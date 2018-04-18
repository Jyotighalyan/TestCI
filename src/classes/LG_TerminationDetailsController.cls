/**
 * Used as a controller for LG_TerminationDetails VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-625
 * @since  24/04/2017
 */
public with sharing class LG_TerminationDetailsController {

	public cscfga__Product_Basket__c basket {get; set;}
	public List<cscrm__Address__c> premises {get; set;}
	public Map<Id, String> premiseWishDate {get; set;}
	public String premiseIdToWishDates {get; set;}
	public Date minTerminationDate {get; set;}
	public Map<Id, List<csord__Service__c>> premiseToServices {get; set;}
	private Id basketId;
	private Id returnId;
	public Set<Id> terminatedSubs {get; set;}
	private Set<Id> terminatedServicesIds {get; set;}

	public LG_TerminationDetailsController() {
		basketId = ApexPages.currentPage().getParameters().get('basketId');
		returnId = ApexPages.currentPage().getParameters().get('returnId');

		premises = new List<cscrm__Address__c>();

		if (String.isBlank(returnId)) {
			returnId = basketId;
		}

		if (basketId != null) {
			basket = [SELECT Id, csordtelcoa__Change_Type__c, Name,
					  csbb__Account__r.Name, csbb__Account__r.Id
					  FROM cscfga__Product_Basket__c
					  WHERE Id = :basketId];

			loadData();
		}

		minTerminationDate = getTerminationDate();
	}

	// formats the date in the dd-mm-yyyy format
	private String getFormattedDate(Date value)
	{
		String formattedDate = '';

		if (value != null) {
			formattedDate = value.day() + '-' + value.month() + '-' + value.year();
		}

		return formattedDate;
	}

	//Calculates the minimum termination date: today() + min lead time (working days).
	private Date getTerminationDate()
	{
		Date minInstallDate = Date.today();

		//first check if today is a weekend, if so
		//set the minInstallDate first to Monday...
		DateTime dtMinDate = (DateTime) minInstallDate;
		String dayOfWeek   = dtMinDate.format('EEE');

		if  (dayOfWeek.equals('Sat')) {
			minInstallDate = minInstallDate.addDays(2);
		} else if (dayOfWeek.equals('Sun')) {
			minInstallDate = minInstallDate.addDays(1);
		}

		Integer minLeadTime = Integer.valueOf(LG_TerminationSpecificVariables__c.getInstance(UserInfo.getUserId()).LG_MinLeadTime__c);

		//Now that we are sure that start ('today') is
		//a working day - Mon-Fri, add the min lead time
		//and don't take Sat and Sun in calculation
		for (Integer i = 0; i < minLeadTime; i++) {
			minInstallDate = minInstallDate.addDays(1);

			//check if date now falls on weekend (Sat)
			//if so, add 2 days to make it Monday
			dtMinDate = (DateTime) minInstallDate;
			dayOfWeek = dtMinDate.format('EEE');

			if  (dayOfWeek.equals('Sat')) {
				minInstallDate = minInstallDate.addDays(2);
			}
		}

		return minInstallDate;
	}

	/**
	 * Updates the Product Configuration with Termination Details
	 *
	 * @author Tomislav Blazek
	 * @ticket SFOM-625
	 * @since  24/04/2017
	 */
	public PageReference save()
	{
		saveWishDateOnJunctionObject();

		recalculatePenalityFees();

		return redirectToReturnId();
	}

	private void recalculatePenalityFees(){
		LG_PenaltyFeeCalculation calculator = LG_PenaltyFeeCalculation.getCalcInstance();
		if (calculator != null) {
			calculator.calculateCreatePenaltyFee(basketId, terminatedServicesIds);
		}
	}

	/**
	 * Saves the wish date on the subscription_macdBasket junction object
	 * for the related records (based on the subscription address and the product configuration
	 * address)
	 *
	 * @author Tomislav Blazek
	 * @ticket SFOM-401
	 * @since  31/5/2017
	 */
	private void saveWishDateOnJunctionObject()
	{
		Map<Id, Date> premiseIdToWishDate = new Map<Id, Date>();

		for (String premiseDate : premiseIdToWishDates.split('#')) {
			if (String.isNotBlank(premiseDate)) {
				Id premiseId  = premiseDate.split('~')[0];
				Date wishDate = null;

				if (premiseDate.split('~').size() > 1) {
					String wishDateStr = premiseDate.split('~')[1];
					//date is in dd-mm-yyyy format so we should create a new instance properly formatted
					wishDate = Date.newInstance(Integer.valueOf(wishDateStr.split('-')[2]),
												Integer.valueOf(wishDateStr.split('-')[1]),
												Integer.valueOf(wishDateStr.split('-')[0]));
				}
				premiseIdToWishDate.put(premiseId, wishDate);
			}
		}

		Map<Id, csordtelcoa__Subscr_MACDProductBasket_Association__c> junctionsToUpdate
			= new Map<Id, csordtelcoa__Subscr_MACDProductBasket_Association__c>();

		for (csordtelcoa__Subscr_MACDProductBasket_Association__c junction : [SELECT csordtelcoa__Subscription__r.LG_Address__c,
																			  LG_DeactivationWishDate__c, csordtelcoa__Subscription__c
																			  FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
																			  WHERE csordtelcoa__Product_Basket__c = :basketId
																													 AND csordtelcoa__Subscription__c IN :terminatedSubs]) {
			if (premiseIdToWishDate.containsKey(junction.csordtelcoa__Subscription__r.LG_Address__c)) {
				junction.LG_DeactivationWishDate__c = premiseIdToWishDate.get(junction.csordtelcoa__Subscription__r.LG_Address__c);
				junctionsToUpdate.put(junction.Id, junction);
			}
		}

		if (!junctionsToUpdate.isEmpty()) {
			update junctionsToUpdate.values();
		}
	}

	//loads the data from the junction object. Services that are being terminated are services not linked
	//to the configurations in the macd basket
	private void loadData(){
		Set<Id> clonedServices = new Set<Id>();
		for (cscfga__Product_Configuration__c prodConfs : [SELECT Id, csordtelcoa__Replaced_Service__c
														   FROM cscfga__Product_Configuration__c
														   WHERE cscfga__Product_Basket__c = :basketId]) {
			clonedServices.add(prodConfs.csordtelcoa__Replaced_Service__c);
		}

		Map<Id, Date> subToWishDate = new Map<Id, Date>();
		for (csordtelcoa__Subscr_MACDProductBasket_Association__c junc : [SELECT csordtelcoa__Subscription__c, LG_DeactivationWishDate__c
																		  FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
																		  WHERE csordtelcoa__Product_Basket__c = :basketId]) {
			subToWishDate.put(junc.csordtelcoa__Subscription__c, junc.LG_DeactivationWishDate__c);
		}

		premiseWishDate       = new Map<Id, String>();
		premiseToServices     = new Map<Id, List<csord__Service__c>>();
		terminatedSubs        = new Set<Id>();
		terminatedServicesIds = new Set<Id>();

		for (csord__Subscription__c sub : [SELECT Id, (SELECT Id, LG_Address__c, Name,
													   csord__Subscription__c
													   FROM csord__Services__r
													   WHERE csord__Service__c = null)
										   FROM csord__Subscription__c
										   WHERE Id IN :subToWishDate.keySet()]) {
			for (csord__Service__c service : sub.csord__Services__r) {
				if (!clonedServices.contains(service.Id) || basket.csordtelcoa__Change_Type__c == 'Move') {
					premiseWishDate.put(service.LG_Address__c, getFormattedDate(subToWishDate.get(service.csord__Subscription__c)));
					terminatedSubs.add(service.csord__Subscription__c);
					if (!premiseToServices.containsKey(service.LG_Address__c)) {
						premiseToServices.put(service.LG_Address__c, new List<csord__Service__c>());
					}
					premiseToServices.get(service.LG_Address__c).add(service);
					terminatedServicesIds.add(service.Id);
				}
			}
		}

		premises =  [SELECT Id, LG_FullAddressDetails__c
					 FROM cscrm__Address__c
					 WHERE Id IN :premiseToServices.keySet()
					 ORDER BY LG_FullAddressDetails__c];
	}

//back to return Id
	public PageReference redirectToReturnId() {
		PageReference newocp = new PageReference(LG_Util.getSalesforceBaseUrl() + '/' + returnId);
		return newocp;
	}
}
/**
 * Abstract class used for the Penalty fee calculation.
 * Abstract class was used so that we can fetch the appropriate
 * class by the name from the Custom settings (related to the users country)
 *
 * @author Tomislav Blazek
 * @ticket SFDT-1298
 * @since  12/07/2016
*/
public abstract class LG_PenaltyFeeCalculation {

	public Integer numberOfDaysTolerated {get; set;}
	public static LG_TerminationSpecificVariables__c termSpecifics = LG_TerminationSpecificVariables__c.getInstance(UserInfo.getUserId());

	public abstract Map<Id, Decimal> calculatePenaltyFees(List<csord__Service__c> services, Id basketId, Map<Id, Date> subToWishdate);

	public LG_PenaltyFeeCalculation() {
		numberOfDaysTolerated = 0;

		if (termSpecifics != null && termSpecifics.LG_NumberOfToleratedDays__c != null) {
			numberOfDaysTolerated = Integer.valueOf(termSpecifics.LG_NumberOfToleratedDays__c);
		}
	}

	//Based on the custom settings related to the loggedin user, returns a valid class instance.
	public static LG_PenaltyFeeCalculation getCalcInstance() {
		LG_PenaltyFeeCalculation calculator = null;

		if (termSpecifics != null && String.isNotBlank(termSpecifics.LG_PenaltyFeeCalculationClass__c)) {
			Type appropriateCalcClass = Type.forName(termSpecifics.LG_PenaltyFeeCalculationClass__c);
			calculator = (LG_PenaltyFeeCalculation) appropriateCalcClass.newInstance();
		}
		return calculator;
	}

	public void calculateCreatePenaltyFee(Id basketId, Set<Id> serviceIds) {

		deleteExistingPenaltyFees(basketId);

		//holds the map of wishdates from the junction object
		Map<Id, Date> subToWishdate      = new Map<Id, Date>();
		List<csord__Service__c> services = new List<csord__Service__c>();

		for (csordtelcoa__Subscr_MACDProductBasket_Association__c junction : [SELECT LG_DeactivationWishDate__c, csordtelcoa__Subscription__r.LG_Address__c
                                                                		        FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
                                                                		        WHERE csordtelcoa__Product_Basket__c = :basketId
                                                                		                AND LG_DeactivationWishDate__c != null]) {
			subToWishdate.put(junction.csordtelcoa__Subscription__c, junction.LG_DeactivationWishDate__c);
		}

		if (!serviceIds.isEmpty() && !subToWishdate.isEmpty()) {
			services = [SELECT Id, LG_Address__c, LG_ContractEndDate__c, csord__Subscription__c FROM csord__Service__c WHERE Id IN :serviceIds];
		}

		if (!services.isEmpty()) {
			Map<Id, Decimal> sliPenaltyFees = calculatePenaltyFees(services, basketId, subToWishdate);

			createPenaltyFeeRecords(sliPenaltyFees, basketId, subToWishdate);
		}
	}

	//deletes the existing PC and PCR records that need to be recalculated
	public void deleteExistingPenaltyFees(Id basketId) {

		List<cscfga__Product_Configuration__c> penaltyFeesToDelete = [SELECT Id, (SELECT Id FROM csbb__Product_Configuration_Requests__r)
                                                        		        FROM cscfga__Product_Configuration__c
                                                        		        WHERE cscfga__Product_Basket__c = :basketId
                                                        		                AND cscfga__Product_Definition__r.LG_ProductSubtype__c = 'Penalty Fee'];

		if (!penaltyFeesToDelete.isEmpty()) {

			List<csbb__Product_Configuration_Request__c> prodReqToDelete = new List<csbb__Product_Configuration_Request__c>();

			for (cscfga__Product_Configuration__c prodConf : penaltyFeesToDelete) {
				prodReqToDelete.addAll(prodConf.csbb__Product_Configuration_Requests__r);
			}

			delete prodReqToDelete;
			delete penaltyFeesToDelete;
		}
	}

	/**
	 * Implement the overwrite penalty fees method
	 *
	 * @author Petar Miletic
	 * @story SFDT-1188, SFDT-1309
	 * @since  13/07/2016
	 */
	public void overwritePenaltyFees(Decimal overridenTotal, Id opportunityId) {

		cscfga__Product_Basket__c basket = [SELECT Id, Name, cscfga__Opportunity__c, cscfga__Opportunity__r.LG_CalculatedPenaltyFee__c
		                                    FROM cscfga__Product_Basket__c
		                                    WHERE cscfga__Opportunity__c = :opportunityId AND csordtelcoa__Synchronised_with_Opportunity__c = true LIMIT 1];


		if (basket != null) {

			// Impossible to calculate if null or zero
			if (basket.cscfga__Opportunity__r.LG_CalculatedPenaltyFee__c == null || basket.cscfga__Opportunity__r.LG_CalculatedPenaltyFee__c == 0) {
				return;
			}

			// // There is no need for recalculation, totals are the same
			// if (overridenTotal == basket.cscfga__Opportunity__r.LG_CalculatedPenaltyFee__c) {
			//     return;
			// }

			// Calculate difference multiplier
			decimal difference = ((overridenTotal * 100) / basket.cscfga__Opportunity__r.LG_CalculatedPenaltyFee__c) - 100;

			List<cscfga__Product_Configuration__c> pcs = [SELECT Id, Name, cscfga__Product_Basket__c, cscfga__Total_Price__c,
					                                       cscfga__total_one_off_charge__c, cscfga__Unit_Price__c,
					                                       (SELECT Name, cscfga__Price__c, cscfga__Value__c
					                                        FROM cscfga__Attributes__r
					                                        WHERE Name IN ('Calculated Price', 'Overridden Price'))
					                                       FROM cscfga__Product_Configuration__c
					                                       WHERE cscfga__Product_Basket__c = :basket.Id
					                                               AND cscfga__Product_Definition__r.LG_ProductSubtype__c = 'Penalty Fee'];

			List<cscfga__Attribute__c> atts = new List<cscfga__Attribute__c>();

			for (cscfga__Product_Configuration__c pc : pcs) {
				cscfga__Attribute__c calcAtt = null;
				cscfga__Attribute__c overAtt = null;

				for (cscfga__Attribute__c a : pc.cscfga__Attributes__r) {
					if (a.Name == 'Calculated Price') {
						calcAtt = a;
					} else if (a.Name == 'Overridden Price') {
						overAtt = a;
					}
				}

				Decimal calcPrice = IsNull(calcAtt.cscfga__Price__c);

				// Calculate values
				overAtt.cscfga__Price__c = calcPrice + ((calcPrice * difference).divide(100, 2));
				overAtt.cscfga__Value__c = String.valueOf(overAtt.cscfga__Price__c);
				atts.add(overAtt);

				pc.cscfga__total_one_off_charge__c = overAtt.cscfga__Price__c;
				pc.cscfga__Total_Price__c          = overAtt.cscfga__Price__c;
				pc.cscfga__Unit_Price__c           = overAtt.cscfga__Price__c;
			}

			update atts;
			update pcs;
		}
	}

	private void createPenaltyFeeRecords(Map<Id, Decimal> sliPrice, Id basketId, Map<Id, Date> subToWishdate) {
		cscfga__Product_Definition__c prodDef = [SELECT Id, Name, cscfga__Product_Category__c,
		                              (SELECT Id, Name FROM cscfga__Attribute_Definitions__r)
		                              FROM cscfga__Product_Definition__c WHERE LG_ProductSubtype__c = 'Penalty Fee'];

		cscfga__Product_Basket__c basket = [SELECT Id, LG_BasketNumber__c FROM cscfga__Product_Basket__c WHERE Id = :basketId];

		List<csord__Service_Line_Item__c> serviceLineItems =  [SELECT Id, Name, csord__Total_Price__c,
		                                  csord__Line_Number__c,
		                                  csord__Service__c,
		                                  csord__Service__r.LG_Address__c,
		                                  csord__Service__r.LG_Address__r.LG_FullAddressDetails__c,
		                                  csord__Service__r.LG_Site__c,
		                                  csord__Service__r.LG_Address__r.LG_PremiseNumber__c,
		                                  csord__Service__r.csord__Subscription__c,
		                                  csord__Service__r.LG_ContractEndDate__c,
		                                  csord__Service__r.csord__Subscription__r.Id,
		                                  csord__Service__r.csord__Subscription__r.LG_Contract__r.LG_DWHExternalID__c
		                                  FROM csord__Service_Line_Item__c
		                                  WHERE ID IN :sliPrice.keySet()
		                                  AND LG_Commitment__c = 'Yes'
		                                          AND csord__Is_Recurring__c = true];

		Map<Integer, List<cscfga__Attribute__c>> attributeListMap  = new Map<Integer, List<cscfga__Attribute__c>>();
		Map<Integer, cscfga__Product_Configuration__c> prodConfMap = new Map<Integer, cscfga__Product_Configuration__c>();
		Integer prodCounter = 0;

		for (csord__Service_Line_Item__c sli : serviceLineItems) {
			Date terminationWishDate = subToWishdate.get(sli.csord__Service__r.csord__Subscription__c);

			cscfga__Product_Configuration__c prodConf = new cscfga__Product_Configuration__c();
			prodConf.cscfga__Product_Basket__c       = basket.Id;
			prodConf.LG_ChangeType__c                = 'Terminate';
			prodConf.Name                            = 'Penalty Fee for ' + sli.Name;
			prodConf.cscfga__total_one_off_charge__c = sliPrice.get(sli.Id);
			prodConf.cscfga__Description__c          = 'Penalty Fee for ' + sli.Name;
			prodConf.cscfga__Total_Price__c          = sliPrice.get(sli.Id);
			prodConf.cscfga__Unit_Price__c           = sliPrice.get(sli.Id);
			prodConf.LG_Address__c                   = sli.csord__Service__r.LG_Address__c;
			prodConf.cscfga__Product_Definition__c   = prodDef.Id;
			prodConf.cscfga__Product_Family__c       = prodDef.Name;
			prodCounter++;

			List<cscfga__Attribute__c> atts = new List<cscfga__Attribute__c>();

			for (cscfga__Attribute_Definition__c attDef : prodDef.cscfga__Attribute_Definitions__r) {
				cscfga__Attribute__c att = new cscfga__Attribute__c();
				att.Name                            = attDef.Name;
				att.cscfga__Attribute_Definition__c = attDef.Id;

				if (attDef.Name == 'Product Name') {
					att.cscfga__Value__c = 'Penalty Fee for ' + sli.Name;
				} else if  (attDef.Name == 'Premise Id') {
					att.cscfga__Value__c = sli.csord__Service__r.LG_Address__c;
				} else if  (attDef.Name == 'Site Id') {
					att.cscfga__Value__c = sli.csord__Service__r.LG_Site__c;
				} else if  (attDef.Name == 'Premise Number') {
					att.cscfga__Value__c = sli.csord__Service__r.LG_Address__r.LG_PremiseNumber__c;
				} else if  (attDef.Name == 'Basket Number') {
					att.cscfga__Value__c = basket.LG_BasketNumber__c;
				} else if  (attDef.Name == 'Order Number') {
					att.cscfga__Value__c = basket.LG_BasketNumber__c
					                       + sli.csord__Service__r.LG_Address__r.LG_PremiseNumber__c;
				} else if  (attDef.Name == 'Description') {
					att.cscfga__Value__c = sli.Name + ', Contract: ' + sli.csord__Service__r.csord__Subscription__r.LG_Contract__r.LG_DWHExternalID__c
					                       + ', Locatie: ' + sli.csord__Service__r.LG_Address__r.LG_FullAddressDetails__c
					                       + ', Afkoopsom periode ' + LG_Util.getFormattedDate(terminationWishDate)
					                       + ' t/m ' + LG_Util.getFormattedDate(sli.csord__Service__r.LG_ContractEndDate__c);
				} else if  (attDef.Name == 'Calculated Price') {
					att.cscfga__Value__c = String.valueOf(sliPrice.get(sli.Id));
					att.cscfga__Price__c = sliPrice.get(sli.Id);
				} else if  (attDef.Name == 'Overridden Price') {
					att.cscfga__Value__c                 = String.valueOf(sliPrice.get(sli.Id));
					att.cscfga__Price__c                 = sliPrice.get(sli.Id);
					att.cscfga__Is_Line_Item__c          = true;
					att.cscfga__Line_Item_Description__c = 'Penalty Fee for ' + sli.Name;
				} else if  (attDef.Name == 'Terminated Service Id') {
					att.cscfga__Value__c = sli.csord__Service__c;
				} else if  (attDef.Name == 'Terminated Service Line Item Id') {
					att.cscfga__Value__c = sli.Id;
				}

				atts.add(att);
			}

			attributeListMap.put(prodCounter, atts);
			prodConfMap.put(prodCounter, prodConf);
		}

		insert prodConfMap.values();

		for (Integer prodCount : prodConfMap.keySet()) {
			for (cscfga__Attribute__c att : attributeListMap.get(prodCount)) {
				att.cscfga__Product_Configuration__c = prodConfMap.get(prodCount).Id;
			}
		}

		List<cscfga__Attribute__c> attToInsert = new List<cscfga__Attribute__c>();
		for (List<cscfga__Attribute__c> attList : attributeListMap.values()) {
			attToInsert.addAll(attList);
		}

		insert attToInsert;

		List<csbb__Product_Configuration_Request__c> prodReqsToInsert = new List<csbb__Product_Configuration_Request__c>();
		for (cscfga__Product_Configuration__c prodConf : prodConfMap.values()) {
			prodReqsToInsert.add(new csbb__Product_Configuration_Request__c(csbb__Total_OC__c = prodConf.cscfga__Total_Price__c,
			                     csbb__Product_Basket__c = prodConf.cscfga__Product_Basket__c,
			                     csbb__Product_Configuration__c = prodConf.Id,
			                     csbb__Product_Category__c = prodDef.cscfga__Product_Category__c));
		}
		insert prodReqsToInsert;
	}

	private decimal IsNull(decimal num) {

		if (num == null) {
			num = 0;
		}

		return num;
	}

	public virtual void calculateChangePenaltyFee(Id basketId) {

	    throw new LG_Exception(Label.LG_NotImplemented);
	}
}
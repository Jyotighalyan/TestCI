/**
 * Used as a controller for LG_NumberManagement VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-106
 * @since  12/12/2016
 */
global with sharing class LG_NumberManagementController {

	public List<NumberRangeWrapper> numberRangeList {get; set;}
	public Id recordId {get; set;}
	public String caseRecordTypeName {get; set;}
	public Id solnId {get; set;}
	public Boolean basketContext {get; set;}
	public Boolean pageReadOnly {get; set;}
	public Boolean validationsRequiredForNew {get; set;}
	public Boolean validationsRequiredForPortIn {get; set;}
	public String numberLengthValidationMsg {get; set;}
	public LG_NumberManagementSettings__c numberMngSettings {get; set;}

	//fetches the portin details fields - fields dependent on the profile/custom settings
	public List<Schema.FieldSetMember> getPortInDetailsFields()
	{
		Schema.FieldSet portInDetailsFieldSet = Schema.SObjectType.Asset.fieldSets.getMap().get(numberMngSettings.LG_PortInDetailsFieldSet__c);
		return portInDetailsFieldSet != null ? portInDetailsFieldSet.getFields() : new List<Schema.FieldSetMember>();
	}

	//fetches the numbers new details fields - fields dependent on the profile/custom settings
	public List<Schema.FieldSetMember> getNewDetailsFields()
	{
		Schema.FieldSet newDetailsFieldSet = Schema.SObjectType.Asset.fieldSets.getMap().get(numberMngSettings.LG_NewDetailsFieldSet__c);
		return newDetailsFieldSet != null ? newDetailsFieldSet.getFields() : new List<Schema.FieldSetMember>();
	}

	public LG_NumberManagementController() {
		recordId      = ApexPages.currentPage().getParameters().get('id');
		basketContext = false;
		if (String.isNotBlank(recordId)) {
			if (Schema.cscfga__Product_Basket__c.SObjectType == recordId.getSObjectType()) {
				basketContext = true;
			} else if (Schema.Case.SObjectType == recordId.getSObjectType()) {
				Case caseRec = [SELECT Id, RecordType.Name, LG_Solution__r.csord__Order__c, LG_Solution__c FROM Case WHERE Id = :recordId];
				//SFOM-621,
				this.caseRecordTypeName = caseRec.RecordType.Name;
				this.solnId             = caseRec.LG_Solution__c;
				if (caseRec.RecordType.Name == 'Inflight Change') {
					recordId = caseRec.LG_Solution__c;
				} else
				{
					recordId = caseRec.LG_Solution__r.csord__Order__c;
				}
				//page should be rendered as readonly
				if (caseRec.RecordType.Name == 'Activate Service' || caseRec.RecordType.Name == 'Install' || caseRec.RecordType.Name == 'Provision') {
					pageReadOnly = true;
				}
			} else {
				recordId = null;
			}
		}
		numberMngSettings            = LG_NumberManagementSettings__c.getInstance(UserInfo.getUserId());
		validationsRequiredForNew    = numberMngSettings.LG_RequireDetailsForNew__c || !basketContext;
		validationsRequiredForPortIn = numberMngSettings.LG_RequireDetailsForPortIn__c || !basketContext;
		numberLengthValidationMsg    = numberMngSettings.LG_MinNumberLength__c == numberMngSettings.LG_MaxNumberLength__c
									   ? Label.LG_NmbrManagementMinNmbr.replace('{minNumberLength}', String.valueOf(Integer.valueOf(numberMngSettings.LG_MaxNumberLength__c)))
									   : Label.LG_NmbrManagementMinMaxNmbr.replace('{minNumberLength}', String.valueOf(Integer.valueOf(numberMngSettings.LG_MinNumberLength__c)))
									   .replace('{maxNumberLength}', String.valueOf(Integer.valueOf(numberMngSettings.LG_MaxNumberLength__c)));

		populateNmbrRangeListFromAssets();
	}

	public List<SelectOption> getPortInOperators()
	{
		List<SelectOption> portInOperators = new List<SelectOption>();
		portInOperators.add(new SelectOption('', Label.LG_Select));

		for (String portInOperator : LG_Util.commaSeparatedStringToSet(numberMngSettings.LG_PortInOperators__c)) {
			portInOperators.add(new SelectOption(portInOperator, portInOperator));

		}
		return portInOperators;
	}

	/**
	 * Updates the Number Block Asset records with the details, and updated the
	 * related phone number asset records if there was a change in the number.
	 *
	 * @author Tomislav Blazek
	 * @ticket SFOM-106
	 * @since  14/12/2016
	 */
	public void save()
	{
		Map<NumberRangeWrapper, Asset> numberRangeToNumberBlock = new Map<NumberRangeWrapper, Asset>();
		Set<Id> asseIds                                         = new Set<Id>();
		boolean donorOnly          = false;
		boolean updateOrchestrator = false;

		for (NumberRangeWrapper nw : numberRangeList) {
			nw.numberBlockAsset.Name = nw.numberBlockAsset.LG_NumberRange__c;
			numberRangeToNumberBlock.put(nw, nw.numberBlockAsset);
			asseIds.add(nw.numberBlockAsset.Id);
		}

		//SFOM-621 track type of change before updating the asset
		if (caseRecordTypeName == 'Manage Numbers') {
			donorOnly          = isDonorOnlyChange(asseIds);
			updateOrchestrator = true;

		}

		update numberRangeToNumberBlock.values();

		//update existing phone number records with valid numbers (for existing number block assets)
		updateExistingPhoneNumbers(numberRangeToNumberBlock.keySet());

		//SFOM-621
		if (updateOrchestrator) {

			updateInflightNumberProcess(solnId, donorOnly);
		}
	}

	private void updateExistingPhoneNumbers(Set<NumberRangeWrapper> numberRangeList)
	{
		List<Asset> numbersToUpsert = new List<Asset>();
		Set<Id> numberBlockIds      = new Set<Id>();
		for (NumberRangeWrapper nw : numberRangeList) {
			numberBlockIds.add(nw.numberBlockAsset.Id);
		}

		List<Asset> phoneNumbers = [SELECT Id, Name, LG_Asset__c, LG_PhoneNumber__c
									FROM Asset
									WHERE LG_Asset__c IN :numberBlockIds];

		Map<Id, List<Asset>> nmbrBlockToNumbers = new Map<Id, List<Asset>>();
		for (Asset numberAsset : phoneNumbers) {
			if (!nmbrBlockToNumbers.containsKey(numberAsset.LG_Asset__c)) {
				nmbrBlockToNumbers.put(numberAsset.LG_Asset__c, new List<Asset>());
			}
			nmbrBlockToNumbers.get(numberAsset.LG_Asset__c).add(numberAsset);
		}

		for (NumberRangeWrapper nw : numberRangeList) {
			List<String> numbers;
			Integer blockSize = Integer.valueOf(nw.numberBlockAsset.LG_NumberRangeSize__c);

			//start number not changed, so skip the update of phone numbers
			if (String.isNotBlank(nw.numberBlockAsset.LG_StartNumber__c) && String.isBlank(nw.numbers)) {
				continue;
			}
			//start number changed
			if (String.isNotBlank(nw.numberBlockAsset.LG_StartNumber__c)) {
				numbers = (List<String>)JSON.deserialize(nw.numbers, List<String>.class);
			}
			List<Asset> numberAssets = nmbrBlockToNumbers.get(nw.numberBlockAsset.Id);
			for (Integer i = 0; i < blockSize; i++) {
				Asset phoneNumber = numberAssets[i];
				phoneNumber.Name              = numbers != null ? numbers[i] : 'Not Defined';
				phoneNumber.LG_PhoneNumber__c = numbers != null ? numbers[i] : 'Not Defined';
				numbersToUpsert.add(phoneNumber);
			}
		}

		update numbersToUpsert;
	}

	private void populateNmbrRangeListFromAssets(){
		numberRangeList = new List<NumberRangeWrapper>();

		if (recordId != null) {
			String blocksMainQuery = 'Id, LG_NumberRangeType__c, LG_NumberRangeSize__c,'
									 + 'LG_StartNumber__c, LG_EndNumber__c, LG_NumberRange__c,'
									 + 'LG_TelephonyProductConfiguration__c, '
									 + 'LG_TelephonyProductConfiguration__r.Name, '
									 + 'LG_TelephonyProductConfiguration__r.LG_Address__c, '
									 + 'LG_TelephonyProductConfiguration__r.LG_Features__c, '
									 + 'LG_TelephonyProductConfiguration__r.LG_Address__r.LG_FullAddressDetails__c, '
									 + 'LG_TelephonyProductConfiguration__r.LG_Address__r.cscrm__Zip_Postal_Code__c '
									 + 'FROM Asset WHERE RecordType.Name = \'Number Block\' '
									 + 'AND LG_SoftDeleted__c = false '
									 + 'AND (LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = :recordId '
									 + '     OR LG_TelephonyService__r.LG_RootOrder__c = :recordId '
									 + '     OR LG_TelephonyService__r.LG_Suborder__c = :recordId) '
									 + 'ORDER BY LG_TelephonyProductConfiguration__r.LG_Address__r.LG_FullAddressDetails__c,'
									 + ' LG_TelephonyProductConfiguration__r.Name, LG_StartNumber__c';

			String existingBlocksQuery = 'SELECT ';
			for (Schema.FieldSetMember f : getPortInDetailsFields()) {
				if (!blocksMainQuery.contains(f.getFieldPath()) && !existingBlocksQuery.contains(f.getFieldPath())) {
					existingBlocksQuery += f.getFieldPath() + ', ';
				}
			}
			for (Schema.FieldSetMember f : getNewDetailsFields()) {
				if (!blocksMainQuery.contains(f.getFieldPath()) && !existingBlocksQuery.contains(f.getFieldPath())) {
					existingBlocksQuery += f.getFieldPath() + ', ';
				}
			}

			existingBlocksQuery += blocksMainQuery;

			List<Asset> existingBlocks = Database.query(existingBlocksQuery);
			for (Asset numberBlock : existingBlocks) {
				numberRangeList.add(new NumberRangeWrapper(numberBlock, numberRangeList));
			}
		}
	}

	public class NumberRangeWrapper
	{
		public Asset numberBlockAsset {get; set;}
		public String addressDesc {get; set;}
		public String addressKey {get; set;}
		public String addressTooltip {get; set;}
		public Integer index {get; set;}
		public String numbers {get; set;}

		public NumberRangeWrapper(Asset asset, List<NumberRangeWrapper> numberRangeList) {
			this.numberBlockAsset = asset;
			this.index            = numberRangeList.size();
			this.addressKey       = asset.LG_TelephonyProductConfiguration__r.LG_Address__c + ', ' + asset.LG_TelephonyProductConfiguration__c;
			this.addressTooltip   = asset.LG_TelephonyProductConfiguration__r.LG_Address__r.LG_FullAddressDetails__c + ', '
									+ asset.LG_TelephonyProductConfiguration__r.Name + ', ' + asset.LG_TelephonyProductConfiguration__r.LG_Features__c;
			this.addressDesc = asset.LG_TelephonyProductConfiguration__r.Name + ', ' + asset.LG_TelephonyProductConfiguration__r.LG_Address__r.cscrm__Zip_Postal_Code__c;
			if (this.index != 0 && numberRangeList[this.index - 1].addressKey == this.addressKey) {
				this.addressDesc = null;
			}
		}
	}

	/**
	 * Track changes for donor only or other changes
	 *
	 * @param  Set<Id> asseIds Asset Ids
	 * @retrun boolean
	 * @author Minhaj Alam
	 * @ticket SFOM-621
	 * @since  24/04/2017
	 */
	public boolean isDonorOnlyChange(Set<Id> asseIds)
	{
		List<string> donorDetailsNew      = new List<string>();
		List<string> donorDetailsOldAsset = new List<string>();
		List<string> otherDetailsNew      = new List<string>();
		List<string> otherDetailsOldAsset = new List<string>();
		Map<Id, Asset> assetsMap          = new Map<Id, Asset>();
		boolean donorOnlyChange = false;

		//Fetch the old asset values which are candidate for change
		List<Asset> assets = [SELECT Id, LG_StartNumber__c, LG_EndNumber__c, LG_PortInWishDate__c, LG_PortInOperator__c, LG_PortInName__c, LG_PortInZipcode__c FROM Asset WHERE Id IN :asseIds];

		for (Asset record: assets) {
			assetsMap.put(record.Id, record);

		}

		for (NumberRangeWrapper nw : numberRangeList) {

			//identify donor only and other changes from new asset values
			String OtherChange = nw.numberBlockAsset.LG_StartNumber__c + nw.numberBlockAsset.LG_EndNumber__c + nw.numberBlockAsset.LG_PortInWishDate__c + nw.numberBlockAsset.LG_PortInOperator__c;
			otherDetailsNew.add(OtherChange.toLowerCase());
			String donor = nw.numberBlockAsset.LG_PortInName__c + nw.numberBlockAsset.LG_PortInZipcode__c;
			donorDetailsNew.add(donor.toLowerCase());

			//identify donor only and other changes from old asset values
			Asset OldAsset             = assetsMap.get(nw.numberBlockAsset.Id);
			String OtherChangeOldAsset = OldAsset.LG_StartNumber__c + OldAsset.LG_EndNumber__c + OldAsset.LG_PortInWishDate__c + OldAsset.LG_PortInOperator__c;
			otherDetailsOldAsset.add( OtherChangeOldAsset.toLowerCase());
			String donorOldAsset = OldAsset.LG_PortInName__c + OldAsset.LG_PortInZipcode__c;
			donorDetailsOldAsset.add(donorOldAsset.toLowerCase());

		}

		//if other changes are same but donor information is changed
		if (otherDetailsOldAsset.equals(otherDetailsNew) && !donorDetailsOldAsset.equals(donorDetailsNew)) {
			donorOnlyChange = true;
		}

		return donorOnlyChange;
	}


	/**
	 * update orchestrator driving variables for manage numbers case
	 *
	 * @param  Id solnId Solution ID
	 * @param  boolean donorOnly  donor only change or other change
	 * @author Minhaj Alam
	 * @ticket SFOM-621
	 * @since  24/04/2017
	 */
	Public Void updateInflightNumberProcess(Id solnId, boolean donorOnly)
	{
		List<CSPOFA__Orchestration_Process__c> processIds = new List <CSPOFA__Orchestration_Process__c>();
		List<CSPOFA__Orchestration_Step__c> processSteps  = new List<CSPOFA__Orchestration_Step__c>();
		List<csord__Solution__c> solnlist                 = new List<csord__Solution__c>();
		List<csord__Solution__c> solnListToUpdate         = new List<csord__Solution__c>();

		//Get the list of orchestration process ids and process ids for the solution
        solnList     = [SELECT id, LG_TargetDate__c, LG_Jeopardy__c, LG_EarliestInstallDate__c, LG_EarliestPortingWishDate__c,LG_LatestPortingWishDate__c, LG_AnyNumbersToPort__c, LG_InflightChange__c, LG_RetryInstall__c, LG_RetryNumberPort__c from csord__Solution__c WHERE id = :solnId];
		processIds   = [SELECT id, Name, LG_Solution__c, CSPOFA__Orchestration_Process_Template__c, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c where LG_Solution__c = :solnId];
		processSteps = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c,CSPOFA__Orchestration_Process__c,CSPOFA__Orchestration_Process__r.LG_Solution__r.id FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c in :processIds and CSPOFA__Step_Order__c <100];

		Integer potentialGotoSeq;
		csord__Solution__c soln;


		if (!solnList.isEmpty()) {
			soln             = solnList[0];
            //SFOM-737
            //Get the orchestration process associated to a solution
            CSPOFA__Orchestration_Process__c pro = new CSPOFA__Orchestration_Process__c ();
            for (CSPOFA__Orchestration_Process__c orch : processIds){
                if(orch.LG_Solution__c== soln.id){
                    pro = orch;
                    break;
                }
            }
            //SFOM-737
            //Get the custom setting defined for a process
            LG_InflightChangeStep__c csSetting = new   LG_InflightChangeStep__c (); 
            List<LG_InflightChangeStep__c> inflightSettingList = LG_InflightChangeStep__c.getall().values();        
            for (LG_InflightChangeStep__c cs :inflightSettingList ){
                if(cs.LG_OrchestrationProcess__c == pro.CSPOFA__Orchestration_Process_Template__c){
                    csSetting = cs;
                    break;
                }
            }
            
            potentialGotoSeq = csSetting.LG_RetryProvision__c.intvalue();
			if (donorOnly) {
                potentialGotoSeq = csSetting.LG_RetryNumberPort__c.intvalue();
			}

			CSPOFA__Orchestration_Step__c inProgressProcessStep = inProgressProcessStep(processSteps, soln.id);
            if (soln.LG_Jeopardy__c != True) {
			if (inProgressProcessStep.CSPOFA__Step_Order__c >= potentialGotoSeq ) {

                    if (potentialGotoSeq == csSetting.LG_RetryNumberPort__c.intvalue()) {
					soln.LG_RetryNumberPort__c = True;
				} else {
					soln.LG_RetryProvision__c = True;
				}
					soln.LG_InflightChange__c = True;
				}
            }
            //SFOM-737
            else if (soln.LG_Jeopardy__c == True) {
                if (inProgressProcessStep.CSPOFA__Step_Order__c >= potentialGotoSeq ) {

                    if (inProgressProcessStep.CSPOFA__Step_Order__c  == csSetting.LG_NumberPortLoop__c.intvalue()) {
                        soln.LG_RetryNumberPort__c = True;
                    } else if (inProgressProcessStep.CSPOFA__Step_Order__c  == csSetting.LG_ProvisionLoop__c.intvalue()) {
                        soln.LG_RetryProvision__c = True;
                    }
                }
            }
				update soln;
			}

		}


	//Method to compute the inporgress orchestration process step
	Private static CSPOFA__Orchestration_Step__c inProgressProcessStep (List<CSPOFA__Orchestration_Step__c> inProgressProcessStep, Id solnId)
	{
		CSPOFA__Orchestration_Step__c pro = new CSPOFA__Orchestration_Step__c();
		for (CSPOFA__Orchestration_Step__c processStep : inProgressProcessStep) {
			if (processstep.CSPOFA__Orchestration_Process__r.LG_Solution__c== solnId  && (processstep.CSPOFA__Status__c == 'In Progress'  || processstep.CSPOFA__Status__c == 'Waiting For Feedback')) {
				pro = processStep;
				break;
			}
		}
		return pro;
	}
}
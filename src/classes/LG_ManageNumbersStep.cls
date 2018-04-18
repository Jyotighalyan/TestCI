/**
 * Used as a custom orchestator step.
 * Scans all the Number Block Asset records related
 * to the solution being processed.
 * Stamps the 'Numbers Incomplete' flag on the solution,
 * so that further conditions in the process can use it.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-339
 * @since  7/2/2017
 */
global class LG_ManageNumbersStep implements CSPOFA.ExecutionHandler {

  private Set<String> requiredFieldsForNew;
  private Set<String> requiredFieldsForPortIn;

  public List<sObject> process(List<SObject> data)
  {
    List<sObject> result = new List<sObject>();
    //collect the data for all steps passed in, if needed
    //process steps
    List<CSPOFA__Orchestration_Step__c> stepList =
      (List<CSPOFA__Orchestration_Step__c>)data;

    Set<Id> processesIds = new Set<Id>();
    for (CSPOFA__Orchestration_Step__c step : stepList) {
      processesIds.add(step.CSPOFA__Orchestration_Process__c);
    }

    checkNumberBlockAssets(processesIds);

    for (CSPOFA__Orchestration_Step__c step : stepList) {
      //mark step Status, Completed Date
      step.CSPOFA__Status__c         = 'Complete';
      step.CSPOFA__Completed_Date__c = Date.today();
      result.add(step);
    }

    return result;
  }

  /**
   * Scans the Number Block Assets related to the processes/solutions being
   * executed/processed and checks whether all the required fields on the asset
   * records are populated.
   * If that's not the case, flag 'Numbers Incomplete' on the related solution will
   * be set to true.
   *
   * @param  Set<Id> processesIds
   * @author Tomislav Blazek
   * @ticket SFOM-339
   * @since  7/2/2017
   */
  @TestVisible
  private void checkNumberBlockAssets(Set<Id> processesIds)
  {
    Set<Id> solutionsIds = new Set<Id>();
    for (CSPOFA__Orchestration_Process__c process : [SELECT LG_Solution__c
                             FROM CSPOFA__Orchestration_Process__c
                             WHERE Id IN :processesIds
                             AND LG_Solution__c != null]) {
      solutionsIds.add(process.LG_Solution__c);
    }

    Map<Id, csord__Solution__c> solutionsToUpdate = new Map<Id, csord__Solution__c>();

    List<Asset> relatedNumberBlocks = fetchNumberBlocks(solutionsIds);

    for (Asset numberBlock : relatedNumberBlocks) {
      if (String.isBlank(numberBlock.LG_StartNumber__c) || checkRequiredFields(numberBlock)) {
        solutionsToUpdate.put(numberBlock.LG_TelephonyService__r.LG_Suborder__c,
                    new csord__Solution__c(Id = numberBlock.LG_TelephonyService__r.LG_Suborder__c,
                               LG_NumbersIncomplete__c = true));
      }
    }

    if (!solutionsToUpdate.isEmpty()) {
      update solutionsToUpdate.values();
    }
  }

  private List<Asset> fetchNumberBlocks(Set<Id> solutionIds)
  {
    requiredFieldsForNew = new Set<String>();
    requiredFieldsForNew.add('LG_StartNumber__c');
    requiredFieldsForPortIn = new Set<String>();
    requiredFieldsForPortIn.add('LG_StartNumber__c');

    LG_NumberManagementSettings__c nmbrMngSettings = LG_NumberManagementSettings__c.getInstance(UserInfo.getUserId());

    String blocksMainQuery = 'Id,Name, LG_TelephonyService__r.LG_Suborder__c, LG_NumberRangeType__c, LG_StartNumber__c '
                 + 'FROM Asset WHERE RecordType.Name = \'Number Block\' '
                 + 'AND LG_TelephonyService__r.LG_Suborder__c IN :solutionIds ';

    String existingBlocksQuery = 'SELECT ';

    for (Schema.FieldSetMember f : getPortInDetailsFields(nmbrMngSettings)) {
      if (f.required || f.dbrequired) {
        requiredFieldsForPortIn.add(f.getFieldPath());

        if (!blocksMainQuery.contains(f.getFieldPath()) && !existingBlocksQuery.contains(f.getFieldPath())) {
          existingBlocksQuery += f.getFieldPath() + ', ';
        }
      }
    }

    for (Schema.FieldSetMember f : getNewDetailsFields(nmbrMngSettings)) {
      if (f.required || f.dbrequired) {
        requiredFieldsForNew.add(f.getFieldPath());

        if (!blocksMainQuery.contains(f.getFieldPath()) && !existingBlocksQuery.contains(f.getFieldPath())) {
          existingBlocksQuery += f.getFieldPath() + ', ';
        }
      }
    }
    existingBlocksQuery += blocksMainQuery;

    return Database.query(existingBlocksQuery);
  }

  private Boolean checkRequiredFields(Asset asset)
  {
    Boolean fieldsIncomplete = false;

    Set<String> requiredFields = asset.LG_NumberRangeType__c == 'New' ? requiredFieldsForNew : requiredFieldsForPortIn;
    for (String fieldName : requiredFields) {
      if (String.isBlank(String.valueOf(asset.get(fieldName)))) {

        fieldsIncomplete = true;
      }
    }
    return fieldsIncomplete;
  }

  //fetches the portin details fields - fields dependent on the profile/custom settings
  private List<Schema.FieldSetMember> getPortInDetailsFields(LG_NumberManagementSettings__c numberMngSettings)
  {
    Schema.FieldSet portInDetailsFieldSet = Schema.SObjectType.Asset.fieldSets.getMap().get(numberMngSettings.LG_PortInDetailsFieldSet__c);
    return portInDetailsFieldSet != null ? portInDetailsFieldSet.getFields() : new List<Schema.FieldSetMember>();
  }

  //fetches the numbers new details fields - fields dependent on the profile/custom settings
  private List<Schema.FieldSetMember> getNewDetailsFields(LG_NumberManagementSettings__c numberMngSettings)
  {
    Schema.FieldSet newDetailsFieldSet = Schema.SObjectType.Asset.fieldSets.getMap().get(numberMngSettings.LG_NewDetailsFieldSet__c);
    return newDetailsFieldSet != null ? newDetailsFieldSet.getFields() : new List<Schema.FieldSetMember>();
  }
}
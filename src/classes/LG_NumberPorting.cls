/**
 * Number porting class. Encapsulates several method for handling porting data
 *
 * @author Petar Miletic
 * @ticket SFOM-194 & SFOM-194
 * @since  12 & 19/12/2016
 */
public class LG_NumberPorting {

  /**
   * Creates the Porting Process records for Port-In Assets.
   * And releates the newly related records to the Assets through
   * Asset Process Association Records.
   * Assets are 'grouped' to Processes based on the Portin wish dates and
   * senquentiality of the numbers.
   *
   * @param  List<Id> serviceIds
   * @author Tomislav Blazek
   * @ticket SFOM-250
   * @since  11/1/2017
   */
  public static void createPortInProcessRecords(List<Id> serviceIds)
  {
      // Get assets but filter out the ones that already  have association
    List<Asset> numberAssets = [SELECT Id, AccountId,
                                            RecordType.Name, LG_PortInWishDate__c, LG_Asset__c,
                          LG_TelephonyService__r.LG_Suborder__c, LG_StartNumber__c, LG_EndNumber__c
                          FROM Asset
                          WHERE LG_TelephonyService__c IN :serviceIds
                          AND LG_NumberRangeType__c = 'Portin'
                          AND Id NOT IN (SELECT LG_Asset__c
                                                FROM LG_AssetProcessAssociation__c
                                                WHERE LG_Asset__r.LG_TelephonyService__c IN :serviceIds)
                                            ORDER BY LG_StartNumber__c];

    	system.debug('----numberAssets--' +numberAssets);
      Id portinRecType = Schema.SObjectType.LG_PortingProcess__c.getRecordTypeInfosByName().get('Port-In').getRecordTypeId();
		system.debug('----portinRecType--' +portinRecType);
      Map<Id, List<Asset>> solutionAssets = new Map<Id, List<Asset>>();
      for (Asset asset : numberAssets) {
        if (!solutionAssets.containsKey(asset.LG_TelephonyService__r.LG_Suborder__c)) {
          solutionAssets.put(asset.LG_TelephonyService__r.LG_Suborder__c, new List<Asset>());
        }
        solutionAssets.get(asset.LG_TelephonyService__r.LG_Suborder__c).add(asset);
      }
      Map<List<Asset>, LG_PortingProcess__c> assetsToProcess = new Map<List<Asset>, LG_PortingProcess__c>();
      List<List<Asset>> listOfAssetsList                     = new List<List<Asset>>();
      for (Id solutionId : solutionAssets.keySet()) {
        Date wishDate      = null;
        Long lastNumber = null;
        List<Asset> lastList = null;
        for (Asset asset : solutionAssets.get(solutionId)) {
          if (asset.RecordType.Name != 'Number Block') {
            continue;
          }

          if (wishDate != asset.LG_PortInWishDate__c
              //if numbers are in continuous range, they should fall into the same process unless portin wishdate
              //is different
            || lastNumber == null || Long.valueOf(asset.LG_StartNumber__c) != lastNumber + 1) {
            lastList = new List<Asset>{asset};
            listOfAssetsList.add(lastList);
          } else {
            lastList.add(asset);
          }
          wishDate   = asset.LG_PortInWishDate__c;
          lastNumber = Long.valueOf(asset.LG_EndNumber__c);
          //add all phone number assets
          for (Asset phoneNumber : numberAssets) {
            if (phoneNumber.LG_Asset__c == asset.Id && phoneNumber.RecordType.Name == 'Phone Number') {
              lastList.add(phoneNumber);
            }
          }
        
      }

      for (List<Asset> assetList : listOfAssetsList) {
        assetsToProcess.put(assetList, new LG_PortingProcess__c(RecordTypeId = portinRecType, LG_Account__c = assetList[0].AccountId));
      }

      insert assetsToProcess.values();

      List<LG_AssetProcessAssociation__c> assetProcessInsert = new List<LG_AssetProcessAssociation__c>();

      for (List<Asset> assetList : assetsToProcess.keySet()) {
        LG_PortingProcess__c process = assetsToProcess.get(assetList);
        for (Asset asset : assetList) {
          assetProcessInsert.add(new LG_AssetProcessAssociation__c(LG_Asset__c = asset.Id, LG_Process__c = process.Id));
        }
      }
      Set<Id> procesi = new Set<Id>();
      for (LG_AssetProcessAssociation__c obj :assetProcessInsert) {

        procesi.add(obj.LG_Process__c);
      }

      insert assetProcessInsert;
    }
  }

  /**
   * Check if there are any number to port
   *
   * @param  Set<Id> processesIds
   * @author Petar Miletic
   * @ticket SFOM-193
   * @since  03/02/2017
   */
  private static Boolean validateProcessResponse(List<LG_AssetProcessAssociation__c> assets) {

    // Find out if there is any request that is not marked as Success
    Set<Id> processIds   = new Set<Id>();
    Set<String> statuses = new Set<String>();

    Set<Id> processToReqIds = new Set<Id>();

    // Ger Process Ids
    for (LG_AssetProcessAssociation__c obj :assets) {
      processIds.add(obj.LG_Process__c);
    }

    // Get requests by processIds
    List<LG_ProcessRequest__c> reqs = [SELECT Id,
                       LG_Process__c,
                       LG_Response__c
                       FROM LG_ProcessRequest__c
                       WHERE LG_Process__c IN :processIds
                       ORDER BY LG_Process__c, CreatedDate DESC];

    // Detect Rejected ones
    for (LG_AssetProcessAssociation__c obj :assets) {

      for (LG_ProcessRequest__c req :reqs) {

        // Add process Id
        processToReqIds.add(req.LG_Process__c);

        // Get only the latest request for process ID
        if (obj.LG_Process__c == req.LG_Process__c) {

          statuses.add(req.LG_Response__c);
          break;
        }
      }

      // Stop looping if there is at least one that requires porting
      if (statuses.contains('Rejected')) {
        break;
      }
    }

    // Every process must have at least one request and that request must be successful
    return !statuses.contains('Rejected') && processIds.size() == processToReqIds.size();
  }

  // Update solutions. Set LG_AnyNumbersToPort__c to false
  private void setNoPorting(Set<Id> solutionIds) {

    List<csord__Solution__c> solutions = [SELECT Id, LG_AnyNumbersToPort__c FROM csord__Solution__c WHERE Id IN :solutionIds];

    for (csord__Solution__c sol :solutions) {
      sol.LG_AnyNumbersToPort__c = false;
    }

    if (!solutions.isEmpty()) {
      update solutions;
    }
  }

  /**
   * Check if there are any number to port
   *
   * Scans all numbers under this Solution. If there are any numbers that
   * still require porting, set the Any Numbers to Port to True and also update the
   * Earliest and Latest porting dates if needed.
   *
   * For test coverage run: LG_AnalyseNumberPortingTest
   *
   * @param  Set<Id> processesIds
   * @author Petar Miletic
   * @ticket SFOM-193, replaces (SFOM-190, SFOM-194)
   * @since  03/02/2017
   */
  @TestVisible
  public void checkNumberPorting(Set<Id> processesIds) {

    Set<Id> solutionIds = new Set<Id>();

    // Get all solution Ids associated with the processes
    for (CSPOFA__Orchestration_Process__c process : [SELECT Id, LG_Solution__c
                             FROM CSPOFA__Orchestration_Process__c
                             WHERE Id IN :processesIds AND LG_Solution__c != null]) {
      solutionIds.add(process.LG_Solution__c);
    }

    Set<Id> serviceIds = new Set<Id>();

    // Get all Service Ids associated with the processes
    for (csord__Service__c service : [SELECT Id
                      FROM csord__Service__c
                      WHERE LG_Suborder__c IN :solutionIds]) {
      serviceIds.add(service.Id);
    }

    createPortInProcessRecords(new List<Id>(serviceIds));

    List<LG_AssetProcessAssociation__c> assets = [SELECT Id,
                            Name,
                            LG_Asset__c,
                            LG_Asset__r.Name,
                            LG_Asset__r.LG_NumberRangeType__c,
                            LG_Asset__r.LG_PortInWishDate__c,
                            LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c,
                            LG_Asset__r.LG_TelephonyService__r.LG_Suborder__r.Id,
                            LG_Asset__r.LG_TelephonyService__r.LG_Suborder__r.LG_AnyNumbersToPort__c,
                            LG_Asset__r.LG_TelephonyService__r.LG_Suborder__r.LG_EarliestPortingWishDate__c,
                            LG_Asset__r.LG_TelephonyService__r.LG_Suborder__r.LG_LatestPortingWishDate__c,
                            LG_Process__c,
                            LG_Process__r.LG_ChangeIndicator__c,
                            LG_Process__r.LG_PortInWishDate__c
                            FROM LG_AssetProcessAssociation__c
                            WHERE LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c IN :solutionIds AND
                            LG_Asset__r.RecordType.Name = 'Number Block' AND
                                          LG_Asset__r.LG_NumberRangeType__c = 'Portin'];

    // If there are no assets or all where ported successfully
    if (assets.isEmpty() || validateProcessResponse(assets)) {

      setNoPorting(solutionIds);
      return;
    }

    List<Asset> objs = new List<Asset>();

    for (LG_AssetProcessAssociation__c obj :assets) {

      objs.add(obj.LG_Asset__r);
    }

    checkNumberPorting(objs);
  }

  /**
   * Scans Service assets in order to detect porting number range type
   *
   * @param  Set<Id> processesIds
   * @author Petar Miletic
   * @ticket SFOM-190
   * @since  12/12/2016
   */
  @TestVisible
  private void checkNumberPorting(List<Asset> assets) {

    Map<Id, csord__Solution__c> solutions = new Map<Id, csord__Solution__c>();

    // Retrieve all active porting assets by service Ids
    for (Asset obj : assets) {

      // Get solution
      csord__Solution__c sol = new csord__Solution__c();
      sol = obj.LG_TelephonyService__r.LG_Suborder__r;

      if (sol == null) {

        continue;
      }

      sol.LG_AnyNumbersToPort__c = true;

      // Set porting wish date (earliest and latest)
      if (obj.LG_NumberRangeType__c == 'Portin' && obj.LG_PortInWishDate__c != null) {


        // Check earliest porting wish date
        if (sol.LG_EarliestPortingWishDate__c == null || sol.LG_EarliestPortingWishDate__c > obj.LG_PortInWishDate__c) {
          sol.LG_EarliestPortingWishDate__c = obj.LG_PortInWishDate__c;
        }

        // Check latest porting wish date
        if (sol.LG_LatestPortingWishDate__c == null || sol.LG_LatestPortingWishDate__c < obj.LG_PortInWishDate__c) {
          sol.LG_LatestPortingWishDate__c = obj.LG_PortInWishDate__c;
        }
      }

      solutions.put(sol.Id, sol);
    }

    // If not empty update values
    if (!solutions.values().isEmpty()) {

      update solutions.values();
    }
  }
}
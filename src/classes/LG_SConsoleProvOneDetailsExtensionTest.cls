public class LG_SConsoleProvOneDetailsExtensionTest{

     Public Asset assetBdsToUpdate{get;set;}
     Public Asset assetBds{get;set;}
     Public csord__Service__c bdsService{get;set;}
     Public List<csord__Service__c> listOfBds{get;set;}
     public List<asset> assetList{get;set;}
     public List<cscfga__Attribute__c> attributes{get;set;}
     public List<String> ListOfFields{get;set;}
     public List<String> ListOfAttRecords{get;set;}
   
     
    @TestVisible
    private final Case cs { get; set; }

    
    public csord__Solution__c solutionObject { get; set; }

    public String caseRecordType { get; set; }
    public boolean caseClosed {get;set;}
   // @TestVisible
   // public List<ProvisioningDetails> provisioningDetails { get; set; }
        
         //Get Service records    
     //Get Service records    
    ApexPages.StandardController stdController;
    
    LG_SConsoleProvisionOneDetailsExtension lgsc = new LG_SConsoleProvisionOneDetailsExtension(stdController);
    List<csord__Service__c> csord_ServiceRecords = lgsc.getServiceRecords();
    
    //solObject = lgsc.getSolutionRecord();
     PageReference pr = lgsc.Save();
     PageReference prEdit = lgsc.Edit();
     PageReference prCancel = lgsc.Cancel();
     PageReference prPage = lgsc.PageRefresh();
    String address = lgsc.FrameAddressInFormat('25', 'Jerus', 'New York','USA', '712345');
     
     Asset ast = lgsc.getBDSServiceAsset();
     //csord__Solution__c solutionObject = lgsc.getSolutionRecord();
    // lgsc.getAssetRecord();
   LG_SConsoleProvisionOneDetailsExtension.ProvisioningDetails provDetails = new LG_SConsoleProvisionOneDetailsExtension.ProvisioningDetails('Provision One Step',bdsService);
   
   //lgsc.provisioningDetails = provDetails.getProvisioningDetails();
   
    public csord__Solution__c getSolution() {
        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }



  private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        List<csord__Solution__c> solutionList = new List<csord__Solution__c>();
         List<csord__Solution__c> solutionList1 = new List<csord__Solution__c>();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solutionList = [SELECT LG_Address__r.cscrm__State_Province__c,LG_Address__r.LG_TechnicalContact__r.Phone,Id, LG_OneStepCase_Provisioning_Account_No__c,Name, LG_Address__c, csord__Account__c, csord__Order__c,
                   csord__Status__c, LG_Jeopardy__c, csordtelcoa__Product_Configuration__c, LG_JeopardyExplanation__c,
                   LG_ProvisioningWorkOrder__c,LG_ProvisioningAccountNo__c, LG_TargetDate__c, LG_EarliestInstallDate__c,
                   CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c, Jeopardy_Reason__c,
                   csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c, csord__Order__r.csord__Account__c,
                   LG_Address__r.cscrm__Country__c, LG_Address__r.LG_TechnicalContact__c,LG_Address__r.LG_FullAddressDetails__c,LG_Address__r.LG_Icomms_Premise_ID__c, LG_Address__r.LG_Icomms_Site_ID__c,
                   csord__Order__r.csord__Account__r.LG_Huawei_Tenant_ID__c
                   FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        }

        if(solutionList.size() > 0){
            solution = solutionList[0];
            //Removed as a part of SFOM-1748
            /*if (solution.LG_Jeopardy__c == true) {
                this.jeopardy = true;
            }*/
        }else {
            solution = new csord__Solution__c();
        }
                return solution;
    }
}
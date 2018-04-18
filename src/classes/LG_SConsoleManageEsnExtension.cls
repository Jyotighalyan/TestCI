public class LG_SConsoleManageEsnExtension {
    public final Case cs { get; set; }
    public List<Asset> assetList {get; set;}
    public csord__Order__c orderObject { get; set; } 
    public Boolean isClosed {get; set;}
    public Boolean isEditMode {get; set;}
    
    public LG_SConsoleManageEsnExtension (ApexPages.StandardController stdController) {
        isEditMode = false;
        List<String> defaultFields = new List<String>();
        if(!Test.isRunningTest())
        {
            stdController.addFields(getFieldList());
        }
        this.cs = (Case)stdController.getRecord();
        orderObject = retriveOrderRecord();
        getAssetList ();     
        if(cs.status == 'Closed'){
            isClosed = true;
        }
            
    }
    
    public List<Asset> getAssetList (){
     orderObject = retriveOrderRecord();

    system.debug('orderObject  =='+orderObject );       

     assetList = [select id ,LG_MACAddress__c,name,csord__service__c from asset where LG_MACAddress__c=null AND csord__Service__c IN
             (select id from csord__service__c where LG_RootOrder__c=:orderObject.id) ];
           
    system.debug('assetList =='+assetList );       
    return assetList;
    }
    
    public csord__Order__c retriveOrderRecord(){
        csord__Order__c order = new csord__Order__c();
        try{
        if(this.cs.LG_Order__c != null){
            order = 
            [
                SELECT Id, Name, Ownerid, csord__Status__c, csord__Account__c, csord__Account__r.Name, csordtelcoa__Opportunity__r.LG_PrimaryContact__c
                FROM csord__Order__c 
                WHERE Id = :this.cs.LG_Order__c
            ];
           }
          
        
          }
       catch(Exception e){
        System.debug('An exception occurred: ' + e.getMessage());
        } 
    return order;  
    }
    
     
    public void updateAssetList(){ 
        if(assetList != null)
            update assetList;
            isEditMode = false;
    }
    
    public void setEditMode(){
        isEditMode = true;
    }
    
    public String getRecordType() {
        return this.cs.RecordType.Name;
    }
    
    public List<String> getFieldList(){
        List<String> defaultFields = new List<String>();
        defaultFields.add('LG_Order__c');
        defaultFields.add('LG_Solution__c');
        defaultFields.add('RecordType.Name');
        defaultFields.add('Status');
        return defaultFields;
    }
    
 
}
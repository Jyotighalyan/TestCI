/**
* Custom SF Service Console
* 
* @author Petar Miletic
* @story SFOM-29
* @since  03/11/2016
*/
public class LG_SConsoleServiceDetailsExtension extends LG_ServiceConsoleBase {

    private final Case cs { get; set; }
    public boolean caseClosed {get;set;}

    private csord__Service__c serviceObject { get; set; }

    public csord__Service__c getService() {
        
        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecord();
        }
        
        return this.serviceObject; 
    }
    
    private List<csord__Service_Line_Item__c> serviceLineItems { get; set; }
    
    public List<csord__Service_Line_Item__c> getServiceLineItems() {
        
        if (this.serviceLineItems == null) {
            this.serviceLineItems = getServiceLineItemRecords();
        }
        
        return this.serviceLineItems; 
    }
    
    private List<csord__Service__c> services { get; set; }
    
    public List<csord__Service__c> getServiceItems() {
        
        if (this.services == null) {
            this.services = getServiceRecords();
        }
        
        return this.services; 
    }

    public LG_SConsoleServiceDetailsExtension (ApexPages.StandardController stdController) {

        List<String> defaultFields = new List<String>();
        
        if(!test.isRunningTest()){
        defaultFields.add('LG_Service__c');
        defaultFields.add('LG_Solution__c');
            defaultFields.add('RecordType.Name');
        defaultFields.add('Status');
        stdController.addFields(defaultFields);
        this.cs = (Case)stdController.getRecord();
        } else
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name, Status, Type from Case LIMIT 1];
		if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        } else {
            edit();
        }
    }

    private csord__Service__c getServiceRecord() {
        csord__Service__c obj = [SELECT Id, Name, csord__Status__c, LastModifiedById, LastModifiedDate, CreatedById, CreatedDate FROM csord__Service__c WHERE Id = :this.cs.LG_Service__c]; 

        if (obj == null) {
            obj = new csord__Service__c();
        }

        return obj;
    }
   
    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    private List<csord__Service__c> getServiceRecords() {
        
        // List<csord__Service_Line_Item__c> objs = [SELECT Id, Name, csord__Start_Date__c, csord__End_Date__c FROM csord__Service_Line_Item__c WHERE csord__Service__c = :this.cs.LG_Service__c];
        List<csord__Service__c> objs = new List<csord__Service__c>();
        if(this.cs.LG_Solution__c != Null)
            objs = [SELECT Id, Name, LG_ServiceExternalId__c, csord__Status__c,csordtelcoa__Delta_Status__c FROM csord__Service__c WHERE LG_Suborder__C = :this.cs.LG_Solution__c];
        
        return objs;
    }
    
    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    private List<csord__Service_Line_Item__c> getServiceLineItemRecords() {
        
        // List<csord__Service_Line_Item__c> objs = [SELECT Id, Name, csord__Start_Date__c, csord__End_Date__c FROM csord__Service_Line_Item__c WHERE csord__Service__c = :this.cs.LG_Service__c];
        
        List<csord__Service_Line_Item__c> objs = new List<csord__Service_Line_Item__c>();
        if(this.cs.LG_Solution__c != Null)
	       	objs = [SELECT Id, Name, csord__Start_Date__c, csord__End_Date__c,csordtelcoa__Delta_Status__c FROM csord__Service_Line_Item__c WHERE csord__Service__r.LG_Suborder__C = :this.cs.LG_Solution__c];

        return objs;
    }
    
    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    /*
     * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }
    
    public PageReference save() {

        update this.serviceObject;

        setMode(DisplayMode.detail);
        return null;
    }
    
    public PageReference cancel() {

        setMode(DisplayMode.detail);
        return null;
    }
}
/**
* Custom SF Service Console
*
* @author Petar Miletic
* @story SFOM-29
* @since  03/11/2016
*/
public class LG_SConsoleSolutionDetailsExtension extends LG_ServiceConsoleBase {

    private final Case cs { get; set; }
    public boolean caseClosed {get;set;}
    public boolean assignOrder {get;set;}

    private csord__Solution__c solutionObject { get; set; }

    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    private list<csord__Solution__c> solutionList { get; set; }

    public list<csord__Solution__c> getSolutionList() {

         if(this.cs.LG_order__c != NULL){
            this.solutionList = getSolutionRecords();
        }

        return this.solutionList;
    }

    private csord__Order__c orderObject { get; set; }

    public csord__Order__c getOrder() {

        if (this.orderObject == null) {
            this.orderObject = getOrderRecord();
        }

        return this.orderObject;
    }

    public LG_SConsoleSolutionDetailsExtension(ApexPages.StandardController stdController) {

        List<String> defaultFields = new List<String>();

        if(!test.isRunningTest()){
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Status');
            defaultFields.add('RecordType.Name');

            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();
        } else
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name, Status, Type from Case LIMIT 1];

		if( (getRecordType() == 'Assign Owner'  || getRecordType() == 'Assign Order Owner' ) && this.cs.Status != 'Closed')
           edit();
        else caseClosed = True;

        assignOrder = False;
        if(this.cs.LG_Solution__c == Null)
           assignOrder = True;
    }

    private csord__Solution__c getSolutionRecord() {
		csord__Solution__c obj = new csord__Solution__c();
        if(this.cs.LG_Solution__c != NULL){
            obj = [SELECT Id, Name, csord__Account__c, csord__Order__c,
                                  csord__Status__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                  LG_ProvisioningWorkOrder__c, LG_TargetDate__c, LG_EarliestInstallDate__c,
                                  CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c
                                  FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        }
        return obj;
    }

    private csord__Order__c getOrderRecord() {
		csord__Order__c obj = new csord__Order__c();
        if(this.cs.LG_Order__c != NULL){
            obj = [SELECT Id, Name, OwnerId,  csord__Account__c, csordtelcoa__Opportunity__c, csordtelcoa__Opportunity__r.owner.name
                                  FROM csord__Order__c WHERE Id = :this.cs.LG_order__c];
        }
        return obj;
    }

    private List<csord__Solution__c> getSolutionRecords() {
		List<csord__Solution__c> obj = new List<csord__Solution__c>();
        if(this.cs.LG_order__c != NULL){
            obj = [SELECT Id, Name, csord__Account__c,
                                  csord__Status__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                  LG_ProvisioningWorkOrder__c, LG_TargetDate__c, LG_EarliestInstallDate__c,
                                  CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c, LG_Address__r.LG_FullAddressDetails__c
                                  FROM csord__Solution__c WHERE csord__Order__c = :this.cs.LG_Order__c];
        }

        return obj;
    }

    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    public Boolean getProvisoning() {
        return this.cs.RecordType.Name == 'Provision';
    }

    /*
     * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }

    public PageReference save() {

        if(this.cs.LG_Solution__c !=null)
            update this.solutionObject;
		else if (this.cs.LG_Order__c!= null)
            update this.orderObject;

        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference cancel() {

        setMode(DisplayMode.detail);
        return null;
    }
}
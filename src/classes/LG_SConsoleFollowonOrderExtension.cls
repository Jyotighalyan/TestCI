public class LG_SConsoleFollowonOrderExtension {
/**
* Custom Extension controller for Contact Customer Case record type
*
* @author Ganesh Subbiah
* @story SFOM-390
* @since  04/02/2017
*/
    private final Case cs { get; set; }

    private csord__Order__c orderObject { get; set; }
    public csord__Order__c getOrder() {
        if (this.orderObject == null) {
            this.orderObject = getOrderRecord();
        }
        return this.orderObject;
    }

	@TestVisible
	private List<csord__Solution__c> solutionObject { get; set; }
    public List<csord__Solution__c> getSolution() {
		if (this.solutionObject == null) {
			this.solutionObject = getSolutionRecord();
		}
		return this.solutionObject;
	}

    public LG_SConsoleFollowonOrderExtension (ApexPages.StandardController stdController) {
        List<String> defaultFields = new List<String>();
        if(!Test.isRunningTest())
        {
            defaultFields.add('LG_Order__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('RecordType.Name');
        	stdController.addFields(defaultFields);
        }
        this.cs = (Case)stdController.getRecord();
    }

    private csord__Order__c getOrderRecord() {
        csord__Order__c orderObj = new csord__Order__c();
        if (this.cs.LG_Order__c == null) {
            return new csord__Order__c();
        }
        List<csord__Order__c> orderList = [SELECT Id, Name, OwnerId,csord__Order_Type__c, csord__Status2__c,csord__Account__c,csordtelcoa__Opportunity__c  FROM csord__Order__c WHERE Id = :this.cs.LG_Order__c];
		if(!orderList.isEmpty())
        {
            orderObj = orderList[0];
        }
        return orderObj;
    }

	private List<csord__Solution__c> getSolutionRecord() {
		List<csord__Solution__c> solutions = new List<csord__Solution__c>();
		if (this.cs.LG_Order__c != null) {
			solutions = [SELECT Id, Name, Ownerid, csord__Status__c, LG_Jeopardy__c, LG_JeopardyRaisedBy__c, Jeopardy_Reason__c, LG_OrderCancelled__c, LG_OrderChanged__c, LG_ProvisioningWorkOrder__c, LG_Address__c FROM csord__Solution__c WHERE csord__Order__c = :this.cs.LG_Order__c];
		}

		return solutions;
	}
	public String getRecordType() {
        return this.cs.RecordType.Name;
    }
}
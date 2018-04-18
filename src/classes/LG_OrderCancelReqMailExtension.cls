public class LG_OrderCancelReqMailExtension {
	
    public Id orderId {get;set;}
    public List<csord__Solution__c> getRelatedProdList(){
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        if (orderId != null) {
            solutions = [SELECT Id, Name FROM csord__Solution__c WHERE csord__Order__c = :orderId];
        }

        return solutions;
    }
    
    public String getOrderName(){
        csord__Order__c order;
        if (orderId != null) {
            order = [SELECT Id, Name FROM csord__Order__c WHERE Id = :orderId LIMIT 1];
        }

        return order.Name;
    }
}
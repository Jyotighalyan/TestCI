public class UM_VWProcessRecords implements Queueable {
    
    private List<UM_VW_Staging_Feed__c> scope;
    
    public UM_VWProcessRecords(List<UM_VW_Staging_Feed__c> scope){
        this.scope=scope;
    }
    
    public void execute(QueueableContext context) {     
        UM_VWStagingFeedUtil vwsFeed=new UM_VWStagingFeedUtil();
        vwsFeed.segregateStagingData(scope);
    }
}
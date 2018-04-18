/**
    @ClassName    : UM_DeactivateBillingAcc_Schedule 
    @CreatedOn    : 18/Dec/2017
    @Description  : This is the Scheduler class for scheduling the Batch UM_DeactivateBillingAccBatch (BU-234)
**/

public class UM_DeactivateBA_Schedule implements Schedulable{

    /**
        @MethodName : execute
        @param      : SchedulableContext SC
        @Description: This method schedules the respective batch class based on given cron expression
    **/
    public void execute (SchedulableContext SC){    
    UM_DeactivateBA_Batch batch = new UM_DeactivateBA_Batch ();
    Database.executeBatch(batch,1);
    }
}
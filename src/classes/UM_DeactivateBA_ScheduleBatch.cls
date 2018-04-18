/**
    @ClassName    : UM_DeactivateBA_ScheduleBatch 
    @CreatedOn    : 18/Dec/2017 
    @Description  : This class will schedule the batch "UM_DeactivateBA_Batch" to run at 00:00:00 every day.
*/

public class UM_DeactivateBA_ScheduleBatch {

    /*
        @ MethodName : UM_DeactivateBA_ScheduleBatch(Constructor)
        @ Param      : None
        @ Description: This constructor schedules the class "UM_DeactivateBA_Schedule", which in turn fires the batch "UM_DeactivateBA_Batch"
    */
    public UM_DeactivateBA_ScheduleBatch(){
    
    UM_DeactivateBA_Schedule batchSchedule = new UM_DeactivateBA_Schedule();
    String cronExp = '0 0 0 ? * * *';
    System.schedule ('DeactivateBA',cronExp,batchSchedule);
    }
}
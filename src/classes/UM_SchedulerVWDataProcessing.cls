/*
    This scheduler is used to process only that data which is set to process later.
*/
global class UM_SchedulerVWDataProcessing Implements Schedulable{
    global void execute(SchedulableContext SC){
        // process termination as well as pending data
        UM_VWStagingFeedUtil.InvokeBatchProcessStagingData(null);
    }
}
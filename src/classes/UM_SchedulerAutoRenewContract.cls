global class UM_SchedulerAutoRenewContract Implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
        UM_BatchAutoRenewContract scheduleAutoRenewContract=new UM_BatchAutoRenewContract();
        Database.executeBatch(scheduleAutoRenewContract);
    }
}
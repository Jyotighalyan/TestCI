global class UM_ScheduleUpdateServiceStatus implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    UM_UpdateServiceStatusBatch b = new UM_UpdateServiceStatusBatch(); 
      database.executeBatch(b, 200);
    }
}
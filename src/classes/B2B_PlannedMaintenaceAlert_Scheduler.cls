/************************************************************************************************************************************
*        Class: B2B_PlannedMaintenaceAlert_Scheduler 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will schedule the batch class which sends email to contacts.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017 
*  Test Class : LG_Care_PlannedMaintenanceAlert_Sch_Test 
*************************************************************************************************************************************/
global with sharing class B2B_PlannedMaintenaceAlert_Scheduler implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        LG_Care_PlannedMaintenanceAlert_Batch plannedAlert = new LG_Care_PlannedMaintenanceAlert_Batch(); 
        Id batchId = Database.executeBatch(plannedAlert,1);
   }
   
}
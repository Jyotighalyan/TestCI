/************************************************************************************************************************************
*        Class: LG_Care_MedalliaRelationshipSurvey_sch 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will schedule the batch class which gonna ask medallia to survey the contacts.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 21-DEC-2017 
*  Test Class : LG_Care_MedalliaRelationship_schTest
*************************************************************************************************************************************/

global class LG_Care_MedalliaRelationshipSurvey_sch implements Schedulable{
   
   global void execute(SchedulableContext SC) {
        LG_Care_MedalliaRelationshipSurvey_Batch mSurvey = new LG_Care_MedalliaRelationshipSurvey_Batch(); 
        Id batchId = Database.executeBatch(mSurvey,1999);// CRQ000000767526 FIx for 18.15 warrany issue
   }
}
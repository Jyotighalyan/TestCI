/************************************************************************************************************************************
*        Class: AccountTrigger
*     Program : B2B SELF CARE PROGRAM
*  Description: Triggers to populate E-Commerce Customer Id field on Account with Account Number field when a new account 
				is inserted
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 10-APR-2018
*   Test Class: LG_B2B_AccountTriggerTest
*************************************************************************************************************************************/

trigger LG_B2B_AccountTrigger on Account (after insert) {
    
    Id accId = [SELECT Id FROM Account WHERE Id IN: Trigger.new].id;
    Account acc=[SElECT LG_AccountNumber__c, csb2c__E_Commerce_Customer_Id__c FROM Account WHERE Id =: accId];
    String value=acc.LG_AccountNumber__c;
    acc.csb2c__E_Commerce_Customer_Id__c = value;
    update acc;

}
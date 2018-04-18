/*********************************************************************************************************
*        Class: AccountTrigger
*     Program : B2B SELF CARE PROGRAM
*  Description: Triggers to populate E-Commerce Customer Id field on Account with Account Number field when a new account 
                is inserted
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 10-APR-2018
*************************************************************************************************************************************/
@isTest
public class LG_B2B_AccountTriggerTest {

    static testMethod void copyAccountField(){
        Account acc = new Account (
        Name = 'newAcc1'
        );
        insert acc;
        if(acc.LG_AccountNumber__c!=null)
            acc.csb2c__E_Commerce_Customer_Id__c = acc.LG_AccountNumber__c;
        update acc;
    }
}
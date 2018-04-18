@isTest
public class UM_CustomerApprovalTiggerTest
{
 
 public static testmethod void  testCustomerApprovalTriggerForApprovedByCustomerAsTrue()
 {
     //User u= UM_CustomerApprovalTiggerTestData.createUser('UM Partner Sales User');
     //insert u;
     //System.runAs(u)
     //{
         CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromOtherCompnany();
         cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
         test.startTest();
         custApproval.CSCAP__Approved_By_Customer__c=true;
         update custApproval;
         test.stopTest();
     //}
 }
   
    public static testmethod void  testCustomerApprovalTriggerForRejectedByCustomerAsTrue()
 {
     //User u= UM_CustomerApprovalTiggerTestData.createUser('UM Partner Sales User');
     //insert u;
     //System.runAs(u)
     //{
         CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromOtherCompnany();
         cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
         test.startTest();
         custApproval.CSCAP__Rejected_By_Customer__c=true;
         update custApproval;
         test.stopTest();
     //}
 }
    
}
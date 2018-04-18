@isTest
public class UM_SendReminderMailControllerTest
{
 
 public static testmethod void  testgetproductConfigurationListFromOtherCompnany()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromOtherCompnany();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_SendReminderMailController sendRem= new UM_SendReminderMailController ();
     sendRem.oppId =custApproval.CSCAP__Opportunity__c;
     test.startTest();
     sendRem.getproductConfigurationList();
     test.stopTest();
     System.assert(sendRem.address.contains(''));
 }
    
 public static testmethod void  testgetproductConfigurationListFromUnitymedia_Hessen_GmbH_Co_KG()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromUnitymedia_Hessen_GmbH_Co_KG();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_SendReminderMailController sendRem= new UM_SendReminderMailController ();
     sendRem.oppId =custApproval.CSCAP__Opportunity__c;
     test.startTest();
     sendRem.getproductConfigurationList();
     test.stopTest();
     System.assert(sendRem.address.contains('Unitymedia Hessen GmbH & Co. KG'));
 }
    
 public static testmethod void  testgetproductConfigurationListFromUnitymedia_BW_GmbH()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromUnitymedia_BW_GmbH();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_SendReminderMailController sendRem= new UM_SendReminderMailController ();
     sendRem.oppId =custApproval.CSCAP__Opportunity__c;
     test.startTest();
     sendRem.getproductConfigurationList();
     test.stopTest();
     System.assert(sendRem.address.contains('Unitymedia BW GmbH'));
 }
 }
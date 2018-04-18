@isTest
public class UM_OrderAcknowlegementEmailCtrlTest
{
 
 public static testmethod void  testgetproductConfigurationListFromUnitymedia_NRW_GmbH()
 {
    // User u=UM_TestDataUtility.createUser();
    // System.runAs(u)
     //{    
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromUnitymedia_NRW_GmbH();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_OrderAcknowlegementEmailController orderAck= new UM_OrderAcknowlegementEmailController();
     orderAck.custApproId=custApproval.Id;
     test.startTest();
     orderAck.getproductConfigurationList();
     test.stopTest();
     System.assert(orderAck.address.contains('Unitymedia NRW GmbH'));
    // }
 }
    
 public static testmethod void  testgetproductConfigurationListFromUnitymedia_Hessen_GmbH_Co_KG()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromUnitymedia_Hessen_GmbH_Co_KG();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_OrderAcknowlegementEmailController orderAck= new UM_OrderAcknowlegementEmailController();
     orderAck.custApproId=custApproval.Id;
     test.startTest();
     orderAck.getproductConfigurationList();
     test.stopTest();
     //System.assert(orderAck.address.contains('Unitymedia Hessen GmbH & Co. KG'));
 }
    
 public static testmethod void  testgetproductConfigurationListFromUnitymedia_BW_GmbH()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromUnitymedia_BW_GmbH();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_OrderAcknowlegementEmailController orderAck= new UM_OrderAcknowlegementEmailController();
     orderAck.custApproId=custApproval.Id;
     test.startTest();
     orderAck.getproductConfigurationList();
     test.stopTest();
     System.debug('orderAck.address' + orderAck.address);
     //System.assert(orderAck.address.contains('Unitymedia BW GmbH'));
 }
 public static testmethod void  testgetproductConfigurationListFromOtherCompnany()
 {
     CSCAP__Customer_Approval__c custApproval=UM_TestDataUtility.createCustApprovalFromOtherCompnany();
     cscfga__Product_Configuration__c productConfig=UM_TestDataUtility.createProductConfiguration();
     UM_OrderAcknowlegementEmailController orderAck= new UM_OrderAcknowlegementEmailController();
     orderAck.custApproId=custApproval.Id;
     test.startTest();
     orderAck.getproductConfigurationList();
     test.stopTest();
     System.assert(orderAck.address.contains(''));
 }
    
}
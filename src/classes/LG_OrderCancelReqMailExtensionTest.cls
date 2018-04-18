/**
 *Test Class for LG_OrderCancelReqMailExtension
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class LG_OrderCancelReqMailExtensionTest {
    public static testmethod void reqmailext(){
          csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
       solution.LG_ActivationNeeded__c=true;
        insert solution;
        test.startTest();
        LG_OrderCancelReqMailExtension mailext=new LG_OrderCancelReqMailExtension();
        mailext.orderId=order.id;
        mailext.getOrderName();
        mailext.getRelatedProdList();
        test.stopTest();
    }

}
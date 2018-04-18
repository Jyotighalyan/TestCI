/**
 *Test Class for LG_ActualBillingAccount
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class LG_ActualBillingAccountTest {
    public static testmethod void billaccnt(){
        test.startTest();
        LG_ActualBillingAccount billav=new LG_ActualBillingAccount();
        billav.getBillingAccountId();
        billav.getProductBasketLineItemsIdsList();
        billav.getSiteAddress();
        billav.getType();
        billav.setBillingAccountId('billingAccountId');
        billav.setSiteAddress('siteAddress');
        billav.setSiteAddress('siteAddress');
        billav.setType('type');
        billav.setProductBasketLineItemsIdsList('eachId');
      
        test.stopTest();
        
    }

}
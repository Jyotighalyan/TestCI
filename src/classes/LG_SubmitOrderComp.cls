/********
Controller class for VF component SubmitOrderComponent****
Author: Alisha **********
****************************************************************/

public class LG_SubmitOrderComp {
    public Id Oppid{get;set;}
    public List<csconta__Billing_Account__c> getbillAccount ()
    {
    List<csconta__Billing_Account__c> billAccount = [SELECT id,LG_PaymentType__c  from csconta__Billing_Account__c where Opportunity__c =:OppId limit 1];
        return billAccount;

    }

     public List<csord__Service__c> getserviceList()
    {
     try{
     csord__Order__c orderId = [SELECT id from csord__Order__c where csordtelcoa__Opportunity__c =:OppId limit 1];
     List<csord__Service__c> serviceList=[SELECT id,name, LG_Address__r.LG_FullAddressDetails__c,LG_Address__r.LG_HouseNumber__c from csord__Service__c where csord__Order__c =:orderId.id];

     return serviceList;
        }
        catch(Exception ex){
        system.debug(ex);
         return null;
        }

    }
}
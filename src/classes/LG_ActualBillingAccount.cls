/* -----------------------------------------------------------------------------------------------------------------------
   Name: LG_ActualBillingAccount.cls 
   Description: This class is a dao class ystem

   Date            Version         Author          Summary of Changes 
-----------  ------- --------------  ----------------------------------------------------------------------------------
   April 2015      1.0             Manmohan        ESSR1B
------------------------------------------------------------------------------------------------------------------------ */
public class LG_ActualBillingAccount {
   Public String billingAccountId = '';
    Public String type = '';
    Public String siteAddress = '';
    Public Set<String> productBasketLineItemsIdsList = new Set<String>();
    
    public string getBillingAccountId(){ return billingAccountId;}
    public void setBillingAccountId(String billingAccountId){this.billingAccountId = billingAccountId;}
    
    public string getType(){ return type;}
    public void setType(String type){this.type = type;}
    
    public string getSiteAddress(){ return siteAddress;}
    public void setSiteAddress(String siteAddress){this.siteAddress = siteAddress;}
    
    public Set<String> getProductBasketLineItemsIdsList(){ return productBasketLineItemsIdsList;}
    public void setProductBasketLineItemsIdsList(String eachId){productBasketLineItemsIdsList.add(eachId);}
}
/************************************************************
* File Name     :  LG_BillingAccountDO is the data object class for LG_BillingAccount
* Description   :  This class is used to count number of billing accounts.

* @author       :  Manmohan Singh | manmohan.singh1@cognizant.com
* Modification Log
=============================================================
* Ver.    Date          Author              Modification
-------------------------------------------------------------
* 1.0     06/05/2016    Manmohan Singh        File Created.
************************************************************/
public class LG_BillingAccountDO {
    Public String siteAddress = '';
    Public String siteId = ''; 
    Public String siteName = '';
    Public String productFamily = '';
    Public String productCategory = '';
    Public Set<String> productBasketLineItemsIdsList = new Set<String>();

    public string getSiteAddress(){ return siteAddress;}
    public void setSiteAddress(String siteAddress){this.siteAddress = siteAddress;}
    
    public string getSiteId(){ return siteId;}
    public void setSiteId(String siteId){this.siteId = siteId;}
    
    public string getSiteName(){ return siteName;}
    public void setSiteName(String siteName){this.siteName = siteName;}
    
    public string getProductFamily(){ return productFamily;}
    public void setProductFamily(String productFamily){this.productFamily = productFamily;}
    
    public string getProductCategory(){ return productCategory;}
    public void setProductCategory(String productCategory){this.productCategory = productCategory;}
    
    public Set<String> getProductBasketLineItemsIdsList(){ return productBasketLineItemsIdsList;}
    public void setProductBasketLineItemsIdsList(String eachId){productBasketLineItemsIdsList.add(eachId);}
}
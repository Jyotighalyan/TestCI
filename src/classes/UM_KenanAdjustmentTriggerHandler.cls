public with sharing class UM_KenanAdjustmentTriggerHandler{
    public static void beforeInsertEventHandler(list<Kenan_Adjustment__c> newAdj){
        Set<String>  invoiceNumberSet=new Set<String>();
        Map<String,id> InvoiceIdInvoiceNumberMap=new Map<String,id>(); 
        for(Kenan_Adjustment__c kenanAdj : newAdj)
        {
            invoiceNumberSet.add(kenanAdj.UM_Original_Invoice_Number__c);
        }
        for(UM_InvoiceHeader__c invoiceHeader : [SELECT id,UM_InvoiceNumber__c FROM UM_InvoiceHeader__c  WHERE UM_InvoiceNumber__c IN : invoiceNumberSet])
        {
            InvoiceIdInvoiceNumberMap.put(invoiceHeader.UM_InvoiceNumber__c,invoiceHeader.id);
        }
        for(Kenan_Adjustment__c adj : newAdj)
            {
                if(adj.UM_Received_from_Billing_System__c==True)
                {
                    if(adj.UM_Original_Invoice_Number__c!=null && (InvoiceIdInvoiceNumberMap.keyset()).contains(adj.UM_Original_Invoice_Number__c) && adj.Invoice_Header__c==null)
                            adj.Invoice_Header__c=InvoiceIdInvoiceNumberMap.get(adj.UM_Original_Invoice_Number__c);
                    if(adj.Total_Amount__c!=null && adj.Total_Amount__c!=0)
                            adj.Total_Amount__c=adj.Total_Amount__c/100;
                    if(adj.UM_Tax__c!=null && adj.UM_Tax__c!=0)
                            adj.UM_Tax__c=adj.UM_Tax__c/100;
                    if(adj.UM_Net_Amount__c!=null && adj.UM_Net_Amount__c!=0)
                            adj.UM_Net_Amount__c=adj.UM_Net_Amount__c/100;
                }
            }
    }
    //added below to support Amount update from Kenan- BHP-22 -15/01/18
    public static void beforeUpdateEventHandler(list<Kenan_Adjustment__c> newAdjList, Map<Id,Kenan_Adjustment__c> oldAdjMap)
    {
         for(Kenan_Adjustment__c adj:newAdjList) 
         {
             if(adj.UM_Received_from_Billing_System__c && adj.Total_Amount__c !=null && adj.Total_Amount__c !=0 && adj.Total_Amount__c != oldAdjMap.get(adj.id).Total_Amount__c)
                 adj.Total_Amount__c = adj.Total_Amount__c/100;
             if(adj.UM_Received_from_Billing_System__c && adj.UM_Tax__c !=null && adj.UM_Tax__c!=0 && adj.UM_Tax__c != oldAdjMap.get(adj.id).UM_Tax__c)
                 adj.UM_Tax__c = adj.UM_Tax__c/100;
             if(adj.UM_Received_from_Billing_System__c && adj.UM_Net_Amount__c !=null && adj.UM_Net_Amount__c!=0 && adj.UM_Net_Amount__c != oldAdjMap.get(adj.id).UM_Net_Amount__c)
                 adj.UM_Net_Amount__c = adj.UM_Net_Amount__c/100;
             
         }  
    }
}
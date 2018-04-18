public class LG_QOSTemplateController
{

    public List<LG_QOS_Template__c> standortqosList = new List<LG_QOS_Template__c>();
    public String standortproductDefName = 'BDS Standort';
    
    
     public List<LG_QOS_Template__c> getStandortqosList(){
     
     
         List<LG_QOS_Template__c> qos =  [select id, Qos_Type__c,Low_Loss_Traffic_MB_Sec__c, Total_Downstream_Bandwidth_MB_Sec__c, Total_Upstream_Bandwidth_MB_Sec__c, Voice_Traffic__c from LG_QOS_Template__c where Product_Definition_Name__c=:standortproductDefName order by Total_Downstream_Bandwidth_MB_Sec__c ];
         
         System.debug('Aswin QOS is:'+qos +' And prodName is:'+standortproductDefName);
         
         return qos;
     }



}
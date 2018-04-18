/**
 * Used as a Observer implementation class for firing the
 * util methods when product configuration are created by 
 * Simple Select, Clone, Advanced Clone
 * @author BDS Dev Team
 * @since  06/12/2017
 */

public class LG_ObserverPcUtil {

    public static void updatePersistentId(cscfga__Product_Configuration__c pC) {
        
       cscfga__Product_Configuration__c p= [Select cscfga__Product_Definition__r.name,cscfga__Product_Basket__r.csordtelcoa__Change_Type__c,(Select Id, Name,cscfga__Value__c from cscfga__Attributes__r where Name='Persistent Id')  from cscfga__Product_Configuration__c where id=:pc.id];   
       system.debug(p.cscfga__Attributes__r);
       List<cscfga__Attribute__c> attr= [Select cscfga__Value__c, Name from cscfga__Attribute__c where Id=:p.cscfga__Attributes__r limit 1]; 
       system.debug(p.cscfga__Product_Definition__r.name);
       system.debug(p.cscfga__Product_Basket__r.csordtelcoa__Change_Type__c);
        If((!attr.isEmpty()) && (p.cscfga__Product_Definition__r.name=='BDS Standort' || p.cscfga__Product_Definition__r.name=='VPN Services')){ 
              pc.LG_Persistent_Id__c= pc.id;
               attr[0].cscfga__Value__c=pc.id;
          update pc;
          update attr;
        }     
    }   
}
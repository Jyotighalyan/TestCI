public class UM_CollectionTriggerHandler{
     
     public static Set<String> collectionIdSet = new Set<String>();
     public static Set<String> billingAccount = new Set<String>();
     public static List<UM_Collection__c> collectionListToInsert = new List<UM_Collection__c>();
     public static List<csconta__Billing_Account__c> billList = new List<csconta__Billing_Account__c>();
     public static Map<Id,UM_Collection__c> mapOfbillingandColl = New Map<Id,UM_Collection__c>();
   
     public static Integer counter = 1;
     
    
       
     public static Set<String> collectionBeforeInsert(List<UM_Collection__c> collectionList){
         
          for(UM_Collection__c collection : collectionList){
                collectionIdSet.add(collection.UM_Collection_ID__c);
                
                if(String.isNotEmpty(collection.UM_Last_Event_Date__c) && (!collection.UM_Last_Event_Date__c.contains(':'))){
                        
                    string year = collection.UM_Last_Event_Date__c.substring(0,4);
                    string month = collection.UM_Last_Event_Date__c.substring(4,6);
                    string day = collection.UM_Last_Event_Date__c.substring(6,8);
                    string hour = collection.UM_Last_Event_Date__c.substring(8,10);
                    string minute = collection.UM_Last_Event_Date__c.substring(10,12);
                    string second = collection.UM_Last_Event_Date__c.substring(12,14);
                   
                    //string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' +minute + ':' + second.remove('');
                    string stringDate = day + '.' + month + '.' + year + ' ' + hour + ':' +minute + ':' + second;
                    collection.UM_Last_Event_Date__c  = stringDate; //myDate.format('dd.MM.yyyy HH:mm:ss');
                    
                }
         }
         
         return collectionIdSet;
         
     }
     

    
        public static void insertCollection(List<UM_Collection__c> collectionList,Set<String> collectionIdSet){
        
       
       
        for(UM_Collection__c collection: collectionList){
                  billingAccount.add(collection.UM_Billing_Location__c);
                  collectionIdSet.add(collection.UM_Collection_ID__c);
         }  
              
        List<UM_Collection__c> lstColl =[Select Id,Name,UM_Collection_ID__c,UM_Billing_Location__c,UM_Name_Counter__c from UM_Collection__c Where UM_Collection_ID__c in :collectionIdSet AND UM_Billing_Location__c IN:billingAccount];
      
        //billList = [SELECT Id, (Select Id,UM_Collection_ID__c,Name,UM_Name_Counter__c,UM_Billing_Location__c from Collections__r Order by UM_Name_Counter__c DESC) from csconta__Billing_Account__c where Id IN:billingAccount];

        billList = [SELECT Id, (Select Id,UM_Collection_ID__c,Name,UM_Name_Counter__c,UM_Billing_Location__c from Collections__r Order by UM_Name_Counter__c DESC limit 1) from csconta__Billing_Account__c where Id IN:billingAccount];
      
        if(billList.Size() > 0){
            for(csconta__Billing_Account__c billingObj : billList){
                if(billingObj.Collections__r.Size() > 0){
                    System.debug('billList Collection'+billingObj.Collections__r[0]);
                    mapOfbillingandColl.put(billingObj.Id,billingObj.Collections__r[0]); 
                }
            }
        }
       
        for(UM_Collection__c collections1 : collectionList){
            if(lstColl.Size() > 0){
              for(UM_Collection__c coll :lstColl){
             ///if(mapOfBillingIdAndColl.Size() > 0){
                    if(collections1.UM_Collection_ID__c == coll.UM_Collection_ID__c && collections1.UM_Billing_Location__c == coll.UM_Billing_Location__c){
                            collectionListToInsert = new List<UM_Collection__c>();
                            if(coll.Name.contains('Mahnzyklus - ')){
                                collections1.Name = coll.Name;
                            }else{
                                collections1.Name = 'Mahnzyklus - ' + counter;
                            }
                            collections1.UM_Name_Counter__c =collections1.Name.substringAfter('-');
                            collectionListToInsert.add(collections1);
                              break;
                            }else{
                              if(mapOfbillingandColl.Size() > 0){ 
                                     //counter = Integer.valueOf(billingObj.Collections__r[0].UM_Name_Counter__c) + 1; 
                                     UM_Collection__c collectionObj =   mapOfbillingandColl.get(collections1.UM_Billing_Location__c);
                                     if(collectionObj != null && String.isNotEmpty(collectionObj.UM_Name_Counter__c)){
                                        counter = Integer.valueOf(collectionObj.UM_Name_Counter__c)+1;
                                        collections1.Name = 'Mahnzyklus - ' + counter;
                                        collections1.UM_Name_Counter__c = collections1.Name.SubstringAfter('-');
                                        collectionListToInsert.add(collections1); 
                                     }else{
                                     counter = 1;
                                     collections1.Name = 'Mahnzyklus - ' + counter;
                                     collections1.UM_Name_Counter__c = String.valueOf(counter);
                                     collectionListToInsert.add(collections1);
                                      }
                                   
                              }
                        }
                }
                    
             // }
            }
           else{
               if(mapOfbillingandColl.Size() > 0){
                     //counter = Integer.valueOf(billingObj.Collections__r[0].UM_Name_Counter__c) + 1;
                     UM_Collection__c collectionObj =   mapOfbillingandColl.get(collections1.UM_Billing_Location__c);
                     if(collectionObj != null && String.isNotEmpty(collectionObj.UM_Name_Counter__c)){
                        counter = Integer.valueOf(collectionObj.UM_Name_Counter__c)+1;
                         collections1.Name = 'Mahnzyklus - ' + counter;
                         collections1.UM_Name_Counter__c = collections1.Name.SubstringAfter('-');
                         collectionListToInsert.add(collections1); 
                     }else{
                     counter = 1;
                     collections1.Name = 'Mahnzyklus - ' + counter;
                     collections1.UM_Name_Counter__c = String.valueOf(counter);
                     collectionListToInsert.add(collections1);
                      }
                    
              }
        } 
       // }
    }
}
}

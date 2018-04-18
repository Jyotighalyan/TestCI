/**BU-234**/

global class UM_DeactivateBA_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {
//Private Id billingId;
    
   /* global UM_DeactivateBA_Batch (Id billingAccId)
    {
      billingId = billingAccId;
    } */
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String BillingStatus = 'Deactivation Requested';
       // String BillingEscaped= String.escapeSingleQuotes(BillingStatus);        
        String BillingQuery = 'SELECT id,csconta__Status__c FROM csconta__Billing_Account__c WHERE csconta__Status__c = \''+String.escapeSingleQuotes(BillingStatus )+'\'';
       /* if (billingId != null)
        {
          BillingQuery += ' AND id =\''+String.escapeSingleQuotes(billingId)+'\'';
        } */
        System.debug ('Query-->'+BillingQuery);
        return Database.getQueryLocator(BillingQuery);      
                                                      
    }
    
    global void execute(Database.BatchableContext BC,List<csconta__Billing_Account__c > billingList){
       
       System.debug('1##');
       Map<Id, list<csord__Service__c>> mapAccIdToListSer = new Map<Id, list<csord__Service__c>>();
       for (csord__Service__c serviceObj : [SELECT Id, csord__Subscription__r.csconta__Billing_Account__c,csord__Deactivation_Date__c  FROM csord__Service__c 
                                                WHERE csord__Subscription__r.csconta__Billing_Account__c =:billingList] )
          {
            if (!mapAccIdToListSer.containskey(serviceObj.csord__Subscription__r.csconta__Billing_Account__c))
            {
                System.debug('2if##');
               mapAccIdToListSer.put(serviceObj.csord__Subscription__r.csconta__Billing_Account__c, new List <csord__Service__c>{serviceObj});
            }
             else
             {
              System.debug('2else##');
               mapAccIdToListSer.get(serviceObj.csord__Subscription__r.csconta__Billing_Account__c).add(serviceObj);
             }
           }     
           
           Set<Id> BillingAccId = new Set<Id>(); 
           System.debug('3##');
           for(Id BillingId : mapAccIdToListSer.keySet())
           {
              System.debug('4##');
             List<csord__Service__c> serviceList = mapAccIdToListSer.get(BillingId);
            
             boolean deactflag = false;
             
             for (csord__Service__c serObj: serviceList )
                 {
                   System.debug('5##');
                  if(serObj.csord__Deactivation_Date__c >= Date.today()) 
                  {
                    deactflag = true;
                    System.debug('InsideDeactivationLoop##');
                  }
                 }
              
                if (deactflag == false){
                System.debug('AddBilingId##');
                 BillingAccId.add(BillingId);
                }
           }
                
           try{ 
           if (BillingAccId.size() !=0)
                {
                   System.debug('Size>0##');
                  for(Id billingId : BillingAccId)
                  {
                    System.debug('BillId##'+billingId );
                    UM_KenanAccountSyncCtrl.createCeaseKenanBillinAcc(billingId);
                  }
                }  
              }
              
           catch(exception e){
            System.debug('Error: '+e.getMessage() + 'stack trace:'+ e.getStackTraceString());
            }    
        }

    global void finish(Database.BatchableContext BC) {
        
        //Finish logic
        
        
    }


    
    
}
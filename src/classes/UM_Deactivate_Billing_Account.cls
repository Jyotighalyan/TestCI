global class UM_Deactivate_Billing_Account{

 public static String deactivateStr = 'DeactivateBA';

    /**Method for changing the status of BA object as 'Deactivation Requested' (BU-234)**/
    webservice static String deactivateBA(String billingId){
        
        System.debug('InsideDeactivateMethod@@'+billingId);   
        Boolean deactivationReq =false;
        Boolean invalidServices =true;
        list<csord__Service__c> serviceList = [SELECT id, csord__Activation_Date__c, csord__Deactivation_Date__c
                                                       FROM csord__service__c
                                                       WHERE csord__Subscription__r.csconta__Billing_Account__c =:billingId];
        System.debug('serviceList@@'+serviceList.size()); 
        
 
                                                       
        list<csord__Service__c> filteredServiceList = [SELECT id, csord__Activation_Date__c, csord__Deactivation_Date__c
                                                       FROM csord__service__c
                                                       WHERE csord__Subscription__r.csconta__Billing_Account__c =:billingId
                                                       AND (LG_ServiceStatus__c != 'Active')  AND (csord__Deactivation_Date__c!=null)];                                                      
        System.debug('filteredServiceList @@'+filteredServiceList.size());
       
       csconta__Billing_Account__c billingObj = [Select id,csconta__Status__c from csconta__Billing_Account__c where Id =:billingId];
       
           if (!serviceList.isEmpty() )
           {
          
                   if ((serviceList.size() == filteredServiceList.size()) && (billingObj.csconta__Status__c != 'Deactivation Requested') 
                   && (billingObj.csconta__Status__c != 'Deactivation Pending') && (billingObj.csconta__Status__c != 'Inactive'))
                   {
                      System.debug('@if');
                      billingObj.csconta__Status__c = 'Deactivation Requested';
                      update billingObj;
                      deactivateStr = 'Deactivate';
                      deactivationReq = true;
                   }
                   else if (serviceList.size() != filteredServiceList.size()){
                        System.debug('@1stElseif');
                        deactivateStr = 'Error';
                   }
                   else if ((serviceList.size() == filteredServiceList.size()) && (billingObj.csconta__Status__c == 'Deactivation Requested')){
                        System.debug('@2ndElseif');
                        deactivateStr = 'Already Deactivated';
                        deactivationReq = true;
                   } 
                   else if ((serviceList.size() == filteredServiceList.size()) && (billingObj.csconta__Status__c == 'Deactivation Pending')){
                        System.debug('@3rdElseif');
                        deactivateStr = 'Already Deact Pending';
                        deactivationReq = true;
                   } 
                     else if ((serviceList.size() == filteredServiceList.size()) && (billingObj.csconta__Status__c == 'Inactive')){
                        System.debug('@4thElseif');
                        deactivateStr = 'Already Inactive';
                        deactivationReq = true;
                   } 
         
         csconta__Billing_Account__c billingAccObj = [Select id,csconta__Status__c from csconta__Billing_Account__c where Id =:billingId];
              
                   if (deactivationReq == true )
                   {
                     System.debug('@deactivationReqif-->');
                         for(csord__Service__c serviceObj: filteredServiceList )
                         {
                               if (serviceObj.csord__Deactivation_Date__c >=Date.today())
                               {
                                 System.debug('@DATE_SERVDEACTIVATION-->');
                                 invalidServices = false;
                               }
                         } 
                         
                         if (invalidServices == true && (billingAccObj.csconta__Status__c == 'Deactivation Requested'))
                         {
                           System.debug('@invalidServicesIf-->');
                          // UM_KenanAccountSyncCtrl.createCeaseKenanBillinAcc(billingId);
                          deactivateStr = 'Invoke API';
                          
                         }
                       
                   }
                   
                } 
           else 
            {
              System.debug('@No Subscriptions/Services present');
              deactivateStr = 'No linked Services';
            }
            
           /*  if (deactivationReq == true ){
             UM_DeactivateBA_Batch batch = new UM_DeactivateBA_Batch(billingId);
             Database.executeBatch(batch);
             } */
    return deactivateStr;
    }
}
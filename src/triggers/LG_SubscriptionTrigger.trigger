trigger LG_SubscriptionTrigger on csord__Subscription__c (before insert, before update, after insert, after update, before delete) {
 No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

    if (notriggers == null || !notriggers.Flag__c)
    {
       /* //SFOM-1786 && OMB-1114
         if (Trigger.isBefore && Trigger.isUpdate)
        {
            for(csord__Subscription__c  sub1 : Trigger.New) {
               if(sub1.csord__Status__c == 'Closed Replaced' && sub1.LG_ReplacementSubChangeType__c == 'Move')
               {
                   sub1.csord__Status__c  = 'Inactive';
               }
          }
        }
        */
        
        //added as part of SOFM-1970 and OMB-2936
        
          if (Trigger.isBefore && Trigger.isUpdate)
        {
            for(csord__Subscription__c  sub1 : Trigger.New) {
            
               if(Trigger.oldMap.get(sub1 .id).csord__Status__c!='Closed Replaced' &&
                    sub1.csord__Status__c == 'Closed Replaced' &&
                    sub1.LG_ReplacementSubChangeType__c!=null && 
                    sub1.LG_ReplacementSubChangeType__c == 'Move')
               {
                   sub1.csord__Status__c  = Trigger.oldMap.get(sub1 .id).csord__Status__c;
               }
          }
        }
       
    }
}
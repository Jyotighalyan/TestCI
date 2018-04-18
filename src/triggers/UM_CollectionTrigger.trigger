trigger UM_CollectionTrigger on UM_Collection__c (before insert,before update) {
      
         Set<String> collectionIdSet = new Set<String>();
       
          if(Trigger.isBefore){
             if(Trigger.isInsert || Trigger.isUpdate){         
                  collectionIdSet = UM_CollectionTriggerHandler.collectionBeforeInsert(Trigger.New);
                   if(collectionIdSet.Size() > 0){
                     UM_CollectionTriggerHandler.insertCollection(Trigger.New,collectionIdSet);
                 }
             }
           
          }
       
}
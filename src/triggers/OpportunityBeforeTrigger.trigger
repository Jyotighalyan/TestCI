trigger OpportunityBeforeTrigger on Opportunity(before insert, before update) {
  // TriggerOpportunityHandler.handle(Trigger.new, Trigger.old); Theo ten Klooster 25-2-2016 removed trigger
  

  // Opportunity contact role
  if(trigger.isupdate && trigger.isbefore){
      TriggerOpportunityContactRole.primaryContactUpdate(trigger.new);
  }
  
}
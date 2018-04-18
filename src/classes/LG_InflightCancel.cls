/* 
* Desc: This class is used as controller of LG_InflightCancel.  
* JIRA Issue : SFOM -2385 
*/

public class LG_InflightCancel{

Public  opportunity opp {get;set;}
public String statusOptions { get; set; }
public String message { get; set; }
public String  orderId{ get; set; }
public String checkParam {get;set;}
public List<case> cas {get;set;}
List<csord__Subscription__c> sub{get;set;}
List<csord__Service__c> serv{get;set;}
List<csord__Solution__c> soln{get;set;}
List<CSPOFA__Orchestration_Process__c> orch{get;set;}
 

public LG_InflightCancel(){
    orderId = Apexpages.currentpage().getparameters().get('id');
    opp=[select id,UM_PICReasons__c from opportunity limit 1];
}

public List<SelectOption> getItems() {
List<SelectOption> options = new List<SelectOption>();
        
   Schema.DescribeFieldResult fieldResult =
 opportunity.UM_PICReasons__c.getDescribe();
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
   for( Schema.PicklistEntry f : ple)
   {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
   }       
   return options;

}
public void ConfirmCancel(){
try{
system.debug('orderId'+orderId);
    csord__Order__c order=[select csord__Status__c,LG_PICReason__c,csordtelcoa__Opportunity__c from csord__Order__c where id=:orderId];
    if(order.csord__Status__c=='Activation Completed' || order.csord__Status__c=='Ready for Billing' || order.csord__Status__c=='Active'|| order.csord__Status__c=='Inactive' ){
          Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+'Order already after PONR. Cancellation is no more an option"'));
        message='Order already after PONR. Cancellation is no more an option';
        system.debug('message'+message); 
        
    }
    else{
        order.csord__Status__c='Cancel Confirmed';
        order.LG_PICReason__c=statusOptions;
        //update opportunity
        opportunity oppt=[select id,UM_PICReasons__c,Stagename from opportunity where id=:order.csordtelcoa__Opportunity__c];
        oppt.Stagename='Pre-Installation-Cancellation';
        oppt.UM_PICReasons__c=statusOptions;
        system.debug(oppt.id);
         system.debug(order.csordtelcoa__Opportunity__c);
        update oppt;
        update order;
        //update cases 
        cas=[select id,status from case where LG_Order__c=:order.id]; 
        for(case ca:cas){
        ca.status='Cancelled';
        }
        update cas;
        //update subscriptions
        sub=[select  csord__Status__c from csord__Subscription__c where csord__Order__c=:order.id];
        for(csord__Subscription__c subs:sub){
        subs.csord__Status__c='Cancelled';
        }
        update sub;
        
        //update service
        serv=[select csord__Status__c,UM_PICReason__c from csord__Service__c where csord__Order__c=:order.id];
        for(csord__Service__c ser:serv){
        ser.UM_PICReason__c=statusOptions;
        ser.LG_ServiceStatus__c='cancelled';
        
        }
        update serv;
        
        //update solutions
         soln=[select csord__Status__c from csord__Solution__c where csord__Order__c=:order.id];
        for(csord__Solution__c sol:soln){
           sol.csord__Status__c='cancelled';
                }
        update soln;
        
        //update orchestration process
        orch=[select CSPOFA__Status__c from CSPOFA__Orchestration_Process__c where LG_Order__c=:order.id];
        for(CSPOFA__Orchestration_Process__c orchestration:orch){
        orchestration.CSPOFA__Status__c='Complete';
                }
        update orch;
        
        //update asset
        
        List<asset> ass=[select id,status from asset where csord__Order__c=:order.id];
        for(asset asst:ass){
        
        asst.status='inactive';
        
        }
        update ass;
        
        
        
        
        checkParam = 'Ok!';   
    }
}

catch(Exception e){
system.debug(e.getmessage()+''+e.getlinenumber());
}
}
}
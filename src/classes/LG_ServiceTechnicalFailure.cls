/************************************************************
* File Name     : LG_ServiceTechnicalFailure
* Description   : This class creates Callout System Failure records based on the serives failures

* @author       :  Infosys limited
* Modification Log
* version 1.1   : Team Assisted Care (14th AUG 2017) -- UM  
*****************************************************************/
public Class LG_ServiceTechnicalFailure{
    //8 arguments -- AC team need last three everything else will be null for the record.
    public Static void createCalloutFailureResult(String oppid,String oppOwnerID, String accountID,String serviceName,String code,String description,String request,String response){
        System.debug(oppid +'-*-'+oppOwnerID+'-*-'+accountID+'-*-'+serviceName+'-*-'+code+'-*-'+description);
        System.debug('request#--'+request );
        System.debug(' response#--'+response );
        /* Not needed for care track
if(oppid!=null && serviceName!=null && Code!=null && description!=null && oppid!='' && serviceName!='' && Code!='' && description!=''){
map<String,LG_CalloutTechnicalFailure__c> allTechnicalFailuresMap=LG_CalloutTechnicalFailure__c.getall();
if(allTechnicalFailuresMap.containsKey(serviceName+':'+Code)){
LG_CalloutTechnicalFailure__c CallOutFail=allTechnicalFailuresMap.get(serviceName+':'+Code);
Group ITTeamQueue= [Select iD from Group where Name='IT Team Queue' and Type = 'Queue' lIMIT 1]; */
        LG_CalloutSystemFailures__c callSysFail=new LG_CalloutSystemFailures__c();
        //callSysFail.OwnerID=CallOutFail.LG_Queueid__c;
        callSysFail.LG_Status__c='Open';
        if(oppid != null && oppid != '')
            callSysFail.LG_Opportunity__c=oppid;
        if(oppOwnerID!=null && oppOwnerID!=''){
            callSysFail.LG_OpportunityOwner__c=oppOwnerID;
        }
        if(accountID!=null && accountID!=''){
            callSysFail.LG_Account__c=accountID;
        }
        if(request != null && request != '')
            callSysFail.LG_RequestMessage__c=request;
        if(response != null && response != '')
            callSysFail.LG_ResponseMessage__c=response;
        //callSysFail.LG_TypeOfService__c=CallOutFail.LG_ServiceType__c;
        if(code != null && code != '')
            callSysFail.LG_ErrorCode__c=code;
        if(description != null && description != '')
            callSysFail.LG_ErrorDescription__c=description;
        if(serviceName != null && serviceName != '')
            callSysFail.LG_ServiceName__c=serviceName;
        /* Not needed for care track
updating Opportunity Status and Dashboard error meassage field
opportunity opp=new opportunity();
opp.id=oppid;
opp.LG_Opportunity_Status__c=CallOutFail.LG_ConditionFieldValue__c;
opp.LG_DashboardTechnicalError__c=code+' '+CallOutFail.LG_Description__c+' : '+CallOutFail.LG_ErrorMessage__c;
*/
        System.debug('####### callSysFail'+callSysFail);
        try{
            insert callSysFail;
            //update opp;
        }catch(Exception ex){
            System.debug('## Exception in LG_ServiceTechnicalFailure:'+ex);
        }
        //}
        //}  
        
    }
    
    
}
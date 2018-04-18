/* Used to Send an WelcomePAck Email through Orchestrator
 * Author : Vivek Ajantha
 * ticket : SFOM - 144
 * Since : 01-02-2017
*/
global class LG_SendWelcomePackEmail implements CSPOFA.ExecutionHandler 
{
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
                
        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList)
        {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        Set<Id> solutionIds = new Set<Id>();

        // Get all solution Ids associated with the processes
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id, LG_Solution__c
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            solutionIds.add(process.LG_Solution__c);
        }
        
        for (Id solutionId : solutionIds) {
            SendEmail(solutionId);
        }   
        
        for (CSPOFA__Orchestration_Step__c step : stepList)
        {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;        
    }
    public static void SendEmail(Id solutionId)
    {
        csord__Solution__c solutionObject = new csord__Solution__c();
        Id Solid = solutionId;
        csord__Solution__c obj;
        Contact contactobj;
        Id accId = null;
        //Fetching solution Details associated with the solution id
        solutionObject = getSolutionRecord(Solid);
        system.debug(solutionObject);
        //Fetching Acount Id assosiated with the solution object
        if(solutionObject != null){
            accId = solutionObject.csord__Order__r.csord__Account__c;
        }else{
            obj = [SELECT Id, csord__Order__r.csord__Account__c FROM csord__Solution__c WHERE Id = :solutionId];
            accId = obj.csord__Order__r.csord__Account__c;
        }
        //Fetching the contact list related to the Account Obj
        /*if(accId != null){
            contactobj = getContactRecords(accId);
        }*/
        //call conga url
        String sessId = UserInfo.getSessionId();
        String servUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/services/Soap/u/29.0/'+UserInfo.getOrganizationId();
        
        if(solutionObject.LG_SendEmailCheck__c == false)
        {
            solutionObject.LG_SendEmailCheck__c = true;
            system.debug(solutionObject.LG_SendEmailCheck__c);
        }
        update solutionObject;
        
        
    }
    
    public static csord__Solution__c getSolutionRecord(Id solutionId) {
        csord__Solution__c solObj = new csord__Solution__c();
        List<csord__Solution__c> solList = [SELECT Id, Name, LG_Address__c,LG_SendEmailCheck__c, LG_Address__r.Name, LG_ProvisioningWorkOrder__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                   csord__Order__r.csord__Account__r.Name, csord__Order__r.Name, csord__Order__r.csord__Order_Type__c,csord__Order__r.csord__Order_Number__c ,csord__Order__r.csord__Account__c,
                   LG_PlanningRequired__c, Jeopardy_Reason__c, Ownerid FROM csord__Solution__c WHERE Id = :solutionId];
        System.debug('obj' + solObj);
        if(!solList.isEmpty())
        {
            solObj = solList[0];
        }
        System.debug('obj2' + solObj);
        return solObj;
    }
    /*public static Contact getContactRecords(Id accId) {
        Contact contact = new Contact();
        List<Contact> contactListDetails = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE AccountId=:accId];
        if(!contactListDetails.isEmpty())
        {
            contact = contactListDetails[0];
        }
        return contact;
    }*/
}
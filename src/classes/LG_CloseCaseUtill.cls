global class LG_CloseCaseUtill {
    webservice static String closeCase(List<Id> recIds)
    {
        String errorMsg = 'Success';        
        Map<id, case> caseMap = new Map<id, case>();
        map<Id, Schema.RecordTypeInfo>  newSchema = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById();
        
        List<Case> caseRecords = [select Id,LG_Service__c,LG_Solution__c,LG_Solution__r.LG_Jeopardy__c, LG_Solution__r.owner.id, LG_Order__r.owner.id, LG_Order__c,CaseNumber,ContactId,AccountId,RecordTypeId, LG_Solution__r.LG_RetryProvision__c,
                                  Type,Status,LG_AccountId__c from Case where Id=:recIds];
        List<case> configCaseList = new List<case>();
        List<Case> casesToUpdate = new List<Case>();
        Set<id> inflightSolnId = new Set<id>(); //SFOM-688
        Set<id> configSolnId = new set<id>();
        Set<id> jeopardySolnId = new set<id>();  //SFOM-589
        Set<id> legacyFulfilmentSolnId = new set<id>(); //SFOM-796
        Set<id> provisionSolnId = new set<id>(); //SFOM-913
        
        if(!caseRecords.isEmpty()){
            for (Case c : caseRecords){
                c.status = 'Closed';
                casesToUpdate.add(c);
                
                if (newSchema.get(c.recordTypeID).getName() == 'Schedule Appointment'  && c.LG_Solution__C!= Null ) {
                    caseMap.put(c.id, c);  
                    if(c.lg_solution__r.LG_Jeopardy__c == False)
                        inflightSolnId.add(c.LG_Solution__c); //SFOM-688
                } 
                if (newSchema.get(c.recordTypeID).getName() == 'Inflight Configuration'  && c.LG_Solution__C!= Null ) {
                    configCaseList.add(c);                
                    configSolnID.add(c.LG_Solution__C);
                    if(c.lg_solution__r.LG_Jeopardy__c == False)
                        inflightSolnId.add(c.LG_Solution__c); //SFOM-688  
                }
                if (newSchema.get(c.recordTypeID).getName() == 'Manage Numbers'  && c.LG_Solution__C!= Null ) {
                    if(c.lg_solution__r.LG_Jeopardy__c == False)
                        inflightSolnId.add(c.LG_Solution__c);   //SFOM-688
                }
                //SFOM-589
                if (newSchema.get(c.recordTypeID).getName() == 'Jeopardy'  && c.LG_Solution__C!= Null ) {
                    //if(c.lg_solution__r.LG_Jeopardy__c == False)
                        jeopardySolnId.add(c.LG_Solution__c);   
                } 
                //SFOM-796
                if(newSchema.get(c.recordTypeID).getName() == 'Legacy Fulfilment'  && c.LG_Solution__C!= Null && c.Type == 'Modify'){
                    legacyFulfilmentSolnId.add(c.LG_Solution__c);
                }
                 //SFOM-913
                if(newSchema.get(c.recordTypeID).getName() == 'Provision' && c.Type == 'Change'){
                    provisionSolnId.add(c.LG_Solution__c);
                 }
            }
        }
        try{
            update casesToUpdate;
        }
        catch (Exception e)
        {
            errorMsg = e.getDmlMessage(0);
        }   
        
        if(errormsg== 'Success')
        {
            //SFOM-796
            if(legacyFulfilmentSolnId.size()>0){
                errorMsg = checkBillingSystemReference(legacyFulfilmentSolnId);
            }
             //SFOM-913
            if(provisionSolnId.size()>0){
                resetRetryProvisionFlag(provisionSolnId);
            }
            if (!configCaseList.isEmpty())
                errorMsg = checkConfiguration (configCaseList, configSolnID);           
            
            if(caseMap.size()>0)
                errorMsg = checkappointment(caseMap);
            //SFOM-688
            if(inflightSolnid.size()>0 && errorMsg == 'Success')
                errorMsg = cancelRelatedCases(inflightSolnid);
            //SFOM-589
            if(jeopardySolnid.size()>0)
                errorMsg = updateJeopardySoln(jeopardySolnid);
        }
        return errorMsg;
    }
    
    Public Static String checkConfiguration(List<case> caseList, Set<id> solnId)
    {
        List<csord__Solution__c> solnToUpdate = new List <csord__Solution__c>();
        List<csord__Solution__c> solnList = [SELECT id, Name,
                                             csord__Order__c,
                                             LG_ProvisioningWorkOrder__c,
                                             LG_Jeopardy__c
                                             from csord__Solution__c where Id=:solnid ];
        
        for (csord__solution__c sol :solnList){
            if(sol.LG_Jeopardy__c == True)
            {
                sol.LG_RetryProvision__c = True;
                solnToUpdate.add(sol);
            } 
            else {         //if(sol.LG_ProvisioningWorkOrder__c != '')
                sol.LG_InflightChange__c  = True;
                sol.LG_RetryProvision__c = True;
                solnToUpdate.add(sol);                
            }
        }
        if(solnToUpdate.size()>0){
            try{
                update solnToUpdate; 
            } catch (Exception e)
            {
                return e.getMessage();
            }                   
        }
        return 'Success';
    }
    
    Public Static String checkAppointment(Map<id, case> caseMap){
        
        String errorMsg = 'Success';
        Map<id, LG_ScheduleAppointment__c> caseAppMap = new Map<id, LG_ScheduleAppointment__c>();
        List<LG_ScheduleAppointment__c> appointmentList= new List <LG_ScheduleAppointment__c>();
        List<case> caseList = new List<case>();
        List<CSPOFA__Orchestration_Process__c> processIds = new List <CSPOFA__Orchestration_Process__c>();
        List<CSPOFA__Orchestration_Step__c> processSteps = new List<CSPOFA__Orchestration_Step__c>();
        List<csord__Solution__c> solnlist = new List<csord__Solution__c>(); 
        List<csord__Solution__c> solnListToUpdate = new List<csord__Solution__c>(); 
        
        //get the list of appointments for the cases in the map and cases for Modify type and not in Jeopardy
        appointmentList = [SELECT id,LG_Status__c,LG_Case__c from LG_ScheduleAppointment__c WHERE LG_Case__c in :caseMap.keyset() and  LG_Status__c = 'Scheduled'];
        caseList = [SELECT id, LG_Solution__C from case WHERE  id in :caseMap.keyset() and type = 'Modify' ];
        
        //Get the list of solution id mapped to the cases
        set<Id> solnId = new set <Id>();
        
        for (case c : caseList){
            solnId.add(c.LG_Solution__c);
        }
        
        //Get the list of orchestration process ids and process ids for the solution
        solnList = [SELECT id, LG_TargetDate__c, LG_Jeopardy__c, LG_EarliestInstallDate__c, LG_EarliestPortingWishDate__c,LG_LatestPortingWishDate__c, LG_AnyNumbersToPort__c, LG_InflightChange__c, LG_RetryInstall__c, LG_RetryNumberPort__c from csord__Solution__c WHERE  id in :solnId];
        processIds = [SELECT id, Name, LG_Solution__c, CSPOFA__Orchestration_Process_Template__c, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c where LG_Solution__c IN :solnId];
        processSteps = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c,CSPOFA__Orchestration_Process__c,CSPOFA__Orchestration_Process__r.LG_Solution__r.id  FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c in :processIds and CSPOFA__Step_Order__c <100];    
        
        //add appointment details to a map
        for (LG_ScheduleAppointment__c appointment :appointmentList) {
            
            caseAppMap.put(appointment.LG_Case__C, appointment);
        }
        
        //check if every case in the map contains a appointment
        for (String keyId : caseMap.keySet() ){
            
            if(!caseAppMap.keyset().contains(keyId)){
                caseMap.get(keyId).addError('Case cannot be closed without a valid appointment');
                errorMsg = 'Case cannot be closed without a valid appointment';
                return errorMsg;
            }
        }
        
        //To Send Appointment remainder mails -- SFOM-552   
        if (errorMsg == 'Success')
            errorMsg = sendNotificationEmail(solnId, errorMsg);
        
        //Checking the impact on Orchestration Process
        ////Setting portingwindow to 7 days -- to be made dynamic in future phases
        if (errorMsg == 'Success'){
            Integer portingWindow;
            Integer potentialGotoSeq;   
            for (csord__Solution__c soln :solnList ){
                LG_InflightChangeStep__c inflightSetting = checkCustomSetting (processIds,soln.id);
                
                portingWindow = inflightSetting.LG_PortingWindow__c.intvalue();
                //Get the inprogress step
                CSPOFA__Orchestration_Step__c inProgressProcessStep = inProgressProcessStep(processSteps, soln.id);
                
                //Condition to check if there is an impact on orchestration process due to change in dates  and set the appropriate flags to True
                System.debug('inProgressProcessStep.CSPOFA__Step_Order__c'+inProgressProcessStep.CSPOFA__Step_Order__c);
                
                if (soln.LG_AnyNumbersToPort__c == True){
                    //Compute the potential step based on porting wish date
                    potentialGotoSeq = inflightSetting.LG_RetryNumberPort__c.intvalue();
                    if (soln.LG_LatestPortingWishDate__c.addDays(portingWindow) > soln.LG_TargetDate__c ){
                        potentialGotoSeq = inflightSetting.LG_RetryInstall__c.intvalue();
                    }
                    
                    System.debug('potentialGotoSeq'+potentialGotoSeq);
                    //For Suborders not in Jeopardy
                    if(soln.LG_Jeopardy__c == False){
                        if(inProgressProcessStep.CSPOFA__Step_Order__c >=potentialGotoSeq ){
                            if(potentialGotoSeq == inflightSetting.LG_RetryInstall__c.intvalue()){
                                soln.LG_RetryInstall__c = True;
                                solnListToUpdate.add(soln);
                            }
                            else if(potentialGotoSeq == inflightSetting.LG_RetryNumberPort__c){
                                soln.LG_RetryNumberPort__c = True;
                                solnListToUpdate.add(soln);
                            }
                            soln.LG_InflightChange__c = True;
                            continue;
                        }
                    }
                    //For Suborders in Jeopardy  SFOM-577
                    if(soln.LG_Jeopardy__c == True){
                        if(inProgressProcessStep.CSPOFA__Step_Order__c > potentialGotoSeq ){
                            if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_InstallLoop__c.intvalue()){
                                soln.LG_RetryInstall__c = True;
                                solnListToUpdate.add(soln);
                            }
                            else if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_NumberPortLoop__c.intvalue()){
                                soln.LG_RetryNumberPort__c = True;
                                solnListToUpdate.add(soln);
                            }
                            continue;
                        }
                    }                
                }
                //For products with number porting flag unchecked
                if (soln.LG_AnyNumbersToPort__c == False){
                    potentialGotoSeq = inflightSetting.LG_RetryInstall__c.intvalue();
                    
                    //Condition to check if there is an impact on orchestration process due to change in dates  and set the appropriate flags to True
                    if(soln.LG_Jeopardy__c == False){
                        if(inProgressProcessStep.CSPOFA__Step_Order__c >=potentialGotoSeq ){
                            soln.LG_RetryInstall__c = True;
                            soln.LG_InflightChange__c = True;
                            solnListToUpdate.add(soln);
                        }
                    }
                    //SFOM-577
                    else if (soln.LG_Jeopardy__c == True){
                        if(inProgressProcessStep.CSPOFA__Step_Order__c > potentialGotoSeq && inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_InstallLoop__c.intvalue() ){
                            soln.LG_RetryInstall__c = True;
                            solnListToUpdate.add(soln);
                        }                        
                    }
                    
                }
            }
            
            if(solnListToUpdate.size()>0){
                try{
                    update solnListToUpdate; 
                } catch (Exception e)
                {
                    return e.getMessage();
                }
            }
        }
        return errorMsg;
    }
    //Method to get the Custom settings  SFOM-577 & SFOM-688
    @TestVisible
    Private static LG_InflightChangeStep__c checkCustomSetting (List<CSPOFA__Orchestration_Process__c> orchProcess, Id solnId){
        //Get the orchestration process associated to a solution
        System.debug('checkCustomSetting-->'+orchProcess);
        System.debug('solnId-->'+solnId);
        id pro;
        for (CSPOFA__Orchestration_Process__c orch : orchProcess){
            if(orch.LG_Solution__c== solnId){
                pro = orch.CSPOFA__Orchestration_Process_Template__c;
                break;
            }
        }
        //Get the custom setting defined for a process
        LG_InflightChangeStep__c csSetting = new   LG_InflightChangeStep__c (); 
        List<LG_InflightChangeStep__c> inflightSettingList = LG_InflightChangeStep__c.getall().values();        
        for (LG_InflightChangeStep__c cs :inflightSettingList ){
            if(cs.LG_OrchestrationProcess__c == pro){
                csSetting = cs;
                break;
            }
        }
        return csSetting; 
    }
    //Method to compute the inprogress orchestration process step
    @TestVisible
    Private static CSPOFA__Orchestration_Step__c inProgressProcessStep (List<CSPOFA__Orchestration_Step__c> inProgressProcessStep, Id solnId){
        
        CSPOFA__Orchestration_Step__c pro = new CSPOFA__Orchestration_Step__c ();
        for (CSPOFA__Orchestration_Step__c processStep : inProgressProcessStep){
            if(processstep.CSPOFA__Orchestration_Process__r.LG_Solution__c== solnId  && (processstep.CSPOFA__Status__c == 'In Progress'  || processstep.CSPOFA__Status__c == 'Waiting For Feedback')){
                pro = processStep;
                break;
            }
        }
        return pro; 
    }
    //Method to send notification mail if a appointment is modified  -- SFOM-552
    public static String sendNotificationEmail(set<id> solId, String errorMsg) {
        EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE Name = 'Appointment modification notification' LIMIT 1];
        List<LG_ScheduleAppointment__c> appointmentsList = [SELECT id,LG_AgreedInstallDate__c,LG_DateofFirstEmailNotification__c,LG_DateofSecondEmailNotification__c,LG_InstallationContact__c,LG_InstallationContact__r.Name,LG_Solution__c,LG_Solution__r.OwnerId,LG_Address__r.Name,LG_Solution__r.Name 
                                                            FROM LG_ScheduleAppointment__c 
                                                            WHERE LG_Solution__c = :solId];
        try {
            
            if(!appointmentsList.isEmpty())
            {
                List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
                for(LG_ScheduleAppointment__c app: appointmentsList)
                {
                    if(app.LG_InstallationContact__c != null)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(app.LG_InstallationContact__c);
                        mail.setWhatId(app.id);
                        mail.setTemplateId(template.id);
                        mail.setReplyTo(Label.LG_EmailAddress_Appointment_Handler);
                        mail.saveAsActivity = True;
                        mailsToSend.add(mail);
                    }
                }
                //Send Email
                if(mailsToSend.size() > 0)
                {
                    Messaging.sendEmail(mailsToSend);       
                }
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return ex.getMessage();
        }
        return errorMsg;
        
    }
    //Method to cancel all open cases when a inflight case is closed and there is a impact on orchestration  SFOM-688
    Public static String cancelRelatedCases (Set<id> solnListid){
        string errormsg = 'Success';
        List<case> caseList = new List<case>();
        List<case> caseListtoCancel = new List<case>();
        caseList = [SELECT Id, Status, owner.name, owner.LastName, owner.Email, LG_Solution__r.LG_RetryInstall__c, LG_Solution__r.LG_RetryProvision__c, LG_Solution__r.LG_RetryNumberPort__c from case where LG_Solution__c = :solnListid 
                    and status = 'New'
                    and case.recordtype.name in ('Install', 'Activate Service', 'Provision', 'Number Port')];       
        //Update the case status to Cancelled
        if(caseList.size()>0){
            for (Case c:caseList ){
                if(c.LG_Solution__r.LG_RetryInstall__c== True || c.LG_Solution__r.LG_RetryProvision__c== True || c.LG_Solution__r.LG_RetryNumberPort__c== True) {
                    c.Status = 'Cancelled';
                    c.Description = 'Case Cancelled due to Inflight Cancel Request';
                    caseListtoCancel.add(c);
                }
            }
            try{
                update caseListtoCancel;
            } catch (exception e)
            {
                errorMsg = e.getMessage();
            }
            if(errorMsg == 'Success')
                errorMsg = sendCancelMail(caseListtoCancel);
        }
        return errormsg;
    }
    //Method to send notification to suborder owner when a case is cancelled  SFOM-688
    public static String sendCancelMail(List<Case> caseListtoCancel) {
        String errorMsg = 'Success';
        EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE Name = 'Case Cancel Notification' LIMIT 1];
        try {
            if(!caseListtoCancel.isEmpty())
            {
                List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
                List<Contact> contactToSend = new List<Contact>();
                for(Case c: caseListtoCancel)
                {
                    Contact tmpContact = new Contact(email = c.owner.email, firstName = c.owner.name, LastName = c.owner.LastName);
                    insert tmpContact;
                    contactToSend.add(tmpContact);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(tmpContact.id);
                    mail.setWhatId(c.LG_Solution__c);
                    mail.setTemplateId(template.id);
                    mail.setReplyTo(Label.LG_EmailAddress_Appointment_Handler);
                    mail.saveAsActivity = True;
                    mailsToSend.add(mail);
                }
                //Send Email
                if(mailsToSend.size() > 0)
                {
                    Messaging.sendEmail(mailsToSend); 
                    delete contactToSend;
                }
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return ex.getMessage();
        }
        return errorMsg;
        
    }
    //Method to update retry flags when no action is taken on Jeopardy case -- SFOM-589
        Public static string updateJeopardySoln (set<id> jeoid){
        String errorMsg = 'Success';
        List<csord__Solution__c> jeoSolnToUpdate = new List<csord__Solution__c>(); 
        List<csord__Solution__c> jeoSolnList  = [SELECT id, LG_TargetDate__c, LG_Jeopardy__c, LG_EarliestInstallDate__c, LG_EarliestPortingWishDate__c,LG_LatestPortingWishDate__c, LG_AnyNumbersToPort__c, LG_InflightChange__c, LG_RetryInstall__c, LG_RetryNumberPort__c, LG_RetryProvision__c from csord__Solution__c WHERE  id in :jeoid];    
        List<CSPOFA__Orchestration_Process__c> processIds = new List <CSPOFA__Orchestration_Process__c>();
        List<CSPOFA__Orchestration_Step__c> processSteps = new List<CSPOFA__Orchestration_Step__c>();
        
        //Get the list of orchestration process ids and process ids for the solution
        processIds = [SELECT id, Name, LG_Solution__c, CSPOFA__Orchestration_Process_Template__c, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c where LG_Solution__c IN :jeoid];
        processSteps = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c,CSPOFA__Orchestration_Process__c,CSPOFA__Orchestration_Process__r.LG_Solution__r.id  FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c in :processIds and CSPOFA__Step_Order__c <100];    
        //Checking the impact on Orchestration Process
        for (csord__Solution__c soln :jeoSolnList ){
            if(soln.LG_RetryInstall__c== False && soln.LG_RetryProvision__c== False && soln.LG_RetryNumberPort__c== False) {
                
                //Get the inprogress step and custom setting for the process
                LG_InflightChangeStep__c inflightSetting = checkCustomSetting (processIds,soln.id);
                CSPOFA__Orchestration_Step__c inProgressProcessStep = inProgressProcessStep(processSteps, soln.id);
                System.debug('inProgressProcessStep.CSPOFA__Step_Order__c'+inProgressProcessStep.CSPOFA__Step_Order__c);
                
                if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_InstallLoop__c.intvalue()){
                    soln.LG_RetryInstall__c = True;
                    jeoSolnToUpdate.add(soln);
                }
                else if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_NumberPortLoop__c.intvalue()){
                    soln.LG_RetryNumberPort__c = True;
                    jeoSolnToUpdate.add(soln);
                }
                else if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_ProvisionLoop__c.intvalue()){
                    soln.LG_RetryProvision__c = True;
                    jeoSolnToUpdate.add(soln);
                }
                // added to fix error @step 200 in orch process
                 else if(inProgressProcessStep.CSPOFA__Step_Order__c == inflightSetting.LG_Access_Planningloop__c.intvalue()){
                    soln.LG_RetryPlanning__c = True;
                    jeoSolnToUpdate.add(soln);
                }
                continue;
            }
        }
        if(jeoSolnToUpdate.size()>0){
            try{
                update jeoSolnToUpdate; 
            } catch (Exception e)
            {
                return e.getMessage();
            }
        }
        return errorMsg;
    }    
    
    //SFOM -796 Added by : Ankur Gupta
    public static String checkBillingSystemReference(set<id> legacyFulfilmentSolnId){
        String errorMsg = 'Success';
        List<csord__service__c> services = [SELECT id FROM csord__service__c where LG_Suborder__c IN :legacyFulfilmentSolnId];
        
        if(!services.isEmpty()){
            List<csord__Service_Line_Item__c> lineItems = [SELECT id,LG_BillingAccount__r.LG_ExternalId__c FROM csord__Service_Line_Item__c where csord__service__c IN :services];
            
            if(!lineItems.isEmpty()){
                for(csord__Service_Line_Item__c sli: lineItems ){
                    if(sli.LG_BillingAccount__r.LG_ExternalId__c == null){
                        errorMsg = System.Label.LG_BillingExternIdError;                 
                    }
                }
            }
        }
        return errorMsg;
    }
    
    //SFOM-913
    public static void resetRetryProvisionFlag(set<id> provisionSolnId){
         List<csord__solution__c> solnList = [SELECT id, LG_RetryProvision__c FROM csord__solution__c WHERE id IN :provisionSolnId];
         for (csord__solution__c sol :solnList){
             sol.LG_RetryProvision__c = false;
         }
        update solnList;
    }
}
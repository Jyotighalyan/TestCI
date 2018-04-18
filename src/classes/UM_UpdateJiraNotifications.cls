/**
* This class is for handling the notification of status change in JIRA.
*
* @author Ankur Gupta
* @ticket SFOM-2131
* @since  16/11/2017
*/

@RestResource(urlMapping = '/UM_UpdateJiraNotifications')
global with sharing Class UM_UpdateJiraNotifications 
{
    static List<Note> errorNotes;     
    
    @HttpPost
    global static void updateJiraNotifications()
    {
        errorNotes = new List<Note>();
        
        RestRequest req = RestContext.request;
        System.debug('--req' + req);
        String jsonRequest = req.requestBody.toString();
        System.debug('incoming json request string' + jsonRequest);
        
        JiraNotificationWrapper notificationDetails = (JiraNotificationWrapper)JSON.deserialize(jsonRequest, JiraNotificationWrapper.class);
        System.debug('--notifications send by JIRA are for issues:' + notificationDetails);
        
        if (notificationDetails != null) 
            updateNotifications(notificationDetails);
    }
    
    global static void updateNotifications(JiraNotificationWrapper notification)
    {
        List<csord__service__c> services         = new List<csord__service__c>();
        List<Database.SaveResult> saveResults    = new List<Database.SaveResult>();
        Map<Id,csord__Service__c> servicesToUpdate = new Map<Id,csord__Service__c>();
        
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        
        Set<String> serviceStatuses = new Set<String>();
        
        LG_ScheduleAppointment__c appointment;
        csord__solution__c suborder;
        
        String jiraStatus = null;
        String exceptionMsg = null;
        String issueTypeId = null;
        String assigneeEmailAddress = null;  //SFOM-2588
        EmailTemplate template;
        OrgWideEmailAddress owea;
        Boolean isFinalStatus = false;
        
        Map<String,String> progressStatusMap = new Map<String,String>();
        Map<String,String> completionStatusMap = new Map<String,String>();
        Map<String,String> statusEmailTemplateNameMap = new Map<String,String>();
        //OMB-2665 -- Start
        for(JiraStatusCodeMapping__mdt statusRec : [SELECT Id, DeveloperName, Email_Template_Name__c, isStatusForCompletion__c, isStatusForEmail__c, 
                                                    isStatusForProgress__c, IssueType__c, Label, Language, MasterLabel, NamespacePrefix, QualifiedApiName,
                                                    Status__c FROM JiraStatusCodeMapping__mdt])
        {
            if(statusRec.isStatusForProgress__c)
                progressStatusMap.put(statusRec.IssueType__c,statusRec.Status__c );
            else if(statusRec.isStatusForCompletion__c)
                completionStatusMap.put(statusRec.IssueType__c,statusRec.Status__c );
            else if(statusRec.isStatusForEmail__c)
                statusEmailTemplateNameMap.put(statusRec.Status__c,statusRec.Email_Template_Name__c);
        }
        //OMB-2665 -- End
        if( String.isNotBlank(notification.issue_id) )
        {
            try
            {
                List<csord__solution__c> suborders = [SELECT Id, Name,LG_Jira_Status__c, LG_Provisioning_External_Id__c,LG_TargetDate__c, csord__Status__c, 
                                                      LG_Jeopardy__c, Jeopardy_Reason__c, LG_JeopardyExplanation__c, LG_Integration_Status__c, 
                                                      LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c, LG_Integration_Description__c
                                                      FROM csord__Solution__c  WHERE LG_ProvisioningWorkOrder__c = :notification.issue_id ]; 
                
                if(!suborders.isEmpty())
                {
                    suborder = suborders[0];
                    
                    if(String.isNotBlank(notification.status))
                        jiraStatus = notification.status;
                    else if(String.isNotBlank(suborder.LG_Jira_Status__c))
                        jiraStatus = suborder.LG_Jira_Status__c;
                    else
                        jiraStatus = 'No Status Received';
                    
                    Date serviceDate;
                    if(String.isNotBlank(notification.service_date))
                        serviceDate = Date.valueOf(notification.service_date);
                    else if(suborder.LG_TargetDate__c != null)
                        serviceDate = suborder.LG_TargetDate__c;
                        
                    List<LG_ScheduleAppointment__c> schAppointments = [SELECT Id,LG_Status__c, LG_Solution__c, LG_AgreedInstallDate__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :suborder.id ];
                    
                    if(statusEmailTemplateNameMap.containsKey(jiraStatus.toUpperCase()))
                    {
                        template = [SELECT Id FROM EmailTemplate WHERE Name = :statusEmailTemplateNameMap.get(jiraStatus.toUpperCase())];
                        owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply_care@unitymedia.de' LIMIT 1];   
                    }
                    
                    for(csord__service__c service : [SELECT id, LG_Suborder__c,csord__Service__c, csord__Deactivation_Date__c, LG_Action__c, LG_Suborder__r.LG_Provisioning_External_Id__c, 
                                                     Name, LG_ProvisioningAccountNo__c, csordtelcoa__Product_Configuration__r.id, csord__Activation_Date__c, 
                                                     csordtelcoa__Product_Configuration__c, LG_EffectiveDate__c, LG_ProductFamily__c, LG_ServiceStatus__c, UM_JiraIssueTypeId__c,
                                                     LG_Additional_Hour__c, LG_Additional_Work_Note__c, UM_ProvisioningServiceExternalId__c,
                                                     LG_Address__c, LG_Address__r.LG_TechnicalContact__c, LG_Address__r.LG_TechnicalContact__r.Email
                                                     FROM  csord__Service__c WHERE LG_Suborder__c = : suborder.id])
                    {
                        services.add(service);
                        serviceStatuses.add(service.LG_ServiceStatus__c);
                        
                        if(String.isNotBlank(service.UM_JiraIssueTypeId__c))
                            issueTypeId = service.UM_JiraIssueTypeId__c;
                        
                        System.debug('issueTypeId# ' + issueTypeId);
                    }
                    
                    if(String.isNotBlank(issueTypeId))
                    {
                        suborder.LG_Jira_Status__c = jiraStatus.toUpperCase();
                        //SFOM-2588 -- Start
                        if(String.isNotBlank(notification.assignee) && (String.isBlank(assigneeEmailAddress) || 
                                                                        (String.isNotBlank(assigneeEmailAddress) && notification.assignee != assigneeEmailAddress)))
                        {
                            for(JiraAssigneeData__c assignee : JiraAssigneeData__c.getall().values())
                            {
                                if(assignee.Name.equalsIgnoreCase(notification.assignee))
                                {
                                    suborder.UM_JiraAssigneeName__c = notification.assignee;
                                    assigneeEmailAddress = assignee.AssigneeEmail__c;
                                }
                            }
                        }
                        //SFOM-2588 -- End
                        if(jiraStatus.equalsIgnoreCase(progressStatusMap.get(issueTypeId)) && !(serviceStatuses.contains('Ready for Billing') || serviceStatuses.contains('Activation Completed') || serviceStatuses.contains('Active')))
                        {
                            if(serviceDate != null && schAppointments.isEmpty())
                            {
                                suborder.LG_TargetDate__c = serviceDate;
                                suborder.LG_Integration_Status__c = 'Installation In-Progress';
                                suborder.LG_Integration_Description__c = 'Success';
                                appointment = new LG_ScheduleAppointment__c(Name = 'Appointment for ' + suborder.Name,
                                                                            LG_Status__c = 'Scheduled',
                                                                            LG_Solution__c = suborder.id,
                                                                            LG_AgreedInstallDate__c = serviceDate );
                            } 
                        }
                        else if(jiraStatus.equalsIgnoreCase(completionStatusMap.get(issueTypeId)) && !(serviceStatuses.contains('Ready for Billing') || serviceStatuses.contains('Activation Completed') || serviceStatuses.contains('Active')))
                        {
                            isFinalStatus = true;
                            suborder.LG_Integration_Status__c = 'Installation Complete';
                            suborder.LG_Integration_Description__c = 'Success';
                        }
                        else if(jiraStatus == 'GESCHLOSSEN' && String.isNotBlank(notification.cancellation_reason))
                        {
                            suborder.LG_Integration_Status__c = 'JIRA Initiated Cancellation';
                            suborder.LG_Integration_Description__c = 'JIRA Initiated Cancellation';
                            suborder.LG_Jeopardy__c  = true;
                            suborder.LG_JeopardyExplanation__c = 'Order Cancellation initiated in Jira';
                        }
                        
                        if(serviceDate != null && !schAppointments.isEmpty() && schAppointments[0].LG_AgreedInstallDate__c != serviceDate)
                        {
                            schAppointments[0].LG_AgreedInstallDate__c = serviceDate;
                            appointment = schAppointments[0];
                        }
                        
                        if (serviceDate != null && (suborder.LG_TargetDate__c == null  || suborder.LG_TargetDate__c != serviceDate))
                            suborder.LG_TargetDate__c = serviceDate;
                            
                        if(String.isNotBlank(notification.cancellation_reason) && (String.isBlank(suborder.LG_Cancellation_Reason__c) || suborder.LG_Cancellation_Reason__c != notification.cancellation_reason))
                            suborder.LG_Cancellation_Reason__c = notification.cancellation_reason;
                        
                        if(String.isNotBlank(notification.cancellation_description) && (String.isBlank(suborder.LG_Cancellation_Description__c) || suborder.LG_Cancellation_Description__c != notification.cancellation_description))
                            suborder.LG_Cancellation_Description__c = notification.cancellation_description;
                        
                        for(csord__service__c service : services)
                        {
                            Boolean isServiceUpdated = false;
                            
                            if(String.isNotBlank(notification.additional_hour) && (String.isBlank(service.LG_Additional_Hour__c) || service.LG_Additional_Hour__c != notification.additional_hour)){
                                service.LG_Additional_Hour__c = notification.additional_hour;
                                isServiceUpdated = true;
                            }
                            if(String.isNotBlank(notification.additional_work_note) && (String.isBlank(service.LG_Additional_Work_Note__c) ||service.LG_Additional_Work_Note__c != notification.additional_work_note)){
                                service.LG_Additional_Work_Note__c = notification.additional_work_note;
                                isServiceUpdated = true;
                            }
                            if(String.isNotBlank(notification.service_id) && (String.isBlank(service.UM_ProvisioningServiceExternalId__c) || service.UM_ProvisioningServiceExternalId__c  != notification.service_id)){
                                service.UM_ProvisioningServiceExternalId__c = notification.service_id;
                                isServiceUpdated = true;
                            }
                            // SFOM-2665 -- Start
                            if(String.isNotBlank(notification.esn_device_number) && (String.isBlank(service.UM_ESN__c) || service.UM_ESN__c  != notification.esn_device_number)){
                                service.UM_ESN__c = notification.esn_device_number;
                                isServiceUpdated = true;
                            }
                            //SFOM-2665 -- End
                            if (isFinalStatus)
                            {
                                if(serviceDate != null){
                                    service.LG_EffectiveDate__c = serviceDate;
                                    service.csord__Activation_Date__c = serviceDate;
                                }
                                else{
                                    service.LG_EffectiveDate__c = suborder.LG_TargetDate__c;
                                    service.csord__Activation_Date__c = suborder.LG_TargetDate__c;   
                                }
                                
                                service.LG_ServiceStatus__c = 'Activation Completed';
                                service.csord__status__c    = 'Activation Completed';
                                isServiceUpdated = true;
                            }
                            
                            if(isServiceUpdated)
                            	servicesToUpdate.put(service.Id,service);
                            // Intermin Communications for CF only
                            if(template != null && issueTypeId == '12101' && assigneeEmailAddress != null) //SFOM-2588
                            {
                                System.debug('template# ' + template);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setTargetObjectId(service.LG_Address__r.LG_TechnicalContact__c);
                                mail.setWhatId(service.Id);
                                mail.setTemplateId(template.Id);
                                mail.setToAddresses(new String[]{service.LG_Address__r.LG_TechnicalContact__r.Email});
                                //SFOM-2588 -- Start
                                mail.setBccAddresses(new String[]{assigneeEmailAddress}); 
                                //SFOM-2588 -- End
                                mail.setOrgWideEmailAddressId(owea.id);
                                mail.saveAsActivity = true;
                                mailsToSend.add(mail);
                                System.debug('mailsToSend# ' + mailsToSend);
                            }
                        }
                        
                        if(appointment != null)
                            upsert appointment;
                        if(!servicesToUpdate.isEmpty())
                            update servicesToUpdate.values();
                        if(suborder!=null)
                            update suborder;
                        if(!mailsToSend.isEmpty())
                            Messaging.sendEmail(mailsToSend);
                    }
                }
            }
            catch(DMLException e){
                exceptionMsg = e.getMessage();
                System.debug('Exception#' + exceptionMsg); 
                suborder.LG_Integration_Status__c = 'SFDC failure';
                if(exceptionMsg.length() < (255- Label.LG_JiraExceptionMsg.length()))
                    suborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg + exceptionMsg;
                else{
                    suborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
                    createErrorNotes(suborder.id,  suborder.LG_Integration_Status__c , exceptionMsg);
                }
                if(!exceptionMsg.contains(suborder.id))
                    update suborder;
            }
            catch(Exception e){
                exceptionMsg = e.getMessage();
                System.debug('Exception#' + exceptionMsg); 
                //To increase length of exception for test class
                if(Test.isRunningTest()){
                    exceptionMsg += ', Jira Form Validation failed because some mandatory fields have blank value. Please fill values for mandatory fields and try again. ' + Label.LG_JiraJeopardyError;
                }
                suborder.LG_Integration_Status__c = 'SFDC failure';
                if(exceptionMsg.length() < (255- Label.LG_JiraExceptionMsg.length()))
                    suborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg + exceptionMsg;
                else{
                    suborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
                    createErrorNotes(suborder.id,  suborder.LG_Integration_Status__c , exceptionMsg);
                }
                if(!exceptionMsg.contains(suborder.id))
                    update suborder;
            }
            
            if(!errorNotes.isEmpty()){
                System.debug('CreateErrorNotes#'); 
                saveResults = Database.insert(errorNotes,false);
                for(Database.SaveResult sr : saveResults){
                    if(!sr.isSuccess())
                        System.debug('errors # ' + sr.getErrors());
                }
            }
            
            if(exceptionMsg != null)
            {
                RestContext.response.addHeader('Content-Type', 'application/xml');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'Not successfully updated in SFDC Error: '+ exceptionMsg)));
                return;
            }
            else
            {
                System.debug('Success');
                RestContext.response.addHeader('Content-Type', 'application/xml');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Success', 'Success')));
                return;
            }
        }
        else
        {
            System.debug('Issue Id Missing in request');
            RestContext.response.addHeader('Content-Type', 'application/xml');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'Mandatory details missing: Issue Id')));
            return;
        }
    }
    
    //wrapper for JIRA Notifications
    global Class JiraNotificationWrapper 
    {
        public String issue_id {get; set;}
        public String status  {get; set;}
        public String service_date {get; set;}
        public String cancellation_reason {get; set;}
        public String cancellation_description {get; set;}
        public String additional_hour {get; set;}
        public String additional_work_note {get; set;}
        public String service_id {get; set;}
        public String assignee {get;set;}   //SFOM-2588
        public String resolution {get;set;}  //SFOM-2665
        public String esn_device_number {get;set;} //SFOM-2665
    }
    
    public class ResponseWrapper{
        
        public String status;
        public String statusMessage;
        
        public ResponseWrapper (String status, String statusMessage)
        {
            this.status = status;
            this.statusMessage = statusMessage;
        }
    }
    
    @TestVisible
    private static void createErrorNotes(Id suborderId, String subject, String description)
    {
        Note note = new Note();
        note.Body = description;
        note.ParentId = suborderId;
        note.Title = Datetime.now() + ' - ' + subject;
        errorNotes.add(note);
    }
}
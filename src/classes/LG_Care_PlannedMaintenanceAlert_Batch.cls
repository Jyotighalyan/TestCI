/************************************************************************************************************************************
*        Class: LG_Care_PlannedMaintenanceAlert_Batch 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: The batch class will send email alert to the contacts who are affected / will be affected by various services
*               for a period of time.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 08-AUG-2017
*   Test Class: LG_Care_PlannedMaintenanceAlertBatchTest
*************************************************************************************************************************************/
global with sharing class LG_Care_PlannedMaintenanceAlert_Batch implements Database.Batchable<sobject> {
    String caseType = 'LG_B2B_Care_Planned_Maintenance_Request_UM';
    @testVisible List<String> exceptionMessages = new List<String>();
    String notify = Label.B2B_PlannedMaintenanceAlert_Batch_Notify_value;
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String tempCaseId = '5004E000004FLzEQAW';
       
        String query = 'SELECT id,LG_Care_Email_Sent_to_Customer_On__c,LG_Care_USMS_Service__c,CaseNumber,LG_Send_Email_To_Decision_Maker__c,LG_Choose_Specific_Role__c,LG_Care_Down_Time_in_Minutes__c,LG_Estimated_resolution_time__c,LG_Estimated_Start_Time__c'+
            ' FROM Case'+
            ' WHERE RecordType.DeveloperName = :caseType AND LG_Mailing_Date__c = today AND LG_Notify_Customers__c = :notify ';
        return Database.getQueryLocator(query);
        
    } 
    
    global void execute(Database.BatchableContext BC, list<Case> plannedMaintenenceCases) {
        try{
            system.debug('Cases@#'+plannedMaintenenceCases);
            List<Case> hpbxCase= new List<Case>();
            List<Case> plannedMCase= new List<Case>();
            Map<Id,Case> plannedMaintenenceCasesMap = new map<Id,Case>(plannedMCase);
            List<Id> caseIds = new List<Id>();
            caseIds.addAll(plannedMaintenenceCasesMap.keySet());
            Set<String> serviceIds = new Set<String>();
            Set<String> serviceIdsTemp = new Set<String>();
            Set<String> serviceTypes = new Set<String>();
            Set<String> streets = new Set<String>();
            Set<String> cities = new Set<String>();
            Set<String> postCodes = new Set<String>();
            Set<String> houseNumber = new Set<String>();
            Set<String> houseNumberExtension = new Set<String>();
            
            Set<String> customerNumbers = new Set<String>();
            Set<String> equipmentId = new Set<String>();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();     
            /* Hpbx Code Added */  
            if(plannedMaintenenceCases[0].LG_Care_USMS_Service__c==Label.B2B_Care_Planned_Maintenance_Hpbx) {
            for(csord__Service__c Ser : [SELECT id,Name,csord__Subscription__c,csord__Subscription__r.csord__Account__c from csord__Service__c where LG_ProductFamily__c='Virtual Voice' AND LG_ServiceStatus__c='Active'])
                {
             
                serviceIds.add(Ser.id);
                }
            }
            system.debug('hpbx services'+serviceIds);    
           
            for(Service_Impacted__c li: [SELECT id,LG_Care_Service_Record_Id__c,LG_Care_Customer_Number__c,LG_B2B_Care_Equipment_id__c,B2B_Postcode__c,B2B_Case_Number__c,B2B_City__c,B2B_Service_Category__c,B2B_Service_Id__c,B2B_Street__c,LG_Care_House_Number__c,LG_Care_House_Number_Extension__c
                                         FROM Service_Impacted__c
                                         WHERE B2B_Case_Number__c IN :caseIds])
            {
                if(li.LG_Care_Service_Record_Id__c != null && li.LG_Care_Service_Record_Id__c != '') {
                    serviceIds.add(li.LG_Care_Service_Record_Id__c);
                }
                else if(li.B2B_Service_Id__c != Null && li.B2B_Service_Id__c != '') {
                    serviceIdsTemp.add(li.B2B_Service_Id__c);
                }
                else if(li.LG_B2B_Care_Equipment_id__c != null) {
                    equipmentId.add(li.LG_B2B_Care_Equipment_id__c);
                }
                else if(li.LG_Care_Customer_Number__c != null) {
                    customerNumbers.add(li.LG_Care_Customer_Number__c);
                }
                else {
                    
                    if(li.B2B_Street__c != Null) {
                        streets.add(li.B2B_Street__c + '%');
                    } 
                    if(li.B2B_City__c != Null) {
                        cities.add(li.B2B_City__c + '%');
                    }
                    if(li.B2B_Postcode__c != Null) {
                        postCodes.add(li.B2B_Postcode__c + '%');
                    }
                    if(li.LG_Care_House_Number__c != Null) {
                        houseNumber.add(li.LG_Care_House_Number__c + '%');
                    }
                    if(li.LG_Care_House_Number_Extension__c != Null) {
                        houseNumberExtension.add(li.LG_Care_House_Number_Extension__c + '%');
                    }
                    
                }
            }
            Map<Id,List<String>> subMapAddress = new Map<Id,List<String>>();
            Set<Id> accountIds = new Set<Id>();
            for(csord__Service__c service : [SELECT LG_ServiceStatus__c,LG_ServiceExternalId__c,Id,LG_Address__r.LG_FullAddressDetails__c,csord__Subscription__c FROM csord__Service__c WHERE LG_Address__c in ( SELECT id
                                                                                                                                                                                                                FROM cscrm__Address__c
                                                                                                                                                                                                                WHERE cscrm__Street__c LIKE : streets OR cscrm__City__c LIKE : cities OR
                                                                                                                                                                                                                cscrm__Zip_Postal_Code__c LIKE : postCodes OR LG_HouseNumber__c LIKE : houseNumber OR
                                                                                                                                                                                                                LG_HouseNumberExtension__c LIKE : houseNumberExtension)])
            {
                if(service.LG_ServiceExternalId__c != Null && service.Id != null && service.LG_ServiceStatus__c == 'Active') {
                    serviceIds.add(service.Id);
                }                
            }
            
            if(serviceIdsTemp.size()>0 || customerNumbers.size()>0) {
                for(csord__Service__c service : [SELECT LG_ServiceStatus__c,LG_ServiceExternalId__c FROM csord__Service__c WHERE LG_ServiceStatus__c = 'Active' AND (LG_ServiceExternalId__c in :serviceIdsTemp OR LG_ProvisioningAccountNo__c in :customerNumbers)]) {
                    
                    serviceIds.add(service.Id);
                    
                }   
            }
            
            if(equipmentId.size()>0) {
                 for(Asset ass :[SELECT Id, csord__Service__c, LG_MACAddress__c  FROM Asset WHERE LG_MACAddress__c IN :equipmentId] ) {
                     serviceIds.add(ass.csord__Service__c);
                 }
            }
            
            for(csord__Service__c service: [SELECT Id,LG_Care_Full_Address__c,csord__Subscription__c FROM csord__Service__c WHERE id in : serviceIds]) {
                if(subMapAddress.containsKey(service.csord__Subscription__c)){
                    List<String> temp = subMapAddress.get(service.csord__Subscription__c);
                    temp.add(service.LG_Care_Full_Address__c);
                    subMapAddress.put(service.csord__Subscription__c, temp);
                }
                else
                    subMapAddress.put(service.csord__Subscription__c, new List<String>{service.LG_Care_Full_Address__c});
                
            }
            
            //Creating a Map for mapping Subscription and (Account)
            Map<Id,Id> subMapAcc = new Map<Id,Id>(); 
            Map<Id,csord__Subscription__c> subIdMapSubDetails = new Map<Id,csord__Subscription__c>();
            for(csord__Subscription__c subscription: [SELECT csord__Account__c,csconta__Billing_Account__r.LG_BillingAccountNumber__c, csord__Account__r.LG_AccountNumber__c FROM csord__Subscription__c WHERE Id in (SELECT csord__Subscription__c FROM 
                                                                                                                                                                                                                      csord__Service__c WHERE Id in : serviceIds)]) 
            {
                if(subscription.csord__Account__c != Null) {
                    accountIds.add(subscription.csord__Account__c);
                    //Mapping of Sub Id vs Info about Account
                    subMapAcc.put(subscription.Id, subscription.csord__Account__c);
                    subIdMapSubDetails.put(subscription.Id, subscription);
                }
            }
            
            //Find appropriate contacts
            String query = 'SELECT Id,name,Salutation,lastName,LG_Contact_Account_No__c,AccountId from Contact where accountId IN :accountIds and Email != null and HasOptedOutOfEmail = false';
            
            Case plannedMaintenenceCase = plannedMaintenenceCases[0];
            if(plannedMaintenenceCase.LG_Send_Email_To_Decision_Maker__c){
                query +=' and LG_DecisionMaker__c = true';
            }
            
            List<String> roles = new List<String>();
            if(String.isNotBlank(plannedMaintenenceCase.LG_Choose_Specific_Role__c)){
                roles.addAll(plannedMaintenenceCase.LG_Choose_Specific_Role__c.split(';'));
            }
            
            String contactRoles ='';
            for(String role : roles){
                contactRoles += '\''+ role + '\''+',';
            }
            if(contactRoles.lastIndexOf(',')!=-1){
                contactRoles = contactRoles.removeEnd(',');
            }
            if(String.isNotBlank(contactRoles)){
                query +=' and LG_Role__c includes ('+contactRoles+') ';
            }
            // Add the contacts with a link with the Accounts like a Map. We have all the affected serviceIds. We can get the 
            // full address and accountNumber and Billing Account Number. All in all the linking point will be account ID.
            
            
            //Mapping Contact and Accounts
            List<Contact> contacts = Database.query(query);
            system.debug('hpbx contacts'+ contacts);
            Map<Id,List<Contact>> accIdMapContacts = new Map<Id,List<Contact>>();
            for(Id accId :accountIds) {
                for(Contact con :contacts) {
                    if(con.AccountId == accId && accIdMapContacts.containsKey(accId)) {
                        List<Contact> c = accIdMapContacts.get(accId);
                        c.add(con);
                        accIdMapContacts.put(accId, c);
                    }
                    else if(con.AccountId == accId && !(accIdMapContacts.containsKey(accId))) {
                        accIdMapContacts.put(accId, new List<Contact>{con});
                    }
                }
            }
            
            //Mapping subId vs Contacts
            Map<Id,List<Contact>> subIdMapContacts = new Map<Id,List<Contact>>();
            for(Id subId :subMapAcc.keySet()) {
                if(accIdMapContacts.keySet().contains(subMapAcc.get(subId))) {
                    subIdMapContacts.put(subId, accIdMapContacts.get(subMapAcc.get(subId))); 
                }
            }
            //Mapping of Contacts vs Different Infos. Mapping is one to many.
            
            Map<String,String> conChildMap;
            Map<Contact,List<Map<String,String>>> conMapAll = new Map<Contact,List<Map<String,String>>>();
            for(Id subId :subIdMapContacts.keySet()) {
                if(subIdMapSubDetails.keySet().contains(subId) && subMapAddress.keySet().contains(subId)) {
                    for(Contact con: subIdMapContacts.get(subId)) {
                        for(String add :subMapAddress.get(subId)){
                            conChildMap = new Map<string,string>();
                            if(subIdMapSubDetails.get(subId).csord__Account__r.LG_AccountNumber__c == null || subIdMapSubDetails.get(subId).csord__Account__r.LG_AccountNumber__c.trim() == '') {
                                conChildMap.put('AccountNumber',' ');
                            }
                            else {
                                conChildMap.put('AccountNumber', subIdMapSubDetails.get(subId).csord__Account__r.LG_AccountNumber__c);
                            }
                            if(subIdMapSubDetails.get(subId).csconta__Billing_Account__r.LG_BillingAccountNumber__c == null || subIdMapSubDetails.get(subId).csconta__Billing_Account__r.LG_BillingAccountNumber__c.trim() == '') {
                                conChildMap.put('BANumber',' ');
                            }
                            else {
                                conChildMap.put('BANumber', subIdMapSubDetails.get(subId).csconta__Billing_Account__r.LG_BillingAccountNumber__c);    
                            }
                            if(add == null || add.trim() == ''){
                                conChildMap.put('FullAddress',' ');
                            }
                            else {
                                conChildMap.put('FullAddress', add);
                            }
                            
                            if(conMapAll.containsKey(con)) {
                                List<Map<String,String>> temp = conMapAll.get(con);
                                temp.add(conChildMap);
                                conMapAll.put(con, temp);
                            }
                            else {
                                List<Map<String,String>> temp = new List<Map<String,String>>();
                                temp.add(conChildMap);
                                conMapAll.put(con,temp);
                            }
                        }
                    }
                }
            }
            
            
     
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply_care@unitymedia.de'];
            EmailTemplate et=[Select id,HtmlValue,Body,Subject from EmailTemplate where DeveloperName = 'B2B_Planned_Maintenance_Notification_Custom' limit 1];
            EmailTemplate etHpbx=[Select id,HtmlValue,Body,Subject from EmailTemplate where DeveloperName = 'B2B_Care_Planned_Maintainance_Hpbx_Custom' limit 1];
      
            String bodyOfTemplate = et.HtmlValue;
            String bodyofTemplateHpbx=etHpbx.HtmlValue;
            for(Contact con: contacts) {
                for(Map<String,String> m :conMapAll.get(con)) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(owea.size() > 0)
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    if(plannedMaintenenceCases[0].LG_Care_USMS_Service__c==Label.B2B_Care_Planned_Maintenance_Hpbx)
                    {
                    system.debug('inside if');
                    mail.setSubject(Label.B2B_Care_Planned_Maintenance_Sub);
                    mail.setTargetObjectId(con.Id);
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(etHpbx.Id);
                    String temp = null;
                    
                    temp = bodyofTemplateHpbx.replace('$AccountNumber$',m.get('AccountNumber'));
                    temp = temp.replace('$BillingAccNumber$',m.get('BANumber'));
                    if(con.salutation.equalsIgnoreCase('Mr.')) {
                        temp = temp.replace('$Salutation$','Herr');        
                    }
                    else if(con.salutation.equalsIgnoreCase('Ms.')) {
                        temp = temp.replace('$Salutation$','Frau');        
                    }
                    else
                        temp = temp.replace('$Salutation$','Sehr geehrte');
                    temp = temp.replace('$LastName$',con.lastName);
                    String startTime = String.ValueOf(plannedMaintenenceCases[0].LG_Estimated_Start_Time__c.format('dd.MM.YYYY,HH:MM'));
                    temp = temp.replace('$StartTime$',startTime);
                    String endTime = String.ValueOf(plannedMaintenenceCases[0].LG_Estimated_resolution_time__c.format('dd.MM.YYYY,HH:MM'));
                    temp = temp.replace('$EndTime$',endTime);
                    temp = temp.replace('$FullAddress$',m.get('FullAddress'));
                    Integer d = Integer.valueOf(plannedMaintenenceCases[0].LG_Care_Down_Time_in_Minutes__c);
                    String duration = String.ValueOf(d);
                    temp = temp.replace('$EstimatedDuration$',duration);
                    mail.setHtmlBody(temp);
                    system.debug('inside if'+mail);
                    //mail.setHTMLBody(getHTMLTemplate(plannedMaintenenceCases[0], con, m));
                    mails.add(mail);    
                }
                
                else{
                     system.debug('inside else');
                    mail.setSubject(Label.B2B_Care_Planned_Maintenance_Sub);
                    mail.setTargetObjectId(con.Id);
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(et.Id);
                    String temp = null;
                    system.debug('inside else2');
                    temp = bodyOfTemplate.replace('$AccountNumber$',m.get('AccountNumber'));
                    temp = temp.replace('$BillingAccNumber$',m.get('BANumber'));
                    if(con.salutation.equalsIgnoreCase('Mr.')) {
                        temp = temp.replace('$Salutation$','Herr');        
                    }
                    else if(con.salutation.equalsIgnoreCase('Ms.')) {
                        temp = temp.replace('$Salutation$','Frau');        
                    }
                    else
                    temp = temp.replace('$Salutation$','Sehr geehrte');
                    temp = temp.replace('$LastName$',con.lastName);
                    String startTime = String.ValueOf(plannedMaintenenceCases[0].LG_Estimated_Start_Time__c.format());
                    temp = temp.replace('$StartTime$',startTime);
                    String endTime = String.ValueOf(plannedMaintenenceCases[0].LG_Estimated_resolution_time__c.format());
                    temp = temp.replace('$EndTime$',endTime);
                    temp = temp.replace('$FullAddress$',m.get('FullAddress'));
                    Integer d = Integer.valueOf(plannedMaintenenceCases[0].LG_Care_Down_Time_in_Minutes__c);
                    String duration = String.ValueOf(d);
                    temp = temp.replace('$EstimatedDuration$',duration);
                    mail.setHtmlBody(temp);
                    
                    //mail.setHTMLBody(getHTMLTemplate(plannedMaintenenceCases[0], con, m));
                    mails.add(mail); 
                
                
                system.debug('inside else'+mails);
                
                
                }
                }
                //mail.setWhatId(caseIds[0]);
                // mail.setHTMLBody(getHTMLTemplate(plannedMaintenenceCases[0], con, conMapAll.get(con)));
                //mail.setTemplateId(templateId.Id);
                
            } 
            system.debug('Email Final'+ mails);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(mails,false);
            Boolean flag = false;
            for(Messaging.SendEmailResult r :results) {
                if(!r.isSuccess()) {
                    
                    // Do something with r.getErrors()
                }
                else {
                    flag = true;
                }
            }
            if(flag) {
                plannedMaintenenceCases[0].LG_Care_Email_Sent_to_Customer_On__c = DateTime.Now();
                Database.update(plannedMaintenenceCases[0]);
            }
        }
        Catch(Exception e) {/*
String msg = e.getMessage();
exceptionMessages.add(msg);*/
            //We can send a mail to an admin informing him/her about the exceptions.
        }
    }
    /*
private static String getHTMLTemplate(Case c, Contact con, Map<string,string> conDetails) {

String headerURL = Label.B2B_Care_batch_email_header;
String template = '<Html>' +

'<body>' +
'<div>'+

'<style type="text/css"> '+
'.col {'+
'+border-right: 1px solid #000;'+
'}'+
'</style>'+

'<div >' +
'<img src="'+headerURL+'" >'+
'</br>'+
'<p style="text-align: right;">Ihre Rahmenvertragsnummer: '+conDetails.get('AccountNumber')+'</p>'+
'<p style="text-align: right;">Ihre Kundennummer: '+conDetails.get('BANumber')+'</p>'+
'<p style="text-align: justify;">Guten Tag  '+con.Salutation+'&nbsp;'+con.lastName+',</p>'+
'<p style="text-align: justify;">&nbsp;&nbsp;</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">In der Zeit <strong>von '+c.LG_Estimated_Start_Time__c+' Uhr bis '+c.LG_Estimated_resolution_time__c+' Uhr </strong>finden Wartungsarbeiten statt.<strong> Daher </strong>kann es an Ihrem Anschluss <strong>'+conDetails.get('FullAddress')+'</strong> zu einem Totalausfall von ca. <strong>'+c.LG_PM_Estimated_Duration__c+'</strong> Stunden bei Ihren Diensten kommen. W&auml;hrend der Unterbrechungen k&ouml;nnen Sie keine Telefon- und Internetdienste nutzen. Notrufe k&ouml;nnen dann nur mobil abgesetzt werden.<br /> <br /> Wir bedauern die Unannehmlichkeiten und bitten um Ihr Verst&auml;ndnis.&nbsp;</p>'+
'<p style="text-align: justify;">Sollten Sie Fragen haben, rufen Sie uns einfach an. Sie erreichen uns unter der Rufnummer 0800 141 299 99 &ndash; Mo - Fr von 8 bis 20 Uhr und Sa 8 bis 16 Uhr. Sie erreichen uns auch per E-Mail an <a href="mailto:Enterprise.Service@unitymedia.de">Enterprise.Service@unitymedia.de</a>.</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">Mit freundlichen Gr&uuml;&szlig;en</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">Unitymedia Business Team</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;">Tel.: 0800 141 299 99</p>'+
'<p style="text-align: justify;">Fax: 0800 888 87 10</p>'+
'<p style="text-align: justify;">&nbsp;</p>'+
'<p style="text-align: justify;"><a href="http://www.unitymedia.de/business">www.unitymedia.de/business</a></p>'+

'<p ><span style=\'font-size:10.0pt;font-family:"Arial",sans-serif\'><o:p>&nbsp;</o:p></span></p>'+ 

'<p ><span style=\'font-size:10.0pt;font-family:"Arial",sans-serif\'><o:p>&nbsp;</o:p></span></p>'+ 

'<p ><span style=\'font-size:10.0pt;font-family:"Arial",sans-serif\'><o:p>&nbsp;</o:p></span></p>'+ 


'<table style="height: 100%; float: left;" width="100%">'+
'<tbody>'+
'<tr>'+
'<td class="col" style="width: 202px;">'+
'<p><strong>Unitymedia NRW GmbH</strong></p>'+
'</td>'+
'<td class="col" style="width: 240px;">'+
'<p><strong>Unitymedia</strong><strong> Hessen GmbH &amp; Co. KG</strong></p>'+
'</td>'+
'<td class="col" style="width: 191px;">'+
'<p><strong>Unitymedia BW GmbH</strong></p>'+
'</td>'+
'</tr>'+
'<tr>'+
'<td class="col" style="width: 202px;">'+
'<p>Unitymedia Business Service</p>'+
'<p>Postfach 45 12 04</p>'+
'<p>50887 K&ouml;ln</p>'+
'</td>'+
'<td class="col" style="width: 240px;">'+
'<p>Unitymedia Business Service</p>'+
'<p>Postfach 45 12 04</p>'+
'<p>50887 K&ouml;ln</p>'+
'</td>'+
'<td class="col" style="width: 191px;">'+
'<p>Unitymedia Business Service</p>'+
'<p> Postfach 9001 31</p>'+
'<p>75090 Pforzheim</p>'+
'</td>'+
'</tr>'+
'<tr>'+
'<td class="col" style="width: 202px;">'+
'<p>Handelsregister:</p>'+
'<p>Amtsgericht K&ouml;ln HRB 83533</p>'+
'</td>'+
'<td class="col" style="width: 240px;">'+
'<p>Handelsregister:</p>'+
'<p>Amtsgericht K&ouml;ln HRA 24116</p>'+
'</td>'+
'<td class="col" style="width: 191px;">'+
'<p>Handelsregister:</p>'+
'<p>Amtsgericht K&ouml;ln HRB 83533</p>'+
'</td>'+
'</tr>'+
'<tr>'+
'<td class="col" style="width: 633px;" colspan="3">'+
'<p>&nbsp;</p>'+
'<p style="text-align: justify;">Gesch&auml;ftsf&uuml;hrer: Lutz Sch&uuml;ler (Vorsitzender) | Gudrun Scharler | Christian Hindennach | Dr. Herbert Leifker | Winfried Rapp</p>'+
'</td>'+
'</tr>'+
'</tbody>'+
'</table>'+


'<p ><span style=\'font-size:10.0pt;font-family:"Arial",sans-serif\'><o:p>&nbsp;</o:p></span></p>'+ 

'<p ><span style=\'font-size:10.0pt;font-family:"Arial",sans-serif\'><o:p>&nbsp;</o:p></span></p>'+ 

'</div>'+ 
'</div>'+
'</body>'+ 

'</html> ';
return template;
}
*/
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply_care@unitymedia.de'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(owea.size() > 0)
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
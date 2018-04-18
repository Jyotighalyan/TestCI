/* **********************************************************************************************************************************************
 * Description: This class performs below two requirements:
 *                
                    1. After 24 hours (on working days) of lead Assignment, an email reminder for all inbound leads (web, phone leads) 
                       will be sent to the lead owner in case the last lead status change date was not changed
                    2. After 3 working days of lead Assignment, the lead will be withdrawn and dispatched to the corresponding director 
                       for all inbound leads (see above) in case the last lead status change date was not changed.
 *              -----------------------------------------------------------------------------------------------
 * 
 * Date: 8th Mar 2018
 * 
 * Auther: Amit Senapati <amit_senapati01@infosys.com>
 *
 * **********************************************************************************************************************************************
 */

global class sendReminderToLeadOwner implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    global final Date beforeOneDay;
    global final Date beforeThreeDay; 
    global final String query;
    Boolean haveNull = false;
    Lead_Assignment_Table__c  leadAssignTonPFnPCNull;
    
    List<Lead> reminderLeadList = new List<Lead>();
    List<Lead> withdrawLeadList = new List<Lead>();
    List<Lead_Assignment_Table__c>  LATList = new List<Lead_Assignment_Table__c>();
    List<Lead> updateLead = new List<Lead>();
    
    Set<String> prodFamilySet = new Set<String>();
    Set<String> postalCodeSet = new Set<String>();
    
    Map<String, List<Lead_Assignment_Table__c>> prodFAndleadATMap = new Map<String, List<Lead_Assignment_Table__c>>();
    Map<String, Lead_Assignment_Table__c> postalCodeAndleadATMap = new Map<String, Lead_Assignment_Table__c>();
    
    global sendReminderToLeadOwner(){
        Date myDay = Date.today();
        Date refDate = Date.newInstance(1900, 1, 7);
        /********** START: Considering only Working Days (Monday to Friday) *************/
        if(math.mod(refDate.daysBetween(myDay),7) == 1){
            beforeOneDay = Date.today().addDays(-3);
            beforeThreeDay = Date.today().addDays(-5);
        }
        else if(math.mod(refDate.daysBetween(myDay),7) == 2 || math.mod(refDate.daysBetween(myDay),7) == 3){
            beforeOneDay = Date.today().addDays(-1);
            beforeThreeDay = Date.today().addDays(-5);
        }
        else{ 
            beforeOneDay = Date.today().addDays(-1);
            beforeThreeDay = Date.today().addDays(-3);
        }
        System.debug('beforeOneDay::'+beforeOneDay+'---->beforeThreeDay::'+beforeThreeDay);
        /******************************  END ********************************************/        
        query = 'SELECT id, Owner.Name, Owner.Email, Name, Assigned_Date__c,UM_Product__c, LG_VisitPostalCode__c, LG_Last_Lead_Status_Change_Date__c FROM Lead WHERE (Assigned_Date__c =: beforeOneDay OR Assigned_Date__c =: beforeThreeDay) AND IsConverted = FALSE';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> leadList){
        System.debug('Inside Execute');        
        for(Lead lead: leadList){
            /**** Preparing List of Lead to whom a reminder will be send *****
            * Here, the condition is: Lead Assign Date is YESTERDAY and The Last Lead Status Change Date is not TODAY or YESTERDAY **/
            if(lead.Assigned_Date__c == beforeOneDay && (lead.LG_Last_Lead_Status_Change_Date__c != beforeOneDay || lead.LG_Last_Lead_Status_Change_Date__c != Date.today())){
                reminderLeadList.add(lead);
            }
            /**** Preparing List of Lead which will be dispatched to corresponding Director *****
            * Here, the condition is: Lead Assign Date is TODAY()-3 and The Last Lead Status Change Date is older than TODAY-3 **/
            else if(lead.Assigned_Date__c == beforeThreeDay && lead.LG_Last_Lead_Status_Change_Date__c <= beforeThreeDay){
                withdrawLeadList.add(lead);
                if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c == NULL){
               	 	haveNull = true;
            	}	
                else if(lead.UM_Product__c != NULL){
                    prodFamilySet.add(lead.UM_Product__c);
                }
                else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c != NULL){
                    String postalcode = lead.LG_VisitPostalCode__c.substring(0, 3);
                    postalCodeSet.add(postalcode);
                }
            }
        }
        System.debug('reminderLeadList size::'+reminderLeadList.size()+'-->withdrawLeadList size::'+withdrawLeadList.size());
        System.debug('prodFamilySet ::'+prodFamilySet+'---->postalCodeSet ::'+postalCodeSet);
        // Querying required records from Lead Assignment Table (LAT)
        if(haveNull && (prodFamilySet.size() > 0 || postalCodeSet.size() > 0)){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c = NULL AND Postal_Code__c = NULL)
                       OR Product_Family__c IN :prodFamilySet OR Postal_Code__c IN :postalCodeSet];
        }
        else if(haveNull){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c = NULL AND Postal_Code__c = NULL)];
        }
        else if(prodFamilySet.size() > 0 || postalCodeSet.size() > 0){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c IN :prodFamilySet OR Postal_Code__c IN :postalCodeSet)];
        }
        System.debug('LATList::'+LATList.size()+'-->'+LATList);
        
        // Preparing Product Family map where KEY=Product Family & VALUE=record from LAT And Postal code map where KEY=Postal code & VALUE= record from LAT     
            for(Lead_Assignment_Table__c leadAssignT : LATList){
                List<Lead_Assignment_Table__c> ltList = new List<Lead_Assignment_Table__c>();
                if(leadAssignT.Product_Family__c != NULL){
                    if(prodFAndleadATMap.get(leadAssignT.Product_Family__c) != null){
                        ltList.add(leadAssignT);
                        ltList.addAll(prodFAndleadATMap.get(leadAssignT.Product_Family__c));
                        prodFAndleadATMap.put(leadAssignT.Product_Family__c, ltList);
                    }
                    else{
                        ltList.add(leadAssignT);
                        prodFAndleadATMap.put(leadAssignT.Product_Family__c, ltList);
                    }
                }
                else if(leadAssignT.Product_Family__c == NULL && leadAssignT.Postal_Code__c != NULL){
                    postalCodeAndleadATMap.put(leadAssignT.Postal_Code__c, leadAssignT);
                }
                else{
                    //system.debug('Inside else::'+leadAssignT);
                    leadAssignTonPFnPCNull = leadAssignT;
                }
            }
        System.debug('prodFAndleadATMap:'+prodFAndleadATMap.size()+' prodFAndleadATMap'+prodFAndleadATMap);
        
        for(Lead lead: withdrawLeadList){
            //System.debug('inside for');
            // Dispatching the leads to the corresponding Director according the Lead Assignmnet table considering Product Family and Postal code
            if(prodFAndleadATMap.size()>0 || postalCodeAndleadATMap.size()>0 || leadAssignTonPFnPCNull != NULL){
                if(lead.UM_Product__c != NULL && prodFAndleadATMap.containsKey(lead.UM_Product__c)){
                    System.debug('Inside if::'+prodFAndleadATMap.get(lead.UM_Product__c).size());
                    // for distinct Product Family
                    if(prodFAndleadATMap.get(lead.UM_Product__c).size() == 1){
                        if(prodFAndleadATMap.get(lead.UM_Product__c)[0].Lead_Assignee__c != NULL){
                            lead.OwnerId = prodFAndleadATMap.get(lead.UM_Product__c)[0].Lead_Assignee__c;
                            lead.LeadAssignmentErrorMsg__c = '';
                            lead.Withdrawn__c = TRUE;
                            updateLead.add(lead);
                            system.debug('Only 1:'+updateLead.size());
                        }
                        else{
                            lead.LeadAssignmentErrorMsg__c = 'Director is not available in the master table';
                            updateLead.add(lead);
                            system.debug('Else');
                        }
                    }
                    // multiple Product Family of same type with different postal code 
                    else{
                        for(Lead_Assignment_Table__c LAT : prodFAndleadATMap.get(lead.UM_Product__c)){
                            if(lead.LG_VisitPostalCode__c.substring(0, 3) == LAT.Postal_Code__c){
                                if(LAT.Lead_Assignee__c != NULL){
                                    lead.OwnerId = LAT.Lead_Assignee__c;
                                    lead.LeadAssignmentErrorMsg__c = '';
                                    lead.Withdrawn__c = TRUE;
                                    system.debug('LeadPC:'+lead.LG_VisitPostalCode__c.substring(0, 3));
                                    break;
                                }
                                else{
                                    lead.LeadAssignmentErrorMsg__c = 'Director is not available in the master table';
                                    break;
                                }
                            }
                            else{
                                    lead.LeadAssignmentErrorMsg__c = 'Lead Postal Code is not available in the master table';
                            }
                        }
                        updateLead.add(lead);
                    }
                }
                // When Product Family is Null but Have postal code
                else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c != NULL && postalCodeAndleadATMap.containsKey(lead.LG_VisitPostalCode__c.substring(0, 3))){
                    if(postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Lead_Assignee__c != NULL){
                        lead.OwnerId = postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Lead_Assignee__c;
                        lead.LeadAssignmentErrorMsg__c = '';
                        lead.Withdrawn__c = TRUE;
                        updateLead.add(lead);
                    }
                    else{
                        lead.LeadAssignmentErrorMsg__c = 'Director is not available in the master table';
                    }
                }
                else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c == NULL){
                    if(leadAssignTonPFnPCNull.Lead_Assignee__c != NULL){
                        lead.OwnerId = leadAssignTonPFnPCNull.Lead_Assignee__c;
                        lead.LeadAssignmentErrorMsg__c = '';
                        lead.Withdrawn__c = TRUE;
                        updateLead.add(lead);
                    }
                    else{
                        lead.LeadAssignmentErrorMsg__c = 'Director is not available in the master table';
                        updateLead.add(lead);
                    }
                }
            }
            else{
                lead.LeadAssignmentErrorMsg__c = 'No data found in the master table';
                updateLead.add(lead);
                System.debug('DNF');
            }
        }
        update updateLead;     
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('list Size::'+reminderLeadList.size());
        // sending reminder mails to the Lead owner
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        //fetching email body from custom setting.
        Queue_Name__c eBody = Queue_Name__c.getInstance('EmailBody');
        String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        try{
            for(Lead lead: reminderLeadList){
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                
                String[] toAddress = new List<String>();
                toAddress.add(lead.Owner.Email);
                
                String body = '<html lang="ja"><body>'+
                    'Guten Tag '+lead.Owner.Name+','+
                    '<br><br>'+eBody.EmailBodyPartOne__c+' '+'<b><i>'+lead.Name+'</i></b>'+' '+eBody.EmailBodyPartTwo__c+
                    '<br><br><a href="' + baseURL + '/' + lead.Id + '" target="_blank"><u>Lead Link</u></a>'+
                    '<br><br><br>'+'Ihr Unitymedia B2B Sales Strategy & Operations Team';
                
                email.setToAddresses(toAddress);
                email.setHtmlBody(body);
                email.setSubject('Sanfte Erinnerung | Lead:'+lead.Name+'; Ausstehend für deine Aktion!!'); // business will provide Subject Line
                
                emailList.add(email);
            }
            for(Lead lead: withdrawLeadList){
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                
                String[] toAddress = new List<String>();
                toAddress.add(lead.Owner.Email);
                
                String body = '<html lang="ja"><body>'+
                    'Guten Tag '+lead.Owner.Name+','+
                    '<br><br>'+eBody.EmailBodyPartOne__c+' '+'<b><i>'+lead.Name+'</i></b>'+' '+eBody.EmailBodyPartTwo__c+
                    '<br><br><a href="' + baseURL + '/' + lead.Id + '" target="_blank"><u>Lead Link</u></a>'+
                    '<br><br><br>'+'Ihr Unitymedia B2B Sales Strategy & Operations Team';
                
                email.setToAddresses(toAddress);
                email.setHtmlBody(body);
                email.setSubject('Sanfte Erinnerung | Lead:'+lead.Name+'; Ausstehend für deine Aktion!!'); // business will provide Subject Line
                
                emailList.add(email);
            }
            Messaging.sendEmail(emailList);
        }
        catch(Exception e){
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            // fetching admin email id from Custom setting named "Queue Name"
            String adminEmailID = Queue_Name__c.getInstance('AdminEmailID').Admin_Email_ID__c;
            String[] toAddress = new List<String>();
            toAddress.add(adminEmailID);
            
            String body = '<html lang="ja"><body>'+
                'Hi Admin'+
                '<br><br>'+'There is some error occured while sending reminder emails to the lead owners.'+
                '<br><br><b>'+'Error Message::'+e.getMessage()+'</b>'+
                '<br><br>'+'Please have a look into this.'+
                '<br><br><br>'+'Thanks';
            
            email.setToAddresses(toAddress);
            email.setHtmlBody(body);
            email.setSubject('Error: Sending Reminder Emails Failed !!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }
    
    global void execute(SchedulableContext sc) {
        sendReminderToLeadOwner b1 = new sendReminderToLeadOwner();
        ID batchprocessid = Database.executeBatch(b1);           
    }
}
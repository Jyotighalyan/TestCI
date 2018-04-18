/************************************************************************************************************************************
*        Class: LG_CreateCase
*     Program : B2B SELF CARE PROGRAM
*  Description: We expose this class as REST Service to perform CREATE operation on Case object.
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_CreateCaseTest
*************************************************************************************************************************************/

@RestResource(urlMapping='/createCase/*')
global class LG_CreateCase { 
    RestRequest req = RestContext.request;
    
    @HttpPost  
    global static void createNewcase(string caseOrigin, string description, String accountNumber, string priority,Id contactId,Id recordTypeId,Id billingAccountId,Id serviceId,Id invoiceId,string caseReason,string caseType,string changeEffectiveDate,string name,String email,string phone){
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        res.statusCode=200;
        String jsonResponse = '';
        
        try{
           system.debug('inside try');
           string  techRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Technical_Request_UM'].id ;
           string  billingRectypeIds=[select id from recordType where sObjectType='case' and  developerName='LG_B2B_Care_Online_Billing_Request_UM'].id ;
           string  adminRectypeIds= [select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Admin_Change_Request_UM' ].id;
           string  genralrectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_General_Query_Request_UM'].id;
           string  complaintRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Complaint_Request_UM'].id; 
           string  maintainenceRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Planned_Maintenance_Request_UM'].id; 
           string  outageRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Mass_Outage_Request_UM'].id; 
           string  slaRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_SLA_Breach_Request_UM'].id;
           string  serviceRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Service_Change_Request_UM'].id;
           string  billingQueryRectypeIds =[select id from recordType where sObjectType='case' and developerName='B2B_Care_Billing_Query_Request_UM'].id;
            
            Case c = new Case();
                if(string.isEmpty(priority)){
                    
                   c.Priority='High';
                }
                else{
                    c.Priority=priority;
                }
            system.debug('before if---');
            system.debug('recordTypeId---'+recordTypeId);
                if(recordTypeId==techRectypeIds|| recordTypeId==billingQueryRectypeIds || recordTypeId==billingRectypeIds || recordTypeId== adminRectypeIds || recordTypeId==genralrectypeIds  || recordTypeId==maintainenceRectypeIds  || recordTypeId==outageRectypeIds  || recordTypeId==slaRectypeIds || recordTypeId==serviceRectypeIds || recordTypeId==complaintRectypeIds ){
                    system.debug('inside if---');
                    c.RecordTypeId = recordTypeId;
                    
                }else{
                res.statusCode = 400;
                jsonResponse = Json.serialize('Record type Id field is empty or invalid');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
                }
            
            c.Description = description;
            c.ContactId = contactId;
			Set<String> picklistOptions = new Set<String>();  //case origin code starts
			List<Schema.PicklistEntry> picklistvalues = Case.getSObjectType().getDescribe().fields.getMap().get('Origin').getDescribe().getPickListValues();
		    for(Schema.PicklistEntry pValues: picklistvalues)
            {
              picklistOptions.add(pValues.getLabel());  
            }
            if(!picklistOptions.contains(caseOrigin) || String.isEmpty(caseOrigin))
			{
				res.statusCode = 400;
                jsonResponse = Json.serialize('Case Origin Invalid');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
			} 
			else
			c.origin = caseOrigin;		//case origin code ends, get the origin value from DEP
            c.LG_Case_Reason__c = caseReason;
            c.Type = caseType;
            if(string.isEmpty(changeEffectiveDate)){
                c.LG_Change_Effective_Date__c =null;
            }
            else{
                c.LG_Change_Effective_Date__c=date.valueOf(changeEffectiveDate);
            }
            system.debug('here===');
            c.LG_Billing_Account__c = billingAccountId;
            system.debug('serviceId value+++'+serviceId);
            c.LG_Service__c = serviceId;
            c.LG_Invoice_Header__c = invoiceId;
            c.B2B_Alternate_Contact_Name__c=name;
            c.B2B_Alternate_Email__c=email;
            c.B2B_Alternate_Contact_Number__c=phone;
            Id accountId = [select id from Account where LG_AccountNumber__c  =: accountNumber limit 1].id;
            c.AccountId = accountId;
            RecordType rectype = [select id, DeveloperName from RecordType where SobjectType='Case' AND id =: c.RecordTypeId];

            if(((rectype.DeveloperName == 'LG_B2B_Care_Admin_Change_Request_UM') || (rectype.DeveloperName == 'B2B_Care_Billing_Query_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_Complaint_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_Service_Change_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_General_Query_Request_UM')) && (string.isEmpty(c.LG_Billing_Account__c))){
                res.statusCode = 400;
                jsonResponse = Json.serialize('Billing Account field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            else if(((rectype.DeveloperName == 'LG_B2B_Care_Admin_Change_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_Service_Change_Request_UM')) && (c.LG_Change_Effective_Date__c==null)){
                
                system.debug('this if =');
                res.statusCode = 400;
                jsonResponse = Json.serialize('Change Effective Date field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            else if(((rectype.DeveloperName == 'LG_B2B_Care_Admin_Change_Request_UM ') || (rectype.DeveloperName == 'LG_B2B_Care_Technical_Request_UM')  || (rectype.DeveloperName == 'LG_B2B_Care_SLA_Breach_Request_UM') || 
                     (rectype.DeveloperName == 'B2B_Care_Billing_Query_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_Complaint_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_Service_Change_Request_UM') || (rectype.DeveloperName == 'LG_B2B_Care_General_Query_Request_UM')) && (string.isEmpty(c.ContactId))){
                res.statusCode = 400;
                jsonResponse = Json.serialize('Contact Id field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }           
            else if(string.isEmpty(c.Description)){
                res.statusCode = 400;
                jsonResponse = Json.serialize('Description field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            else if(string.isEmpty(c.Type)){
                res.statusCode = 400;
                jsonResponse = Json.serialize('Type field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            else if((rectype.DeveloperName=='LG_B2B_Care_Technical_Request_UM') && (string.isEmpty(c.LG_Service__c))){
                system.debug('inside this:');
                res.statusCode = 400;
                jsonResponse = Json.serialize('Service id field is empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            } 
             if(!string.isEmpty(c.Type)){
             if(string.isEmpty(c.LG_Case_Reason__c )){
                res.statusCode = 400;
                jsonResponse = Json.serialize('Case Reason field is Empty');
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            }
            system.debug('case account number===='+c.account.Company_ID__c);     
            system.debug('case account number===='+c.AccountId);      
            system.debug('debug case+++'+c);
            insert c;
            Case cs= [select id,Priority,B2B_Alternate_Contact_Name__c,origin,CreatedDate,B2B_Alternate_Email__c,B2B_Alternate_Contact_Number__c,status,description,contact.account.LG_AccountNumber__c,contactId,ContactEmail,ContactPhone,CaseNumber,LG_Case_Reason__c,type,LG_Change_Effective_Date__c,LG_Billing_Account__c,LG_Service__c,LG_Invoice_Header__c,RecordTypeId from case where id=:c.Id];
            jsonResponse = Json.serialize(cs);
            res.responseBody = blob.valueOf(jsonResponse);
            return;
            
            }
        catch(exception e){
            system.debug('exception catch'+e.getMessage());
            system.debug('exception catch'+e.getLineNumber());
            res.statusCode = 400;
            jsonResponse = Json.serialize(e.getMessage());
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
    }

}
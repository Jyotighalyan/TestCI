trigger UM_CustomerApprovalTigger on CSCAP__Customer_Approval__c (after update) 
{
        
    CSCAP__Customer_Approval__c newCustApprObj =Trigger.new[0];
    private list<CSCAP__Customer_Approval__c > custApprList = new list<CSCAP__Customer_Approval__c>();
    private list <contact> contactList = new list<contact>();
    
    system.debug('In trigger-->'+newCustApprObj);
    if(newCustApprObj.CSCAP__Approved_By_Customer__c == true && newCustApprObj.Order_Date__c != Null)
    {
        system.debug('In if -->'); 
        contactList = [SELECT id,email
                           FROM Contact
                           WHERE id IN (SELECT CSCAP__Contact__c
                                        FROM CSCAP__Customer_Approval__c 
                                        WHERE id =: newCustApprObj.id) limit 1];    
        /*opportunityList = [SELECT id,LG_PrimaryContact__c 
                           FROM Opportunity 
                           WHERE id IN (SELECT CSCAP__Opportunity__c,CSCAP__Contact__c 
                                        FROM CSCAP__Customer_Approval__c 
                                        WHERE id =: newCustApprObj.id) limit 1];
                                        
        system.debug('opportunityList -->'+opportunityList);
        if(!opportunityList.isEmpty())                                  
            contactList= [select email from contact where id =:opportunityList[0].LG_PrimaryContact__c limit 1];
         */   
        if(!contactList.isEmpty())
        {
            system.debug('contactList-->'+contactList);
            system.debug('newCustApprObj-->'+newCustApprObj);
            Messaging.SingleEmailMessage oMail= new Messaging.SingleEmailMessage();          
            EmailTemplate oEmailTemplate = [Select id from EmailTemplate where developerName =:'UM_Order_Acknowledgement_Email'];
            oMail.setTemplateId(oEmailTemplate.id);
            oMail.setTargetObjectId(contactList[0].id);
            oMail.setWhatId(newCustApprObj.id);
            List<string> listMailAddresses = new List<string>(); 
            listMailAddresses.add(contactList[0].email);
             system.debug('listMailAddresses-->'+listMailAddresses);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {oMail});
        }
    }
    else if(newCustApprObj.CSCAP__Rejected_By_Customer__c==true)
    {
        /*opportunityList = [SELECT id,LG_PrimaryContact__c 
                           FROM Opportunity 
                           WHERE id IN (SELECT CSCAP__Opportunity__c 
                                        FROM CSCAP__Customer_Approval__c 
                                        WHERE id =: newCustApprObj.id) limit 1];
                                        
        system.debug('opportunityList -->'+opportunityList);
        if(!opportunityList.isEmpty())                                  
            contactList= [select email from contact where id =:opportunityList[0].LG_PrimaryContact__c limit 1];
         */
        contactList = [SELECT id,email
                           FROM Contact
                           WHERE id IN (SELECT CSCAP__Contact__c
                                        FROM CSCAP__Customer_Approval__c 
                                        WHERE id =: newCustApprObj.id) limit 1];    
        if(!contactList.isEmpty())
        {
            system.debug('contactList-->'+contactList);
            system.debug('newCustApprObj-->'+newCustApprObj);
            Messaging.SingleEmailMessage oMail= new Messaging.SingleEmailMessage();          
            EmailTemplate oEmailTemplate = [Select id from EmailTemplate where developerName =:'UM_Order_Rejection_Email'];
            oMail.setTemplateId(oEmailTemplate.id);
            oMail.setTargetObjectId(contactList[0].id);
            oMail.setWhatId(newCustApprObj.id);
            List<string> listMailAddresses = new List<string>(); 
            listMailAddresses.add(contactList[0].email);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {oMail});
        }
    }
}
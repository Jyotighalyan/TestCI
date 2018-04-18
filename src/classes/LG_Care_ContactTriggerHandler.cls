public class LG_Care_ContactTriggerHandler {
    
    public void generateActivationCode(List<Contact> contactsList) {
        integer counter = 0;
        for(Contact con :contactsList) {
            if(con.Generate_Activation_Code__c) {
                String hashString = counter + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
                Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
                
                con.B2B_Activation_Code__c = EncodingUtil.convertToHex(hash).substring(0,10);
                // add expiration date logic here.
                Date tempDate = Date.today();
                con.B2B_Expiration_Date__c = tempDate.addDays(14);
                con.Generate_Activation_Code__c = false;
                con.B2B_Care_Email_Sent_On__c = DateTime.now();
                counter++;
            }
        }
    }
    
    public void sendMail_to_Contact(List<Contact> contactList,Map<Id,Contact> oldConMap) {
    
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        for(Contact con :contactList) {
                if(con.B2B_Activation_Code__c != oldConMap.get(con.Id).B2B_Activation_Code__c) {
                    
                    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Unitymedia Business' limit 1];
                    
                    List<EmailTemplate> et=[Select id from EmailTemplate where DeveloperName = 'B2B_Activation_Code_For_Self_Care' OR DeveloperName = 'B2B_Activation_Url_For_Self_Care' limit 2];
                    
                    for(EmailTemplate e :et) {
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTemplateId(e.Id);
                        singleMail.setTargetObjectId(con.Id);
                        singleMail.setSaveAsActivity(false);
                        singleMail.setOrgWideEmailAddressId(owa.id);
                        mails.add(singleMail);
                    }
                        
                }
            }
            if(mails.size() > 0)
                Messaging.sendEmail(mails);  
    }
}
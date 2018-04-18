public class LG_ValidateMyBillDetails {
	
    public static void handle(List<csconta__Billing_Account__c> newData){
        checkDuplicateMyBillAcc(newData);
    }
    
    /*godson - SFOM-93*/
    private static void checkDuplicateMyBillAcc(List<csconta__Billing_Account__c> newData){
        
        Map<Id,List<Contact>> billingAccountIdContact = new Map<Id,List<Contact>>();
        Map<Id,csconta__Billing_Account__c> IdBillingAccount = new Map<Id,csconta__Billing_Account__c>();
        List<Contact> contactForBillingAccount = new List<Contact>();
        set<Id> contacts = new Set<Id>();
        Map<Id,List<csconta__Billing_Account__c>> billingAccountIdAccount = new Map<Id,List<csconta__Billing_Account__c>>();
        
        for(csconta__Billing_Account__c billingRecord : newData){
            if(null != billingRecord.LG_MyBillAccount__c && null != billingRecord.LG_MyBillAddress__c){
                contacts.add(billingRecord.LG_MyBillAccount__c);
                IdBillingAccount.put(billingRecord.Id, billingRecord);
                system.debug('Inside '+billingRecord.Id);
            } 
        }
        
        
		contactForBillingAccount = [SELECT Id,
                                    FirstName, 
                                    LastName, 
                                    MobilePhone, 
                                    Phone, 
                                    Email,
                                    cscrm__Address__c,
                                    LG_IsFinContact__c from Contact 
                                    WHERE Id IN :contacts 
                                    and LG_IsFinContact__c = true];
        
       system.debug('contact '+contactForBillingAccount.size());
        for(Id id : IdBillingAccount.keySet()){
            for(Contact c : contactForBillingAccount){
                if(IdBillingAccount.get(id).LG_MyBillAccount__c == c.Id){
                    if(billingAccountIdContact.containsKey(id)){
                        billingAccountIdContact.get(id).add(c);
                    }
                    else{
                        billingAccountIdContact.put(id, new List<Contact>());
                        billingAccountIdContact.get(id).add(c);
                    }
                }
            }
        }
        
        Set<Id> billingAccount = new Set<Id>();
        Map<Id,List<csconta__Billing_Account__c>> billingAcountIdExistingBillingAccount = new Map<Id,List<csconta__Billing_Account__c>>();
        for(Id id : billingAccountIdContact.keySet()){
            if(billingAccountIdContact.get(id).size()>0){
                billingAccount.add(IdBillingAccount.get(id).csconta__Account__c);
            }
        }
        
        List<csconta__Billing_Account__c> existingBillingRecords = [SELECT Id,
                                                                   LG_MyBillAccount__c, 
                                                                   //LG_MyBillBillingSysType__c, - Removed as a part of SFOM-519
                                                                   LG_MyBillBillingSysAccId__c,csconta__Account__c from csconta__Billing_Account__c
                                                                   WHERE csconta__Account__c IN :billingAccount 
                                                                   //and LG_MyBillBillingSysType__c != null - Reomoved as a part of SFOM-519
                                                                   and LG_MyBillBillingSysAccId__c !=null 
                                                                   and LG_MyBillExists__c = true 
                                                                   LIMIT 1];
        
        system.debug('existing billing records: '+existingBillingRecords.size());
        for(Id id : IdBillingAccount.keySet()){
            for(csconta__Billing_Account__c account : existingBillingRecords){
                if(account.csconta__Account__c == id){
                    if(billingAccountIdAccount.containsKey(id)){
                        billingAccountIdAccount.get(id).add(account);
                    }
                    else{
                        billingAccountIdAccount.put(id, new List<csconta__Billing_Account__c>());
                        billingAccountIdAccount.get(id).add(account);
                    }
                }
            }
        }
        
       
        for(csconta__Billing_Account__c billingRecord : newData){
            if(null != billingRecord.LG_MyBillAccount__c && null != billingRecord.LG_MyBillAddress__c){
                system.debug('Inside');
            List<Contact> contactDetail = new List <Contact>();
            if(billingAccountIdContact.containsKey(billingRecord.Id)){
                contactDetail = billingAccountIdContact.get(billingRecord.Id);
            }
            //To validate the contact
                if(contactDetail.size() > 0){
                    List<csconta__Billing_Account__c> existingBillingRecord = new List<csconta__Billing_Account__c>();
                    if(billingAccountIdAccount.containsKey(billingRecord.Id)){
                        existingBillingRecord = billingAccountIdAccount.get(billingRecord.Id);
                    }
                    
                                     
                    if(existingBillingRecord.size() > 0){
                        if(contactDetail[0].Id == existingBillingRecord[0].LG_MyBillAccount__c){
                            billingRecord.LG_MyBillContactFirstName__c = contactDetail[0].FirstName;
                            billingRecord.LG_MyBillContactLastName__c = contactDetail[0].LastName;
                            billingRecord.LG_MyBillMobile__c = contactDetail[0].MobilePhone;
                            billingRecord.LG_MyBillPhone__c = contactDetail[0].Phone;
                            billingRecord.LG_MyBillEmail__c = contactDetail[0].Email;
                            
                            //billingRecord.LG_MyBillBillingSysType__c = existingBillingRecord[0].LG_MyBillBillingSysType__c;
                            billingRecord.LG_MyBillBillingSysAccId__c = existingBillingRecord[0].LG_MyBillBillingSysAccId__c;
                            billingRecord.LG_MyBillExists__c = true;
                        }else{
                            List<Contact> contactName = [SELECT Id,Name from Contact WHERE Id=:existingBillingRecord[0].LG_MyBillAccount__c and LG_IsFinContact__c = true];
                            billingRecord.LG_MyBillAccount__c.addError('MyBill account : "'+ contactName[0].Name+'" already exist, please use "'+ contactName[0].Name+'".');
                        }
                        
                        
                    }else{//Adding for the first time
                        
                        if(billingRecord.LG_MyBillBillingSysAccId__c !=null){
                            billingRecord.LG_MyBillContactFirstName__c = contactDetail[0].FirstName;
                            billingRecord.LG_MyBillContactLastName__c = contactDetail[0].LastName;
                            billingRecord.LG_MyBillMobile__c = contactDetail[0].MobilePhone;
                            billingRecord.LG_MyBillPhone__c = contactDetail[0].Phone;
                            billingRecord.LG_MyBillEmail__c = contactDetail[0].Email;
                            billingRecord.LG_MyBillExists__c = true;
                        }else{
                            billingRecord.LG_MyBillContactFirstName__c = contactDetail[0].FirstName;
                            billingRecord.LG_MyBillContactLastName__c = contactDetail[0].LastName;
                            billingRecord.LG_MyBillMobile__c = contactDetail[0].MobilePhone;
                            billingRecord.LG_MyBillPhone__c = contactDetail[0].Phone;
                            billingRecord.LG_MyBillEmail__c = contactDetail[0].Email;
                            //billingRecord.LG_MyBillBillingSysType__c = null;
                            billingRecord.LG_MyBillBillingSysAccId__c = null;
                            billingRecord.LG_MyBillExists__c = false;
                        }
                        
                        
                    }
                    
                }else{
                        
                 	billingRecord.LG_MyBillAccount__c.addError('This account is not a Finance contact. Make sure you select Finance contact after creating or modifying the contact.');
                }
            }
            else if(null != billingRecord.LG_MyBillAccount__c && null == billingRecord.LG_MyBillAddress__c){
                billingRecord.LG_MyBillAddress__c.addError('You must enter a value');
            }else if(null == billingRecord.LG_MyBillAccount__c && null != billingRecord.LG_MyBillAddress__c){
                billingRecord.LG_MyBillAccount__c.addError('You must enter a value');
            }else{
                //clear all record
            }
            }
    }
}
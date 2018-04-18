@isTest
public class UM_BillingAccountItemTriggerHandlerTest
{
    @testsetup static void setupTestData()
    {
        UM_Kenan_NRCReason_Mapping__c nrc = new UM_Kenan_NRCReason_Mapping__c();
        nrc.UM_Kenan_Code__c = '2632';
        nrc.UM_Kenan_NRC_Reason__c = 'Falscher Rechnungsbetrag';
        nrc.UM_Is_Active__c = true;
        nrc.name = '2632_FalscherRechnungsbetrag';
        insert nrc;
        
        Account masterAccount = new Account(Name='Test Account');
        masterAccount.LG_PostalStreet__c = 'Aachener Str.';
        masterAccount.LG_PostalCity__c = 'Köln';
        masterAccount.UM_VisitStateProvince__c = 'NRW';
        masterAccount.LG_PostalPostalCode__c = '50933';
        masterAccount.LG_PostalHouseNumber__c = '746';
        masterAccount.LG_PostalHouseNumberExtension__c = '-750';
        masterAccount.LG_Segment__c='SME';
        masterAccount.LG_ChamberOfCommerceNumber__c = 'C12132312';
        masterAccount.LG_VIP__c=false;
        masterAccount.UM_Legal_Name__c='abc';
        insert masterAccount;
        
        Contact billingContact = new Contact(FirstName = 'First', LastName = 'Last', AccountId = masterAccount.id, Salutation='Mr.');
        insert billingContact;
        
        csconta__Billing_Account__c billingAccount = new csconta__Billing_Account__c (csconta__Account__c = masterAccount.id);
        billingAccount.csconta__Street__c = 'Street 1';
        billingAccount.csconta__Postcode__c = 'Postcode 1';
        billingAccount.csconta__City__c = 'City 1';
        billingAccount.csconta__Country__c ='Germany';
        billingAccount.Billing_Contact__c = billingContact.id;
        billingAccount.csconta__Status__c ='Active';
        insert billingAccount; 
        system.debug('BA'+billingAccount);
        
        LG_Discount__c discount = new LG_Discount__c();
        discount.name= 'disc 1';
        discount.LG_Amount__c = 30;
        discount.LG_Months__c = 2;
        discount.LG_Active__c = true;
        discount.LG_DiscountType__c = 'Promotional Action';
        discount.UM_ExternalId__c= '2554';
        insert discount;
        
        String orgId = UserInfo.getOrganizationId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = new User(Alias = 'standt',CommunityNickname='test11', Email='testuser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,companyName='UM', TimeZoneSidKey='Europe/Berlin',
             UserName='neha1@abc.com'+orgId);
        insert u1;
        User u2 = new User(Alias = 'test2',CommunityNickname='test22', Email='testuser2@testorg.com', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',EmailEncodingKey='UTF-8', LastName='Testing2', ProfileId = p.Id,companyName='UM',TimeZoneSidKey='Europe/Berlin', 
             UserName='testuser2@abc.com'+orgId,managerId= u1.id);
        insert u2;    
        
    }
    private static testMethod void testMethodAdjstBillingItem()
    {
        User adminUser = [SELECT id FROM USER WHERE email='testuser2@testorg.com' and isActive= true LIMIT 1];
        Id adjustmentRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();
        
        csconta__Billing_Account__c billingAccount = [SELECt id,csconta__Status__c FROM csconta__Billing_Account__c WHERE csconta__Status__c='Active' LIMIT 1];
        UM_BillingAccountItem__c bItem = new UM_BillingAccountItem__c();
        system.RunAs(adminUser)
        {
            bItem.UM_BillingAccount__c = billingAccount.id ;
            bItem.recordTypeId = adjustmentRecordTypeId ;
            bItem.UM_NRC_Reason__c = 'Falscher Rechnungsbetrag';
            bItem.UM_Total_Amount__c = 400;
            bItem.UM_StartDate__c = system.today();
            insert bItem;
                        
            List<UM_BillingAccountItem__c> listInserted= [SELECT id,recordtypeId FROM UM_BillingAccountItem__c];
            system.debug('rt#'+listInserted[0].recordtypeId );
            system.assertEquals(listInserted.size(),1);
            listInserted[0].UM_Approval_Status__c = 'Approved';
            update listInserted[0];
         }   
            //below BI inserted from external system- kenan
            bItem = new UM_BillingAccountItem__c();
            bItem.UM_BillingAccount__c = billingAccount.id ;
            bItem.recordTypeId = adjustmentRecordTypeId ;
            bItem.UM_NRC_Reason__c = 'Falscher Rechnungsbetrag';
            bItem.UM_Received_from_Billing_System__c= true;
            bItem.UM_Total_Amount__c = 4000;
            bItem.UM_StartDate__c = system.today();
            insert bItem;
            List<UM_BillingAccountItem__c> BiList= [SELECT id,recordtypeId,UM_Total_Amount__c  FROM UM_BillingAccountItem__c WHERE UM_Received_from_Billing_System__c= true];
            system.assertEquals(BiList[0].UM_Total_Amount__c ,40 );          
        
    }
    private static testmethod void testUpdateDiscountBillingItem()
    {
        //User adminUser = [SELECT id FROM USER WHERE email='testuser2@testorg.com' and isActive= true LIMIT 1];
        csconta__Billing_Account__c billingAccount = [SELECt id,csconta__Status__c FROM csconta__Billing_Account__c WHERE csconta__Status__c='Active' LIMIT 1];
        Id discountRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Discount').getRecordTypeId();
        LG_Discount__c discount = [SELECT id FROM LG_Discount__c ];
        //system.RunAs(adminUser)
        //{
            List<UM_BillingAccountItem__c> itemList = new List<UM_BillingAccountItem__c>();
            UM_BillingAccountItem__c bItem = new UM_BillingAccountItem__c();
            bItem.UM_BillingAccount__c = billingAccount.id ;
            bItem.recordTypeId = discountRecordTypeId ;
            bItem.UM_Discount__c = discount.id;
            bItem.UM_StartDate__c = system.today();
            bItem.UM_EndDate__c = system.today().addDays(90);
            itemList.add(bItem);
            
            UM_BillingAccountItem__c bItem1 = new UM_BillingAccountItem__c();
            bItem1.UM_BillingAccount__c = billingAccount.id ;
            bItem1.recordTypeId = discountRecordTypeId ;
            bItem1.UM_Discount__c = discount.id;
            bItem1.UM_StartDate__c = system.today().addDays(2);
            bItem1.UM_EndDate__c = system.today().addDays(90);
            itemList.add(bItem1);
            
            insert itemList;
            List<UM_BillingAccountItem__c> listInserted= [SELECT id,recordtypeId,UM_StartDate__c  FROM UM_BillingAccountItem__c];
            system.assertEquals(listInserted.size(),2);
            for(UM_BillingAccountItem__c item:listInserted)
            {
                if(item.UM_StartDate__c > system.today()){
                    item.UM_StartDate__c = system.today();
                    update item;
                }
            }
            
        //}
    
    }
    
}
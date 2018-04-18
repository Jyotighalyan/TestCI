/*
 * Test class for LG_ValidateMyBillDetails
 @ Author : Shruthi Gopal
 @ Date   : 23/10/2017
*/

@isTest
public class LG_ValidateMyBillDetailsTest {
    
	public static testmethod void handleTest(){
        
        
		Account acc = LG_GeneralTest.CreateAccount('Test Acc', '12345678', 'Ziggo', false);
		insert acc;		

        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        address.cscrm__Account__c = acc.id;
        insert address;
        
		Contact tmpContact = new Contact();
        tmpContact.AccountId=acc.Id;
        tmpContact.Firstname='Firstname';
        tmpContact.LastName='LastName';
        tmpContact.Salutation='Mr.';
        tmpContact.MobilePhone = '9876543211';
        tmpContact.Phone = '12345678';
        tmpContact.Email = 'test@infy.com';
        tmpContact.cscrm__Address__c = address.id;
        tmpContact.LG_IsFinContact__c = true;
        insert tmpContact;

       
        //Billing Account with proper data
		List<csconta__Billing_Account__c> newData = new List<csconta__Billing_Account__c>();
		csconta__Billing_Account__c b = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, false);
        b.LG_MyBillAccount__c = tmpContact.id;
        b.LG_MyBillAddress__c = address.id;
        b.LG_MyBillBillingSysAccId__c = 'Test_ID';
        b.csconta__Account__c = acc.id;
        b.LG_MyBillExists__c = true;
		newData.add(b);
		insert newData;
        
        //Billing Account with LG_MyBillBillingSysAccId__c = null
        List<csconta__Billing_Account__c> nullsync = new List<csconta__Billing_Account__c>();
		csconta__Billing_Account__c bill = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, false);
        bill.LG_MyBillAccount__c = tmpContact.id;
        bill.LG_MyBillAddress__c = address.id;
        bill.LG_MyBillBillingSysAccId__c = null;
        bill.csconta__Account__c = acc.id;
        bill.LG_MyBillExists__c = true;
		nullsync.add(bill);
		insert nullsync;
        
        //Billing Account with LG_MyBillAddress__c = null
        List<csconta__Billing_Account__c> nulladdr = new List<csconta__Billing_Account__c>();
		csconta__Billing_Account__c b2 = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, false);
        b2.LG_MyBillAccount__c = tmpContact.id;
        b2.LG_MyBillAddress__c = null;
        b2.LG_MyBillBillingSysAccId__c = 'Test_ID';
        b2.csconta__Account__c = acc.id;
        b2.LG_MyBillExists__c = true;
		nulladdr.add(b2);
		insert nulladdr;
        
        //Billing Account with LG_MyBillAccount__c = null
        List<csconta__Billing_Account__c> nullacc = new List<csconta__Billing_Account__c>();
		csconta__Billing_Account__c b3 = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, false);
        b3.LG_MyBillAccount__c = null;
        b3.LG_MyBillAddress__c = address.id;
        b3.LG_MyBillBillingSysAccId__c = 'Test_ID';
        b3.csconta__Account__c = acc.id;
        b3.LG_MyBillExists__c = true;
		nullacc.add(b3);
		insert nullacc;
        
        
        test.startTest();
        LG_ValidateMyBillDetails.handle(newData);
        LG_ValidateMyBillDetails.handle(nullsync);
        LG_ValidateMyBillDetails.handle(nulladdr);
        LG_ValidateMyBillDetails.handle(nullacc);
        test.stopTest();
        
    }
}
/************************************************************************************************************************************
*        Class: LG_CreateCaseTest
*     Program : B2B SELF CARE PROGRAM
*  Description: Test class for LG_CreateCase class
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 02-AUG-2017
*************************************************************************************************************************************/

@isTest
public class LG_CreateCaseTest{
    	
    	public static Account acc;
    	public static Contact con;
		public static csord__Order_Request__c orderRequest;
    	public static csord__Subscription__c sub;
    	public static cscrm__Address__c address; 
    	public static csord__Service__c service;
	    public static csconta__Billing_Account__c testBilingAcc;
    	public static UM_InvoiceHeader__c InvoiceHeader1;
        public static   string  techRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Technical_Request_UM'].id ;
        public static   string  billingRectypeIds=[select id from recordType where sObjectType='case' and  developerName='LG_B2B_Care_Online_Billing_Request_UM'].id ;
        public static   string  adminRectypeIds= [select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Admin_Change_Request_UM' ].id;
        public static   string  genralrectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_General_Query_Request_UM'].id;
        public static   string  complaintRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Complaint_Request_UM'].id; 
        public static  string  maintainenceRectypeIds=[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Planned_Maintenance_Request_UM'].id; 
        public static   string  outageRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Mass_Outage_Request_UM'].id; 
        public static   string  slaRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_SLA_Breach_Request_UM'].id;
        public static  string  serviceRectypeIds =[select id from recordType where sObjectType='case' and developerName='LG_B2B_Care_Service_Change_Request_UM'].id;
        public static  string  billingQueryRectypeIds =[select id from recordType where sObjectType='case' and developerName='B2B_Care_Billing_Query_Request_UM'].id;
    

    	@testSetup
        public static void setupTestData(){

        acc = new Account (
		Name = 'newAcc1'
		);  
		insert acc;

        con = new Contact(firstname = 'Ram', lastname = 'Reddy', Salutation='Mr.', account = acc);
		insert con;
        system.debug('con is ==='+con);    
        orderRequest = new csord__Order_Request__c();
        orderRequest.Name = 'Test Order Request';
        orderRequest.csord__Module_Name__c = 'Test Module';
        orderRequest.csord__Module_Version__c = 'Test v1.0';
        orderRequest.csord__Process_Status__c = 'Testing';
        insert orderRequest;
        
        sub = new csord__Subscription__c();
        sub.Name = 'Business Broadband';
        sub.csord__Account__c = acc.id;
        sub.csord__Identification__c = 'Test Identification';
        sub.csord__Order_Request__c = orderRequest.id;
        insert sub;
        
        address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
        address.Name = 'Test Address';
        insert address;
    
        service = new csord__Service__c();
        service.csord__Subscription__c = sub.id;
        service.LG_ServiceExternalId__c = null;
        service.LG_Address__c = address.id;
        service.Name = 'Test Service';
        service.csord__Status__c = 'Active';
        service.csord__Order_Request__c = orderRequest.Id;
        service.csord__Identification__c ='test Identification';
        insert service;  
    
        testBilingAcc = LG_GeneralTest.createBillingAccount('1234', acc.Id, true, true);
            
        InvoiceHeader1 = LG_GeneralTest.createInvoiceHeader(acc.Id, Date.today().addDays(-10), '100', 100.00, 75.00, 100, 75, Date.today().addDays(5), testBilingAcc.Id, true);
        }
    	
    	public static testMethod void createNewcaseTest1(){
		//validate for case record type field empty
        RestRequest request8 = new RestRequest();
        RestResponse res8 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_Billing_Location__c =: billAcc.id limit 1];
        request8.requestUri = 'https://cs88.salesforce.com/services/apexrest/createCase/';
        request8.httpMethod = 'POST';
        request8.addHeader('Content-Type', 'application/json');
        request8.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678",priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request8;
      	RestContext.response = res8;
        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, null, billAcc.id, serv.id, testIH.id,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
    	}
		
        public static testMethod void createNewcaseTest2(){

		// normal test run for success scenario without any validation
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

        request.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request;
      	RestContext.response = res;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', null, techRectypeIds, null, null, null,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
    	
    	public static testMethod void createNewcaseTest3(){
        
		//validate for type field empty
        RestRequest request6 = new RestRequest();
        RestResponse res6 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

            request6.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request6.httpMethod = 'POST';
        request6.addHeader('Content-Type', 'application/json');
        request6.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request6;
      	RestContext.response = res6;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, techRectypeIds, billAcc.id, serv.id, testIH.id,'Not working','','2017-09-07','name','abc@xyz.com','1234567890');
        }
    	
    	public static testMethod void createNewcaseTest4(){
        
		//validate for case reason field empty
        RestRequest request7 = new RestRequest();
        RestResponse res7 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];
        
        request7.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request7.httpMethod = 'POST';
        request7.addHeader('Content-Type', 'application/json');
        request7.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request7;
      	RestContext.response = res7;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, adminRectypeIds, billAcc.id, serv.id, testIH.id,'','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
    	
        public static testMethod void createNewcaseTest5(){
        
		//validate for description field empty
        RestRequest request4 = new RestRequest();
        RestResponse res4 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];
        
            request4.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request4.httpMethod = 'POST';
        request4.addHeader('Content-Type', 'application/json');
        request4.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request4;
      	RestContext.response = res4;

        LG_CreateCase.createNewcase('Email','', acnt.LG_AccountNumber__c, 'P1', cnt.id, adminRectypeIds, billAcc.id, serv.id, testIH.id,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
    	
        public static testMethod void createNewcaseTest6(){

		//validate for change effective date field empty
        RestRequest request2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

            request2.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request2.httpMethod = 'POST';
        request2.addHeader('Content-Type', 'application/json');
        request2.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request2;
      	RestContext.response = res2;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, adminRectypeIds, billAcc.id, serv.id, testIH.id,'Not working','Service Down','','name','abc@xyz.com','1234567890');
        }
    	
        public static testMethod void createNewcaseTest7(){
       
		//validate for service id empty
        RestRequest request5 = new RestRequest();
        RestResponse res5 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

            request5.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request5.httpMethod = 'POST';
        request5.addHeader('Content-Type', 'application/json');
        request5.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request5;
      	RestContext.response = res5;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, techRectypeIds, billAcc.id, null, testIH.id,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
    	
    	public static testMethod void createNewcaseTest8(){
		
            system.debug('after setup called');
        //validate for billing account id empty
        RestRequest request1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

            request1.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request1.httpMethod = 'POST';
        request1.addHeader('Content-Type', 'application/json');
        request1.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request1;
      	RestContext.response = res1;
		system.debug('contact id---'+con);
         system.debug('service id---'+service);  
           system.debug('InvoiceHeader1 id---'+InvoiceHeader1);   
        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', cnt.id, adminRectypeIds, null, serv.id, testIH.id,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
		
        public static testMethod void createNewcaseTest9(){
    	
        //validate for contact id field empty
        RestRequest request3 = new RestRequest();
        RestResponse res3 = new RestResponse();
        Account acnt = [select id, LG_AccountNumber__c from Account where Name = 'newAcc1' limit 1];
        Contact cnt = [select id from Contact where firstname = 'Ram' limit 1];
        csord__Subscription__c subs =  [select id from csord__Subscription__c where Name = 'Business Broadband' limit 1];  
        cscrm__Address__c addr = [select id from cscrm__Address__c where Name = 'Test Address' limit 1];
        csord__Service__c serv = [select id from csord__Service__c where Name = 'Test Service' limit 1];
        csconta__Billing_Account__c billAcc =  [select id from csconta__Billing_Account__c where csconta__Billing_Channel__c = 'Paper bill' limit 1];   
        UM_InvoiceHeader__c testIH = [select id from UM_InvoiceHeader__c where UM_InvoiceNumber__c = '100' limit 1];

            request3.requestUri =
            'https://cs88.salesforce.com/services/apexrest/createCase/';
        request3.httpMethod = 'POST';
        request3.addHeader('Content-Type', 'application/json');
        request3.requestBody = Blob.valueOf('{"caseOrigin":"Email","description":"testing","accountNumber":"12345678","priority":"P1","contactId":"0039E00000IjO9D",recordTypeId":"0129E000000CrsN","billingAccountId":"a2g9E000000CnVX","serviceId":"a169E000000LRDB","invoiceId":"a3J9E000003zaFy","caseReason":"Not working","caseType":"Service Down","changeEffectiveDate":"2017-09-07","caseReason":"Not working","name":"name","email":"abc@xyz.com","phone":"1234567890"}');
        RestContext.request = request3;
      	RestContext.response = res3;

        LG_CreateCase.createNewcase('Email','testing', acnt.LG_AccountNumber__c, 'P1', null, adminRectypeIds, billAcc.id, serv.id, testIH.id,'Not working','Service Down','2017-09-07','name','abc@xyz.com','1234567890');
        }
        
}
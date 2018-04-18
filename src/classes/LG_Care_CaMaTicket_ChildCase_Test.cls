@isTest
public class LG_Care_CaMaTicket_ChildCase_Test {
  
@TestSetup
    static void setUpMethod() {
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        System.runAs(careAgent){
        Datetime dateTimeInstance = Datetime.now();
    
                
        B2B_Care_Ext_Connections__c camaConn = new B2B_Care_Ext_Connections__c();
        camaConn.Name = 'CaMa External System Info';
        camaConn.Authentication_Token__c = 'Basic cmVtZWR5LWVjby53czpyM20zZHktU0YzYzA=';
        camaConn.Connection_URL__c = 'https://appst.unitymedia.de/TicketWS/TicketWSService';
        camaConn.UM_No_of_Tries__c = 3;
        
        insert camaConn;
        
        UM_CaMa_Order_Type__c camaOrd = new UM_CaMa_Order_Type__c();
        camaOrd.Name = 'SME';
        camaOrd.UM_Order_Type__c= 'F2B';
        
        insert camaOrd;
        
        
        
        
        Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;
        
        csconta__Billing_Account__c bill = new csconta__Billing_Account__c();
        bill.csconta__Account__c= acc.id;
        bill.csconta__Status__c ='New';
        insert bill;
        Contact con = new Contact();
        con.Email = 'bubun.abhishek@gmail.com';
        con.LG_DecisionMaker__c = true;
        con.HasOptedOutOfEmail = false;
        con.Salutation ='Mr.';
        con.LastName = 'Mishra';
        con.FirstName = 'Abhisek';
        con.AccountId = acc.Id;
        con.LG_Role__c = 'Business User;Financial Contact';
        insert con;
        /*
        cscrm__Address__c address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
        address.Name = 'Test Address';
        address.cscrm__State_Province__c = 'NRW';
        insert address;*/
           
        cscrm__Address__c address_BW = new cscrm__Address__c();
        address_BW .cscrm__Zip_Postal_Code__c = '761104 abc 58';
        address_BW .Name = 'Test Address';
        address_BW .cscrm__State_Province__c = 'BW';
        insert address_BW ;
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c();
        orderRequest.Name = 'Test Order Request';
        orderRequest.csord__Module_Name__c = 'Test Module';
        orderRequest.csord__Module_Version__c = 'Test v1.0';
        orderRequest.csord__Process_Status__c = 'Testing';
        orderRequest.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest;
        
        csord__Subscription__c sub = new csord__Subscription__c();
        sub.Name = 'Business Broadband';
        sub.csord__Account__c = acc.id;
        sub.csord__Identification__c = 'Test Identification';
        sub.csord__Order_Request__c = orderRequest.id;
        sub.csconta__Billing_Account__c=bill.id;
        insert sub;
        
        csord__Service__c service = new csord__Service__c();
        service.csord__Subscription__c = sub.id;
        service.LG_ServiceExternalId__c = '112245';
        service.LG_Address__c = address_BW.id;
        service.Name = 'Test Service';
        service.csord__Status__c = 'Active';
        service.csord__Order_Request__c = orderRequest.Id;
        service.csord__Identification__c ='test Identification';
        service.LG_ProductFamily__c = 'Internet';
        service.LG_ProvisioningAccountNo__c = '100';
        service.LG_Access_Technology__c = 'Coax';
        insert service;
        /*
        csord__Service__c service_voice = new csord__Service__c();
        service_voice.csord__Subscription__c = sub.id;
        service_voice.LG_ServiceExternalId__c = '112245';
        service_voice.LG_Address__c = address.id;
        service_voice.Name = 'Test Service';
        service.csord__Status__c = 'Active';
        service_voice.csord__Order_Request__c = orderRequest.Id;
        service_voice.csord__Identification__c ='test Identification';
        service_voice.LG_ProductFamily__c = 'voice';
        service_voice.LG_ProvisioningAccountNo__c = '100';
        service_voice.LG_Access_Technology__c = 'Coax';
        insert service_voice ;*/
        
        RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Technical_Request_UM'];
        RecordType rt2 = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
        Case technicalCase = new Case();
        technicalCase.RecordTypeId = rt.Id;
        technicalCase.AccountId = acc.Id;
        technicalCase.LG_Service__c = service.Id;
        technicalCase.ContactId = con.Id;
        technicalCase.origin = 'Email';
        technicalCase.type = 'Service Performance';
        technicalCase.LG_Case_Reason__c = 'Severe';
        technicalCase.description = 'CaMa Testing';
        technicalCase.CaMa_Ticket_ID__c = '12345';
        insert technicalCase;
        
        Case technicalCase2 = new Case();
        technicalCase2.RecordTypeId = rt.Id;
        technicalCase2.AccountId = acc.Id;
        technicalCase2.LG_Service__c = service.Id;
        technicalCase2.ContactId = con.Id;
        technicalCase2.origin = 'Email';
        technicalCase2.type = 'Installation';
        technicalCase2.LG_Case_Reason__c = 'Change date';
        technicalCase2.description = 'CaMa Testing2';
        technicalCase2.CaMa_Ticket_ID__c = '98765';
        insert technicalCase2;
        
      
        }
    }
    
      static testmethod void createChildCase() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent)
        {
        Case technicalCase = [SELECT id,AccountId,LG_Service__c,type,description,CaMa_Ticket_ID__c FROM Case WHERE type = 'Service Performance' LIMIT 1];
        RecordType rt2 = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
        Case CamaCase= new Case();
        CamaCase.RecordTypeId = rt2.Id;
        CamaCase.B2B_Order_Comment__c= 'Cama Ticket Testing';
        CamaCase.ParentId=technicalCase.id;
        insert CamaCase;
        Test.stopTest();
        
        List<Case> childCases = [SELECT id FROM Case WHERE parentId = :technicalCase.Id];
        System.assertEquals(1, childCases.size());
        }
    }
    
    static testmethod void createChildCase1() {
    try{
       User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent)
      {
        cscrm__Address__c add = [SELECT cscrm__State_Province__c FROM cscrm__Address__c WHERE Name = 'Test Address' LIMIT 1];
        add.cscrm__State_Province__c = 'NRW';
        update add;
        csord__Service__c ser = [SELECT LG_ProductFamily__c FROM csord__Service__c LIMIT 1];
        ser.LG_ProductFamily__c = 'Voice';
        update ser;
        Case technicalCase = [SELECT id,AccountId,LG_Service__c,type,description,CaMa_Ticket_ID__c FROM Case WHERE type = 'Installation' LIMIT 1];
        RecordType rt2 = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
        Case CamaCase= new Case();
        CamaCase.RecordTypeId = rt2.Id;
        CamaCase.B2B_Order_Comment__c= 'Cama Ticket Testing';
        CamaCase.ParentId=technicalCase.id;
        insert CamaCase;
        Test.stopTest();
        
        List<Case> childCases = [SELECT id FROM Case WHERE parentId = :technicalCase.Id];
        System.assertEquals(1, childCases.size());
        }
     }
        catch(exception e)
        {}
        
    }
    
    static testmethod void createChildCase2() {
    try{
       User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent)
       {   
     
        cscrm__Address__c add = [SELECT cscrm__State_Province__c FROM cscrm__Address__c WHERE Name = 'Test Address' LIMIT 1];
        add.cscrm__State_Province__c = 'Hessen';
        update add;
        csord__Service__c ser = [SELECT LG_ProductFamily__c FROM csord__Service__c LIMIT 1];
        ser.LG_ProductFamily__c = 'TV';
        update ser;
        Case technicalCase = [SELECT id,AccountId,LG_Service__c,type,description,CaMa_Ticket_ID__c FROM Case WHERE type = 'Installation' LIMIT 1];
        RecordType rt2 = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
        Case CamaCase= new Case();
        CamaCase.RecordTypeId = rt2.Id;
        CamaCase.B2B_Order_Comment__c= 'Cama Ticket Testing';
        CamaCase.ParentId=technicalCase.id;
        insert CamaCase;
        Test.stopTest();
        
        List<Case> childCases = [SELECT id FROM Case WHERE parentId = :technicalCase.Id];
        System.assertEquals(1, childCases.size());
    
     }
   }
    catch(exception e)
    {}
    
}
    
   
}
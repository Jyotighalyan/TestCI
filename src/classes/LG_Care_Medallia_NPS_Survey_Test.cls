@isTest
public Class LG_Care_Medallia_NPS_Survey_Test{
    
    @isTest Static void MedalliaCall(){ 
        
        List<id> Mid = New List<id>();
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        System.runAs(careAgent) 
        {
            try{
                
                Recordtype rtid=[Select id,DeveloperName from Recordtype where developerName='LG_B2B_Care_Technical_Request_UM'];
                
                Account MAcc = New Account();
                MAcc.Name='Medalia Account';
                MAcc.LG_VisitCountry__c ='Germany';
                Insert MAcc;
                
                Contact MCon = New Contact();
                MCon.LastName='NPS Test Contact';
                MCon.Email='Nilesh_tanwar@infosys.com';
                MCon.Accountid = MAcc.id;
                
                Insert MCon;
                
                csord__Subscription__c MSubs = new csord__Subscription__c();
                MSubs.Name='NPS Subs';
                MSubs.csord__Identification__c='101';
                MSubs.csord__Account__c = MAcc.id;
                Insert MSubs;
                
                cscrm__Address__c address = new cscrm__Address__c();
                address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
                address.Name = 'Test Address';
                address.cscrm__Country__c='Germany';
                insert address;
                
                csord__Service__c MService= New  csord__Service__c();
                MService.Name='NPS Service';
                MService.LG_ProductFamily__c='internet';
                MService.UM_ProductDescription__c='High Speed Internet';
                MService.csord__Subscription__c=MSubs.id;
                MService.csord__Identification__c='102';
                MService.LG_Address__c=address.id;
                Insert MService;
                Case MCase = new Case();
                MCase.Recordtypeid=rtid.id;
                MCase.Account=MAcc;
                MCase.Contactid=MCon.id;
                MCase.Contact=MCon;
                //MCase.B2B_Care_PE_Customer_Country_Info__c=MCon.Email;
                MCase.Origin='Phone';
                MCase.type='Service Down';
                MCase.LG_Case_Reason__c='Not working';
                MCase.LG_Service__c=MService.id;
                MCase.Accountid=MAcc.id;
                Insert MCase;
                
                MCase.OwnerId = careAgent.id;
                Update MCase;
                
                B2B_Care_Ext_Connections__c MedalliaConnBrand = new B2B_Care_Ext_Connections__c();
                MedalliaConnBrand.Name = 'Germany';
                MedalliaConnBrand.Brand__c = 'Unitymedia Business';               
                insert MedalliaConnBrand;
                
                B2B_Care_Ext_Connections__c MedalliaConn = new B2B_Care_Ext_Connections__c();
                MedalliaConn.Name = 'Medallia External System Info';
                MedalliaConn.UM_No_of_Tries__c = 3;
                MedalliaConn.Connection_URL__c = 'https://libertyglobal.medallia.eu/libertyglobalb2b.feed?unitymediainvitation';       
                insert MedalliaConn;
                
                
                Mid.Add(MCase.id);
                
                Test.StartTest();
                Test.setMock(HttpCalloutMock.class, new LG_Care_SBC_MockHttpResponseGenerator());
                LG_Care_Medallia_NPS_Survey.Create_Medallia_NPS_JSON_Request(Mid);
                system.assertNotEquals(Null,LG_Care_Medallia_NPS_Survey.RqstFile); 
                Test.StopTest();
                
            }
            
            catch(exception e)
            {
            }
        }
    }
    
}
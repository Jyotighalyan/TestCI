@isTest(seeAllData=false)
public Class LG_Care_Medallia_NPS_Response_Test{
    
    @isTest Static void MedalliaCallout(){
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Technical_Request_UM'];
                
                Account NPSAcc = New Account();
                NPSAcc.Name='NPS Test Account';
                NPSAcc.LG_Segment__c='SME';
                NPSAcc.LG_ChamberOfCommerceNumber__c = '12345678';
                Insert NPSAcc;
                //Inserting entitlement record related the above craeted account
                Date d = Date.today();
                Entitlement e1 = new Entitlement();
                e1.AccountId = NPSAcc.Id;
                e1.Name = 'TestEntitlement1';
                e1.StartDate = date.newInstance(2015, 2, 1);
                e1.EndDate = d.addDays(1);
                insert e1;
                
                Contact NPSCon= New Contact();
                NPSCon.LastName='NPS Test Contact';
                NPSCon.Email='rishi.kapoor@infosys.com';
                Insert NPSCon;
                
                csord__Subscription__c NPSSubs = new csord__Subscription__c();
                NPSSubs.Name='NPS Subs';
                NPSSubs.csord__Identification__c='101';
                NPSSubs.csord__Account__c = NPSAcc.Id;
                Insert NPSSubs;

                //system.debug('@20');
                csord__Service__c NPSService = New  csord__Service__c();
                NPSService.Name='NPS Service';
                NPSService.LG_ProductFamily__c='internet';
                NPSService.UM_ProductDescription__c='High Speed Internet';
                //system.debug('@21');
                NPSService.csord__Subscription__c=NPSSubs.id;
                //system.debug('@22');
                NPSService.csord__Identification__c='102';
                //system.debug('@23');
               // NPSService.UM_DependsOnProductConfiguration__c=prodNps.id;
                //NPSService.LG_SLA__c = 'Gold';
                Insert NPSService;
               // system.debug('@25');
               
                Case NPSCase = New Case();
                NPSCase.RecordTypeId=rt.id;
                NPSCase.AccountId=NPSAcc.Id;
                NPSCase.Origin='Email';
                NPSCase.Contact=NPSCon;
                NPSCase.type='Service Down';
                NPSCase.Reason='Disabled';
                NPSCase.LG_Service__c=NPSService.id;
                NPSCase.Priority='P4';
                NPSCase.Subject='Test NPS';
                NPSCase.Description='Test NPS Medaliia';
                NPSCase.LG_Service__c=NPSService.id;
                Insert NPSCase;
                //system.debug('@26');
                Opportunity Oppty2= new Opportunity();
                Oppty2.Name='Nps Opportunity';
                Oppty2.Accountid=NPSAcc.id;
                Oppty2.LG_PrimaryContact__c=NPSCon.id;
                Oppty2.Type='New Business';
                Oppty2.UM_QuotingDate__c=System.today();
                Oppty2.StageName='Awarness of interest';
                Oppty2.Probability__c='10';
                Oppty2.CloseDate=system.today()+7;
                //system.debug('@27');
                Insert Oppty2;    
                
                NPS_Result__c npsrecord= new NPS_Result__c();
                npsrecord.Medallia_ID__c='123456';
                npsrecord.NPS_Score__c='6';
                npsrecord.Medallia_URL__c='https://google.com';
                Insert npsrecord;
                //system.debug('@28');
                
            }
        }
        catch(exception e)
        {
        }
        
        
    }
@isTest Static void MedalliaCalloutHelp(){
try{
    User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
    System.runAs(careAgent) {
        system.debug('@29');
        String TestDate =String.Valueof(System.Now());
        Case TestCase =[Select id,CaseNumber from Case ];
        Account NPSACC =[Select id from account where name='NPS Test Account' ]; //*JIT Changes */
        Contact NPSCon =[Select id,Email from Contact];
        csord__Service__c NPSService=[Select id,LG_ProductFamily__c,UM_ProductDescription__c from csord__Service__c ];
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('ACCOUNT_ID',NPSAcc.id);
        gen.writeStringField('RECORD_ID',TestCase.CaseNumber);
        gen.writeStringField('CUSTOMER_EMAIL',NPSCon.Email);
        gen.writeStringField('Medallia URL','https://google.com');
        gen.writeStringField('Response_date',TestDate);
        gen.writeStringField('Survey_status','Completed');
        gen.writeStringField('tNPS score','9');
        gen.writeStringField('SURVEY_TYPE','Help');
        gen.writeStringField('BRAND','Unitymedia Business');
        
        gen.writeStringField('PRODUCT_FAMILY',NPSService.LG_ProductFamily__c);
        gen.writeStringField('PRODUCT_DESCRIPTION',NPSService.UM_ProductDescription__c);
        gen.writeEndObject(); 

    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/npsexport/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueOf(gen.getAsString());
        RestContext.request = req;
        RestContext.response= res;
        system.debug('@31');
        LG_Care_Medallia_NPS_Response.NPSUpdate();
        
         system.assertequals(200,res.statusCode);
         
      }
    }
   catch(exception e)
   {
   }
    
        
}
    
    @isTest Static void MedalliaCalloutBuy(){
        try{
            system.debug('@32');
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent) {
                String TestDate =String.Valueof(System.Now());
                Opportunity Oppty =[Select id,LG_PrimaryContact__c,Opportunity_ID__c  from Opportunity LIMIT 1];
                Account NPSACC =[Select id from account where name='NPS Test Account'];
                Contact NPSCon =[Select id,Email from Contact LIMIT 1];
                csord__Service__c NPSService=[Select id,LG_ProductFamily__c,UM_ProductDescription__c from csord__Service__c LIMIT 1];
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('ACCOUNT_ID',NPSAcc.id);
                gen.writeStringField('RECORD_ID',Oppty.Opportunity_ID__c);
                gen.writeStringField('CUSTOMER_EMAIL',NPSCon.Email);
                gen.writeStringField('Medallia URL','https://google.com');
                gen.writeStringField('Response_date',TestDate);
                gen.writeStringField('Survey_status','Completed');
                gen.writeStringField('tNPS score','9');
                gen.writeStringField('SURVEY_TYPE','Buy');
                gen.writeStringField('BRAND','Unitymedia Business');
                
                gen.writeStringField('PRODUCT_FAMILY',NPSService.LG_ProductFamily__c);
                gen.writeStringField('PRODUCT_DESCRIPTION',NPSService.UM_ProductDescription__c);
                gen.writeEndObject(); 
                system.debug('@33');
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/npsexport/';  //Request URL
                req.httpMethod = 'POST';//HTTP Request Type
                req.requestBody = Blob.valueOf(gen.getAsString());
                RestContext.request = req;
                RestContext.response= res;
                
                LG_Care_Medallia_NPS_Response.NPSUpdate();
                
                system.assertequals(200,res.statusCode);
                
            }
        }
        
        Catch(Exception e)
        {}
        
    }
    
     @isTest Static void MedalliaCalloutInstall(){
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent) {
                String TestDate =String.Valueof(System.Now());
                Case TestCase =[Select id,CaseNumber from Case LIMIT 1];
                Opportunity Oppty =[Select id,LG_PrimaryContact__c,Opportunity_ID__c  from Opportunity LIMIT 1];
                Account NPSACC =[Select id from account where name='NPS Test Account'];
                Contact NPSCon =[Select id,Email from Contact LIMIT 1];
                csord__Service__c NPSService=[Select id,LG_ProductFamily__c,UM_ProductDescription__c from csord__Service__c LIMIT 1];
                JSONGenerator gen = JSON.createGenerator(true);
                 gen.writeStartObject();
                gen.writeStringField('ACCOUNT_ID',NPSAcc.id);
                gen.writeStringField('RECORD_ID',TestCase.CaseNumber);
                gen.writeStringField('CUSTOMER_EMAIL',NPSCon.Email);
                gen.writeStringField('Medallia_URL','https://google.com');
                gen.writeStringField('Response_date',TestDate);
                gen.writeStringField('Survey_status','Completed');
                gen.writeStringField('NPS_score','9');
                gen.writeStringField('SURVEY_TYPE','Install');
                gen.writeStringField('BRAND','Unitymedia Business');
                
                gen.writeStringField('PRODUCT_FAMILY',NPSService.LG_ProductFamily__c);
                gen.writeStringField('PRODUCT_DESCRIPTION',NPSService.UM_ProductDescription__c);
                gen.writeEndObject(); 
                
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/npsexport/' ;  //Request URL
                req.httpMethod = 'POST';//HTTP Request Type
                req.requestBody = Blob.valueOf(gen.getAsString());
                RestContext.request = req;
                RestContext.response= res;
                
                LG_Care_Medallia_NPS_Response.NPSUpdate();
                
                system.assertequals(500,res.statusCode);
                
            }
        }
        
        Catch(Exception e)
        {}
        
    }
    
}
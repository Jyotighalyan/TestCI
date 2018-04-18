@isTest
public class LG_Care_USMS_SF_TO_USMS_Ticket_Test {
    
    static TestMethod void setUpMethod() {
        List<id> USMSId = new List<id>();
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent)
            {
                RecordType rt = [SELECT id,DeveloperName  FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Technical_Request_UM'];
                
                Account USMSAcc = New Account();
                USMSAcc.Name='USMS Test Account';
                Insert USMSAcc;
                
                Contact USMSCon= New Contact();
                USMSCon.LastName='USMS Test Contact';
                USMSCon.Email='rishi.kapoor@infosys.com';
                Insert USMSCon;
                
                csord__Subscription__c USMSSubs = new csord__Subscription__c();
                USMSSubs.Name='USMS Subs';
                USMSSubs.csord__Identification__c='101';
                Insert USMSSubs;
                
                cscrm__Address__c address = new cscrm__Address__c();
                address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
                address.Name = 'Test Address';
                address.cscrm__Country__c='Germany';
                insert address;
                
                csord__Service__c USMSService = New  csord__Service__c();
                USMSService.Name='USMS Service';
                USMSService.LG_ProductFamily__c='internet';
                USMSService.UM_ProductDescription__c='High Speed Internet';
                USMSService.csord__Subscription__c=USMSSubs.id;
                USMSService.csord__Identification__c='102';
                USMSService.LG_Address__c=address.id;
                Insert USMSService;
                
                
                
                Case ParentCase = New Case();
                ParentCase.RecordTypeId=rt.id;
                ParentCase.Account=USMSAcc;
                ParentCase.Origin='Email';
                ParentCase.Contact=USMSCon;
                ParentCase.type='Service Down';
                ParentCase.Reason='Disabled';
                ParentCase.LG_Service__c=USMSService.id;
                ParentCase.Priority='P4';
                ParentCase.Subject='Test USMS';
                ParentCase.Description='Test USMS Medaliia';
                
                
                
                Insert ParentCase;
                
                Care_USMS_Connection__c USMSConn = new Care_USMS_Connection__c();
                USMSConn.Name='Germany';
                USMSConn.Company__c= 'Unity Media KB2';
                USMSConn.First_Name__c= 'SFDC';
                USMSConn.Last_Name__c= 'Interface';
                USMSConn.Source_System__c= 'SFDC';
                
                insert USMSConn;
                
                
                B2B_Akana_Oath__c USMSOath= new B2B_Akana_Oath__c ();
                USMSOath.Name='USMS Oath Akana';
                USMSOath.Access_Token__c='0AZT#$V%G$RESAWTTKVKAOZ!@23'; 
                USMSOath.Token_Date__c=system.today()+3;
                
                insert USMSOath;
                
                B2B_Care_Ext_Connections__c akana= new B2B_Care_Ext_Connections__c ();
                akana.Name='Aakana OFF Connection';
                akana.Connection_URL__c ='https://jit-api-libertyglobal-com.upc.biz/oauth/oauth20/token';
                
                insert akana;
                
                
                Case USMSCase = New Case();
                Recordtype Rtid=[Select id,developerName from Recordtype where DeveloperName = 'LG_B2B_CARE_USMS_Ticket_UM'];
                USMSCase.RecordtypeId=Rtid.id;
                USMSCase.LG_B2B_USMS_Categorization_Tier1__c='Connectivity';
                USMSCase.LG_B2B_USMS_Categorization_Tier2__c='Internet';
                USMSCase.LG_B2B_USMS_Company__c='Unity Media';
                USMSCase.Subject='Internet Connectivity is very slow';
                USMSCase.Description='Urgently fix the Internet Connectivity for the customer';
                //USMSCase.LG_B2B_USMS_Impact__c='1-Extensive/Widespread';
                USMSCase.LG_B2B_USMS_Urgency__c='High';
                USMSCase.LG_B2B_USMS_Service__c='Ingress DE';
                USMSCase.ParentId=ParentCase.Id;
                Insert USMSCase;
                
                
                
                
                USMSId.add(USMSCase.id);
                
                Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new LG_Care_USMS_MockHttpResponseGenerator());
                LG_Care_USMS_SF_TO_USMS_Ticket.CreateChildCase(USMSId);
                system.assertNotEquals(null,LG_Care_USMS_SF_TO_USMS_Ticket.createXml);
                Test.StopTest();
            }
        }
        
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}
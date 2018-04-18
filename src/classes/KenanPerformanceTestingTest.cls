@isTest
public class KenanPerformanceTestingTest {
	@testSetup static void setup() {
        // Create common test accounts
        Account samAct = new Account();
        samAct.Name = 'Sample Account';
        insert samAct; 
        
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        insert ksc; 
    }
    public static testmethod void createSFDCAccountTest() {
        KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanPerformanceTesting.createSFDCAccount('Test Account');
		Test.stopTest();
    }
    
	public static testmethod void createKenanAccountTest() {
       
		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanPerformanceTesting.createKenanAccount('Test123');
		Test.stopTest();

     }
    
    public static testmethod void createSampleOrderTest() {
        Account a = [select id from Account];
		KenanServiceCalloutMock servMock = new KenanServiceCalloutMock();
		servMock.numberOfRecords = 2;
		Test.setMock (HttpCalloutMock.class, servMock);
		
        
		Test.startTest();
		KenanPerformanceTesting.createSampleOrder(a.id,1,true,true);
		Test.stopTest();

     }
    
    public static testmethod void createSampleOrder2Test() {
        Account a = [select id from Account];
		KenanServiceCalloutMock servMock = new KenanServiceCalloutMock();
		servMock.numberOfRecords = 2;
		Test.setMock (HttpCalloutMock.class, servMock);
		
        
		Test.startTest();
		KenanPerformanceTesting.createSampleOrder(a.id,1,true,false);
		Test.stopTest();

     }
   
}
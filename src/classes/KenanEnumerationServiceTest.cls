/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
public class KenanEnumerationServiceTest {
	
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
    
	@isTest
	static void testGetEnumerations() {
		String enumName = 'UnitsTypeBean';

		KenanEnumerationServiceCalloutMock enumerationMock = new KenanEnumerationServiceCalloutMock();
        enumerationMock.enumName = enumName;
        Test.setMock (HttpCalloutMock.class, enumerationMock);

		Test.startTest();
		KenanEnumeration enumeration = KenanEnumerationService.getEnumeration('SampleEnum');
		Test.stopTest();

		System.assertNotEquals(null, enumeration);
		System.assertEquals( enumName, enumeration.enumName);
		
			for (List<String> dataList: enumeration.dataList) {
				for (String dataItem: dataList) {
					System.assertEquals('Test Data List: ' + enumName, dataItem);
				}
			}

			for (String fieldItem: enumeration.fieldList) {
				System.assertEquals('Test Field List: ' + enumName, fieldItem);
			}

			for (String keyItem: enumeration.keyList) {
				System.assertEquals('Test Key List: ' + enumName, keyItem);
			}
		
	}
}
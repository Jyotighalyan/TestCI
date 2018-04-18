/************************************************************************************************************************************
*        Class: LG_UpdateCase
*     Program : B2B SELF CARE PROGRAM
*  Description: Test class for LG_UpdateCase
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 02-AUG-2017
*************************************************************************************************************************************/


@isTest
public class Lg_UpdateCaseTest {
    	public static Account acc;
		public static csord__Order_Request__c orderRequest;
    	public static csord__Subscription__c sub;
    	public static cscrm__Address__c address; 
    	public static csord__Service__c service;
		public static Case c;
        static List<caseComment> caseComment_List  = new List<caseComment>();
        static List<String> caseCommentBodyList = new List<String>();
   		
    	@testSetup
    	public static void updateCaseFieldsTest(){

        
        acc = new Account (
		Name = 'newAcc1'
		);  
		insert acc;

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
            
        c = new Case(AccountId = acc.Id, Status = 'New');
            
        c.subject = 'test';
            c.Priority = 'P2';
            c.Type = 'Service';
            c.Description = 'description';
            c.Origin = 'Email';
            c.LG_Service__c = service.id;
        insert c;
            system.debug('case inserted=='+c);
                    
        caseComment cs = new caseComment();
		cs.parentId = c.id;
        cs.CommentBody = 'test comment body';
        cs.IsPublished = true;
		insert cs;
          
        caseComment cs1 = new caseComment();
		cs1.parentId = c.id;
        cs1.CommentBody = 'test1 comment body';
        cs1.IsPublished = true;
		insert cs1;
            
        caseComment cs2 = new caseComment();
		cs2.parentId = c.id;
        cs2.CommentBody = 'test2 comment body';
        cs2.IsPublished = true;
		insert cs2;
            
        caseComment_List.add(cs);
        caseComment_List.add(cs1);
        caseComment_List.add(cs2);
        
        for(caseComment cc : caseComment_List)
		{
		caseCommentBodyList.add(cc.CommentBody);
		}
            system.debug('caseCommentBodyList value'+caseCommentBodyList);
        }    
        
    	public static testMethod void updateCaseTest1(){
        system.debug('print case=='+[select id, type, CaseNumber from Case where type =: 'Service' limit 1]);         
		RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        Case cs = [select id, type, CaseNumber from Case where type =: 'Service' limit 1];
        
        request.requestUri =
            'https://cs88.salesforce.com/services/apexrest/updateCase/' + cs.CaseNumber;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{"newCaseStatus" : "Open", caseComment_BodyList": null}');
        RestContext.request = request;
      	RestContext.response = res;
            
            LG_UpdateCase.caseResponseReturnStatus('Open', cs, cs.CaseNumber);    	
        }
        
    	public static testMethod void updateCaseTest2(){
        system.debug('inside==');		
        system.debug('caseCommentBodyList value =='+caseCommentBodyList.size());
        RestRequest request1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        Case cs = [select id, type, CaseNumber from Case where type =: 'Service' limit 1];
        List<caseComment> caseComment_BodyListNew = [select ParentId from caseComment where ParentId =: cs.id];
        List<String> caseComm = new List<String>();
            for(caseComment c : caseComment_BodyListNew){
                caseComm.add(String.valueOf(c));
            }
  
            request1.requestUri =
            'https://cs88.salesforce.com/services/apexrest/updateCase/' + cs.CaseNumber;
        request1.httpMethod = 'PATCH';
        request1.addHeader('Content-Type', 'application/json');
        request1.requestBody = Blob.valueOf('{caseComment_BodyList": caseComment_List, "newCaseStatus" : "Open"}');
        RestContext.request = request1;
      	RestContext.response = res1;
		
        LG_UpdateCase.caseResponseReturnStatusAndCaseComment('Open', caseComm, cs, cs.CaseNumber);
        }    

    	public static testMethod void updateCaseTest3(){
        RestRequest request2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        Case cs = [select id, type, CaseNumber from Case where type =: 'Service' limit 1];
            request2.requestUri =
            'https://cs88.salesforce.com/services/apexrest/updateCase/' + cs.CaseNumber;
        request2.httpMethod = 'PATCH';
        request2.addHeader('Content-Type', 'application/json');
        request2.requestBody = Blob.valueOf('{caseComment_BodyList": caseComment_List, "newCaseStatus" : ""}');
        RestContext.request = request2;
      	RestContext.response = res2;
            system.debug('before method');
        
        LG_UpdateCase.caseResponseReturnCaseComment(caseCommentBodyList, cs, cs.CaseNumber);
        }
        
    	public static testMethod void updateCaseTest4(){
        RestRequest request2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        Case cs = [select id, type, CaseNumber from Case where type =: 'Service' limit 1];
        List<caseComment> caseComment_BodyListNew = [select ParentId from caseComment where ParentId =: cs.id];
        List<String> caseComm = new List<String>();
            for(caseComment c : caseComment_BodyListNew){
                caseComm.add(String.valueOf(c));
            }
  
            request2.requestUri =
            'https://cs88.salesforce.com/services/apexrest/updateCase/' + cs.CaseNumber;
        request2.httpMethod = 'PATCH';
        request2.addHeader('Content-Type', 'application/json');
        request2.requestBody = Blob.valueOf('{caseComment_BodyList": caseComment_List, "newCaseStatus" : "Open"}');
        RestContext.request = request2;
      	RestContext.response = res2;
        system.debug('before method');
      
		LG_UpdateCase.updateCaseFields(caseCommentBodyList, 'Open');
        LG_UpdateCase.caseResponseReturnStatus('Open', cs, cs.CaseNumber);  
        LG_UpdateCase.caseResponseReturnStatusAndCaseComment('Open', caseCommentBodyList, cs, cs.CaseNumber);
        LG_UpdateCase.caseResponseReturnCaseComment(caseComm, cs, cs.CaseNumber);
            
    }  

}
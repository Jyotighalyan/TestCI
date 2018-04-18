/************************************************************************************************************************************
*        Class: LG_UpdateCase
*     Program : B2B SELF CARE PROGRAM
*  Description: we expose classes as REST Service and perform UPDATE operation on Case object.
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 16-SEP-2017
*   Test Class: Lg_UpdateCaseTest
*************************************************************************************************************************************/

@RestResource(urlMapping='/updateCase/*')
global class LG_UpdateCase { 
    
    static RestRequest request = RestContext.request;
    static RestResponse res = RestContext.response;
    static String jsonResponse = '';
    static String  status;
    
    @HttpPatch
    global static void updateCaseFields(List<string> caseComment_BodyList, string newCaseStatus) 
    {
        try{
                res.statusCode = 200;
            	RestContext.response.addHeader('Content-Type', 'application/json'); 
                String caseNumber = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
                system.debug('caseId---'+caseNumber);
                Case thisCaseReturn = [SELECT Id, CaseNumber, status, LG_Case_Reason__c, contact.account.LG_AccountNumber__c, (Select Id, ParentId, isPublished, CommentBody, CreatedById, CreatedDate From CaseComments) FROM Case WHERE CaseNumber = :caseNumber];
            
                
                if(newCaseStatus!=null && (caseComment_BodyList==null || caseComment_BodyList.isEmpty())){
                system.debug('newCaseStatus----'+newCaseStatus);
                caseResponseReturnStatus(newCaseStatus, thisCaseReturn, caseNumber);
                }
                
                else if(newCaseStatus!=null && caseComment_BodyList.size()>0){
                caseResponseReturnStatusAndCaseComment(newCaseStatus,caseComment_BodyList, thisCaseReturn, caseNumber);
                }
            
                else if(newCaseStatus==null && caseComment_BodyList!=null &&caseComment_BodyList.size()>0){
                caseResponseReturnCaseComment(caseComment_BodyList, thisCaseReturn, caseNumber);
                }
                else{
                    res.statusCode=202;
                    status='case comment or status to be updated missing';
                    return;
                }
            }
            catch(Exception e){
            system.debug('except------'+e);
            res.statusCode = 400;               
            jsonResponse = Json.serialize(e.getMessage());
            res.responseBody = blob.valueOf(jsonResponse);
            return;
            }
    }
        
            global static void caseResponseReturnStatus(string newCaseStatus , Case thisCaseReturn , String caseNumber)
            {
                String jsonResponse = '';
                
                thisCaseReturn.Status = newCaseStatus;
                update thisCaseReturn;
                system.debug('thisCaseReturn.Status+++'+thisCaseReturn.Status);
                Case thisCase = [SELECT Id, CaseNumber, status, contact.account.LG_AccountNumber__c FROM Case WHERE CaseNumber = :caseNumber];
                system.debug('thisCase+++'+thisCase);
                jsonResponse = Json.serialize(thisCase);
                res.responseBody = blob.valueOf(jsonResponse);
                system.debug('thisCase==========='+thisCase);
                return;
            }
        
        
            global static void caseResponseReturnStatusAndCaseComment(string newCaseStatus, List<string> caseComment_BodyList, Case thisCaseReturn , String caseNumber){
                thisCaseReturn.Status = newCaseStatus;
                update thisCaseReturn;
                List<caseComment> caseComment_List = new List<caseComment>();
                if(caseComment_BodyList!=null){
                    for(String caseComment_Body:caseComment_BodyList)
                    {
                        caseComment cs = new caseComment();
                        cs.CommentBody=caseComment_Body;
                        cs.parentId=thisCaseReturn.Id;
                        cs.IsPublished = true;
                        caseComment_List.add(cs);
                    }
                insert caseComment_List;
                }
                Case thisCase = [SELECT Id, CaseNumber, status, contact.account.LG_AccountNumber__c, (Select Id, ParentId, isPublished, CommentBody, CreatedById, CreatedDate From CaseComments where id IN :caseComment_List) FROM Case WHERE CaseNumber = :caseNumber];
                jsonResponse = Json.serialize(thisCase);
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            global static void caseResponseReturnCaseComment(List<string> caseComment_BodyList, Case thisCaseReturn , String caseNumber){
                //update thisCaseReturn;
                List<caseComment> caseComment_List = new List<caseComment>();
                if(caseComment_BodyList!=null){
                    for(String caseComment_Body:caseComment_BodyList)
                    {
                        caseComment cs = new caseComment();
                        cs.CommentBody=caseComment_Body;
                        cs.parentId=thisCaseReturn.Id;
                        cs.IsPublished = true;
                        caseComment_List.add(cs);
                    }
                insert caseComment_List;
                }
                Case thisCase = [SELECT Id, CaseNumber, status, contact.account.LG_AccountNumber__c, (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate From CaseComments where id IN :caseComment_List) FROM Case WHERE CaseNumber = :caseNumber];
                jsonResponse = Json.serialize(thisCase);
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            
            }

    }
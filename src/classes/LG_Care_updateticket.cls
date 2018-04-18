/********************************************************************************************************
*        Class: LG_Care_updateticket 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It will be used to update CaMa case in salesforce when response comes from CaMa External System
*              
*    Author(s): Jagannath Behera(Infosys Ltd)
* Created Date: 28-June-2017
*   Test Class: LG_Care_updateticket_Test
*********************************************************************************************************/



@RestResource(urlMapping='/updateticket/*')
global with sharing class LG_Care_updateticket {

public static Set<String> caseNumbers{get;set;}    
 @HttpPost
    global static void doPost() {
        List<Case> CaseRecord = new List<Case>();
      
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if(req.requestBody != null){
            system.debug('----------- '+req.requestBody.toString());
            //LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'CaMa System Temp',null,null, req.requestBody.toString(), null);
           XmlStreamReader reader = new XmlStreamReader(req.requestBody.toString());
            caseNumbers = new Set<String>();
            
            List<caseWrapper> caseWrapperList = parsecaseWrappers(reader);
            
            Map<String,Case> caseMap = new Map <String,Case>();
            
                   
            for(Case caseObj : [SELECT Id,CaseNumber,B2B_Completion_Status__c,B2B_Position_Comment__c from Case where CaseNumber like: caseNumbers] )
            {
                
                caseMap.put(caseObj.CaseNumber, caseObj);
                for(CaseWrapper CaseWrap :caseWrapperList ){
                    if(caseObj.CaseNumber.endsWith(CaseWrap.caseId)){
                        CaseWrap.caseId = caseObj.CaseNumber;
                    }
                }
                
            }
            
        CaseRecord=CaseMapMethod(caseWrapperList,caseMap);
            
        String sf_jsonResponse = '';
        try{ 
            update CaseRecord;
            sf_jsonResponse = '{"response": {"success": "true"}}';
            res.statusCode = 200;
            res.responseBody = blob.valueOf(sf_jsonResponse);
            res.addHeader('Content-Type', 'application/json');
            return;
        }catch(Exception e){
            
            sf_jsonResponse = '{"response": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
            res.statusCode = 500;
            res.responseBody = blob.valueOf(sf_jsonResponse);
            res.addHeader('Content-Type', 'application/json');
            LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'CaMa System',null,sf_jsonResponse, req.requestBody.toString(), null);
            return;
        }
   
    }
  }
 Public Static List<case> CaseMapMethod(List<caseWrapper> CaseMapWrapper , Map<String,Case> caseMapper)
  {
  List<case> CaseUpdate = new List<Case>();
         
         List<CaseComment> caseCommList = new List<CaseComment>();
         
            for(CaseWrapper CaseWrap :CaseMapWrapper){
                
                Case Cs = New Case();
           
                Cs.Id = (caseMapper.get(CaseWrap.caseId)).Id;
                if(CaseWrap.orderNumber != null && CaseWrap.orderNumber != '')
                    Cs.CaMa_Ticket_ID__c = CaseWrap.orderNumber;
             
                if(CaseWrap.orderStatus=='CN'){
                    Cs.B2B_Order_Status__c = 'CN(Cancelled)';  
                
                }
                else if(CaseWrap.orderStatus=='CP'){
                    Cs.B2B_Order_Status__c = 'CP(Completed)';  
                }
                else if(CaseWrap.orderStatus=='ND'){
                    Cs.B2B_Order_Status__c = 'ND(Not done)';
                }
                else if(CaseWrap.orderStatus=='PC'){
                    Cs.B2B_Order_Status__c = 'PC(Pending cancellation)';
                }
                else if(CaseWrap.orderStatus !=null && CaseWrap.orderStatus !=''){
                    Cs.B2B_Order_Status__c = CaseWrap.orderStatus;
                }
                
                if(CaseWrap.completionStatus== null && CaseWrap.orderNumber != null && CaseWrap.orderNumber != '' && (caseMapper.get(CaseWrap.caseId)).B2B_Completion_Status__c == null)
                    Cs.B2B_Completion_Status__c = 'P';
                else if(CaseWrap.completionStatus != null)
                    Cs.B2B_Completion_Status__c = CaseWrap.completionStatus;
                
                if(CaseWrap.technicianId != null) Cs.B2B_Technician_Id__c = CaseWrap.technicianId; 
                if(CaseWrap.technicianName != null) Cs.B2B_Technician_Name__c = CaseWrap.technicianName;
                if(CaseWrap.faultCode != null) Cs.B2B_Fault_Code__c = CaseWrap.faultCode;
                if(CaseWrap.findingCode != null) Cs.B2B_Finding_Code__c = CaseWrap.findingCode;
                if(CaseWrap.solutionCode != null) Cs.B2B_Solution_Code__c = CaseWrap.solutionCode;
                if(CaseWrap.positionComment != null){
                    Cs.B2B_Position_Comment__c = CaseWrap.positionComment;
                    if(CaseWrap.positionComment != '' && CaseWrap.positionComment != caseMapper.get(CaseWrap.caseId).B2B_Position_Comment__c ){
                        CaseComment com = new CaseComment();
                        com.ParentId = cs.Id;
                        com.CommentBody= CaseWrap.positionComment;
                        caseCommList.add(com);
                    }
                }
                if(CaseWrap.orderComment != null) Cs.UM_Order_Comment_from_CaMa__c = CaseWrap.orderComment;  
                if(CaseWrap.completionTime != null) Cs.B2B_Completion_Time__c = CaseWrap.completionTime;
                if(CaseWrap.completionDate != null) Cs.B2B_Completion_Date__c = CaseWrap.completionDate;
                if(CaseWrap.notDoneCode != null) Cs.B2B_Not_Done_Code__c = CaseWrap.notDoneCode;
                if(CaseWrap.cancellationCode != null)
                {
                if(CaseWrap.cancellationCode=='01') Cs.B2B_Care_Cancellation_Code__c='01  Kunde verweigert Zutritt';
                else if(CaseWrap.cancellationCode=='02') Cs.B2B_Care_Cancellation_Code__c='02  laut Kd. wieder in Ordnung';
                else if(CaseWrap.cancellationCode=='03') Cs.B2B_Care_Cancellation_Code__c='03  VOM KUNDEN WIDERRUFEN';
                else if(CaseWrap.cancellationCode=='04') Cs.B2B_Care_Cancellation_Code__c='04  Fehler Innendienst';
                else if(CaseWrap.cancellationCode=='05') Cs.B2B_Care_Cancellation_Code__c='05  Kunde zieht Störung fehlt';
                } 
                //else Cs.B2B_Care_Cancellation_Code__c=' ';
                /*if(CaseWrap.errorCode != null) Cs.B2B_Error_Code__c = CaseWrap.errorCode;*/
                Cs.B2B_Error_Code__c = CaseWrap.errorCode;
                cs.B2B_Error_Message__c = CaseWrap.errorMessage;
                
                if(CaseWrap.errorMessage != null) {
                    //cs.B2B_Error_Message__c = CaseWrap.errorMessage;
                    cs.B2B_Success__c = false;
                }
                
                //Lock the record
                if(CaseWrap.completionStatus == 'C'){
                    if(CaseWrap.orderStatus=='CN'){
                        Cs.status = 'Cancelled';
                    }
                    else{
                        Cs.status = 'Completed';
                    }
                }
                CaseUpdate.add(Cs);
         }
         if(caseCommList.size() > 0){
             insert caseCommList;
         }
  return CaseUpdate;
  }
    


 public static caseWrapper[] parsecaseWrappers(XmlStreamReader reader) {
        caseWrapper[] caseWrappers = new caseWrapper[0];
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            // Start at the beginning of the caseWrapper and make sure that it is a caseWrapper
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('ticket' == reader.getLocalName()) {
                    // Pass the caseWrapper to the parsecaseWrapper method (below) 
                    caseWrapper caseWrapper = parsecaseWrapper(reader);
                    caseWrappers.add(caseWrapper);
                    
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
           
        }
        return caseWrappers;
    }

    // Parse through the XML, determine the author and the characters
    private static caseWrapper parsecaseWrapper(XmlStreamReader reader) {
        caseWrapper caseWrapper = new caseWrapper();
        
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'ticket' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'CaseID') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.caseId = reader.getText();
                    caseNumbers.add('%' +reader.getText());
                    
                }
            }
           
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'OrderNumber') {
                 
                reader.next();
                 if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.orderNumber= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'completionStatus') {
               
            reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                
                    caseWrapper.completionStatus = reader.getText();
                }
            }
            
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'orderStatus') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.orderStatus= reader.getText();
                }
            }
            
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'technicianId') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.technicianId= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'technicianName') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.technicianName= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'macAddress') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.macAddress= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'faultCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.faultCode= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'findingCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.findingCode= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'solutionCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.solutionCode = reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'positionComment') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.positionComment= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'orderComment') {
                
                reader.next();
                
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.orderComment= reader.getText();
                }
                reader.next();
                while(reader.getEventType() != XmlTag.END_ELEMENT){
                    caseWrapper.orderComment = caseWrapper.orderComment + reader.getText();
                    reader.next();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'completionDate') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.completionDate= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'completionTime') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.completionTime= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'notDoneCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.notDoneCode= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'cancellationCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.cancellationCode= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'errorCode') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.errorCode= reader.getText();
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'errorMessage') {
                reader.next();
                if (reader.getEventType() == XmlTag.CHARACTERS) {
                    caseWrapper.errorMessage= reader.getText();
                }
            }

            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } 
            else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return caseWrapper;
    }

    public class caseWrapper{
        public string caseId{get;set;}
        public string orderNumber{get;set;}
        public string completionStatus{get;set;}
        public string orderStatus{get;set;}
        public string technicianId{get;set;}
        public string technicianName{get;set;}
        public string macAddress{get;set;}
        public string faultCode{get;set;}
        public string findingCode{get;set;}
        public string solutionCode{get;set;}
        public string positionComment{get;set;}
        public string orderComment{get;set;}
        public string completionDate{get;set;}
        public string completionTime{get;set;}
        public string notDoneCode{get;set;}
        public string cancellationCode{get;set;}
        public string errorCode{get;set;}
        public string errorMessage{get;set;}
    }
  
}
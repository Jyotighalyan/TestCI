/************************************************************************************************************************************
*        Class: LG_Care_CaMaTicket_Transaction
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will create, update, cancel a ticket in CaMa.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_CaMaTicket_Transaction_Test & LG_Care_CaMa_MockHttpResponseGenerator
*************************************************************************************************************************************/
Global class LG_Care_CaMaTicket_Transaction{
    Static final B2B_Care_Ext_Connections__c camaConn = B2B_Care_Ext_Connections__c.getInstance('CaMa External System Info');
    
    public static HTTPResponse res;
    public static HttpRequest req;
    public static String createXml;
    
    Static String Region;
    Static Long childCaseId;
    Static final String authorization = camaConn.Authentication_Token__c;
    
    //Arguments for create method
    Static String customerNumber;
    Static String orderType;
    Static String problemCode;
    Static String sourceCode;
    Static String ticketPriority;
    Static String orderRemarks;
    Static String orderComment;
    Static Long orderNumber;
    Static String outageService;
    Static String outageType;
    Static String customerSituation;
    Static String overrideActivityProfile;
    
    //Extra agruments for Cancel process
    Static String statusChangeCode;
    Static String cancellationCode;
    
    //A variable to know the operation
    public static String operation;
    
    public static void createXML_for_CreateTicketRequest(Case camaCase) {
        try{
            Case caseObj = [SELECT CaseNumber from case where id =: camaCase.Id limit 1];
            Region = camaCase.B2B_Region__c;
            String temp = caseObj.caseNumber;
            if(temp!=null)
                childCaseId = Long.valueOf(temp);
            if(camaCase.B2B_Customer_Number__c!=null)
                customerNumber = camaCase.B2B_Customer_Number__c;
            orderType = camaCase.B2B_Order_Type__c;
            problemCode = camaCase.B2B_Problem_Code__c;
            sourceCode = camaCase.B2B_Source_Code__c;
            ticketPriority = camaCase.B2B_Ticket_Priority__c;
            if(camaCase.B2B_Order_Remarks__c != null)
                orderRemarks = camaCase.B2B_Order_Remarks__c;
            else
                orderRemarks = '';
            orderComment = camaCase.B2B_Order_Comment__c;
            outageService = camaCase.B2B_Outage_Service__c; 
            outageType = camaCase.B2B_Outage_Type__c; 
            customerSituation = camaCase.B2B_Customer_Situation__c ; 
            //overrideActivityProfile = null;
            //customerSituation = 'Customer situation';
            
                        
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
                w.writeStartElement(null, 'Envelope', null);
                    w.writeNamespace('', 'http://schemas.xmlsoap.org/soap/envelope/');
                    w.writeStartElement(null, 'Body', null);
                        w.writeStartElement(null, 'createTroubleTicket', null);
                            w.writeNamespace('', 'http://ticketws.unitymedia.com/');
                                w.writeStartElement(null, 'region', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(Region);
                                w.writeEndElement(); //end region
                                w.writeStartElement(null, 'childCaseId', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(childCaseId));
                                w.writeEndElement(); //end childCaseId
                                w.writeStartElement(null, 'customerNumber', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(customerNumber));
                                w.writeEndElement(); //end customerNumber
                                w.writeStartElement(null, 'orderType', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(orderType);
                                w.writeEndElement(); //end orderType
                                w.writeStartElement(null, 'problemCode', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(problemCode);
                                w.writeEndElement(); //end problemCode
                                w.writeStartElement(null, 'sourceCode', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(sourceCode);
                                w.writeEndElement(); //end sourceCode
                                w.writeStartElement(null, 'ticketPriority', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(ticketPriority);
                                w.writeEndElement(); //end ticketPriority
                                w.writeStartElement(null, 'outageService', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(outageService);
                                w.writeEndElement(); //end outageService
                                
                                w.writeStartElement(null, 'outageType', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(outageType);
                                w.writeEndElement(); //end outageType
                                w.writeStartElement(null, 'customerSituation', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(customerSituation);
                                w.writeEndElement(); //end customerSituation
                                w.writeStartElement(null, 'overrideActivityProfile', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters('');
                                w.writeEndElement(); //end overrideActivityProfile
                                w.writeStartElement(null, 'orderRemarks', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(orderRemarks);
                                w.writeEndElement(); //end orderRemarks
                                w.writeStartElement(null, 'orderComment', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(orderComment);
                                w.writeEndElement(); //end orderComment
                                w.writeStartElement(null, 'authorization', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(authorization);
                                w.writeEndElement(); //end authorization
            
                        w.writeEndElement(); //end createTroubleTicket
                    w.writeEndElement(); //end Body
                w.writeEndElement(); //end Envelope
            w.writeEndDocument();
            createXml = w.getXmlString();
            w.close();
            
            operation = 'Creation';
            LG_Care_CaMaTicket_Transaction.camaTicketRequest(createXml,camaCase.Id,operation, null);
        }
        catch(Exception e) {
        }
    }
    
    @InvocableMethod(label='Update Order Comments')
    public static void createXML_for_UpdateTicketRequest(List<Id> camaCaseid) {  
    
        try {
            List<Case> camaCase=[Select id,UM_Order_Comment_Prior_value__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c,B2B_Order_Remarks__c,B2B_Order_Comment__c
                                from Case where id=:camaCaseId[0] limit 1 ]  ;
            Region = camaCase[0].B2B_Region__c;
            String temp = camaCase[0].caseNumber;
            if(temp!=null)
                childCaseId = Long.valueOf(temp);
            temp = camaCase[0].CaMa_Ticket_ID__c;
            if(temp!=null)
                orderNumber = Long.valueOf(temp);
            if(camaCase[0].B2B_Order_Remarks__c!=null)
                orderRemarks = camaCase[0].B2B_Order_Remarks__c;
            else
                orderRemarks = '';
            
            
            if(camaCase[0].UM_Order_Comment_Prior_value__c != null && camaCase[0].B2B_Order_Comment__c != camaCase[0].UM_Order_Comment_Prior_value__c){
                orderComment = camaCase[0].B2B_Order_Comment__c;
            }
            else{
                orderComment  ='';
            }
            //orderComment = camaCase[0].B2B_Order_Comment__c;
        
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
                w.writeStartElement(null, 'Envelope', null);
                    w.writeNamespace('', 'http://schemas.xmlsoap.org/soap/envelope/');
                    w.writeStartElement(null, 'Body', null);
                        w.writeStartElement(null, 'updateTroubleTicket', null);
                            w.writeNamespace('', 'http://ticketws.unitymedia.com/');
                                w.writeStartElement(null, 'region', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(Region);
                                w.writeEndElement(); //end region
                                w.writeStartElement(null, 'childCaseId', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(childCaseId));
                                w.writeEndElement(); //end childCaseId
                                w.writeStartElement(null, 'orderNumber', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(orderNumber));
                                w.writeEndElement(); //end orderNumber
                                w.writeStartElement(null, 'orderRemarks', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(orderRemarks);
                                w.writeEndElement(); //end orderRemarks
                                w.writeStartElement(null, 'orderComment', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(orderComment);
                                    //w.writeComment(orderComment);
                                w.writeEndElement(); //end orderComment
                                w.writeStartElement(null, 'authorization', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(authorization);
                                w.writeEndElement(); //end authorization
            
                        w.writeEndElement(); //end createTroubleTicket
                    w.writeEndElement(); //end Body
                w.writeEndElement(); //end Envelope
            w.writeEndDocument();
            createXml = w.getXmlString();
            w.close();
            
            
            operation = 'Updation';
            LG_Care_CaMaTicket_Transaction.camaTicketRequest(createXml,camaCase[0].id,operation, orderComment);
        }   
        catch(Exception e) {
            system.debug(e);
        }
    }
    
    Webservice static void createXML_for_CancelTicketRequest(Case camaCase) {
        try {
            region = camaCase.B2B_Region__c;
            String temp = camaCase.caseNumber;
            if(temp!=null)
                childCaseId = Long.valueOf(temp);
            temp = camaCase.CaMa_Ticket_ID__c;
            if(temp!=null)
                orderNumber = Long.valueOf(temp);
            statusChangeCode = 'C'; 
            //faultCode = '1'; 
            //findingCode = camaCase[0];
            //solutionCode = camaCase[0];
            //positionComment = camaCase[0];
            //completionDate = camaCase[0];
            //completionTime = camaCase[0];
            //notDoneCode = camaCase[0];
            List<String> codes = camaCase.B2B_Care_Cancellation_Code__c.split(' ');
            cancellationCode = codes[0].trim();
            
          
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
                w.writeStartElement(null, 'Envelope', null);
                    w.writeNamespace('', 'http://schemas.xmlsoap.org/soap/envelope/');
                    w.writeStartElement(null, 'Body', null);
                        w.writeStartElement(null, 'changeTroubleTicket', null);
                            w.writeNamespace('', 'http://ticketws.unitymedia.com/');
                                w.writeStartElement(null, 'region', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(Region);
                                w.writeEndElement(); //end region
                                w.writeStartElement(null, 'childCaseId', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(childCaseId));
                                w.writeEndElement(); //end childCaseId
                                w.writeStartElement(null, 'orderNumber', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(String.valueOf(orderNumber));
                                w.writeEndElement(); //end orderNumber
                                w.writeStartElement(null, 'statusChangeCode', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(statusChangeCode);
                                w.writeEndElement(); //end orderRemarks
                                w.writeStartElement(null, 'cancellationCode', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(cancellationCode);
                                w.writeEndElement(); //end orderComment
                                w.writeStartElement(null, 'authorization', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(authorization);
                                w.writeEndElement(); //end authorization
            
                        w.writeEndElement(); //end createTroubleTicket
                    w.writeEndElement(); //end Body
                w.writeEndElement(); //end Envelope
            w.writeEndDocument();
            createXml = w.getXmlString();
            w.close();
            
            operation = 'Cancellation';
            LG_Care_CaMaTicket_Transaction.camaTicketRequest(createXml, camaCase.Id,operation, null);
        }   
        catch(Exception e) {
        }
            
    }
    
    @future (callout=true)
    Public static void camaTicketRequest(String createXml, String camaCaseId, String operation, String ordercomment){
        try{
            System.debug('------------------- '+createXml);
            req = new HttpRequest();
            req.setTimeout(120000); // timeout in milliseconds
            req.setEndpoint(camaConn.Connection_URL__c);//custom settings
            req.setMethod('POST');
            req.setHeader('Content-Type','text/xml;charset=UTF-8');
            Double noOfTries = camaConn.UM_No_of_Tries__c;//custom settings
        
            req.setBody(createXml);
            Http http = new Http();
            
            while(noOfTries != 0) {
                res = http.send(req);
                if(res.getStatusCode() != 200){
                    noOfTries = noOfTries - 1;
                }
                else
                    noOfTries = 0;
            }
            system.debug('---body--- '+res.getBody());
            Case caMaCase = new Case();
            caMaCase.Id = camaCaseId;
            XmlStreamReader reader = res.getXmlStreamReader();
            boolean isSafeToGetNextXmlElement = true;
            while(isSafeToGetNextXmlElement) {
            
                if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'success') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        caMaCase.B2B_Success__c = Boolean.valueOf(reader.getText());
                    
                    }
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'errorCode') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        caMaCase.B2B_Error_Code__c = reader.getText();
                    }
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'errorMessage') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        caMaCase.B2B_Error_Message__c = reader.getText();
                    }
                }
            
                if (reader.hasNext()) {
                    reader.next();
                } else {
                    isSafeToGetNextXmlElement = false;
                    break;
                }
            }
            if(ordercomment!= null && ordercomment != '' && caMaCase.B2B_Success__c == true){
                CaseComment com = new CaseComment();
                com.ParentId = camaCaseId;
                com.CommentBody= ordercomment;
                insert com;
            }
            if( operation.equalsIgnoreCase('cancellation') && caMaCase.B2B_Success__c == true ) {
                caMaCase.status = 'Cancelled';
                caMaCase.B2B_Status_Change_Code__c = 'C';
                caMaCase.B2B_Completion_Status__c  = 'C';
                caMaCase.B2B_Order_Status__c  = 'CN(Cancelled)';
            }
            Database.Update(caMaCase);
            }
            catch(Exception e) {
                LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'CaMa System',null,e.getStackTraceString(), req.getBody(), res.getBody());
            }
        }
   
   
}
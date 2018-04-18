/************************************************************************************************************************************
*        Class: LG_Care_USMS_Update_Ticket_SF_TO_USMS
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It will be called via process builder. If update on the USMS ticket in SFDC happens then the same would be sent to USMS.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 13-JULY-2017
*   Test Class: LG_Care_USMS_UpdateTicketSF_TO_USMSTest  
*************************************************************************************************************************************/

public class LG_Care_USMS_Update_Ticket_SF_TO_USMS {

    //Static Long childCaseId;
    //Static final String authorization = 'Basic cmVtZWR5LWVjby53czpyM20zZHktU0YzYzA='; // use a custom setting for this. 
    public static HTTPResponse res;
    public static String createXml;
    //Arguments for create method
    //Static String Action;
    Static Long IncidentId;
    Static String WorkInfoType;
    Static String WorkInfoNotes;
    Static String WorkInfoSource;
    public Static String OathToken;
    //A variable to know the operation
    public static String operation;

   
    @InvocableMethod(label='Update USMS Ticket')
    public static void B2B_Update_USMS_Ticket(List<Id> USMSCaseid) {
        try {
                   
           
            List<Case> USMSCase=[Select id, USMS_Ticket_ID__c, Origin,Parent.Origin, 
                                 B2B_Work_Info_Type__c, B2B_Work_Info_Notes__c from Case where id=:USMSCaseid limit 1 ]  ;
            
            /* extract case comments                     
            CaseComment c = [Select id, CommentBody from casecomment where parentid=:USMSCaseid order by createddate desc limit 1];   
            
            List<String> hparts = c.CommentBody.split('-');
            WorkInfoType = hparts[0];
            WorkInfoNotes = hparts[1];     
            WorkInfoSource = 'Email'; */
            
            WorkInfoType = USMSCase[0].B2B_Work_Info_Type__c;
            WorkInfoNotes = USMSCase[0].B2B_Work_Info_Notes__c;     
            //WorkInfoSource = USMSCase[0].Origin;
            WorkInfoSource = USMSCase[0].Parent.Origin;
            //Action = 'Modify';            
                                                                 
            String IncidentId = USMSCase[0].USMS_Ticket_ID__c;
            //IncidentId = Long.valueOf(temp);
                   /* 
             createXml= '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
                '<Body>'+
                    '<UpdateInput xmlns="urn:SFDC2USMS">'+ 
                        '<UpdateRequest xmlns="">'+                   
                            '<SourceSystemID>SFDC</SourceSystemID>'+
                            '<WorkInfoType>'+WorkInfoType+'</WorkInfoType>'+
                            '<WorkInfoNotes>'+WorkInfoNotes+'</WorkInfoNotes>'+
                            '<WorkInfoSource>'+WorkInfoSource+'</WorkInfoSource>'+
                            '<TicketID>'+IncidentId+'</TicketID>'+
                        '</UpdateRequest>'+
                    '</UpdateInput>'+
                '</Body>'+
            '</Envelope>';*/
           
            
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
                w.writeStartElement(null, 'Envelope', null);
                    w.writeNamespace('', 'http://schemas.xmlsoap.org/soap/envelope/');
                    w.writeStartElement(null, 'Body', null);
                        w.writeStartElement(null, 'UpdateInput', null);
                            w.writeNamespace('', 'urn:SFDC2USMS');
                              w.writeStartElement(null, 'UpdateRequest', null);
                                w.writedefaultNamespace('');
                                  w.writeStartElement(null, 'SourceSystemID', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters('SFDC');
                                w.writeEndElement(); //end SourceSystemID
                                w.writeStartElement(null, 'WorkInfoType', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(WorkInfoType);
                                w.writeEndElement(); //end WorkInfoType
                                w.writeStartElement(null, 'WorkInfoNotes', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(WorkInfoNotes);
                                w.writeEndElement(); //end WorkInfoNotes
                                w.writeStartElement(null, 'WorkInfoSource', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(WorkInfoSource);
                                w.writeEndElement(); //end WorkInfoSource
                                w.writeStartElement(null, 'TicketID', null);
                                    w.writedefaultNamespace('');
                                    w.writeCharacters(IncidentId);
                                w.writeEndElement(); //end TicketID  
                        w.writeEndElement(); //end UpdateRequest
                        w.writeEndElement(); //end UpdateInput
                    w.writeEndElement(); //end Body
                w.writeEndElement(); //end Envelope
            w.writeEndDocument();
            createXml = w.getXmlString();
            w.close();
                       system.debug('madrid '+createXML);
            // send request to USMS and recieve response.
            LG_Care_USMS_Update_Ticket_SF_TO_USMS.USMSTicketRequest(createXml,USMSCase[0].id);
            
            }
        Catch(Exception e) {
        
        }
        
    }
    
        @future (callout=true)
       Public static void USMSTicketRequest(String createXml, String USMSCaseId){
        HttpRequest req;
        try{
            
            B2B_Akana_Oath__c oauthToken=LG_Care_Oath_Authentication_akana.CreateToken();
                      
            B2B_Care_Ext_Connections__c akana = B2B_Care_Ext_Connections__c.getInstance('Aakana OFF Connection');
            req = new HttpRequest();
            req.setEndpoint(akana.Connection_URL__c);
            req.setMethod('POST');
            req.setHeader('Content-Type','text/xml;charset=UTF-8');
            req.setBody(createXml);
            req.setHeader('Authorization', oauthToken.Access_Token__c );
            req.setTimeout(120000);
            Http http = new Http();    
            
            res = http.send(req);
            System.debug('----------------------- '+res.getBody());
            
            Database.Update(oauthToken);
            
            Case USMSCase= new Case();
            USMSCase.Id = USMSCaseId;
            XmlStreamReader reader = res.getXmlStreamReader();
            boolean isSafeToGetNextXmlElement = true;
            while(isSafeToGetNextXmlElement) {
            
                if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'success') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Success__c = Boolean.valueOf(reader.getText());
                    
                    }
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'RequestID') {
                    //reader.next();
                    //if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Success__c = true;
                    
                    //}
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'faultcode') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Error_Code__c = reader.getText();
                    }
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'faultstring') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Error_Message__c = reader.getText();
                    }
                }
            
                if (reader.hasNext()) {
                    reader.next();
                } else {
                    isSafeToGetNextXmlElement = false;
                    break;
                }
            }
            
            Database.Update(USMSCase);
            }
            catch(Exception e) {
               
                LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS System',null,e.getStackTraceString(), req.getBody(), res.getBody());
            }
        }

}
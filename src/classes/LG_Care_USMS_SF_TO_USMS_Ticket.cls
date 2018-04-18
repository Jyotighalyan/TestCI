/************************************************************************************************************************************
*        Class: LG_Care_USMS_SF_TO_USMS_Ticket
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will create a ticket in USMS.
*    Author(s): Rishi Kapoor (Infosys Limited)
* Created Date: 13-JULY-2017
*   Test Class: LG_Care_USMS_SF_TO_USMS_Ticket_Test & LG_Care_USMS_MockHttpResponseGenerator 
*************************************************************************************************************************************/




Global Class LG_Care_USMS_SF_TO_USMS_Ticket{
    Static Care_USMS_Connection__c USMSConn ;
    Static String Country;
    Static String Company;
    Static String CategorizationTier1;
    Static String CategorizationTier2;
    Static String Impact;
    Static String Service;
    Static String Summary;
    Static String Urgency;
    Static String Notes;
    Static String FirstName;
    Static String LastName;
    Static String customerSituation;
    public static HTTPResponse res;
    public static String Createxml;
    public Static String resp;
    public Static Case Cs;
    
    
    
    
    @InvocableMethod(label='USMS Ticket Case')
    Webservice static void CreateChildCase(List<Id> USMSid){
        try{
            
            
            LG_Care_USMS_SF_TO_USMS_Ticket.createxml_for_CreateTicketRequest(USMSid);
            
            
        }
        Catch(Exception e) {
            throw e;
            
            
        }
    }
    public static void Createxml_for_CreateTicketRequest(list<id> USMSid) {
        try{
            String businessArea;    String majorIncident;    String supportTime;
            String serviceImpacted;    String sla;    String impactedCustomers;
            List<Case> USMS = [SELECT id,LG_B2B_USMS_Categorization_Tier1__c,LG_B2B_USMS_Categorization_Tier2__c,LG_B2B_USMS_Impact__c,
                               CaseNumber,LG_B2B_USMS_Service__c,Parentid,Subject,description,LG_B2B_USMS_Urgency__c,
                               LG_Care_Business_Area__c,LG_Care_Major_Incident__c,LG_Care_Service_Impact__c,LG_Care_SLA__c,LG_Care_Support_Time__c,LG_Care_Impacted_Customers__c from case where id =: USMSid[0] limit 1];
            String temp = USMS[0].caseNumber;
            if(temp!=null)
            {
                
                businessArea = usms[0].LG_Care_Business_Area__c;
                majorIncident = usms[0].LG_Care_Major_Incident__c;
                
                serviceImpacted = usms[0].LG_Care_Service_Impact__c;
                sla = usms[0].LG_Care_SLA__c;
                
                supportTime = usms[0].LG_Care_Support_Time__c;
                impactedCustomers = usms[0].LG_Care_Impacted_Customers__c;
                
                if(usms[0].LG_B2B_USMS_Service__c == 'HPBX PROD DE') {
                    usms[0].LG_B2B_USMS_Impact__c = '3-Moderate/Limited';
                }
                else {
                    usms[0].LG_B2B_USMS_Impact__c = '2-Significant/Large';
                }
                
                if(serviceImpacted == '2-Service Degradation') {
                    if(impactedCustomers == '1-"1 customer"') {
                        if(sla == '3-Medium SLA') {
                            usms[0].priority ='Medium';
                            usms[0].LG_B2B_USMS_Urgency__c = '4-Low';
                        }
                        else if(sla == '2-Basic SLA / MTTR 8h') {
                            usms[0].priority ='Low';
                            usms[0].LG_B2B_USMS_Urgency__c = '4-Low';
                        }
                    }
                    else if(impactedCustomers == '4-">= 4 customers"') {
                        if(sla == '3-Medium SLA') {
                            usms[0].priority ='High';
                            usms[0].LG_B2B_USMS_Urgency__c = '2-High';
                        }
                        else if(sla == '2-Basic SLA / MTTR 8h') {
                            usms[0].priority ='Medium';
                            usms[0].LG_B2B_USMS_Urgency__c = '3-Medium';
                        }
                    }
                }
                else if(serviceImpacted == '4-Service Outage') {
                    if(impactedCustomers == '4-">= 4 customers"' || impactedCustomers == '3-">=4 sites/services of 1 customer"') {
                        usms[0].priority ='Critical';
                        usms[0].LG_B2B_USMS_Urgency__c = '1-Critical';
                    }
                    else if(impactedCustomers == '2-"1-3 sites/services of 1 customer"') {
                        usms[0].priority ='High';
                        usms[0].LG_B2B_USMS_Urgency__c = '2-High';
                    }
                    else if(impactedCustomers == '99-n/a') {
                        usms[0].priority ='Medium';
                        usms[0].LG_B2B_USMS_Urgency__c = '3-Medium';
                    }
                }
                
                
                
                CategorizationTier1=USMS[0].LG_B2B_USMS_Categorization_Tier1__c;
                CategorizationTier2=USMS[0].LG_B2B_USMS_Categorization_Tier2__c;
                Impact=USMS[0].LG_B2B_USMS_Impact__c;
                Service=USMS[0].LG_B2B_USMS_Service__c;
                Summary=USMS[0].Subject;
                Urgency= USMS[0].LG_B2B_USMS_Urgency__c;
                Notes=USMS[0].Description;
                Cs=[Select id,B2B_Care_PE_Customer_Country_Info__c,Account.Name from Case where id=:USMS[0].Parentid ];
                
                Country=Cs.B2B_Care_PE_Customer_Country_Info__c;
                
            } 
            
            
            
            
            String sourceSystem = ''; 
            Care_USMS_Connection__c USMSConn =Care_USMS_Connection__c.getInstance(Country); 
            if(USMSConn != null){  
                Company= USMSConn.Company__c; 
                FirstName= USMSConn.First_Name__c;
                LastName= USMSConn.Last_Name__c;
                sourceSystem = USMSConn.Source_System__c;
            }
            
            //Urgency = '4-Low';
            /*
createXml= '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
'<Body>'+
'<Input xmlns="urn:SFDC2USMS">'+
'<Request xmlns="">'+
'<SourceSystemID>'+sourceSystem+'</SourceSystemID>'+
'<company>'+Company+'</company>'+
'<notes>'+Notes+'</notes>'+
'<serial>'+USMS[0].CaseNumber+'</serial>'+
'<summary>'+Summary+'</summary>'+
'<CategorizationTier1>'+CategorizationTier1+'</CategorizationTier1>'+
'<CategorizationTier2>'+CategorizationTier2+'</CategorizationTier2>'+
'<service>'+Service+'</service>'+
'<firstname>'+FirstName+'</firstname>'+
'<lastname>'+LastName+'</lastname>'+
'<impact>'+Impact+'</impact>'+
'<urgency>'+Urgency+'</urgency>'+
'</Request>'+
'</Input>'+
'</Body>'+
'</Envelope>';    
*/
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument('UTF-8', '1.0');
            w.writeStartElement(null, 'Envelope', null);
            w.writeNamespace('', 'http://schemas.xmlsoap.org/soap/envelope/');
            w.writeStartElement(null, 'Body', null);
            w.writeStartElement(null, 'Input', null);
            w.writeNamespace('', 'urn:SFDC2USMS');
            w.writeStartElement(null, 'Request', null);
            w.writedefaultNamespace('');
            
            w.writeStartElement(null, 'SourceSystemID', null);
            w.writeCharacters(SourceSystem);
            w.writeEndElement(); //end SourceSystemID
            
            w.writeStartElement(null, 'company', null);                                    
            w.writeCharacters(Company);
            w.writeEndElement(); //end company
            
            w.writeStartElement(null, 'notes', null);                                    
            w.writeCharacters(Notes);
            w.writeEndElement(); //end notes
            
            w.writeStartElement(null, 'serial', null);                                    
            w.writeCharacters(String.valueOf(USMS[0].CaseNumber));
            w.writeEndElement(); //end serial
            
            w.writeStartElement(null, 'summary', null);
            w.writeCharacters(Summary);
            w.writeEndElement(); //end summary
            
            
            
            w.writeStartElement(null, 'businessArea', null);
            w.writeCharacters(businessArea);
            w.writeEndElement();
            
            w.writeStartElement(null, 'majorIncident', null);
            w.writeCharacters(majorIncident);
            w.writeEndElement();
            
            w.writeStartElement(null, 'SLA', null);
            w.writeCharacters(sla);
            w.writeEndElement();
            
            w.writeStartElement(null, 'serviceImpact', null);
            w.writeCharacters(serviceImpacted);
            w.writeEndElement();
            
            w.writeStartElement(null, 'supportTime', null);
            w.writeCharacters(supportTime);
            w.writeEndElement();
            
            w.writeStartElement(null, 'impactedCustomers', null);
            w.writeCharacters(impactedCustomers);
            w.writeEndElement();
            
            
            
            w.writeStartElement(null, 'CategorizationTier1', null);                                    
            w.writeCharacters(CategorizationTier1);
            w.writeEndElement(); //end CategorizationTier1
            
            w.writeStartElement(null, 'CategorizationTier2', null);                                    
            w.writeCharacters(CategorizationTier2);
            w.writeEndElement(); //end CategorizationTier2
            
            w.writeStartElement(null, 'service', null);
            w.writeCharacters(Service);
            w.writeEndElement(); //end service
            
            w.writeStartElement(null, 'firstname', null);
            w.writeCharacters(FirstName);
            w.writeEndElement(); //end firstname
            
            w.writeStartElement(null, 'lastname', null);
            w.writeCharacters(LastName);
            w.writeEndElement(); //end lastname
            
            w.writeStartElement(null, 'impact', null);
            w.writeCharacters(Impact);
            w.writeEndElement(); //end impact
            
            w.writeStartElement(null, 'urgency', null);
            w.writeCharacters(Urgency);
            w.writeEndElement(); //end urgency
            
            w.writeEndElement(); //end Request
            w.writeEndElement(); //end Input    
            w.writeEndElement(); //end Body
            w.writeEndElement(); //end Envelope
            w.writeEndDocument();
            Createxml = w.getXmlString();
            w.close();              
            Database.update(usms[0]);
            USMSTicketRequest(Createxml, USMS[0].Id, Cs.Account.Name);
            
        }   
        catch(Exception e) {
            throw e;
            
        }
    }
    
    @future (callout=true)
    Public static void USMSTicketRequest(String Createxml, Id USMSCaseId, String accName){
        HttpRequest req;
        try{
            
            System.debug('----------------------- '+Createxml);
            B2B_Akana_Oath__c oauthToken=LG_Care_Oath_Authentication_akana.CreateToken();
            
            B2B_Care_Ext_Connections__c akana = B2B_Care_Ext_Connections__c.getInstance('Aakana OFF Connection');
            req = new HttpRequest();
            req.setTimeout(120000); 
            req.setendpoint(akana.Connection_URL__c); 
            req.setmethod('POST');
            req.setHeader('Content-Type','text/xml;charset=UTF-8');
            req.setHeader('Authorization', oauthToken.Access_Token__c );
            req.setbody(Createxml);
            Http http = new Http();
            res = http.send(req);
            
            System.debug('----------------------- '+res.getBody());
            
            Database.Update(oauthToken);
            
            Case USMSCase = new Case();
            USMSCase.Id = USMSCaseId;
            
            
            USMSCase.B2B_Account_Name__c = accName;
            //USMSCase.LG_B2B_USMS_Urgency__c = '4-Low';
            
            XmlStreamReader reader = res.getXmlStreamReader();
            boolean isSafeToGetNextXmlElement = true;
            while(isSafeToGetNextXmlElement) {
                
                if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'IncidentNumber') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Success__c = true;
                        USMSCase.USMS_Ticket_ID__c = reader.getText();
                    }
                }
                else if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'faultcode') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        USMSCase.B2B_Success__c = false;
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
            throw e;
        }
    }
    
    
}
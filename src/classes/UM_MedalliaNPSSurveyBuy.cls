global class UM_MedalliaNPSSurveyBuy {    
    
    Static final B2B_Care_Ext_Connections__c medalliaConn = B2B_Care_Ext_Connections__c.getInstance('Medallia External System Info');
    public static HTTPResponse res;
    // arguments for NPS. 
    static String  account_id; 
    static String  account_name; //Added for SFOM-2540
    static String  record_id; 
    static string  customer_id;
    static string  customer_name; //Added for SFOM-2540
    static string  customer_email; 
    static string  survey_type; 
    static string  brand; 
    static String  channel_id; 
    static string  product_family; 
    static string  product_description;
    static string  case_record_type; 
    static string  case_type; 
    static string  case_reason; 
    static string  service_name;    
    static string  sf_user_role; 
    static string  opportunityowner;
    static String salespartnerid_BW;
    static String salespartnerid_NRW_HS;
    
    public Static B2B_Care_Ext_Connections__c NPSConn;   
    
    //    public string  customerid;  this is not required in SFCTB-143
    //    public string  contact_role;   this is not required in SFCTB-143
    
        
    @InvocableMethod(label='NPS BuyTransaction')
    public static void Create_Medallia_NPS_JSON_Request(List<Id> OpportunityId) {
        
        if(!OpportunityId.isEmpty()){
             List<Id> userList = new List<Id>();
             Map<Id,User> userMap;
             Map<Id,Opportunity> opportunityMap = getAllOpportunityRecords(OpportunityId);
             Map<Id,List<csord__Service__c>> serviceListMap = getAllRelatedServices(OpportunityId);
             
            for(Opportunity oppRecord : opportunityMap.values()){
                userList.add(oppRecord.OwnerId);
            }
            if(! userList.isEmpty()){
                userMap = getUserNameList(userList);
            }
             for (Id opp:OpportunityId) {
                 if(opportunityMap.containsKey(opp)){
                     
                     try {
                         Opportunity opportunity = opportunityMap.get(opp);
                     	 List<csord__Service__c> services = new List<csord__Service__c>();
                         
                         
                         product_family = '';
                         product_description = '';
                         service_name = '';
                         
                         if(serviceListMap.containsKey(opp)){
                            services = serviceListMap.get(opp);
                        }
                         
                         Integer iCount = 0;
                         for(csord__Service__c service:Services){
                             String tempProdFamily;
                             String tempProdDescr;
                             
                             tempProdFamily = service.LG_ProductFamily__c != null ? service.LG_ProductFamily__c: '';
                             tempProdDescr = service.UM_ProductDescription__c != null ? service.UM_ProductDescription__c: '';
                             
                             if(iCount != 0){
                                 UM_MedalliaNPSSurveyBuy.addMultipleValues(service.Name, tempProdFamily, tempProdDescr, ',');
                             }else{
                                 UM_MedalliaNPSSurveyBuy.addMultipleValues(service.Name, tempProdFamily, tempProdDescr, '');
                             }
                             iCount++;
                         }
                           
                         account_id = opportunity.Account.LG_AccountNumber__c;
                         //SFOM-2540
                         account_name = opportunity.Account.Name;
                            //survey_type = 'Help';
                         channel_id = opportunity.LG_NEWSalesChannel__c != null ? opportunity.LG_NEWSalesChannel__c:'';
                         record_id = opportunity.Opportunity_ID__c != null ? opportunity.Opportunity_ID__c:'';
                         //SFOM-2540
                         customer_name = opportunity.LG_PrimaryContact__r.Name != null ? opportunity.LG_PrimaryContact__r.Name:'';
                         //SFOM-1634 - Null value handled
                         customer_email = opportunity.LG_PrimaryContact__r.Email != null ? opportunity.LG_PrimaryContact__r.Email:'';
                         customer_id = opportunity.Id != null ? opportunity.Id:'';
                         opportunityowner = opportunity.OwnerId;
                            
                         if (opportunity.Account.LG_VisitCountry__c != null){
                             NPSConn = B2B_Care_Ext_Connections__c.getInstance(opportunity.Account.LG_VisitCountry__c); 
                             brand = NPSConn.Brand__c; 
                         }
                            
                         if( opportunityowner.startswith('005')){
                             if(userMap.containsKey(opportunityowner)){
                                 User usr = userMap.get(opportunityowner); 
                             	 sf_user_role = usr.UserRole.Name != null? usr.UserRole.Name:'';
                             }else{
                                 sf_user_role = '';
                             }
                             
                         }
                         else {
                             sf_user_role = '';
                         }
                         
                         salespartnerid_BW = opportunity.SF_Sales_Partner_ID_BW__c != null ? opportunity.SF_Sales_Partner_ID_BW__c:'';
                                  
                         salespartnerid_NRW_HS = opportunity.SF_Sales_Partner_ID_NRW_HSN__c != null ? opportunity.SF_Sales_Partner_ID_NRW_HSN__c:'';
                         
                         case_record_type = ''; 
                         case_type = '';
                         case_reason = '';
                         
                         // create JSON request.
                         JSONGenerator gen = JSON.createGenerator(true);
                         gen.writeStartObject();
                         
                         gen.writeStringField('ACCOUNT_ID', account_id);
                         //SFOM-2540
                         gen.writeStringField('ACCOUNT_NAME', account_name);
                         gen.writeStringField('RECORD_ID', record_id);
                         gen.writeStringField('CUSTOMER_ID', customer_id);
                         //SFOM-2540
                         gen.writeStringField('CUSTOMER_NAME', customer_name);
                         gen.writeStringField('CUSTOMER_EMAIL', customer_email);
                         gen.writeStringField('SURVEY_TYPE', 'Buy');
                         gen.writeStringField('BRAND', brand);
                         gen.writeStringField('CHANNEL_ID', channel_id);
                         gen.writeStringField('PRODUCT_FAMILY', product_family);
                         gen.writeStringField('PRODUCT_DESCRIPTION', product_description);
                         gen.writeStringField('CASE_RECORD_TYPE', case_record_type);
                         gen.writeStringField('CASE_TYPE', case_type);
                         gen.writeStringField('CASE_REASON', case_reason);
                         gen.writeStringField('SERVICE_NAME', service_name);
                         gen.writeStringField('SF_USER_ROLE',sf_user_role);
                         gen.writeStringField('SF_Sales_Partner_ID_BW',salespartnerid_BW);
                         gen.writeStringField('Sales_Partner_ID_NRW_HSN',salespartnerid_NRW_HS);
                         
                         gen.writeEndObject();
                         //System.debug('Request:'+gen.getAsString());
                         UM_MedalliaNPSSurveyBuy.NPSRequest(gen.getAsString(),opportunity.Id);
                        
                     } 
                     catch(Exception e) {
                            System.debug('Exception:'+e.getMessage());
                     }
                     
                 }
             }
             
        }
    }
    
@Future(callout =true)   
public static void NPSRequest(string body, Id oppId){
  try{
           
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
	req.setEndpoint(medalliaConn.Connection_URL__c);//custom settings
       
    Double noOfTries = medalliaConn.UM_No_of_Tries__c;//custom settings
      
    req.setBody( body );
    
    Http http = new Http();
    req.setTimeout(120000); // timeout in milliseconds
    
     while(noOfTries != 0) {
        res = http.send(req);
        
		if(res.getStatusCode() != 200){
           noOfTries = noOfTries - 1;
        }
        else
        noOfTries = 0;
        }
        System.debug('Request:'+body);
      	System.debug('Response:'+res.getBody());
      //Handling Response Status Code
      Opportunity opportunityObj = new Opportunity(Id = oppId);
      if(res.getStatusCode() == 200){
          opportunityObj.UM_MedalliaNPSResponse__c = 'Success';
      }else if(res.getStatusCode() == 400){
          opportunityObj.UM_MedalliaNPSResponse__c = 'Failed - The input file contains unexpected data or is missing required data.';
      }else if(res.getStatusCode() == 403){
          opportunityObj.UM_MedalliaNPSResponse__c = 'Failed - The request used invalid/unauthorized credentials.';
      }else if(res.getStatusCode() == 500){
          opportunityObj.UM_MedalliaNPSResponse__c = 'Failed - An unexpected, internal error occurred.';
      }else{
          opportunityObj.UM_MedalliaNPSResponse__c = 'Failed - Error unknown.';
      }
      update opportunityObj;
    }
	catch(Exception e) {
     	system.debug('Exception:'+e.getLineNumber());
     	system.debug('Exception:'+e.getMessage());
    }
   }
    
    private static Map<Id,Opportunity> getAllOpportunityRecords(List<Id> oppIds){
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
        //SFOM-2540 - Added Account Name & Tech. Contact Name in the query
        List<Opportunity> opportunityList =[SELECT Id, Opportunity_ID__c, OwnerId, LG_PrimaryContact__c, LG_PrimaryContact__r.Name, LG_PrimaryContact__r.Email, AccountId, Account.Name, Account.LG_VisitCountry__c,
                                            Account.LG_AccountNumber__c, LG_NEWSalesChannel__c, SF_Sales_Partner_ID_BW__c,
                                            SF_Sales_Partner_ID_NRW_HSN__c, UM_MedalliaNPSResponse__c
                                            FROM Opportunity WHERE Id IN :oppIds];
        
        for(Opportunity opportunity:opportunityList){
            if(!opportunityMap.containsKey(opportunity.Id)){
                opportunityMap.put(opportunity.Id, opportunity);
            }
        }
        
        return opportunityMap;
    }
    
    private static Map<Id,List<csord__Service__c>> getAllRelatedServices(List<Id> oppIds){
        Map<Id,List<csord__Service__c>> serviceMap = new Map<Id,List<csord__Service__c>>();
        List<csord__Service__c> Services = [SELECT Id, Name, UM_ProductDescription__c, LG_ProductFamily__c, LG_RootOrder__r.csordtelcoa__Opportunity__c 
                                            FROM csord__Service__c WHERE LG_RootOrder__r.csordtelcoa__Opportunity__c IN :oppIds];
        for(csord__Service__c service:Services){
            if(serviceMap.containsKey(service.LG_RootOrder__r.csordtelcoa__Opportunity__c)){
                List<csord__Service__c> serviceList = serviceMap.get(service.LG_RootOrder__r.csordtelcoa__Opportunity__c);
                serviceList.add(service);
                serviceMap.put(service.LG_RootOrder__r.csordtelcoa__Opportunity__c, serviceList);
            }else{
                serviceMap.put(service.LG_RootOrder__r.csordtelcoa__Opportunity__c, new List<csord__Service__c>{service});
            }
        }
        return serviceMap;
    }
    
    private static Map<Id,User> getUserNameList(List<Id> ownerId){
        Map<Id,User> userMap = new Map<Id,User>();
        List<User> usr = [SELECT UserRole.Name FROM user WHERE Id IN : ownerId];
        for(User usrData: usr){
            if(!userMap.containsKey(usrData.Id)){
                userMap.put(usrData.Id, usrData);
            }
        }
        return userMap;
    }
    
    private static void addMultipleValues(String service, String prodFamily, String prodDescription, String delimiter){
        product_family = product_family + delimiter + prodFamily;
        product_description = product_description + delimiter + prodDescription;
        service_name = service_name + delimiter + service;
    }
    
}
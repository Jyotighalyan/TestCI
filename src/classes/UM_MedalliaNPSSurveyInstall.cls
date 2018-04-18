/**
 * 
 * @author Godson D S
 * @ticket SFOM-818
 * @since  04/08/2017
 */
global class UM_MedalliaNPSSurveyInstall implements CSPOFA.ExecutionHandler {
	public static B2B_Care_Ext_Connections__c medalliaConn = B2B_Care_Ext_Connections__c.getInstance('Medallia External System Info');
	public static HTTPResponse res;
    // arguments for NPS. 
    private String  account_id; 
    private String  account_name; //Added for SFOM-2540
    private String  record_id; 
    private string  customer_id;
    private string  customer_name; //Added for SFOM-2540
    private string  customer_email; 
    private string  survey_type; 
    private string  brand; 
    private String  channel_id; 
    private string  product_family; 
    private string  product_description;
    private string  case_record_type; 
    private string  case_type; 
    private string  case_reason; 
    private string  service_name;    
    private string  sf_user_role; 
    private string  suborderowner;
    private String salespartnerid_BW;
    private String salespartnerid_NRW_HS;
    
    public static B2B_Care_Ext_Connections__c NPSConn;

    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        requestMedalliaNPSSurveyInstall(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }
   
    @TestVisible
    public void requestMedalliaNPSSurveyInstall(Set<Id> processesIds)
    {       
        Map<Id, csord__Order__c> orderMap   = new Map<Id, csord__Order__c>();
        Map<Id,csord__Solution__c> subOrderMap = new Map<Id,csord__Solution__c>();
        List<Id> currentSolutions = new List<Id>();      
        Map<Id,List<csord__Service__c>> relatedServicesMap = new Map<Id,List<csord__Service__c>>();
        List<Id> userList = new List<Id>();
        Map<Id,User> userMap;
        
        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c                                                        
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            
            currentSolutions.add(process.LG_Solution__c);
        }
        system.debug('currentSolutions :'+currentSolutions);
        

        if (!currentSolutions.isEmpty()) {
			subOrderMap = getAllSolutionRecords(currentSolutions);
            relatedServicesMap = getAllRelatedServices(currentSolutions);
            
            for(csord__Solution__c subOrdRecord : subOrderMap.values()){
                userList.add(subOrdRecord.OwnerId);
            }
            if(! userList.isEmpty()){
                userMap = getUserNameList(userList);
            }
            
            for (Id sol :currentSolutions) {
                if(subOrderMap.containsKey(sol)){
                    try {
                        csord__Solution__c subOrder = subOrderMap.get(sol);
                        
                        List<csord__Service__c> services = new List<csord__Service__c>(); 
                        
                        
                        product_family = '';
                        product_description = '';
                        service_name = '';
                        
                        if(relatedServicesMap.containsKey(subOrder.Id)){
                            services = relatedServicesMap.get(subOrder.Id);
                        }
                        
                        Integer iCount = 0;
                        for(csord__Service__c service:Services){
                             String tempProdFamily;
                             String tempProdDescr;
                             
                             tempProdFamily = service.LG_ProductFamily__c != null ? service.LG_ProductFamily__c: '';
                             tempProdDescr = service.UM_ProductDescription__c != null ? service.UM_ProductDescription__c: '';
                             
                             if(iCount != 0){
                                 addMultipleValues(service.Name, tempProdFamily, tempProdDescr, ',');
                             }else{
                                 addMultipleValues(service.Name, tempProdFamily, tempProdDescr, '');
                             }
                             iCount++;
                        }
                        
                        if(subOrder.csord__Order__c !=null && 
                           subOrder.csord__Order__r.csord__Account__c != null &&
                           subOrder.csord__Order__r.csord__Account__r.LG_AccountNumber__c != null){
                               account_id = subOrder.csord__Order__r.csord__Account__r.LG_AccountNumber__c;
                           }else{
                               account_id = '';
                           }
                        
                         //SFOM-2540
                         if(subOrder.csord__Order__c !=null && 
                           subOrder.csord__Order__r.csord__Account__c != null &&
                           subOrder.csord__Order__r.csord__Account__r.Name != null){
                               account_name = subOrder.csord__Order__r.csord__Account__r.Name;
                           }else{
                               account_name = '';
                           }
                        
                        if(subOrder.csord__Order__c !=null && 
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__c != null &&
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__r.LG_NEWSalesChannel__c != null){
                               channel_id = subOrder.csord__Order__r.csordtelcoa__Opportunity__r.LG_NEWSalesChannel__c;
                           }else{
                               channel_id = '';
                           }  
                        record_id = subOrder.Id;
                        //SFOM-2540
                        customer_name = subOrder.LG_Address__r.LG_TechnicalContact__r.Name != null ? subOrder.LG_Address__r.LG_TechnicalContact__r.Name:'';
                        customer_id = subOrder.csord__Order__r.csordtelcoa__Opportunity__c != null ? subOrder.csord__Order__r.csordtelcoa__Opportunity__c:'';
                        customer_email = subOrder.LG_Address__r.LG_TechnicalContact__r.Email;
                        suborderowner = subOrder.OwnerId;
                     
                        
                        if (subOrder.csord__Order__r.csord__Account__r.LG_VisitCountry__c != null){
                            NPSConn = B2B_Care_Ext_Connections__c.getInstance(subOrder.csord__Order__r.csord__Account__r.LG_VisitCountry__c); 
                            brand = NPSConn.Brand__c; 
                            system.debug('@32'+brand);
                        }
                        
                        if( suborderowner.startswith('005')){
                             if(userMap.containsKey(suborderowner)){
                                 User usr = userMap.get(suborderowner); 
                             	 sf_user_role = usr.UserRole.Name != null? usr.UserRole.Name:'';
                             }else{
                                 sf_user_role = '';
                             }
                             
                         }
                         else {
                             sf_user_role = '';
                         }
                        system.debug('@32'+sf_user_role);
                        
                        if(subOrder.csord__Order__c !=null && 
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__c != null &&
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_BW__c != null){
                            salespartnerid_BW = subOrder.csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_BW__c;
                        }else{
                            salespartnerid_BW = '';
                        }
                        
                        if(subOrder.csord__Order__c !=null && 
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__c != null &&
                           subOrder.csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_NRW_HSN__c != null){
                            salespartnerid_NRW_HS = subOrder.csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_NRW_HSN__c;
                        }else{
                            salespartnerid_NRW_HS = '';
                        }
                        
                        case_record_type = ''; 
                        case_type = '';
                        case_reason = '';
                        
                        
                        // create JSON request.
                        JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();
                        //gen.writeFieldName('npsInvite');
                        //gen.writeStartObject();
                        
                        gen.writeStringField('ACCOUNT_ID', account_id);
                        //SFOM-2540
                        gen.writeStringField('ACCOUNT_NAME', account_name);
                        gen.writeStringField('RECORD_ID', record_id);
                        gen.writeStringField('CUSTOMER_ID', customer_id);
                        //SFOM-2540
                        gen.writeStringField('CUSTOMER_NAME', customer_name);
                        gen.writeStringField('CUSTOMER_EMAIL', customer_email);
                        gen.writeStringField('SURVEY_TYPE', 'Install');
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
                        System.debug('Request:'+gen.getAsString());
    
                        UM_MedalliaNPSSurveyInstall.NPSRequest(gen.getAsString(), subOrder.Id);
    
                    } 
                    catch(Exception e) {
                        System.debug('Exception:'+e.getMessage());
                    }
                }
				
            }
            
        }

    }
    
    @future(callout=true)
    private static void NPSRequest(string body, String subOrdId){
      try{
               
         //Case NPSCase= new Case();
         //NPSCase.Id = CaseId;       
               
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(medalliaConn.Connection_URL__c);//custom settings
        
        Double noOfTries = medalliaConn.UM_No_of_Tries__c;//custom settings
        System.debug(medalliaConn.UM_No_of_Tries__c);
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
          
          //System.debug('Response:'+res.getBody());
          //System.debug('Response:'+res.getStatusCode());
          csord__Solution__c suborderObj = new csord__Solution__c(Id = subOrdId);
      	
          if(res.getStatusCode() == 200){
              suborderObj.LG_Integration_Status__c = 'Install Survey Successful';
              suborderObj.LG_Integration_Description__c = 'Success';
          }else if(res.getStatusCode() == 400){
              suborderObj.LG_Integration_Status__c = 'Install Survey Failed';
              suborderObj.LG_Integration_Description__c = 'The input file contains unexpected data or is missing required data.';
          }else if(res.getStatusCode() == 403){
              suborderObj.LG_Integration_Status__c = 'Install Survey Failed';
              suborderObj.LG_Integration_Description__c = 'The request used invalid/unauthorized credentials.';
          }else if(res.getStatusCode() == 500){
              suborderObj.LG_Integration_Status__c = 'Install Survey Failed';
              suborderObj.LG_Integration_Description__c = 'An unexpected, internal error occurred.';
          }else{
              suborderObj.LG_Integration_Status__c = 'Install Survey Failed';
              suborderObj.LG_Integration_Description__c = 'Status:'+res.getStatusCode()+', Error unknown.';
          }
          
          update suborderObj;
        
        
         }
      catch(Exception e) {
         system.debug('Exception:'+e.getMessage());
         
       }
   }
    
    private static Map<Id,csord__Solution__c> getAllSolutionRecords(List<Id> solutionIds){
        Map<Id,csord__Solution__c> solutionMap = new Map<Id,csord__Solution__c>();
        //SFOM-2540 - Added Account Name & Tech. Contact Name in the query
        List<csord__Solution__c> subOrderList = [SELECT Id, OwnerId, LG_Address__c, LG_Address__r.LG_TechnicalContact__c, 
                                                             LG_Address__r.LG_TechnicalContact__r.Name,
															 LG_Address__r.LG_TechnicalContact__r.Email, csord__Order__c, 
															 csord__Order__r.csord__Account__c, 
															 csord__Order__r.csord__Account__r.Name,
															 csord__Order__r.csord__Account__r.LG_VisitCountry__c,
															 csord__Order__r.csord__Account__r.LG_AccountNumber__c, 
															 csord__Order__r.csordtelcoa__Opportunity__c, 
															 csord__Order__r.csordtelcoa__Opportunity__r.LG_NEWSalesChannel__c,
                                                             csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_BW__c,
                                                             csord__Order__r.csordtelcoa__Opportunity__r.SF_Sales_Partner_ID_NRW_HSN__c
															 FROM csord__Solution__c WHERE Id IN :solutionIds];
        for(csord__Solution__c subOrder:subOrderList){
            if(!solutionMap.containsKey(subOrder.Id)){
                solutionMap.put(subOrder.Id, subOrder);
            }
        }
        return solutionMap;
    }
    
    private Map<Id,List<csord__Service__c>> getAllRelatedServices(List<Id> solutionIds){
        Map<Id,List<csord__Service__c>> serviceMap = new Map<Id,List<csord__Service__c>>();
        List<csord__Service__c> Services = [SELECT Id, Name, UM_ProductDescription__c, LG_ProductFamily__c, LG_Suborder__c 
                                                FROM csord__Service__c WHERE LG_Suborder__c IN :solutionIds];
        for(csord__Service__c service:Services){
            if(serviceMap.containsKey(service.LG_Suborder__c)){
                List<csord__Service__c> serviceList = serviceMap.get(service.LG_Suborder__c);
                serviceList.add(service);
                serviceMap.put(service.LG_Suborder__c, serviceList);
            }else{
                serviceMap.put(service.LG_Suborder__c, new List<csord__Service__c>{service});
            }
        }
        
        return serviceMap;
    }
    
    private static Map<Id,User> getUserNameList(List<Id> ownerId){
        Map<Id,User> userMap = new Map<Id,User>();
        List<User> usr = [SELECT Id, UserRole.Name FROM user WHERE Id IN : ownerId];
        for(User usrData: usr){
            
            if(!userMap.containsKey(usrData.Id)){
                userMap.put(usrData.Id, usrData);
            }
        }
        return userMap;
    }
    
    private void addMultipleValues(String service, String prodFamily, String prodDescription, String delimiter){
        product_family = product_family + delimiter + prodFamily;
        product_description = product_description + delimiter + prodDescription;
        service_name = service_name + delimiter + service;
    }
    
}
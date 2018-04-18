/************************************************************************************************************************************
*        Class: LG_Care_MedalliaRelationshipSurvey_Batch  
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will request medallia to survey limited contacts as per the rules mentioned in the custom settings.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 08-AUG-2017
*   Test Class: LG_Care_MedalliaRelation_Batch_Test
*************************************************************************************************************************************/
global class LG_Care_MedalliaRelationshipSurvey_Batch  implements Database.Batchable<sobject>, Database.Stateful ,Database.AllowsCallouts {
    public Static String RqstFile;
    final static Map < id, Set < String >> accountToOrderMap = new Map < id, Set < String >> ();
    final static Map < id, Set < String >> accountToOrderMap2 = new Map < id, Set < String >> ();
    
    Static final LG_Care_Medallia_Settings__c myCS1 = LG_Care_Medallia_Settings__c.getInstance('Default');
    
    public static String editOrderSet(String new_product) {
       
        String temp_product='';
        
        if(new_product!=null)
        {
            if(new_product.Contains('Company Internet')){
                temp_product='Internet';
            }
            else if(new_product.Contains('Company Voice') || new_product.Contains('Virtual voice')){
                temp_product='Fixed Telephony';
            }
            else if (new_product.Contains('Company Fiber') || new_product.Contains('Wholesale Fiber')){
                temp_product='Data/VPN Services';
            }
            
            else if (new_product.Contains('Mobilfunkprodukte')){
                temp_product='Mobile';
            }
            
            else if (new_product.Contains('Digital TV')){
                temp_product='TV';
            }
            
            else if (new_product.Contains('Office')){
                temp_product='Internet';
            }
            
            else if (new_product.Contains('WLAN')){
                temp_product='Wifi';
            }
            else if (new_product.Contains('VPN')){
                temp_product='Data/VPN Services';
            }
              else if (new_product.Contains('BDS') || new_product.Contains('Connect')){
                temp_product='Data/VPN Services';
            }
           
           }
           
        
        return temp_product;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> contactRole = myCS1.LG_Care_Contact_Role__c.split(',');
        String roleQuery = '';
        Set<String> contactRoleSet = new Set<String>();
        contactRoleSet.addAll(contactRole);
        if(!contactRoleSet.isEmpty() && contactRoleSet.size() > 0) {
            roleQuery = roleQuery + 'LG_Role__c includes ( ';
            for(String temp :contactRoleSet) {
                roleQuery = roleQuery + '\''+ temp + '\'' + ',';   
            }
            if(roleQuery.lastIndexOf(',')!=-1){
                roleQuery = roleQuery.removeEnd(',');
            }
            roleQuery = roleQuery +' ) AND';
        }
         
        
        DateTime rNPSLimitDate = DateTime.Now() - myCS1.LG_Care_Last_rNPS_Send_Date__c;
        DateTime createdDate = DateTime.now() - myCS1.LG_Care_Contact_Created_Date__c;
        Integer maxLimit = Integer.valueOf(myCS1.LG_Care_Max_Number_of_Contacts__c);
        
        String rType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
    
        
        String query = 'SELECT ID, Name,AccountID,Email,Account.Name, LG_Role__c, Account.LG_AccountNumber__c, CreatedDate, LG_Care_Relationship_Survey_Sent_Date__c FROM Contact WHERE ( '
                        +roleQuery+' LG_Care_Survey_Opt_Out__c = false) AND ((LG_Care_Relationship_Survey_Sent_Date__c = NULL) OR (LG_Care_Relationship_Survey_Sent_Date__c != NULL AND LG_Care_Relationship_Survey_Sent_Date__c < :rNPSLimitDate)) AND (CreatedDate < :createdDate) AND AccountID!=NULL AND Account.RecordType.id!=:rType LIMIT 1999';
                       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> listOfCmps) {
        try {
         
            String record_id;
            String contact_role;
            String product_type;
            String new_product_type;
            B2B_Care_Ext_Connections__c NPSConn;
            product_type = '';
            contact_role = '';
            set < id > cntAll = new set < id > ();
            set < id > accIds = new set < id > ();
            List<Contact> filteredListOfContacts = new List<Contact>();
            Map<Id,Contact> contactMap = new Map<Id,Contact>();
            for (Contact cpm: listOfCmps) {
               
                if (cpm.accountid != null) {
                    accIds.add(cpm.accountid);
                    contactMap.put(cpm.accountid, cpm);
                }
                  
            }
           
            
            Map < id, Set < String >> accountToOrderMap = new Map < id, Set < String >> ();
            
            

            /*for(csord__Service__c actSubs :[Select id,Name,csord__Subscription__c,csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c
                                            from csord__Service__c where csord__Subscription__c in (Select id from csord__Subscription__c where csord__Account__c in :accIds and csord__Status__c='Active')]){*/
            for(csord__Service__c actSubs :[Select id,Name,csord__Subscription__c,csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c,csord__Subscription__r.csord__Account__c 
                                            from csord__Service__c where csord__Subscription__r.csord__Account__c in :accIds and LG_ServiceStatus__c ='Active' 
                                            and csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c != null]){
            
                Id Actid=actSubs.csord__Subscription__r.csord__Account__c ;
                //Set < String > orderToAccountList = new Set < String > ();
            
                new_product_type=editOrderSet(actSubs.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c);
                if(new_product_type != null && new_product_type != ''){
                if (accountToOrderMap.containskey(Actid)) {
                    Set < String > orderToAccountList = accountToOrderMap.get(Actid);
                    orderToAccountList.add(new_product_type);
                    accountToOrderMap.put(Actid, orderToAccountList);
                } else {
                    Set < String > orderToAccountList = new Set < String > ();
                    orderToAccountList.add(new_product_type);
                    
                    accountToOrderMap.put(Actid, orderToAccountList);
                    
                }
                
                }
            
                
            }
            
            List<Contact> contactListTemp = new List<Contact>();
            Integer maxLimit = Integer.valueOf(myCS1.LG_Care_Max_Number_of_Contacts__c);
            Integer count = 1;
            for(Id accountId : accountToOrderMap.keySet()){
                if((maxLimit < 100 && count > maxLimit) || (count > 99)){
                    break;
                }
                else{
                    contactListTemp.add(contactMap.get(accountId));
                }
                count++;
            }
            system.debug('final list: '+contactMap+' '+accountToOrderMap);
            contactMap.clear();
            List < String > JFile = new List < String > ();
            List < String > Stringfor = new List < String > ();
            Set < String > setOrder = new Set < String > ();
            
            Map<String,Id> requestBodyMapContactId = new Map<String,Id>();
            
            //for (Contact cont: listOfCmps) ////use SOQL for loop
            for (Contact cont: contactListTemp) ////use SOQL for loop
            {
                //system.debug(cont.email +' ----------------- '+ cont.accountId);
                product_type = '';
                Stringfor.clear();
                
                
                if (cont.Email != null && cont.AccountId !=null & cont.Account.LG_AccountNumber__c !=null) {
                    
                    Datetime dt = Datetime.now();
                    record_id = cont.id + dt.format('yyyyMMddHHmmss');
                    
                    
                    if (Cont.LG_Role__c != Null) {
                        contact_role = cont.LG_Role__c;
                    }
                    
                    if (accountToOrderMap.get(cont.AccountId) != null) {
                        
                        Stringfor.addAll(accountToOrderMap.get(cont.AccountId));
                        String separator = ', ';
                        
                        product_type = String.join(Stringfor, separator);
                        
                    }
                    
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    gen.writeStringField('ACCOUNT_ID', cont.Account.LG_AccountNumber__c);
                    gen.writeStringField('ACCOUNT_NAME', cont.Account.Name);
                    gen.writeStringField('RECORD_ID', record_id);
                    gen.writeStringField('CUSTOMER_ID', cont.id);
                    gen.writeStringField('CUSTOMER_NAME', cont.Name);
                    gen.writeStringField('CUSTOMER_EMAIL', cont.Email);
                    gen.writeStringField('SURVEY_TYPE', 'Relationship');
                    gen.writeStringField('BRAND', 'Unitymedia Business');
                    gen.writeStringField('CHANNEL_ID', '');
                    gen.writeStringField('Case_Origin', '');
                    gen.writeStringField('PRODUCT_FAMILY', '');
                    gen.writeStringField('PRODUCT_DESCRIPTION', '');
                    gen.writeStringField('CASE_RECORD_TYPE', '');
                    gen.writeStringField('CASE_TYPE', '');
                    gen.writeStringField('CASE_REASON', '');
                    gen.writeStringField('SERVICE_NAME', '');
                    gen.writeStringField('SF_USER_ROLE', '');
                    gen.writeStringField('CONTACT_ROLE', contact_role);
                    gen.writeStringField('PRODUCT_TYPE', product_type);
                    //system.debug(' ----------------- '+ product_type);
                    gen.writeEndObject();
                    RqstFile = gen.getAsString();
                    JFile.add(RqstFile);
                    requestBodyMapContactId.put(rqstFile, cont.Id);
                }
            }
            system.debug('@3File'+JFile);

         
          LG_Care_Medallia_Relationship_Survey.NPSRequest(JFile,requestBodyMapContactId); 
        } catch (Exception e) {}
        
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}
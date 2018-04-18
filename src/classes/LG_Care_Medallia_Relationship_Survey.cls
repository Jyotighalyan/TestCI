global class LG_Care_Medallia_Relationship_Survey {

 Static final B2B_Care_Ext_Connections__c medalliaConn = B2B_Care_Ext_Connections__c.getInstance('Medallia Relational System Info');
 public static HTTPResponse res;
 public Static String RqstFile;
/*
 Webservice static void Create_Medallia_NPS_JSON_Request(Campaign Cmp) {

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

   for (CampaignMember cpm: [SELECT id, contactId, contact.accountid FROM Campaignmember where campaignid = : Cmp.id]) {
    cntAll.add(cpm.contactId);
    if (cpm.contact.accountid != null) {
     accIds.add(cpm.contact.accountid);
    }
   }

   Map < id, Set < String >> accountToOrderMap = new Map < id, Set < String >> ();

   Set < String > orderToAccountList = new Set < String > ();
   for (csord__Order__c ord: [select id, csord__Product_Type__c, csord__Account__c from csord__Order__c where csord__Account__c in : accIds]) {

    if (accountToOrderMap.containskey(ord.csord__Account__c)) {

     orderToAccountList = accountToOrderMap.get(ord.csord__Account__c);
     new_product_type=editOrderSet(ord.csord__Product_Type__c);
     orderToAccountList.add(new_product_type);
  
     accountToOrderMap.put(ord.csord__Account__c, orderToAccountList);
    } else {
     new_product_type=editOrderSet(ord.csord__Product_Type__c);
     orderToAccountList.add(new_product_type);
     accountToOrderMap.put(ord.csord__Account__c, orderToAccountList);

    }
   }

   system.debug('Account to order map'+accountToOrderMap);
   List < String > JFile = new List < String > ();
   List < String > Stringfor = new List < String > ();
   Set < String > setOrder = new Set < String > ();
 
   for (Contact cont: [Select id, Email, LG_Role__c, AccountId,Account.LG_AccountNumber__c from Contact where id in : cntAll]) ////use SOQL for loop
   {
    product_type = '';
    Stringfor.clear();
   
    
    if (cont.Email != null && cont.AccountId !=null & cont.Account.LG_AccountNumber__c !=null) {

     Datetime dt = Datetime.now();
     record_id = cont.id + dt.format('yyyyMMddHHmmss');
   

     if (Cont.LG_Role__c != Null) {
      contact_role = cont.LG_Role__c;
     }
     system.debug('Map Before'+accountToOrderMap.get(cont.AccountId));
     if (accountToOrderMap.get(cont.AccountId) != null) {
      
      Stringfor.addAll(accountToOrderMap.get(cont.AccountId));
      String separator = ', ';
      
      product_type = String.join(Stringfor, separator);
     
     }
    
     JSONGenerator gen = JSON.createGenerator(true);
     gen.writeStartObject();
     gen.writeStringField('ACCOUNT_ID', cont.Account.LG_AccountNumber__c);
     gen.writeStringField('RECORD_ID', record_id);
     gen.writeStringField('CUSTOMER_ID', cont.id);
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
     gen.writeEndObject();
     RqstFile = gen.getAsString();
     JFile.add(RqstFile);
    
    }
   }
   
  
   NPSRequest(JFile,Cmp.id);
  } catch (Exception e) {}

 }

 public static String editOrderSet(String new_product) {

 String temp_product;
 if(new_product.Contains('Company Internet'))
 {
     temp_product='Internet';
 }
 else if(new_product.Contains('Company Voice') || new_product.Contains('Virtual voice'))
 {
     temp_product='Fixed Telephony';
 }
 else if (new_product.Contains('Company Fiber') || new_product.Contains('Wholesale Fiber'))
 {
     temp_product='Data/VPN Services';
 }
 
 else if (new_product.Contains('Mobilfunkprodukte'))
 {
     temp_product='Mobile';
 }
 
  else if (new_product.Contains('Digital TV'))
 {
     temp_product='TV';
 }
 
  else if (new_product.Contains('Office'))
 {
     temp_product='Internet';
 }
 
  else if (new_product.Contains('WLAN'))
 {
     temp_product='Wifi';
 }
   else if (new_product.Contains('VPN'))
 {
     temp_product='Data/VPN Services';
 }


  return temp_product;

 }*/

 Public static void NPSRequest(List < string > body, Map<String,Id> cid) {
  HttpRequest req;
  Boolean check_status= true;
  try {
    //Campaign Cmpg = New Campaign();
    //Cmpg.id = CId;
    List<Contact> contacts = new List<Contact>();
    for (String strFile: body) {
    Contact cont = new Contact();
    cont.Id = cid.get(strFile);
    req = new HttpRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
    req.setEndpoint(medalliaConn.Connection_URL__c); //custom settings
    Double noOfTries = medalliaConn.UM_No_of_Tries__c; 

    req.setBody(strFile);

    Http http = new Http();
    req.setTimeout(120000); // timeout in milliseconds

    while (noOfTries != 0) {

     res = http.send(req);
    
     if (res.getStatusCode() != 200) {
      noOfTries = noOfTries - 1;
     } else
      noOfTries = 0;
    }    
    system.debug(res);

    String result = res.getStatus();
    if (result =='OK') {
      cont.LG_Care_Relationship_Survey_Sent_Date__c = system.Now();
      contacts.add(cont);
      //check_status= False;
    }
   
  
   }
   Database.update(contacts);
   /*
   if(check_status)
   {
    Cmpg.B2B_Request_Sent_to_Medallia_On__c = System.Now();  
    Database.Update(Cmpg);
  } */
  }
  catch (Exception e) {
   LG_ServiceTechnicalFailure.createCalloutFailureResult(null, null, null, 'Medallia System', null, e.getStackTraceString(), req.getBody(), res.getBody());

  }

 }


}
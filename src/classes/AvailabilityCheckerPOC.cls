public class AvailabilityCheckerPOC {
    //Public void performtest(){
    Public string performtest(string objId,string objPostalCode){ // Deb-- 14 Mar
    system.debug('AvailabilityCheckerPOC '+objId+'--'+objPostalCode);
     //HttpResponseRemoting remoteResponse = new HttpResponseRemoting();

        // TO FIX Local query for DEV
        //if (LG_Util.getSandboxInstanceName().equals('dev'))
        //{
        //    remoteResponse.statusCode = 200;
        //    remoteResponse.respBody = LG_RfsCheckUtility.buildRfsResponse();
        //}
        //else
        //{

        UM_AddressResponse.TopasWSPort ws = new UM_AddressResponse.TopasWsPort();
        ws.timeout_x  = 2000;
        ws.endpoint_x = 'callout:UM_SpiderWS/TopasWS/TopasWSService';

        Map<String, String> searchParams = new Map<String, String>();
        String respBody = ''; // Deb-- 14 Mar

        //searchParams.put('buildingId', EncodingUtil.urlEncode('933038', 'UTF-8'));
        searchParams.put('buildingId', EncodingUtil.urlEncode(objPostalCode, 'UTF-8')); // Deb-- 14 Mar

        String systemId     = '';
        Integer maxRecords  = 100;
        Integer startRecord = 0;

        try {

            //if(isMove) {
            //    remoteResponse.respBody = siteId;
            //  } else {
            UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TopasWS');
            UM_AddressResponse addressResponse           = new UM_AddressResponse();
            addressResponse.addressExt = new List<UM_AddressResponse.addressExt>();

            UM_AddressResponse.addressesExt res = ws.addressSearchExt(systemId, maxRecords, startRecord, searchParams, loginCredentials.login__c, loginCredentials.password__c);
            addressResponse.addressExt = (List<UM_AddressResponse.addressExt>)res.address;
            //UM_AddressResponse.OptionalsJson rr = addressResponse.OptionalsJson(addressResponse.addressExt.get(0));
            //system.debug('--+ Json: '+rr);
            //String respBody = JSON.serialize(addressResponse.addressExt.get(0));
            respBody = JSON.serialize(addressResponse.addressExt.get(0)); // Deb-- 14 Mar
            system.debug('respBody:'+respBody);
            //}



        } catch (Exception e) {
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.UM_GenericError));
           return Label.UM_GenericError;
        }
    //}
    
    return respBody; // Deb-- 14 Mar
  }

}
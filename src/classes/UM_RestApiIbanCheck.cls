@RestResource(urlMapping = '/CSA/um_ibancheck')
global without sharing class UM_RestApiIbanCheck {

	@HttpGet
	global static String um_ibancheck() {
		RestRequest req = RestContext.request;

		// what we send when calling this class
		String ibanValue = req.params.get('ibanValue');
		String bic = '';

		if(String.isEmpty(ibanValue)) {
            return 'IBAN_EMPTY';
        }

		UM_IbanResponse.TolerantWSPort ws = new UM_IbanResponse.TolerantWSPort();
		ws.timeout_x = 2000;
		ws.endpoint_x = 'callout:UM_SpiderWS_IBAN_Validation/TolerantWS/TolerantWSService';

		UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TolerantWS');

		bic = null;

		try {
			UM_IbanResponse.checkResult res = ws.checkIban(ibanValue, loginCredentials.login__c, loginCredentials.password__c);
			system.debug('res.rclist' + res.rclist);

			if(res.rclist != null && res.rclist.WsbnkBankrectypeUser[0].bic != null) {
				bic = res.rclist.WsbnkBankrectypeUser[0].bic;
            }

			if (res.rclist != null && res.rclist.WsbnkBankrectypeUser[0].resultmsg == null) {
				return 'IBAN_OK' + (bic != null ? ',' + bic : ',0');
			}
		} catch (Exception e) {

                //System.debug(e.getMessage());
                return 'NO_CONNECTION';
        }

        return 'IBAN_NOTOK';
	}
}
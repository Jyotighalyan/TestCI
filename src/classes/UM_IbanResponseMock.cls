@isTest
global class UM_IbanResponseMock implements WebServiceMock {

    public static String resmth;

    global void doInvoke(    
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {

        UM_IbanResponse.checkIbanResponse response_x = new UM_IbanResponse.checkIbanResponse ();
        response_x.return_x = new UM_IbanResponse.checkResult();

        UM_IbanResponse.checkResult checkRes = new UM_IbanResponse.checkResult();
        checkRes.Status = 'OK';
            
        UM_IbanResponseWsdlTypes.WsbnkBankrectypeUser tstData = new UM_IbanResponseWsdlTypes.WsbnkBankrectypeUser();
        tstData.bic = '123456789';

        response_x.return_x.Status = 'OK';
        response_x.return_x.rclist = new UM_IbanResponseWsdlTypes.WsbnkBankrectypeUserArray();
        response_x.return_x.rclist.WsbnkBankrectypeUser = new List<UM_IbanResponseWsdlTypes.WsbnkBankrectypeUser>();
        response_x.return_x.rclist.WsbnkBankrectypeUser.add( tstData );

        response.put('response_x', response_x);
    }
}
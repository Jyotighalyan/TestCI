/*`
* Mock class for UM_PlaceOrder service responses
*
* @author Ankur
* @ticket SFOM-2296
* @since  14/12/2017
*/
@isTest
global class UM_PlaceOrderBackgroundMock implements WebServiceMock
{
    String errorBody = 'Cannot forward issue to Cama: ORA-20012: ORA-20002: 500 <?xml version="1.0" encoding="UTF-8"'+
        'standalone="yes"?><status><status-code>500</status-code><stack-trace>java.lang.NullPointerException'+
        'at de.catworkx.jira.plugins.sol.utils.SolRestDataUtil.createIssueFromJSON(SolRestDataUtil.java:56'+
        'ORA-06512: at "APP_SPIDER.SPDINTJIR", line 25 ORA-06512: at line 1';
    
    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                         String requestName,String responseNS,String responseName, String responseType) 
    {
        UM_minervawsUnitymediaCom.placeOrder orderReq = ( UM_minervawsUnitymediaCom.placeOrder)request;
        UM_metaWebserviceMinervaZentiveCom.placeOrderRequest req = orderReq.params;
        
        //successful callout
        if(req.buildingId.contains('123456'))
        {
            UM_minervawsUnitymediaCom.placeOrderResponse response_x = new UM_minervawsUnitymediaCom.placeOrderResponse();
            response_x.return_x = new UM_minervawsUnitymediaCom.asyncTransaction();
            response_x.return_x.transactionId = 1234567;
            response_x.return_x.success = true;
            response.put('response_x', response_x);
        }
        //callout failure
        else if(req.buildingId.contains('223456'))
        {
            UM_minervawsUnitymediaCom.placeOrderResponse response_x = new UM_minervawsUnitymediaCom.placeOrderResponse();
            response_x.return_x = new UM_minervawsUnitymediaCom.asyncTransaction();
            response_x.return_x.transactionId = null;
            response_x.return_x.success = false;
            response.put('response_x', response_x);
        }
        //callout exception
        else if(req.buildingId.contains('323456'))
        {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage(errorBody);
            throw e;
        }
    }
}
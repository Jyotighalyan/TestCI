/*
 * Test class for LG_ValidateMyBillDetails
 @ Author : Shruthi Gopal
 @ Date   : 23/10/2017
*/

@isTest
public class AsyncUM_minervawsUnitymediaComTest {
	
     public static testmethod void AsyncMinervaWSPortTest(){
         test.startTest();
         AsyncUM_minervawsUnitymediaCom.AsyncMinervaWSPort am = new AsyncUM_minervawsUnitymediaCom.AsyncMinervaWSPort();
        
         Continuation cont = new Continuation(60);
		 cont.continuationMethod = 'processResponse';
         AsyncUM_minervawsUnitymediaCom.createTroubleTicketResponseFuture cttrf = am.beginCreateTroubleTicket(cont,'IND',2147483648L,2146383648L,'New','Testprob','TestSrc','Test','TestAuth');
         AsyncUM_minervawsUnitymediaCom.retrieveTroubleTicketResponseFuture rttrf = am.beginRetrieveTroubleTicket(cont,'IND',2147483648L,2146383648L,'TestAuth');
         UM_metaWebserviceMinervaZentiveCom.placeOrderRequest por = new UM_metaWebserviceMinervaZentiveCom.placeOrderRequest();
         AsyncUM_minervawsUnitymediaCom.placeOrderResponseFuture porf = am.beginPlaceOrder(cont,por,'TestAuth');
         test.stopTest();
     }
}
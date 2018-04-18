/**
 * Used for the Product Basket new custom button 'Termination Details'
 * Button opens the LG_TerminationDetails VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-625
 * @since  24/04/2017
 */
global with sharing class CustomButtonTerminationDetails extends csbb.CustomButtonExt {

	public static final String errorMsg = '{"status":"error","title":"Error",'
										  + '"text":"' + Label.LG_NotTerminateBasket + '"}';

	public String performAction (String basketId) {

		String action = '';

		if ([SELECT csordtelcoa__Change_Type__c FROM cscfga__Product_Basket__c
			 WHERE Id = : basketId].csordtelcoa__Change_Type__c != 'Terminate') {
			action = errorMsg;
		} else {action =  '{"status":"ok","redirectURL":"' + LG_Util.getSalesforceBaseUrl()
						 + '/apex/LG_TerminationDetails?basketId=' + basketId + '"}';}

		return action;
	}
}
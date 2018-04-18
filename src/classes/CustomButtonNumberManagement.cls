/**
 * Used for the Product Basket new custom button 'Number Management'
 * Button opens the LG_NumberManagement VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-106
 * @since  7/3/2017
 */
global with sharing class CustomButtonNumberManagement extends csbb.CustomButtonExt {

	public static final String errorMsg = '{"status":"error","title":"Error",'
										  + '"text":"' + Label.LG_NoNumberRangeAssetsInBasket + '"}';

	public String performAction (String basketId) {

		String action = '';

		if ([SELECT Id FROM Asset
			 WHERE RecordType.Name = 'Number Block'
									 AND LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = : basketId].isEmpty()) {
			action = errorMsg;
		} else {
			String newUrl = LG_Util.getSalesforceBaseUrl()
							+ '/apex/LG_NumberManagement?id=' + basketId;

			action =  '{"status":"ok","redirectURL":"' + newUrl + '"}';
		}

		return action;
	}
}
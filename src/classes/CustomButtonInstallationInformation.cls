/**
* Used for the Product Basket new custom button 'Installation Information'
* Button opens the LG_InstallationInformation VF page.
* 
* @author Tomislav Blazek
* @ticket SFDT-221
* @since  11/02/2016
*/
global with sharing class CustomButtonInstallationInformation extends csbb.CustomButtonExt {
    
    public String performAction (String basketId) {
        
    	String newUrl = LG_Util.getSalesforceBaseUrl() 
                            + '/apex/LG_InstallationInformation?basketId=' + basketId;
							
		return '{"status":"ok","redirectURL":"' + newUrl + '"}';
    }
}
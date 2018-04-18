/**
* Used for the Product Basket new custom button 'Upload Porting Numbers'
* Button opens the LG_PortingNumbers VF page.
* 
* @author Tomislav Blazek
* @ticket SFDT-100
* @since  21/1/2016
*/
global with sharing class CustomButtonPortingNumbers extends csbb.CustomButtonExt {
    
    public String performAction (String basketId) {
        
    	String newUrl = LG_Util.getSalesforceBaseUrl() 
                            + '/apex/LG_PortingNumbers?basketId=' + basketId;
							
		return '{"status":"ok","redirectURL":"' + newUrl + '"}';
    }
}
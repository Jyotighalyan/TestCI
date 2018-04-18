/**
 * Base class for SMS Gateway
 * 
 * Extent this class in order to provide custom functionality for each country
 * 
 * @author Petar Miletic
 * @ticket SFOM-103
 * @since 22/12/2016
*/
public abstract class LG_SMSGateway {

    // Retrieve value from Custom Settings (hierarchy)  
    private static LG_SMSGatewayConfiguration__c req = LG_SMSGatewayConfiguration__c.getInstance(UserInfo.getUserId());
    
    public String smsEndpoint { get; private set; }

    /* 
     * Constructor
     *
    */
    public LG_SMSGateway() {
      
        this.smsEndpoint = req.LG_SMSEndpoint__c;
    }
    
	/*
	 * Based on the custom settings related to the loggedin user, returns a valid class instance
	*/
	public static LG_SMSGateway getInstance()
	{
		LG_SMSGateway instance = null;

		if (req != null && String.isNotBlank(req.LG_LocalizationClass__c)) {
		    
			Type classType = Type.forName(req.LG_LocalizationClass__c);
			System.debug('Show me: ' + req.LG_LocalizationClass__c);
			instance = (LG_SMSGateway)classType.newInstance();
		}
		
		return instance;
	}

    /*
     * Send Message
    */
    public abstract Boolean send(String messageBody);
}
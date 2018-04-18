/**
* Custom Settings for Endpoints Callouts
* 
* Class is used to resolve URL endpoints based on the user Country
* 
* @author Petar Miletic
* @ticket SFDT-1270
* @since  22/07/2016
*/
public abstract class LG_EndpointResolver {

    // Map of populated field, exposed trough isValuePopulated
    private Map<String, Object> populatedFieldsMap { get; set; }

    // Retrieve value from Custom Settings (hierarchy)  
    public static LG_ServiceRequestUrl__c req = LG_ServiceRequestUrl__c.getInstance(UserInfo.getUserId());
    
    public String addressCheckEndpoint { get; private set; }
    public String availabilityCheckEndpoint { get; private set; }

    /*
     * Constructor
     *
    */
    public LG_EndpointResolver() {
      
        this.addressCheckEndpoint = req.LG_AddressCheck__c;
        this.availabilityCheckEndpoint = req.LG_AvailabilityCheck__c;
    }
    
	/*
	 * Based on the custom settings related to the loggedin user, returns a valid class instance
	*/
	public static LG_EndpointResolver getInstance()
	{
		LG_EndpointResolver instance = null;

		if (req != null && String.isNotBlank(req.LG_LocalizationClass__c)) {
		    
			Type classType = Type.forName(req.LG_LocalizationClass__c);
			instance = (LG_EndpointResolver)classType.newInstance();
		}
		
		return instance;
	}
    
    /*
     * Address Validation
    */
    public abstract string getAddressCheckEndpoint(string houseFlatNumber, string houseFlatExt, string postcode);
    
    
    /*
     * Availability Check
    */
    public abstract string getAvailabilityCheckEndpoint(string addressId);
    
    /*
     * Address validation failing in JIT
     *
     * @author Petar Miletic
     * @ticket SFDT-1591
     * @since 17/10/2016
    */
    public virtual Boolean isValuePopulated(string fieldName, sObject obj) {
        
        if (this.populatedFieldsMap == null) {
            this.populatedFieldsMap = obj.getPopulatedFieldsAsMap();
        }
        
        return this.populatedFieldsMap.containsKey(fieldName);
    }
    
    /*
     * Generate append value (&param=value)
    */
    public string appendValue(string key, string value) {
        
        string val = '';
        
        if (String.isNotBlank(value)) {
            val = '&' + key + '=' + EncodingUtil.urlEncode(value.trim(), 'UTF-8');
        }
        
        return val;
    }
}
/**
* 
* Class for converting different address for common address format
* 
* @author Petar Miletic
* @ticket SFDT-15
* @since  23/02/2016
*/
public class LG_CommonAddressFormat {

    private Map<String, Object> response { get; set; }
    private Map<String, Object> envelope { get; set; }
    private Map<String, Object> body { get; set; }
    private Map<String, Object> getAddresses2Response { get; set; }
    
    private string street { get; set; }
    private string houseNumber { get; set; }
    private string houseNumberExt { get; set; }
    private string postcode { get; set; }
    private string city { get; set; }
    private string stateProvince { get; set; }
    private string latitude { get; set; }
    private string longitude { get; set; }
    
    private Boolean PEAL { get; set; }
    
    // Readonly property 
    private string displayValue 
    {
        get 
        {
            // If everything is blank or null return empty string
            if (String.isBlank(this.street) && String.isBlank(this.houseNumber)  && String.isBlank(this.houseNumberExt) && String.isBlank(this.postcode)  && String.isBlank(this.city)) {
                return '';                
            }
            else {
                return LG_util.checkNull(this.street) + ' ' + LG_util.checkNull(this.houseNumber) + ' ' + LG_util.checkNull(this.houseNumberExt) + ', ' + LG_util.checkNull(this.postcode) + ' ' + LG_util.checkNull(this.city);                
            }
        }
    }

     /*
        Constructor
    */
    public LG_CommonAddressFormat(Map<String, Object> inputMap) {
        
        this.PEAL = false;
        string s = (String)inputMap.get('addressResponseRaw');
        
        if (s.contains('Envelope') && s.contains('Body')) {
            this.response = (Map<String, Object>)JSON.deserializeUntyped(s);
            this.envelope = (Map<String, Object>)response.get('Envelope');
            this.body = (Map<String, Object>)envelope.get('Body');
            this.getAddresses2Response = (Map<String, Object>)body.get('getAddressesResponse');
            
            if (this.getAddresses2Response == null) {
                this.getAddresses2Response = (Map<String, Object>)body.get('getCustomAddressesResponse');
            }
            if (this.getAddresses2Response == null) {
                this.getAddresses2Response = (Map<String, Object>)body.get('getSameAddressResponse');
            }
            if (this.getAddresses2Response == null) {
                this.getAddresses2Response = (Map<String, Object>)body.get('addressSearchExtResponse');
            }
            system.debug('+++this.getAddresses2Response: ' + this.getAddresses2Response);
        }
        else {

            this.PEAL = true;
            this.response = (Map<String, Object>)JSON.deserializeUntyped(s);
            this.getAddresses2Response = this.response;            
        }
    }

    /*
        Convert JSON response from internal/external source to common address format for TCS Console
        Parametar order: street, house number, house number extension, postcode, city, ID field
    */
    public List<Object> ToCommonAddressFormat(string street, string houseNumber, string houseNumberExt, string postcode, string city, string stateProvince, string latitude, string longitude, string idField) {
        
        List<Object> results = new List<Object>();
		
        if (!this.PEAL) {
            string result = (String)getAddresses2Response.get('result');
            if (result == null) {
            	if(getAddresses2Response.get('return') instanceof String){
                	result = (String)getAddresses2Response.get('return');
                	results = (List<Object>)JSON.deserializeUntyped(result);
            	}
            	else if (getAddresses2Response.get('return') instanceof map<string,object>){
            		map<string,object> mapResult = (map<string,object>) getAddresses2Response.get('return');
            		results = mapResult.values(); 
            	}
	            else{
            		results = (List<Object>)getAddresses2Response.get('return');
	            }            	
            }
            else
            	results = (List<Object>)JSON.deserializeUntyped(result);
            system.debug('+++results is: ' + results);
            
        }
        else  {
        
            if (Test.isRunningTest()){
    
                string result = (String)getAddresses2Response.get('response');
                results = (List<Object>)JSON.deserializeUntyped(result);
            }
            else {
                
                results = (List<Object>)getAddresses2Response.get('response');                
            }
        }
        
        for (Object resultRow : results) {
            
            Map<String, Object> r = (Map<String, Object>)resultRow;

            this.street = getStringValue(r, street);
            this.houseNumber = getStringValue(r, houseNumber);
            this.houseNumberExt = getStringValue(r, houseNumberExt);
            this.postcode = getStringValue(r, postcode);
            this.city = getStringValue(r, city);
            this.stateProvince = getStringValue(r, stateProvince);
            this.latitude = getStringValue(r, latitude).replace(',', '.');
            this.longitude = getStringValue(r, longitude).replace(',', '.');
            
            r.put('id', getStringValue(r, idField));
            r.put('LG_Street', this.street);
            r.put('LG_HouseNumber', this.houseNumber);
            r.put('LG_HouseNumberExt', this.houseNumberExt);
            r.put('LG_City', this.city);
            r.put('LG_StateProvince', this.stateProvince);
            r.put('LG_Latitude', this.latitude);
            r.put('LG_Longitude', this.longitude);
            r.put('LG_Postcode', this.postcode);
            r.put('DisplayValue', this.displayValue);
            r.put('LG_AddressID', getStringValue(r, idField));
        }

        return results;
    }

    /*
        Helper method for processing property value
    */
    private string getStringValue(Map<String, Object> objList, string propertyName) {
        string retval;
        Object retObj = objList.get(propertyName);
        if (retObj instanceOf Decimal) {
        	Decimal retvalDecimal = (Decimal)retObj;
            retval = retvalDecimal.toPlainString();
        }
        else {
            retval = (String)retObj;
        }
        
        if (retval == null) {
            retval = '';
        }
        
        return retval;
    }
}
/**
* 
* Toest for CalloutResponse Class and class for converting different 
* address for common address format (LG_CommonAddressFormat)
* 
* @author Petar Miletic
* @ticket SFDT-15
* @since  24/02/2016
*/
@isTest
public class LG_CalloutResponseTest {

	@isTest
	public static void calloutResponseAddressCheckTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> retval = new Map<String, Object>();

        // Get JSON data as Map<String, Object>
        inputMap = getDataForAddressCheck('AddressCheck_GetAddresses');
	    
	    CalloutResponseAddressCheck o = new CalloutResponseAddressCheck();
	    
	    test.startTest();
	    
	    retval = o.processResponseRaw(inputMap);
	    
	    test.stopTest();
	    
        List<Object> obj = (List<Object>)JSON.deserializeUntyped((string)retval.values()[0]);
        Map<String, Object> objMap = (Map<String, Object>)obj[0];
	    
	    System.assertEquals('12346', objMap.get('id'), 'Invalid data');
	    System.assertEquals('Ruusbroeclaan', objMap.get('LG_Street'), 'Invalid data');
	    System.assertEquals('120', objMap.get('LG_HouseNumber'), 'Invalid data');
	    System.assertEquals('B', objMap.get('LG_HouseNumberExt'), 'Invalid data');
	    System.assertEquals('Eindhoven', objMap.get('LG_City'), 'Invalid data');
	    System.assertEquals('5611LV', objMap.get('LG_Postcode'), 'Invalid data');
	}
    @isTest
	public static void CalloutResponseTopasAddressCheckTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    
        inputMap = getDataForAddressCheck('AddressCheck_GetAddresses');
	    
	    CalloutResponseTopasAddressCheck o = new CalloutResponseTopasAddressCheck();
	    
	    test.startTest();
	    
	    o.processResponseRaw(inputMap);
	    o.getDynamicRequestParameters(inputMap);
	    test.stopTest();
	    
	}
    
    @isTest
	public static void CalloutResponsePEALAddressCheckTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> inputMap1 = new Map<String, Object>();
        Map<String, Object> inputMap2 = new Map<String, Object>();
        // Get JSON data as Map<String, Object>
        inputMap = getDataForPEALAddressCheck('AddressCheck_GetAddresses');
		inputMap1 = getDataForPEALAddressCheck400('AddressCheck_GetAddresses');
        inputMap2 = getDataForPEALAddressCheck200('AddressCheck_GetAddresses');
	    CalloutResponsePEALAddressCheck o = new CalloutResponsePEALAddressCheck();
	    
	    test.startTest();
	    
	    o.processResponseRaw(inputMap);
        o.processResponseRaw(inputMap1);
        o.processResponseRaw(inputMap2);
	    o.getDynamicRequestParameters(inputMap);
	    test.stopTest();
	    
        
	}
	@isTest
	public static void CalloutResponseCreateAddrFromAddrCheckTest() {
	   
	    Map<String, Object> inputMap = new Map<String, Object>();
       
   
      	
	    CalloutResponseCreateAddrFromAddrCheck o = new CalloutResponseCreateAddrFromAddrCheck();
	    test.startTest();
	    o.getDynamicRequestParameters(inputMap);
        o.processResponseRaw(inputMap);
	    test.stopTest();
	      
	}
	@isTest
	public static void calloutResponseCustomCalloutsTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> retval = new Map<String, Object>();

        // Get JSON data as Map<String, Object>
        inputMap = getDataForAddressCheck('CustomCallouts_GetCustomAddresses');
	                                       
	    CalloutResponseCustomCallouts o = new CalloutResponseCustomCallouts();
	    
	    test.startTest();
	    
	    retval = o.processResponseRaw(inputMap);
	    
	    test.stopTest();
	    
        List<Object> obj = (List<Object>)JSON.deserializeUntyped((string)retval.values()[0]);
        Map<String, Object> objMap = (Map<String, Object>)obj[0];

	    System.assertEquals('12346', objMap.get('id'), 'Invalid data');
	    System.assertEquals('Ruusbroeclaan', objMap.get('LG_Street'), 'Invalid data');
	    System.assertEquals('120', objMap.get('LG_HouseNumber'), 'Invalid data');
	    System.assertEquals('B', objMap.get('LG_HouseNumberExt'), 'Invalid data');
	    System.assertEquals('Eindhoven', objMap.get('LG_City'), 'Invalid data');
	    System.assertEquals('5611LV', objMap.get('LG_Postcode'), 'Invalid data');
	}
	
    @isTest
	public static void calloutResponseAddressCreationTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> retval = new Map<String, Object>();
        Map<String, csbb.CalloutResponse> mapCR = new Map<String, csbb.CalloutResponse>();
        Map<String, String> attMap = new Map<String, String>();
        Map<String, String> responseFields = new Map<String, String>();
        
      
        csbb.CalloutProduct.ProductResponse productResponse = new  csbb.CalloutProduct.ProductResponse();
		productResponse.displayMessage = 'Test Response';
        productResponse.available = 'true';
        
        
        // Get JSON data as Map<String, Object>
        inputMap = getDataForAddressCheck('AddressCheck_GetAddresses');

	    CalloutResponseAddressCreation o = new CalloutResponseAddressCreation();
	    CalloutResponseLocalAddressCreation lac = new CalloutResponseLocalAddressCreation();
	    test.startTest();
	    
	    o.processResponseRaw(inputMap);
        o.getDynamicRequestParameters(inputMap);
        o.canOffer(attMap,responseFields,productResponse);
        
        lac.processResponseRaw(inputMap);
        lac.getDynamicRequestParameters(inputMap);
        lac.canOffer(attMap,responseFields,productResponse);
	    test.stopTest();
	    
        
	}
    
    @isTest
	public static void CalloutResponsePEALRFSCheckTest() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> inputMap1 = new Map<String, Object>();
        Map<String, Object> inputMap2 = new Map<String, Object>();
        Map<String, Object> inputMap3 = new Map<String, Object>();
        Map<String, csbb.CalloutResponse> mapCR = new Map<String, csbb.CalloutResponse>();
        Map<String, String> attMap = new Map<String, String>();
        Map<String, String> responseFields = new Map<String, String>();
        
      
        csbb.CalloutProduct.ProductResponse productResponse = new  csbb.CalloutProduct.ProductResponse();
		productResponse.displayMessage = 'Test Response';
        productResponse.available = 'true';
       
        
        // Get JSON data as Map<String, Object>
        inputMap = getDataForPEALAddressCheck('AddressCheck_GetAddresses');
		inputMap1 = getDataForPEALAddressCheck400('AddressCheck_GetAddresses');
        inputMap3 = getDataForPEALAddressCheck404('AddressCheck_GetAddresses');
		
	    CalloutResponsePEALRFSCheck o = new CalloutResponsePEALRFSCheck();
	    
	    test.startTest();
	    
	    o.processResponseRaw(inputMap);
        o.processResponseRaw(inputMap1);
       
        o.processResponseRaw(inputMap3);
        o.getDynamicRequestParameters(inputMap);
        o.canOffer(attMap,responseFields,productResponse);       
	    test.stopTest();
	    
        
	}
    @isTest
	public static void CalloutResponseTBAvailabilityCheck1Test() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> retval = new Map<String, Object>();
        Map<String, csbb.CalloutResponse> mapCR = new Map<String, csbb.CalloutResponse>();
        Map<String, String> attMap = new Map<String, String>();
        
        Map<String, String> responseFields = new Map<String, String>();
        responseFields.put('topSpeed', '200');
        Map<String, String> responseField2 = new Map<String, String>();
        responseField2.put('topSpeed', '50');
        
        csbb.CalloutProduct.ProductResponse productResponse = new  csbb.CalloutProduct.ProductResponse();
		productResponse.displayMessage = 'Test Response';
        productResponse.available = 'true';
        
        

        
        // Get JSON data as Map<String, Object>
        inputMap = getDataForAddressCheck('AddressCheck_GetAddresses');

	    CalloutResponseTBAvailabilityCheck1 o = new CalloutResponseTBAvailabilityCheck1();
	    CalloutResponseAA_LoopbackTest aa = new CalloutResponseAA_LoopbackTest();
	    test.startTest();
	    
	    o.processResponseRaw(inputMap);
        o.getDynamicRequestParameters(inputMap);
        o.canOffer(attMap,responseFields,productResponse);
        
        
        aa.processResponseRaw(inputMap);
        aa.getDynamicRequestParameters(inputMap);
        aa.canOffer(attMap,responseFields,productResponse);
        aa.canOffer(attMap,responseField2,productResponse);

	    test.stopTest();
	    
        
	}
    
    
    @isTest
	public static void CalloutResponseBasicAvailabilityCheck1Test() {
	    
	    Map<String, Object> inputMap = new Map<String, Object>();
	    Map<String, Object> retval = new Map<String, Object>();
        Map<String, csbb.CalloutResponse> mapCR = new Map<String, csbb.CalloutResponse>();
        Map<String, String> attMap = new Map<String, String>();
        Map<String, String> attMap2 = new Map<String, String>();
        Map<String, String> responseField = new Map<String, String>();
        responseField.put('topSpeed','0');
        attMap.put('Ignore RFS Check','Yes');
      
        csbb.CalloutProduct.ProductResponse productResponse = new  csbb.CalloutProduct.ProductResponse();
		productResponse.displayMessage = 'Test Response';
        productResponse.available = 'true';
       
        
        // Get JSON data as Map<String, Object>
        inputMap = getDataForAddressCheck('AddressCheck_GetAddresses');

	    CalloutResponseBasicAvailabilityCheck1 o = new CalloutResponseBasicAvailabilityCheck1();
	    
	    test.startTest();
	    
	    retval = o.processResponseRaw(inputMap);
        o.getDynamicRequestParameters(inputMap);
        o.canOffer(attMap,responseField,productResponse);
        o.canOffer(attMap2,responseField,productResponse);
	  
	    test.stopTest();
	    
        
	}
	
	/*
        Inner class for generating JSON that mimics the one that is send into the services 
	    (original JSON is not available in pure form so this is the only way to do exact replica)
	*/
	private static Map<string, Object> getDataForAddressCheck(string calloutServiceMethodName)
	{
        wrapperHelper w = new wrapperHelper();
        AddressResponseRawHelper ar = new AddressResponseRawHelper();
        EnvelopeHelper e = new EnvelopeHelper();
        BodyHelper b = new BodyHelper();
        AddressesResponseHelper arh = new AddressesResponseHelper();
        ContextHelper ch = new ContextHelper();
        
        if (calloutServiceMethodName == 'AddressCheck_GetAddresses') {
            arh.result = '[{\"attributes\":{\"type\":\"cscrm__Address__c\",\"url\":\"/services/data/v36.0/sobjects/cscrm__Address__c/a388E0000008WGLQA2\"},\"Id\":\"a388E0000008WGLQA2\",\"LG_AddressID__c\":\"12346\",\"cscrm__Street__c\":\"Ruusbroeclaan\",\"LG_HouseNumber__c\":\"120\",\"LG_HouseNumberExtension__c\":\"B\",\"cscrm__Zip_Postal_Code__c\":\"5611LV\",\"cscrm__City__c\":\"Eindhoven\"}]';    
        }
        else if (calloutServiceMethodName == 'CustomCallouts_GetCustomAddresses') {
            arh.result = '[{\"attributes\":{\"type\":\"cscrm__Address__c\",\"url\":\"/services/data/v36.0/sobjects/cscrm__Address__c/a388E0000008WGLQA2\"},\"Id\":\"a388E0000008WGLQA2\",\"Site_Id__c\":\"12346\",\"Address_Line_1__c\":\"Ruusbroeclaan\",\"House_Number__c\":\"120\",\"House_Number_Extension__c\":\"B\",\"Postcode__c\":\"5611LV\",\"Town__c\":\"Eindhoven\"}]';    
        }
        else {
            arh.result = '';
        }
        
        b.getAddressesResponse = arh;
        e.Body = b;
        ar.Envelope = e;
        
        ch.calloutServiceMethodName = calloutServiceMethodName;
        ch.calloutServiceMethodType = 'address';
        
        w.addressResponseRaw = JSON.serialize(ar);
        w.context = ch;

        string response = JSON.serialize(w);
        
        if (calloutServiceMethodName == 'CustomCallouts_GetCustomAddresses') {
            response = response.replace('getAddressesResponse', 'getCustomAddressesResponse');
        }

        return (Map<String, Object>)JSON.deserializeUntyped(response);
	}
   
    private static Map<string, Object> getDataForPEALAddressCheck(string calloutServiceMethodName)
	{
        pealWraperHelper w = new pealWraperHelper();
        ContextHelper ch = new ContextHelper();
      	
        pealAddressesResponseHelper ar = new pealAddressesResponseHelper();
        ar.response = '[{\"postcode\":\"3572RE\",\"city\":\"UTRECHT\",\"streetNrFirst\":\"20\",\"streetNrFirstSuffix\":\"B\",\"streetName\":\"MARMERSTRAAT\",\"addressId\":\"18059941\"}]';

        ch.calloutServiceMethodName = calloutServiceMethodName;
        ch.calloutServiceMethodType = 'address';
       
        
        w.addressResponseRaw = JSON.serialize(ar);
        w.context = ch;
		w.httpStatusCode = '500';
        string response = JSON.serialize(w);

        return (Map<String, Object>)JSON.deserializeUntyped(response);
	}
    private static Map<string, Object> getDataForPEALAddressCheck400(string calloutServiceMethodName)
	{
        pealWraperHelper w = new pealWraperHelper();
        ContextHelper ch = new ContextHelper();
      	
        pealAddressesResponseHelper ar = new pealAddressesResponseHelper();
        ar.response = '[{\"postcode\":\"3572RE\",\"city\":\"UTRECHT\",\"streetNrFirst\":\"20\",\"streetNrFirstSuffix\":\"B\",\"streetName\":\"MARMERSTRAAT\",\"addressId\":\"18059941\"}]';

        ch.calloutServiceMethodName = calloutServiceMethodName;
        ch.calloutServiceMethodType = 'address';
       
        
        w.addressResponseRaw = JSON.serialize(ar);
        w.context = ch;
		w.httpStatusCode = '400';
        string response = JSON.serialize(w);

        return (Map<String, Object>)JSON.deserializeUntyped(response);
	}
    private static Map<string, Object> getDataForPEALAddressCheck200(string calloutServiceMethodName)
	{
        pealWraperHelper w = new pealWraperHelper();
        ContextHelper ch = new ContextHelper();
      	
        pealAddressesResponseHelper ar = new pealAddressesResponseHelper();
        ar.response = '[{\"postcode\":\"3572RE\",\"city\":\"UTRECHT\",\"streetNrFirst\":\"20\",\"streetNrFirstSuffix\":\"B\",\"streetName\":\"MARMERSTRAAT\",\"addressId\":\"18059941\"}]';

        ch.calloutServiceMethodName = calloutServiceMethodName;
        ch.calloutServiceMethodType = 'address';
       
        
        w.addressResponseRaw = JSON.serialize(ar);
        w.context = ch;
		w.httpStatusCode = '200';
        string response = JSON.serialize(w);

        return (Map<String, Object>)JSON.deserializeUntyped(response);
	}
    private static Map<string, Object> getDataForPEALAddressCheck404(string calloutServiceMethodName)
	{
        pealWraperHelper w = new pealWraperHelper();
        ContextHelper ch = new ContextHelper();
      	
        pealAddressesResponseHelper ar = new pealAddressesResponseHelper();
        ar.response = '[{\"postcode\":\"3572RE\",\"city\":\"UTRECHT\",\"streetNrFirst\":\"20\",\"streetNrFirstSuffix\":\"B\",\"streetName\":\"MARMERSTRAAT\",\"addressId\":\"18059941\"}]';

        ch.calloutServiceMethodName = calloutServiceMethodName;
        ch.calloutServiceMethodType = 'address';
       
        
        w.addressResponseRaw = JSON.serialize(ar);
        w.context = ch;
		w.httpStatusCode = '404';
        string response = JSON.serialize(w);

        return (Map<String, Object>)JSON.deserializeUntyped(response);
	}
	
	// PEAL
	private class pealWraperHelper
	{
	    public string addressResponseRaw { get; set; }
	    public ContextHelper context { get; set;}
        public string httpStatusCode { get; set;}
	}
	
    private class pealAddressesResponseHelper 
    {
        public string response { get; set; }
    }
    
	
	// non PEAL
    private class wrapperHelper
    {
        public string addressResponseRaw { get; set;}
        public ContextHelper context { get; set;}
        
    }
    
    private class ContextHelper
    {
        public string calloutServiceMethodName { get; set; }
        public string calloutServiceMethodType { get; set; }
        
    }

    
    private class AddressResponseRawHelper
    {
        public EnvelopeHelper Envelope { get; set; }
    }

    private class EnvelopeHelper
    {
        public BodyHelper Body { get; set; }
    }
    
    private class BodyHelper
    {
        public AddressesResponseHelper getAddressesResponse { get; set; }
    }

    private class AddressesResponseHelper 
    {
        public string result { get; set; }
    }
    

}
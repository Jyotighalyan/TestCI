/*
This controller executes asynchronous HTTP callouts via the Continuation API
in order to get information about the availability of different services for a given address.
If no information are available for the given address, another REST callout is done
in order to retrieve suggestions for house number extesion.
*/
public without sharing class LG_ServiceAvailabilityController {
    
    // Service availability information, contains service name and boolean flag
    public class ServiceAvailability {
			
		public final String serviceName { get; private set; }
			
		public final Boolean available { get; private set; }
			
		public ServiceAvailability(String serviceName, Boolean available) {
			this.serviceName = serviceName;
			this.available = available;
		}
	
	}
    
    // Encapsulates a suggestion for house number extension returned by REST service
    public class HouseNumberExtensionSuggestion {
        
        public final String suggestion { get; private set; }
        
        // ECMAScript escaped string to be used in JavaScript
        public String getEscapedSuggestion() {
            return suggestion.escapeEcmaScript();
        }
        
        public HouseNumberExtensionSuggestion(String suggestion) {
            this.suggestion = suggestion;
        }
        
    }
	
	// Postal code set by attribute
	public String postalCodeAttribute { get; set; }
	
	// House number set by attribute
	public String houseNumberAttribute { get; set; }
	
	// Extension code set by attribute
	public String extensionAttribute { get; set; }
	
	// Postal code set by input field
	public String postalCode {
		get {
			if (postalCode == null) {
				postalCode = ((postalCodeAttribute != null) ? postalCodeAttribute : '');
			}
			return postalCode;
		}
		set;
	}
	
	// House number set by input field
	public String houseNumber {
		get {
			if (houseNumber == null) {
				houseNumber = ((houseNumberAttribute != null) ? houseNumberAttribute : '');
			}
			return houseNumber;
		}
		set;
	}
	
	// Extension number set by input field
	public String extension {
		get {
			if (extension == null) {
				extension = ((extensionAttribute != null) ? extensionAttribute : '');
			}
			return extension;
		}
		set;
	}
    
    // Suggestions for house number extension returned by REST service
    public List<HouseNumberExtensionSuggestion> extensionSuggestions {
        get {
            if (extensionSuggestions == null) {
                extensionSuggestions = new List<HouseNumberExtensionSuggestion>();
            }
            return extensionSuggestions;
        }
        private set;
    }
    
    // Count of available suggestions for house number extension
    public Integer extensionSuggestionCount {
        get {
            return extensionSuggestions.size();
        }
    }
	
	public String errorMessage { get; private set; }
	
	public List<ServiceAvailability> serviceAvailabilityInformation {
		get {
			if (serviceAvailabilityInformation == null) {
				serviceAvailabilityInformation = new List<ServiceAvailability>();
			}
			return serviceAvailabilityInformation;
		}
		private set;
	}
	
    public LG_ServiceAvailabilityController() {
        // Do nothing...
    }
	
	// Invoke external web service and update availability information
    public Object updateServiceAvailability() {
        serviceAvailabilityInformation = null;
        extensionSuggestions = null;
		errorMessage = null;
		String normalizedPostalCode = postalCode.replaceAll('(\\s+)', '');
        String normalizedHouseNumber = houseNumber.trim();
		if ((normalizedPostalCode.length() > 0) && (normalizedHouseNumber.length() > 0)) {
			HttpRequest request = new HttpRequest();
			request.setMethod('GET');
			String endpoint = LG_ServiceRequestUrl__c.getInstance().LG_Url__c + 'zipcode/'
					+ EncodingUtil.urlEncode(normalizedPostalCode, 'UTF-8')
					+ '/housenumber/' + EncodingUtil.urlEncode(normalizedHouseNumber, 'UTF-8');
			String normalizedExtension = extension.trim();
			if (normalizedExtension.length() > 0) {
				endpoint += '/extension/' + EncodingUtil.urlEncode(normalizedExtension, 'UTF-8');
			}
			request.setEndpoint(endpoint);
			Continuation cont = new Continuation(30);
			cont.continuationMethod = 'processServiceAvailabilityResponse';
			requestLabel = cont.addHttpRequest(request);
			return cont;
		} else {
			errorMessage = Label.LG_FillOutRequired;
			return null;
		}
	}
	
	
	// Continuation request label
	@TestVisible
	private String requestLabel;
	
	// Callback method.
	// Client code should never call this method!!! It's public only because the Continuation API requires it to be public.
	public Object processServiceAvailabilityResponse() {
		HttpResponse response = Continuation.getResponse(requestLabel);
		String contentType = response.getHeader('Content-Type');
		Integer statusCode = response.getStatusCode();
        System.debug('Status Code: ' + statusCode);
		if ((statusCode == 200)
				&& ((contentType == 'application/json') || ((contentType != null) && contentType.startsWith('application/json;')))) {
			serviceAvailabilityInformation = parseServiceAvailabilityResponse(response.getBody());
		} else if (statusCode == 404) {
            errorMessage = Label.LG_NoServiceAvailabilityInformation;
            // If extension is set and no information found, make new callout to retrieve suggestions
            return updateExtensionSuggestions();
        } else if (statusCode == 2000) {
            errorMessage = Label.LG_CalloutTimedOut;
        } else {
			errorMessage = Label.LG_UnknownApexError;
		}
        requestLabel = null;
		return null;
	}
	
	// Parse JSON response containing service availability data
	@TestVisible
	private List<ServiceAvailability> parseServiceAvailabilityResponse(String responseBody) {
		List<ServiceAvailability> availabilityInformation = new List<ServiceAvailability>();
		Map<String, Object> deserializedData = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        Object availabilityDataObject = deserializedData.get('availability');
        // Populate availability information
		List<Object> availabilityData = (List<Object>) deserializedData.get('availability');
        for (Object availabilityObject : availabilityData) {
            Map<String, Object> availability = (Map<String, Object>) availabilityObject;
            String serviceName = (String) availability.get('name');
            // Map REST API names to user-friendly service names using custom setting
            LG_ServiceInformation__c serviceInformation = LG_ServiceInformation__c.getValues(serviceName);
            if (serviceInformation != null) {
                serviceName = serviceInformation.LG_ServiceName__c;
            }
            availabilityInformation.add(new ServiceAvailability(serviceName, (Boolean) availability.get('available')));
		}
		return availabilityInformation;
	}
    
    // Invoke external web service and retrieve suggestions for house number extension
    @TestVisible
    private Object updateExtensionSuggestions() {
        String normalizedPostalCode = postalCode.replaceAll('(\\s+)', '');
        String normalizedHouseNumber = houseNumber.trim();
        String normalizedExtension = extension.trim();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        String endpoint = LG_ServiceRequestUrl__c.getInstance().LG_Url__c + 'zipcode/'
				+ EncodingUtil.urlEncode(normalizedPostalCode, 'UTF-8')
				+ '/housenumber/' + EncodingUtil.urlEncode(normalizedHouseNumber, 'UTF-8')
            	+ '/extensions?q=' + EncodingUtil.urlEncode(normalizedHouseNumber, 'UTF-8');
       	request.setEndpoint(endpoint);
        Continuation cont = new Continuation(30);
        requestLabel = cont.addHttpRequest(request);
        cont.continuationMethod = 'processExtensionSuggestionsResponse';
        return cont;
    }
    
    // Callback method.
	// Client code should never call this method!!! It's public only because the Continuation API requires it to be public.
    public Object processExtensionSuggestionsResponse() {
        HttpResponse response = Continuation.getResponse(requestLabel);
		String contentType = response.getHeader('Content-Type');
		Integer statusCode = response.getStatusCode();
        System.debug('Status Code: ' + statusCode);
        if ((statusCode == 200)
				&& ((contentType == 'application/json') || ((contentType != null) && contentType.startsWith('application/json;')))) {
			extensionSuggestions = parseExtensionSuggestionsResponse(response.getBody());
           	System.debug(extensionSuggestions);
		} else if (statusCode == 404) {
            errorMessage = Label.LG_NoServiceAvailabilityInformation;
        } else if (statusCode == 2000) {
            errorMessage = Label.LG_CalloutTimedOut;
        } else {
			errorMessage = Label.LG_UnknownApexError;
		}
        requestLabel = null;
        return null;
    }
    
    // Parse JSON response containing suggestions for house number extension
    @TestVisible
    private List<HouseNumberExtensionSuggestion> parseExtensionSuggestionsResponse(String responseBody) {
		List<HouseNumberExtensionSuggestion> suggestions = new List<HouseNumberExtensionSuggestion>();
       	Map<String, Object> deserializedData = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> suggestionData = (List<Object>) deserializedData.get('suggestions');
        for (Object suggestionObject : suggestionData) {
            suggestions.add(new HouseNumberExtensionSuggestion((String) suggestionObject));
        }
        return suggestions;
    }

}
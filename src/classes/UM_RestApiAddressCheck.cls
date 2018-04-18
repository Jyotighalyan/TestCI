@RestResource(urlMapping = '/CSA/um_addresscheck')
global without sharing class UM_RestApiAddressCheck {

	@HttpGet
	global static List<Address> um_addresscheck() {
		RestRequest req = RestContext.request;
		String[] parts = req.requestURI.split('/');

		String zip            = req.params.get('zip');
		String streetNo       = req.params.get('streetNo');
		String streetNoSuffix = req.params.get('streetNoSuffix');
		String street         = req.params.get('street');
		// cities sometimes wrongly imported in Leads and the check can be done without them
		String city           = ''; //req.params.get('city');

		UM_AddressResponse.TopasWSPort ws = new UM_AddressResponse.TopasWsPort();
		ws.timeout_x  = 2000;
		ws.endpoint_x = 'callout:UM_SpiderWS/TopasWS/TopasWSService';

		Map<String, String> searchParams = new Map<String, String>();

		if (String.isNotBlank(zip)) {
			searchParams.put('zip', zip);
		}
		if (String.isNotBlank(streetNo)) {
			searchParams.put('streetNo', streetNo);
		}
		if (String.isNotBlank(streetNoSuffix)) {
			searchParams.put('streetNoSuffix', streetNoSuffix);
		}
		if (String.isNotBlank(street)) {
			searchParams.put('street', street);
		}
		if (String.isNotBlank(city)) {
			searchParams.put('city', city);
		}

		String systemId     = '';
		Integer maxRecords  = 100;
		Integer startRecord = 0;

		UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TopasWS');
		List<Address> addresses = new List<Address>();
		try {
			UM_AddressResponse.addressesExt res = ws.addressSearchExt(systemId, maxRecords, startRecord, searchParams, loginCredentials.login__c, loginCredentials.password__c);
			for (UM_AddressResponse.addressExt address : res.address) {
				addresses.add(new Address(address));
			}
		} catch (Exception e) {
		}
		return addresses;
	}

	global class Address
	{
		public String city {get; set;}
		public String zip {get; set;}
		public String streetNo {get; set;}
		public String streetNoSuffix {get; set;}
		public String street {get; set;}
		public Boolean internetAvailable {get; set;}
		public Boolean digitalAvailable {get; set;}
		public String address {get; set;}
		public String buildingId {get; set;}

		public Address (UM_AddressResponse.addressExt addressExt)
		{
			this.buildingId        = addressExt.buildingId;
			this.city              = addressExt.city;
			this.zip               = addressExt.zip;
			this.streetNo          = addressExt.streetNo;
			this.streetNoSuffix    = addressExt.streetNoSuffix;
			this.street            = addressExt.street;
			this.internetAvailable = addressExt.mktInternet == 'Y';
			this.digitalAvailable  = addressExt.mktDigital == 'Y';
			this.address           = LG_Util.getFormattedAddress(this.street, this.streetNo, this.streetNoSuffix, this.zip, this.city);
		}
	}
}
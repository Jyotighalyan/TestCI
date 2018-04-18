/**
* Used as a utility class for RFS check.
* Holds inner classes for deserialization and serialization of the RFS
* Check JSON response and RFS Common JSON format.
* Holds the methods that parse the response to the common format.
* 
* @author Tomislav Blazek
* @ticket SFDT-120
* @since  29/1/2016
*/
public class UM_RfsCheckUtility {
	
	//basic rfs response attribute names
	private static final String attInternet = 'UPC Internet'; //UPC Internet
	private static final String attMobileInternet = 'mobile_internet'; //No longer relevant
	private static final String attMobile = 'mobile'; //No longer relevatn - Always true
	private static final String attTelephony = 'telephony';
	private static final String attAnalogueTv = 'Catv'; //Catv
	private static final String attDigitalTv = 'DMM'; //DMM
	private static final String attQos = 'QoS'; //Always true
	private static final String attFp200 = 'UPC Fiber Power Internet'; //UPC Fiber Power Internet
	private static final String attFp500 = 'UPC_superfast'; //UPC_superfast
	
	//rfs common capabilities strings
	private static final String capData = 'Data';
	private static final String capVoice = 'Voice';
	private static final String capTv = 'TV';
	
	//rfs common technologies strings
	private static final String techHfc = 'HFC';
	private static final String techMobile = 'Mobile';
	private static final String techDigital = 'Digital';
	private static final String techAnalogue = 'Analogue';
	private static final string techCoax = 'Coax';
	
	//rfs common limits strings
	private static final String limDownBasic = '130';
	private static final String limDownFp200 = '300';
	private static final String limDownFp500 = '500';
	private static final String limUpBasic = '30';
	private static final String limUpFp200 = '40';
	private static final String limUpFp500 = '40';
	
	//rfs common QoS strings
	private static final String qosVoice = 'Voice';
	private static final String qosStnd = 'Standard';
	
	/**
	 * Method parses the RFS Check JSON response, and serializes the parsed data into
	 * a common JSON format
	 * 
	 * @param  String rfsCheckResponse - json response returned from the RFS Check
	 * @return String - parsed json response in the common JSON format
	 * @author Tomislav Blazek
	 * @ticket
	 * @since  29/1/2016
	 */
	public static String getCommonRfsJsonFormat(String rfsCheckResponse)
	{
		System.Debug('++rfsCheckResponse++: '+rfsCheckResponse);
		RfsResponse rfsResponse = (RFSResponse) JSON.deserialize(rfsCheckResponse, UM_RfsCheckUtility.RfsResponse.class);
		System.Debug('++rfsResponse++'+rfsResponse);
		return JSON.serialize(parseRfsResponse(rfsResponse));
	}
	
	/**
	 * Method extracts the limit values from a common RFS Check object, dependent
	 * on the product family type. i.e. returns max down speed, max up speed and qos
	 * for the Internet product family. 
	 * 
	 * @param  String rfsCommonResponse - RFS Check response in a common format
	 * @param  String productFamily - a product family type i.e. Internet
	 * @return Map<String, String> - map of limit value
	 * @author Tomislav Blazek
	 * @ticket SFDT-240
	 * @since  25/02/2016
	 */
	public static Map<String, String> getProductFamilyLimits(String rfsCommonResponse, String productFamily)
	{
		RfsCommon rfsCommon = (RfsCommon) JSON.deserialize(rfsCommonResponse, UM_RfsCheckUtility.RfsCommon.class);
		
		Map<String, String> limitToValuesMap = new Map<String, String>();
		
		if (productFamily.equals('Internet'))
		{
			String upSpeed = null;
			String downSpeed = null;
			String qos = null;
			
			for (common_Availability avail : rfsCommon.availability)
			{
				if (avail.capability.equals('Data') && avail.technology.equals('HFC'))
				{
					for (Limits lim : avail.limits)
					{
						if (upSpeed == null)
						{
							upSpeed = lim.up;
						}
						else
						{
							if (String.isNotBlank(upSpeed) && String.isNotBlank(lim.up))
							{
								if (Integer.valueOf(lim.up) > Integer.valueOf(upSpeed))
								{
									upSpeed = lim.up;
								}
							}
						}
						
						if (downSpeed == null)
						{
							downSpeed = lim.down;
						}
						else
						{
							if (String.isNotBlank(downSpeed) && String.isNotBlank(lim.down))
							{
								if (Integer.valueOf(lim.down) > Integer.valueOf(downSpeed))
								{
									downSpeed = lim.down;
								}
							}
						}
						
						if (qos == null)
						{
							qos = lim.qos;
						}
						else
						{
							if (String.isNotBlank(lim.qos) && lim.qos.equals('Voice'))
							{
								qos = 'Voice';
							}
						}
					}
					
					if (upSpeed != null)
					{
						limitToValuesMap.put('up', upSpeed);
					}
					if (qos != null)
					{
						limitToValuesMap.put('qos', qos);
					}
					if (downSpeed != null)
					{
						limitToValuesMap.put('down', downSpeed);
					}
				}
			}
		}
		
		return limitToValuesMap;
	}
	
	private static RfsCommon parseRfsResponse(RfsResponse rfsResponse)
	{
		RfsCommon rfsCommon = new RfsCommon();
		
		
		
		//address data
		rfsCommon.street = rfsResponse.street;
		rfsCommon.houseNumber = rfsResponse.streetNo;
		rfsCommon.houseNumberExt = rfsResponse.streetNoSuffix;
		rfsCommon.zipCode = rfsResponse.zip;
		rfsCommon.city = rfsResponse.city;
        rfsCommon.stateOrProvince = rfsResponse.region;
        rfsCommon.latitude = rfsResponse.geoCoordinateNorth;
        rfsCommon.longitude = rfsResponse.geoCoordinateEast;
        rfsCommon.addressId = rfsResponse.buildingId;
		//rfsCommon.footprint = rfsResponse.footprint;
		
		//availability data
		rfsCommon.availability = new List<common_Availability>();
		
		/*
		//mobile always true - start
		common_Availability commAvailMobile = new common_Availability();
		commAvailMobile.limits = new List<Limits>();
		//supportingData - TODO when defined
		commAvailMobile.supportingData = new List<SupportingData>();
					
		//mobile is available, set the parsed data
		commAvailMobile.capability = capVoice;
		commAvailMobile.technology = techMobile;
		rfsCommon.availability.add(commAvailMobile);
			
		//mobile always true - end
		*/
			
		if(rfsResponse.mktPhone=='Y'){
			common_Availability commAvail = new common_Availability();
			commAvail.capability = capVoice;
			commAvail.technology = techDigital;
			rfsCommon.availability.add(commAvail);
		}
		
		if(rfsResponse.mktMobile=='Y'){
			common_Availability commAvail = new common_Availability();
			commAvail.capability = capData;
			commAvail.technology = techMobile;
			rfsCommon.availability.add(commAvail);
		}
		
		if(rfsResponse.mktInternet=='Y'){
			common_Availability commAvail = new common_Availability();
			commAvail.limits = new List<Limits>();
			commAvail.capability = capData;
			commAvail.technology = techCoax;
			rfsCommon.availability.add(commAvail);
			
			Limits limits = new Limits();
			limits.down = limDownBasic;
			limits.up = limUpBasic;
			limits.qos = qosVoice;
			commAvail.limits.add(limits);
		}
		
		if(rfsResponse.mktDigital=='Y'){
			common_Availability commAvail = new common_Availability();
			commAvail.capability = capVoice;
			commAvail.technology = techDigital;
			rfsCommon.availability.add(commAvail);
		}
		
		if(rfsResponse.mktAnalog=='Y'){
			common_Availability commAvail = new common_Availability();
			commAvail.capability = capVoice;
			commAvail.technology = techDigital;
			rfsCommon.availability.add(commAvail);
		}
		
		
		/*for (GeographicAreas geoArea : rfsResponse.geographicAreas)
		{
			//we only want to use AVAILABILITY_AREA GeographicAreas type
			if (geoArea.type != 'AVAILABILITY_AREA')
			{
				continue;
			}
			
			for (AvailabilityGroups availGroup : geoArea.availabilityGroups)
			{
				for (ProdSpecGroups prodSpecGroup : availGroup.prodSpecGroups)
				{
					//Internet - Data parsing
					if (attInternet.equalsIgnoreCase(prodSpecGroup.name))
					{
						common_Availability commAvail = new common_Availability();
						commAvail.limits = new List<Limits>();
						//supportingData - TODO when defined
						commAvail.supportingData = new List<SupportingData>();
						
						rfsCommon.availability.add(commAvail);
						
						//Internet is available, set the minimum set of data
						commAvail.capability = capData;
						commAvail.technology = techHfc;
						
						Limits limits = new Limits();
						limits.down = limDownBasic;
						limits.up = limUpBasic;
						limits.qos = qosVoice;
						commAvail.limits.add(limits);
						
						//Iterate through other availabilities data to possibly
						//construct greater limits
						Boolean fp200 = false;
						Boolean fp500 = false;
						for (AvailabilityGroups aGroup : geoArea.availabilityGroups)
						{
							for (ProdSpecGroups specGroup : aGroup.prodSpecGroups)
							{
								if (attFp200.equalsIgnoreCase(specGroup.name))
								{
									fp200 = true;
								}
								else if (attFp500.equalsIgnoreCase(specGroup.name))
								{
									fp500 = true;
								}
							}	
						}
						
						//if fp200 available overwrite the limits with data for fp200
						if (fp200)
						{
							limits.down = limDownFp200;
							limits.up = limUpFp200;
						}
						//if fp500 available overwrite the limits with data for fp500
						if (fp500)
						{
							limits.down = limDownFp500;
							limits.up = limUpFp500;
						}
					}
					//Mobile Internet parsing -- no longer relevant - legacy product
					// else if (attMobileInternet.equalsIgnoreCase(availability.name)
					// 			&& availability.available)
					// {
					// 	common_Availability commAvail = new common_Availability();
					// 	commAvail.limits = new List<Limits>();
					// 	//supportingData - TODO when defined
					// 	commAvail.supportingData = new List<SupportingData>();
					// 	
					// 	rfsCommon.availability.add(commAvail);
					// 	
					// 	//mobile_internet is available, set the parsed data
					// 	commAvail.capability = capData;
					// 	commAvail.technology = techMobile;
					// }
					
					//mobile (voice) parsing - no longer relevant - always true
					// else if (attMobile.equalsIgnoreCase(availability.name)
					// 			&& availability.available)
					// {
					// 	common_Availability commAvail = new common_Availability();
					// 	commAvail.limits = new List<Limits>();
					// 	//supportingData - TODO when defined
					// 	commAvail.supportingData = new List<SupportingData>();
					// 	
					// 	rfsCommon.availability.add(commAvail);
					// 	
					// 	//mobile is available, set the parsed data
					// 	commAvail.capability = capVoice;
					// 	commAvail.technology = techMobile;
					// }

					//telephony (voice) parsing
					else if (attTelephony.equalsIgnoreCase(prodSpecGroup.name))
					{
						common_Availability commAvail = new common_Availability();
						commAvail.limits = new List<Limits>();
						//supportingData - TODO when defined
						commAvail.supportingData = new List<SupportingData>();
						
						rfsCommon.availability.add(commAvail);
						
						//telephony is available, set the parsed data
						commAvail.capability = capVoice;
						commAvail.technology = techDigital;
					}
					//digital TV parsing
					else if (attDigitalTv.equalsIgnoreCase(prodSpecGroup.name))
					{
						common_Availability commAvail = new common_Availability();
						commAvail.limits = new List<Limits>();
						//supportingData - TODO when defined
						commAvail.supportingData = new List<SupportingData>();
						
						rfsCommon.availability.add(commAvail);
						
						//digital TV is available, set the parsed data
						commAvail.capability = capTv;
						commAvail.technology = techDigital;
						
						Limits limits = new Limits();
						limits.qos = qosVoice;
						commAvail.limits.add(limits);
					}
					//analogue TV parsing
					else if (attAnalogueTv.equalsIgnoreCase(prodSpecGroup.name))
					{
						common_Availability commAvail = new common_Availability();
						commAvail.limits = new List<Limits>();
						//supportingData - TODO when defined
						commAvail.supportingData = new List<SupportingData>();
						
						rfsCommon.availability.add(commAvail);
						
						//analogue TV is available, set the parsed data
						commAvail.capability = capTv;
						commAvail.technology = techAnalogue;
						
						Limits limits = new Limits();
						limits.qos = qosVoice;
						commAvail.limits.add(limits);
					}
				}
			}
		}*/
		return rfsCommon;
	}		
	
	//Inner class used for deserializing JSON response of the RFS Check
	public class RfsResponse {
		public String zip;
		public String uepId;
		public String streetNoSuffix;
		public String streetNo;
		public String street;
		public String streetNrFirst;
		public String mktPhone;
		public String mktMobile;
		public String mktInternet;
		public String mktDigital;
		public String mktAnalog;
		public String geoCoordinateNorth;
		public String geoCoordinateEast;		
		public String city;
        public String region;
		public String buildingId;				
	}
		
	//Inner class used in rfsResponse class
	public class GeographicAreas {
		public String type;
		public String code;
		public AvailabilityGroups[] availabilityGroups;
		public String areaType;
		public String activationCode;
		public String setupId;
		public String region;
		public String availabilityDescription;
		public String isPartnerNetwork;
		public String networkId;
		public String hubId;
		public String nodeId;
	}
	
	//Inner class used in rfsResponse class
	public class AvailabilityGroups {
		public ProdSpecGroups[] prodSpecGroups;
		public ProductSpecifications[] productSpecifications;
		public AvailabilityInfo availabilityInfo;
	}
	
	//Inner class used in rfsResponse class
	public class ProdSpecGroups {
		public String objectID;
		public String name;
		public String description;
		public String extName;
		public Boolean isRootProductSpecGroup;
	}
	
	//Inner class used in rfsResponse class
	public class ProductSpecifications {
	}
	
	//Inner class used in rfsResponse class
	public class AvailabilityInfo {
		public String buildingStatus;
		public String availableDate;
		public String partnerNetFlag;
	}
	
	//Inner class used in rfsResponse class
	public class Properties {
	}
	
	//Inner class used for serializing RFS Check Common JSON format
	public class RfsCommon{
		public String street;
		public String houseNumber;
		public String houseNumberExt;
		public String zipCode;
		public String city;
		public String stateOrProvince;
		public String country;
		public String addressId;
		public String footprint;
		public String longitude;
		public String latitude;
		public common_Availability[] availability;
	}
	
	//Inner class used in RfsCommon class
	public class common_Availability {
		public String capability;
		public String technology;
		public Limits[] limits;
		public SupportingData[] supportingData;
	}
	
	//Inner class used in common_Availability class
	public class Limits {
		public String down = '';
		public String up = '';
		public String qos = '';
	}
	
	//Inner class used in common_Availability class.
	public class SupportingData {
		public String provider;
		public String pop;
		public String productName;
		public String id;
	}
	
	//Used for testing and dev environment
	public static String buildRfsResponse()
	{
		return buildRfsResponse(true, true, true, true, true, true);
	}
	
	public static String buildRfsResponse(Boolean internet, Boolean fp200, Boolean fp500, Boolean dtv, Boolean catv, Boolean telephony)
	{
		String internetStr = internet ? UM_RfsCheckUtility.attInternet : 'test';
		String fp200Str = fp200 ? UM_RfsCheckUtility.attFp200 : 'test';
		String fp500Str = fp500 ? UM_RfsCheckUtility.attFp500 : 'test';
		String dtvStr = dtv ? UM_RfsCheckUtility.attDigitalTv : 'test';
		String catvStr = catv ? UM_RfsCheckUtility.attAnalogueTv : 'test';
		String telephonyStr = telephony ? UM_RfsCheckUtility.attTelephony : 'test';
		
		return '{"footprint":"ZIGGO","type":"POSTAL","addressId":"11532544","streetName":"LEISTRAAT","streetNrFirstSuffix":"1",'
			+ '"streetNrFirst":"22","streetNrLastSuffix":null,"streetNrLast":null,"houseNumber":null,"houseName":null,"city":"UTRECHT"'
			+ ',"postcode":"3572RE","stateOrProvince":null,"countryName":"Netherlands","poBoxNr":null,"poBoxType":null,"attention":null,'
			+ '"geographicAreas":[{"type":"AVAILABILITY_AREA","code":null,"availabilityGroups":[{"prodSpecGroups":[{"objectID":null,'
			+ '"name":"' + internetStr + '","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"' + fp200Str + '","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"' + fp500Str + '","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"1900-01-01+01:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"Priority","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"' + dtvStr + '","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"Additional Line","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},'
			+ '{"prodSpecGroups":[{"objectID":null,"name":"' + catvStr + '","description":"","extName":"","isRootProductSpecGroup":null}],"productSpecifications":[]'
			+ ',"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}},{"prodSpecGroups":[{"objectID":null,'
			+ '"name":"' + telephonyStr + '","description":"","extName":"","isRootProductSpecGroup":null}],"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT"'
			+ ',"availableDate":"1900-01-01+01:00","partnerNetFlag":null}},{"prodSpecGroups":[{"objectID":null,"name":"VoIP SIP","description":"","extName":"",'
			+ '"isRootProductSpecGroup":null}],"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00",'
			+ '"partnerNetFlag":null}},{"prodSpecGroups":[{"objectID":null,"name":"UPC Fiber Power Placeholder","description":"","extName":"",'
			+ '"isRootProductSpecGroup":null}],"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00",'
			+ '"partnerNetFlag":null}},{"prodSpecGroups":[{"objectID":null,"name":"UPC Internet Light","description":"","extName":"","isRootProductSpecGroup":null}],'
			+ '"productSpecifications":[],"availabilityInfo":{"buildingStatus":"DEFAULT","availableDate":"2015-04-21+02:00","partnerNetFlag":null}}],'
			+ '"areaType":"AVAILABILITY_AREA","activationCode":null,"setupId":null,"region":"381","availabilityDescription":"UTRECHT","isPartnerNetwork":null,'
			+ '"networkId":null,"hubId":null,"nodeId":null},{"nodeId": null,"hubId": null,"networkId": null,"isPartnerNetwork": null,"availabilityDescription": null,'
			+ '"region": null,"setupId": null,"activationCode": null,"areaType": null,"availabilityGroups": null,"code": null,"type": "TELEPHONE_NUMBER_AREA"}],'
			+ '"firstName":null,"lastName":null,"title":null,"region":null,"additionalInfo":null,"properties":[],"entrance":null,"district":null}';
	}
}
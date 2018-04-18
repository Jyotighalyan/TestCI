public class LG_AddressResponse {
    public Boolean moreAddressesAvailable;
    public List<addView> addView {get; set;}
    
    public class addView {
        public String  footprint{get;set;}
        public String  type{get;set;}   // e.g. POSTAL
        public String  addressId{get;set;}  // e.g. 41639
        public String  streetName{get;set;} // e.g. Chemin des Coudriers
        public String  streetNrFirstSuffix{get;set;}    // e.g. 
        public String  streetNrFirst{get;set;}  // e.g. 39
        public String  streetNrLastSuffix{get;set;}
        public String  houseNumber{get;set;}
        public String  houseName{get;set;}
        public String  city{get;set;}   // e.g. Le Grand-Saconnex
        public String  postcode{get;set;}   // e.g. 1218
        public String  stateOrProvince{get;set;}  // e.g. Genève
        public String  CountryName{get;set;}    // e.g. CH
        public String  poBoxNr{get;set;}
        public String  poBoxType{get;set;}
        public String  attenstion{get;set;}
        public List<geographicAreas> geographicAreas {get;set;}
        public String  firstName{get;set;}    //": null,
        public String  lastName{get;set;}    //": null,
        public String  title{get;set;}    //": null,
        public String  region{get;set;}    //": null,
        public String  additionalInfo{get;set;}    //": null,
        public List<Object> properties{get;set;}    //": [],
        public String  entrance{get;set;}    //": null,
        public String  district{get;set;}    //": nullaa



        public String get(String fieldName) {
            if(fieldName == 'type') {
                return type;
            } else if(fieldName == 'addressId') {
                return addressId;        
            } else if(fieldName == 'streetName') {
                return streetName;        
            } else if(fieldName == 'streetNrFirstSuffix') {
                return streetNrFirstSuffix;        
            } else if(fieldName == 'streetNrFirst') {
                return streetNrFirst;        
            } else if(fieldName == 'city') {
                return city;        
            } else if(fieldName == 'postcode') {
                return postcode;        
            } else if(fieldName == 'stateOrProvince') {
                return stateOrProvince;        
            } else if(fieldName == 'CountryName') {
                return CountryName;        
            } else {
                return null;
            }
        }
    }

    public class geographicAreas {
        public String type{get;set;}//": "AVAILABILITY_AREA",
        public String code{get;set;}//": "11532542",
        public String availabilityGroups{get;set;}//": null,
        public String areaType{get;set;}//": "AVAILABILITY_AREA",
        public String activationCode{get;set;}//": null,
        public String setupId{get;set;}//": null,
        public String region{get;set;}//": "381",
        public String availabilityDescription{get;set;}//": "UTRECHT",
        public String isPartnerNetwork{get;set;}//": null,
        public String networkId{get;set;}//": null,
        public String hubId{get;set;}//": null,
        public String nodeId{get;set;}//": null
    }
    
    /**
	 * Used for saving to Optionals field of the Product Configuration Request
	 * 
	 * @author Tomislav Blazek
	 * @ticket SFDT-366
	 * @since  07/03/2016
	 */
    public class OptionalsJson {
        public String stateOrProvince {get;set;}	//Bavaria
        public String city {get;set;}	//Amstelveen
        public String postCode {get;set;}	//1183NW
        public String houseNumberExt {get;set;}	//AE
        public String houseNumber {get;set;}	//26
        public string latitude {get;set;}	//51.3176121
        public string longitude {get;set;}	//6.7469452
        public String street {get;set;}	//Bankrashof
        public String addressId {get;set;}	//12360
        public String selectedAddressDisplay	//Bankrashof 26AE, 1183NW Amstelveen
        {
            get 
            {
                // Extracted to Util becouse it is used in multiple classes
                return LG_util.getFormattedAddress(this.street, this.houseNumber, this.houseNumberExt, this.postcode, this.city);
            } 
            set;    
        }
        
        public OptionalsJson (LG_AddressResponse.addView address)
        {
            this.city = address.city;
            this.postCode = address.postcode;
            this.houseNumberExt = address.streetNrFirstSuffix;
            this.houseNumber = address.streetNrFirst;
            this.street = address.streetName;
            this.addressId = address.addressId;
            this.stateOrProvince =  address.stateOrProvince;
        }
        
        public OptionalsJson (cscrm__Address__c address)
        {
            this.city = address.cscrm__City__c;
            this.stateOrProvince = address.cscrm__State_Province__c;
            this.postCode = address.cscrm__Zip_Postal_Code__c;
            this.houseNumberExt = address.LG_HouseNumberExtension__c;
            this.houseNumber = address.LG_HouseNumber__c;
            this.latitude = String.valueOf(address.cscrm__Geolocation__latitude__s);
            this.longitude = String.valueOf(address.cscrm__Geolocation__longitude__s);
            this.street = address.cscrm__Street__c;
            this.addressId = address.LG_AddressID__c;
        }
    }
//Used for testing and dev environment
    public static String buildAddressResponse(Boolean onlyOneAddress)
    {
        if (onlyOneAddress)
        {
            String addressId = LG_Util.generateRandomNumberString(20);

            return '[{"footprint":"ZIGGO","type":null,"addressId":"' + addressId +'","streetName":"MARMERSTRAAT","streetNrFirstSuffix":"001","streetNrFirst":"22"'
                    + ',"streetNrLastSuffix":null,"streetNrLast":null,"houseNumber":null,"houseName":null,"city":"UTRECHT","postcode":"3572RE",'
                    + '"stateOrProvince":null,"countryName":"Netherlands","poBoxNr":null,"poBoxType":null,"attention":null,"geographicAreas":'
                    + '[{"type":"AVAILABILITY_AREA","code":"' + addressId +'","availabilityGroups":null,"areaType":"AVAILABILITY_AREA","activationCode":null,'
                    + '"setupId":null,"region":"381","availabilityDescription":"UTRECHT","isPartnerNetwork":null,"networkId":null,"hubId":null,'
                    + '"nodeId":null}],"firstName":null,"lastName":null,"title":null,"region":null,"additionalInfo":null,"properties":[],'
                    + '"entrance":null,"district":null}]';
        }
        else
        {
            String addressId = LG_Util.generateRandomNumberString(20);
            String secondAddressId = LG_Util.generateRandomNumberString(20);
            
            return '[{"footprint":"ZIGGO","type":null,"addressId":"' + addressId +'","streetName":"MARMERSTRAAT","streetNrFirstSuffix":"001",'
                    + '"streetNrFirst":"22","streetNrLastSuffix":null,"streetNrLast":null,"houseNumber":null,"houseName":null,"city":"UTRECHT"'
                    + ',"postcode":"3572RE","stateOrProvince":null,"countryName":"Netherlands","poBoxNr":null,"poBoxType":null,"attention":null,'
                    + '"geographicAreas":[{"type":"AVAILABILITY_AREA","code":"' + addressId +'","availabilityGroups":null,"areaType":"AVAILABILITY_AREA",'
                    + '"activationCode":null,"setupId":null,"region":"381","availabilityDescription":"UTRECHT","isPartnerNetwork":null,"networkId":null,'
                    + '"hubId":null,"nodeId":null}],"firstName":null,"lastName":null,"title":null,"region":null,"additionalInfo":null,"properties":[],'
                    + '"entrance":null,"district":null},{"footprint":null,"type":null,"addressId":"' + secondAddressId +'","streetName":"LEISTRAAT",'
                    + '"streetNrFirstSuffix":"1","streetNrFirst":"22","streetNrLastSuffix":null,"streetNrLast":null,"houseNumber":null,"houseName":null,'
                    + '"city":"UTRECHT","postcode":"3572RE","stateOrProvince":null,"countryName":"Netherlands","poBoxNr":null,"poBoxType":null,'
                    + '"attention":null,"geographicAreas":[{"type":"AVAILABILITY_AREA","code":"' + secondAddressId +'","availabilityGroups":null,"areaType":"AVAILABILITY_AREA"'
                    + ',"activationCode":null,"setupId":null,"region":"381","availabilityDescription":"UTRECHT","isPartnerNetwork":null,"networkId":null,'
                    + '"hubId":null,"nodeId":null}],"firstName":null,"lastName":null,"title":null,"region":null,"additionalInfo":null,"properties":[],'
                    + '"entrance":null,"district":null}]';
        }
    }
}
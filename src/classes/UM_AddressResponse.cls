public class UM_AddressResponse {

    /* public List<address> address {get; set;} */
    public List<addressExt> addressExt {get; set;}

    /*public class addresses {
        public UM_AddressResponse.address[] address;
        private String[] address_type_info = new String[]{'address','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'address'};
    } */

    public class addressesExt {
        public UM_AddressResponse.addressExt[] address;
        private String[] address_type_info = new String[]{'address','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'address'};
    }

    /*public class address {
        public String buildingId {get; set;}
        public String city {get; set;}
        public String street {get; set;}
        public String streetNo {get; set;}
        public String streetNoSuffix {get; set;}
        public Long uepId {get; set;}
        public String zip {get; set;}
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] uepId_type_info = new String[]{'uepId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','city','street','streetNo','streetNoSuffix','uepId','zip'};

        public String get(String fieldName) {

            if(fieldName == 'buildingId') {
                return buildingId;
            } else if(fieldName == 'street') {
                return street;
            } else if(fieldName == 'streetNoSuffix') {
                return streetNoSuffix;
            } else if(fieldName == 'streetNo') {
                return streetNo;
            } else if(fieldName == 'city') {
                return city;
            } else if(fieldName == 'zip') {
                return zip;
            } else {
                return null;
            }
        }
    }*/

    public class addressExt {
        public String buildingId {get; set;}
        public String city {get; set;}
        public String geoCoordinateEast {get; set;}
        public String geoCoordinateNorth {get; set;}
        public String mktAnalog {get; set;}
        public String mktDigital {get; set;}
        public String mktInternet {get; set;}
        public String mktMobile {get; set;}
        public String mktPhone {get; set;}
        public String street {get; set;}
        public String streetNo {get; set;}
        public String streetNoSuffix {get; set;}
        public String region {get; set;}
        public Long uepId {get; set;}
        public String zip {get; set;}
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] geoCoordinateEast_type_info = new String[]{'geoCoordinateEast','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] geoCoordinateNorth_type_info = new String[]{'geoCoordinateNorth','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] mktAnalog_type_info = new String[]{'mktAnalog','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] mktDigital_type_info = new String[]{'mktDigital','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] mktInternet_type_info = new String[]{'mktInternet','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] mktMobile_type_info = new String[]{'mktMobile','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] mktPhone_type_info = new String[]{'mktPhone','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] region_type_info = new String[]{'region','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] uepId_type_info = new String[]{'uepId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','city','geoCoordinateEast','geoCoordinateNorth','mktAnalog','mktDigital','mktInternet','mktMobile','mktPhone','street','streetNo','streetNoSuffix','region','uepId','zip'};

        public String get(String fieldName) {

            if(fieldName == 'buildingId') {
                return buildingId;
            } else if(fieldName == 'street') {
                return street;
            } else if(fieldName == 'streetNoSuffix') {
                return streetNoSuffix;
            } else if(fieldName == 'streetNo') {
                return streetNo;
            } else if(fieldName == 'city') {
                return city;
            } else if(fieldName == 'zip') {
                return zip;
            } else if(fieldName == 'region') {
                return region;
            } else if(fieldName == 'geoCoordinateNorth'){
                return geoCoordinateNorth;
            } else if(fieldName == 'geoCoordinateEast'){
                return geoCoordinateEast;
            } else {
                return null;
            }
        }

        public Boolean getServiceability(String fieldName) {

            if(fieldName == 'mktAnalog') {
                return (mktAnalog == 'Y') ? true : false;
            } else if(fieldName == 'mktDigital') {
                return (mktDigital == 'Y') ? true : false;
            } else if(fieldName == 'mktInternet') {
                return (mktInternet == 'Y') ? true : false;
            } else if(fieldName == 'mktMobile') {
                return (mktMobile == 'Y') ? true : false;
            } else if(fieldName == 'mktPhone') {
                return (mktPhone == 'Y') ? true : false;
            }

            return null;
        }
    }

    /*public class addressSearchResponse {
        public UM_AddressResponse.addresses return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }*/

    public class addressSearchExtResponse {
        public UM_AddressResponse.addressesExt return_x;
        private String[]return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    /*public class addressSearch {
        public String systemId;
        public Integer maxRecords;
        public Integer startRecord;
        public String zip;
        public String city;
        public String street;
        public String streetNo;
        public String streetNoSuffix;
        public Long buildingId;
        public String user_x;
        public String password;
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] maxRecords_type_info = new String[]{'maxRecords','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] startRecord_type_info = new String[]{'startRecord','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'systemId','maxRecords','startRecord','zip','city','street','streetNo','streetNoSuffix','buildingId','user_x','password'};
    }*/

    public class addressSearchExt {
        public String systemId;
        public Integer maxRecords;
        public Integer startRecord;
        public String zip;
        public String city;
        public String street;
        public String streetNo;
        public String streetNoSuffix;
        public String buildingId;
        public String user_x;
        public String password;
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] maxRecords_type_info = new String[]{'maxRecords','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] startRecord_type_info = new String[]{'startRecord','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'systemId','maxRecords','startRecord','zip','city','street','streetNo','streetNoSuffix','buildingId','user_x','password'};
    }

    public class APIExceptionClass {
        public String source;
        private String[] source_type_info = new String[]{'source','http://topasws.unitymedia.com/',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'source'};
    }

    public class TopasWSPort {
        public String endpoint_x = ''; /*https://apps.unitymedia.de/TopasWS/TopasWSService';*/
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://topasws.unitymedia.com/', 'UM_AddressResponse'};

        private String normalizeStreet(String strName) {

            Pattern streetPattern = Pattern.compile('(?i)(straße$)|(strasse$)');
            strName = streetPattern.matcher(strName).replaceAll('str.');

            return strName;
        }

        /* Address search - verify address */
        /*public UM_AddressResponse.addresses addressSearch(String systemId, Integer maxRecords, Integer startRecord, Map<String, String> searchParams, String user_x, String password) {

            UM_AddressResponse.addressSearch request_x = new UM_AddressResponse.addressSearch();
            request_x.systemId = systemId;
            request_x.maxRecords = maxRecords;
            request_x.startRecord = startRecord;
            if(searchParams.containsKey('zip')) request_x.zip = searchParams.get('zip');
            if(searchParams.containsKey('city')) request_x.city = searchParams.get('city');
            if(searchParams.containsKey('street')) request_x.street = this.normalizeStreet( searchParams.get('street') );
            if(searchParams.containsKey('streetNo')) request_x.streetNo = searchParams.get('streetNo');
            if(searchParams.containsKey('streetNoSuffix')) request_x.streetNoSuffix = searchParams.get('streetNoSuffix');
            //request_x.buildingId = buildingId;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_AddressResponse.addressSearchResponse response_x;
            Map<String, UM_AddressResponse.addressSearchResponse> response_map_x = new Map<String, UM_AddressResponse.addressSearchResponse>();
            response_map_x.put('response_x', response_x);

            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'addressSearch',
              'http://topasws.unitymedia.com/',
              'addressSearchResponse',
              'UM_AddressResponse.addressSearchResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }*/

        /* Address search with additional data - service accessibility */
        public UM_AddressResponse.addressesExt addressSearchExt(String systemId,Integer maxRecords,Integer startRecord,Map<String, String> searchParams,String user_x,String password) {
            UM_AddressResponse.addressSearchExt request_x = new UM_AddressResponse.addressSearchExt();
            request_x.systemId = systemId;
            request_x.maxRecords = maxRecords;
            request_x.startRecord = startRecord;
            if(searchParams.containsKey('zip')) request_x.zip = searchParams.get('zip');
            if(searchParams.containsKey('city')) request_x.city = searchParams.get('city');
            if(searchParams.containsKey('street')) request_x.street = this.normalizeStreet( searchParams.get('street') );
            if(searchParams.containsKey('streetNo')) request_x.streetNo = searchParams.get('streetNo');
            if(searchParams.containsKey('streetNoSuffix')) request_x.streetNoSuffix = searchParams.get('streetNoSuffix');
            if(searchParams.containsKey('buildingId')) request_x.buildingId = searchParams.get('buildingId');
            request_x.user_x = user_x;
            request_x.password = password;
            system.debug('+++request_x: ' + request_x);
            UM_AddressResponse.addressSearchExtResponse response_x;
            Map<String, UM_AddressResponse.addressSearchExtResponse> response_map_x = new Map<String, UM_AddressResponse.addressSearchExtResponse>();
            response_map_x.put('response_x', response_x);

            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'addressSearchExt',
              'http://topasws.unitymedia.com/',
              'addressSearchExtResponse',
              'UM_AddressResponse.addressSearchExtResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }

    /**
     * Used for saving to Optionals field of the Product Configuration Request
     *
     * @author Tomislav Blazek
     * @ticket SFDT-366
     * @since  07/03/2016
     */
    public class OptionalsJson {
        public String region {get;set;}    //Bavaria
        public String city {get;set;}   //Amstelveen
        public String zip {get;set;}   //1183NW
        public String streetNoSuffix {get;set;} //AE
        public String streetNo {get;set;}    //26
        public String street {get;set;} //Bankrashof
        public String buildingId {get;set;}  //12360
        public String geoCoordinateNorth{get;set;}   //51.3176121
        public String geoCoordinateEast{get;set;}  //6.7469452
        public string stateOrProvince {get;set;}

        public String mktAnalog {get; set;}
        public String mktDigital {get; set;}
        public String mktInternet {get; set;}
        public String mktMobile {get; set;}
        public String mktPhone {get; set;}

        public String selectedAddressDisplay    //Bankrashof 26AE, 1183NW Amstelveen
        {
            get
            {
                // Extracted to Util becouse it is used in multiple classes
                return LG_util.getFormattedAddress(this.street, this.streetNo, this.streetNoSuffix, this.zip, this.city);
            }
            set;
        }

        public OptionalsJson (UM_AddressResponse.addressExt address)
        {
            this.region = address.region;
            this.city = address.city;
            this.zip = address.zip;
            this.streetNoSuffix = address.streetNoSuffix;
            this.streetNo = address.streetNo;
            this.street = address.street;
            this.buildingId = address.buildingId;
            this.geoCoordinateNorth= address.geoCoordinateNorth;
            this.geoCoordinateEast= address.geoCoordinateEast;
            this.stateOrProvince = address.region;

            this.mktAnalog = address.mktAnalog;
            this.mktDigital = address.mktDigital;
            this.mktInternet = address.mktInternet;
            this.mktMobile = address.mktMobile;
            this.mktPhone = address.mktPhone;
        }
    }
}
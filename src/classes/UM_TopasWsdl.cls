public class UM_TopasWsdl {

    public class addresses {
        public UM_TopasWsdl.address[] address;
        private String[] address_type_info = new String[]{'address','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'address'};
    }
    
    public class addressExt {
        public Long buildingId;
        public String city;
        public String geoCoordinateEast;
        public String geoCoordinateNorth;
        public String mktAnalog;
        public String mktDigital;
        public String mktInternet;
        public String mktMobile;
        public String mktPhone;
        public String street;
        public String streetNo;
        public String streetNoSuffix;
        public Long uepId;
        public String zip;
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
        private String[] uepId_type_info = new String[]{'uepId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','city','geoCoordinateEast','geoCoordinateNorth','mktAnalog','mktDigital','mktInternet','mktMobile','mktPhone','street','streetNo','streetNoSuffix','uepId','zip'};
    }

    public class address {
        public Long buildingId;
        public String city;
        public String street;
        public String streetNo;
        public String streetNoSuffix;
        public Long uepId;
        public String zip;
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] uepId_type_info = new String[]{'uepId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','city','street','streetNo','streetNoSuffix','uepId','zip'};
    }

    public class streets {
        public String[] street;
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'street'};
    }

    public class cities {
        public String[] city;
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'city'};
    }

    public class unlockOofAddress {
        public Long buildingId;
        public String user_x;
        public String password;
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','user_x','password'};
    }

    public class addressSearchResponse {
        public UM_TopasWsdl.addresses return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class getStreetsResponse {
        public UM_TopasWsdl.streets return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class addressesExt {
        public UM_TopasWsdl.addressExt[] address;
        private String[] address_type_info = new String[]{'address','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'address'};
    }

    public class getBuildingsResponse {
        public UM_TopasWsdl.buildings return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class building {
        public Long buildingId;
        public Integer oofFlag;
        public String region;
        public String streetNo;
        public String streetNoSuffix;
        public String systemId;
        public Long uepId;
        private String[] buildingId_type_info = new String[]{'buildingId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] oofFlag_type_info = new String[]{'oofFlag','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] region_type_info = new String[]{'region','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNo_type_info = new String[]{'streetNo','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] streetNoSuffix_type_info = new String[]{'streetNoSuffix','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] uepId_type_info = new String[]{'uepId','http://topasws.unitymedia.com/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'buildingId','oofFlag','region','streetNo','streetNoSuffix','systemId','uepId'};
    }

    public class getCitiesResponse {
        public UM_TopasWsdl.cities return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class addressSearchExt {
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
    }

    public class APIExceptionClass {
        public String source;
        private String[] source_type_info = new String[]{'source','http://topasws.unitymedia.com/',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'source'};
    }

    public class unlockOofAddressResponse {
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{};
    }

    public class buildings {
        public UM_TopasWsdl.building[] building;
        private String[] building_type_info = new String[]{'building','http://topasws.unitymedia.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'building'};
    }

    public class addressSearchExtResponse {
        public UM_TopasWsdl.addressesExt return_x;
        private String[] return_x_type_info = new String[]{'return','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class addressSearch {
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
    }

    public class getStreets {
        public String systemId;
        public String zip;
        public String city;
        public String user_x;
        public String password;
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'systemId','zip','city','user_x','password'};
    }

    public class getCities {
        public String systemId;
        public String zip;
        public String user_x;
        public String password;
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'systemId','zip','user_x','password'};
    }

    public class getBuildings {
        public String systemId;
        public String zip;
        public String city;
        public String street;
        public String user_x;
        public String password;
        private String[] systemId_type_info = new String[]{'systemId','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] zip_type_info = new String[]{'zip','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] city_type_info = new String[]{'city','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] street_type_info = new String[]{'street','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://topasws.unitymedia.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://topasws.unitymedia.com/','false','false'};
        private String[] field_order_type_info = new String[]{'systemId','zip','city','street','user_x','password'};
    }

    public class TopasWSPort {
        public String endpoint_x = 'https://apps.unitymedia.de/TopasWS/TopasWSService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://topasws.unitymedia.com/', 'UM_TopasWsdl'};
        public UM_TopasWsdl.buildings getBuildings(String systemId,String zip,String city,String street,String user_x,String password) {
            UM_TopasWsdl.getBuildings request_x = new UM_TopasWsdl.getBuildings();
            request_x.systemId = systemId;
            request_x.zip = zip;
            request_x.city = city;
            request_x.street = street;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.getBuildingsResponse response_x;
            Map<String, UM_TopasWsdl.getBuildingsResponse> response_map_x = new Map<String, UM_TopasWsdl.getBuildingsResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'getBuildings',
              'http://topasws.unitymedia.com/',
              'getBuildingsResponse',
              'UM_TopasWsdl.getBuildingsResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }

        public void unlockOofAddress(Long buildingId,String user_x,String password) {
            UM_TopasWsdl.unlockOofAddress request_x = new UM_TopasWsdl.unlockOofAddress();
            request_x.buildingId = buildingId;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.unlockOofAddressResponse response_x;
            Map<String, UM_TopasWsdl.unlockOofAddressResponse> response_map_x = new Map<String, UM_TopasWsdl.unlockOofAddressResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'unlockOofAddress',
              'http://topasws.unitymedia.com/',
              'unlockOofAddressResponse',
              'UM_TopasWsdl.unlockOofAddressResponse'}
            );
            response_x = response_map_x.get('response_x');
        }

        public UM_TopasWsdl.addresses addressSearch(String systemId,Integer maxRecords,Integer startRecord,String zip,String city,String street,String streetNo,String streetNoSuffix,Long buildingId,String user_x,String password) {
            UM_TopasWsdl.addressSearch request_x = new UM_TopasWsdl.addressSearch();
            request_x.systemId = systemId;
            request_x.maxRecords = maxRecords;
            request_x.startRecord = startRecord;
            request_x.zip = zip;
            request_x.city = city;
            request_x.street = street;
            request_x.streetNo = streetNo;
            request_x.streetNoSuffix = streetNoSuffix;
            request_x.buildingId = buildingId;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.addressSearchResponse response_x;
            Map<String, UM_TopasWsdl.addressSearchResponse> response_map_x = new Map<String, UM_TopasWsdl.addressSearchResponse>();
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
              'UM_TopasWsdl.addressSearchResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }

        public UM_TopasWsdl.streets getStreets(String systemId,String zip,String city,String user_x,String password) {
            UM_TopasWsdl.getStreets request_x = new UM_TopasWsdl.getStreets();
            request_x.systemId = systemId;
            request_x.zip = zip;
            request_x.city = city;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.getStreetsResponse response_x;
            Map<String, UM_TopasWsdl.getStreetsResponse> response_map_x = new Map<String, UM_TopasWsdl.getStreetsResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'getStreets',
              'http://topasws.unitymedia.com/',
              'getStreetsResponse',
              'UM_TopasWsdl.getStreetsResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }

        public UM_TopasWsdl.cities getCities(String systemId,String zip,String user_x,String password) {
            UM_TopasWsdl.getCities request_x = new UM_TopasWsdl.getCities();
            request_x.systemId = systemId;
            request_x.zip = zip;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.getCitiesResponse response_x;
            Map<String, UM_TopasWsdl.getCitiesResponse> response_map_x = new Map<String, UM_TopasWsdl.getCitiesResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://topasws.unitymedia.com/',
              'getCities',
              'http://topasws.unitymedia.com/',
              'getCitiesResponse',
              'UM_TopasWsdl.getCitiesResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }

        public UM_TopasWsdl.addressesExt addressSearchExt(String systemId,Integer maxRecords,Integer startRecord,String zip,String city,String street,String streetNo,String streetNoSuffix,Long buildingId,String user_x,String password) {
            UM_TopasWsdl.addressSearchExt request_x = new UM_TopasWsdl.addressSearchExt();
            request_x.systemId = systemId;
            request_x.maxRecords = maxRecords;
            request_x.startRecord = startRecord;
            request_x.zip = zip;
            request_x.city = city;
            request_x.street = street;
            request_x.streetNo = streetNo;
            request_x.streetNoSuffix = streetNoSuffix;
            request_x.buildingId = buildingId;
            request_x.user_x = user_x;
            request_x.password = password;
            UM_TopasWsdl.addressSearchExtResponse response_x;
            Map<String, UM_TopasWsdl.addressSearchExtResponse> response_map_x = new Map<String, UM_TopasWsdl.addressSearchExtResponse>();
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
              'UM_TopasWsdl.addressSearchExtResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}
@isTest
global class UM_MPIUtilityTest {
    static string c='eU9WzoFgU4n8Apu5PYxcNGRZswRDZJWDEMdbQVU85gw=';
    static string c1='===eU9WzoFgU4n8Apu5PYxcNGRZswRDZJWDEMdbQVU85gw===';
    static string c2='eU9WzoFgU4n8Apu5PYxcNGRZswRDZJWDEMdbQVU85gw';
    
    public static testmethod void utiltest(){
        
        String file_name='';
        Blob cryptoKey= EncodingUtil.base64Decode(c2);
        String bodyEncoded = EncodingUtil.base64Encode(cryptoKey);
        Blob bodyBlob = null;
        system.debug(bodyEncoded.length()-4+bodyEncoded.length());
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        system.debug(last4Bytes);
        map<String, String> metaData=new map<String,String>();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        test.startTest();
        
        UM_MPIUtility.deliverFile(file_name,cryptoKey,metaData);
        test.stopTest();
        
    }
    
}
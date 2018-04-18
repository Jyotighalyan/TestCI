/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
public class KenanEnumerationService {

	//public static List<KenanEnumeration> getEnumerations(){
	//	List<KenanEnumeration> enumerations = new List<KenanEnumeration>();
	//	KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
	//	HttpResponse response = helper.sendRequest(null, 'GET', '/enumerations', 0, 0);

	//	enumerations = (List<KenanEnumeration>) JSON.deserialize(response.getBody(), List<KenanEnumeration>.class);
		
	//	system.debug('enumerations:' + enumerations[0]);
	//	return enumerations;
	//}

	public static KenanEnumeration getEnumeration(String enumName){
		//KenanEnumeration enumeration;= new List<KenanEnumeration>();
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		HttpResponse response = helper.sendRequest(null, 'GET', '/enumeration/' + enumName, 0, 0);

		KenanEnumeration enumeration = (KenanEnumeration) JSON.deserialize(response.getBody(), KenanEnumeration.class);
		
		system.debug('enumeration:' + enumeration);
		return enumeration;
	}
}
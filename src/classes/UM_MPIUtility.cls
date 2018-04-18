/**
  * Class that is used to prepare the data for the MPI Webservice via Spider
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
public class UM_MPIUtility {

	/**
	  * Method that is used to prepare the data for the MPI Webservice via Spider
	  * @future (callout=true) is used because this method is called from a trigger
	  *
	  * @param file_name	string with the name of the file that is sent
	  * @param file_body	blob with the actual file that is sent
	  * @param metadata		map with meta data that is needed for MPI
	  */
	@future (callout=true)
	public static void deliverFile(String file_name, Blob file_body, map<String, String> metaData){

		//Define boundary (you can use any string, but must be unique)
		String boundary = '-------MPI--------5g71v0mhy^54';
		String finalbody = '';

		//Create entries for metadata
		for(String name : metaData.keySet()){
			String header = '--' + boundary + '\r\nContent-Disposition: form-data; name="' + name + '"\r\n\r\n';
			String body = metaData.get(name) + '\r\n';
			finalbody += header + body;
		}

		//Special handling of binary data for file upload
		String header = '--' + boundary +'\nContent-Disposition: form-data; name="document"; filename="' + file_name + '";\nContent-Type: application/pdf';
		finalbody += header;
		String footer = '--' + boundary + '--';
		system.debug('finalbody is:'+finalbody);
		String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(finalbody+'\r\n\r\n'));
		while(headerEncoded.endsWith('=')){
			finalbody+=' ';
			headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(finalbody+'\r\n\r\n'));
		}
		String bodyEncoded = EncodingUtil.base64Encode(file_body);
		Blob bodyBlob = null;
		String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
		if(last4Bytes.endsWith('==')) {
			last4Bytes = last4Bytes.substring(0,2) + '0K';
			bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
			String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
		} else if(last4Bytes.endsWith('=')) {
			last4Bytes = last4Bytes.substring(0,3) + 'N';
			bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
			footer = '\n' + footer;
			String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
		} else {
			footer = '\r\n' + footer;
			String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
		}

		//Make callout
		HTTPResponse res = UM_MPIResponse.sendData(boundary, bodyBlob);
		
	}
}
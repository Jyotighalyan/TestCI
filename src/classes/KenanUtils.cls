/**
* TODO: ApexDoc.
*/
public class KenanUtils {

	public static DateTime convertFromUnix(Long timestamp){
		return DateTime.newInstance(timestamp);
	}

	public static Long convertToUnix(DateTime timestamp){
		return timestamp.getTime();
	}

	public static KenanException handleException(HttpResponse response){
		system.debug('handleException:' + response.getBody());
		KenanException e =  new KenanException(response);
		
		return e;
	}
	
	public static DateTime fixDateTime(object dateObject){
		Datetime convertedDate;

		if(dateObject instanceof Datetime) {
			Datetime dte = (Datetime) dateObject;
			convertedDate = Datetime.newInstance(
								dte.year() , //year
								dte.month(), //month
								dte.day(), //day
								dte.hour(), //hour
								dte.minute(), //minute
								dte.second()); //second
		} else {
			//expected format: 2016-06-29T14:00:43.448Z
			String dateToConvert = (String) dateObject;
			List<String> dateTimeArray = dateToConvert.split('T');
			List<String> dateArray = dateTimeArray[0].split('-');
			List<String> hourArray = dateTimeArray[1].split(':');
			String second = hourArray[2].left(2);
			
			convertedDate = Datetime.newInstance(
								Integer.valueOf(dateArray[0]) , //year
								Integer.valueOf(dateArray[1]), //month
								Integer.valueOf(dateArray[2]), //day
								Integer.valueOf(hourArray[0]), //hour
								Integer.valueOf(hourArray[1]), //minute
								Integer.valueOf(second)); //second
		}

		return convertedDate;
	}
	
	public static Map<String, String> getExternalDataMap(Map<String, Object> objectMap){
		Map<String, String> extDataString = new Map<String, String>();
		for (String key : objectMap.keySet()){
			extDataString.put(key, String.valueOf(objectMap.get(key)));
		}
		return extDataString;
	}

	private static String fakeIdSuffix {
		set;
		get {
			fakeIdSuffix = String.valueOf(fakeIdSuffix == null ? 0 : (Integer.valueOf(fakeIdSuffix) + 1));
			return fakeIdSuffix;
		}
	}

	public static Id getFakeId(Schema.SObjectType objectType) {
		String idPrefix = objectType.getDescribe().getKeyPrefix();
		String idSuffix = fakeIdSuffix;
		String idPadding = '0'.repeat(12 - idSuffix.length());
		return Id.valueOf(idPrefix + idPadding + idSuffix);
	}

	public static String getGMTFormattedDateString(Datetime theDate) {
		return EncodingUtil.urlEncode(theDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''), 'UTF-8');
	}
}
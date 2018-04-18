public class KenanGWTEncodingUtils {
		
	public static String urlEncode(String unencodedString) {
        String returnVal = null;
        if(unencodedString != null) {
            returnVal = '';
            for(Integer i = 0; i < unencodedString.length(); i++) {
                String c = charAt(unencodedString, i);
                if('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789;,/?:@&=+$-_.!~*();'.contains(c)) {
                    returnVal += c;
                } else if(' '.equals(c)) {
                    returnVal += '%20';
                } else {
                    returnVal += EncodingUtil.urlEncode(c, 'UTF-8');
                }
            }
        }
        return returnVal;
    } 

    @TestVisible
    private static String charAt(String str, Integer index) {
        if(str == null) {
            return null;
        }
        if(str.length() <= 0) {
            return str;    
        }
        if(index < 0 || index >= str.length()) {
            return null;    
        }
        return str.substring(index, index+1);
    }
}
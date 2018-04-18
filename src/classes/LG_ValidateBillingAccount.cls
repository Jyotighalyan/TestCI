public class LG_ValidateBillingAccount {
 
// 14-1-2016 Theo ten Klooster : Created Class
// IBAN Validation on Billing Account 

    public enum BankNumberValidationResult {
      IBAN_OK, // Valid IBAN
        IBAN_INVALID_FORMAT, // Base format check failed (must start with country code, ...)
        IBAN_INVALID_LENGTH, // Invalid country specific length
        IBAN_SANITY_CHECK_FAILED, // Failed sanity check
        IBAN_WRONG_COUNTRY_CHECKSUM // Wrong country specific checksum (example: Eleven-check in the Netherlands)
    }
     
    // Basic IBAN Pattern
    public static final Pattern IBAN_PATTERN = Pattern.compile('^[A-Z]{2}[0-9]{2}[A-Z0-9]+$');
       
    public static void handle(List<csconta__Billing_Account__c> newData, List<csconta__Billing_Account__c> oldData){
        IBAN_Validation(newData);
       //system.debug('testing-------'+m.find());
    }
    
    private static void IBAN_Validation(List<csconta__Billing_Account__c> data){
        Map<String, Integer> IbanValues = IbanMap();
        for(csconta__Billing_Account__c o : data){
            BankNumberValidationResult validationResult = checkIban(o.LG_BankAccountNumberIBAN__c,IbanValues);
            if(validationResult != BankNumberValidationResult.IBAN_OK){
                o.LG_BankAccountNumberIBAN__c.addError(getErrorMessage(validationResult));
            }
        }
    }
    
    private static String getErrorMessage(BankNumberValidationResult validationResult) {
        if (validationResult == BankNumberValidationResult.IBAN_INVALID_FORMAT) {
            return Label.LG_IBANInvalidFormat;
        } else if (validationResult == BankNumberValidationResult.IBAN_INVALID_LENGTH) {
            return Label.LG_IBANInvalidLength;
        } else if (validationResult == BankNumberValidationResult.IBAN_SANITY_CHECK_FAILED) {
            return Label.LG_IBANSanityCheckFailed;
        } else if (validationResult == BankNumberValidationResult.IBAN_WRONG_COUNTRY_CHECKSUM) {
            return Label.LG_IBANWrongCountryChecksum;
        }
        return Label.LG_IBANInvalidCode;
    }
    //replacing characters with numeric values for iban validation
    private static Map<String, Integer> IbanMap(){
        Map<String, Integer> finalMap = new Map<String, Integer>();
        string alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        for(integer i = 0, k = alphabet.length(); i < k ; i++){
            finalMap.put(alphabet.substring(i,i+1),i);
            system.debug('finalmap' +finalmap);
        }
        return finalMap;
    }
    
    private static BankNumberValidationResult checkIban(String iban, Map<String, Integer> IbanValues) {
        // IBAN field can be empty / not specified
        if(String.isEmpty(iban)){
            return BankNumberValidationResult.IBAN_OK;
        }
        // remove whitespaces
        String code = iban.replaceAll('(\\s+)', '').toUppercase();
       
       // system.debug('mycode----'+code +'------------'+ IBAN_PATTERN.matcher(code).matches());
        // check format
        if (code.length() < 5 || !IBAN_PATTERN.matcher(code).matches()) {
            
            return BankNumberValidationResult.IBAN_INVALID_FORMAT;
        }
        // check country specific length
        String countryCode = code.substring(0, 2);
        LG_IBAN__c ibanCountrySpecificConfiguration = LG_IBAN__c.getValues(countryCode);
        if ((ibanCountrySpecificConfiguration != null) && (ibanCountrySpecificConfiguration.LG_Length__c != code.length())) {
          System.debug(ibanCountrySpecificConfiguration);
          return BankNumberValidationResult.IBAN_INVALID_LENGTH;
        }
        // IBAN sanity check
        String reformattedCode = code.substring(4) + code.substring(0, 4);
        Long total = 0;
        Long Max = 999999999;
        Integer charValue;
        for (Integer i = 0, j = reformattedCode.length(); i < j; i++) {
            charValue = IbanValues.get(reformattedCode.substring(i, i + 1));
            total = (charValue > 9 ? total * 100 : total * 10) + charValue; 
            if (total > MAX) {
                total = Math.mod(total, 97);
            }
        }
        return ((Math.mod(total , 97) == 1) ? BankNumberValidationResult.IBAN_OK : BankNumberValidationResult.IBAN_SANITY_CHECK_FAILED);
    }
   
}
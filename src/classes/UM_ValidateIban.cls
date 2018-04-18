/**
 * Local variation - Iban number validation via webservice provided by
 * UnityMedia - Tolerant, available via Spider
 *
 * @author Robert Stankiewicz <robert.stankiewicz@accenture.com>
 * @version 1.0
 */
global class UM_ValidateIban {
    
    public enum BankNumberValidationResult {
        IBAN_OK,    // Valid IBAN
        IBAN_NOTOK, // Invalid IBAN
        IBAN_EMPTY, // No IBAN
        NO_CONNECTION
    }

    /**
     * Interface used to implement Iban check initialized from 
     * custom button - invoked from JS
     * @param  recordId Id of record on which Iban check need to be executed
     * @return          Returns error message
     */
    Webservice static String checkIbanWebservice(String recordId) {

        List<Id> recordsToCheck = new List<Id>();
        recordId = String.escapeSingleQuotes( recordId );
        recordsToCheck.add( Id.valueOf(recordId) );

        String sObjName = recordsToCheck[0].getSObjectType().getDescribe().getName();
        List<sObject> objectsToValidate = Database.query('SELECT Id, LG_BankAccountNumberIBAN__c, UM_IBANValidated__c FROM '+sObjName+' WHERE Id IN :recordsToCheck');

        IBAN_Validation validateIban = new IBAN_Validation( objectsToValidate );
        //system.debug('--+ validate iban: '+validateIban);
        if(validateIban.validatedObjects.size() > 0){

            try {             
                update validateIban.validatedObjects;

            } catch (DmlException e) {

                System.debug(e.getMessage());           
            }    
        }
       
        return validateIban.listOfErrors.get( recordId );
    }

    public class IBAN_Validation {

        public Map<Id, String> listOfErrors {get;set;}
        public List<sObject> validatedObjects {get;set;}

        public String bic {get;set;}

        public final Integer TIMEOUT_X = 2000;
        //public final String ENDPOINT_X = 'callout:UM_SpiderWS/TolerantWS/TolerantWSService';
        public final String ENDPOINT_X = 'callout:UM_SpiderWS_IBAN_Validation/TolerantWS/TolerantWSService';

        private UM_WebserviceCredentials__c loginCredentials {
            get {
                if(loginCredentials == null) {
                    loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TolerantWS');
                }
                return loginCredentials;
            } 
            set;
        }

        private String getErrorMessage(BankNumberValidationResult validationResult) {

            if (validationResult == BankNumberValidationResult.IBAN_OK) {
                return Label.UM_IBANOk;
            } else if (validationResult == BankNumberValidationResult.IBAN_EMPTY) {
                return Label.UM_NoIBAN;
            } else if (validationResult == BankNumberValidationResult.NO_CONNECTION) {
                return Label.UM_NoConnection;
            }

            return Label.UM_IBANNotVerified;
        }

        public IBAN_Validation( List<sObject> objectsToValidate ) {
 
            listOfErrors = new Map<Id, String>();
            validatedObjects = new List<sObject>();
            
            for(sObject ibanToCheck : objectsToValidate) {
                String iban = String.valueOf( ibanToCheck.get('LG_BankAccountNumberIBAN__c') );                
                BankNumberValidationResult validationResult = checkIban( iban );

                if(validationResult == BankNumberValidationResult.IBAN_OK) {
                    ibanToCheck.put( 'UM_IBANValidated__c', true );
                } else {
                    ibanToCheck.put( 'UM_IBANValidated__c', false );
                }

                if(bic != null) {
                    ibanToCheck.put( 'UM_BankAccountNumberBic__c', bic);
                }

                listOfErrors.put( ibanToCheck.Id, getErrorMessage(validationResult) );
                validatedObjects.add( ibanToCheck );
            }
        }

        private BankNumberValidationResult checkIban(String iban) {

            if(String.isEmpty(iban)) {
                return BankNumberValidationResult.IBAN_EMPTY;
            }

            UM_IbanResponse.TolerantWSPort ws = new UM_IbanResponse.TolerantWsPort();
            ws.timeout_x = TIMEOUT_X;
            ws.endpoint_x = ENDPOINT_X;

            bic = null;

            try {
                UM_IbanResponse.checkResult res = ws.checkIban(iban, loginCredentials.login__c, loginCredentials.password__c);

                if(res.rclist != null && res.rclist.WsbnkBankrectypeUser[0].bic != null) {

                    bic = res.rclist.WsbnkBankrectypeUser[0].bic;
                }

                // More data sent back in this request can be used, check UM_IbanResponse
                if(res.rclist != null && res.rclist.WsbnkBankrectypeUser[0].resultmsg == null) {

                    return BankNumberValidationResult.IBAN_OK;
                }

            } catch (Exception e) {

                //System.debug(e.getMessage());
                return BankNumberValidationResult.NO_CONNECTION;
            }

            return BankNumberValidationResult.IBAN_NOTOK;
        }

    }
   
}
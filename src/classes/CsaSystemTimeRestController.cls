@RestResource(urlMapping='/CsaRest/SystemTime')
global without sharing class CsaSystemTimeRestController {
    
    /**
     * Returns the current Salesforce system time.
     * Datetime.getTime returns the offset from 1/1/70 in milliseconds.
     */
    @HttpGet 
    global static Long getSystemTime() {
        return DateTime.now().getTime();
    }
}
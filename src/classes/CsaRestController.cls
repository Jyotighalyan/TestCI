@RestResource(urlMapping='/CsaRest')
global without sharing class CsaRestController {
    
    /**
     * Returns whether or not the CSA rest api is available. 
     */
    @HttpGet 
    global static Boolean isRestApiAvailable() {
        return true;
    }
}
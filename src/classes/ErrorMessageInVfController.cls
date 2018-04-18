public with sharing class ErrorMessageInVfController {

    public ErrorMessageInVfController(ApexPages.StandardController controller) {
       ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'You cannot edit when services are Active');
        ApexPages.addmessage(myMsg);        
    }     
 }
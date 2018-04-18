/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAdjustmentProcessBuilder for use in Salesforce Kenan Connector to send Adjusment updates to Kenan API
*/
public class KenanAdjustmentProcessBuilder {

    /** 
    * @description Method that can be called from Process Builder to support updates to adjustments in Kenan Billing System
    * @param adjustments List<Kenan_Adjustment__c> List of Kenan_Adjustment__c objects whose Approval_Status__c field has been changed. 
    * This method is meant to be called from Process Builder. This in turn will call updateAdjustmentCallout method that will send the HTTP Callout to Kenan.
    */
    @InvocableMethod(label='Update Adjustments' description='Update an Adjustment Record in Kenan Billing system.')
    public static void updateAdjustment(List<Kenan_Adjustment__c> adjustments){
        system.debug('KenanAdjustmentProcessBuilder.updateAdjustment:' + adjustments);
        
        for (Kenan_Adjustment__c ka : adjustments){
            updateAdjustmentCallout(ka.Id);
        }
        
    }

    @future(callout=true)
    public static void updateAdjustmentCallout(Id adjustmentId){
        Kenan_Adjustment__c adjustment = [SELECT Id, trackingId__c, trackingIdServ__c, Approval_Status__c, OwnerId, Owner.Email, LastModifiedById, LastModifiedBy.Name, LastModifiedBy.Email FROM Kenan_Adjustment__c WHERE Id = :adjustmentId LIMIT 1];
        KenanAdjustmentService service = new KenanAdjustmentService();
        KenanAdjustment ka = new KenanAdjustment();
        ka.trackingId = adjustment.trackingId__c;
        ka.trackingIdServ = adjustment.trackingIdServ__c;
        ka.approvalStatus = adjustment.Approval_Status__c;
        ka.approvedBy = adjustment.LastModifiedBy.Name;
        try {
            if (!Test.isRunningTest()){
                service.updateRow(ka, 'PUT', null);
            }
        } 
        catch (KenanException ke) {
            sendEmailNotification(adjustment, ke);
        }
    }

    @TestVisible
    private static void sendEmailNotification(Kenan_Adjustment__c adjustment, KenanException e){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<String> toAddresses = new List<String>();
        if (Test.isRunningTest()){
            toAddresses.add('a@a.com');
        } else {
            toAddresses.add(adjustment.Owner.Email);
            toAddresses.add(adjustment.LastModifiedBy.Email);   
        }
        
        mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
        mail.setWhatId(adjustment.Id);
        
        String htmlBody = 'An Error occured when trying to send an update to the Billing System.<br/>';
        htmlBody = htmlBody + URL.getSalesforceBaseUrl().toExternalForm() + '/' + adjustment.id + '<br/><p>';
        htmlBody = htmlBody + e + '</p>';

        mail.setHtmlBody(htmlBody);

        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }

    }
}
global with sharing class UM_SendEmailToSipwiseController {

    public UM_SendEmailToSipwiseController(ApexPages.StandardController stdController) {

    }

    Webservice static String sendEmailJS(String recordId) {
        list<asset> phoneNumbers = new list<asset>();

        UM_SendEmailToSipwise e = new UM_SendEmailToSipwise();
        csord__Service__c serviceDetails = [SELECT Id, LG_Address__r.cscrm__State_Province__c, LG_Address__r.LG_AddressID__c, csord__Subscription__r.csord__Account__r.LG_AccountNumber__c, LG_ServiceStatus__c,  csordtelcoa__Product_Configuration__c
                                                FROM csord__Service__c
                                                WHERE id=:recordId LIMIT 1];

        if(serviceDetails.LG_ServiceStatus__c=='Requested'){
            serviceDetails.LG_ServiceStatus__c='Sent to Provisioning';
            update serviceDetails;

            list<csord__Service__c> numberRangeServices = [select id from csord__Service__c where csord__Service__c=:recordId];

            phoneNumbers = [select id, status from asset where csord__Service__c in :numberRangeServices];
            for(Asset p : phoneNumbers){
                p.status = 'Provisioning Requested';
            }
            update phoneNumbers;
        }
        return e.sendEmailToSipwise(recordId);
    }

    public static String sendEmailTrigger(String recordId) {

        UM_SendEmailToSipwise e = new UM_SendEmailToSipwise();

        return e.sendEmailToSipwise(recordId);
    }

    public class UM_SendEmailToSipwise {

        public String res = 'Email sent';
        public UM_Email_Settings__c emailSettings;

        public UM_SendEmailToSipwise() {

            emailSettings = UM_Email_Settings__c.getValues('Sipwise Provisioning');
        }

        public String sendEmailToSipwise(String recordId) {
            Map<String, String> subscriberDetails = new Map<String, String>();

            // query objects
            // get parent service details
            csord__Service__c serviceDetails = [SELECT Id, LG_Address__r.cscrm__State_Province__c, LG_Address__r.LG_AddressID__c, csord__Subscription__r.csord__Account__r.LG_AccountNumber__c, LG_ServiceStatus__c,  csordtelcoa__Product_Configuration__c
                                                    FROM csord__Service__c
                                                    WHERE id=:recordId LIMIT 1];


            // get child services
            List<String> childServicesConfig = new List<String>();
            for(csord__Service__c childService: [SELECT Id, csordtelcoa__Product_Configuration__c FROM csord__Service__c WHERE csord__Service__c=:recordId]) {

                system.debug('--+ '+childService.csordtelcoa__Product_Configuration__c);
                childServicesConfig.add(childService.csordtelcoa__Product_Configuration__c);
            }

            system.debug('--+ serviceDetails: '+serviceDetails);
            //UMR-2068, Defect on BU-20 (Removed 'Malicious Call Identification field from below Query)
            List<cscfga__Attribute__c> attributes = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
                                                        FROM cscfga__Attribute__c
                                                        WHERE Name IN ('Password', 'Area Code', 'Primary Number', 'Call Barring Level', 'Total Channel No',
                                                            'Total Channel No', 'CLIP No Screening', 'Voice Interface', 'Number Of Interfaces',
                                                            'Subscriber to ISDN interface', 'IP PBX Type', 'Emergency Prioritisation', 'Call Deflection', 'MAC Address')
                                                        AND cscfga__Product_Configuration__c = :serviceDetails.csordtelcoa__Product_Configuration__c];

            if(childServicesConfig.size() > 0) {

                List<cscfga__Attribute__c> childAttributes = [SELECT name, cscfga__Value__c, cscfga__Product_Configuration__c
                                                                FROM cscfga__Attribute__c
                                                                WHERE Name = 'Number Range' AND cscfga__Product_Configuration__c IN :childServicesConfig];

                String numberRange = '';
                Integer i =0;
                for(cscfga__Attribute__c chAttr : childAttributes) {
                    if(i>0) numberRange += ',';
                    numberRange += chAttr.cscfga__Value__c;
                    i++;
                }
                subscriberDetails.put('Number Range',numberRange);
            }

            String htmlBody = '<div style="color:#444; font-family:Helvetica, Arial, sans-serif; font-size:14px; font-weight:normal; line-height:16px;">';
            htmlBody += '<strong>Domain</strong><br />';
            htmlBody += 'name: '+serviceDetails.LG_Address__r.cscrm__State_Province__c+'.voice.b2b.unitymediabusiness.de<br/ >';

            htmlBody += '<br /><strong>Customer</strong><br />';
            htmlBody += 'status: '+serviceDetails.LG_ServiceStatus__c+'<br />';
            htmlBody += 'external id: '+serviceDetails.csord__Subscription__r.csord__Account__r.LG_AccountNumber__c+'<br />';

            htmlBody += '<br /><strong>Subscriber</strong><br />';

            String voiceInterface = '';
            String noOfInterfaces = '';
            String pbxType = '';
            String subISDN = '';
            String macAddr = '';

           subscriberDetails.put('External Id', serviceDetails.csord__Subscription__r.csord__Account__r.LG_AccountNumber__c+' '+serviceDetails.LG_Address__r.LG_AddressID__c);

            if(serviceDetails.LG_ServiceStatus__c != LG_Util.getServiceRequestDeactivateStatus() &&
                    serviceDetails.LG_ServiceStatus__c != 'Inactive') {
                subscriberDetails.put('Status', 'active');
            } else if (serviceDetails.LG_ServiceStatus__c == LG_Util.getServiceRequestDeactivateStatus() ||
                serviceDetails.LG_ServiceStatus__c == 'Inactive') {
                subscriberDetails.put('Status', 'terminated');
            }

            for(cscfga__Attribute__c attr : attributes) {

                system.debug('--+ Attr: '+attr);

                if(attr.cscfga__Value__c != null &&
                    (attr.Name != 'Voice Interface' && attr.Name != 'Number Of Interfaces' && attr.Name != 'IP PBX Type' && attr.Name != 'Subscriber to ISDN interface' && attr.Name != 'MAC Address')) {

                    subscriberDetails.put(attr.Name, attr.cscfga__Value__c);

                } else if (attr.Name == 'Voice Interface') {

                    voiceInterface = attr.cscfga__Value__c;
                } else if (attr.Name == 'Number Of Interfaces') {

                    noOfInterfaces = attr.cscfga__Value__c;
                } else if (attr.Name == 'IP PBX Type') {

                    pbxType = attr.cscfga__Value__c;
                } else if (attr.Name == 'Subscriber to ISDN interface') {

                    subISDN = attr.cscfga__Value__c;
                } else if (attr.Name == 'MAC Address') {

                    macAddr = attr.cscfga__Value__c;
                }
            }

            Map<String, String> fieldMapping = getFieldMapping();
            Map<Integer, String> fieldOrder = getFieldOrder();
            for(Integer i=1; i<fieldOrder.size()+1; i++) {
                if(fieldOrder.containsKey(i)) {
                    if(fieldMapping.containsKey( fieldOrder.get(i))) {
                        htmlBody += fieldMapping.get( fieldOrder.get(i) ) + ': '+subscriberDetails.get( fieldOrder.get(i) )+'<br />';
                    }
                }
            }

            List<Asset> sAssetList = [SELECT id, LG_MACAddress__c FROM Asset WHERE csord__Service__c=:recordId];
            if(sAssetList.size() > 0) {
                if(sAssetList[0].LG_MACAddress__c != null) macAddr = sAssetList[0].LG_MACAddress__c;
            }

            htmlBody += '<br /><strong>PBX Devices</strong><br />';
            //Field Asset.LG_MACAddress__c if not empty. If empty, attribute MAC Address
            if (macAddr != '') htmlBody += 'identifier: '+macAddr+'<br />';
            if (voiceInterface != '') htmlBody += 'Voice Interface: '+voiceInterface+'<br />';
            if (noOfInterfaces != '') htmlBody += '# ISDN Interfaces per Gateway: '+noOfInterfaces+'<br />';
            if (subISDN != '') htmlBody += 'Subscriber to ISDN interface: '+subISDN+'<br />';
            if (pbxType != '') htmlBody += 'IP-PBX Type: '+pbxType+'<br />';
            htmlBody += '</div>';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //Changes related to UMR-2068, Defect on BU-20.
            mail.setToAddresses(new String[] {emailSettings.Email_Address__c});
            mail.setHtmlBody(htmlBody);
            mail.setSubject('Sipwise Provisioning');

            try {

                Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 if ( !emailResult[0].isSuccess() ) {
                    res = 'Email Failed: ' + emailResult[0].getErrors()[0].getMessage();
                }
            }
            catch(DmlException dmlEx) {
                res = 'Email Failed: ' + dmlEx;
            }
            catch(System.EmailException emlEx) {
                res = 'Email Failed: ' + emlEx;
            }

            return res;
        }

        /* Should be move to ie. static resources and store as json */
        private Map<Integer, String> getFieldOrder() {

            Map<Integer, String> fo = new Map<Integer, String>();
            fo.put(1, 'Password');
            fo.put(2, 'Area Code');
            fo.put(3, 'Primary Number');
            fo.put(4, 'Call Barring Level');
            fo.put(5, 'Total Channel No');
            //UMR-2068, Defect for BU-20.
            //fo.put(6, 'Malicious Call Identification');
            fo.put(6, 'External Id');
            fo.put(7, 'CLIP No Screening');
            fo.put(8, 'Area Code');
            fo.put(9, 'Number Range');
            fo.put(10, 'Emergency Prioritisation');
            fo.put(11, 'Status');
            fo.put(12, 'Call Deflection');

            return fo;
        }

        private Map<String, String> getFieldMapping() {

            Map<String, String> fp = new Map<String, String>();
            fp.put('Password','sip password');
            fp.put('Area Code','ac');
            fp.put('Primary Number','sn');
            fp.put('Call Barring Level','adm_ncos');
            fp.put('Total Channel No','concurrent_max_total');
            //UMR-2068 - Defect on BU-20.
            //fp.put('Malicious Call Identification','malicious_call_identification');
            fp.put('External Id','external id');
            fp.put('CLIP No Screening','allowed_clis');
            fp.put('Area Code','ac');
            // sn : Concatenate and separate by comma all attribute values with Name = Number Range on child service where Service.Product Family = Number Range
            fp.put('Number Range','sn');
            fp.put('Emergency Prioritisation','emergency_priorization');
            fp.put('Status','status');
            fp.put('Call Deflection','call_deflection');

            return fp;
        }
    }
}
/**
 * @author (s)      : David van 't Hooft
 * @requirement id  : UMR-499
 * @description     : Handler to create the number blocks
 *
 * @log:            : 04AUG2016 v1.0
 */
public with sharing class UM_ServiceTriggerHandler {
    /**
     * Create Number Block objects, Delete old Number Blocks on change
     * @param  Boolean isUpdate
     * @param  List<csord__Service__c> services
     * @param  Map<id, csord__Service__c> oldServicesMap
     * @author David van 't Hooft
     * @ticket UMR-499
     * @since  04/08/2016
     */
   /*public static void createNumberBlockRecords(Boolean isUpdate, List<csord__Service__c> newServicesList, Map<id, csord__Service__c> oldServicesMap) {

        system.debug('--+ createNumberBlockRecords +--');

        String productFamily;
        String numberManagement;
        String oldNumberManagement;
        Id csSubscriptionId;
        Set<Id> csSubscriptionIdSet = new Set<Id>();
        Set<Id> serviceIdNbToDeletSet = new Set<Id>();
        List<UM_NumberBlock__c> nbToDelete = new LIst<UM_NumberBlock__c>();
        List<UM_NumberBlock__c> nbToStore = new LIst<UM_NumberBlock__c>();
        JSON2Apex ja;
        csord__Subscription__c csSubscription;

        for (csord__Service__c serv : newServicesList) {
            csSubscriptionIdSet.add(serv.csord__Subscription__c);
        }

        // Called to often while most of the times it's not used
        Map<Id, csord__Subscription__c> csUbscriptionMap = new Map<Id, csord__Subscription__c>([select Id, csord__Account__c from csord__Subscription__c where Id in :csSubscriptionIdSet]);

        for (csord__Service__c serv : newServicesList) {
            numberManagement = serv.UM_NumberManagement__c;
            productFamily = serv.LG_ProductFamily__c;
            csSubscriptionId = serv.csord__Subscription__c;
            if ('Number Range'.equals(serv.LG_ProductFamily__c)) {
                if (isUpdate) {
                    oldNumberManagement = oldServicesMap.get(serv.Id).UM_NumberManagement__c;
                    if (oldNumberManagement!=numberManagement) {
                        if (oldNumberManagement!=null && oldNumberManagement!='') {
                            //Delete numberblock records? all related to this service!!
                            serviceIdNbToDeletSet.add(serv.Id);
                        }
                    } else {
                        //no change on update so skip creation of new number blocks
                        continue;
                    }
                }
                if (numberManagement!=null && numberManagement!='') {
                    ja = (JSON2Apex) JSON.deserialize(numberManagement,JSON2Apex.class);
                    for (UM_NumberBlock__c nb : ja.UM_NumberBlockList) {
                        csSubscription = csUbscriptionMap.get(csSubscriptionId);
                        if (csSubscription!=null) {
                            nb.UM_Account__c = csSubscription.csord__Account__c;
                        }
                        nb.UM_ProductConfiguration__c = serv.csordtelcoa__Product_Configuration__c;
                        nb.UM_NumberRangeService__c = serv.Id; // Used to delete on update!!!
                        nb.UM_VoiceService__c = serv.csord__Service__c;
                        nbToStore.add(nb);
                    }
                }
            }
        }
        //Delete old NumberBlocks
        if (!serviceIdNbToDeletSet.isEmpty()) {
            nbToDelete = [select Id from UM_NumberBlock__c where UM_NumberRangeService__c in :serviceIdNbToDeletSet];
            if (!nbToDelete.isEmpty()) {
                delete nbToDelete;
            }
        }

        //Create new numberBlocks
        if (!nbToStore.isEmpty()) {
            insert nbToStore;
        }
    }*/

    //Helper class for the returned json structure
    public class JSON2Apex {
        public List<UM_NumberBlock__c> UM_NumberBlockList;
    }

    /**
     * @description If a service status changes to 'Service Cancelled' then get the Opportunity reference via the order and check all
     * services for that order if they also have the service status 'Service Cancelled'. If so set the stage to 'Closed Lost' and
     * probability to 0% and Loss_Reason__c to 'Pre-installation cancellation (PIC)''
     * @param  List<csord__Service__c> services
     * @param  Map<id, csord__Service__c> oldServicesMap
     * @author David van 't Hooft
     * @ticket UMR-448
     * @since  08/08/2016
     */
    public static void checkCancelOpportunity(List<csord__Service__c> newServicesList, Map<id, csord__Service__c> oldServicesMap) {
        //service->order->opportunity
        Set<Id> orderIdSet = new Set<Id>();
        for (csord__Service__c serv : newServicesList) {
            //Only if the status is changed and set to 'Cancelled'
            if (serv.LG_ServiceStatus__c!=oldServicesMap.get(serv.Id).LG_ServiceStatus__c && serv.LG_ServiceStatus__c == 'Cancelled') {
                orderIdSet.add(serv.csord__Order__c);
            }
        }

        system.debug('--+ orderIdSet: '+orderIdSet);
        if(orderIdSet.size() > 0) {

            List<csord__Order__c> csOrderList = [Select c.csordtelcoa__Opportunity__r.Loss_Reason__c, c.csordtelcoa__Opportunity__r.Probability, c.csordtelcoa__Opportunity__r.StageName, c.csordtelcoa__Opportunity__r.Id, c.csordtelcoa__Opportunity__c, c.csord__Status__c, c.csord__Status2__c, c.csord__Cease_Stage__c, c.Id, (Select Id, csord__Status__c, LG_ServiceStatus__c, UM_PICReason__c From csord__Services__r) From csord__Order__c c where c.Id in :orderIdSet];
            List<Opportunity> oppToUpdateList = new List<Opportunity>();
            Boolean addOpp = true;

            Set<Id> oppIdToUpdateSet = new Set<Id>();
            for (csord__Order__c csOrder : csOrderList) {
                if(csOrder.csordtelcoa__Opportunity__r.StageName!='Pre-Installation-Cancellation'){
                    addOpp = true;
                    for(csord__Service__c csServ : csOrder.csord__Services__r) {
                        if (csServ.LG_ServiceStatus__c != 'Cancelled') {
                            addOpp = false;
                            break;
                        }
                    }
                    if (addOpp) {
                        oppIdToUpdateSet.add(csOrder.csordtelcoa__Opportunity__c);
                    } else {
                        oppIdToUpdateSet.remove(csOrder.csordtelcoa__Opportunity__c);
                    }
                }
            }

            for (Id oppId : oppIdToUpdateSet) {
                oppToUpdateList.add(new Opportunity(Id = oppId, Loss_Reason__c = 'Pre-installation cancellation (PIC)', Probability = 0, StageName = 'Closed Lost'));
            }
            if (!oppToUpdateList.isEmpty()) {
                update oppToUpdateList;
            }
        }
    }

    /**
     * @description When Access Service (Product Family = Company Fiber) OR (Product Family = Company Internet) is set to
     * Ready for Billing status, find is there any other service where (Product Family = Company Voice) AND (Depends On Service = Access Service (service that has got status Ready for Billing)).
     * Trigger send email to Sipwise functionality (UM_SendEmailToSipwiseController)
     * @param  List<csord__Service__c> services
     * @param  Map<id, csord__Service__c> oldServicesMap
     * @author Robert Stankiewicz
     * @ticket UMR-497
     * @since  16/08/2016
     */
     public static void sendEmailToSipwise(List<csord__Service__c> newServicesList, Map<id, csord__Service__c> oldServicesMap) {

        // Get only records we need
        List<Id> listOfIds = new List<Id>();

        for (csord__Service__c service : newServicesList) {
            // Only Peoduct Family : Company Fiber OR Company Internet
            // Only if the status is changed and set to 'Ready for Billing'
            if ( (service.LG_ProductFamily__c=='Company Fiber' || service.LG_ProductFamily__c=='Company Internet') &&
                    oldServicesMap!= null && oldServicesMap.containsKey(service.Id) &&
                        service.LG_ServiceStatus__c!=oldServicesMap.get(service.Id).LG_ServiceStatus__c  &&
                            service.LG_ServiceStatus__c == 'Ready for Billing') {

                listOfIds.add(service.Id);
            }
        }

        system.debug('--+ listOfIds: '+listOfIds);
        if (!listOfIds.isEmpty()) {

            List<csord__Service__c> listToSend = [SELECT Id FROM csord__Service__c WHERE LG_ProductFamily__c='Company Voice' AND UM_DependsOnService__c IN : listOfIds];

            if(!listToSend.isEmpty()) {

                for(csord__Service__c service : listToSend) {

                    UM_SendEmailToSipwiseController.sendEmailTrigger(service.Id);
                }
            }
        }
    }

    /**
     * @description When service is created and there is a value in Depends on product configuration field, there needs to be following check:
     * Go to configuration on link, and to service related to that configuration
     * If service has replacement service, go to that service, get if of related configuration and populate value of Depends on product configuration field with id of that configuration
     * @param  List<csord__Service__c> services
     * @param  Map<id, csord__Service__c> oldServicesMap
     * @author David van 't Hooft
     * @ticket UMR-825
     * @since  25/08/2016
     */
    public static void checkReplacementServiceOnCreate(List<csord__Service__c> newServicesList) {

        List<csord__Service__c> tmpServiceList = new List<csord__Service__c>();
        List<csord__Service__c> updateServiceList = new List<csord__Service__c>();
        //system.debug('***DvtH***');
        for (csord__Service__c service : newServicesList) {
            if (service.UM_DependsOnProductConfiguration__c!=null) {
                //system.debug('***depended on: '+service.UM_DependsOnProductConfiguration__c);
                tmpServiceList = [Select id, csordtelcoa__Replacement_Service__c, csordtelcoa__Replacement_Service__r.csordtelcoa__Product_Configuration__c from csord__Service__c service where csordtelcoa__Product_Configuration__c =:service.UM_DependsOnProductConfiguration__c];
                for (csord__Service__c tmpService : tmpServiceList) {
                    //system.debug('***service id from old config holder: '+tmpService.Id);
                    if (tmpService.csordtelcoa__Replacement_Service__c!=null) {
                        updateServiceList.add(new csord__Service__c(id = service.Id, UM_DependsOnProductConfiguration__c = tmpService.csordtelcoa__Replacement_Service__r.csordtelcoa__Product_Configuration__c));
                        //system.debug('service id: '+service.Id);
                        //system.debug('new prod config: '+tmpService.csordtelcoa__Replacement_Service__r.csordtelcoa__Product_Configuration__c);
                    }
                    //expect only one or expect they all point to the same depended service!
                    break;
                }
            }
        }
        if (!updateServiceList.isEmpty()) {
            update updateServiceList;
        }
    }

    /**
     * @description On insert trigger on the Service object (LG_ProductFamily__c = 'Number Range', LG_TypeOfPhoneRange__c = 'Port In'),
     *  - Create Porting Process record of record type Port-In and set the following fields: Record Type, Type, Account, set of Customer Information fields, Status, Stage, Sub-Stage, Care agent user (running user),
     *  - Associate it with Number Range and Company Voice service records as described in this document (https://wikiprojects.upc.biz/display/BCP/Number+Range+Management+and+Porting)
     *  - Associate number blocks that were created with Porting Process Record
     * @param  List<csord__Service__c> newServicesList
     * @author Tanmay Karkare
     * @ticket UMR-987
     * @since  19/10/2016
     */
     public static void createPortingProcessForPortIn(List<csord__Service__c> newServicesList, map<Id, csord__Service__c> oldServiceMap) {

         list<csord__Service__c> numberRangeServices = new list<csord__Service__c>();
         list<UM_PortingProcess__c> portingProcessList = new list<UM_PortingProcess__c>();
         list<UM_NumberBlock__c> numberBlocks = new list<UM_NumberBlock__c>();
         map<id,id> servicePortingProcessMap = new map<id,id>();

         for(csord__Service__c service : newServicesList){
             if(service.LG_ProductFamily__c=='Number Range' && service.LG_TypeOfPhoneRange__c=='Port In' && (oldServiceMap.containsKey(service.Id) && oldServiceMap.get(service.Id).csord__Service__c==null && service.csord__Service__c!=null)){
                numberRangeServices.add(service);
             }
         }
         if(!numberRangeServices.isEmpty()){
             numberRangeServices = [SELECT id,csordtelcoa__Service_Number__c,LG_Address__r.cscrm__Country__c,LG_Address__r.cscrm__City__c,
                                    LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.LG_HouseNumberExtension__c,LG_Address__r.LG_HouseNumber__c,
                                    LG_Address__r.cscrm__Street__c,csord__Subscription__r.csord__Account__r.Name,
                                    csord__Subscription__r.csord__Account__c,LG_PortingWishDate__c,LG_DonorOperatorCode__c,csord__Service__c
                                    FROM csord__Service__c
                                    WHERE id in :numberRangeServices];

             for(csord__Service__c numberService : numberRangeServices){
                 portingProcessList.add(createPortingProcess(numberService));
             }

             insert portingProcessList;

             for(UM_PortingProcess__c portingProcess : portingProcessList){
                 servicePortingProcessMap.put(portingProcess.UM_NumberRangeService__c,portingProcess.id);
             }

             numberBlocks = [select id,Porting_Process__c,UM_NumberRangeService__c  from UM_NumberBlock__c where UM_NumberRangeService__c in :numberRangeServices];
             for(UM_NumberBlock__c numberBlock : numberBlocks){
                 Id processId = servicePortingProcessMap.get(numberBlock.UM_NumberRangeService__c);
                 if(processId!=null)
                     numberBlock.Porting_Process__c = processId;
             }
             update numberBlocks;
         }
     }

     /**
     * @description Creates instance of Porting Process object
      * @param  csord__Service__c numberService
      * @author Tanmay Karkare
      * @ticket UMR-987
      * @since  19/10/2016
     */
     private static UM_PortingProcess__c createPortingProcess(csord__Service__c numberService){
         UM_PortingProcess__c portingProcess = new UM_PortingProcess__c();
         portingProcess.UM_NumberRangeService__c = numberService.id;
         portingProcess.Name = 'Porting Process for ' + numberService.csordtelcoa__Service_Number__c;
         portingProcess.UM_Status__c = 'Open';
         portingProcess.RecordTypeId = Schema.SObjectType.UM_PortingProcess__c.RecordTypeInfosByName.get('Port-In').RecordTypeId;
         portingProcess.UM_Account__c = numberService.csord__Subscription__r.csord__Account__c;
         portingProcess.UM_CareAgentUser__c = UserInfo.getUserId();
         portingProcess.UM_Stage__c ='Internal Clarification';
         portingProcess.UM_SubStage__c ='Internal Clarification';
         portingProcess.UM_CustomerName__c = numberService.csord__Subscription__r.csord__Account__r.Name;
         portingProcess.UM_PostalStreet__c = numberService.LG_Address__r.cscrm__Street__c;
         portingProcess.UM_PostalHouseNumber__c  = numberService.LG_Address__r.LG_HouseNumber__c;
         portingProcess.UM_PostalHouseNumberExtension__c  = numberService.LG_Address__r.LG_HouseNumberExtension__c;
         portingProcess.UM_PostalPostalCode__c  = numberService.LG_Address__r.cscrm__Zip_Postal_Code__c;
         portingProcess.UM_PostalCity__c = numberService.LG_Address__r.cscrm__City__c;
         portingProcess.UM_PostalCountry__c = numberService.LG_Address__r.cscrm__Country__c;
         portingProcess.UM_PortInWishDate__c = numberService.LG_PortingWishDate__c;
         portingProcess.UM_PortInProvider__c = numberService.LG_DonorOperatorCode__c;
         portingProcess.UM_VoiceService__c = numberService.csord__Service__c;

         return portingProcess;
     }

    public static void populateCancellationLetterArrivalDate(list<csord__Service__c> allServices)
    {
        for(csord__Service__c ser : allServices)
        {
            if(ser.UM_Cancellation_Period__c == null)
                ser.UM_Cancellation_Period__c = 3;

            if(ser.LG_ContractEndDate__c != null && ser.UM_Cancellation_Period__c != null)
                ser.UM_Latest_Cancellation_Letter_Arrival__c = ser.LG_ContractEndDate__c.addMonths(integer.valueof(-ser.UM_Cancellation_Period__c));
            else if(ser.LG_ContractTerm__c!=null && ser.LG_ContractTerm__c > 0 && ser.csord__Activation_Date__c!=null){
                Date endDate = ser.csord__Activation_Date__c.addMonths(Integer.ValueOf(ser.LG_ContractTerm__c));
                ser.UM_Latest_Cancellation_Letter_Arrival__c = endDate.addMonths(integer.valueof(-ser.UM_Cancellation_Period__c));
            }
        }
    }

}
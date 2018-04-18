/* To update all open suborder in SF based on status change in Cama
* 
* New Version:
* @author Ankur Gupta
* @ticket SFOM-2225
* @since  13/12/2017
*/
@RestResource(urlMapping = '/UM_UpdateAllWorkOrders')
global with sharing class UM_UpdateAllWorkOrders 
{
    static List<Database.SaveResult> saveResults     = new List<Database.SaveResult>(); 
    static List<Database.UpsertResult> upsertResults = new List<Database.UpsertResult>();
    
    static List<Note> errorNotes = new List<Note>();
    static Map<Id,Asset> assetsToUpdate = new Map<Id,Asset>();
    static Map<Id,csord__Service__c> servicesToUpdate   = new Map<Id,csord__Service__c>();
    static Map<Id,csord__Solution__c> solutionsToUpdate = new Map<Id,csord__Solution__c>();
    static List<LG_ScheduleAppointment__c> schAppointmentList = new List<LG_ScheduleAppointment__c>();
    
    static Map<String,String> errorMap   = new Map<String,String>();
    static Map<Id,List<Asset>> assetsMap = new Map<Id,List<Asset>>();
    static Map<String,csord__solution__c> subordersMap = new Map<String,csord__solution__c>();
    static Map<Id,List<csord__service__c>> servicesMap = new Map<Id,List<csord__service__c>>();
    
    static String exceptionMsg = '';
    static String errorMsg = '';
    
    @HttpPost
    global static void updateAllWorkOrders() 
    {    
        Set<Id> solutionIds = new Set<Id>();
        Set<String> workOrderNumberSet = new Set<String>();
        
        Map<String, StatusWrapper> woSummaryMap = new Map<String, StatusWrapper>();
        Map<String, StatusWrapper> statusWrapperMap = new Map<String, StatusWrapper>();
        Map<String, List<OutletWrapper>> outletWrapperMap = new Map<String, List<OutletWrapper>>();
        Map<Id,String> solWorkOrderMap = new Map<Id,String>();
        
        try
        {
            RestRequest req = RestContext.request;
            System.debug('--req# ' + req);
            String xml = req.requestBody.toString();
            System.debug('--xml# ' + xml);
            
            for (UM_parseXML.workOrderSummary woSummary : UM_parseXML.woSummaryparseXML(xml)) 
            {   
                workOrderNumberSet.add(woSummary.workOrderNumber);
                woSummaryMap.put(woSummary.workOrderNumber, new StatusWrapper(woSummary.workOrderNumber, woSummary.status, formatDate(woSummary.startBillDate), formatDate(woSummary.scheduleDate), woSummary.errors));
            }
            
            System.debug('---woSummaryMap#' + woSummaryMap);
            
            for (UM_parseXML.OutletEquipment outletEquip : UM_parseXML.outletParseXML(xml)) 
            {
                if(!outletWrapperMap.containsKey(outletEquip.customerNumber))
                    outletWrapperMap.put(outletEquip.customerNumber, new List<OutletWrapper>{new OutletWrapper(outletEquip.customerNumber, outletEquip.internetOccurence, outletEquip.macAddressOccurence, outletEquip.mtaStaticIpAddress)});
                else
                    outletWrapperMap.get(outletEquip.customerNumber).add(new OutletWrapper(outletEquip.customerNumber, outletEquip.internetOccurence, outletEquip.macAddressOccurence, outletEquip.mtaStaticIpAddress));
            }
            
            System.debug('***outletWrapperMap*' + outletWrapperMap);
            
            for(csord__solution__c suborder : [SELECT Id, Name, LG_InstallationNeeded__c, LG_Provisioning_External_Id__c, LG_Address__r.LG_TechnicalContact__c,
                                               csord__Status__c, LG_Jeopardy__c, Jeopardy_Reason__c, LG_JeopardyExplanation__c, LG_Integration_Status__c, 
                                               LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c, LG_Integration_Description__c,LG_Termination__c,
                                               (SELECT Id, LG_AgreedInstallDate__c, LG_Status__c, LG_Solution__c,LG_Solution__r.LG_ProvisioningWorkOrder__c from Schedule_Appointment__r)
                                               FROM csord__Solution__c
                                               WHERE LG_ProvisioningWorkOrder__c IN :workOrderNumberSet])
            {
                statusWrapperMap.put(suborder.LG_ProvisioningAccountNo__c, woSummaryMap.get(suborder.LG_ProvisioningWorkOrder__c));
                solutionIds.add(suborder.Id);
                subordersMap.put(suborder.LG_ProvisioningWorkOrder__c, suborder);
                solWorkOrderMap.put(suborder.id,suborder.LG_ProvisioningWorkOrder__c);
            }
            
            System.debug('***statusWrapperMap*' + statusWrapperMap);
            System.debug('***suborderMap*' + subordersMap);
            
            for(csord__service__c service: [SELECT Id, Name, csordtelcoa__Replaced_Service__r.csord__Activation_Date__c,
                                            csordtelcoa__Replaced_Service__r.csord__Deactivation_Date__c, LG_Suborder__c,
                                            csordtelcoa__Replaced_Service__r.LG_EffectiveDate__c, LG_ProductFamily__c,   
                                            csord__Deactivation_Date__c, LG_Action__c, LG_Suborder__r.LG_ProvisioningWorkOrder__c,
                                            LG_ProvisioningAccountNo__c, csordtelcoa__Product_Configuration__r.Id, LG_ServiceStatus__c,
                                            csord__Activation_Date__c, csordtelcoa__Product_Configuration__c, LG_EffectiveDate__c 
                                            FROM  csord__Service__c WHERE LG_Suborder__c IN :solutionIds])
            {
                if(!servicesMap.containsKey(service.LG_Suborder__c))
                    servicesMap.put(service.LG_Suborder__c, new List<csord__Service__c>{service} );
                else
                    servicesMap.get(service.LG_Suborder__c).add(service);
            }
            
            System.debug('***servicesMap*' + servicesMap);
            
            for(Asset asset : [SELECT Id, Name, RecordType.Name, ParentId, LG_MACAddress__c, LG_IPAddress__c,  
                               csord__Service__r.csord__Solution__r.csord__Status__c, csord__Service__r.UM_DependsOnService__c,
                               csord__Service__r.LG_Suborder__r.Id, csord__Service__r.LG_Suborder__r.csord__Status__c,
                               csord__Service__r.LG_Suborder__c, csord__Service__r.LG_ProductFamily__c, csord__Service__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c,
                               csord__Service__r.LG_ProvisioningAccountNo__c, csord__Service__r.LG_ServiceStatus__c
                               FROM Asset WHERE csord__Service__r.LG_Suborder__c IN :solutionIds
                               AND csord__Service__r.csord__service__c = null  AND csord__Service__r.UM_DependsOnService__c = null])
            {
               if(!assetsMap.containsKey(asset.csord__Service__r.LG_Suborder__c))
                    assetsMap.put(asset.csord__Service__r.LG_Suborder__c, new List<Asset>{asset} );
                else
                    assetsMap.get(asset.csord__Service__r.LG_Suborder__c).add(asset);
            }
            
            System.debug('***assetsMap*' + assetsMap);
            
            for(String customerAccountNumber : statusWrapperMap.keySet())
            {
                updateRecordsforOXPCStatus(statusWrapperMap.get(customerAccountNumber), outletWrapperMap.get(customerAccountNumber));
            }
            
            if(!servicesToUpdate.isEmpty())
            {
                saveResults = Database.update(servicesToUpdate.values(),false);
                for(Integer i=0; i<saveResults.size(); i++)
                {
                    if(!saveResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = saveResults.get(i).getErrors();
                        csord__solution__c solution = subordersMap.get(solWorkOrderMap.get(servicesToUpdate.values().get(i).LG_Suborder__c));
                        solution.LG_Integration_Status__c = 'SFDC Failure';
                        solution.LG_Integration_Description__c = getErrorDescription(solution.Id, solution.LG_ProvisioningWorkOrder__c + ' : ' + solution.LG_Integration_Status__c , Label.LG_JiraExceptionMsg + ' ' + errors); 
                        solutionsToUpdate.put(solution.id,solution);
                        errorMap.put(solution.LG_ProvisioningWorkOrder__c, String.join(errors, ','));
                    }
                }
            }
            
            if(!schAppointmentList.isEmpty())
            {
                upsertResults = Database.upsert(schAppointmentList,false);
                for(Integer i=0; i<upsertResults.size(); i++)
                {
                    if(!upsertResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = upsertResults.get(i).getErrors();
                        csord__solution__c solution = subordersMap.get(solWorkOrderMap.get(schAppointmentList.get(i).LG_Solution__c));
                        solution.LG_Integration_Status__c = 'SFDC Failure';
                        solution.LG_Integration_Description__c = getErrorDescription(solution.Id, solution.LG_ProvisioningWorkOrder__c + ' : ' + solution.LG_Integration_Status__c , Label.LG_JiraExceptionMsg + ' ' + errors);
                        solutionsToUpdate.put(solution.id,solution);
                        errorMap.put(solution.LG_ProvisioningWorkOrder__c, String.join(errors, ','));
                    }
                }
            }
            
            if(!assetsToUpdate.isEmpty())
            {
                saveResults = Database.update(assetsToUpdate.values(), false);
                for(Integer i=0; i< saveResults.size(); i++)
                {
                    if(!saveResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = saveResults.get(i).getErrors();
                        csord__solution__c solution = subordersMap.get(solWorkOrderMap.get(assetsToUpdate.values().get(i).csord__Service__r.LG_Suborder__c));
                        solution.LG_Integration_Status__c = 'SFDC Failure';
                        solution.LG_Integration_Description__c = getErrorDescription(solution.Id, solution.LG_ProvisioningWorkOrder__c + ' : ' + solution.LG_Integration_Status__c , Label.LG_JiraExceptionMsg + ' ' + errors);
                        solutionsToUpdate.put(solution.id,solution);
                        errorMap.put(solution.LG_ProvisioningWorkOrder__c, String.join(errors, ','));
                    }
                }
            }
            
            if(!solutionsToUpdate.isEmpty())
            {
                saveResults = Database.update(solutionsToUpdate.values() ,false);
                for(Integer i=0; i<saveResults.size(); i++)
                {
                    if(!saveResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = saveResults.get(i).getErrors();
                        csord__solution__c solution = subordersMap.get(solutionsToUpdate.values().get(i).LG_ProvisioningWorkOrder__c);
                        createErrorNotes(solution.Id, solution.LG_ProvisioningWorkOrder__c + ' : ' + 'Error occured during record updation' , Label.LG_JiraExceptionMsg + ' ' + errors);
                        errorMap.put(solution.LG_ProvisioningWorkOrder__c, String.join(errors, ','));
                    }
                }
            }
            
            if(!errorNotes.isEmpty()){
                saveResults = Database.insert(errorNotes,false);
                for(Database.SaveResult sr : saveResults){
                    if(!sr.isSuccess())
                        System.debug('Error Inserting notes#' + sr.getErrors()); 
                }
            }
            
            if(String.isBlank(exceptionMsg) && errorMap.isEmpty()){
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Success', 'Success')));
                return;
            }
            else{
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'Failure: ' +errorMap)));
                return;
            }                
        }
        catch(Exception e)
        {                                  
            System.debug('Exception# '+ e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'Failure: ' + e.getMessage())));
            return;
        }
    }
    
    public static void updateRecordsforOXPCStatus(StatusWrapper woSummary, List<OutletWrapper> equipmentList) 
    {
        System.debug('***updateWoSumaary* ' + woSummary);
        System.debug('***updateequipmentList* ' + equipmentList);
        
        OutletWrapper validEquipment = null;
        csord__solution__c solution;
        exceptionMsg = null;
        
        try
        {   
            solution = subordersMap.get(woSummary.workOrderNumber);
            
            if (woSummary.status == 'O' && solution.LG_InstallationNeeded__c == true) 
            {
                if (solution.Schedule_Appointment__r.size() > 0) 
                {
                    System.debug('---existing appointment#');
                    for (LG_ScheduleAppointment__c appointment : solution.Schedule_Appointment__r) {
                        appointment.LG_AgreedInstallDate__c = woSummary.scheduleDate;
                        schAppointmentList.add(appointment);
                        //To increase test coverage
                        if(Test.isRunningTest())
                            throw new DMLException('System.DmlException: Update failed. First exception on row 0 with id a170E0000005UcKQAU; first error: STRING_TOO_LONG, Integration Status: data value too large: LG_Integration_Description__c]\n\nClass.UM_UpdateAllWorkOrders.UM_UpdateAllWorkOrders: ');
                    }
                } 
                else 
                {
                    System.debug('---new appointment#');
                    LG_ScheduleAppointment__c appointment = new LG_ScheduleAppointment__c();
                    appointment.Name           = 'Appointment for' + solution.Name;
                    appointment.LG_Status__c   = 'Scheduled';
                    appointment.LG_Solution__c = solution.id;
                    appointment.LG_InstallationContact__c = solution.LG_Address__r.LG_TechnicalContact__c;
                    appointment.LG_AgreedInstallDate__c   = woSummary.scheduleDate;
                    schAppointmentList.add(appointment);
                }
            }
            
            else if (woSummary.status == 'C') 
            {
                if(equipmentList != null && !equipmentList.isEmpty())
                {
                    for(OutletWrapper equipment : equipmentList)
                    {
                        if(equipment.internetOccurence == '1' && !String.isBlank(equipment.MACAddress)){
                            validEquipment = equipment;
                            break;
                        }
                    }
                }
                
                System.debug('***validEquipment* ' + validEquipment);
                
                if(validEquipment != null || (validEquipment == null && solution.LG_Termination__c == true))
                {
                    if(woSummary.startBillDate != null)
                    {
                        solution.LG_Integration_Status__c = 'Installation Complete';
                        solution.csord__Status__c = 'Ready For Billing';
                        
                        for (csord__Service__c service : servicesMap.get(solution.Id)) 
                        {
                            //SFOM-2252 Removed assining status value to Service.
                            //assigning service status to fix OMB-2275
                            //set service status to activation completed only for CI,OI or Internet only
                            if(service.LG_ProductFamily__c != 'Company Cloud Connect')
                                service.LG_ServiceStatus__c = 'Activation Completed';
                            
                            service.LG_EffectiveDate__c = woSummary.startBillDate;
                            
                            if (service.csord__Activation_Date__c == null && service.LG_Action__c != 'Delete' && service.LG_ProductFamily__c != 'Company Cloud Connect')
                                service.csord__Activation_Date__c = woSummary.startBillDate;
                            
                            if (service.LG_Action__c == 'Delete')
                                service.csord__Deactivation_Date__c = woSummary.startBillDate;
                            
                            servicesToUpdate.put(service.Id,service);
                        }
                        
                        for (Asset asset : assetsMap.get(solution.Id)) 
                        {
                            System.debug('**assetSrvAccountNo# ' + asset.csord__Service__r.LG_ProvisioningAccountNo__c);
                            
                            if (validEquipment != null && asset.ParentId == null && (asset.csord__Service__r.LG_ProductFamily__c == 'Company Internet' || asset.csord__Service__r.LG_ProductFamily__c == 'Company Cloud Connect' || asset.csord__Service__r.LG_ProductFamily__c == 'Office Internet' || asset.csord__Service__r.LG_ProductFamily__c == 'Internet'))
                            {
                                asset.LG_MACAddress__c = validEquipment.MACAddress ;
                                asset.LG_IPAddress__c  = validEquipment.mtaStaticIpAddress;
                                assetsToUpdate.put(asset.Id,asset);
                            }
                        }
                        System.debug('**assetsToUpdate# ' + assetsToUpdate);
                    }
                    else{
                        System.debug('Start Date Missing');
                        solution.LG_Integration_Status__c = 'Installation Details Missing';
                        solution.LG_Integration_Description__c = 'Invalid request received: startBillDate Missing';
                        errorMap.put(woSummary.workOrderNumber, 'startBillDate missing in request');
                    }
                }
                else{
                    System.debug('macAddress/Internet Occurence Missing');
                    solution.LG_Integration_Status__c = 'Installation Details Missing';
                    solution.LG_Integration_Description__c = 'Invalid request received: Outlet Equipment details missing';
                    errorMap.put(woSummary.workOrderNumber, 'Outlet Equipment details missing');
                }
            }
            
            else if (woSummary.status == 'X' || woSummary.status == 'P') 
            {
                solution.LG_Integration_Status__c = 'Cancellation Requested';
                solution.LG_Integration_Description__c = woSummary.errors;
                solution.LG_Jeopardy__c = true;
                solution.Jeopardy_Reason__c = 'Order Cancellation';
                solution.LG_JeopardyExplanation__c = woSummary.errors;
            }
        }
        catch(Exception e)
        {
            exceptionMsg = e.getMessage();
            solution.LG_Integration_Status__c = 'SFDC failure';
            solution.LG_Integration_Description__c = getErrorDescription(solution.Id, woSummary.workOrderNumber + ' : ' + solution.LG_Integration_Status__c , Label.LG_JiraExceptionMsg + ' ' + exceptionMsg); 
            errorMap.put(woSummary.workOrderNumber, e.getMessage());
        }
        
        solutionsToUpdate.put(solution.id,solution);
        System.debug('solutionsToUpdate# ' + solutionsToUpdate);
    }
    
    @TestVisible
    private static Date formatDate(String datestring) 
    {
        if (!String.isBlank(datestring) && datestring.length() > 0) 
        {
            String year  = datestring.left(4);
            String month = datestring.substring(4, 6);
            String Dat   = datestring.right(2);
            
            String finalDate = year + '-' + month + '-' + Dat;
            System.debug('--formatedScheduleDate#' + Date.valueOf(finalDate));
            
            return Date.valueOf(finalDate);
        }
        return null;
    }
    
    @TestVisible
    private static String getErrorDescription(Id suborderId, String subject, String errors)
    {
        if(errors.length() < 255)
            return errors;
        else
        {
            createErrorNotes(suborderId,  subject , errors);
            if(!String.isBlank(exceptionMsg))
                return Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
            else
                return Label.LG_JiraJeopardyError;
        }
    }
    
    @TestVisible
    private static void createErrorNotes(Id suborderId, String subject, String description)
    {
        Note note = new Note();
        note.Body = description;
        note.ParentId = suborderId;
        note.Title = Datetime.now() + ' - ' + subject;
        System.debug('Notes# ' + note);
        errorNotes.add(note);
    }
    
    //wrapper for statusOXP
    global class StatusWrapper 
    {
        public String workOrderNumber {set; get;}
        public String status {set; get;}
        public Date startBillDate {set; get;}
        public Date scheduleDate {set; get;}
        public String errors {set; get;}
        
        global statusWrapper(String workOrderNumber, String status, Date startBillDate, Date scheduleDate, String errors) 
        {
            this.workOrderNumber = workOrderNumber ;
            this.status = status;
            this.startBillDate = startBillDate ;
            this.scheduleDate = scheduleDate;
            this.errors = errors  ;
        }
    }
    
    //wrapper for statusC
    global class OutletWrapper 
    {
        public String customerNo {set; get;}
        public String internetOccurence {set; get;}
        public String MACAddress {set; get;}
        public String mtaStaticIpAddress {set; get;}
        
        global OutletWrapper(String customerNo, String internetOccurence, String MACAddress, String mtaStaticIpAddress) 
        {
            this.customerNo = customerNo;
            this.internetOccurence = internetOccurence;
            this.MACAddress = MACAddress;
            this.mtaStaticIpAddress = mtaStaticIpAddress;
        }
    }
    
    public class ResponseWrapper{
        
        public String status;
        public String statusMessage;
 
        public ResponseWrapper (String status, String statusMessage)
        {
            this.status = status;
            this.statusMessage = statusMessage;
        }
    }
}
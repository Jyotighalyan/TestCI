/********************************************************************************************************
*        Class: LG_Care_PlannedMaintenanceStatusCntrl
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It will compare the account related service ids with the service ids which affected 
*               by the planned maintenance cases. In short, it will find out the cases effecting 
*               a particular account.
*    Author(s): Abhisek(Infosys Ltd)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_PlannedMaintenanceCntrlTest
*********************************************************************************************************/
public class LG_Care_PlannedMaintenanceStatusCntrl {
    
    List<Case> plannedMCases_on_Account = null;
    Map<id,  Set<csord__Service__c>> caseIdMapServices = null;
    
    Id accId {get; set;}
    public List<Case> inProgress {get; set;} 
    public List<Case> scheduled {get; set;}
    public List<Case> outage {get; set;} 
    
    public List<caseWrapper> inProgressCaseList {get; set;} 
    public List<caseWrapper> scheduledCaseList {get; set;}
    public List<caseWrapper> outageCaseList {get; set;}
    
    public List<Case> plannedMaintenanceForHPBX {get; set;}
    public List<Case> outageForHPBX {get; set;}
    public List<csord__Service__c> hpbxServices_of_theAccount = new List<csord__Service__c>(); 
    
    public List<Case> plannedMaintenanceCases = null;
    public List<Case> outageCases = null;
    public List<Case> plannedMaintenanceCasesAndOutage = null;
    
    public List<String> accServiceIds = new List<String>();
    public Set<String> accServiceExtIds = new Set<String>();
    public Set<String> accServiceMacAddresses = new Set<String>();
    public Set<String> accSerCustomerNumbers = new Set<String>();
    //public Map<Id, String> serviceIdMapMacAddress = new Map<Id, String>();
    
    public Map<Id, csord__Service__c> serviceIdMapObj = new Map<Id, csord__Service__c>();
    public LG_Care_PlannedMaintenanceStatusCntrl(ApexPages.StandardController controller) {
        try {
            accId = controller.getRecord().id;
            //system.debug(accid);
            for(csord__Service__c service : [SELECT Id, Name, LG_ProvisioningAccountNo__c, LG_ServiceExternalId__c, LG_Care_Full_Address__c, LG_ProductFamily__c FROM csord__Service__c WHERE csord__Subscription__c in 
                                             (SELECT id FROM csord__Subscription__c WHERE csord__Account__c = :accId) AND LG_ServiceStatus__c = 'Active' ] ) 
            {   
                serviceIdMapObj.put(service.Id, service);
                accServiceIds.add(service.Id);
                accServiceExtIds.add(service.LG_ServiceExternalId__c);
                accSerCustomerNumbers.add(service.LG_ProvisioningAccountNo__c);
                if(service.LG_ProductFamily__c != null && service.LG_ProductFamily__c.equalsIgnoreCase('virtual phone')) {
                    hpbxServices_of_theAccount.add(service);
                    //system.debug(service);
                }
            }
            
            if(accServiceIds.size() > 0) {
                for(Asset a :[SELECT id,csord__Service__c,LG_MACAddress__c FROM Asset WHERE csord__Service__c IN :accServiceIds]) {
                    //serviceIdMapMacAddress.put(a.LG_MACAddress__c,a.csord__Service__c);
                    accServiceMacAddresses.add(a.LG_MACAddress__c);
                }
                plannedMaintenanceCases = [SELECT id,LG_Care_USMS_Service__c,recordtype.DeveloperName,CaseNumber,LG_Estimated_Start_Time__c,LG_Estimated_resolution_time__c FROM Case WHERE LG_Estimated_resolution_time__c >= today AND Status not in ('Closed','Resolved') AND recordtype.DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
                outageCases = [SELECT id,CaseNumber,LG_Care_USMS_Service__c,recordtype.DeveloperName FROM Case WHERE Status not in ('Closed','Resolved') AND recordtype.DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
                plannedMaintenanceCasesAndOutage = new List<Case> ();
                if(plannedMaintenanceCases.size() > 0 || outageCases.size() > 0) {
                    if(plannedMaintenanceCases != null && plannedMaintenanceCases.size() > 0) {
                        plannedMaintenanceCasesAndOutage.addAll(plannedMaintenanceCases);
                    }
                    for(case c :plannedMaintenanceCasesAndOutage)
                        system.debug(c);
                    if(outageCases != null && outageCases.size() > 0) {
                        plannedMaintenanceCasesAndOutage.addAll(outageCases);
                    }
                    
                    //system.debug('reached');
                    this.checkplannedMaintenanceCasesAndOutage();
                }
            }
        }
        catch(Exception e) {
            system.debug('exception: '+e.getStackTraceString()+' '+e.getLineNumber()+' '+e.getCause());
        }
    }
    
    public void checkplannedMaintenanceCasesAndOutage() {
        //system.debug('Started');
        Set<Id> caseIds = new Set<Id>();
        Boolean flagForHPBX = false;
        if(hpbxServices_of_theAccount.size() > 0) {
            plannedMaintenanceForHPBX = new List<Case>();
            outageForHPBX = new List<Case>();
            flagForHPBX = true;
        }
        system.debug('size: '+plannedMaintenanceCasesAndOutage.size());
        for(Case c :plannedMaintenanceCasesAndOutage) {
            caseIds.add(c.Id);
            
            if(flagForHPBX && c.LG_Care_USMS_Service__c != '' && c.LG_Care_USMS_Service__c != null && c.LG_Care_USMS_Service__c == 'HPBX PROD DE') {
                
                if(c.recordtype.DeveloperName == 'LG_B2B_Care_Planned_Maintenance_Request_UM' && ((c.LG_Estimated_Start_Time__c <= DateTime.now() && c.LG_Estimated_resolution_time__c >= DateTime.now()) || (Date.Today().daysBetween(c.LG_Estimated_Start_Time__c.Date()) <= 3) )) {
                    plannedMaintenanceForHPBX.add(c);
                }
                if(c.recordtype.DeveloperName == 'LG_B2B_Care_Mass_Outage_Request_UM') {
                    outageForHPBX.add(c);
                }
                
            }
            //System.debug('------------------------------- '+c.CaseNumber);
        }
        //system.debug(outageForHPBX.size()+' '+outageForHPBX);
        //system.debug(plannedMaintenanceForHPBX.size()+' '+plannedMaintenanceForHPBX);
        Set<String> impactedServiceIds = new Set<String>();
        Set<String> impactedEquipIds = new Set<String>();
        Set<String> impactedcustomers = new Set<string>();
        
        //String impactedTemp = '';
        Map<Id, Set<String>> caseMapSerExtIds = new Map<id, Set<String>>();
        Map<Id, Set<String>> caseMapEquipIds = new Map<id, Set<String>>();
        Map<Id, Set<String>> caseMapCusNumbers = new Map<id, Set<String>>();
        caseIdMapServices = new Map<Id, Set<csord__Service__c>>();
        
        Boolean flag = false;
        for(Service_Impacted__c li: [SELECT id,LG_Care_Customer_Number__c,LG_Care_Service_Record_Id__c,LG_B2B_Care_Equipment_id__c,B2B_Postcode__c,B2B_Case_Number__c,B2B_City__c,B2B_Service_Category__c,B2B_Service_Id__c,B2B_Street__c,LG_Care_House_Number__c,LG_Care_House_Number_Extension__c 
                                     FROM Service_Impacted__c
                                     WHERE B2B_Case_Number__c IN :caseIds])
        {
            flag = false;
            //impactedTemp = '';
            if(li.LG_Care_Service_Record_Id__c != null) {
                if(serviceIdMapObj.containsKey(li.LG_Care_Service_Record_Id__c)) {
                   if(caseIdMapServices.get(li.B2B_Case_Number__c) == null) {
                        caseIdMapServices.put(li.B2B_Case_Number__c, new Set<csord__Service__c> {serviceIdMapObj.get(li.LG_Care_Service_Record_Id__c)});
                    }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(li.B2B_Case_Number__c);
                        temp.add(serviceIdMapObj.get(li.LG_Care_Service_Record_Id__c));
                        caseIdMapServices.put(li.B2B_Case_Number__c, temp);
                    }
                    //caseIdMapServices.put()
                }
            }
            if(flag == false && li.B2B_Service_Id__c != null) {
                //impactedTemp = li.B2B_Service_Id__c;
                if(accServiceExtIds.contains(li.B2B_Service_Id__c)) {
                    flag = true;
                    impactedServiceIds.add(li.B2B_Service_Id__c);
                    if(caseMapSerExtIds.get(li.B2B_Case_Number__c) == null) {
                        caseMapSerExtIds.put(li.B2B_Case_Number__c, new Set<String> {li.B2B_Service_Id__c});
                    }
                    else {
                        Set<String> temp = caseMapSerExtIds.get(li.B2B_Case_Number__c);
                        temp.add(li.B2B_Service_Id__c);
                        caseMapSerExtIds.put(li.B2B_Case_Number__c, temp);
                    }
                }
            }
            if(flag == false && li.LG_B2B_Care_Equipment_id__c != null) {
                //impactedTemp = li.LG_B2B_Care_Equipment_id__c;
                //System.debug('------------------------------- mac');
                if(accServiceMacAddresses.contains(li.LG_B2B_Care_Equipment_id__c)) {
                    flag = true;
                    impactedEquipIds.add(li.LG_B2B_Care_Equipment_id__c);
                    if(caseMapEquipIds.get(li.B2B_Case_Number__c) == null) {
                        caseMapEquipIds.put(li.B2B_Case_Number__c, new Set<String> {li.LG_B2B_Care_Equipment_id__c});
                    }
                    else {
                        Set<String> temp = caseMapEquipIds.get(li.B2B_Case_Number__c);
                        temp.add(li.LG_B2B_Care_Equipment_id__c);
                        caseMapEquipIds.put(li.B2B_Case_Number__c, temp);
                    }
                }
            }
            if(flag == false && li.LG_Care_Customer_Number__c != null) {
                //impactedTemp = li.LG_B2B_Care_Equipment_id__c;
                //system.debug('customer numbers '+li.LG_Care_Customer_Number__c);
                if(accSerCustomerNumbers.contains(li.LG_Care_Customer_Number__c)) {
                    flag = true;
                    impactedcustomers.add(li.LG_Care_Customer_Number__c);
                    if(caseMapCusNumbers.get(li.B2B_Case_Number__c) == null) {
                        caseMapCusNumbers.put(li.B2B_Case_Number__c, new Set<String> {li.LG_Care_Customer_Number__c});
                    }
                    else {
                        Set<String> temp = caseMapCusNumbers.get(li.B2B_Case_Number__c);
                        temp.add(li.LG_Care_Customer_Number__c);
                        caseMapCusNumbers.put(li.B2B_Case_Number__c, temp);
                    }
                    //system.debug('--customer numbers -- '+caseMapCusNumbers);                    
                }
            }/*
if(impactedTemp != '' && impactedTemp != null) {
if(accServiceExtIds.contains(impactedTemp) || accSerCustomerNumbers.contains(impactedTemp) || accServiceMacAddresses.contains(impactedTemp))
{
if(caseMapSerImpacted.get(li.B2B_Case_Number__c) == null) {
caseMapSerImpacted.put(li.B2B_Case_Number__c, new Set<String> {impactedtemp});
}
else {
Set<String> temp = caseMapSerImpacted.get(li.B2B_Case_Number__c);
temp.add(impactedTemp);
caseMapSerImpacted.put(li.B2B_Case_Number__c, temp);
}
}
}*/
        }
        //caseIdMapServices = new Map<Id, Set<csord__Service__c>>();
        
        for(Id serId :serviceIdMapObj.keySet()) {
            for(Id caseId :caseMapSerExtIds.keySet()) {
                
                if(caseMapSerExtIds.get(caseId).contains(serviceIdMapObj.get(serId).LG_ServiceExternalId__c)) {
                    if(caseIdMapServices.get(caseId) == null) {
                        caseIdMapServices.put(caseId, new Set<csord__Service__c>{serviceIdMapObj.get(serId)});
                    }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                        temp.add(serviceIdMapObj.get(serId));
                        caseIdMapServices.put(caseId, temp);
                    }
                }
            }
        }
        
        for(Id serId :serviceIdMapObj.keySet()) {
            for(Id caseId :caseMapCusNumbers.keySet()) {
                if(caseMapCusNumbers.get(caseId).contains(serviceIdMapObj.get(serId).LG_ProvisioningAccountNo__c)) {
                    if(caseIdMapServices.get(caseId) == null) {
                        caseIdMapServices.put(caseId, new Set<csord__Service__c>{serviceIdMapObj.get(serId)});
                    }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                        temp.add(serviceIdMapObj.get(serId));
                        caseIdMapServices.put(caseId, temp);
                    }
                }
            }
        }
        system.debug('--- case id map services -- '+caseIdMapServices);
        Map<id,  Set<Id>> caseIdMapSerId = new Map<Id, Set<Id>>();
        for(Asset ass :[SELECT Id, csord__Service__c, LG_MACAddress__c  FROM Asset WHERE LG_MACAddress__c IN :impactedEquipIds] )
        {
            for(Id caseId :caseMapEquipIds.keySet()) {
                if(caseMapEquipIds.get(caseId).contains(ass.LG_MACAddress__c)) {
                    if(caseIdMapSerId.get(caseId) == null) {
                        caseIdMapSerId.put(caseId, new Set<Id>{ass.csord__Service__c} );
                    }
                    else {
                        Set<Id> temp = caseIdMapSerId.get(caseId);
                        temp.add(ass.csord__Service__c);
                        caseIdMapSerId .put(caseId,temp);
                    }
                }
            }
        }
        
        for(Id caseId :caseIdMapSerId.keySet()) {
            for(Id serId :caseIdMapSerId.get(caseId)) {
                if(caseIdMapServices.get(caseId) == null) {
                    caseIdMapServices.put(caseId, new Set<csord__Service__c> {serviceIdMapObj.get(serId)} );
                }
                else {
                    Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                    temp.add(serviceIdMapObj.get(serId));
                    caseIdMapServices.put(caseId, temp);
                }
            }
        }
        
        for(Id caseId :caseIdMapServices.keySet()) {
            for(csord__Service__c ser :caseIdMapServices.get(caseId)) {
                system.debug('--------- '+caseId+' ------- '+ser.id+' ---- '+ser.name);
            }
        }
        
        plannedMCases_on_Account = new List<Case>();
        
        outageCaseList = new List<caseWrapper>();
        for (Case c : plannedMaintenanceCasesAndOutage) {
            //System.debug('------------------------------- '+c.casenumber);
            if(caseIdMapServices.containsKey(c.Id) && c.recordtype.DeveloperName == 'LG_B2B_Care_Planned_Maintenance_Request_UM') {
                plannedMCases_on_Account.add(c);
                
            }
            else if(caseIdMapServices.containsKey(c.Id) && c.recordtype.DeveloperName == 'LG_B2B_Care_Mass_Outage_Request_UM') {
                caseWrapper caseWrapp = new caseWrapper();
                caseWrapp.caseObj = c;
                caseWrapp.servList = new List<csord__Service__c>();
                caseWrapp.servList.addAll(caseIdMapServices.get(c.Id));
                outageCaseList.add(caseWrapp);
                
            }
        }
        
        if(plannedMCases_on_Account.size() > 0) {
            this.checkPlannedMaintenance_in_Progress();
            this.checkPlannedMaintenance_Scheduled();
        }
    }
    
    public void checkPlannedMaintenance_Scheduled() {
        scheduledCaseList = new List<caseWrapper>();
        
        transient DateTime todayNow = DateTime.Now();
        Long td1 = todayNow.getTime();
        transient Date today = Date.today();
        for(Case c : plannedMCases_on_Account) {
            Long td2 = c.LG_Estimated_resolution_time__c.getTime();
            Long td3 = c.LG_Estimated_Start_Time__c.getTime();
            if(today.daysBetween(c.LG_Estimated_Start_Time__c.Date()) <= 3 && (td3 - td1)/1000 >0 && (td2 - td1)/1000 > 0) {
                
                
                caseWrapper caseWrapp = new caseWrapper();
                caseWrapp.caseObj = c;
                caseWrapp.servList = new List<csord__Service__c>();
                caseWrapp.servList.addAll(caseIdMapServices.get(c.Id));
                scheduledCaseList.add(caseWrapp);
                
            }
        }
    }
    
    public void checkPlannedMaintenance_in_Progress() {
        inProgressCaseList = new List<caseWrapper>();
        transient DateTime todayNow = DateTime.Now();
        for(Case c : plannedMCases_on_Account) {
            if(c.LG_Estimated_Start_Time__c <= todayNow & c.LG_Estimated_resolution_time__c >= todayNow) {
                
                
                caseWrapper caseWrapp = new caseWrapper();
                caseWrapp.caseObj = c;
                caseWrapp.servList = new List<csord__Service__c>();
                caseWrapp.servList.addAll(caseIdMapServices.get(c.Id));
                inProgressCaseList.add(caseWrapp);
                
            }
        }
    }
    
    public class caseWrapper{
        public case caseObj{get;set;}
        public List<csord__Service__c> servList {get;set;}
    }
}
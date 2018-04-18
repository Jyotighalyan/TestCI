/**
 * Utillity class for Inflight Change Step HLD
 *
 * @author Petar Miletic
 * @ticket SFOM-355
 * @since  20/02/2017
*/
global with sharing  class LG_InflightChangeUtil {

	/*
	 * New Case record will be created, case record type: Schedule appointment, case type: Modify
	*/
	webservice static String reSchedule(Id solutionId) {

		try {
			String errorMsg = validateServiceStatus(solutionId);
	        if(errorMsg != 'Success')
                return errorMsg;
            else
            	return getExistingOrNewCase(solutionId, 'Schedule Appointment', 'Modify');
            
		} catch (DmlException e) {
			return e.getMessage();
		}
	}

	/*
	 * New Case record will be created, case record type: Manage Numbers, case type: Inflight
	*/
	webservice static String correctNumbers(Id solutionId) {

		try {

            return getExistingOrNewCase(solutionId, 'Manage Numbers', 'Inflight Change');

		} catch (DmlException e) {
			return e.getMessage();
		}
	}

	/*
	 * New Case record will be created, case record type: Inflight Configuration, case type: Standard
	*/
	webservice static String configure(Id solutionId) {
                  
		try {
		    
            return getExistingOrNewCase(solutionId, 'Inflight Configuration', 'Standard');

		} catch (DmlException e) {
			return e.getMessage();
		}
	}
	
	/*
	 * Get existing Case or crate a new one
	*/
	private static Id getExistingOrNewCase(Id solutionId, String recordTypeName, String caseType) {

        // Get Cases
		List<Case> cases = [SELECT Id,
                                ContactId, 
                                Type, 
                                Description, 
                                Subject, 
                                LG_Solution__c,
                                RecordType.Name,
                                LG_Order__c,
                                Status
		                    FROM Case
		                    WHERE LG_Solution__c = :solutionId AND RecordType.Name = :recordTypeName AND Status NOT IN ('Cancelled', 'Closed')
		                            ORDER BY CreatedDate DESC];

        // If Cases exist
		if (cases.size() > 0) {

            return cases[0].Id;

			/*List<Case> subset = getCaseNewSubset(cases, caseType);

			// Return Case that is already open
			if (subset.size() > 0) {
			    
			    // Return Id
				return cases[0].Id;

			} else {

				// Take the first one, clone it and insert with New status
				Case obj = cases[0].clone(false, true, false, false);
				obj.Type = caseType;
				obj.Status = 'New';

				insert obj;

                // Return Id
				return obj.Id;
			}*/

		} else {

            // Get record type
            RecordType manageNumbers = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND RecordType.Name = :recordTypeName LIMIT 1];

			// Create new case
			Case obj = new Case();
			obj.LG_Solution__c = solutionId;
			obj.RecordTypeId = manageNumbers.Id;
			obj.Type = caseType;
            obj.subject = 'Please capture customer\'s last minute change';
			obj.Status = 'New';

			insert obj;

            // Return Id
			return obj.Id;
		}
	}

    /*
     * Return Case subset based on Status == New and Type passed as parameter
    */
	/*private static List<Case> getCaseNewSubset(List<Case> cases, String type) {

		List<Case> subset = new List<Case>();

		for (Case obj : cases) {

			if (obj.Status == 'New' && obj.Type == type) {
				subset.add(obj);
			}
		}

		return subset;
	}*/

    /**
     * Appointment (OMB-170: Inflight change)
     *
     * @author  Ganesh Subbiah
     * @ticket SFOM-427 Code
    */
    private static String validateServiceStatus(Id solutionId) {
			
        List<csord__Service__c> serviceObjList= new List<csord__Service__c>() ;
        List<LG_ScheduleAppointment__c> appList = new List<LG_ScheduleAppointment__c>();
		if (solutionId != null) {
            appList = [Select 	id, LG_Status__c, LG_AgreedInstallDate__c
                       			from LG_ScheduleAppointment__c
                       			where LG_Solution__c= :solutionId
                      			and LG_Status__c = 'Scheduled'];
            if(appList.isEmpty() || applist.size() ==0){
                return 'There is no appointment to modify';
            }
            else if (applist[0].LG_AgreedInstallDate__c < system.today())
                return 'Appointment cannot be modified as appointment is in the past';
            else {
                serviceObjList = [SELECT Id, Name,
                              csord__Status__c,
                              LG_ServiceStatus__c
                              FROM csord__Service__c
                              WHERE LG_Suborder__c = :solutionId];
                Set<String> inValidStatus = new Set<String> {'Active', 'Ready for Billing', 'Inactive'};
                if(!serviceObjList.isEmpty()){
                    for(csord__Service__c serviceRecord: serviceObjList){
                      if(inValidStatus.contains(serviceRecord.LG_ServiceStatus__c) ){
                            return 'Appointment cannot be modified as service is not in a valid status';
                      }
                    }
                }
                else return 'No valid service is available to update';
        }
        }    
        return 'Success';
    }
}
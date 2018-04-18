public  class TriggerOpportunityContactRole {
	public static void primaryContactUpdate(List<Opportunity> opptyList) {

    if(OpptyList.size() > 0) {

        Set<Id> OppIds = new Set<Id>();
        for (Opportunity o : opptyList) {
            if (o.LG_primarycontact__c == null) {
                OppIds.add(o.id);
            }
        }
        if(OppIds.isEmpty()){
            return;
        }       
        if (OppIds!=null && !OppIds.isEmpty()) {

			Map<Id, List<OpportunityContactRole>> OCRmap = new Map<Id, List<OpportunityContactRole>>();

			for (OpportunityContactRole ocr : [SELECT id, contactid, Opportunityid, role, isprimary, createddate FROM OpportunityContactRole WHERE opportunityid in :OppIds AND isprimary = true]) {
				List<OpportunityContactRole> ocrlist = new List<OpportunityContactRole>();
				ocrlist = OCRmap.get(ocr.opportunityid);

				if (ocrlist == null) {
					OCRmap.put(ocr.opportunityid, new List<OpportunityContactRole> {ocr});
				} else {
					OCRmap.put(ocr.opportunityid, ocrlist);
				}
			}

			// for each Opp modified in the trigger, trying to find relevant contacts
			for (Opportunity opps : opptyList) {
				// temporary list of OpptyContactRoles for this Opportunity populated from the main map
				List<OpportunityContactRole>  contactrole = new List<OpportunityContactRole>();
				contactrole = OCRmap.get(opps.id);

				if (contactrole == null) {
					opps.LG_primarycontact__c = null;
				} else {

					for (OpportunityContactRole r : contactrole) {

                        // if the role is primary, track this Contact id
                        if (r.isprimary) {
                            opps.LG_primarycontact__c = r.contactid;
                        }
                    }
                }
            }
        }
    }
  }
    
    //Deb-- 14 Mar, serviceability check
    public static void validateOpportunityChanges(Map<Id,Opportunity> oldOpptyMap,Map<Id,Opportunity> newOpptyMap) 
    {
            for(Opportunity optyObj : newOpptyMap.values())
            {
                if(optyObj.LG_PostalCode__c!=oldOpptyMap.get(optyObj.Id).LG_PostalCode__c)
                {
                    optyObj.Is_Availability_Performed__c= 'No';
                    optyObj.Phone_Availability__c='Not Performed';
                    optyObj.Mobile_Availability__c='Not Performed';
                    optyObj.Internet_Availability__c='Not Performed';
                    optyObj.Analog_Availability__c='Not Performed';
                            
                }
            }
            
      }
      //end
}
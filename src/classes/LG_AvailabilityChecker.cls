global class LG_AvailabilityChecker{

    webservice static boolean checkServiceability(String OppObjId, String OppPostalCode){
        system.debug('checkServiceability method called');
        system.debug('OppObjId--'+OppObjId);
        system.debug('OppPostalCode--'+OppPostalCode);
        AvailabilityCheckerPOC acPoc = new AvailabilityCheckerPOC();
        String response = acPoc.performtest(OppObjId,OppPostalCode);
        system.debug('response--'+response);
        
        if(response==Label.UM_GenericError)
        {
            return false;
        }
        
        Opportunity oppObj = [select id,name,Is_Availability_Performed__c,Phone_Availability__c,
                              Mobile_Availability__c,Internet_Availability__c,Analog_Availability__c
                              from Opportunity where id=:OppObjId];
        system.debug('oppObj.Is_Availability_Performed__c--'+oppObj.Is_Availability_Performed__c);                      
        oppObj.Is_Availability_Performed__c= 'Yes';
                
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(response);
        String mktPhone = (String)data.get('mktPhone');
        String mktMobile = (String)data.get('mktMobile');
        String mktInternet = (String)data.get('mktInternet');
        String mktAnalog = (String)data.get('mktAnalog');
        system.debug('mktPhone-'+mktPhone+'mktMobile-'+mktMobile+'mktInternet-'+mktInternet+'mktAnalog-'+mktAnalog);
        
        if(mktPhone!=null && mktPhone=='Y'){
            oppObj.Phone_Availability__c='Available';
        }else {
            oppObj.Phone_Availability__c='Unavailable';
        }
        if(mktMobile!=null && mktMobile=='Y'){
            oppObj.Mobile_Availability__c='Available';
        }else {
            oppObj.Mobile_Availability__c='Unavailable';
        }        
        if(mktInternet!=null && mktInternet=='Y'){
            oppObj.Internet_Availability__c='Available';
        }else {
            oppObj.Internet_Availability__c='Unavailable';
        }    
        if(mktAnalog!=null && mktAnalog=='Y'){
            oppObj.Analog_Availability__c='Available';
        }else {
            oppObj.Analog_Availability__c='Unavailable';
        }
        
        update oppObj;
        
        return true;
    }
    
    webservice static boolean checkServiceabilityLead(String LeadObjId, String LeadPostalCode){
        system.debug('checkServiceabilityLead method called');
        system.debug('LeadObjId--'+LeadObjId);
        system.debug('LeadPostalCode--'+LeadPostalCode);
        AvailabilityCheckerPOC acPoc = new AvailabilityCheckerPOC();
        String response = acPoc.performtest(LeadObjId,LeadPostalCode);
        system.debug('response--'+response);
        
        if(response==Label.UM_GenericError)
        {
            return false;
        }
        
        Lead leadObj = [select id,name,Is_Availability_Performed__c,Phone_Availability__c,
                              Mobile_Availability__c,Internet_Availability__c,Analog_Availability__c
                              from Lead where id=:LeadObjId];
        system.debug('leadObj.Is_Availability_Performed__c--'+leadObj.Is_Availability_Performed__c);                      
        leadObj.Is_Availability_Performed__c= 'Yes';
                
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(response);
        String mktPhone = (String)data.get('mktPhone');
        String mktMobile = (String)data.get('mktMobile');
        String mktInternet = (String)data.get('mktInternet');
        String mktAnalog = (String)data.get('mktAnalog');
        system.debug('mktPhone-'+mktPhone+'mktMobile-'+mktMobile+'mktInternet-'+mktInternet+'mktAnalog-'+mktAnalog);
        
        if(mktPhone!=null && mktPhone=='Y'){
            leadObj.Phone_Availability__c='Available';
        }else {
            leadObj.Phone_Availability__c='Unavailable';
        }
        if(mktMobile!=null && mktMobile=='Y'){
            leadObj.Mobile_Availability__c='Available';
        }else {
            leadObj.Mobile_Availability__c='Unavailable';
        }        
        if(mktInternet!=null && mktInternet=='Y'){
            leadObj.Internet_Availability__c='Available';
        }else {
            leadObj.Internet_Availability__c='Unavailable';
        }    
        if(mktAnalog!=null && mktAnalog=='Y'){
            leadObj.Analog_Availability__c='Available';
        }else {
            leadObj.Analog_Availability__c='Unavailable';
        }
        
        update leadObj;
        
        return true;
    }  
    
    
}
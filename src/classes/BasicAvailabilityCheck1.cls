global class BasicAvailabilityCheck1 {

    webservice static String doWork (String siteId) {
        String numbersOnly;
        if (siteId == '11111') {
            numbersOnly = '0';
        }
        else {
			numbersOnly = '500';            
        }

        Map<String, String> retMap = new Map<String, String>{'topspeed' => numbersOnly};
        return JSON.serialize(retMap);
    }
}
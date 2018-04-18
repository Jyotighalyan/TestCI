global class UM_WebToLeadEmailHandler implements Messaging.InboundEmailHandler {

		public final String SRN = 'UM_Web2LeadMapping';
		public mapAndDisplay mapAndDisplaySetting {get; set;}

      	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        	Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        	StaticResource displayMapBlob = [Select body, name from StaticResource where Name = :SRN]; 

        	String strUrlUTF8 = displayMapBlob.body.toString();
        	String fmappingJson = EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'); 

        	mapAndDisplaySetting = (mapAndDisplay)JSON.deserialize(fmappingJson, mapAndDisplay.class);
			string formEmail;
			Lead toInsert = new Lead();
        	Map<String, String> tmpToInsert = new Map<String,String>();

          	List<String> txtToList = email.plainTextBody.split('\n');
          	for(String line : txtToList) {
				if(line.contains('Email') && line.contains('<')){
					line=line.substring(0,line.IndexOf('<'));
      			}
          		if(line.trim().length() > 0) {
          			List<String> sp = line.split(':');
          			if(sp.size() == 2) {
	          			tmpToInsert.put(sp.get(0), sp.get(1));
	          		}
	        	}
          	}
          	if(tmpToInsert.size() > 0){

          		for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
          			if(tmpToInsert.containsKey(loopVar.wfFieldName)) {
          				toInsert.put(loopVar.sfFieldName, tmpToInsert.get(loopVar.wfFieldName).trim());
          				toInsert.LeadSource='Web';
          			}
          		}

	          	try {

	          		insert toInsert;
	          	} catch (DmlException e) {
	          		system.debug('Error: '+e);
	          	}          		
          	}

          	return result;
      	}

	    class mapAndDisplay {
	        public boolean isActive;
	        public List<fieldMap> fieldMap{get;set;}
	    }

	    class fieldMap {
	        public String wfFieldName{get;set;}
	        public String sfFieldName{get;set;}
	    }      	
  }
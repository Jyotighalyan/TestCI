/**
* This class is for creation of JIRA form on the fly.
*
* @author Ankur Gupta
* @ticket SFOM-2145
* @since  03/11/2017
*/
global class UM_JiraCreateIssue
{ 
    public static Map<String,String> valueLookUpMap;
    public static Map<String,JiraAttributesMapping__mdt> parameterMap;
    public static Map<Schema.SObjectType,Set<String>> missingFieldMap;
    public static Map<String, JiraAttributesProduktMapping__mdt> produktParameterMapping;
    
    public static sObject sObj;
    public static Boolean isChild;
    public static String formJson = '';    
    public static csord__service__c service;
    
    public static Set<String> childServiceNames;
    
    public static String createJiraOrder(csord__solution__c currentSolution)
    {
        Set<String> queryFieldSet = new Set<String>();
        
        missingFieldMap = new Map<Schema.SObjectType, Set<String>>();
        parameterMap    = new Map<String,JiraAttributesMapping__mdt>();
        valueLookUpMap  = new Map<String,String>();
        childServiceNames = new Set<String>();
        produktParameterMapping = new Map<String,JiraAttributesProduktMapping__mdt>();
        
        service = [SELECT Id,Name,UM_JiraIssueTypeId__c, UM_DownloadSpeed__c,LG_Suborder__c, UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c,
                   UM_DependsOnService__c, UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningAccountNo__c,LG_RootOrder__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c, 
                   csord__Service__r.csord__Service__c,UM_AS_Number__c,UM_Announced_prefix__c,UM_BGP_Password__c,UM_IPv4__c,UM_IPv6__c,LG_SLA__c,
                   UM_Access_Active_IPv4__c,UM_Access_Active_IPv6__c,UM_Access_Transfer_IPv4__c,UM_Access_Transfer_IPv6__c,LG_AdditionalInformation__c,
                   csord__service__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c           // SFOM-2665
                   FROM csord__Service__c WHERE LG_Suborder__c =:currentSolution.Id AND UM_JiraIssueTypeId__c != null];
		
        if(service.Name.containsIgnoreCase('Access'))
            childServiceNames.add('Access');
        else if(service.Name.containsIgnoreCase('BGP'))
            childServiceNames.add('BGP');
        /*SFOM-2665 -- Start*/
        else if(service.Name.containsIgnoreCase('Company Cloud Fiber'))    
            childServiceNames.add('CCF');
        /*SFOM-2665 -- End*/
        else
            childServiceNames.add(service.name);
        
        // Add all the query fields of each parameter in queryFieldSet
        for(JiraAttributesMapping__mdt attr : [SELECT id, MasterLabel, DeveloperName, Attribute_Name__c, Constant_Value__c, Form_Name__c, 
                                               Is_Mandatory__c, Is_Service_Child__c, Is_Value_Lookup__c, SF_Field__c 
                                               FROM JiraAttributesMapping__mdt 
                                               WHERE Form_Name__c = :service.UM_JiraIssueTypeId__c AND Is_Service_Child__c = false])
        {
            if(attr.SF_Field__c != null){
                queryFieldSet.add(attr.SF_Field__c.toUpperCase());
            }
            parameterMap.put(attr.Attribute_Name__c, attr);
        }
        
        //Create map of lookup Values for each attribute
        for(JiraAttributeLookupMapping__mdt valueLookup : [SELECT Id, MasterLabel, DeveloperName, Attribute_Name__c, Form_Name__c, 
                                                           SF_Field_Value__c,Subsitution_Value__c FROM JiraAttributeLookupMapping__mdt 
                                                           WHERE Form_Name__c = :service.UM_JiraIssueTypeId__c ])
        {
            valueLookUpMap.put(valueLookup.Attribute_Name__c+valueLookup.SF_Field_Value__c, valueLookup.Subsitution_Value__c);
        }
        
        for(JiraAttributesProduktMapping__mdt produktMap : [SELECT Id, MasterLabel, DeveloperName, Download_Speed__c, Name__c,
                                                            Download_Speed_Code__c, Option_with_Child__c, Service_Code__c FROM 
                                                            JiraAttributesProduktMapping__mdt WHERE Name__c IN :childServiceNames])
        {
            if(produktMap.Option_with_Child__c)
                produktParameterMapping.put(produktMap.Name__c + produktMap.Download_Speed__c , produktMap);
            else
                produktParameterMapping.put(produktMap.Name__c + service.UM_DownloadSpeed__c, produktMap);
        }
        
        String serviceQuery = 'SELECT Id';
        //get the child queries (if any) and append it in the service query
        String childQuery = createChildQuery(service);
        
        if(String.isNotBlank(childQuery)){
            serviceQuery = serviceQuery + childQuery;
        }
        
        for(String field : fieldParser(queryFieldSet) )
        {
            serviceQuery = serviceQuery + ', ' + field;
        }
        
        serviceQuery = serviceQuery + ' FROM csord__service__c WHERE UM_JiraIssueTypeId__c = \'' + service.UM_JiraIssueTypeId__c + '\' AND LG_Suborder__c = \'' + currentSolution.Id + '\'';
        sObj = Database.query(serviceQuery);
        
        String srQuery = 'SELECT Id,body,Name FROM StaticResource WHERE Name = \'JiraForm_' + service.UM_JiraIssueTypeId__c + '\'';
        StaticResource sr = Database.query(srQuery);        
        formJson = sr.body.tostring();
        formJson = formJson.replaceAll('"attribute" : "' , '"attribute": "');
        formJson = formJson.replaceAll('"attribute" :"' , '"attribute": "');
        formJson = formJson.replaceAll('"attribute":"' , '"attribute": "');
        
        JSONParser parser = Json.createParser(formJson);
        Set<String> attributeSet = new Set<string>();
        
        while (parser.nextToken() != null) 
        {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getCurrentName() == 'attribute')
            {    
                parser.nextToken();
                attributeSet.add(parser.getText());
            }
        } 
        
        //Set Vermittler parameters based on the availability of partner account linked to opportunity
        if(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c != null)
        {
            for(String attributeKey : parameterMap.keySet())
            {
                if(parameterMap.get(attributeKey).MasterLabel.contains('Vermittler') && parameterMap.get(attributeKey).MasterLabel != 'Vermittler (Firma)')
                    parameterMap.remove(attributeKey);
            }    
        }
        
        return valueAppender(attributeSet);
    }
    
    //Append value tag for each attribute available in the Jira form
    public static String valueAppender(Set<String> attributeSet)
    {
        String replacement;
        String value;
        String attributeTag;
        String valueTag;
        String summaryValue;
        
        for(String attribute: attributeSet)
        {
            attributeTag = '"attribute": "'+ attribute +'",';
            valueTag     = '"value" : "' ;
            isChild = false;
            
            if(parameterMap.containsKey(attribute) && String.isNotBlank(parameterMap.get(attribute).SF_Field__c))
            {
                replacement = '';
                value       = '';
                
                Set<String> fieldSet = new Set<String>{parameterMap.get(attribute).SF_Field__c};    
                List<String> fields = UM_JiraCreateIssue.fieldParser(fieldSet);
                
                if(!parameterMap.get(attribute).Is_Service_Child__c)
                {
                    if(parameterMap.get(attribute).Is_Value_Lookup__c == false){
                        valueTag = valueTag + getValueTag(attribute,fields);
                    }
                    else
                    {
                        value = String.valueOf(getFieldValue(sObj, fields[0] , parameterMap.get(attribute).Is_Mandatory__c));
                        if(value != null && valueLookUpMap.containsKey(attribute+value))
                            valueTag = valueTag + valueLookUpMap.get(attribute+value) + '",';
                    }
                }
                else
                {
                    isChild = true;
                    valueTag = valueTag + getValueTag(attribute,fields);
                }
            }
            else if(parameterMap.containsKey(attribute) && String.isNotBlank(parameterMap.get(attribute).Constant_Value__c) 
                    && parameterMap.get(attribute).Is_Value_Lookup__c == false )
            {
                valuetag  = valuetag + parameterMap.get(attribute).Constant_Value__c + '",';
            }
            //if for a attribute valueTag gets appended value, then append valueTag in the form
            if(valueTag.contains(','))
            {
                if(parameterMap.get(attribute).Attribute_Name__c == 'summary'){
                  if(valueTag.substringBefore('_').containsIgnoreCase('HSN'))   
                        valueTag = valueTag.replaceFirst('HSN','HE');
                    summaryValue = valueTag;
                }
                
                if(formJson.contains(attributeTag ))
                    replacement = attributeTag + '\n' + valuetag;
                else
                {
                    attributeTag = attributeTag.removeEnd(',');
                    replacement = valuetag + '\n' + attributeTag;
                }
                
                formJson = formJson.replace(attributeTag, replacement);
            }
        }
        
        if(service.csord__service__c != null)
        {
            String key = '';
            
            if(service.Name.containsIgnoreCase('Access'))
                key = 'Access' + service.UM_DownloadSpeed__c;
            else if(service.Name.containsIgnoreCase('BGP'))
                key = 'BGP' + service.UM_DownloadSpeed__c;
            /*SFOM-2665 -- Start*/
            else if(service.Name.containsIgnoreCase('Company Cloud Fiber'))  
                key = 'CCF' + service.UM_DownloadSpeed__c;
            /*SFOM-2665 -- End*/
            else
                key = service.Name + service.UM_DownloadSpeed__c;
            
            valueTag = '"value" : "';
            attributeTag = '"attribute": "customfield_14500",';
            
            if(produktParameterMapping.containsKey(key))
            {
                if(produktParameterMapping.get(key).Option_with_Child__c)
                    valueTag += produktParameterMapping.get(key).Service_Code__c + '",\n"child" : "' + produktParameterMapping.get(key).Download_Speed_Code__c  +'",';
                else
                    valueTag += produktParameterMapping.get(key).Service_Code__c + '",';
                
                replacement = attributeTag + '\n' + valuetag;
                formJson = formJson.replace(attributeTag, replacement);
            }
            /*SFOM-2665 -- Start*/
            valueTag = '"value" : "';
            attributeTag = '"attribute": "description",';
                
            if(service.Name.containsIgnoreCase('BGP'))
            {
                if(String.isNotBlank(summaryValue))
                    formJson = formJson.replace(summaryValue, summaryValue.substringBefore('_') + '_BGP_' + summaryValue.substringAfter('_'));
                //for description attribute
                if(!String.isBlank(String.valueOf(service.UM_AS_Number__c)) && service.UM_AS_Number__c != 0)
                    valueTag += 'AS-Nummer: ' + service.UM_AS_Number__c + ' \\n ';
                if(!String.isBlank(service.UM_Announced_prefix__c))
                    valueTag += 'Announced Prefix: ' + service.UM_Announced_prefix__c + ' \\n ';
                if(!String.isBlank(service.UM_BGP_Password__c))
                    valueTag += 'BGP-Passwort: ' + service.UM_BGP_Password__c + ' \\n ';
                if(!String.isBlank(service.UM_IPv4__c))
                    valueTag += 'IPv4 PI Adressraum: ' + service.UM_IPv4__c + ' \\n ';
                if(!String.isBlank(service.UM_IPv6__c))
                    valueTag += 'IPv6 PI Adressraum: ' + service.UM_IPv6__c + ' \\n ';
                if(!String.isBlank(service.LG_AdditionalInformation__c))
                    valueTag += 'zusätzliche Information: ' + service.LG_AdditionalInformation__c ;
            }
            else if(service.Name.containsIgnoreCase('Access'))
            {
                if(String.isNotBlank(summaryValue))
                    formJson = formJson.replace(summaryValue, summaryValue.substringBefore('_') + '_IP-A_' + summaryValue.substringAfter('_'));
                //for description attribute
                if(String.isNotBlank(service.UM_Access_Active_IPv4__c))
                    valueTag += 'Wirknetz-IPv4: ' + service.UM_Access_Active_IPv4__c + ' \\n ';
                if(String.isNotBlank(service.UM_Access_Active_IPv6__c))
                    valueTag += 'Wirknetz-IPv6: ' + service.UM_Access_Active_IPv6__c + ' \\n ';
                if(String.isNotBlank(service.UM_Access_Transfer_IPv4__c))
                    valueTag += 'Transfernetz-IPv4: ' + service.UM_Access_Transfer_IPv4__c + ' \\n ';
                if(String.isNotBlank(service.UM_Access_Transfer_IPv6__c))
                    valueTag += 'Transfernetz-IPv6: ' + service.UM_Access_Transfer_IPv6__c + ' \\n ';
                if(!String.isBlank(String.valueOf(service.LG_AdditionalInformation__c)))
                    valueTag += 'zusätzliche Information: ' + service.LG_AdditionalInformation__c;
            }
            else if(service.Name.containsIgnoreCase('Company Cloud Fiber'))
            {                
                if(String.isNotBlank(summaryValue))
                    formJson = formJson.replace(summaryValue, summaryValue.substringBefore('_') + '_CFP_' + summaryValue.substringAfter('_'));
                //for description attribute                
				if(!String.isBlank(String.valueOf(service.LG_AdditionalInformation__c)))
                    valueTag += 'zusätzliche Information: ' + service.LG_AdditionalInformation__c + ' \\n ';
                if(String.isNotBlank(service.csord__service__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c))
                    valueTag += 'Jira Id: ' + service.csord__service__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c;
            }
              	
                if(valueTag != '"value" : "') {
                    valueTag += '",';
                    replacement = attributeTag + '\n' + valuetag;
                    formJson = formJson.replace(attributeTag, replacement);
                }
            /*SFOM-2665 -- End*/
            }
        
        else if(service.UM_DependsOnService__c != null)
        {
            if(String.isNotBlank(summaryValue))
                formJson = formJson.replace(summaryValue, summaryValue.substringBefore('_') + '_Fibre/Coax_' + summaryValue.substringAfter('_'));
            
            //Kunde(RNS)
            attributeTag = '"attribute": "customfield_15500",';
            //for CI + MWLAN
            if(String.isNotBlank(service.UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningAccountNo__c))
            {
                valueTag     = '"value" : "' + service.UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningAccountNo__c + '",';
                replacement  = attributeTag + '\n' + valuetag;
                formJson     = formJson.replace(attributeTag, replacement);
            }
            //for CF + MWLAN
            else if(String.isNotBlank(service.UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c)
                    && service.UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c.contains('BBS'))
            {
                valueTag     = '"value" : "' + service.UM_DependsOnService__r.LG_Suborder__r.LG_ProvisioningWorkOrder__c + '",';
                replacement  = attributeTag + '\n' + valuetag;
                formJson     = formJson.replace(attributeTag, replacement);
            }
        }
        
        System.debug('finalJson : ' + formJson);
        return formJson;
    }
    
    //Create Child Query for attributes with Is Service Child true
    public static String createChildQuery(csord__service__c service)
    {
        Set<String> childQueryFieldSet = new Set<String>();
        Map<String,List<String>> childQueryMap = new Map<String,List<String>>();
        String childQuery = null;
        // Add all the query fields for child objects of service
        for(JiraAttributesMapping__mdt attr: [SELECT id, MasterLabel, DeveloperName, Attribute_Name__c, Constant_Value__c, Form_Name__c, 
                                              Is_Mandatory__c, Is_Service_Child__c, Is_Value_Lookup__c, SF_Field__c 
                                              FROM JiraAttributesMapping__mdt 
                                              WHERE Form_Name__c = :service.UM_JiraIssueTypeId__c AND Is_Service_Child__c = true])
        {
            if(attr.SF_Field__c != null){
                childQueryFieldSet.add(attr.SF_Field__c.toUpperCase());
            }
            parameterMap.put(attr.Attribute_Name__c, attr);
        }
        
        for(String childField : fieldParser(childQueryFieldSet))
        {
            if(childField.contains('.')){
                List<String> token = childField.split('\\.');
                if(!childQueryMap.containsKey(token[0]))
                    childQueryMap.put(token[0], new List<String>{token[1]});
                else
                    childQueryMap.get(token[0]).add(token[1]);
            }
        }
        
        //Create query on service object using parsed field set list
        for(String obj : childQueryMap.keySet() )
        {
            if(childQuery!=null)
                childQuery = childQuery + ', (SELECT Id, ' + String.join(childQueryMap.get(obj), ',') + ' FROM ' + obj + ')';
            else
                childQuery = ', (SELECT Id, ' + String.join(childQueryMap.get(obj), ',') + ' FROM ' + obj + ') ';
        }
        return childQuery;
    }
    
    public static List<String> fieldParser(Set<String> queryFieldSet)
    {
        Set<String> fieldSet = new Set<String>();
        Set<String> tempFieldSet = new Set<String>();
        for(String field : queryFieldSet)
        {
            if(field.contains('<'))
                tempFieldSet.addall(field.split('<'));    
        }
        
        for(String field : tempFieldSet)
        {
            if(field.contains('>'))
                fieldSet.add(field.split('>')[0].toUpperCase().normalizeSpace());    
        }
        return new List<String>(fieldSet);
    }
    
    public static String getValueTag(String attribute, List<String> fields)
    {
        String value = '';
        //If SF_Field contains only one field e.g. - <LG_AccountName__c>
        if(fields.size() == 1)
        {   
            value = String.valueOf(getFieldValue(sObj, fields[0], parameterMap.get(attribute).Is_Mandatory__c));
            if(value != null) 
                return value + '",';
        }
        //If SF_Field contains more than one field e.g. - <LG_AccountName__c>_<LG_CustomerName__c> <LG_Address_c>
        else if(fields.size() > 1)
        {
            String toBeReplacedField = parameterMap.get(attribute).SF_Field__c.toUpperCase();                
            for(String multiField : fields)
            {
                value = String.valueOf(getFieldValue(sObj, multiField, parameterMap.get(attribute).Is_Mandatory__c));
                multiField = '<' + multiField + '>'; 
                toBeReplacedField = value!=null ? toBeReplacedField.replace(multiField, value) : toBeReplacedField.replace(multiField, '');
            }
            return toBeReplacedField + '",';
        }
        return value;
    }
    
    // To get field values for relationship fields e.g. [LG_Address__r.LG_TechnicalContact__r.Phone]
    public static Object getFieldValue(sObject sObj, String field, Boolean isMandatory)
    {
        if(sObj == null)
            return null;
        
        if(field.contains('.'))
        {
            String nextField = field.substringAfter('.');
            String relation = field.substringBefore('.');
            return isChild == false ?  UM_JiraCreateIssue.getFieldValue((sObject)sObj.getSObject(relation),nextField, isMandatory) : 
            UM_JiraCreateIssue.getFieldValue((sObject)sObj.getSObjects(relation)[0],nextField, isMandatory);
        }
        else{
            if(sObj.get(field) == null && isMandatory)
            {
                Schema.SObjectType key = sObj.getSObjectType();
                //String objName = key.getDescribe().getName();
                //Schema.SObjectField fld = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(field);
                if(!missingFieldMap.containsKey(key))
                    missingFieldMap.put(key, new Set<String>{field.toLowerCase()});  
                else
                    missingFieldMap.get(key).add(field.toLowerCase()); 
 
                System.debug('missingMap# ' + missingFieldMap);
            }
            
            if(sObj.get(field) instanceof Date)
                return formatDate((Date)sObj.get(field));

            return sObj.get(field);
        }
    }
    
    public static String formatDate(Date installOrWishDate)
    {
       return Datetime.newInstance(installOrWishDate.year(), installOrWishDate.month(), installOrWishDate.day()).format('dd.MM.YYYY');
    }
}
global class CompileOfflineHelper {

    webservice static List<cscfga__Attribute_Definition__c> getSelectListLookups(String prodDefId) {
        System.debug('Retrieving attribute definitions with cscfga__Select_List_Lookup__c set to TRUE for Product Definition Id: ' + prodDefId);
        List<cscfga__Attribute_Definition__c> adList = [SELECT Id, Name 
             FROM cscfga__Attribute_Definition__c 
             WHERE cscfga__Select_List_Lookup__c = TRUE 
             AND cscfga__Product_Definition__c = :prodDefId];    
        System.debug(adList);
        return adList;
    }

    webservice static Boolean toggleAttributes(List<cscfga__Attribute_Definition__c> attDefList, Boolean toggleState) {
        Boolean flag = false;
        try {
            System.debug('Toggling the following attribute definitions to ' + toggleState);
            System.debug(attDefList);
            for(cscfga__Attribute_Definition__c ad : attDefList) {
                ad.cscfga__Select_List_Lookup__c = toggleState;        
            }
            update attDefList;    
            flag = true;
        } catch (Exception e) {
            flag = false;
        } finally {
            return flag;
        }
        return flag;
    }

    webservice static Boolean compile(String prodDefId) {
        System.debug('----- ----- ----- ----- ----- ----- ----- ----- -----');
        System.debug('Started compile of product definition: ' + prodDefId);
        datetime qryStart = datetime.now();
        System.debug('Query start time is: ' + qryStart);
        
        PageReference pr = new PageReference('/apex/cscfga__CaptureProductModel?id=' + prodDefId + '&template=csac__RenderOfflineAppUI&phase=template');
        Blob b = pr.getcontent();
        
        Boolean flag = true;
        
        do {
            List<Attachment> a = [SELECT Id, LastModifiedDate FROM Attachment WHERE ParentId = :prodDefId AND Name = 'DefaultScreenFlow-csac__RenderOfflineAppUI' LIMIT 1];
            System.debug('Last modified datetime is: ' + a.get(0).lastmodifieddate);
    
            if(a.get(0).lastmodifieddate > qryStart) {
                system.debug('Exiting Loop');
                flag = false;
            } else {
                system.debug('Sleeping');
                customSleep(1);
            }
        } while(flag);
        System.debug('Ended compile of product definition: ' + prodDefId);    
        System.debug('----- ----- ----- ----- ----- ----- ----- ----- -----');
        System.debug('Used cpu time: ' + Limits.getCpuTime());
        return true;
    }
    
    webservice static Boolean updatePDLastModifiedDate(String prodDefId) {
        Boolean flag = false;
        try {
            List<cscfga__Product_Definition__c> pdList = [SELECT Id FROM cscfga__Product_Definition__c WHERE Id = :prodDefId];
            update pdList;
        } catch (Exception ex) {
            flag = false;
        } finally {
            return flag;
        }
        return flag;
    }

    private static void customSleep(Integer timeInSeconds) {
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        Integer delayInMilliseconds = timeInSeconds * 1000; // One-second delay
        while (System.now().getTime() - startingTime < delayInMilliseconds)  {
            // Do nothing until desired delay has passed
        }
    }
}
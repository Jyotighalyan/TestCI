public class LG_AddressValidationHelper {

    /*
    Description : This method processes Record ID and fetched the object Name from the Schema object
    Param : Record ID
    Return : API name of the object
    */
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

    /*
    Descripion : This method process fieldset data and returns a map of Field Label and Field API name
    Param : FieldSet API Name & Object Name
    Return : Map of Field Label & Field API name
    */
    public static Map<String,String> readFieldSet(String fieldSetName, String ObjectName)
    {
        system.assert(ObjectName != '', 'This page can be used with refernce to Salesforce Objects');
        system.assert(fieldSetName != '', 'No Search layout defined for this object');
        Map<String,String> searchField = new Map<String,String>();
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        Integer loopCount = 0;
        for(Schema.FieldSetMember loopVar : fieldSetObj.getFields()) {
            searchField.put(loopVar.getFieldPath(), loopVar.getLabel());
            loopCount++;
        }

        system.debug('--+ searchField: '+searchField);

        return searchField; 
    } 

}
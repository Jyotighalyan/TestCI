public class LG_SMSTemplateUtil {

    public static String renderTemplate(Schema.sObjectType type,sObject sobj, String template) {
        for (String fieldName : fields(sobj.getSObjectType())) {
            String key = '{!' +type+'.'+ fieldName + '}';
            system.debug('key#'+key);
           // while (template.containsIgnoreCase(key)) {
            if(template.containsIgnoreCase(key))    
            {	try {
                    system.debug('inside While');
                    Integer foundPosition = template.indexOfIgnoreCase(key, 0);
                    template = template.left(foundPosition) +
                        String.valueOf(sobj.get(fieldName)) +
                        template.substring(foundPosition + key.length());
                } catch (Exception e) {
                    // ignoring field not queried error for now because not sure if we want to query everything
                }
            }
        }
        return template;
    }

    public static String renderTemplate(Id id, String template) {
        Schema.sObjectType t = id.getSObjectType();
        String query = 
            'select ' + joinStrings(',', queryableFields(t)) + 
            ' from ' + t + 
            ' where Id = :id ';
        for (sObject sobj : Database.query(query)) {
            system.debug('sob'+sobj);
            return renderTemplate(t,sobj, template);
        }
        return null;
    }
    
    private static String joinStrings (String delimiter, Set<String> items) {
        String result = '';
        for (String item : items) {
            if (result != '') result += delimiter;
            result += item;
        }
        return result;
    }
    
    private static Set<String> fields(Schema.sObjectType t) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fields = t.getDescribe().fields.getMap();
        return fields.keySet();
    }

    private static Set<String> queryableFields(Schema.sObjectType t) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fields = t.getDescribe().fields.getMap();
        for(String fieldName : fields.keySet()) {
            //if(fields.get(fieldName).getDescribe().isUpdateable() || fields.get(fieldName).getDescribe().isCalculated() ||
               //fields.get(fieldName).getDescribe().isUnique() || fields.get(fieldName).getDescribe().isIdLookup() || fields.get(fieldName).getDescribe().isCustom()) {
             result.add(fieldName);
        }
        return result;
    }
    
}
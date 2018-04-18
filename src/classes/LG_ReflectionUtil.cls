/**
 * Remap numbers to active version
 *
 * @author Petar Miletic
 * @ticket SFOM-498
 * @since  13/03/2017
*/
public class LG_ReflectionUtil {

    /*
     * Retrieves a map containing set with object fields
     * @param String[] types - object names
    */
    public static Map<String, Set<String>> getObjectFieldsMap(String[] types) {
        
        Map<String, Set<String>> retval = new Map<String, Set<String>>();
        
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
                
        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) {
            retval.put(res.getName(), res.fields.getMap().keySet());
        }
        
        return retval;
    }
   
	public static String getColumns(Set<String> fields) {

	    List<String> columns = new List<String>(fields);

        return String.join(columns, ',');
	}
    
	public static String getColumns(Set<String> fields, string prefix) {

	    List<String> columns = new List<String>(fields);

        if (String.isNotBlank(prefix)) {
            
            String str = String.join(columns, ', ' + prefix + '.');
            return prefix + '.' + str;
        }

        return String.join(columns, ',');
	}
}
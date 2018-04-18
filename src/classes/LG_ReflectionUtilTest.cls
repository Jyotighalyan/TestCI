/**
 *Test Class for LG_ReflectionUtil
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class LG_ReflectionUtilTest {
    
    public static testmethod void utiltest(){
        
        test.startTest();
         Set<String> fields=new Set<string>();
        LG_ReflectionUtil.getColumns(fields);
       
        string prefix='';
        LG_ReflectionUtil.getColumns(fields, prefix);
        //String[] types
        //LG_ReflectionUtil.getObjectFieldsMap(types);
        test.stopTest();
        
    }

}
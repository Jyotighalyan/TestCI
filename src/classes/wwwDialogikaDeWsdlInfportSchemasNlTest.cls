@Istest
public class wwwDialogikaDeWsdlInfportSchemasNlTest {
    public static testmethod void daigtest(){
        wwwDialogikaDeWsdlInfportSchemasNl.LookupNumberRequest_element elemt=new  wwwDialogikaDeWsdlInfportSchemasNl.LookupNumberRequest_element();
        elemt.phoneNumber='1234567891';
       
        //tNumberLookup
        wwwDialogikaDeWsdlInfportSchemasNl.LookupNumberResponse_element respelement=new wwwDialogikaDeWsdlInfportSchemasNl.LookupNumberResponse_element();
        
        wwwDialogikaDeWsdlInfportSchemasNl.tNumberLookup element=new  wwwDialogikaDeWsdlInfportSchemasNl.tNumberLookup();
        element.phoneNumber='phone number';
        element.portId='port id';
        element.numberType='number type';
       Datetime myDateTime = Datetime.newInstance(1960, 2, 17);
            element.modifiedDate=myDateTime;
        element.modifier='modifier';
        
    
    }
    

}
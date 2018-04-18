/**
* Used as a utility class for fetching (and releasing)
* available numbers from Cramer (by using WS calls)
*
* @author Tomislav Blazek
* @ticket SFDT-823
* @since  2/6/2016
*/

public class LG_NumberReservationUtil {

    public static final String NUMBER_STATUS_AVAILABLE = LG_PhoneNumbersIntegrationVariables__c.getAll().get('LG_NumberStatusAvailable').LG_Value__c;
    public static final String NUMBER_STATUS_ALLOCATED = LG_PhoneNumbersIntegrationVariables__c.getAll().get('LG_NumberStatusAllocated').LG_Value__c;
    public static final Integer SIZE_OF_NUMBERS_TO_SHOW = Integer.valueOf(LG_PhoneNumbersIntegrationVariables__c.getAll().get('LG_NumberOfShownNumbers').LG_Value__c);
    public static string scriptvar{get;set;}

    public static String areaCode {get;set;}
    public static cscrm__Address__c premiseaddress;
    public static UM_Area_Code__c CustomSetList;




    /*public static List<String> fetchAvailableNumbers(Integer blockTypeSize, Boolean random, String pAreaCode, String region)
    {
        List<String> numbers = new List<String>();

        try{
            InfoportServiceConnection__c connection = InfoportServiceConnection__c.getInstance();
            infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
            pbWebservice.endpoint_x = connection.Connection_URL__c; //'http://172.25.46.55:8001/infportWebservice12/ipWS';
            pbWebservice.inputHttpHeaders_x = new Map<String, String>();
            pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);

            System.debug('*** endpoint='+pbWebservice.endpoint_x);

            if(connection.Session_Timeout__c!=null)
                pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);

            //System.debug('POSTCODE==>'+postalCode);
            //CustomSetList= [SELECT UM_AreaCode__c FROM UM_Area_Code__c where UM_PostCode__c=:postalCode];
            if(pAreaCode!=null)
            {
                areaCode=pAreaCode.substring(1);
                System.debug('AREACODEINUTIL==>'+areaCode);
                wwwDialogikaDeWsdlInfportSchemasSp.GetFreeNumbersResponse_element resp = pbWebservice.getFreeNumbers(areaCode,'TK',null,null,null,null,blockTypeSize,50,null,region,null,null,connection.Authentication_Token__c);


                for (wwwDialogikaDeWsdlInfportSchemasSf.tifnPhone p : resp.freeNrsList.phone){
                    numbers.add(p.startNumber+'-'+p.endNumber);
                }

                return numbers;
            }
            else
            {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Area Code is mandatory.'));
                return numbers;
            }
        }
        catch(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage());
            ApexPages.addMessage(myMsg);
            return numbers;
        }

  }

    public static void activatePhoneRequest(string prefix,String startNumber, string endNumber,string reservationKey, string customerNumber, string region){
        InfoportServiceConnection__c connection = InfoportServiceConnection__c.getInstance();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        pbWebservice.endpoint_x = connection.Connection_URL__c; //'http://172.25.46.55:8001/infportWebservice12/ipWS';
        pbWebservice.inputHttpHeaders_x = new Map<String, String>();
        pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);
        if(connection.Session_Timeout__c!=null)
          pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);

        wwwDialogikaDeWsdlInfportSchemasSp.taExtensionPhone phones = new wwwDialogikaDeWsdlInfportSchemasSp.taExtensionPhone();
        wwwDialogikaDeWsdlInfportSchemasSp.tIActivateInfo rInfo = new wwwDialogikaDeWsdlInfportSchemasSp.tIActivateInfo();
        rInfo.reservationKey = reservationKey;
        rInfo.clientId = customerNumber;
        rInfo.portDate = Date.today();

        wwwDialogikaDeWsdlInfportSchemasSp.tExtensionPhone tPhone = new wwwDialogikaDeWsdlInfportSchemasSp.tExtensionPhone();
        phones.phone = new list<wwwDialogikaDeWsdlInfportSchemasSp.tExtensionPhone>();

        tPhone.prefix= prefix;
        integer iLength = prefix.length();
        tPhone.startNumber = startNumber.substring(iLength);
        tPhone.endNumber = endNumber.substring(iLength);
        phones.phone.add(tPhone);
        try{
            pbWebservice.activateOwnNumbers(phones,rInfo,null,null,null,region,null,null,connection.Authentication_Token__c);
        }catch(Exception e){
            System.debug('**** Error: '+e.getMessage() + ' trace ='+e.getStackTraceString());
        }
    }*/

    public static map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> fetchNetworkOperatorsList(string region){
        map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> networkOperators = new map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier>();
        InfoportServiceConnection__c connection = InfoportServiceConnection__c.getInstance();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        pbWebservice.endpoint_x = connection.Connection_URL__c; //'http://172.25.46.55:8001/infportWebservice12/ipWS';
        pbWebservice.inputHttpHeaders_x = new Map<String, String>();
        pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);

        System.debug('*** endpoint='+pbWebservice.endpoint_x);

        if(connection.Session_Timeout__c!=null)
            pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);
        try{
            if(Test.isRunningTest()){
                list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> carriers = UM_NetworkOperatorsListCtrlTest.getOperatorData();
                networkOperators.put(carriers[0].mainPortId,carriers[0]);
            }else{
                wwwDialogikaDeWsdlInfportSchemasSf.GetAllCarriersResponse_element resp = pbWebService.getAllCarriers(region,null,null,connection.Authentication_Token__c);
                for(wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier carrier: resp.fnCarriers.carrier){
                    networkOperators.put(carrier.mainPortId,carrier);
                }
            }
        }catch(exception e){
            System.debug('***** Error: '+e.getMessage());
            return null;
        }
        return networkOperators;
    }
}
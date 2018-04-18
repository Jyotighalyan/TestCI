@isTest
public class wwwDialogikaDeWsdlInfportSchemasSfTest {
    
    public static testmethod void schematest(){
        
        test.startTest();
        wwwDialogikaDeWsdlInfportSchemasSf.tICarriers carr=new  wwwDialogikaDeWsdlInfportSchemasSf.tICarriers();
        wwwDialogikaDeWsdlInfportSchemasSf.ActivateOwnNumberRequest_element act=new wwwDialogikaDeWsdlInfportSchemasSf.ActivateOwnNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.DeactivateNumberRequest_element deact=new wwwDialogikaDeWsdlInfportSchemasSf.DeactivateNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.DeleteOwnOpenMessageRequest_element del=new wwwDialogikaDeWsdlInfportSchemasSf.DeleteOwnOpenMessageRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.ExportNumberRequest_element expt=new wwwDialogikaDeWsdlInfportSchemasSf.ExportNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetAllCarriersResponse_element carrier=new wwwDialogikaDeWsdlInfportSchemasSf.GetAllCarriersResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetByClientIdRequest_element clnt=new wwwDialogikaDeWsdlInfportSchemasSf.GetByClientIdRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetByClientIdResponse_element resp=new  wwwDialogikaDeWsdlInfportSchemasSf.GetByClientIdResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetByContractNumberRequest_element numbreq=new wwwDialogikaDeWsdlInfportSchemasSf.GetByContractNumberRequest_element(); 
        wwwDialogikaDeWsdlInfportSchemasSf.GetByContractNumberResponse_element numbresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetByContractNumberResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCarrierRequest_element carrreq=new wwwDialogikaDeWsdlInfportSchemasSf.GetCarrierRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCarrierResponse_element carrresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetCarrierResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCarriersByPortIdRequest_element carrport=new wwwDialogikaDeWsdlInfportSchemasSf.GetCarriersByPortIdRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCarriersByPortIdResponse_element carrresp1=new wwwDialogikaDeWsdlInfportSchemasSf.GetCarriersByPortIdResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCurrentRequest_element getcurrntreq=new wwwDialogikaDeWsdlInfportSchemasSf.GetCurrentRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetCurrentResponse_element getrespele=new wwwDialogikaDeWsdlInfportSchemasSf.GetCurrentResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetDeactivatedNumbersRequest_element getdeact=new wwwDialogikaDeWsdlInfportSchemasSf.GetDeactivatedNumbersRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetDeactivatedNumbersResponse_element getderesp=new wwwDialogikaDeWsdlInfportSchemasSf.GetDeactivatedNumbersResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetGlobalHistoryRequest_element getglobal=new wwwDialogikaDeWsdlInfportSchemasSf.GetGlobalHistoryRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetGlobalHistoryResponse_element getglobalresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetGlobalHistoryResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryByClientIdRequest_element hsitclient=new  wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryByClientIdRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryByClientIdResponse_element hstresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryByClientIdResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryRequest_element histreq=new wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryResponse_element histresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetHistoryResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetIncompletePortedNumbersRequest_element incomplport=new wwwDialogikaDeWsdlInfportSchemasSf.GetIncompletePortedNumbersRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetIncompletePortedNumbersResponse_element incomplresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetIncompletePortedNumbersResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetLocalStateOfNumberRequest_element localst=new wwwDialogikaDeWsdlInfportSchemasSf.GetLocalStateOfNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetLocalStateOfNumberResponse_element localresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetLocalStateOfNumberResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetOpenPortingsRequest_element openport=new wwwDialogikaDeWsdlInfportSchemasSf.GetOpenPortingsRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetOpenPortingsResponse_element openresp=new  wwwDialogikaDeWsdlInfportSchemasSf.GetOpenPortingsResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetOwnReturnedNumbersRequest_element ownret=new wwwDialogikaDeWsdlInfportSchemasSf.GetOwnReturnedNumbersRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.GetOwnReturnedNumbersResponse_element getnumresp=new wwwDialogikaDeWsdlInfportSchemasSf.GetOwnReturnedNumbersResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.ImportNumberRequest_element impnum=new wwwDialogikaDeWsdlInfportSchemasSf.ImportNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.IsOpenRequest_element openreq=new wwwDialogikaDeWsdlInfportSchemasSf.IsOpenRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.IsOpenResponse_element openresp1=new wwwDialogikaDeWsdlInfportSchemasSf.IsOpenResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.ReactivateNumberRequest_element reactnumb=new wwwDialogikaDeWsdlInfportSchemasSf.ReactivateNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.ReactivateNumberRequest_element reanumb=new wwwDialogikaDeWsdlInfportSchemasSf.ReactivateNumberRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.SelectRequest_element selectreq=new wwwDialogikaDeWsdlInfportSchemasSf.SelectRequest_element();
        wwwDialogikaDeWsdlInfportSchemasSf.SelectResponse_element selectresp=new wwwDialogikaDeWsdlInfportSchemasSf.SelectResponse_element();
        wwwDialogikaDeWsdlInfportSchemasSf.taFnCarrier carr2=new wwwDialogikaDeWsdlInfportSchemasSf.taFnCarrier();
        wwwDialogikaDeWsdlInfportSchemasSf.taIFnPhone phon=new wwwDialogikaDeWsdlInfportSchemasSf.taIFnPhone();
        wwwDialogikaDeWsdlInfportSchemasSf.tCarrier car=new wwwDialogikaDeWsdlInfportSchemasSf.tCarrier();
        wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier facr=new wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier();
        wwwDialogikaDeWsdlInfportSchemasSf.tIAcceptInfo accpt=new wwwDialogikaDeWsdlInfportSchemasSf.tIAcceptInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tIActivateInfo act2=new  wwwDialogikaDeWsdlInfportSchemasSf.tIActivateInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tICarriers icarr=new wwwDialogikaDeWsdlInfportSchemasSf.tICarriers();
        wwwDialogikaDeWsdlInfportSchemasSf.tIDeactivationInfo deactinfo=new  wwwDialogikaDeWsdlInfportSchemasSf.tIDeactivationInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tIExportInfo expt2=new  wwwDialogikaDeWsdlInfportSchemasSf.tIExportInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tIFnPhone phn=new wwwDialogikaDeWsdlInfportSchemasSf.tIFnPhone();
        wwwDialogikaDeWsdlInfportSchemasSf.tIFnPortedNumber portnum=new wwwDialogikaDeWsdlInfportSchemasSf.tIFnPortedNumber();
        wwwDialogikaDeWsdlInfportSchemasSf.tIImportInfo imptinfo=new  wwwDialogikaDeWsdlInfportSchemasSf.tIImportInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tISimpleInfo simpinfo=new wwwDialogikaDeWsdlInfportSchemasSf.tISimpleInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tIUpdateInfo uptinfo=new wwwDialogikaDeWsdlInfportSchemasSf.tIUpdateInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tSelectInfo selectinfo=new wwwDialogikaDeWsdlInfportSchemasSf.tSelectInfo();
        wwwDialogikaDeWsdlInfportSchemasSf.tSelectionResult selectresult=new  wwwDialogikaDeWsdlInfportSchemasSf.tSelectionResult();
        wwwDialogikaDeWsdlInfportSchemasSf.UpdateCarrierRequest_element uptcarr=new   wwwDialogikaDeWsdlInfportSchemasSf.UpdateCarrierRequest_element();
        
        
        test.stopTest();
        
    }
    
}
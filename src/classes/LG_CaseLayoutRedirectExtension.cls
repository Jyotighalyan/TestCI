public class LG_CaseLayoutRedirectExtension {
    
    @TestVisible
    private final Case cs { get; set; }

    public LG_CaseLayoutRedirectExtension (ApexPages.StandardController controller){
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>{'LG_Solution__c','Contact','Type','RecordType.Name','LG_Order__c','Subject','Owner','CaseNumber'};
            controller.addFields(defaultFields);
            this.cs = (Case)controller.getRecord();

            System.debug('Case==>' + this.cs);
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, Type, ContactId, LG_Order__c, RecordType.Name from Case LIMIT 1];
        }
    }
    
    //Redirect to the Case Record type's VF page
    public PageReference redirect(){
        String url = getRedirectURL();
        //system.debug('URL----->'+url);
        return new PageReference(url);
         
    }
    
    
    /***
     * SFOM-536
     * To fetch the Custom page URL for Case record Type
     **/
    private String getRedirectURL(){
        //List<RecordType> rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case'];
        String URL = '';
        boolean customRecord = false;
        Integer recordPosition = -1;
        
            for(String recordType: recordTypeList){
                recordPosition++;
                if(recordType == cs.RecordType.Name){
                system.debug('recordType' + cs.RecordType.Name);
                    customRecord = true;
                    break;
                }
            }
        system.debug('custom Record' + customRecord);
        if(customRecord){
            if(cs.RecordType.Name == recordTypeList[recordPosition]){
                URL = '/apex/'+recordLytList[recordPosition]+'?id='+cs.Id;
            }else{
                URL = '/'+cs.Id+'?nooverride=1';
            }
        }else{
            URL = '/'+cs.Id+'?nooverride=1';
        }
        
        
        return URL;
    }

private Integer ASSIGNOWNER = 0;
private Integer SCHEDULEAPPOINTMENT = 1;
private String STR_LAYOUTA = 'LG_CaseLayoutA';
private String STR_LAYOUTB = 'LG_CaseLayoutB';
private String STR_LAYOUTC = 'LG_CaseLayoutC';
private String STR_LAYOUTD = 'LG_CaseLayoutD';
private String STR_LAYOUTE = 'LG_CaseLayoutE';
private String STR_LAYOUTF = 'LG_CaseLayoutF';
private String STR_LAYOUTG = 'LG_CaseLayoutG';
    
//Assign Layout type to the CASE Record Type
private String PAGE_ACTIVATESERVICE = STR_LAYOUTA;
private String PAGE_ASSIGNORDEROWNER = STR_LAYOUTB;
private String PAGE_ASSIGNOWNER = STR_LAYOUTB;
private String PAGE_CONTACTCUSTOMER = STR_LAYOUTC;    
private String PAGE_FOLLOWONORDER = STR_LAYOUTD;    
private String PAGE_INFLIGHTCONFIG = STR_LAYOUTA;    
private String PAGE_INSTALL = STR_LAYOUTA;
private String PAGE_JEOPARDY = STR_LAYOUTF;    
private String PAGE_MANAGESUBSCR = STR_LAYOUTA;
private String PAGE_MANAGENUMBER = STR_LAYOUTE;
private String PAGE_NUMBERPORT = STR_LAYOUTA;
private String PAGE_ORDERCANCELREQ = STR_LAYOUTF;
private String PAGE_PROVISION = STR_LAYOUTA;    
private String PAGE_SCHEDULEAPP = STR_LAYOUTE;    
private String PAGE_ACCESSPLANNING = STR_LAYOUTA;    
private String PAGE_LEGACYFULFILMENT = STR_LAYOUTD;
private String PAGE_CAMAPENDINGORDER = STR_LAYOUTD;
private String PAGE_PROVISIONONESTEP = STR_LAYOUTG;
private String PAGE_CAMACUSTOMERTYPE = STR_LAYOUTD; 
private String PAGE_MANAGETENANT = STR_LAYOUTD;
private String PAGE_COORDINATE = STR_LAYOUTE;
private String PAGE_MANAGELOGISTICS = STR_LAYOUTA;
private String PAGE_TERMINATEBDS= STR_LAYOUTG;
private String PAGE_MANAGEASSET = STR_LAYOUTA;


    //SFOM-796 Case layout STR_LAYOUTD is added for 'Legacy Fulfilment' Case record Type : Added by - Ankur Gupta 
private String[] recordTypeList = new String[]{'Activate Service','Assign Order Owner','Assign Owner','Contact Customer','Follow-On Order','Inflight Configuration','Install','Jeopardy',
                                'Manage Subscriptions','Manage Numbers','Number Port','Order Cancel Request','Provision','Schedule Appointment','Access Planning', 'Legacy Fulfilment',
                                'Cama PendingOrder','Provision One Step','Cama Customer Type','Manage Tenant','Coordinate','Manage Logistics','Terminate','Manage Assets'};
private String[] recordLytList = new String[]{PAGE_ACTIVATESERVICE, PAGE_ASSIGNORDEROWNER, PAGE_ASSIGNOWNER, PAGE_CONTACTCUSTOMER, PAGE_FOLLOWONORDER, PAGE_INFLIGHTCONFIG, PAGE_INSTALL, PAGE_JEOPARDY, 
                                PAGE_MANAGESUBSCR, PAGE_MANAGENUMBER, PAGE_NUMBERPORT, PAGE_ORDERCANCELREQ, PAGE_PROVISION, PAGE_SCHEDULEAPP, PAGE_ACCESSPLANNING, PAGE_LEGACYFULFILMENT,
                                PAGE_CAMAPENDINGORDER,PAGE_PROVISIONONESTEP,PAGE_CAMACUSTOMERTYPE,PAGE_MANAGETENANT, PAGE_COORDINATE,PAGE_MANAGELOGISTICS,PAGE_TERMINATEBDS,PAGE_MANAGEASSET };

}
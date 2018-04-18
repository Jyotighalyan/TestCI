/**
* getOpenOrders for polling to send to camma
* @author Sathya.b
* @ticket SFOM-728
* @since  30/6/2017
*
*`New Version:
* @author Ankur Gupta
* @ticket SFOM-2297
* @since  13/12/2017
*/

@RestResource(urlMapping='/UM_GetOpenWorkOrders')
global with sharing class UM_getOpenWorkOrders
{   
    
    @HttpGet
    global static ResponseWrapper getOpenOrders()
    {  
        String formatedAgreedDate;
        List<csord__Solution__c> openSolutionList = new List<csord__Solution__c>();
        ResponseWrapper response = new ResponseWrapper(); 
        List<openWOwrapper> woWrap = new List<openWOwrapper>(); 
        
        try
        {       
            //loop through solutions
            for(csord__Solution__c  s : [SELECT id, LG_Address__r.cscrm__State_Province__c,LG_ProvisioningAccountNo__c,
                                         LG_ProvisioningWorkOrder__c, (SELECT LG_AgreedInstallDate__c FROM Schedule_Appointment__r )
                                         FROM csord__Solution__c 
                                         WHERE LG_Integration_Status__c='Work Order Created'])
            {
                formatedAgreedDate = '';
                if(s.Schedule_Appointment__r.size()>0)
                {
                    for(LG_ScheduleAppointment__c app : s.Schedule_Appointment__r )   
                    {
                        if(app.LG_AgreedInstallDate__c != null)
                        {
                            //format date into yyyymmdd
                            Date agreeDate = app.LG_AgreedInstallDate__c;
                            formatedAgreedDate = Datetime.newInstance(agreeDate.year(), agreeDate.month(), agreeDate.day()).format('YYYYMMdd');
                            System.debug('formatedAgreedDate# ' + formatedAgreedDate);
                        }
                    }
                }
                
                //if no sch,adding values to wrapper with agree install Date as nulll
                if(String.isBlank(formatedAgreedDate))
                {
                    system.debug('--new Solutions# '+s.id);
                    woWrap.add(new openWOwrapper(s.LG_Address__r.cscrm__State_Province__c,s.LG_ProvisioningAccountNo__c,s.LG_ProvisioningWorkOrder__c,null));  
                }
                else
                {
                    woWrap.add(new openWOwrapper(s.LG_Address__r.cscrm__State_Province__c,s.LG_ProvisioningAccountNo__c,s.LG_ProvisioningWorkOrder__c,formatedAgreedDate ));           
                    system.debug('--woWrap : '+woWrap);
                }
                
            }
            //final wrapper class to be sent with status
            
            if(!woWrap.isEmpty())
            {
                response.status ='Success';
                response.statusMessage ='Success';
                response.WorkOrder = woWrap;
            }
            else
            {
                response.status ='Failure';
                response.statusMessage ='Failure';
                response.WorkOrder = null;
            }
        }
        catch(Exception e )
        {
            response.status ='Failure';
            response.statusMessage = 'SFDC Internal Error Occured: ' + e.getMessage();
            response.WorkOrder = null;
        }
        System.debug('res # ' + response);
        return response; 
    }
    
    //Wrapper class to send solutionlist along with status/Message
    global class ResponseWrapper
    {
        public String status { get; set; }
        public String statusMessage{ get; set; }
        public List<openWOwrapper> WorkOrder{set;get;} 
    }
    
    global class openWOwrapper
    {
        public String region {set;get;}
        public String accountNumber {set;get;}
        public String workOrderNo {set;get;}
        public String scheduleDate {set;get;}
        
        global openWOwrapper(String region, String accountNumber, String workOrderNo, String scheduleDate)
        {
            this.region        = region;
            this.accountNumber = accountNumber;
            this.workOrderNo   = workOrderNo;
            this.scheduleDate  = scheduleDate;
        }
    }
}
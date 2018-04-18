@isTest
private class UM_VWStagingFeedUtilTest {
    public static string accountNumber;
    public static void dataSetup()
    {
        //insert billing account and premise address
        Account acc=new Account(Name='SampleAccount',LG_ChamberOfCommerceNumber__c='1223');
        insert acc;
        
        csconta__Billing_Account__c bac=new csconta__Billing_Account__c(LG_State__c='NRW',csconta__Account__c=acc.Id);
        cscrm__Address__c lac=new cscrm__Address__c(LG_AddressID__c='10778710',cscrm__Country__c='Germany');
        
        Database.insert(new SObject[]{bac,lac});
        
        List<cscrm__Address__c> lacs=[Select Id,LG_PremiseNumber__c from cscrm__Address__c where Id=:lac.Id];
        System.debug('Auto generated number is >> ' + lacs.get(0).LG_PremiseNumber__c);
        
        List<csconta__Billing_Account__c> bacs=[Select Id,LG_BillingAccountNumber__c from csconta__Billing_Account__c where Id=:bac.Id];
        accountNumber=bacs.get(0).LG_BillingAccountNumber__c+'|'+lacs.get(0).LG_PremiseNumber__c+'|NRW'+'|UAT';
        System.debug('account number :'+accountNumber);
        
        Date validfrom=date.today();
        
        csconta__Contract__c con =new csconta__Contract__c(csconta__Account__c=acc.Id,
                                                           csconta__Valid_From__c=validfrom,
                                                           csconta__Valid_To__c=validfrom.addYears(2)
                                                          );
        insert con;
        csord__Subscription__c sub=new csord__Subscription__c(name='Virtual Voice Kundensetup',
                                                              csconta__Billing_Account__c=bacs.get(0).Id,
                                                              LG_Address__c=lac.Id,
                                                              csord__Identification__c='Identification_Id',
                                                              csord__Account__c=acc.Id,
                                                              csord__Status__c='Active',
                                                              LG_Contract__c=con.id );
        insert sub;
        
        csord__Service__c serv1=new csord__Service__c(Name = 'Virtual Voice Kundensetup',
                                                      csord__Subscription__c=sub.Id,
                                                      LG_Address__c=lac.Id,
                                                      csord__Identification__c='Identification'+sub.Id,
                                                      csord__Activation_Date__c=validfrom.addDays(-5),
                                                      LG_SLA__c='Bronze',
                                                      LG_ServiceStatus__c='Active',
                                                      csord__Status__c='Active',
                                                      LG_ProductFamily__c = 'Virtual Voice');
        insert serv1;
        
        cspmb__Price_Item__c cpi1=new cspmb__Price_Item__c(Name='Premium', cspmb__Price_Item_Description__c='Premium',cspmb__One_Off_Charge__c=0,cspmb__Recurring_Charge__c=490,
                                                UM_VoiceworksOneOffChargeID__c='', UM_VoiceworksRecurringChargeID__c='654', cspmb__Is_Active__c = true,
                                                   cspmb__One_Off_Charge_External_Id__c='2202', cspmb__Recurring_Charge_External_Id__c='2203');
       cspmb__Price_Item__c cpi2=new cspmb__Price_Item__c(Name='IVR', cspmb__Price_Item_Description__c='IVR',cspmb__One_Off_Charge__c=4990,cspmb__Recurring_Charge__c=490,
                                                UM_VoiceworksOneOffChargeID__c='24100', UM_VoiceworksRecurringChargeID__c='23978', cspmb__Is_Active__c = true,
                                                   cspmb__One_Off_Charge_External_Id__c='2212', cspmb__Recurring_Charge_External_Id__c='2213');
        cspmb__Price_Item__c cpi3=new cspmb__Price_Item__c(Name='eFax IN', cspmb__Price_Item_Description__c='eFax IN',cspmb__One_Off_Charge__c=990,cspmb__Recurring_Charge__c=90,
                                                UM_VoiceworksOneOffChargeID__c='24365', UM_VoiceworksRecurringChargeID__c='23980', cspmb__Is_Active__c = true,
                                                   cspmb__One_Off_Charge_External_Id__c='2214', cspmb__Recurring_Charge_External_Id__c='2215');
        cspmb__Price_Item__c cpi4=new cspmb__Price_Item__c(Name='IVR (Interactive Voice Response) IVR (Interactive Voice Response)', cspmb__Price_Item_Description__c='IVR (Interactive Voice Response) IVR (Interactive Voice Response) IVR (Interactive Voice Response)',cspmb__One_Off_Charge__c=0,cspmb__Recurring_Charge__c=490,
                                                UM_VoiceworksOneOffChargeID__c='12000', UM_VoiceworksRecurringChargeID__c='12001', cspmb__Is_Active__c = true,
                                                   cspmb__One_Off_Charge_External_Id__c='12202', cspmb__Recurring_Charge_External_Id__c='12203', UM_VoiceworksMoreServices__c=True);
        cspmb__Price_Item__c cpi5=new cspmb__Price_Item__c(Name='Virtual Voice Port', cspmb__Price_Item_Description__c='Virtual Voice Port',cspmb__One_Off_Charge__c=990,cspmb__Recurring_Charge__c=180,
                                                UM_VoiceworksOneOffChargeID__c='353', UM_VoiceworksRecurringChargeID__c='686', cspmb__Is_Active__c = true,
                                                   cspmb__One_Off_Charge_External_Id__c='2778', cspmb__Recurring_Charge_External_Id__c='2777', UM_NumberOfUnitsRequired__c=True, 
                                                   UM_UnitType__c= 'Channel');
                                                                                              
        cspmb__Add_On_Price_Item__c aopi1=new cspmb__Add_On_Price_Item__c(Name='Eintrag ins Telefonbuch', 
                                                                        cspmb__Add_On_Price_Item_Description__c='Eintrag ins Telefonbuch',
                                                                        cspmb__One_Off_Charge__c=41,
                                                                         UM_VoiceworksRecurringChargeID__c='4111951',
                                                                        cspmb__One_Off_Charge_External_Id__c='2410',
                                                                         cspmb__Is_Active__c = true);
        cspmb__Add_On_Price_Item__c aopi2=new cspmb__Add_On_Price_Item__c(Name='UC Call Manager UC Call Manager UC Call Manager', 
                                                                        cspmb__Add_On_Price_Item_Description__c='UC Call Manager UC Call Manager UC Call Manager UC Call Manager UC Call Manager',
                                                                        cspmb__One_Off_Charge__c=99,
                                                                        cspmb__Recurring_Charge__c=99,
                                                                         UM_VoiceworksRecurringChargeID__c='90', 
                                                                        cspmb__One_Off_Charge_External_Id__c='2240', 
                                                                        cspmb__Recurring_Charge_External_Id__c='2241',
                                                                        cspmb__Is_Active__c = true);
        cspmb__Add_On_Price_Item__c aopi3=new cspmb__Add_On_Price_Item__c(Name='Allnet-Flat für Premium', 
                                                                        cspmb__Add_On_Price_Item_Description__c='Allnet-Flat für Premium',
                                                                        cspmb__One_Off_Charge__c=99,
                                                                        cspmb__Recurring_Charge__c=90,
                                                                         UM_VoiceworksRecurringChargeID__c='652', 
                                                                        cspmb__One_Off_Charge_External_Id__c='2230', 
                                                                        cspmb__Recurring_Charge_External_Id__c='2231',
                                                                         UM_Create_Additional_Line_Item__c=true,
                                                                         cspmb__Is_Active__c = true);
        cspmb__Add_On_Price_Item__c aopi4=new cspmb__Add_On_Price_Item__c(Name='Gigaset Pro S650H handset', 
                                                                        cspmb__Add_On_Price_Item_Description__c='Gigaset Pro S650H handset',
                                                                        cspmb__One_Off_Charge__c=70,
                                                                         UM_VoiceworksOneOffChargeID__c='40396', 
                                                                        cspmb__One_Off_Charge_External_Id__c='2458', 
                                                                        UM_VoiceworksMoreServices__c=True,
                                                                        cspmb__Is_Active__c = true);
        cspmb__Add_On_Price_Item__c aopi5=new cspmb__Add_On_Price_Item__c(Name='Gigaset Pro S650H handset1', 
                                                                        cspmb__Add_On_Price_Item_Description__c='Gigaset Pro S650H handset1',
                                                                        cspmb__One_Off_Charge__c=71,
                                                                         UM_VoiceworksOneOffChargeID__c='24171', 
                                                                        cspmb__One_Off_Charge_External_Id__c='2450',
                                                                        UM_VoiceworksMoreServices__c=True,cspmb__Is_Active__c = true);
        cspmb__Add_On_Price_Item__c aopi6 = new cspmb__Add_On_Price_Item__c(Name='Virtual Voice Festnetzpaket 5.000 Min.', 
                                                                        cspmb__Add_On_Price_Item_Description__c='Virtual Voice Festnetzpaket 5.000 Min.',
                                                                        cspmb__One_Off_Charge__c=990,
                                                                        cspmb__Recurring_Charge__c=45,
                                                                        UM_VoiceworksRecurringChargeID__c='593', 
                                                                        cspmb__One_Off_Charge_External_Id__c='2915',
                                                                        cspmb__Recurring_Charge_External_Id__c='2914',
                                                                        UM_Create_Additional_Line_Item__c=true,
                                                                        cspmb__Is_Active__c = true);                                                                
        
        Database.insert(new sObject[]{cpi1,cpi2,cpi3,cpi4,cpi5,aopi6 ,aopi5,aopi4,aopi3,aopi2,aopi1});  
    }
    
    @isTest
    public static void testMethod1(){
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
            
            if(vws.UM_VoiceWorksObjectId__c == '11111111' || vws.UM_VoiceWorksObjectId__c == '22222222')
            {
                vws.UM_Enddate__c = date.today();
            }
        }
        update ls;
        
        UM_VW_Staging_Feed__c vw1=new UM_VW_Staging_Feed__c();
        vw1.UM_StoreOrderNumber__c='20170057';
        vw1.UM_Brand__c='Mitel';
        vw1.UM_Model__c='6867I';
        vw1.UM_MAC__c='0D09520963';
        vw1.UM_Serial__c='101900142385';
        vw1.UM_HardwareType__c='DeskPhone';
        vw1.UM_ExportType__c='Hardware';
        vw1.UM_TransactionId__c = '5555';
        insert vw1;
        
        Test.startTest();
        try{
        UM_VWStagingFeedUtil.InvokeBatchProcessStagingData(new list<string>{'5555'});
        }catch(exception ex){}
        Test.stopTest();
    }
    
    
    static testMethod void testMethod2(){
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;

        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<UM_VW_Staging_Feed__c> vwsList1=Database.Query(query);
        boolean wrongAcc = false;
        for(UM_VW_Staging_Feed__c v: vwsList1)
        {
            v.UM_Status__c='New';
            if(wrongAcc)
                v.UM_AccountNumber__c='12312423|8888666';
        }
        update vwsList1;
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }

    
    static testMethod void testMethod3(){
        
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<csord__Service__c> serList=[Select id,LG_ServiceStatus__c,csord__Status__c from csord__Service__c WHERE UM_VoiceWorksObjectId__c != null];
        for(csord__Service__c ser: serList)
        {
            ser.LG_ServiceStatus__c='Active';
            ser.csord__Status__c='Active';
        }
        update serList;
        
        List<UM_VW_Staging_Feed__c> vwsList1=Database.Query(query);
        
        for(UM_VW_Staging_Feed__c v: vwsList1)
        {
            v.UM_Status__c='New';
            v.UM_Enddate__c=System.today();
            v.UM_ProcessLater__c = true;
        }
        update vwsList1;
        
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }
    
    
    static testMethod void testMethod6(){
        
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<csord__Service__c> serList=[Select id,LG_ServiceStatus__c,csord__Status__c from csord__Service__c WHERE UM_SubscriberID__c != null AND csord__Service__c != null];
        for(csord__Service__c ser: serList)
        {
            ser.LG_ServiceStatus__c='Active';
            ser.csord__Status__c='Active';
        }
        update serList;
        
        List<UM_VW_Staging_Feed__c> vwsList1=Database.Query(query);
        
        for(UM_VW_Staging_Feed__c v: vwsList1)
        {
            v.UM_Status__c='New';
            v.UM_Enddate__c=System.today();
            v.UM_ProcessLater__c = true;
        }
        update vwsList1;
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }
    
    
    static testMethod void testMethod7(){
        
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<csord__Service__c> serList=[Select id,LG_ServiceStatus__c,csord__Status__c from csord__Service__c WHERE UM_VoiceWorksObjectId__c = '301408'];
        for(csord__Service__c ser: serList)
        {
            ser.LG_ServiceStatus__c='Active';
            ser.csord__Status__c='Active';
        }
        update serList;
        
        List<UM_VW_Staging_Feed__c> vwsList1=Database.Query(query);
        
        for(UM_VW_Staging_Feed__c v: vwsList1)
        {
            if(v.UM_VoiceWorksObjectId__c == '301408'){
                v.UM_Status__c='New';
                v.UM_Enddate__c=System.today();
                v.UM_ProcessLater__c = true;
            }
        }
        update vwsList1;
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }
    
    static testMethod void testMethod5(){
        
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<csord__Service__c> serList=[Select id,LG_ServiceStatus__c,csord__Status__c from csord__Service__c WHERE UM_SubscriberId__c != null AND csord__Service__c = null];
        for(csord__Service__c ser: serList)
        {
            ser.LG_ServiceStatus__c='Active';
            ser.csord__Status__c='Active';
            ser.UM_SubscriberName__c = 'test 1';
        }
        update serList;
        
        List<UM_VW_Staging_Feed__c> vwsList1=Database.Query(query);
        
        for(UM_VW_Staging_Feed__c v: vwsList1)
        {
            v.UM_Status__c='New';
            v.UM_DescriptionChanged__c = '1';
            v.UM_ProcessLater__c = true;
        }
        update vwsList1;
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }
    
    
    static testMethod void testMethod4()
    {
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        for(UM_VW_Staging_Feed__c vws : ls){
            System.debug('acount ' + accountNumber);
            vws.UM_AccountNumber__c=accountNumber;
            vws.UM_Startdate__c=date.today();
        }
        update ls;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
        
        Test.startTest();
        List<csord__Service__c> serList=[Select id,LG_ServiceStatus__c,csord__Status__c from csord__Service__c WHERE UM_StoreOrderNumber__c = '20170057'];
        for(csord__Service__c ser: serList)
        {
            ser.LG_ServiceStatus__c='Active';
            ser.csord__Status__c='Active';
        }
        update serList;
        
        UM_VW_Staging_Feed__c vw1=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw2=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw3=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                                    UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw4=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                                    UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw5=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw6=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        
        UM_VW_Staging_Feed__c vw7=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170111',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        List<UM_VW_Staging_Feed__c> vwsList1=new List<UM_VW_Staging_Feed__c>();
        vwsList1.add(vw1);
        vwsList1.add(vw2);
        vwsList1.add(vw3);
        vwsList1.add(vw4);
        vwsList1.add(vw5);
        vwsList1.add(vw6);
        vwsList1.add(vw7);
        Database.insert(vwsList1);
        
        vwObj.segregateStagingData(vwsList1);
        Test.stopTest();
    }
    
    static testMethod void testMethod8()
    {
        UM_VW_Staging_Feed__c vw1=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        insert vw1;
        
        String subscriberQuery = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c') + 
                                                                ' WHERE UM_Status__c=\'New\' AND UM_Type__c = \'Feed\'' +
                                                                ' AND UM_SubscriberID__c <> null' + 
                                                                ' AND UM_AccountNumber__c <> null';

        UM_VWStagingFeedProcessBatch vwSubscriberBatch = new UM_VWStagingFeedProcessBatch();                                                                
        vwSubscriberBatch.query = subscriberQuery;
        vwSubscriberBatch.processType = 'Subscriber';

        Database.executeBatch(vwSubscriberBatch, 1);
    }
    
    static testMethod void testMethod9()
    {
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        String hardwareQuery = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c') + 
                                                            ' WHERE UM_Status__c=\'New\' AND UM_Type__c = \'Feed\'' +
                                                            ' AND UM_SubscriberID__c = null' + 
                                                            ' AND UM_AccountNumber__c = null' +
                                                            ' AND UM_StoreOrderNumber__c <> null';
        
        UM_VWStagingFeedProcessBatch vwHardwareBatch = new UM_VWStagingFeedProcessBatch();
        vwHardwareBatch.query = hardwareQuery;
        vwHardwareBatch.processType = 'Hardware';
        Database.executeBatch(vwHardwareBatch, 1);
    }
    
    static testMethod void testMethod10()
    {
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.collectSubscriberData(ls);
        
        UM_VW_Staging_Feed__c vw1=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        UM_VW_Staging_Feed__c vw2=new UM_VW_Staging_Feed__c(UM_StoreOrderNumber__c='20170057',UM_Brand__c='Mitel',UM_Model__c='6867I',UM_MAC__c='0D09520963',
                                                            UM_Serial__c='101900142385',UM_ExportType__c='Hardware',UM_TransactionId__c = '4444');
        List<UM_VW_Staging_Feed__c> vwsList=new List<UM_VW_Staging_Feed__c>();
        vwsList.add(vw1);
        vwsList.add(vw2);
        Database.insert(vwsList);
        vwObj.collectHardwareData(vwsList);
    
    }
    static testMethod void testMethod11()
    {
        dataSetup();
        List<UM_VW_Staging_Feed__c> ls = Test.loadData(UM_VW_Staging_Feed__c.sObjectType, 'UM_VW_staging_billing_export_testdataNew');
        
        UM_VW_Staging_Feed__c vws =  ls[0];
        vws.UM_AccountNumber__c='123';
        
        update vws;
        
        String query = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c');
        
        List<UM_VW_Staging_Feed__c> vwsList=Database.Query(query);
        
        UM_VWStagingFeedUtil vwObj = new UM_VWStagingFeedUtil();
        vwObj.segregateStagingData(vwsList);
    }
}

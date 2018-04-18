@istest
public class UM_ServiceHPBX_MACDTest {

    public static string queryForBatchChild;
    public static string queryForBatchParent;
    public static void dataSetup()
    {
        queryForBatchChild = 'SELECT Id, LG_ServiceExternalId__c,csord__Activation_Date__c,csord__Deactivation_Date__c, csord__Service__r.csord__Service__c,csord__Service__r.csord__Activation_Date__c,csord__Status__c, LG_ServiceStatus__c, csordtelcoa__Delta_Status__c,'+
                                            '(SELECT Id,csordtelcoa__Line_Item_Reference_Id__c,csordtelcoa__Delta_Status__c,csord__Service__r.csord__Subscription__c,'+
                                            'UM_Price_Override__c ,csord__Service__c, UM_ServiceItemType__c,'+
                                            'UM_KenanServiceLineId__c,csord__Service__r.csord__Service__c,csord__Line_Description__c,'+
                                            'csord__Service__r.csordtelcoa__Service_Number__c,LG_BillingProductId__c,UM_BillingProductId__c,'+
                                            'csord__Total_Price__c, UM_NumberOfUnits__c, UM_UnitType__c,csord__Is_Recurring__c,'+
                                            'csord__Discount_Value__c,csord__Discount_Type__c,UM_DiscountEndDate__c,'+
                                            'csord__Discounted_Amount__c, UM_ContractId__c,UM_RecurringPriceDiscount__c, '+
                                            'UM_OneOffPriceDiscount__c'+
                                        ' FROM csord__Service_Line_Items__r ORDER BY csord__Service__c)'+
                                    ' FROM csord__Service__c where csord__Service__c != null';
        
         queryForBatchParent = 'SELECT Id, LG_ServiceExternalId__c, csord__Service__c, csord__Subscription__c, csordtelcoa__Delta_Status__c,'+
                                    'csord__Status__c, LG_ServiceStatus__c, csord__Deactivation_Date__c, UM_SubscriberName__c, UM_PhoneExtension__c' +
                                    ' FROM csord__Service__c where csord__Service__c = null';
        //insert billing account and premise address
        Account acc=new Account(Name='SampleAccount',LG_ChamberOfCommerceNumber__c='1223');
        insert acc;
        
        csconta__Billing_Account__c bac=new csconta__Billing_Account__c(LG_State__c='NRW',csconta__Account__c=acc.Id);
        cscrm__Address__c lac=new cscrm__Address__c(LG_AddressID__c='10778710',cscrm__Country__c='Germany');
        
        Database.insert(new SObject[]{bac,lac});
        
        List<cscrm__Address__c> lacs=[Select Id,LG_PremiseNumber__c from cscrm__Address__c where Id=:lac.Id];
        System.debug('Auto generated number is >> ' + lacs.get(0).LG_PremiseNumber__c);
        
        List<csconta__Billing_Account__c> bacs=[Select Id,LG_BillingAccountNumber__c from csconta__Billing_Account__c where Id=:bac.Id];
        
        Date validfrom=date.today();
        
        csconta__Contract__c con =new csconta__Contract__c(csconta__Account__c=acc.Id,
                                                           csconta__Valid_From__c=validfrom,
                                                           csconta__Valid_To__c=validfrom.addYears(2));
        insert con;
        csord__Subscription__c sub=new csord__Subscription__c(name='Virtual Voice Kundensetup',
                                                              csconta__Billing_Account__c=bacs.get(0).Id,
                                                              LG_Address__c=lac.Id,
                                                              csord__Identification__c='Identification_Id',
                                                              UM_SubscriberId__c ='123445', 
                                                              csord__Account__c=acc.Id,
                                                              csord__Status__c='Active',
                                                              LG_Contract__c=con.id );
        insert sub;
        
        csord__Service__c serv1=new csord__Service__c(Name = 'Virtual Voice Kundensetup',
                                                      csord__Subscription__c=sub.Id,
                                                      csord__Identification__c='Identification'+sub.Id,
                                                      csord__Activation_Date__c=validfrom.addDays(-5),
                                                      LG_SLA__c='Bronze',
                                                      LG_ServiceExternalId__c = '35342534',
                                                      LG_ServiceStatus__c='Active',
                                                      csord__Status__c='Active',
                                                      LG_ProductFamily__c='Virtual Voice'
                                                      );
                                                      
        insert serv1;
        
        csord__Service__c serv2=new csord__Service__c(Name = 'Premium',
                                                      csord__Subscription__c=sub.Id,
                                                      csord__Identification__c='Identification'+sub.Id,
                                                      csord__Activation_Date__c=validfrom.addDays(-5),
                                                      LG_SLA__c='Bronze',
                                                      LG_ServiceStatus__c='Active',
                                                      csord__Status__c='Active',
                                                      csord__Service__c=serv1.id,
                                                      LG_ProductFamily__c='Virtual Voice'
                                                      );
    
        insert serv2;
        
        csord__Service_Line_Item__c servlinitem=new csord__Service_Line_Item__c();
        servlinitem.csord__Service__c=serv1.id;
        servlinitem.csord__Identification__c='rttuyuyu';
        servlinitem.csord__Total_Price__c=100;
        servlinitem.UM_KenanServiceLineId__c='1234';
        servlinitem.csord__Line_Description__c='abcdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        servlinitem.UM_ServiceItemType__c='1';
        
        csord__Service_Line_Item__c servlinitem1=new csord__Service_Line_Item__c();
        servlinitem1.csord__Service__c=serv1.id;
        servlinitem1.UM_KenanServiceLineId__c='12345';
        servlinitem1.csord__Identification__c='rttu';
        servlinitem1.csord__Total_Price__c=100;
        servlinitem1.csord__Line_Description__c='abcdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        servlinitem1.UM_ServiceItemType__c='0';
        
        csord__Service_Line_Item__c servlinitem2=new csord__Service_Line_Item__c();
        servlinitem2.csord__Service__c=serv2.id;
        servlinitem2.UM_KenanServiceLineId__c='123433';
        servlinitem2.csord__Identification__c='rttu';
        servlinitem2.csord__Total_Price__c=100;
        servlinitem2.csord__Line_Description__c='abcdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        servlinitem2.UM_ServiceItemType__c='1';
        
        list<csord__Service_Line_Item__c> sliList =NEW list<csord__Service_Line_Item__c>();
        sliList.add(servlinitem);
        sliList.add(servlinitem1);
        sliList.add(servlinitem2);
        INSERT sliList;  
        
    }
    
    @isTest
    public static void testMethod1(){
        dataSetup();      
        List<csord__Service__c> srvList=Database.query(queryForBatchChild);
        for(csord__Service__c s:srvList){
            s.LG_ServiceStatus__c = 'Ready for Billing';
            s.csordtelcoa__Delta_Status__c='Terminate';
            s.csord__Deactivation_Date__c = system.today();         
        }
        update srvList;
        
        Test.StartTest();
        try{
        UM_ServiceHPBX_MACD hpmacd = new UM_ServiceHPBX_MACD();
        hpmacd.execute(srvList);
        }catch(Exception ex){}
        Test.StopTest();
    }
    @isTest
    public static void testMethod2(){
        dataSetup();       
        List<csord__Service__c > srvList=Database.query(queryForBatchParent);
        for(csord__Service__c s:srvList){
            s.csordtelcoa__Delta_Status__c='Terminate'; 
            s.csord__Deactivation_Date__c = system.today();
        }
        update srvList;
        
        Test.StartTest();
        try{
        UM_ServiceHPBX_MACD hpmacd = new UM_ServiceHPBX_MACD();
        hpmacd.execute(srvList);
        }catch(Exception ex){}
        Test.StopTest();
    }
    
    @isTest
    public static void testMethod3(){
        dataSetup();       
        List<csord__Service__c > srvList=Database.query(queryForBatchParent);
        for(csord__Service__c s:srvList){
            s.csordtelcoa__Delta_Status__c='Modify'; 
        }
        update srvList;
        
        Test.StartTest();
        try{
        UM_ServiceHPBX_MACD hpmacd = new UM_ServiceHPBX_MACD();
        hpmacd.execute(srvList);
        }catch(Exception ex){}
        Test.StopTest();
    }
    
    @isTest
    public static void testMethod4(){
        dataSetup();       
        List<csord__Service__c > srvList=Database.query(queryForBatchParent);
        csord__Service__c serv2;
        for(csord__Service__c s:srvList){
            serv2=new csord__Service__c(Name = 'Premium',
                                          csord__Subscription__c=s.csord__Subscription__c,
                                          csord__Identification__c='Identification1'+s.csord__Subscription__c,
                                          csord__Activation_Date__c=System.today().addDays(-5),
                                          LG_SLA__c='Bronze',
                                          csord__Service__c=s.id,
                                          csordtelcoa__Delta_Status__c='Add',
                                          LG_ServiceStatus__c = 'Ready for Billing');
        }
        
        insert serv2;
        
        csord__Service_Line_Item__c servlinitem2=new csord__Service_Line_Item__c();
        servlinitem2.csord__Service__c=serv2.id;
        servlinitem2.csord__Identification__c='rttu';
        servlinitem2.csord__Total_Price__c=100;
        servlinitem2.csord__Line_Description__c='abcdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        servlinitem2.UM_ServiceItemType__c='1';
        
        insert servlinitem2;
        srvList=Database.query(queryForBatchChild);
        Test.StartTest();
        try{
        UM_ServiceHPBX_MACD hpmacd = new UM_ServiceHPBX_MACD();
        hpmacd.execute(srvList);
        }catch(Exception ex){}
        Test.StopTest();
    }
}
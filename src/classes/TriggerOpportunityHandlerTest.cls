@isTest
public class TriggerOpportunityHandlerTest {
    
    /* Testing IBAN validation on correct input */
    public static testMethod void testIBAN_Validation1(){
        List<String> ibans = new List<String>();
        ibans.add('AL47 2121 1009 0000 0002 3569 8741');
        ibans.add('');  //blank value should pass too
        ibans.add(null);
        ibans.add('BH67 BMAG 0000 1299 1234 56');
        ibans.add('NL39 RABO 0300 0652 64');
        ibans.add('GE29 NB00 0000 0101 9049 17');
        ibans.add('JO94 CBJO 0010 0000 0000 0131 0003 02');
        ibans.add('MT84 MALT 0110 0001 2345 MTLC AST0 01S');
        List<Opportunity> opps = new List<Opportunity>();
        for(String IBAN : ibans){
            opps.add(new Opportunity(Name = 'Test', LG_BankNumber__c = IBAN, CloseDate = Date.today(), StageName='Closed Lost',ForecastCategoryName='Closed'));            
        }
        Database.SaveResult[] srList = Database.insert(opps, false);
        for(Database.SaveResult sr : srList){
            if(!sr.isSuccess()){
                system.debug('IBAN Validation does not passed on correct input data');
                system.assert(true);
            }            
        }
    }
    /* Testing IBAN validation on incorrect input */
    public static testMethod void testIBAN_Validation2(){
        LG_IBAN__c settingNL = new LG_IBAN__c(Name = 'NL', LG_Length__c = 18);
        insert settingNL;
        List<String> ibans = new List<String>();
        ibans.add('wrong input');
        ibans.add('too'); // short input
        // non-english letters
        ibans.add('ôščťžýáí');
        //different check sum
        ibans.add('Too long input string to fit into LG_BankNumber__c field');
        // adding special characters to valid IBAN
        ibans.add('BH67 BMAG @ 0000 1299 1234 56');
        ibans.add('BH67 BMAG $ 0000 1299 1234 56');
        ibans.add('BH67 BMAG ! 0000 1299 1234 56');
        ibans.add('BH67 BMAG # 0000 1299 1234 56');
        // special characters itself
        ibans.add('!@#$%^*()*');
        // invalid length - based on custom setting inserted above
        ibans.add('NL00 1234 56789');
        // Add any other special cases
        ibans.add('NL39 RABO 0300 0652 70');
        ibans.add('NL39 RABO 0300 0652 71');
        ibans.add('NL39 RABO 0300 0652 72');
        ibans.add('NL39 RABO 0300 0652 7N');
        ibans.add('NL39 RABO 0300 0652 646');
        ibans.add('NL39 RABO 0300 0652 647');
        ibans.add('NL39 RABO 0300 0652 648');
        ibans.add('NL39 RABO 0300 0652 649');
        List<Opportunity> opps = new List<Opportunity>();
        for(String IBAN : ibans){
            opps.add(new Opportunity(Name = 'Test', LG_BankNumber__c = IBAN, CloseDate = Date.today(), StageName='Closed Lost',ForecastCategoryName='Closed'));            
        }
        Database.SaveResult[] srList = Database.insert(opps, false);
        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                system.debug('IBAN Validation does passed on incorrect input data');
                system.assert(true);
            }            
        }
    }
}
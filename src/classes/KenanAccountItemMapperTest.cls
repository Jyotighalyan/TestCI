@isTest
public class KenanAccountItemMapperTest  {
    
    public static testmethod void KenanAccountItemMappertest(){
        test.startTest();
        KenanAccountItemMapper mapp=new KenanAccountItemMapper();
        KenanAccountItem accntitm=new KenanAccountItem();
        Datetime myDate = Datetime.newInstance(1967, 2, 17);
        accntitm.activeDate=myDate;
        accntitm.annotation='annotation';
        accntitm.annotation2='annotation 1';
        accntitm.contractLevel=12;
        // accntitm.currencyCode='11';
        
        //accntitm.discountAmount=12.0;
        // accntitm.discountPercent=12.0;
        Datetime myDateTime = Datetime.newInstance(1960, 2, 17);
        accntitm.inactiveDate=myDateTime;
        accntitm.itemId=11;
        accntitm.itemType=13;
        
        
        RateCurrencyBean__mdt currbean=[select CurrencyCode__c,LanguageCode__c,ShortDisplay__C from RateCurrencyBean__mdt WHERE LanguageCode__c='1' AND CurrencyCode__c='11' LIMIT 1];
        system.debug(currbean);
        
        map<String,object> mapaccnt=new map<String,object>();
   	mapaccnt.put('kenanaccountmapper',accntitm);
      
        KenanObject obj=new KenanObject();
       obj.salesforceOrgId='value';
 obj.extData=mapaccnt;
obj.salesforceObjectId='value1';
      
        
        mapp.getDisplayValues(accntitm);
       	mapp.getDisplayValues(mapaccnt);
       system.debug(obj);
     
  
       	mapp.getEnumeratedValues(accntitm);
        test.stopTest();
    }
}
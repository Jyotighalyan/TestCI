@istest
public class CompileOfflineHelperTest {
    	@testsetup
    private static void setupTestData(){
        //createProductDefinition
        cscfga__Product_Definition__c def=LG_GeneralTest.createProductDefinition('prod', true);
        cscfga__Attribute_Definition__c defn=LG_GeneralTest.createAttributeDefinition('attr',def,'User Input','yy','zz','tt','rr');
        
        
    }
    
    public static testmethod void CompileOfflinetest(){
        try{
        
       cscfga__Product_Definition__c cscfprod= [select id from cscfga__Product_Definition__c];
       cscfga__Attribute_Definition__c cscfattr=[select id,cscfga__Type__c,cscfga__Data_Type__c,LG_OPTKey__c,LG_OLIType__c,LG_ProductDetailType__c,cscfga__Product_Definition__c from cscfga__Attribute_Definition__c]; 
        List<cscfga__Attribute_Definition__c> l1=new List<cscfga__Attribute_Definition__c>();
        l1.add(cscfattr);
           //PageReference pageRef =page.compilealldefinitionUIs;
           PageReference pageRef = new PageReference('/apex/cscfga__CaptureProductModel?id=');
 pageRef.getParameters().put('id',cscfprod.id);
            // pageReference pageRef = new PageReference('/apex/cscfga__CaptureProductModel?id=' + cscfprod.id + '&template=csac__RenderOfflineAppUI&phase=template');
         ApexPages.currentPage().getParameters().put('Id',cscfprod.id);

        Test.setCurrentPage(pageRef); 
        system.debug(pageRef);
            //attachment
            Attachment attach = new Attachment();
            Blob body;
           
                body=blob.valueOf('TestString');
      
  
      
            Blob content;
            content=Blob.valueOf('UNIT.TEST');
     
        test.startTest();
        CompileOfflineHelper.getSelectListLookups(cscfprod.id);
        CompileOfflineHelper.toggleAttributes(l1,true);
          CompileOfflineHelper.updatePDLastModifiedDate(cscfprod.id);
        CompileOfflineHelper.compile(cscfprod.id);
      
            test.stopTest();}
        catch(Exception e){
            system.debug(e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            
            
        }
        }
}
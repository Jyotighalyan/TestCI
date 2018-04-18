@isTest
private class LG_UpdateProductsOnOpportunityTest {

static testMethod void synchronizedFalse() {
    List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
    List<cscfga__Product_Basket__c> basketsToInsert = new List<cscfga__Product_Basket__c>();
    
    //create user with admin profile
    Profile p = [select id from profile where name='System Administrator']; 
    User ur = new User();
            ur.FirstName = 'Test';
            ur.LastName = 'User2';
            ur.Email = 'test.user2@test.com';
            ur.Username = 'drder@test.com';
            ur.Alias = 'yjulrty';
            ur.CommunityNickname = 'derkui';
            ur.TimeZoneSidKey = 'Pacific/Fiji';
            ur.LocaleSidKey ='en_US';
            ur.EmailEncodingKey ='UTF-8';
            ur.ProfileId = p.Id;
            ur.LanguageLocaleKey ='en_US';
            ur.CompanyName = 'Test Company';
        insert ur;      
      
      System.runAs(ur){
            test.startTest();
            
            //create Account        
            Account acc = new Account();
            acc.Name = 'TEST NAME';
            acc.LG_ChamberOfCommerceNumber__c = '12345678';
            insert acc; 
            
            //create opportunities
            for (integer i = 0; i< 100; i++){
                  Opportunity opp = new Opportunity();
                  opp.Name = 'TEST OPP';
                  opp.CloseDate = Date.today();
                  opp.StageName = 'Quotation Delivered';
                  opp.Account = acc;
                  opp.AccountId = acc.Id;
                  opportunitiesToInsert.add(opp);
            }
            insert opportunitiesToInsert;
            
            //create baskets
            for (integer i = 0; i< 100; i++){
                    cscfga__Product_Basket__c bsk = new cscfga__Product_Basket__c();
                    bsk.LG_AdminContactDateofBirth__c=date.newinstance(1960, 2, 17);
                    bsk.LG_AdminContactEmail__c='davor.dubokovic@cloudsense.com.test';
                    bsk.LG_AdminContactFirstName__c='Davor';
                    bsk.LG_AdminContactLastName__c='Dubokovic';
                    bsk.LG_AdminContactMiddleName__c='';
                    bsk.LG_AdminContactMobile__c='0299 654647';
                    bsk.LG_AdminContactPhone__c='0299 654648';
                    
                    bsk.LG_AdminContactSalutation__c='Mr.';
                    bsk.LG_BankAccountName__c='MR DD';
                    bsk.LG_BankNumber__c='NL10zlam2503800483';
                    bsk.LG_BillingCity__c='MONNICKENDAM';
                    bsk.LG_BillingCountry__c='Netherlands';
                    bsk.LG_BillingHouseNumber__c='24';
                    bsk.LG_BillingHouseNumberExtension__c='A';
                    bsk.LG_BillingPostalCode__c='1141 KG';
                    bsk.LG_BillingSameAsInstallationAddress__c=false;
                    bsk.LG_BillingStreet__c='Boing';
                    bsk.LG_COAXConnectionLocation__c='';
                    bsk.LG_CreatedFrom__c='Tablet';
                    bsk.LG_CustomerReference__c='ABC123';
                    bsk.LG_InstallationCity__c='Amsterdam';
                    bsk.LG_InstallationCountry__c='Netherlands';
                    bsk.LG_InstallationHouseNumber__c='1';
                    bsk.LG_InstallationHouseNumberExtension__c='A';
                    bsk.LG_InstallationPostalCode__c='1141 GV';
                    bsk.LG_InstallationStreet__c='Boing';
                    bsk.LG_InstallValidationResult__c='Valid';
                    bsk.LG_MainReasonLost__c='Delivery';
                    bsk.LG_PaymentType__c='Bank Transfer';
                    bsk.LG_PostalCity__c='Amsterdam';
                    bsk.LG_PostalCountry__c='Netherlands';
                    bsk.LG_PostalHouseNumber__c='1';
                    bsk.LG_PostalHouseNumberExtension__c='A';
                    bsk.LG_PostalPostalCode__c='1141 GV';
                    bsk.LG_PostalSameAsInstallationAddress__c=false;
                    bsk.LG_PostalStreet__c='Boing';
                    bsk.LG_PreferredInstallationDate__c=date.newinstance(2020, 2, 17);
                    bsk.LG_PreferredInstallationTime__c='18.00 - 21.00';
                    bsk.LG_ResultofVisit__c='Quote Requested';
                    bsk.LG_SameAsAdminContact__c=false;
                    bsk.LG_SBTelephonyId__c='';
                    bsk.LG_SharedOfficeBuilding__c=false;
                    bsk.LG_TechContactSameasBillingContact__c=false;
                    bsk.LG_TechnicalContactDateofBirth__c=date.newinstance(1990, 2, 17);
                    bsk.LG_TechnicalContactEmail__c='davor.dubokovic@cloudsense.com.test';
                    bsk.LG_TechnicalContactFirstName__c='John 1';
                    bsk.LG_TechnicalContactLastName__c='De Vries 2';
                    bsk.LG_TechnicalContactMiddleName__c='';
                    bsk.LG_TechnicalContactMobile__c='0299 654647';
                    bsk.LG_TechnicalContactPhone__c='0299 654642';
                    bsk.LG_TechnicalContactPicklist__c='(new Contact)';
                    bsk.LG_TechnicalContactSalutation__c='Mr.';
                    bsk.LG_ValidationDate__c=date.today();
                    bsk.LG_VisitDescription__c='All OK';                    
                    bsk.cscfga__Products_In_Basket__c = 'PRODUCT1';
                    bsk.cscfga__Opportunity__c = opportunitiesToInsert[0].Id;
                    bsk.csordtelcoa__Synchronised_with_Opportunity__c = false;
                    basketsToInsert.add(bsk);
            }
              insert basketsToInsert;
              
              //validate if field on Opportunity is not changed
              List<Opportunity> oppList = [SELECT Id, LG_ProductsInBasketHidden__c FROM Opportunity WHERE Id in :opportunitiesToInsert];
              
              for(Opportunity opp : oppList){
                  System.assertEquals(opp.LG_ProductsInBasketHidden__c, null);
              }        
              
              test.stopTest();
      }        
    }
    
    static testMethod void synchronizedTrue() {
      List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
      List<cscfga__Product_Basket__c> basketsToInsert = new List<cscfga__Product_Basket__c>();
      List<cscfga__Product_Basket__c> basketsToUpdate = new List<cscfga__Product_Basket__c>();
      
      //create user with admin profile
      Profile p = [select id from profile where name='System Administrator']; 
        User ur = new User();
            ur.FirstName = 'Test';
            ur.LastName = 'User2';
            ur.Email = 'test.user2@test.com';
            ur.Username = 'drder@test.com';
            ur.Alias = 'yjulrty';
            ur.CommunityNickname = 'derkui';
            ur.TimeZoneSidKey = 'Pacific/Fiji';
            ur.LocaleSidKey ='en_US';
            ur.EmailEncodingKey ='UTF-8';
            ur.ProfileId = p.Id;
            ur.LanguageLocaleKey ='en_US';  
            ur.CompanyName = 'Test Company';      
        insert ur;      
      
      System.runAs(ur){
            test.startTest();
            
            //create Account        
            Account acc = new Account();
            acc.Name = 'TEST NAME';
            acc.LG_ChamberOfCommerceNumber__c = '12345678';
            insert acc; 
            
            //create opportunities
            for (integer i = 0; i< 100; i++){
                  Opportunity opp = new Opportunity();
                  opp.Name = 'TEST OPP';
                  opp.CloseDate = Date.today();
                  opp.StageName = 'Quotation Delivered';
                  opp.Account = acc;
                  opp.AccountId = acc.Id;
                  opp.Probability = Decimal.valueOf('0');
                  opportunitiesToInsert.add(opp);
            }
            insert opportunitiesToInsert;
            
            //create baskets
            for (integer i = 0; i< 100; i++){
                    cscfga__Product_Basket__c bsk = new cscfga__Product_Basket__c();
                    bsk.Name = 'TEST';
                    bsk.cscfga__Products_In_Basket__c = 'PRODUCT1';
                    bsk.cscfga__Opportunity__c = opportunitiesToInsert[i].Id;
                    bsk.csordtelcoa__Synchronised_with_Opportunity__c = false;
                    basketsToInsert.add(bsk);
            }
              insert basketsToInsert;
              
              //set synchronized to true and update baskets
              for (cscfga__Product_Basket__c bsc : basketsToInsert){
                    bsc.csordtelcoa__Synchronised_with_Opportunity__c = true;
                    basketsToUpdate.add(bsc);
            }
              update basketsToUpdate;
                          
              //validate if field on Opportunity is changed
              List<Opportunity> oppList = [SELECT Id, LG_ProductsInBasketHidden__c FROM Opportunity WHERE Id in :opportunitiesToInsert];
                
              for(Opportunity opp : oppList){
                  System.assertEquals(opp.LG_ProductsInBasketHidden__c,null);
              }        
              
              test.stopTest();
      }        
    }
}
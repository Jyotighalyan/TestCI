/*******************************************************************************************************************************************
* File Name     :  LG_OrderToOPTWebServiceTest
* Description   :  Test class for class: LG_OrderToOPTWebService

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     24th-Mar-16    Shreyas             Created the class for release R1*
********************************************************************************************************************************************/

@isTest
private class LG_OrderToOPTWebServiceTest{
  
     /*
        Name: TestMethod1_Small
        Purpose: Test method for testing the logic for getting the orders for small products
        Argument: none
        Return type: none
     */


   /* static testmethod void TestMethod1_Small() {
        
        
        
        csordtelcoa__Orders_Subscriptions_Options__c cs_Options = new csordtelcoa__Orders_Subscriptions_Options__c();
        cs_Options.csordtelcoa__Subscription_Initial_State__c = 'Subscription Created';
        cs_Options.LG_SubscriptionRequestDeactivateStatus__c = 'Subscription Termination Requested';
        cs_Options.csordtelcoa__Service_Initial_State__c = 'Service Created';
        cs_Options.LG_ServiceRequestDeactivateStatus__c = 'Termination Requested';
        cs_Options.setupownerId = userinfo.getuserId();
        insert cs_Options;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.LG_Segment__c = 'Small';
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '1';
        acc.LG_ChamberOfCommerceNumber__c = chamberOfCommerce;
        acc.LG_VisitStreet__c = 'street';
        acc.LG_VisitCity__c = 'city';
        acc.LG_VisitHouseNumber__c = '5';
        acc.LG_VisitHouseNumberExtension__c = '73';
        acc.LG_VisitPostalCode__c = '2014GC';
        acc.LG_VisitCountry__c = 'Netherlands';
        acc.LG_PostalStreet__c = 'street';
        acc.LG_PostalCity__c = 'city';
        acc.LG_PostalHouseNumber__c = '5';
        acc.LG_PostalHouseNumberExtension__c = '73';
        acc.LG_PostalPostalCode__c = '2014GC';
        acc.LG_PostalCountry__c = 'Netherlands';
        insert acc;
        
        //Billing Account
        csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
        ba.csconta__Account__c = acc.id;
        ba.csconta__Status__c = 'New';
        ba.csconta__Billing_Channel__c = 'Paper';
        ba.csconta__Format_Type__c = 'Summary';
        insert ba;
       
        
        Contact con = new Contact();
        con.LastName = 'TestLastName';
        con.accountId = acc.Id;
        con.Salutation = 'Mr';
        con.phone = '111';
        con.fax = '111';
        con.email = 'con.con@test.com';
        con.Birthdate = System.today();
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'opp1_test';
        opp.AccountId = acc.Id;
        opp.Type = 'New Business';
        opp.CloseDate = System.today() + 1;
        opp.StageName = 'Ready For Order';
        opp.LG_ClientNumber__c = '1111';
        opp.LG_ExistingSubscription__c = 'yes';
        opp.LG_DTV__c = 'yes';
        opp.LG_IPAddress__c = 'yes';
        opp.LG_Telephony__c = 'yes';
        insert opp;
        
        List<opportunityContactRole> opportunityContactRoleInsertList = new List<opportunityContactRole>();
        opportunityContactRole ocr1 = new opportunityContactRole();
        ocr1.OpportunityId = opp.Id;
        ocr1.ContactId = con.Id;
        ocr1.Role = 'Technical Contact';
        opportunityContactRole ocr2 = new opportunityContactRole();
        ocr2.OpportunityId = opp.Id;
        ocr2.ContactId = con.Id;
        ocr2.Role = 'Administrative Contact';
        opportunityContactRole ocr3 = new opportunityContactRole();
        ocr3.OpportunityId = opp.Id;
        ocr3.ContactId = con.Id;
        ocr3.Role = 'Financial Contact';
        opportunityContactRoleInsertList.add(ocr1);
        opportunityContactRoleInsertList.add(ocr2);
        opportunityContactRoleInsertList.add(ocr3);
        insert opportunityContactRoleInsertList;
        
        cscrm__Address__c premise1 = new cscrm__Address__c();
        premise1.name = 'Home';
        premise1.cscrm__Street__c = 'street';
        premise1.cscrm__City__c = 'city';
        premise1.LG_HouseNumber__c = '5';
        premise1.LG_HouseNumberExtension__c = '73';
        premise1.cscrm__Zip_Postal_Code__c = '2014GC';
        premise1.cscrm__Country__c = 'Netherlands';
        premise1.cscrm__Account__c = acc.Id;
        premise1.LG_TechnicalContact__c = con.Id;
        insert premise1;
        
        
        csord__Order_Request__c orderReq = new csord__Order_Request__c();
        orderReq.Name = 'OR Via Console 1';
        orderReq.csord__Module_Name__c = 'CS Order Implementation Module Telco A';
        orderReq.csord__Module_Version__c = '1.0';
        insert orderReq;
        
        csord__Order__c ord = new csord__Order__c();
        ord.csord__Account__c = acc.Id;
        ord.csord__Order_Request__c = orderReq.Id;
        ord.csord__Identification__c = 'orderId';
        ord.csordtelcoa__Opportunity__c = opp.Id;
        ord.csord__Status2__c = 'Queued';
        insert ord;
        
        List<cscfga__Product_Definition__c> pd = new List<cscfga__Product_Definition__c>();
        string productDefinitionId1 = '';
        string productDefinitionId2 = '';
        
        cscfga__Product_Definition__c pd1 = new cscfga__Product_Definition__c();
        pd1.Name = 'Prod Def1 for Test Class';
        pd1.cscfga__Description__c = 'Prod Def1 for Test Class';
        pd.add(pd1);
        
        cscfga__Product_Definition__c pd2 = new cscfga__Product_Definition__c();
        pd2.Name = 'Prod Def2 for Test Class';
        pd2.cscfga__Description__c = 'Prod Def2 for Test Class';
        pd.add(pd2);
        
        insert pd;
        
        if(pd != null){
            productDefinitionId1 = pd[0].Id;
            productDefinitionId2 = pd[1].Id;
        }
        
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'PC Name';
        pc.cscfga__Description__c = 'PC Name';
        pc.cscfga__Product_Family__c = 'PC Name';
        pc.cscfga__Product_Definition__c = productDefinitionId1;
        pc.cscfga__Quantity__c = 2;
        pc.cscfga__Unit_Price__c = 100;
        pc.cscfga__Total_Price__c = pc.cscfga__Unit_Price__c * pc.cscfga__Quantity__c;
        pc.cscfga__Billing_Frequency__c = 12;
        pc.cscfga__Recurrence_Frequency__c = 12;
        pc.csordtelcoa__Hierarchy_Level__c = 0;
        insert pc;
        
        LG_PortingNumber__c pn = new LG_PortingNumber__c();
        pn.LG_ProductConfiguration__c = pc.Id;
        pn.LG_Opportunity__c = opp.Id;
        pn.LG_DirectoryListingName__c = 'Test Name 2';
        pn.LG_InDirectory__c = 'true';
        insert pn;
        
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.name = 'MKB Internet';
        subs.csconta__Billing_Account__c = ba.id;
        subs.csord__Account__c = acc.Id;
        subs.csord__Order_Request__c = orderReq.Id;
        subs.csord__Identification__c = 'externalId';
        subs.csord__Status__c = 'Subscription Created';
        subs.csord__Order__c = ord.Id;
        insert subs;
        
        csord__Service__c serv_product = new csord__Service__c();
        serv_product.name = 'MKB Internet - Product';
        serv_product.csord__Status__c = 'Service created';
        serv_product.csord__Subscription__c = subs.Id;
        serv_product.csord__Identification__c = 'externalId1';
        serv_product.csord__Order_Request__c = orderReq.Id;
        serv_product.csord__Order__c = ord.Id;
        serv_product.csordtelcoa__Product_Configuration__c = pc.Id;
        serv_product.LG_Address__c = premise1.Id;
        serv_product.LG_CallerID__c = 'yes';
        serv_product.LG_BNumberShielding__c= 'yes';
        serv_product.LG_OrderNumber__c = 'Ord1_test';
        insert serv_product;
        
        csord__Service_Line_Item__c sli_product = new csord__Service_Line_Item__c();
        sli_product.Name = 'MKB Internet - Product';
        sli_product.csord__Is_Recurring__c = True;
        sli_product.LG_ToBeSent__c = 'True';
        sli_product.LG_Type__c = 'Product';
        sli_product.csord__Service__c = serv_product.Id;
        sli_product.csord__Order_Request__c = orderReq.Id;
        sli_product.LG_BillingAccount__c = ba.Id;
        sli_product.csord__Identification__c = 'extId_sli1';
        insert sli_product;
        
        csord__Service_Line_Item__c sli_discount = new csord__Service_Line_Item__c();
        sli_discount.Name = 'MKB Internet - Discount';
        sli_discount.csord__Is_Recurring__c = True;
        sli_discount.LG_ToBeSent__c = 'True';
        sli_discount.LG_Type__c = 'Discount';
        sli_discount.csord__Service__c = serv_product.Id;
        sli_discount.csord__Order_Request__c = orderReq.Id;
        sli_discount.LG_BillingAccount__c = ba.Id;
        sli_discount.csord__Identification__c = 'extId_sli2';
        insert sli_discount;
        
        cscfga__Product_Configuration__c pc2 = new cscfga__Product_Configuration__c();
        pc2.Name = 'PC Name';
        pc2.cscfga__Description__c = 'PC Name';
        pc2.cscfga__Product_Family__c = 'PC Name';
        pc2.cscfga__Product_Definition__c = productDefinitionId2;
        pc2.cscfga__Quantity__c = 2;
        pc2.cscfga__Unit_Price__c = 100;
        pc2.cscfga__Total_Price__c = pc.cscfga__Unit_Price__c * pc.cscfga__Quantity__c;
        pc2.cscfga__Billing_Frequency__c = 12;
        pc2.cscfga__Recurrence_Frequency__c = 12;
        pc2.csordtelcoa__Hierarchy_Level__c = 0;
        insert pc2;
        
        csord__Service__c serv_addon = new csord__Service__c();
        serv_addon.name = 'Pin Zeker - AddOn';
        serv_addon.csord__Status__c = 'Service created';
        serv_addon.csord__Subscription__c = subs.Id;
        serv_addon.csord__Identification__c = 'externalId2';
        serv_addon.csord__Order_Request__c = orderReq.Id;
        serv_addon.csord__Order__c = ord.Id;
        serv_addon.csordtelcoa__Product_Configuration__c = pc2.Id;
        serv_addon.LG_Address__c = premise1.Id;
        serv_addon.LG_OrderNumber__c = 'Ord1_test';
        insert serv_addon;
        
        csord__Service_Line_Item__c sli_addon = new csord__Service_Line_Item__c();
        sli_addon.Name = 'Pin Zeker - AddOn';
        sli_addon.csord__Is_Recurring__c = True;
        sli_addon.LG_ToBeSent__c = 'True';
        sli_addon.LG_Type__c = 'Add On';
        sli_addon.csord__Service__c = serv_addon.Id;
        sli_addon.csord__Order_Request__c = orderReq.Id;
        sli_addon.LG_BillingAccount__c = ba.Id;
        sli_addon.csord__Identification__c = 'extId_sli3';
        insert sli_addon;
        
        csord__Service_Line_Item__c sli_addondiscount = new csord__Service_Line_Item__c();
        sli_addondiscount.Name = 'Pin Zeker - Discount';
        sli_addondiscount.csord__Is_Recurring__c = True;
        sli_addondiscount.LG_ToBeSent__c = 'True';
        sli_addondiscount.LG_Type__c = 'Discount';
        sli_addondiscount.csord__Service__c = serv_addon.Id;
        sli_addondiscount.csord__Order_Request__c = orderReq.Id;
        sli_addondiscount.LG_BillingAccount__c = ba.Id;
        sli_addondiscount.csord__Identification__c = 'extId_sli4';
        insert sli_addondiscount;
        
        
       /* csord__Service_Line_Item__c  serviceLineItemListFetched = [Select Id, LG_Type__c, LG_ExternalServiceName__c, LG_ExternalPriceName__c, LG_Quantity__c, LG_ExternalDescription__c, csord__Service__c, 
                                              csord__Line_Number__c, LG_ServiceLineItemExternalId__c, LG_ToBeSent__c, 
                                              csord__Service__r.LG_OrderNumber__c, 
                                              csord__Service__r.LG_ExternalSubscriptionName__c,
                                              csord__Service__r.LG_ContractTerm__c, 
                                              csord__Service__r.LG_InstallationWishDate__c, 
                                              csord__Service__r.csordtelcoa__Service_Number__c,
                                              csord__Service__r.LG_ServiceExternalId__c, 
                                              csord__Service__r.csordtelcoa__Product_Configuration__c, 
                                              csord__Service__r.LG_IgnoreContractTerm__c, 
                                              csord__Service__r.LG_ChangeType__c, 
                                              csord__Service__r.LG_ChangeTypeCode__c, 
                                              csord__Service__r.csordtelcoa__Replaced_Service__c,
                                              csord__Service__r.csordtelcoa__Replaced_Service__r.LG_OrderNumber__c, 
                                              csord__Service__r.csord__Subscription__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__r.LG_CustomAccountNumber__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__r.LG_ExternalID__c,
                                              csord__Service__r.csord__Subscription__r.csordtelcoa__Subscription_Number__c,
                                              csord__Service__r.csord__Subscription__r.LG_SubscriptionExternalId__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Status__c, 
                                              csord__Service__r.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Name,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Owner.Name,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ClientNumber__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ExistingSubscription__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_DTV__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_IPAddress__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_Telephony__c,
                                              LG_BillingAccount__r.LG_PaymentType__c, 
                                              LG_BillingAccount__r.LG_ExternalId__c, 
                                              LG_BillingAccount__r.Name, 
                                              csord__Service__r.LG_Address__c, 
                                              csord__Service__r.LG_Address__r.Name, 
                                              csord__Service__r.LG_Address__r.cscrm__Street__c, 
                                              csord__Service__r.LG_Address__r.LG_HouseNumber__c, 
                                              csord__Service__r.LG_Address__r.LG_HouseNumberExtension__c, 
                                              csord__Service__r.LG_Address__r.cscrm__Zip_Postal_Code__c, 
                                              csord__Service__r.LG_Address__r.cscrm__City__c, 
                                              csord__Service__r.LG_Address__r.LG_Footprint__c,
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__c, 
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__r.Name,
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__r.Id    
                                              from csord__Service_Line_Item__c where 
                                              
                                              csord__Service__r.LG_OrderNumber__c != null AND 
                                              csord__Service__r.LG_OrderNumber__c != '' AND 
                                              csord__Is_Recurring__c = True 
                                             ];
        
        system.debug(serviceLineItemListFetched*/
     /*   LG_OrderToOPTWebService.getOrders(30, 'small');
        
    }
    
    /*
        Name: TestMethod1_Small
        Purpose: Test method for testing the logic for getting the orders for SoHo products
        Argument: none
        Return type: none
     */
  /*  static testmethod void TestMethod1_SoHo() {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.LG_Segment__c = 'Small';
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '2';
        acc.LG_ChamberOfCommerceNumber__c = chamberOfCommerce;
        acc.LG_VisitStreet__c = 'street';
        acc.LG_VisitCity__c = 'city';
        acc.LG_VisitHouseNumber__c = '5';
        acc.LG_VisitHouseNumberExtension__c = '73';
        acc.LG_VisitPostalCode__c = '2014GC';
        acc.LG_VisitCountry__c = 'Netherlands';
        acc.LG_PostalStreet__c = 'street';
        acc.LG_PostalCity__c = 'city';
        acc.LG_PostalHouseNumber__c = '5';
        acc.LG_PostalHouseNumberExtension__c = '73';
        acc.LG_PostalPostalCode__c = '2014GC';
        acc.LG_PostalCountry__c = 'Netherlands';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'TestLastName';
        con.accountId = acc.Id;
        con.Salutation = 'Mr';
        con.phone = '111';
        con.fax = '111';
        con.email = 'con.con@test.com';
        con.Birthdate = System.today();
        insert con;
        
        csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
        ba.csconta__Billing_Channel__c = 'Paper Bill';
        ba.csconta__Status__c = 'In Collection';
        ba.csconta__Account__c = acc.Id;
        ba.LG_BankAccountHolder__c = 'TestName';
        ba.LG_PaymentType__c = 'Bank Transfer';
        insert ba;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'opp1_test';
        opp.AccountId = acc.Id;
        opp.Type = 'New Business';
        opp.CloseDate = System.today() + 1;
        opp.StageName = 'Ready For Order';
        insert opp;
        
        Product2 prod = new Product2(Name = '1 statische IP-Adresse', 
            Family = 'Options');
        insert prod;

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        

        pricebookentry pbEntry = new pricebookentry();
        pbEntry = [Select Id from pricebookentry limit 1];
        string priceEntryId = '';
        if(pbEntry != null){
            priceEntryId = pbEntry.Id;
        }
        
        opportunityLineItem oli = new opportunityLineItem();
        oli.opportunityid = opp.Id;
        oli.UnitPrice = 10;
        oli.PricebookEntryId = priceEntryId;
        oli.Quantity = 1;
        oli.LG_Segment__c = 'SoHo';
        insert oli;
        
        
        List<opportunityContactRole> opportunityContactRoleInsertList = new List<opportunityContactRole>();
        opportunityContactRole ocr1 = new opportunityContactRole();
        ocr1.OpportunityId = Opp.Id;
        ocr1.ContactId = con.Id;
        ocr1.Role = 'Technical Contact';
        opportunityContactRole ocr2 = new opportunityContactRole();
        ocr2.OpportunityId = Opp.Id;
        ocr2.ContactId = con.Id;
        ocr2.Role = 'Administrative Contact';
        opportunityContactRole ocr3 = new opportunityContactRole();
        ocr3.OpportunityId = Opp.Id;
        ocr3.ContactId = con.Id;
        ocr3.Role = 'Financial Contact';
        opportunityContactRoleInsertList.add(ocr1);
        opportunityContactRoleInsertList.add(ocr2);
        opportunityContactRoleInsertList.add(ocr3);
        insert opportunityContactRoleInsertList;
        
        cscfga__Product_Basket__c pb = new cscfga__Product_Basket__c();
        pb.Name = 'product basket for SoHo Test';
        pb.cscfga__Opportunity__c = Opp.Id;
        pb.csordtelcoa__Synchronised_with_Opportunity__c = True;
        insert pb;
        
        cscfga__Product_Definition__c pd3 = new cscfga__Product_Definition__c();
        pd3.Name = 'Prod Def3 for Test Class';
        pd3.cscfga__Description__c = 'Prod Def3 for Test Class';
        insert pd3;
        
        string productDefinitionId = '';

        if(pd3 != null){
            productDefinitionId = pd3.Id;
        }
        
        cscfga__Attribute_Definition__c attDef = new cscfga__Attribute_Definition__c();
        attDef.Name = 'Test AttDef';
        attDef.cscfga__Product_Definition__c = productDefinitionId;
        insert attDef;
        
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'PC Name';
        pc.cscfga__Description__c = 'PC Name';
        pc.cscfga__Product_Family__c = 'PC Name';
        pc.cscfga__Product_Definition__c = productDefinitionId;
        pc.cscfga__Quantity__c = 2;
        pc.cscfga__Unit_Price__c = 100;
        pc.cscfga__Total_Price__c = pc.cscfga__Unit_Price__c * pc.cscfga__Quantity__c;
        pc.cscfga__Billing_Frequency__c = 12;
        pc.cscfga__Recurrence_Frequency__c = 12;
        pc.csordtelcoa__Hierarchy_Level__c = 0;
        pc.cscfga__Product_Basket__c = pb.Id;
        insert pc;
        /*
        cscfga__Attribute__c att = new cscfga__Attribute__c();
        att.Name = 'Test AttDef';
        att.cscfga__Attribute_Definition__c = attDef.Id;
        att.cscfga__Product_Configuration__c = pc.Id;
        att.cscfga__Is_Line_Item__c = True;
        insert att;
        
        cscfga__Attribute_Field__c attField = new cscfga__Attribute_Field__c();
        attField.Name = 'BillingAccount';
        attField.cscfga__Value__c = ba.Id;
        attField.cscfga__Attribute__c = att.Id;
        insert attField;        
        */
      /*  LG_PortingNumber__c pn = new LG_PortingNumber__c();
        pn.LG_ProductConfiguration__c = pc.Id;
        pn.LG_Opportunity__c = opp.Id;
        pn.LG_DirectoryListingName__c = 'Test Name 2';
        pn.LG_InDirectory__c = 'Yes';
        insert pn;
        
        LG_ProductDetail__c prodDetail = new LG_ProductDetail__c();
        prodDetail.LG_Opportunity__c = opp.Id;
        prodDetail.LG_Name__c = 'Test Pd';
        prodDetail.LG_Type__c = 'Bundle Detail';
        prodDetail.LG_Product__c = '1';
        prodDetail.LG_Sequence__c = 1;
        insert prodDetail;
        
        LG_OrderToOPTWebService.getOrders(30, 'soho');
        
    }
    
    /*
        Name: generateRandomNumber
        Purpose: Method to create random Chamber Of Commerce Number
        Argument: none
        Return type: none
    */
   /* public static string generateRandomNumberForChamberOfCommerce() {
        double a=(Math.random() + 1)*1000000;
        integer b = a.intValue();
        string c = String.valueOf(b);
        return c;     
    } 
    public static testmethod void LGOrderToOPTest(){
        test.startTest();
         LG_OrderToOPTWebService.LG_Contact cont=new LG_OrderToOPTWebService.LG_Contact();
        date d1=System.today();
        cont.Birthdate=d1;
        cont.CommercialContact='commercial';
        cont.Email='email';
        cont.Fax='fax';
        cont.FinancialContact='financial';
        cont.FirstName='fir';
        cont.LastName='last name';
        cont.MobilePhone='phone';
        cont.Name='nam';
        cont.Phone='phon';
        cont.Salutation='salutation';
        cont.TechnicalContact='technical';
        
        //LG_BillingAccount
        LG_OrderToOPTWebService.LG_BillingAccount bilacnt=new LG_OrderToOPTWebService.LG_BillingAccount();
        bilacnt.BankAccountHolder='holder';
        bilacnt.BankAccountNumberIBAN='numberiban';
        bilacnt.BillingAccountNumber='accntnum';
        bilacnt.BillingChannel='billingcha';
        bilacnt.BillingEmailAddress='billingemail';
        bilacnt.City='city';
        bilacnt.Country='count';
        bilacnt.CustomerExternalID='extid';
        bilacnt.CustomerReference='custref';
        bilacnt.ExternalID='extt';
        bilacnt.FormatType='typ';
        bilacnt.HouseNumber='num';
        bilacnt.HouseNumberExtension='extension';
        bilacnt.PaymentTerms='terms';
        bilacnt.PaymentType='typ';
        bilacnt.Postcode='cod';
        bilacnt.Street='street';
       
        
        LG_OrderToOPTWebService webserv=new LG_OrderToOPTWebService();
        LG_OrderToOPTWebService.LG_Account acct=new LG_OrderToOPTWebService.LG_Account();
        acct.ChamberOfCommerceNumber='number';
        acct.PostalHouseNumber='postal house number';
        acct.CustomAccountNumber='number';
        acct.EmailAdministrativeContact='administrative contact';
        acct.ExternalAccountID='accnt id';
        acct.Fax='fax';
        acct.Name='nam';
        acct.Phone='phone';
        acct.PostalCity='city';
        acct.Website='web site';
        acct.VisitCountry ='countrty';
        acct.VisitPostalCode ='postal';
        acct.VisitHouseNumber='house num';
        acct.VisitStreet ='street';
        acct.VisitHouseNumberExtension='house numb ext';
        acct.VisitCity='city';
        acct.PostalCountry='coun';
        acct.PostalPostalCode='post';
        acct.PostalStreet='str';
        acct.PostalHouseNumberExtension='num';
        acct.PostalCity='postal';
        List<LG_OrderToOPTWebService.LG_Contact> lcont=new List<LG_OrderToOPTWebService.LG_Contact>();
        lcont.add(cont);
        acct.contactList=lcont;
        List<LG_OrderToOPTWebService.LG_BillingAccount> billingAccountList =new List<LG_OrderToOPTWebService.LG_BillingAccount>();
        billingAccountList.add(bilacnt);
        acct.billingAccountList=billingAccountList;
        
                  //LG_Discounts
       LG_OrderToOPTWebService.LG_Discounts dis=new LG_OrderToOPTWebService.LG_Discounts();
        dis.DiscountName='20';
        
         //LG_AddOns
        LG_OrderToOPTWebService.LG_AddOns addon=new LG_OrderToOPTWebService.LG_AddOns();
        addon.ExternalServiceName='serv nam';
       addon.ExternalSubscriptionName='sub nam';
        addon.Quantity='4';
        addon.ServiceLineItemExternalDescription='desc';
        addon.ServiceLineItemExternalID='12334556';
        addon.ServiceLineItemLineNumber='25';
        addon.ServiceLineItemPriceName='price nam';
        addon.Yes_No='no';
        List<LG_OrderToOPTWebService.LG_Discounts> addOnDiscountList=new List<LG_OrderToOPTWebService.LG_Discounts>();
        addOnDiscountList.add(dis);
        addon.addOnDiscountList=addOnDiscountList;
        
         //LG_PhoneNumbers
        LG_OrderToOPTWebService.LG_PhoneNumbers phonnum=new LG_OrderToOPTWebService.LG_PhoneNumbers();
        phonnum.AreaCodes='area cod';
        phonnum.BNumberShielding='shielding';
        phonnum.CallBarringLevel='barring';
        phonnum.CallerID='caller id';
        phonnum.DirectoryListingName='dir list nam';
        phonnum.DirectoryListingName='dir list';
        phonnum.DonorOperatorCode='donor oper code';
        phonnum.InDirectory='in direc';
        phonnum.Phonenumbers='phone num';
        phonnum.PortingCity='porting city';
        phonnum.PortingHouseNumber='porting hous num';
        phonnum.PortingHouseNumberAddition='number addition';
        phonnum.PortingInitials='porting initial';
        phonnum.PortingName='porting nam';
        phonnum.PortingPrefix='prefix';
        phonnum.PortingStreet='strt';
        date d7=System.today();
        phonnum.PortingWishDate=d7;
        phonnum.PortingZipcode='zip';
        phonnum.TypeOfPhoneRange='rang';
        

        
        
        //LG_OrderLine
         LG_OrderToOPTWebService.LG_OrderLine ordlin=new LG_OrderToOPTWebService.LG_OrderLine();
        ordlin.BillingAccountExternalId='accnt ext id';
        ordlin.BillingAccountNumber='billing accnt num';
        ordlin.SubscriptionName='subs cription name';
        ordlin.ServiceName='serv name';
        ordlin.ExternalPriceName='price nam';
        ordlin.PremiseName='name';
        ordlin.PremiseStreet='premise street';
        ordlin.PremiseHouseNumber='prem hous num';
        ordlin.PremiseHouseNumberExtension='house num';
        ordlin.PremiseZIPPostalCode='postal code';
        ordlin.PremiseCity='premis city';
        ordlin.PremiseFootprint='premise foot print';
        ordlin.SubscriptionPublicId='sub id';
        ordlin.ServicePublicId='serv public id';
        ordlin.SubscriptionExternalId='sub ext id';
        ordlin.ServiceExternalId='service ext id';
        ordlin.contractstatus='contract status';
        List<LG_OrderToOPTWebService.LG_AddOns> addOnList=new List<LG_OrderToOPTWebService.LG_AddOns>();
        addOnList.add(addon);
            List<LG_OrderToOPTWebService.LG_PhoneNumbers> phoneNumberList=new List<LG_OrderToOPTWebService.LG_PhoneNumbers>();
        phoneNumberList.add(phonnum);
            List<LG_OrderToOPTWebService.LG_Discounts> discountList=new List<LG_OrderToOPTWebService.LG_Discounts>();
        discountList.add(dis);
        ordlin.addOnList=addOnList;
        ordlin.phoneNumberList=phoneNumberList;
        ordlin.discountList=discountList;
      
        
        ///LG_OrderDetail
        LG_OrderToOPTWebService.LG_OrderDetail detail=new LG_OrderToOPTWebService.LG_OrderDetail();
        detail.BillingAccountPaymentType='payment  type';
        detail.ChangeTypeCode='type code';
        detail.CommercialContact='commercial con';
        detail.ContractTerm='contract term';
        detail.CustomAccountNumber='custom acnt num';
        detail.ExternalAccountID='ext id';
        detail.OpportunityName='nam';
        detail.OpportunityOwner='own';
       // detail.orderLineList=''
            detail.OrderNumber='ord num';
        date d2=system.today();
        detail.PreferredInstallationDate=d2;
        detail.Remark='remark';
        detail.TechnicalContact='tech cont';
        List<LG_OrderToOPTWebService.LG_OrderLine> lorder=new List<LG_OrderToOPTWebService.LG_OrderLine>();
        lorder.add(ordlin);
        detail.orderLineList=lorder;
        
    // LG_OrderToOPTWebService.orderData ord=new  LG_OrderToOPTWebService.orderData();
    
           //LG_OpportunityLineItem
        LG_OrderToOPTWebService.LG_OpportunityLineItem linitem=new LG_OrderToOPTWebService.LG_OpportunityLineItem();
        linitem.PricebookEntryName='price book entry name';
        linitem.TotalPrice='total price';
        linitem.OneOffPrice='oneoffprice';
        linitem.Type='type';
        linitem.MainOLI=true;
        
        //LG_OpportunityContactRole
        LG_OrderToOPTWebService.LG_OpportunityContactRole controle=new LG_OrderToOPTWebService.LG_OpportunityContactRole();
       controle.Role='role';
        controle.Name='name';
        controle.Salutation='salutation';
        controle.LastName='last name';
        controle.Phone='phone';
        controle.MobilePhone='mobile phone';
        controle.Fax='fax';
        controle.Email='email';
        Date d9=System.today();
        controle.Birthdate=d9;
        
        //LG_ProductDetail
     LG_OrderToOPTWebService.LG_ProductDetail proddetail=new LG_OrderToOPTWebService.LG_ProductDetail();
        proddetail.Name='name';
        proddetail.Product='prod';
        proddetail.Value='value';
      
       //LG_PortingNumbersForSoho 
        LG_OrderToOPTWebService.LG_PortingNumbersForSoho portnum=new LG_OrderToOPTWebService.LG_PortingNumbersForSoho();
        date dt=system.today();
        portnum.PortingDate=dt;
        portnum.PhoneNumber='phone number';
        portnum.Operator='operator';
        portnum.CustomerName='nname';
        portnum.InDirectory='indirectory';
      //LG_Opportunity
      LG_OrderToOPTWebService.LG_Opportunity opport=new LG_OrderToOPTWebService.LG_Opportunity();
      opport.id='id';
      opport.Type='type';
       opport.AccountSegment='segment';
        opport.FootPrint='foot print';
        opport.Description='dec';
        opport.Name='name';
        opport.AccountId='a';
        opport.AccountName='account nam';
        opport.AccountPhone='accnt phone';
        opport.AccountChamberOfCommerce='commerce';
        date d8=system.today();
        opport.PreferredInstallationDate=d8;
        opport.SharedOfficeBuilding=true;
        opport.COAXConnectionLocation='conn';
        opport.ContractTermMonths='term mon';
        opport.PaymentType='payment type';
        opport.PartnerAccountId='payment id';
        opport.PartnerAccountName='partner account name';
        opport.NEWSalesChannel='news cahnnel';
        opport.BillingStreet='street';
        opport.BillingHouseNumber='house number';
        opport.BillingHouseNumberExtension='extn';
        opport.BillingPostalCode='postal code';
        opport.BillingCity='city';
        opport.BillingCountry='country';
        opport.BankAccountName='accntr name';
        opport.BankNumber='number';
        opport.CustomerReference='reference';
        opport.InstallationStreet='street';
        opport.InstallationHouseNumber='number';
        opport.InstallationHouseNumberExtension='extn';
        opport.InstallationPostalCode='postal';
        opport.InstallationCity='city';
        opport.InstallationCountry='country';
        opport.PostalStreet='postal stret';
        opport.PostalHouseNumber='postal house num';
        opport.PostalHouseNumberExtension='house extn';
        opport.PostalCode='postal code';
        opport.PostalCity='city';
        opport.PostalCountry='postal country';
       List<LG_OrderToOPTWebService.LG_OpportunityLineItem> opportunityLineItemList=new List<LG_OrderToOPTWebService.LG_OpportunityLineItem>();
           List<LG_OrderToOPTWebService.LG_OpportunityContactRole> opportunityContactRoleList=new List<LG_OrderToOPTWebService.LG_OpportunityContactRole>(); 
           List<LG_OrderToOPTWebService.LG_ProductDetail> productDetailList=new List<LG_OrderToOPTWebService.LG_ProductDetail>();
           List<LG_OrderToOPTWebService.LG_PortingNumbersForSoho> portingNumberList=new List<LG_OrderToOPTWebService.LG_PortingNumbersForSoho>();
        
opportunityLineItemList.add(linitem);  
        opportunityContactRoleList.add(controle);
        productDetailList.add(proddetail);
        portingNumberList.add(portnum);
        opport.opportunityLineItemList=opportunityLineItemList;
        opport.opportunityContactRoleList=opportunityContactRoleList;
        opport.productDetailList=productDetailList;
        opport.portingNumberList=portingNumberList;
        
     
        //orderData
        LG_OrderToOPTWebService.orderData orderdata=new LG_OrderToOPTWebService.orderData();
       orderdata.accountDetail=acct;
        orderdata.orderDetail=detail;
        orderdata.opportunityDetail=opport;
        
        //LG_OrderWebserviceVariables__c
        LG_OrderWebserviceVariables__c webservar=new LG_OrderWebserviceVariables__c();
        webservar.name='Opportunity_Status_for_SoHo_Products';
      //  insert webservar;
          LG_OrderWebserviceVariables__c webservar1=new LG_OrderWebserviceVariables__c();
        webservar1.name='Subscription_Status_for_InDelivery';
        //insert webservar1;
          LG_OrderWebserviceVariables__c webservar2=new LG_OrderWebserviceVariables__c();
        webservar2.name='SubsStatusforTerminationInProgress';
       // insert webservar2;
          LG_OrderWebserviceVariables__c webservar3=new LG_OrderWebserviceVariables__c();
        webservar3.name='ServiceLineItem_Type_AddOn';
       // insert webservar3;
          LG_OrderWebserviceVariables__c webservar4=new LG_OrderWebserviceVariables__c();
        webservar4.name='Service_Status_for_InDelivery';
       // insert webservar4;
        
         LG_OrderWebserviceVariables__c webservar5=new LG_OrderWebserviceVariables__c();
        webservar5.name='ServiceStatusforTerminationInProgress';
       // insert webservar5;
         LG_OrderWebserviceVariables__c webservar6=new LG_OrderWebserviceVariables__c();
        webservar6.name='ContactRole_Administrative';
        //insert webservar6;
        
          LG_OrderWebserviceVariables__c webservar7=new LG_OrderWebserviceVariables__c();
        webservar7.name='ContactRole_Technical';
       // insert webservar7;
          LG_OrderWebserviceVariables__c webservar8=new LG_OrderWebserviceVariables__c();
        webservar8.name='ServiceLineItem_Type_Discount';
       // insert webservar8;
         LG_OrderWebserviceVariables__c webservar9=new LG_OrderWebserviceVariables__c();
        webservar9.name='ServiceLineItem_Type_Product';
        //insert webservar9;
         LG_OrderWebserviceVariables__c webservar10=new LG_OrderWebserviceVariables__c();
        webservar10.name='ContactRole_Financial';
        //insert webservar10;
        
             LG_OrderWebserviceVariables__c webservar11=new LG_OrderWebserviceVariables__c();
        webservar11.name='Order_Status_In_Delivery';
         LG_OrderWebserviceVariables__c webservar12=new LG_OrderWebserviceVariables__c();
        webservar12.name='Order_Status_Submitted';
         LG_OrderWebserviceVariables__c webservar13=new LG_OrderWebserviceVariables__c();
        webservar13.name='AttributeFieldName_For_BillingAccount';
         LG_OrderWebserviceVariables__c webservar14=new LG_OrderWebserviceVariables__c();
        webservar14.name='ToBeSent_ServiceLineItems_Small';
          LG_OrderWebserviceVariables__c webservar15=new LG_OrderWebserviceVariables__c();
        webservar15.name='Segment_OpportunityLineItem_SoHo';
          LG_OrderWebserviceVariables__c webservar16=new LG_OrderWebserviceVariables__c();
        webservar16.name='ChangeTypeForTerminateService';
        
            
        List<LG_OrderWebserviceVariables__c>  varlist=new List<LG_OrderWebserviceVariables__c>();
        varlist.add(webservar);
        varlist.add(webservar1);
        varlist.add(webservar2);
        varlist.add(webservar3);
        varlist.add(webservar4);
        varlist.add(webservar5);varlist.add(webservar6);
        varlist.add(webservar7);
        varlist.add(webservar8);
        varlist.add(webservar9);
        varlist.add(webservar10);
        varlist.add(webservar11);
        varlist.add(webservar12);
        varlist.add(webservar13)
        varlist.add(webservar14);
        varlist.add(webservar15);
        varlist.add(webservar16);
        insert varlist;
        
        
        LG_OrderToOPTWebService.getOrders(30, 'small');
        
        test.stopTest();
        }*/
    public static testmethod void meth1(){
        test.startTest();
        
        LG_OrderToOPTWebService serv=new LG_OrderToOPTWebService();
        serv.method();
        test.stopTest();
    }
}
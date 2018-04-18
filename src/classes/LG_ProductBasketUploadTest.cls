@isTest
public class LG_ProductBasketUploadTest {
    static cscfga__Product_Basket__c BuildProductBasketForAccount(Account tmpAccount,  Contact tmpContact) {
        cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Test Basket', tmpAccount, null, null);
        tmpProductBasket.LG_AdminContactPicklist__c = string.valueOf(tmpContact.Id);

        tmpProductBasket.LG_AdminContactDateofBirth__c = date.newinstance(1960, 2, 17);
        tmpProductBasket.LG_AdminContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_AdminContactFirstName__c = 'Davor';
        tmpProductBasket.LG_AdminContactLastName__c = 'Dubokovic';
        tmpProductBasket.LG_AdminContactMiddleName__c = '';
        tmpProductBasket.LG_AdminContactMobile__c = '0299 654647';
        tmpProductBasket.LG_AdminContactPhone__c = '0299 654648';

        tmpProductBasket.LG_AdminContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_BankAccountName__c = 'MR DD';
        tmpProductBasket.LG_BankNumber__c = 'NL10zlam2503800483';
        tmpProductBasket.LG_BillingCity__c = 'MONNICKENDAM';
        tmpProductBasket.LG_BillingCountry__c = 'Netherlands';
        tmpProductBasket.LG_BillingHouseNumber__c = '24';
        tmpProductBasket.LG_BillingHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_BillingPostalCode__c = '1141 KG';
        tmpProductBasket.LG_BillingSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_BillingStreet__c = 'Boing';
        tmpProductBasket.LG_COAXConnectionLocation__c = '';
        tmpProductBasket.LG_CreatedFrom__c = 'Tablet';
        tmpProductBasket.LG_CustomerReference__c = 'ABC123';
        tmpProductBasket.LG_InstallationCity__c = 'Amsterdam';
        tmpProductBasket.LG_InstallationCountry__c = 'Netherlands';
        tmpProductBasket.LG_InstallationHouseNumber__c = '1';
        tmpProductBasket.LG_InstallationHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_InstallationPostalCode__c = '1141 GV';
        tmpProductBasket.LG_InstallationStreet__c = 'Boing';
        tmpProductBasket.LG_InstallValidationResult__c = 'Valid';
        tmpProductBasket.LG_MainReasonLost__c = 'Delivery';
        tmpProductBasket.LG_PaymentType__c = 'Bank Transfer';
        tmpProductBasket.LG_PostalCity__c = 'Amsterdam';
        tmpProductBasket.LG_PostalCountry__c = 'Netherlands';
        tmpProductBasket.LG_PostalHouseNumber__c = '1';
        tmpProductBasket.LG_PostalHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_PostalPostalCode__c = '1141 GV';
        tmpProductBasket.LG_PostalSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_PostalStreet__c = 'Boing';
        tmpProductBasket.LG_PreferredInstallationDate__c = date.newinstance(2020, 2, 17);
        tmpProductBasket.LG_PreferredInstallationTime__c = '18.00 - 21.00';
        tmpProductBasket.LG_ResultofVisit__c = 'Quote Requested';
        tmpProductBasket.LG_SameAsAdminContact__c = false;
        tmpProductBasket.LG_SBTelephonyId__c = '';
        tmpProductBasket.LG_SharedOfficeBuilding__c = false;
        tmpProductBasket.LG_TechContactSameasBillingContact__c = false;
        tmpProductBasket.LG_TechnicalContactDateofBirth__c = date.newinstance(1990, 2, 17);
        tmpProductBasket.LG_TechnicalContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_TechnicalContactFirstName__c = 'John 1';
        tmpProductBasket.LG_TechnicalContactLastName__c = 'De Vries 2';
        tmpProductBasket.LG_TechnicalContactMiddleName__c = '';
        tmpProductBasket.LG_TechnicalContactMobile__c = '0299 654647';
        tmpProductBasket.LG_TechnicalContactPhone__c = '0299 654642';
        tmpProductBasket.LG_TechnicalContactPicklist__c = '(new Contact)';
        tmpProductBasket.LG_TechnicalContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_ValidationDate__c = date.today();
        tmpProductBasket.LG_VisitDescription__c = 'All OK';

        update tmpProductBasket;

        return tmpProductBasket;
    }


    static cscfga__Product_Basket__c BuildProductBasketForOpportunity(Opportunity tmpOpportunity,  Contact tmpContact) {
        cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Test Basket', null, null, tmpOpportunity);

        if (tmpContact != null) {
            tmpProductBasket.LG_AdminContactPicklist__c = string.valueOf(tmpContact.Id);
        }


        tmpProductBasket.LG_AdminContactDateofBirth__c = date.newinstance(1960, 2, 17);
        tmpProductBasket.LG_AdminContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_AdminContactFirstName__c = 'Davor';
        tmpProductBasket.LG_AdminContactLastName__c = 'Dubokovic';
        tmpProductBasket.LG_AdminContactMiddleName__c = '';
        tmpProductBasket.LG_AdminContactMobile__c = '0299 654647';
        tmpProductBasket.LG_AdminContactPhone__c = '0299 654648';

        tmpProductBasket.LG_AdminContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_BankAccountName__c = 'MR DD';
        tmpProductBasket.LG_BankNumber__c = 'NL10zlam2503800483';
        tmpProductBasket.LG_BillingCity__c = 'MONNICKENDAM';
        tmpProductBasket.LG_BillingCountry__c = 'Netherlands';
        tmpProductBasket.LG_BillingHouseNumber__c = '24';
        tmpProductBasket.LG_BillingHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_BillingPostalCode__c = '1141 KG';
        tmpProductBasket.LG_BillingSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_BillingStreet__c = 'Boing';
        tmpProductBasket.LG_COAXConnectionLocation__c = '';
        tmpProductBasket.LG_CreatedFrom__c = 'Tablet';
        tmpProductBasket.LG_CustomerReference__c = 'ABC123';
        tmpProductBasket.LG_InstallationCity__c = 'Amsterdam';
        tmpProductBasket.LG_InstallationCountry__c = 'Netherlands';
        tmpProductBasket.LG_InstallationHouseNumber__c = '1';
        tmpProductBasket.LG_InstallationHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_InstallationPostalCode__c = '1141 GV';
        tmpProductBasket.LG_InstallationStreet__c = 'Boing';
        tmpProductBasket.LG_InstallValidationResult__c = 'Valid';
        tmpProductBasket.LG_MainReasonLost__c = 'Delivery';
        tmpProductBasket.LG_PaymentType__c = 'Bank Transfer';
        tmpProductBasket.LG_PostalCity__c = 'Amsterdam';
        tmpProductBasket.LG_PostalCountry__c = 'Netherlands';
        tmpProductBasket.LG_PostalHouseNumber__c = '1';
        tmpProductBasket.LG_PostalHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_PostalPostalCode__c = '1141 GV';
        tmpProductBasket.LG_PostalSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_PostalStreet__c = 'Boing';
        tmpProductBasket.LG_PreferredInstallationDate__c = date.newinstance(2020, 2, 17);
        tmpProductBasket.LG_PreferredInstallationTime__c = '18.00 - 21.00';
        tmpProductBasket.LG_ResultofVisit__c = 'Quote Requested';
        tmpProductBasket.LG_SameAsAdminContact__c = false;
        tmpProductBasket.LG_SBTelephonyId__c = '';
        tmpProductBasket.LG_SharedOfficeBuilding__c = false;
        tmpProductBasket.LG_TechContactSameasBillingContact__c = false;
        tmpProductBasket.LG_TechnicalContactDateofBirth__c = date.newinstance(1990, 2, 17);
        tmpProductBasket.LG_TechnicalContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_TechnicalContactFirstName__c = 'John 1';
        tmpProductBasket.LG_TechnicalContactLastName__c = 'De Vries 2';
        tmpProductBasket.LG_TechnicalContactMiddleName__c = '';
        tmpProductBasket.LG_TechnicalContactMobile__c = '0299 654647';
        tmpProductBasket.LG_TechnicalContactPhone__c = '0299 654642';
        tmpProductBasket.LG_TechnicalContactPicklist__c = '(new Contact)';
        tmpProductBasket.LG_TechnicalContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_ValidationDate__c = date.today();
        tmpProductBasket.LG_VisitDescription__c = 'All OK';

        update tmpProductBasket;

        return tmpProductBasket;
    }


    static CSCAP__ClickApprove_Constants__c CreateClickApproveConstants() {
        /*
        BrandTemplate tmpBrandTemplate = new BrandTemplate();
        tmpBrandTemplate.Description='Letterhead for Ziggo Zakelijk Quote emails';
        tmpBrandTemplate.DeveloperName='LG_ZiggoZakelijkQuote';
        tmpBrandTemplate.IsActive=true;
        tmpBrandTemplate.Name='Ziggo Zakelijk Quote1';
        tmpBrandTemplate.Value='';
        insert tmpBrandTemplate;
        */

        CSCAP__ClickApprove_Constants__c CAC = new CSCAP__ClickApprove_Constants__c();
        CAC.CSCAP__Allow_Account_Attachments__c = true;
        CAC.CSCAP__Allow_Document_Attachments__c = true;
        CAC.CSCAP__Allow_Opportunity_Attachments__c = true;
        CAC.CSCAP__Allow_Variation_Requests__c = false;
        CAC.CSCAP__Approval_Acknowledgement_Email_Template__c = 'Customer Approval Reply';
        CAC.CSCAP__Approved_By_Customer_Stage__c = 'Customer Approved';
        CAC.CSCAP__Authoriser_Roles__c = '';
        CAC.CSCAP__Check_Returned_Files__c = false;
        CAC.CSCAP__Collect_Physical_Signature__c = false;
        CAC.CSCAP__Contact_Label__c = 'Authorised Signatories';
        CAC.CSCAP__Display_Account_Manager__c = true;
        CAC.CSCAP__Display_Comments_Field__c = true;
        CAC.CSCAP__Display_Comment_Field_on_Decline__c = true;
        CAC.CSCAP__Display_Opportunity_Owner__c = false;
        CAC.CSCAP__Enable_approval_email_body_text_editing__c = true;
        CAC.CSCAP__Enable_approval_email_subject_editing__c = false;
        CAC.CSCAP__Enable_Debug_Logging__c = false;
        CAC.CSCAP__Enable_Info_Logging__c = false;
        CAC.CSCAP__Enable_PO_Field__c = false;
        CAC.CSCAP__Enable_VAT_Field__c = false;
        CAC.CSCAP__Enable_Warning_Logging__c = false;
        CAC.CSCAP__Encryption_Key__c = 'ClickApprove data encryption key';
        CAC.CSCAP__Enforce_Site_PIN__c = false;
        CAC.CSCAP__Letterhead_Name__c = '';
        CAC.CSCAP__Make_Comment_Field_Mandatory__c = false;
        CAC.CSCAP__Make_Comment_Field_Mandatory_on_Decline__c = false;
        CAC.CSCAP__Must_Have_Attachments__c = true;
        CAC.CSCAP__Organisation_Wide_Email_Address__c = '';
        CAC.CSCAP__Rejected_By_Customer_Stage__c = 'Negotiation/Review';
        CAC.CSCAP__Render_CC_Fields__c = false;
        CAC.CSCAP__Sent_To_Customer_Stage__c = 'Quotation Delivered';
        CAC.CSCAP__Site_Address__c = 'dev-libertyglobal.cs80.force.com/partner/CSCAP__customerApproval';
        CAC.CSCAP__Site_Page_CSS__c = '';
        CAC.CSCAP__Site_Page_Language__c = 'nl_NL';
        CAC.CSCAP__Sites_Approval__c = true;
        CAC.CSCAP__Sites_Approval_Checkbox_Text__c = 'Offerte accepteren en opdracht bevestigen';
        CAC.CSCAP__Sites_Decline_Checkbox_Text__c = 'Offerte afwijzen';
        CAC.CSCAP__Template_Folder_Name__c = '';
        CAC.CSCAP__Use_Organisation_wide_email_address__c = false;
        CAC.CSCAP__Verify_Approver__c = false;
        CAC.SetupOwnerId = UserInfo.getOrganizationId();
        insert CAC;

        return CAC;
    }


    static CSCAP__Click_Approve_Setting__c CreateClickApproveSetting() {
        //Folder tmpFolder = [select Id from Folder where Type='Email Template' limit 1];
        RecordType sitesRecordType = [select Id from RecordType where Name = 'Sites Approval' limit 1];

        string HTMLBody = '<table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >';
        HTMLBody += '<tr height="400" valign="top" >';
        HTMLBody += '<td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >';
        HTMLBody += '<![CDATA[test]]></td>';
        HTMLBody += '</tr>';
        HTMLBody += '</table>';

        EmailTemplate tmpEmailNameEmailTemplate = new EmailTemplate();
        tmpEmailNameEmailTemplate.Name = 'Ziggo Zakelijk Quote Template1';
        tmpEmailNameEmailTemplate.DeveloperName = 'ZiggoZakelijkQuoteTemplate1';
        tmpEmailNameEmailTemplate.Subject = 'Offerte Ziggo Zakelijk1';
        tmpEmailNameEmailTemplate.Body = 'Test Body';
        tmpEmailNameEmailTemplate.HtmlValue = HTMLBody;
        tmpEmailNameEmailTemplate.TemplateType = 'text';
        tmpEmailNameEmailTemplate.FolderId = UserInfo.getUserId();
        //tmpEmailNameEmailTemplate.BrandTemplateId=tmpBrandTemplate.Id;
        insert tmpEmailNameEmailTemplate;

        CSCAP__Click_Approve_Setting__c CAS = new CSCAP__Click_Approve_Setting__c();
        CAS.Name = 'Sites Approval Settings - Opportunities1';
        CAS.RecordTypeId = sitesRecordType.Id;
        CAS.CSCAP__Ack_Template_Invalid_Approval__c = '';
        CAS.CSCAP__Acknowledgement_Template_Approvals__c = '';
        CAS.CSCAP__Acknowledgement_Template_Rejection__c = '';
        CAS.CSCAP__Approve_Email_New__c = '';
        CAS.CSCAP__Approve_Email_Message__c = '';
        CAS.CSCAP__Associated_Email_Template_Name__c = 'Ziggo Zakelijk Quote Template1';
        CAS.CSCAP__Send_Approval_Acknowledgment__c = false;
        CAS.CSCAP__Sites_Approval_Header__c = null;
        CAS.CSCAP__Sites_Approval_Title__c = 'Maak een opdracht van uw offerte';
        CAS.CSCAP__Status__c = 'Active';
        CAS.CSCAP__Update_Opportunity_On_Response__c = true;

        insert CAS;

        return CAS;
    }


    static cscfga__Product_Basket__c BuildProductBasketForLead(Lead tmpLead) {

        cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Test Basket', null, tmpLead, null);

        tmpProductBasket.LG_AdminContactDateofBirth__c = date.newinstance(1960, 2, 17);
        tmpProductBasket.LG_AdminContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_AdminContactFirstName__c = 'Davor';
        tmpProductBasket.LG_AdminContactLastName__c = 'Dubokovic';
        tmpProductBasket.LG_AdminContactMiddleName__c = '';
        tmpProductBasket.LG_AdminContactMobile__c = '0299 654647';
        tmpProductBasket.LG_AdminContactPhone__c = '0299 654648';
        tmpProductBasket.LG_AdminContactPicklist__c = '0';
        tmpProductBasket.LG_AdminContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_BankAccountName__c = 'MR DD';
        tmpProductBasket.LG_BankNumber__c = 'NL10zlam2503800483';
        tmpProductBasket.LG_BillingCity__c = 'MONNICKENDAM';
        tmpProductBasket.LG_BillingCountry__c = 'Netherlands';
        tmpProductBasket.LG_BillingHouseNumber__c = '24';
        tmpProductBasket.LG_BillingHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_BillingPostalCode__c = '1141 KG';
        tmpProductBasket.LG_BillingSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_BillingStreet__c = 'Boing';
        tmpProductBasket.LG_COAXConnectionLocation__c = '';
        tmpProductBasket.LG_CreatedFrom__c = 'Tablet';
        tmpProductBasket.LG_CustomerReference__c = 'ABC123';
        tmpProductBasket.LG_InstallationCity__c = 'Amsterdam';
        tmpProductBasket.LG_InstallationCountry__c = 'Netherlands';
        tmpProductBasket.LG_InstallationHouseNumber__c = '1';
        tmpProductBasket.LG_InstallationHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_InstallationPostalCode__c = '1141 GV';
        tmpProductBasket.LG_InstallationStreet__c = 'Boing';
        tmpProductBasket.LG_InstallValidationResult__c = 'Valid';
        tmpProductBasket.LG_MainReasonLost__c = 'Delivery';
        tmpProductBasket.LG_PaymentType__c = 'Bank Transfer';
        tmpProductBasket.LG_PostalCity__c = 'Amsterdam';
        tmpProductBasket.LG_PostalCountry__c = 'Netherlands';
        tmpProductBasket.LG_PostalHouseNumber__c = '1';
        tmpProductBasket.LG_PostalHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_PostalPostalCode__c = '1141 GV';
        tmpProductBasket.LG_PostalSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_PostalStreet__c = 'Boing';
        tmpProductBasket.LG_PreferredInstallationDate__c = date.newinstance(2020, 2, 17);
        tmpProductBasket.LG_PreferredInstallationTime__c = '18.00 - 21.00';
        tmpProductBasket.LG_ResultofVisit__c = 'Quote Requested';
        tmpProductBasket.LG_SameAsAdminContact__c = false;
        tmpProductBasket.LG_SBTelephonyId__c = '';
        tmpProductBasket.LG_SharedOfficeBuilding__c = false;
        tmpProductBasket.LG_TechContactSameasBillingContact__c = false;
        tmpProductBasket.LG_TechnicalContactDateofBirth__c = date.newinstance(1990, 2, 17);
        tmpProductBasket.LG_TechnicalContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_TechnicalContactFirstName__c = 'John 1';
        tmpProductBasket.LG_TechnicalContactLastName__c = 'De Vries 2';
        tmpProductBasket.LG_TechnicalContactMiddleName__c = '';
        tmpProductBasket.LG_TechnicalContactMobile__c = '0299 654647';
        tmpProductBasket.LG_TechnicalContactPhone__c = '0299 654642';
        tmpProductBasket.LG_TechnicalContactPicklist__c = '(new Contact)';
        tmpProductBasket.LG_TechnicalContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_ValidationDate__c = date.today();
        tmpProductBasket.LG_VisitDescription__c = 'All OK';

        update tmpProductBasket;

        return tmpProductBasket;
    }



    static testMethod void TestProductBasketUploadFromAccount_QuoteRequested() {
        //generate Account
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', Date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForAccount(tmpAccount, tmpContact);

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        list<cscfga__Attribute__c> lstAtt = new list<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

   /*     insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        list<Opportunity> lstOpp = [select Id from Opportunity where AccountId = : tmpAccount.Id];
        System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');   */
    }

/*
    static testMethod void TestProductBasketUploadFromAccount_QuoteRequested_InsertAttachment() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];

        User u;

        System.runAs ( thisUser ) {
            No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
            noTriggers.Flag__c = false;
            noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
            upsert noTriggers;
            CreateClickApproveSetting();
            CreateClickApproveConstants();

            Profile p = [select id from profile where name = 'System Administrator'];
            //UserRole r = [select id from userrole where name = 'UM_DelegatedSystemAdministrator'];

            u = new User(alias = 'standt',
                         email = 'standarduser@testorg.com',
                         emailencodingkey = 'UTF-8',
                         lastname = 'Testing',
                         languagelocalekey = 'nl_NL',
                         localesidkey = 'en_US',
                         profileid = p.Id,
                         /* userroleid = r.Id, */
/*                         timezonesidkey = 'America/Los_Angeles',
                         username = 'standarduser@testorg.com.ziggo',
                         CompanyName = 'Test Company');
        }

        System.runAs (u) {
            //generate Account
            Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
            Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', Date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

            //generate Discounts
            LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
            LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
            LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

            cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

            //generate Product Definition
            cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
            tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
            insert tmpProductDefinition;

            //generate Attribute Definitions
            //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
            //string OPTKey, string OLIType, string ProductDetailType
            cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
            cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
            cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
            cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
            cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
            cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
            cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
            cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
            cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

            cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForAccount(tmpAccount, tmpContact);

            cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
            cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, String.valueof(tmpDiscountPromotionalAction.Id), false);
            cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
            cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
            cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
            cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
            cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
            cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

            string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

            cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

            string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

            cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

            List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();

            lstAtt.add(attTotalBasicPrice);
            lstAtt.add(attAdditionalDiscount);
            lstAtt.add(attClosingDealDiscount);
            lstAtt.add(attDiscount);
            lstAtt.add(attUploadSpeed);
            lstAtt.add(attContractTerm);
            lstAtt.add(attInternetSpeed);
            lstAtt.add(attPortingJSON);
            lstAtt.add(attPortingJSON2);

            insert lstAtt;

            tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
            update tmpProductBasket;

            list<Opportunity> lstOpp = [select Id from Opportunity where AccountId = : tmpAccount.Id];
            System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');

            Test.startTest();

            LG_GeneralTest.createAttachment(lstOpp[0].Id, 'PDF Quote');

            Test.stopTest();
        }
    }
*/
    static testMethod void TestProductBasketUploadFromAccount_CustomerApproved() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        //generate Account
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', Date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');


        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForAccount(tmpAccount, tmpContact);
        tmpProductBasket.LG_ResultofVisit__c = 'Customer Approved';
        update tmpProductBasket;

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, String.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        list<cscfga__Attribute__c> lstAtt = new list<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

   /*     insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        list<Opportunity> lstOpp = [select Id from Opportunity where AccountId = : tmpAccount.Id];
        System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');   */
    }

    static testMethod void TestProductBasketUploadFromAccount_CustomerRejected() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        //generate Account
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', Date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForAccount(tmpAccount, tmpContact);
        tmpProductBasket.LG_ResultofVisit__c = 'Customer Rejected';
        update tmpProductBasket;

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        list<cscfga__Attribute__c> lstAtt = new list<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

     /*   insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        list<Opportunity> lstOpp = [select Id from Opportunity where IsClosed = true and IsWon = false and AccountId = : tmpAccount.Id];
        System.assertEquals(1, lstOpp.size(), 'Number of created closed lost Opps must be 1');  */
    }


    static testMethod void TestProductBasketUploadFromLead_QuoteRequested() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        //generate Lead
        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForLead(tmpLead);

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        String JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        String JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

      /*  insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        List<Opportunity> lstOpp = [select Id from Opportunity where LG_LeadId__c = : tmpLead.Id];
        // System.assertEquals(1,lstOpp.size(),'Number of created Opps must be 1');

        List<Lead> lstLead = [select Id from Lead where IsConverted = true and Id = :tmpLead.Id];
        // System.assertEquals(1,lstOpp.size(),'Number of converted Leads must be 1');	*/
    }
/*
    static testMethod void TestAttachmentUpdate() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');

        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

        Opportunity Opp = LG_GeneralTest.CreateOpportunity(tmpAccount, true);

        OpportunityContactRole optcntrole = new OpportunityContactRole();
        optcntrole.ContactId = tmpContact.Id;
        optcntrole.IsPrimary = true;
        optcntrole.OpportunityId = Opp.Id;
        optcntrole.Role = 'Business User';
        insert optcntrole;

        test.startTest();

        Attachment tmpAttachment = LG_GeneralTest.createAttachment(Opp.Id, 'PDF Quote');
        tmpAttachment.Name = 'Test 123';
        update tmpAttachment;

        Attachment tmpAttachment2 = LG_GeneralTest.createAttachment(Opp.Id, 'PDF Quote2');

        test.stopTest();
    }
*/
    static testMethod void TestProductBasketUploadFromLead_CustomerApproved() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
		
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        //generate Account
        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForLead(tmpLead);
        tmpProductBasket.LG_ResultofVisit__c = 'Customer Approved';
        update tmpProductBasket;

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        String JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        String JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

        insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE LG_LeadId__c = :tmpLead.Id];
        // System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');

        List<Lead> lstLead = [SELECT Id FROM Lead WHERE IsConverted = true and Id = :tmpLead.Id];
        // System.assertEquals(1, lstOpp.size(), 'Number of converted Leads must be 1');
    }

    static testMethod void TestProductBasketUploadFromLead_CustomerRejected() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
		
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        //generate Account
        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        //string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        //string OPTKey, string OLIType, string ProductDetailType
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForLead(tmpLead);
        tmpProductBasket.LG_ResultofVisit__c = 'Customer Rejected';
        update tmpProductBasket;

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';
        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';
        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

        insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        List<Opportunity> lstOpp = [select Id from Opportunity where LG_LeadId__c = :tmpLead.Id];
        // System.assertEquals(1,lstOpp.size(),'Number of created Opps must be 1');

        List<Lead> lstLead = [select Id from Lead where IsConverted = true and Id = :tmpLead.Id];
        // System.assertEquals(1,lstOpp.size(),'Number of converted Leads must be 1');
    }

    static testMethod void TestProductBasketFromOpportunity() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        //generate Account
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');

        Opportunity Opp = LG_GeneralTest.CreateOpportunity(tmpAccount, true);

        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');

        OpportunityContactRole optcntrole = new OpportunityContactRole();
        optcntrole.ContactId = tmpContact.Id;
        optcntrole.IsPrimary = true;
        optcntrole.OpportunityId = Opp.Id;
        optcntrole.Role = 'Business User';
        insert optcntrole;

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);

        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);

        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForOpportunity(Opp, tmpContact);
        tmpProductBasket.LG_ResultofVisit__c = 'Customer Approved';
        tmpProductBasket.cscfga__Opportunity__c = Opp.Id;
        update tmpProductBasket;

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, String.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        String JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        String JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

        insert lstAtt;

        Test.startTest();
        System.debug('*****start testing');
        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        System.debug('***tmpProductBasket=' + tmpProductBasket);
        System.debug('***attUploadSpeed=' + attUploadSpeed);
        System.debug('***pcInternet=' + pcInternet);

        attUploadSpeed.cscfga__Value__c = '50';
        update attUploadSpeed;

        System.debug('*****after tmpProductBasket=' + tmpProductBasket);

        List<cscfga__Product_Basket__c> lstPB = [SELECT Id FROM cscfga__Product_Basket__c WHERE csordtelcoa__Synchronised_with_Opportunity__c = false AND Id = :tmpProductBasket.Id];

        System.debug('*****end testing');
        Test.stopTest();

        System.assertEquals(1, lstPB.size(), 'Number of unsynced Product Baskets must be 1');
    }
}
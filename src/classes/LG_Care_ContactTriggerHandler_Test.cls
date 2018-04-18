@isTest
public class LG_Care_ContactTriggerHandler_Test {
public static testMethod void setUpMethod() {


        Account acc = new Account();
        acc.Name = 'Test Account 2';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;
        
        
        Contact con = new Contact();
        con.Email = 'rishi.kapoor@gmail.com';
        con.LG_DecisionMaker__c = true;
        con.HasOptedOutOfEmail = false;
        con.Salutation ='Mr.';
        con.LastName = 'Kapoor';
        con.FirstName = 'Rishi';
        con.AccountId = acc.Id;
        con.LG_Role__c = 'Business User;Financial Contact';
        con.Generate_Activation_Code__c=True;
        insert con;
        
        csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
        ba.csconta__Account__c = acc.id;
        ba.Billing_Contact__c = con.id;
        insert ba;
        
        con.FirstName='Nilesh';
        Update con;
       
        system.assertnotequals('',[select id,B2B_Activation_Code__c from Contact where id=:con.id].B2B_Activation_Code__c );
         system.debug('Code@3'+[select id,B2B_Activation_Code__c from Contact where id=:con.id].B2B_Activation_Code__c);






}



    }
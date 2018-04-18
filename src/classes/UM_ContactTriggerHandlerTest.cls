@isTest
public class UM_ContactTriggerHandlerTest {

    public static testMethod void  testContactUpdate(){
        
        account acc = new account();
        acc.Name = 'Test';
        acc.LG_Segment__c = 'SME';
        acc.UM_IndustryClassification__c = 'A_LAND_UND_FORSTWIRTSCHAFT_FISCHEREI';
        insert acc;
        
        contact con = new Contact(AccountId=acc.id);
        con.Salutation = 'Mr'; 
        con.firstname = 'First';
        con.LastName = 'Last';
		insert con;
        
       	csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
        ba.csconta__Account__c = acc.id;
        ba.Billing_Contact__c = con.id;
        insert ba;
        
        con.FirstName = 'New First';
        update con;
        
        System.assertEquals(true, [select id,UM_IsAccountSynced__c from csconta__Billing_Account__c where id=:ba.id].UM_IsAccountSynced__c);
        
    }
}
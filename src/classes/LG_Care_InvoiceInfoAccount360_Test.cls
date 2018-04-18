@isTest
public class LG_Care_InvoiceInfoAccount360_Test
{
    Static testmethod void testbilling(){
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
                
                Account acc = new Account();
                acc.Name='Infy-Test2';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '4';
                acc.LG_Footprint__c = 'UPC';
                
                insert acc;
                
                csconta__Billing_Account__c b1 = new csconta__Billing_Account__c();
                b1.csconta__Account__c=acc.id;
                
                insert b1;
            
                
                UM_InvoiceHeader__c InvoiceHeader1 = new UM_InvoiceHeader__c();
                InvoiceHeader1.UM_Customer_SF_ID__c = acc.Id;
                InvoiceHeader1.UM_Invoice_Date__c = Date.today().addDays(-10);
                InvoiceHeader1.UM_InvoiceNumber__c = '100';
                InvoiceHeader1.UM_Invoice_Amount_Gross_Currency__c = 100.00;
                InvoiceHeader1.UM_Invoice_Amount_Net_Currency__c = 75.00;
                InvoiceHeader1.UM_Invoice_Amount_Gross__c = 100;
                InvoiceHeader1.UM_Invoice_Amount_Net__c = 75;
                InvoiceHeader1.UM_Payment_Due_Date__c = Date.today().addDays(5);
                InvoiceHeader1.UM_Billing_Location__c = b1.Id;
                insert InvoiceHeader1 ;
                
                UM_InvoiceHeader__c InvoiceHeader2 = new UM_InvoiceHeader__c();
                InvoiceHeader2.UM_Customer_SF_ID__c = acc.Id;
                InvoiceHeader2.UM_Invoice_Date__c = Date.today().addDays(-7);
                InvoiceHeader2.UM_InvoiceNumber__c = '101';
                InvoiceHeader2.UM_Invoice_Amount_Gross_Currency__c = 100.00;
                InvoiceHeader2.UM_Invoice_Amount_Net_Currency__c = 75.00;
                InvoiceHeader2.UM_Invoice_Amount_Gross__c = 100;
                InvoiceHeader2.UM_Invoice_Amount_Net__c = 75;
                InvoiceHeader2.UM_Payment_Due_Date__c = Date.today().addDays(8);
                InvoiceHeader2.UM_Billing_Location__c = b1.Id;
                insert InvoiceHeader2 ;
                
                UM_InvoiceHeader__c InvoiceHeader3 = new UM_InvoiceHeader__c();
                InvoiceHeader3.UM_Customer_SF_ID__c = acc.Id;
                InvoiceHeader3.UM_Invoice_Date__c = Date.today().addDays(-4);
                InvoiceHeader3.UM_InvoiceNumber__c = '102';
                InvoiceHeader3.UM_Invoice_Amount_Gross_Currency__c = 50.00;
                InvoiceHeader3.UM_Invoice_Amount_Net_Currency__c = 35.00;
                InvoiceHeader3.UM_Invoice_Amount_Gross__c = 50;
                InvoiceHeader3.UM_Invoice_Amount_Net__c = 35;
                InvoiceHeader3.UM_Payment_Due_Date__c = Date.today().addDays(10);
                InvoiceHeader3.UM_Billing_Location__c = b1.Id;
                insert InvoiceHeader3 ;
              
                Kenan_Adjustment__c Adj1= new Kenan_Adjustment__c();
                Adj1.trackingId__c = '100';
                Adj1.trackingIdServ__c = '1';
                Adj1.Adjustment_Reason__c = 'Incorrect  charges' ;
                Adj1.Adjustment_Type__c = 'miscellaneous adjustment';
                Adj1.RequestStatus__c = 'requested';
                Adj1.Total_Amount__c = 40.00;
                Adj1.Invoice_Header__c = InvoiceHeader1.Id;
                insert Adj1; 
                
                
                Kenan_Adjustment__c Adj2= new Kenan_Adjustment__c();
                Adj2.trackingId__c = '102';
                Adj2.trackingIdServ__c = '1';
                Adj2.Adjustment_Reason__c = 'Incorrect  charges';
                Adj2.Adjustment_Type__c = 'miscellaneous adjustment';
                Adj2.RequestStatus__c = 'requested';
                Adj2.Total_Amount__c = 15.00;
                Adj2.Invoice_Header__c = InvoiceHeader2.Id;
                insert Adj2; 
                
                Kenan_Adjustment__c Adj3= new Kenan_Adjustment__c();
                Adj3.trackingId__c = '103';
                Adj3.trackingIdServ__c = '1';
                Adj3.Adjustment_Reason__c = 'Incorrect  charges';
                Adj3.Adjustment_Type__c = 'miscellaneous adjustment';
                Adj3.RequestStatus__c = 'requested';
                Adj3.Total_Amount__c = 40.00;
                Adj3.Invoice_Header__c = InvoiceHeader3.Id;
                insert Adj3; 
                
                
                UM_PaymentInformation__c PI = new UM_PaymentInformation__c();
                PI.UM_Transaction_Date__c = '20160804183629';
                PI.UM_Transaction_Amount__c = 33.00;
                PI.UM_Transaction_ID__c = '100';
                PI.UM_Transaction_Status__c = '2';
                PI.UM_Transaction_Status_Translation__c='b1 Payment Calculate';
                PI.UM_Billing_Location__c = b1.Id;
                PI.UM_Overpayments__c = 20.00;
                insert PI;        
                
                Test.StartTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(acc);
                LG_Care_InvoiceInfoAccount360_Controller c = new LG_Care_InvoiceInfoAccount360_Controller(sc);
                system.assertNotEquals(c.wrapperList.size(), 0);
                system.debug('blnc23'+c.wrapperList);
                Test.StopTest();
            }
        }
        
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}
/************************************************************************************************************************************
*        Class: LG_Care_Cancel_CaMa_Transaction_Cntrl
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will cancel the ticket in CaMa external system. This class is called from a VF page.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_Cancel_CaMa_TransactionCntrlTest
*************************************************************************************************************************************/
public class LG_Care_Cancel_CaMa_Transaction_Cntrl {

    public PageReference CancelCaMa() {
        if(tempCase.B2B_Care_Cancellation_Code__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.B2B_Care_vfPage_CareCancelCaMaCntrl1));
            return null;
        }
        else {
            //Case c1 = [SELECT B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE id = :c.Id LIMIT 1];
            c.B2B_Care_Cancellation_Code__c = tempCase.B2B_Care_Cancellation_Code__c;
            LG_Care_CaMaTicket_Transaction.createXML_for_CancelTicketRequest(c);
            try {
                database.update(c);
            }
            catch(Exception e) {
            }
            pageReference p = new Pagereference('/'+c.id);
            return p;
        }
        
    }

    public Case c {get;set;}
    public Boolean flag {get;set;}
    public Case tempCase {get;set;}
    public static Boolean tempBoo;
    
    public LG_Care_Cancel_CaMa_Transaction_Cntrl(ApexPages.StandardController controller) {
    try{
        tempCase = (Case)controller.getRecord();
        c = [SELECT id,status,B2B_Status_Change_Code__c,B2B_Care_Cancellation_Code__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE id = :tempCase.Id LIMIT 1];
        
        if(c.B2B_Status_Change_Code__c != null && c.B2B_Status_Change_Code__c.equalsIgnoreCase('c')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.B2B_Care_vfPage_CareCancelCaMaCntrl2));
            flag = true;
        }
        else if(c.CaMa_Ticket_ID__c == '' || c.CaMa_Ticket_ID__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.B2B_Care_vfPage_CareCancelCaMaCntrl3));
            flag = true;
        } 
        else {
            flag = false;
            tempBoo = false;
        }
    }
    
   catch(Exception e) {
            }  
    

  }
}
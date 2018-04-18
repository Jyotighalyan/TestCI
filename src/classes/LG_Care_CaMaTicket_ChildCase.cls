/************************************************************************************************************************************
*        Class: LG_Care_CaMaTicket_ChildCase
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It creates a child CaMa case for a technical case then calls the CaMa system to create a create a case there as well.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_CaMaTicket_ChildCase_Test
*************************************************************************************************************************************/
global class LG_Care_CaMaTicket_ChildCase {

 @invocableMethod(Label='ChildCase')
    Webservice static void createChildCase(List<id> cId) {
        try {
            case csnew=[Select id, parent.id,B2B_Order_Comment__c from Case where id=:cId[0]];
            Case tempCase = [SELECT type,LG_Service__c,Description,AccountId FROM Case WHERE id =:csnew.parent.id LIMIT 1];
            String rtId = [SELECT ID FROM RecordType where SobjectType = 'Case' and DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM' limit 1].Id;
            Case camaCase = new Case();
            camaCase.id=cId[0];
            camaCase.RecordTypeId = rtId;
            Account acc = [SELECT name FROM Account WHERE id = :tempCase.accountId];
            if(tempCase.LG_Service__c != null) {
                Case sId = tempCase;
                cscrm__Address__c add = [SELECT cscrm__State_Province__c,(SELECT LG_ProductFamily__c,LG_ProvisioningAccountNo__c,LG_ProvisioningSystemID__c FROM Services__r WHERE id = :sId.LG_Service__c) FROM cscrm__Address__c WHERE id in (SELECT LG_Address__c FROM csord__Service__c WHERE id = :sId.LG_Service__c)];
                if(add != null) {
                    if(add.cscrm__State_Province__c != null) {
                        if(add.cscrm__State_Province__c.startswithignorecase('N'))
                            camaCase.B2B_Region__c = 'NRW';
                        else if(add.cscrm__State_Province__c.startswithignorecase('H'))
                            camaCase.B2B_Region__c = 'HSN';
                        else if(add.cscrm__State_Province__c.startswithignorecase('B'))
                            camaCase.B2B_Region__c = 'BW';
                    }
                    if(add.services__r != null) {
                        csord__Service__c service = add.services__r;
                        
                        if(service.LG_ProvisioningAccountNo__c != null && service.LG_ProvisioningAccountNo__c != '') {
                            camaCase.B2B_Customer_Number__c = service.LG_ProvisioningAccountNo__c;    
                        }
                        if(service.LG_ProductFamily__c != null && service.LG_ProductFamily__c != '') {
                            if(service.LG_ProductFamily__c.containsIgnoreCase('Internet')){
                                camaCase.B2B_Outage_Service__c = 'INTERNET';
                            }
                            else if(service.LG_ProductFamily__c.containsIgnoreCase('Voice') || service.LG_ProductFamily__c.containsIgnoreCase('Phone')){
                                camaCase.B2B_Outage_Service__c = 'TELEPHONY';
                            }
                            else if(service.LG_ProductFamily__c.containsIgnoreCase('TV')){
                                camaCase.B2B_Outage_Service__c = 'DTV';
                            }
                            else{
                                camaCase.B2B_Outage_Service__c = 'ALL';
                            }
                        }
                        else{
                            camaCase.B2B_Outage_Service__c = 'ALL';
                        }
                    }
                    //camaCase.LG_Service__c = sId.LG_Service__c;
                }
            }
            
            camaCase.ParentId = csnew.parent.id;
            UM_CaMa_Order_Type__c camaOrdType = UM_CaMa_Order_Type__c.getInstance('SME');
            camaCase.B2B_Order_Type__c = camaOrdType.UM_Order_Type__c;
            
           /* if(tempCase.Type == 'Installation') {
                camaCase.B2B_Order_Type__c = 'S2B';
            }
            else {
                camaCase.B2B_Order_Type__c = 'F2B';
            }
            */
            if(camaCase.B2B_Outage_Service__c == 'TELEPHONY')
                camaCase.B2B_Problem_Code__c = 'G7'; //change it to H1
            else
                camaCase.B2B_Problem_Code__c = 'B5';
            camaCase.B2B_Source_Code__c = '02';
            
            if(tempCase.Type == 'Installation' || tempCase.Type == 'Service Down' || tempCase.Type == 'Infrastructure') {
                camaCase.B2B_Outage_Type__c = 'FAILURE';
            }
            else {
                camaCase.B2B_Outage_Type__c = 'IMPAIRMENT';
            }
            
            camaCase.B2B_Customer_Situation__c = 'Customer situation'; //Not clear
           
            camaCase.B2B_Ticket_Priority__c = '1';
            //camaCase.B2B_Order_Remarks__c = c.Description;
            camaCase.B2B_Order_Comment__c = csnew.B2B_Order_Comment__c ;
            
            //Arguments for Cancellation
            //camaCase.CaMa_Ticket_ID__c = c.CaMa_Ticket_ID__c;
                        
            camaCase.B2B_Success__c = false;
            camaCase.B2B_Account_Name__c = acc.name;
                     
            Database.Update(camaCase);
            System.debug('Inside 4'+camaCase);
            
            LG_Care_CaMaTicket_Transaction.createXML_for_CreateTicketRequest(camaCase);
            
            
        }
        Catch(Exception e) {
            throw e;
            
        }
    } 
}
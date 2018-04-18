public class LG_AttachmentTriggerHandler 
{
    public static void AfterUpdateHandle(List<Attachment> lstAttachmentNew, List<Attachment> lstAttachmentOld)
    {
        
    }
    
    public static void AfterInsertHandle(List<Attachment> lstAttachmentNew)
    {
        SendEmailQuote(lstAttachmentNew);
        
        //Unchecked because not sure when to sind files
        SendToMPI(lstAttachmentNew);
    }
    
    
    private static list< CSCAP__Click_Approve_Setting__c> lstCAS = null;
    
    private static Id GetSiteApprovalSettingId()
    {
        Id CASId=null;
        
        if (lstCAS==null)
        {
            lstCAS = [select Id, Name from CSCAP__Click_Approve_Setting__c c
                where Name='Site Approve - Opportunity' limit 1];
        }
        
        if (lstCAS.size()>0)
        {
            CASId = lstCAS[0].Id;
        }
        
        return CASId;
    }
    
    private static void SendEmailQuote(List<Attachment> lstAttachmentNew)
    {
        
        if (GetSiteApprovalSettingId()!=null)//so there is a setting created
        {
            map<Id,set<Id>> mapOppIdsetAttachmentId = new map<Id,set<Id>>();
            
            for (Attachment tmpAttachment : lstAttachmentNew)
            {
                if (string.valueOf(tmpAttachment.ParentId).startswith('006'))
                {
                    if (mapOppIdsetAttachmentId.containsKey(tmpAttachment.ParentId))
                    {
                        set<Id> setAttachmentId = mapOppIdsetAttachmentId.get(tmpAttachment.ParentId);
                        setAttachmentId.add(tmpAttachment.Id);
                    }
                    else
                    {
                        set<Id> setAttachmentId = new set<Id>();
                        setAttachmentId.add(tmpAttachment.Id);
                        mapOppIdsetAttachmentId.put(tmpAttachment.ParentId,setAttachmentId);
                    }
                }
            }
            
            
            if (mapOppIdsetAttachmentId.size()>0)
            {
                CSCAP.API_1.MultipleSendApprovalRequestRecord tmpMultipleSendApprovalRequestRecord;
                list<CSCAP.API_1.MultipleSendApprovalRequestRecord> lstMultipleSendApprovalRequestRecord = new list<CSCAP.API_1.MultipleSendApprovalRequestRecord>();
                
                list<Opportunity> lstOpportunity = [select Id, LG_AutomatedQuoteDelivery__c, StageName, 
                    (select ContactId, OpportunityId, Role From OpportunityContactRoles) 
                    from Opportunity
                    where LG_AutomatedQuoteDelivery__c='Quote Requested'
                    and Id in : mapOppIdsetAttachmentId.keyset()];  
                
                
                for (Opportunity tmpOpportunity : lstOpportunity)
                {
                    Id recepientId=null;
                    
                    
                    for (OpportunityContactRole tmpOpportunityContactRole : tmpOpportunity.OpportunityContactRoles)
                    {
                        if (tmpOpportunityContactRole.Role=='Business User')
                        {
                            recepientId=tmpOpportunityContactRole.ContactId;
                            break;
                        }
                        else if (tmpOpportunityContactRole.Role=='Administrative Contact')
                        {
                            recepientId=tmpOpportunityContactRole.ContactId;
                            break;
                        }
                        else
                        {
                            recepientId=tmpOpportunityContactRole.ContactId;
                            break;                      
                        }
                    }
                    
                    set<Id> setAttachmentId = mapOppIdsetAttachmentId.get(tmpOpportunity.Id);
                    
                    //added by trupti
                    List<attachment> attachmentList= [select id from attachment where parentId =:tmpOpportunity.Id AND name =: LABEL.LG_LegalDocName limit 1];
                    if(!attachmentList.isEmpty())
                        setAttachmentId.add(attachmentList[0].id);
                    //end
                    
                    if (recepientId!=null)
                    {

                        tmpMultipleSendApprovalRequestRecord = new CSCAP.API_1.MultipleSendApprovalRequestRecord();
                        tmpMultipleSendApprovalRequestRecord.approvalObjectId=tmpOpportunity.Id;
                        tmpMultipleSendApprovalRequestRecord.recipientContactId=recepientId;
                        tmpMultipleSendApprovalRequestRecord.clickApproveSettingId=GetSiteApprovalSettingId();
                        tmpMultipleSendApprovalRequestRecord.attachmentIds = setAttachmentId;
                        tmpMultipleSendApprovalRequestRecord.documentIds=null;
                        tmpMultipleSendApprovalRequestRecord.cc=null;
                        tmpMultipleSendApprovalRequestRecord.bcc=null;
                        
                        system.debug('***tmpMultipleSendApprovalRequestRecord=' + tmpMultipleSendApprovalRequestRecord);
                        
                        lstMultipleSendApprovalRequestRecord.add(tmpMultipleSendApprovalRequestRecord);
                        
                    }
                    
                    tmpOpportunity.LG_AutomatedQuoteDelivery__c='Quote Sent';
                    tmpOpportunity.StageName='Quotation Delivered';
                }
                
                system.debug('***lstOpportunity=' + lstOpportunity);
                system.debug('***lstMultipleSendApprovalRequestRecord=' + lstMultipleSendApprovalRequestRecord);
                
                update lstOpportunity;
                
                if(!Test.isRunningTest()) //added by trupti
                {
                if (lstMultipleSendApprovalRequestRecord.size()>0)
                    CSCAP.API_1.MultipleSendApprovalRequest(lstMultipleSendApprovalRequestRecord);
                }    
                    
            }
        }
    }
    
    
    public static void BeforeUpdateHandle(List<Attachment> lstAttachmentNew, List<Attachment> lstAttachmentOld)
    {
        
    }
    
    public static void BeforeInsertHandle(List<Attachment> lstAttachmentNew)
    {

    }

    /**
      * Method that is used to send data to MPI based on trigger
      *
      * @param lstAttachmentNew     List of attachments
      *
      * @mention Method is not bulkified based on no mass upload of attachments
      */
      
    /*****************************************************************************************************************************
         * @author     : Shubham Mittal
         * @CATGOV     : 131
         * @date        : 17-Jan-2017
         * @Modification Purpose     : For making state as Picklist(Line 180-182)
    *****************************************************************************************************************************/
    public static void SendToMPI(List<Attachment> lstAttachmentNew){
        for(Attachment att : lstAttachmentNew){
            if(string.valueOf(att.ParentId).startswith('006')){
                //Get Opportunity
                Opportunity opp = [select Account.LG_AccountNumber__c, Account.Name, Account.LG_PostalStreet__c, Account.LG_PostalHouseNumber__c,
                                   Account.LG_PostalPostalCode__c,Account.LG_PostalCity__c,Account.LG_PostalCountry__c,Account.UM_VisitStateProvince__c,
                                   (SELECT Contact.Email,contact.Name,IsPrimary, Role FROM OpportunityContactRoles WHERE Role = 'Administrative Contact' AND IsPrimary = true limit 1 )
                                   from Opportunity where Id =: att.ParentId];
                                   
                String accountId = opp.Account.LG_AccountNumber__c;
                string companyName=opp.Account.Name;
                string Street=opp.Account.LG_PostalStreet__c+' '+opp.Account.LG_PostalHouseNumber__c;
                string city=opp.Account.LG_PostalPostalCode__c+' '+opp.Account.LG_PostalCity__c;
                string country=opp.Account.LG_PostalCountry__c;
                string region=opp.Account.UM_VisitStateProvince__c;
                /*if(region!=null){
                    if(region.startsWith('N')) region='Nordrhein-Westfalen (NRW)';                 
                    else if(region.startsWith('H')) region='Hessen';
                    else if(region.startsWith('B')) region='Baden-Württemberg (BW)';
                }*/
                string emailAddress;
                string contactName;
                if(opp.OpportunityContactRoles.size()>0){
                    contactname=opp.OpportunityContactRoles[0].contact.Name;
                    emailAddress=opp.OpportunityContactRoles[0].contact.email;
                }
                system.debug('Region is:'+region+'customer-no is:'+accountId+'company is:'+companyName+'contact is:'+contactName);
                system.debug('street is:'+street+'city is:'+city+'country is:'+country+'email is:'+emailAddress);               
                //Send quotes to MPI
                Blob file_body = att.Body;
                String file_name = att.Name;
                Map<String, String> metaMap = new Map<String, String>();
                if(contactName!=null){                  
                    metaMap = new Map<String, String>{'document-type' => 'pdf',
                                                                      'region' => region,                                                                     
                                                                      'customer-no' => accountId,
                                                                      'company' => companyName,
                                                                      'contact' => contactname,
                                                                      'street' => Street,
                                                                      'city' => city,
                                                                      'country' => country,
                                                                      'email' =>emailAddress};  
                }
                else{
                    metaMap = new Map<String, String>{'document-type' => 'pdf',
                                                                      'region' => region,                                                                     
                                                                      'customer-no' => accountId,
                                                                      'company' => companyName,
                                                                      'street' => Street,
                                                                      'city' => city,
                                                                      'country' => country};
                }
                
                if(!Test.isRunningTest()) //added by trupti
                {
                    if(file_name != LABEL.LG_LegalDocName)
                    {
                        UM_MPIUtility.deliverFile(file_name, file_body, metaMap);
                    }
                }
            }
        }
    }
}
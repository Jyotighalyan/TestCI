public with sharing class LG_LeadUpdateTriggerHandler {
    
    Set<String> prodFamilySet = new Set<String>();
    Set<String> postalCodeSet = new Set<String>();
    Set<String> accontNameSet = new Set<String>();
    Set<ID> ownerIDSet = new Set<ID>();
    
    Map<String, List<Lead_Assignment_Table__c>> prodFAndleadATMap = new Map<String, List<Lead_Assignment_Table__c>>();
    Map<String, Lead_Assignment_Table__c> postalCodeAndleadATMap = new Map<String, Lead_Assignment_Table__c>();
    Map<ID, Account> accMap;
    
    Lead_Assignment_Table__c  leadAssignTonPFnPCNull;
    List<Lead_Assignment_Table__c>  LATList;
    Boolean haveNull = false;
    
    ID queueID = Queue_Name__c.getInstance('QueueName').QueueID__c;
    
    public void createLeadAssignmentMap(List<Lead> leadList){
        for(Lead lead: leadList){
            if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c == NULL){
                haveNull = true;
            }
            else if(lead.UM_Product__c != NULL){
                prodFamilySet.add(lead.UM_Product__c);
            }
            else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c != NULL){
                String postalcode = lead.LG_VisitPostalCode__c.substring(0, 3);
                postalCodeSet.add(postalcode);
                //postalCodeSet.add(lead.LG_VisitPostalCode__c);
            }
            if(lead.LG_MatchingAccount__c != NULL){
                accontNameSet.add(lead.LG_MatchingAccount__c);
            }
        }
        
        if(haveNull && (prodFamilySet.size() > 0 || postalCodeSet.size() > 0)){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c = NULL AND Postal_Code__c = NULL)
                       OR Product_Family__c IN :prodFamilySet OR Postal_Code__c IN :postalCodeSet];
        }
        else if(haveNull){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c = NULL AND Postal_Code__c = NULL)];
        }
        else if(prodFamilySet.size() > 0 || postalCodeSet.size() > 0){
            LATList = [SELECT Id, Product_Family__c, Postal_Code__c, Lead_Assignee__c, Assign_to_Queue__c 
                       FROM Lead_Assignment_Table__c 
                       WHERE (Product_Family__c IN :prodFamilySet OR Postal_Code__c IN :postalCodeSet)];
        }
        
        System.debug('LATList::'+LATList.size()+'-->'+LATList);
        
        for(Lead_Assignment_Table__c leadAssignT : LATList){
            
            ownerIDSet.add(leadAssignT.Lead_Assignee__c);
            
            List<Lead_Assignment_Table__c> ltList = new List<Lead_Assignment_Table__c>();
            
            if(leadAssignT.Product_Family__c != NULL){
                if(prodFAndleadATMap.get(leadAssignT.Product_Family__c) != null){
                    ltList.add(leadAssignT);
                    ltList.addAll(prodFAndleadATMap.get(leadAssignT.Product_Family__c));
                    prodFAndleadATMap.put(leadAssignT.Product_Family__c, ltList);
                }
                else{
                    ltList.add(leadAssignT);
                    prodFAndleadATMap.put(leadAssignT.Product_Family__c, ltList);
                }
            }
            else if(leadAssignT.Product_Family__c == NULL && leadAssignT.Postal_Code__c != NULL){
                postalCodeAndleadATMap.put(leadAssignT.Postal_Code__c, leadAssignT);
            }
            else{
                system.debug('Inside else::'+leadAssignT);
                leadAssignTonPFnPCNull = leadAssignT;
            }            
        }
        if(accontNameSet.size() > 0){
            accMap = new Map<ID, Account>([SELECT ID, OwnerId FROM Account WHERE Id IN :accontNameSet]);
        }        
    }
    
    public void automaticLeadAssign(List<lead> leadList){
        for(Lead lead:leadList){
            if(lead.OwnerId == queueID){
                if(lead.LG_MatchingAccount__c != NULL && accMap.containsKey(lead.LG_MatchingAccount__c)){
                    lead.OwnerId = accMap.get(lead.LG_MatchingAccount__c).OwnerID;
                    lead.LeadAssignmentErrorMsg__c = '';
                    lead.Assigned_Date__c = Date.Today();
                }
                else if(lead.LG_MatchingAccount__c != NULL && !accMap.containsKey(lead.LG_MatchingAccount__c)){
                    lead.LeadAssignmentErrorMsg__c = 'Account found on Lead but not under Account object';
                }
                else if(prodFAndleadATMap.size()>0 || postalCodeAndleadATMap.size()>0 || leadAssignTonPFnPCNull != NULL){
                    if(lead.UM_Product__c != NULL && prodFAndleadATMap.containsKey(lead.UM_Product__c)){
                        if(prodFAndleadATMap.get(lead.UM_Product__c).size() == 1){
                            if(prodFAndleadATMap.get(lead.UM_Product__c)[0].Lead_Assignee__c != NULL){
                                lead.OwnerId = prodFAndleadATMap.get(lead.UM_Product__c)[0].Lead_Assignee__c;
                                lead.LeadAssignmentErrorMsg__c = '';
                                lead.Assigned_Date__c = Date.Today();
                            }
                            else if(prodFAndleadATMap.get(lead.UM_Product__c)[0].Assign_to_Queue__c != NULL){
                                lead.OwnerId = prodFAndleadATMap.get(lead.UM_Product__c)[0].Assign_to_Queue__c;
                                lead.LeadAssignmentErrorMsg__c = '';
                            }
                            else{
                                lead.LeadAssignmentErrorMsg__c = 'Assignee is not available in the master table';
                            }
                        }
                        else{
                            for(Lead_Assignment_Table__c LAT : prodFAndleadATMap.get(lead.UM_Product__c)){
                                if(lead.LG_VisitPostalCode__c.substring(0, 3) == LAT.Postal_Code__c){
                                    if(LAT.Lead_Assignee__c != NULL){
                                        lead.OwnerId = LAT.Lead_Assignee__c;
                                        lead.LeadAssignmentErrorMsg__c = '';
                                        lead.Assigned_Date__c = Date.Today();
                                        break;
                                    }
                                    else if(LAT.Assign_to_Queue__c != NULL){
                                        lead.OwnerId = LAT.Assign_to_Queue__c;
                                        lead.LeadAssignmentErrorMsg__c = '';
                                        break;
                                    }
                                    else{
                                        lead.LeadAssignmentErrorMsg__c = 'Assignee is not available in the master table';
                                        break;
                                    }
                                }
                                else{
                                    lead.LeadAssignmentErrorMsg__c = 'Lead Postal Code is not available in the master table';
                                }
                            }
                        }
                    }
                    else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c != NULL && postalCodeAndleadATMap.containsKey(lead.LG_VisitPostalCode__c.substring(0, 3))){
                        if(postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Lead_Assignee__c != NULL){
                            lead.OwnerId = postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Lead_Assignee__c;
                            lead.LeadAssignmentErrorMsg__c = '';
                            lead.Assigned_Date__c = Date.Today();
                        }
                        else if(postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Assign_to_Queue__c != NULL){
                            lead.OwnerId = postalCodeAndleadATMap.get(lead.LG_VisitPostalCode__c.substring(0, 3)).Assign_to_Queue__c;
                            lead.LeadAssignmentErrorMsg__c = '';
                        }
                        else{
                            lead.LeadAssignmentErrorMsg__c = 'Assignee is not available in the master table';
                        }
                    }
                    else if(lead.UM_Product__c == NULL && lead.LG_VisitPostalCode__c == NULL){
                        if(leadAssignTonPFnPCNull.Lead_Assignee__c != NULL){
                            lead.OwnerId = leadAssignTonPFnPCNull.Lead_Assignee__c;
                            lead.LeadAssignmentErrorMsg__c = '';
                            lead.Assigned_Date__c = Date.Today();
                        }
                        else if(leadAssignTonPFnPCNull.Assign_to_Queue__c != NULL){
                            lead.OwnerId = leadAssignTonPFnPCNull.Assign_to_Queue__c;
                            lead.LeadAssignmentErrorMsg__c = '';
                        }
                        else{
                            lead.LeadAssignmentErrorMsg__c = 'Assignee is not available in the master table';
                        }
                    }
                }
                else{
                    lead.LeadAssignmentErrorMsg__c = 'No data found in the master table';
                }
            }
        }
    }
    
    //Deb-- 14 Mar, serviceability check
    public void validateLeadChanges(Map<Id,Lead> oldLeadMap,Map<Id,Lead> newLeadMap) 
    {
        system.debug('lead handler called');
        for(Lead leadObj : newLeadMap.values())
        {
            if(leadObj.LG_VisitPostalCode__c!=oldLeadMap.get(leadObj.Id).LG_VisitPostalCode__c)
            {
                leadObj.Is_Availability_Performed__c= 'No';
                leadObj.Phone_Availability__c='Not Performed';
                leadObj.Mobile_Availability__c='Not Performed';
                leadObj.Internet_Availability__c='Not Performed';
                leadObj.Analog_Availability__c='Not Performed';
                
            }           
	    // added as a part of CATGOV-490
            if(oldLeadMap.get(leadObj.Id).ownerID != leadObj.ownerID && !ownerIDSet.contains(leadObj.ownerID)){
                leadObj.Withdrawn__c = FALSE;
            }
            //end
        } 
    }
     //end
}
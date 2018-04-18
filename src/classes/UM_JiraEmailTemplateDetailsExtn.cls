/**
* This class is for handling data for JIRA related Email templates 
*
* @author Ankur Gupta
* @ticket SFOM-2588
* @since  14/03/2018
*/
public class UM_JiraEmailTemplateDetailsExtn {

    public String suborderId {get;set;}
    public String attrName {get;set;}
    
    public JiraAssigneeData__c getAssigneeDetails(){
        List<csord__solution__c> suborderList = [SELECT Id, UM_JiraAssigneeName__c FROM csord__solution__c WHERE id = :suborderId ];
        if(!suborderList.isEmpty() && String.isNotBlank(suborderList[0].UM_JiraAssigneeName__c))
        {
            for(JiraAssigneeData__c assignee : JiraAssigneeData__c.getall().values())
            {
                if(assignee.Name.equalsIgnoreCase(suborderList[0].UM_JiraAssigneeName__c))
                    return assignee;
            }
        }
        return null;
    }
    
    public String getAddressDetails(){
        List<csord__solution__c> suborderList = [SELECT Id, LG_Address__c,LG_Address__r.cscrm__State_Province__c FROM csord__solution__c WHERE id = :suborderId ];
        if(!suborderList.isEmpty() && suborderList[0].LG_Address__c != null)
        {
            if(suborderList[0].LG_Address__r.cscrm__State_Province__c.equalsIgnoreCase('BW'))
                return Label.UM_AddressforBW;
            else if(suborderList[0].LG_Address__r.cscrm__State_Province__c.equalsIgnoreCase('HE') || suborderList[0].LG_Address__r.cscrm__State_Province__c.equalsIgnoreCase('HSN') )
                return Label.UM_AddressforHSN;
            else if(suborderList[0].LG_Address__r.cscrm__State_Province__c.equalsIgnoreCase('NRW'))
                return Label.UM_AddressforNRW;
        }
        return null;
    }
    
    public String getLogoUrl() 
    {
        Document UMlogo = [SELECT id FROM Document WHERE name ='Jira_UMLogo'];
        return Url.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+ UMlogo.id + '&oid='+UserInfo.getOrganizationId();
    }
    
    //SFOM-2577 - Method to fetch the Service
    public csord__Service__c getServiceDetails()
    {
        csord__Service__c service = [SELECT Name, UM_DownloadSpeed__c FROM csord__Service__c WHERE LG_Suborder__c = :suborderId LIMIT 1];                  
        return service;
    }
}
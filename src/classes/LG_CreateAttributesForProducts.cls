/*******************************************************************************************************************************************
* File Name     :  LG_CreateAttributesForProducts
* Description   :  This is the utility class for the class: LG_CreateDataFromDWHFeedController that creates 'Attributes' records 
                   from the DWH feed.

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     15th-Feb-16    Shreyas             Created the class for release R1*

********************************************************************************************************************************************/

Public class LG_CreateAttributesForProducts{

    public List<cscfga__Attribute_Definition__c> attributeList;
    public map<string,List<cscfga__Attribute_Definition__c>> mapForAttributeDefinition;
    
    public LG_CreateAttributesForProducts(){
        
    }
    
    /*
        Name: createListOfAttributesForProducts
        Purpose: to create lists of attribute names for products 
        Argument: none
        Return type: none
    */
    public void createListOfAttributeNamesForProducts(set<string> productDefinitionNameList){
        
        system.debug('### productDefinitionNameList in create Attribute Method: ' + productDefinitionNameList);
        
        attributeList = new List<cscfga__Attribute_Definition__c>();
        attributeList = [Select Id, Name, cscfga__Product_Definition__c, cscfga__Product_Definition__r.Name,  
                        cscfga__Is_Line_Item__c, cscfga__Recurring__c from cscfga__Attribute_Definition__c 
                        where cscfga__Product_Definition__r.Name IN: productDefinitionNameList];
                        
        mapForAttributeDefinition = new map<string,List<cscfga__Attribute_Definition__c>>();
        
        For(cscfga__Attribute_Definition__c att: attributeList){
            if(mapForAttributeDefinition.containsKey(att.cscfga__Product_Definition__r.Name)){
                mapForAttributeDefinition.get(att.cscfga__Product_Definition__r.Name).add(att);
            }
            else{
                mapForAttributeDefinition.put(att.cscfga__Product_Definition__r.Name,new List<cscfga__Attribute_Definition__c>{att});
            }
            
        }
        system.debug('### mapForAttributeDefinition: ' + mapForAttributeDefinition);
     }

    
    /*
        Name: createAttributeListForProductDefinition
        Purpose: to process the feed records to create Attribute records in SFDC objects for the specified product definition  
        Argument: string, string
        Return type: List<cscfga__Attribute__c>
    */
    public List<cscfga__Attribute__c> createAttributeListForProductDefinition(string productDefinitionName, string prodConfigId){
    
        system.debug('### prodConfigId for method for: ' + ' ' + productDefinitionName + ' -- ' + prodConfigId);
        List<cscfga__Attribute__c> tempAttributeList = new List<cscfga__Attribute__c>();
        List<cscfga__Attribute_Definition__c> listOfConnectMKBAttributeDefinition = new List<cscfga__Attribute_Definition__c>();
        listOfConnectMKBAttributeDefinition = mapForAttributeDefinition.get(productDefinitionName);
        
        for(cscfga__Attribute_Definition__c ad: listOfConnectMKBAttributeDefinition){
            
            cscfga__Attribute__c att1 = new cscfga__Attribute__c();
            att1.Name = ad.Name;
            att1.cscfga__Value__c = '';
            att1.cscfga__Display_Value__c = '';
            att1.cscfga__Attribute_Definition__c = ad.Id;
            att1.cscfga__Is_Line_Item__c = ad.cscfga__Is_Line_Item__c;
            att1.cscfga__Recurring__c = ad.cscfga__Recurring__c;
            att1.cscfga__Line_Item_Description__c = '';
            att1.cscfga__Price__c = 0;
            att1.cscfga__Product_Configuration__c = prodConfigId;
            tempAttributeList.add(att1);            
        }
        
        return tempAttributeList;
    }
    
      
    
}
public class LG_OpportunityLineItemTriggerHandler 
{
    public static void AfterInsertHandle(List<OpportunityLineItem> newOLI)
    {
    	//TransformOLIs(newOLI);
    }
    
    /*
    private static void TransformOLIs(List<OpportunityLineItem> newOLI)
    {
    	
    	set<string> setAttributeId = new set<string>();
    	map<Id,cscfga__Attribute__c> mapAttribute;
    	map<Id,cscfga__Attribute_Field__c> mapAttributeField;
    	list<OpportunityLineItem> lstOLIUpdate = new list<OpportunityLineItem>();
    	map<string,string> mapPCIdMainAttribId = new map<string,string>(); 
    	map<string,string> mapAttributeIdOLIId = new map<string,string>();
    	set<string> setOpportunityLineItemId = new set<string>();
    	
    	
    	
    	for (OpportunityLineItem tmpOLI : newOLI)
        {
        	if (tmpOLI.cscfga__Attribute__c!=null)	
        	{
        		setAttributeId.add(tmpOLI.cscfga__Attribute__c);
        		mapAttributeIdOLIId.put(tmpOLI.cscfga__Attribute__c,tmpOLI.Id);
        		
        		setOpportunityLineItemId.add(tmpOLI.Id);
        	}
        }
        
        if (setAttributeId.size()>0)
        {
        	
        	map<Id,OpportunityLineItem> mapOLIUpdate = new map<Id,OpportunityLineItem>([select Id, LG_OneOffPrice__c, UnitPrice, LG_Type__c, 
        		LG_MainOLI__c
        		from OpportunityLineItem
        		where Id in : setOpportunityLineItemId]); 
        	
        	mapAttribute  = new map<Id,cscfga__Attribute__c>([select Id, cscfga__Recurring__c, Name, cscfga__Value__c, cscfga__Product_Configuration__c,
        		cscfga__Product_Configuration__r.cscfga__Contract_Term__c
        		from cscfga__Attribute__c 
        		where Id in : setAttributeId]);
        		
        	
        	mapAttributeField = new map<Id,cscfga__Attribute_Field__c>([select Id,Name,cscfga__Value__c, cscfga__Attribute__c, 
        		cscfga__Attribute__r.cscfga__Product_Configuration__c
        		from cscfga__Attribute_Field__c
        		where Name='Main' and cscfga__Value__c='Yes' and cscfga__Attribute__c in : setAttributeId]);
        		
        	for (cscfga__Attribute_Field__c tmpAttributeField : mapAttributeField.values())
        	{
        		mapPCIdMainAttribId.put(tmpAttributeField.cscfga__Attribute__r.cscfga__Product_Configuration__c,tmpAttributeField.cscfga__Attribute__c);
        	}
        		
        	set<string> setDiscountId = new set<string>();
        	
        	for (cscfga__Attribute__c tmpAttribute : mapAttribute.values())
        	{
        		if (tmpAttribute.Name=='Discount')
        		{
        			setDiscountId.add(tmpAttribute.cscfga__Value__c);
        		}
        	}
        	
        	map<Id,LG_Discount__c> mapDiscount;
        	
        	if (setDiscountId.size()>0)
        		mapDiscount = new map<Id,LG_Discount__c>([select Id,LG_Amount__c, LG_Months__c, LG_Type__c
        			from LG_Discount__c where Id in : setDiscountId]); 
        		
        	
        	for (OpportunityLineItem tmpOLIOriginal : newOLI)
        	{	
        		if (tmpOLIOriginal.cscfga__Attribute__c!=null)	
        		{
        			cscfga__Attribute__c tmpAttribute = mapAttribute.get(tmpOLIOriginal.cscfga__Attribute__c);
        			
        			OpportunityLineItem tmpOLI = mapOLIUpdate.get(tmpOLIOriginal.Id);
        			
        			
        			if (!tmpAttribute.cscfga__Recurring__c)
        			{
        				tmpOLI.LG_OneOffPrice__c=tmpOLI.UnitPrice;
        				tmpOLI.UnitPrice=0;
        				
        				
        				if (tmpAttribute.Name=='Discount')
        				{
        					tmpOLI.LG_Type__c = mapDiscount.get(tmpAttribute.cscfga__Value__c).LG_Type__c;
        					tmpOLI.LG_DiscountAmount__c = mapDiscount.get(tmpAttribute.cscfga__Value__c).LG_Amount__c;
        					tmpOLI.LG_DiscountCode__c =  mapDiscount.get(tmpAttribute.cscfga__Value__c).LG_DiscountCode__c;
        					tmpOLI.LG_DiscountMonths__c =  mapDiscount.get(tmpAttribute.cscfga__Value__c).LG_Months__c;
        					tmpOLI.LG_DiscountMessage__c =  mapDiscount.get(tmpAttribute.cscfga__Value__c).LG_DiscountMessage__c;
        					
							string tmpPCId = tmpAttribute.cscfga__Product_Configuration__c;
							if (mapPCIdMainAttribId.containsKey(tmpPCId))
							{
								string mainAttributeId = mapPCIdMainAttribId.get(tmpPCId);
								if (mapAttributeIdOLIId.containsKey(mainAttributeId))
								{
									string mainOLIId = mapAttributeIdOLIId.get(mainAttributeId);
									tmpOLI.LG_MainOLI__c=mainOLIId;
								}
							}
							
        				}
        				else
        				{
        					tmpOLI.LG_Type__c='One Off';
        				}
        				
        			}
        			else
        			{
        				tmpOLI.LG_Type__c='Recurring';
        			}
        			
        			
        			if (tmpAttribute.cscfga__Product_Configuration__r.cscfga__Contract_Term__c!=null)
        				tmpOLI.LG_ContractTerm__c=tmpAttribute.cscfga__Product_Configuration__r.cscfga__Contract_Term__c;
        			
        			
        			lstOLIUpdate.add(tmpOLI);
        			
        		}	
        	}
        	
        	if (lstOLIUpdate.size()>0) update lstOLIUpdate;
        	
        }
        
    }
    */
   
}
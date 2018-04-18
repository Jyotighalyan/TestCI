/**
* Used as a controller for the LG_PortingNumbers VF page.
* 
* @author Tomislav Blazek
* @ticket SFDT-100
* @since  21/1/2016
*/
public with sharing class LG_PortingNumbersController
{
	public List<cscfga__Product_Configuration__c> sites {get; set;}
	public cscfga__Product_Basket__c basket {get; set;}
	public Set<LG_PortingNmbrsSiteComponentController> componentControllers {get; set;}
	private Id oppId;
	private String basketId;
	private String portinRecordTypeId;
	
	public LG_PortingNumbersController getPageController()
	{
		return this;
	}

	public LG_PortingNumbersController()
	{
		componentControllers = new Set<LG_PortingNmbrsSiteComponentController>();
		
		basketId = Apexpages.currentPage().getParameters().get('basketId');
		
		portinRecordTypeId = Schema.SObjectType.LG_PortingNumber__c.getRecordTypeInfosByName()
																	.get('Port In').getRecordTypeId();
		
		//fetch the PortIn Product Configurations with the related (already existing 
		//portin numbers)
		sites = [SELECT Id, Name, cscfga__Serial_Number__c, LG_MaximumQuantity__c,
                 cscfga__Product_Basket__r.Id, cscfga__Product_Basket__r.Name,
				 cscfga__Product_Basket__r.cscfga__Opportunity__c,
				 cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c,
                 (SELECT Id, LG_FirstPhoneNumber__c, LG_LastPhoneNumber__c, 
				 	LG_Operator__c, LG_PhoneNumber__c, LG_PortingDate__c, 
					LG_Type__c, LG_ProductConfiguration__c, LG_Opportunity__c,
					LG_PrimaryNumber__c FROM Porting_Numbers__r
					WHERE RecordTypeId = :portinRecordTypeId)
				 FROM cscfga__Product_Configuration__c 
				 WHERE cscfga__Product_Basket__r.Id = :basketId
				 AND LG_PortIn__c = true];
		
		if (sites.size() > 0)
		{
			basket = sites[0].cscfga__Product_Basket__r;
			if (basket.csordtelcoa__Synchronised_with_Opportunity__c)
			{
				oppId = basket.cscfga__Opportunity__c;
			}
			else
			{
				oppId = null;
			}
		}
		else
		{
			basket = null;
			oppId = null;
		}
	}
	
	//Upload button is not visible if there are some imported rows
	public Boolean uploadButtonVisible
	{
		get 
		{
			Boolean result = false;
			
			if (numberOfImportedRows() == 0)
			{
				result = true;
			}
			
			return result;
		}
	}
	
	//Insert button is visible if there are some imported rows, and any of the
	//imported CSV files was fully valid
	public Boolean insertButtonVisible
	{
		get
		{
			Boolean result=false;
			
			if ((numberOfImportedRows() > 0) && (anyFileValid()))
			{
				result = true;	
			}
				
			return result;
		}
	}
	
	//Discard button is visible if there are some imported rows
	public Boolean discardButtonVisible
	{
		get 
		{
			Boolean result=false;
			
			if (numberOfImportedRows() > 0)
			{
				result = true;
			}
			
			return result;
		}
	}
	
	//Fire the upload and validation of files for all the Sites for that a User
	//has selected a file
	public PageReference uploadValidateFile()
	{
		for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
			if ((controller.filename != null) && (controller.fileBody != null))
			{
				controller.uploadValidateFile();	
			}
		}
		return null;
	}
	
	//discards all the uploaded rows - for all sites
	public PageReference discardUploadedRecords()
	{	
		for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
            controller.resetData(false);
		}
		return null;
	}
	
	//saves the uploaded rows and deletes the previous Site's Porting Number records
	//Uploaded rows are saved only for the files that were valid
	public PageReference insertRecords()
	{
		List<LG_PortingNumber__c> portedNumbersToInsert = new List<LG_PortingNumber__c>();
		Set<Id> prodConfigIdsForRowDeletion = new Set<Id>();
		
		for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
			if (controller.fileIsValid)
			{
				for (LG_PortingNmbrsSiteComponentController.cImportFileRow row : controller.lstImportFileRow)
				{
					LG_PortingNumber__c tmpPortingNumbers = new LG_PortingNumber__c();
					tmpPortingNumbers.LG_FirstPhoneNumber__c = row.firstPhoneNumber;
					tmpPortingNumbers.LG_LastPhoneNumber__c = row.lastPhoneNumber;
					tmpPortingNumbers.LG_Operator__c = row.operator;
					tmpPortingNumbers.LG_PhoneNumber__c = row.phoneNumber;
					tmpPortingNumbers.LG_PortingDate__c = Date.parse(row.portingDate);
					tmpPortingNumbers.LG_PrimaryNumber__c = row.primaryNumber;
					tmpPortingNumbers.LG_Type__c = 'SB Telephony';
					
					tmpPortingNumbers.LG_Opportunity__c = oppId;
					
					tmpPortingNumbers.LG_ProductConfiguration__c = controller.prodConfigId;
					
					tmpPortingNumbers.RecordTypeId = portinRecordTypeId;
			
					portedNumbersToInsert.add(tmpPortingNumbers);
					
					prodConfigIdsForRowDeletion.add(controller.prodConfigId);
				}
			}
		}
		
		//fetch the existing Porting numbers for Sites for which the rows are being inserted
		List<LG_PortingNumber__c> portingNumbersToDelete = [SELECT Id FROM LG_PortingNumber__c 
															WHERE LG_ProductConfiguration__c 
															IN :prodConfigIdsForRowDeletion
															AND RecordTypeId = :portinRecordTypeId];
		
		if (portingNumbersToDelete.size() > 0)
		{
			delete portingNumbersToDelete;
		}
			
		if (portedNumbersToInsert.size() > 0)
		{
			insert portedNumbersToInsert;
		}
		
		for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
            controller.resetData(prodConfigIdsForRowDeletion.contains(controller.prodConfigId));
		}
		
		return null;
	}
    
    //back to basket
    public PageReference redirectToBasket() {
        PageReference newocp = new PageReference(LG_Util.getVisualForceBaseUrl() 
													+ '/apex/BasketbuilderApp?Id=' + basketId);
        
        return newocp;
    }
    
	//checks if any of the uploaded files of all the shown Sites are valid
    private Boolean anyFileValid()
    {
        boolean anyFileValid = false;
        
        for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
        	if (controller.fileIsValid)
			{
				anyFileValid = true;
				break;
			}
        }
        
		return anyFileValid;
    }
	
	//returns the number of imported/uploaded rows across all the sites
	private Integer numberOfImportedRows()
	{
		Integer numberOfRows = 0;
		
		for (LG_PortingNmbrsSiteComponentController controller : componentControllers)
		{
			if (controller.lstImportFileRow != null)
			{
				numberOfRows += controller.lstImportFileRow.size();
			}
		}
		
		return numberOfRows;
	}
}
/**
* Used as a controller for the LG_PortingNmbrsSiteComponent component.
* 
* @author Tomislav Blazek
* @ticket SFDT-100
* @since  21/1/2016
*/
public with sharing class LG_PortingNmbrsSiteComponentController
{
	//Inner class used for holding the data of the imported file rows
	public class cImportFileRow
	{
		public String firstPhoneNumber {get;set;}
		public String lastPhoneNumber {get;set;}
		public String operator {get;set;}
		public String phoneNumber {get;set;}
		public String portingDate {get;set;}
		public String primaryNumber {get;set;}
	}
	
	public List<LG_PortingNumber__c> lstPortedNumbers {get;set;}
	public Boolean insertHeaderRow {get;set;}
	public Boolean fileIsValid {get;set;}
	public String fileName {get;set;}
	public Blob fileBody {get;set;}
	public List<String> lstErrorMessage {get;set;}
	public List<cImportFileRow> lstImportFileRow {get;set;}
	private Boolean loadDataExecuted = false;
	private cscfga__Product_Configuration__c ProductConfig;
	
	//used as an attribute of a component
	public String prodConfigId
	{
		get; 
		set 
			{
				prodConfigId = value;
				if (!loadDataExecuted)
				{
					loadData();
				}
			}
	}
	
	//used as an attribute of a component
	public LG_PortingNumbersController pageController
	{
		get; 
		set 
			{
				pageController = value;
				pageController.componentControllers.add(this);
			}
	}
	
	//used as an attribute of a component
	public Integer prodConfMaxQuantity
	{
		get; 
		set 
			{
				prodConfMaxQuantity = value;
			}
	}
	
	//clears the uploaded rows/numbers table and refetches the data if 
	//true parameter provided
	public void resetData(boolean refetchData)
	{
		lstImportFileRow.clear();
		fileBody = null;
		fileName = '';
		lstErrorMessage.clear();
		fileIsValid = false;
		
		String portinRecordTypeId = Schema.SObjectType.LG_PortingNumber__c
										.getRecordTypeInfosByName().get('Port In').getRecordTypeId();
		
		if (refetchData)
		{
			lstPortedNumbers = [SELECT Id, LG_FirstPhoneNumber__c, LG_LastPhoneNumber__c,
								LG_Operator__c, LG_PhoneNumber__c, LG_PortingDate__c,
								LG_Type__c, LG_ProductConfiguration__c, LG_Opportunity__c,
								LG_PrimaryNumber__c FROM LG_PortingNumber__c
								WHERE LG_ProductConfiguration__c = :prodConfigId
								AND RecordTypeId = :portinRecordTypeId];
		}
	}
	
	//called from the Upload File button
	//First it processes the file/parses it, then it validates if the file is valid
	public void uploadValidateFile()
	{
		lstErrorMessage = new List<String>();
		Boolean validationResult;

		if ((filename != null) && (fileBody != null))
		{
			processFile();
			fileIsValid = validate(lstErrorMessage);     	
		}
		
		system.debug('***FileIsValid=' + fileIsValid);
	}


	//loads the data based on the product configuration Id
	private void loadData()
	{
		lstImportFileRow = new List<cImportFileRow>();
		lstErrorMessage = new List<String>();
		lstPortedNumbers = new List<LG_PortingNumber__c>();
		
		insertHeaderRow = false;
		fileIsValid = false;
		
		//fetch the porting numbers data from the main page controllers list
		if (!String.isBlank(prodConfigId))
		{
			for (cscfga__Product_Configuration__c site : pageController.sites)
			{
				if (prodConfigId.equals(site.Id))
				{
					lstPortedNumbers.addAll(site.Porting_Numbers__r);
				}
			}
			
			resetData(false);
		}
		
		loadDataExecuted = true;
	}

	//Validates the imported file and its rows
	private Boolean validate(List<String> lstErrorMessages)
	{
		Boolean result = true;
		Integer rowCounter = 0;
		String tmpErrorMessage;
		
		//Check if the number of imported rows is greater then the maximum quantity.
		//We don't allow importing more then max quantity is set to.
		if (prodConfMaxQuantity != null && lstImportFileRow.size() > prodConfMaxQuantity)
		{
			tmpErrorMessage = 'Maximum quantity of porting numbers exceeded. Maximum quantity is: '
								+ prodConfMaxQuantity;
			lstErrorMessages.add(tmpErrorMessage);
			result = false;
		}
		else
		{
			for (cImportFileRow tmpImportFileRow : lstImportFileRow)
			{
				rowCounter++;
				
				system.debug('***RowCounter=' + rowCounter);
				system.debug('***tmpImportFileRow.FirstPhoneNumber=' + tmpImportFileRow.firstPhoneNumber);
				system.debug('***tmpImportFileRow.LastPhoneNumber=' + tmpImportFileRow.lastPhoneNumber);
				system.debug('***tmpImportFileRow.PhoneNumber=' + tmpImportFileRow.phoneNumber);
				
				if (!tmpImportFileRow.firstPhoneNumber.isNumericSpace())
				{
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter) 
										+ ' - Wrong First Phone Number - current value is '
										+ tmpImportFileRow.firstPhoneNumber
										+ '. Legal values are: only numerics or space';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
				} 

				if (!tmpImportFileRow.lastPhoneNumber.isNumericSpace())
				{
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - Wrong Last Phone Number - current value is '
										+ tmpImportFileRow.lastPhoneNumber
										+ '. Legal values are: only numerics or space';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
				} 

				if (!tmpImportFileRow.phoneNumber.isNumericSpace())
				{
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - Wrong Phone Number - current value is '
										+ tmpImportFileRow.phoneNumber
										+ '. Legal values are: only numerics or space';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
				} 
				
				if ((tmpImportFileRow.phoneNumber == '') 
					&& ((tmpImportFileRow.firstPhoneNumber == '') || (tmpImportFileRow.lastPhoneNumber == '')))
				{
					//if Phone Number is empty then buth First and Last Number must not be empty
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - When Phone Number is empty then both First Phone Number ' 
										+ 'and Last Phone Number must not be empty';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
					
				}
				
				if (((tmpImportFileRow.firstPhoneNumber == '') 
					&& (tmpImportFileRow.lastPhoneNumber == '')) && (tmpImportFileRow.phoneNumber == ''))
				{
					//if First and Last phone number are empty then Phone Number must not be empty
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - When First Phone Number and Last Phone Number are empty ' 
										+ 'then Phone Number must not be empty';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
				}
				
				if (((tmpImportFileRow.firstPhoneNumber != '')
					&& (tmpImportFileRow.lastPhoneNumber != '')) && (tmpImportFileRow.phoneNumber != ''))
				{
					//if First and Last phone number are not empty and then Phone Number is not empty - this is error
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - When First Phone Number and Last Phone Number are not empty '
										+ 'then Phone Number must be empty';
					lstErrorMessages.add(tmpErrorMessage);
					result = false;
				}
				

				if (!checkDate(tmpImportFileRow.portingDate))
				{
					tmpErrorMessage = 'Row: ' + String.valueOf(rowCounter)
										+ ' - Wrong Porting Date - current value is ' + tmpImportFileRow.portingDate;
					lstErrorMessages.add(tmpErrorMessage);			
					result = false;	
				}
			}	
		}
		
		return result;
	}
	
	//Checks if the date is correctly formatted
	private Boolean checkDate(String tmpStrDate)
	{
		Boolean result = true;
		
		system.debug('***tmpStrDate' + tmpStrDate);
		
		if (tmpStrDate == '' || tmpStrDate == null)
		{
			result = false;			
		}
		else
		{
			try
			{
				Date tmpDate = Date.parse(tmpStrDate);
			}
			catch (Exception ex)
			{
				system.debug('***ex' + ex);
				result = false;
			}
		}
		
		return result;
	}

	//Parstes the file and populates the imported file rows list
	private void processFile()
	{
		String strFileBody = fileBody.toString();
		
		Boolean pass;
		
		system.debug('***strFileBody=' + strFileBody);
		
		List<String> lstRows = strFileBody.split('\n');
		
		Integer rowCounter = 0;
		
		lstImportFileRow.clear();
		
		for (String tmpRow : lstRows)
		{
			rowCounter++;
			pass = true;
			
			//if 'Header Row Exists' checkbox is checked - ignore the First
			//row of the file...
			if (rowCounter == 1 && insertHeaderRow)
			{
				pass=false;
			}			
			
			if (pass)
			{
				cImportFileRow tmpImportFileRow = new cImportFileRow();
				
				system.debug('***tmpRow[' + rowCounter + ']=' + tmpRow);
				
				List<String> lstColumns = tmpRow.split(',');
				
				Integer columnCounter = 0;
				
				for (String tmpColumn : lstColumns)
				{
					columnCounter++;
					
					system.debug('***tmpColumn[' + columnCounter + ']=' + tmpColumn);
					
					
					if (columnCounter == 1)
					{
						tmpImportFileRow.portingDate = tmpColumn.trim();
					}
					else if (columnCounter == 2)
					{
						tmpImportFileRow.primaryNumber = tmpColumn.trim();
					}
					else if (columnCounter == 3)
					{
						tmpImportFileRow.operator = tmpColumn.trim();
					}
					else if (columnCounter == 4)
					{
						tmpImportFileRow.phoneNumber = tmpColumn.trim();
					}
					else if (columnCounter == 6)
					{
						tmpImportFileRow.firstPhoneNumber = tmpColumn.trim();
					}
					else if (columnCounter == 8)
					{
						tmpImportFileRow.lastPhoneNumber = tmpColumn.trim();
					}
				}
				
				lstImportFileRow.add(tmpImportFileRow);
			}	
		}
	}
}
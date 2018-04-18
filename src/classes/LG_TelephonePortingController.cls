public with sharing class LG_TelephonePortingController 
{

	private cscfga__Product_Configuration__c ProductConfig;
	public list<LG_PortingNumber__c> lstPortedNumbers {get;set;}
	public Opportunity CurrOpportunity {get;set;}
	public string OppName {get;set;}
	public string PCName {get;set;}
	public string OppId {get;set;}
	public string PCId {get;set;}
	
	public string PBId {get;set;}
	public string PBName {get;set;}
	
	public Boolean InsertHeaderRow {get;set;}
	public Boolean FileIsValid {get;set;}
	
	public list<cImportFileRow> lstImportFileRow {get;set;}
	
   	public string fileName {get;set;}
    public Blob fileBody {get;set;}	

	public LG_TelephonePortingController()
	{
		lstImportFileRow = new list<cImportFileRow>();
		
		InsertHeaderRow=false;
		
		FileIsValid=false;
		
		string ProductConfigId = Apexpages.currentPage().getParameters().get('PCId');
		
		list<cscfga__Product_Configuration__c> lstPC = [select cscfga__Product_Basket__c, cscfga__Product_Basket__r.cscfga__Opportunity__c, 
			cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c, Id, Name, cscfga__Product_Basket__r.Name
			from cscfga__Product_Configuration__c 
			where Id=:ProductConfigId];
		
		if (lstPC.size()>0)
		{
			ProductConfig=lstPC[0];
			
			PCName = ProductConfig.Name;
			PCId = ProductConfig.Id;
			PBName = ProductConfig.cscfga__Product_Basket__r.Name;
			PBId = ProductConfig.cscfga__Product_Basket__c;
			
			
			list<Opportunity> lstOpportunity = [select Id,Name from Opportunity where Id =:ProductConfig.cscfga__Product_Basket__r.cscfga__Opportunity__c];
			if (lstOpportunity.size()>0)
				OppName=lstOpportunity[0].Name;
			else 
			{
				OppName='Not synced';
				OppId='';
			}
			
			SetData(PCId);
			
		}
		else
		{
			lstPortedNumbers = new list<LG_PortingNumber__c>();
			OppName = 'Not synced';
			OppId='';
			PCName = 'Does not exist';
			PCId='';
			PBId='';
			PBName='';
		}
	}
	
	private void SetData(string tmpPCId)
	{	
		lstPortedNumbers = [select Id, LG_FirstPhoneNumber__c, LG_LastPhoneNumber__c, LG_Operator__c, LG_PhoneNumber__c, LG_PortingDate__c, 
			LG_Type__c, LG_ProductConfiguration__c, LG_Opportunity__c, LG_PrimaryNumber__c 
			from LG_PortingNumber__c
			where LG_ProductConfiguration__c=:tmpPCId];
			
	}
	
	public Boolean UploadButtonVisible
	{
		get 
		{
			Boolean result=false;
			if (lstImportFileRow.size()==0)
			{
				result=true;
			}
			
			return result;
		}
	}
	
	public Boolean InsertButtonVisible
	{
		get
		{
			Boolean result=false;
			
			if ((lstImportFileRow.size()>0) && (FileIsValid))
				result=true;
			
			return result;
		}
	}
	
	public Boolean DiscardButtonVisible
	{
		get 
		{
			Boolean result=false;
			if (lstImportFileRow.size()>0)
			{
				result=true;
			}
			
			return result;
		}
	}
	
	
	private Boolean Validate(list<string> lstErrorMessages)
	{
		Boolean result=true;
		integer RowCounter=0;
		string tmpErrorMessage;
		
		Boolean Pass;
		
		for (cImportFileRow tmpImportFileRow : lstImportFileRow)
		{
			RowCounter++;
			
			system.debug('***RowCounter=' + RowCounter);
			system.debug('***tmpImportFileRow.FirstPhoneNumber=' + tmpImportFileRow.FirstPhoneNumber);
			system.debug('***tmpImportFileRow.LastPhoneNumber=' + tmpImportFileRow.LastPhoneNumber);
			system.debug('***tmpImportFileRow.PhoneNumber=' + tmpImportFileRow.PhoneNumber);
			
			if (!tmpImportFileRow.FirstPhoneNumber.isNumericSpace())
			{
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - Wrong First Phone Number - current value is ' + tmpImportFileRow.FirstPhoneNumber + '. Legal values are: only numerics or space';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
			} 

			if (!tmpImportFileRow.LastPhoneNumber.isNumericSpace())
			{
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - Wrong Last Phone Number - current value is ' + tmpImportFileRow.LastPhoneNumber + '. Legal values are: only numerics or space';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
			} 

			if (!tmpImportFileRow.PhoneNumber.isNumericSpace())
			{
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - Wrong Phone Number - current value is ' + tmpImportFileRow.PhoneNumber + '. Legal values are: only numerics or space';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
			} 
			
			if ((tmpImportFileRow.PhoneNumber=='') && ((tmpImportFileRow.FirstPhoneNumber=='') || (tmpImportFileRow.LastPhoneNumber=='')))
			{
				//if Phone Number is empty then buth First and Last Number must not be empty
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - When Phone Number is empty then both First Phone Number and Last Phone Number must not be empty';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
				
			}
			
			if (((tmpImportFileRow.FirstPhoneNumber=='') && (tmpImportFileRow.LastPhoneNumber=='')) && (tmpImportFileRow.PhoneNumber==''))
			{
				//if First and Last phone number are empty then Phone Number must not be empty
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - When First Phone Number and Last Phone Number are empty then Phone Number must not be empty';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
			}
			
			if (((tmpImportFileRow.FirstPhoneNumber!='') && (tmpImportFileRow.LastPhoneNumber!='')) && (tmpImportFileRow.PhoneNumber!=''))
			{
				//if First and Last phone number are not empty and then Phone Number is not empty - this is error
				tmpErrorMessage='Row: ' + string.valueOf(RowCounter) + ' - When First Phone Number and Last Phone Number are not empty then Phone Number must be empty';
				lstErrorMessages.add(tmpErrorMessage);
				result=false;
			}
			

			if (!CheckDate(tmpImportFileRow.PortingDate))
			{
				tmpErrorMessage = 'Row: ' + string.valueOf(RowCounter) + ' - Wrong Porting Date - current value is ' + tmpImportFileRow.PortingDate;
				lstErrorMessages.add(tmpErrorMessage);			
				result=false;	
			}
			
			
			
		}
		
		return result;
	}
	
	
	private Boolean CheckDate(string tmpStrDate)
	{
		Boolean result=true;
		
		system.debug('***tmpStrDate' + tmpStrDate);
		
		if (tmpStrDate=='' || tmpStrDate==null)
		{
			result=false;			
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
				result=false;
			}
		}
		
		return result;
	}
	
	
	public PageReference UploadValidateFile()
	{
		list<string> lstErrorMessage = new list<string>();
		Boolean ValidationResult;
		
		if ((filename!=null) && (fileBody!=null))
		{
			ProcessFile();
			FileIsValid=Validate(lstErrorMessage);
			
			if (!FileIsValid)
        	{
        		for (string tmpErrorMessage : lstErrorMessage)
        		{
	            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, tmpErrorMessage);
	            	ApexPages.addmessage(myMsg);                  			
        		}
        	}      	
		}
		
		
		system.debug('***FileIsValid=' + FileIsValid);
		
		return null;
	}
	
	public PageReference DiscardUploadedRecords()
	{
		lstImportFileRow.clear();
		fileBody = null;
		fileName = '';
		
		return null;
	}
	
	
	private void ProcessFile()
	{
		string strFileBody = fileBody.toString();
		
		Boolean Pass;
		
		system.debug('***strFileBody=' + strFileBody);
		list<string> lstRows = strFileBody.split('\n');
		
		integer RowCounter=0;
		
		lstImportFileRow.clear();
		
		for(string tmpRow : lstRows)
		{
			RowCounter++;
			Pass=false;
			
			
			if (RowCounter==1)
			{
				if (InsertHeaderRow)
					Pass=true;
			}
			else
				Pass=true;
			
			
			if (Pass)
			{
				cImportFileRow tmpImportFileRow = new cImportFileRow();
				
				system.debug('***tmpRow[' + RowCounter + ']=' + tmpRow);
				
				list<string> lstColumns = tmpRow.split(',');
				
				integer ColumnCounter=0;
				
				for(string tmpColumn : lstColumns)
				{
					ColumnCounter++;
					system.debug('***tmpColumn[' + ColumnCounter + ']=' + tmpColumn);
					
					
					if (ColumnCounter==1)
					{
						tmpImportFileRow.PortingDate=tmpColumn.trim();
					}
					else if (ColumnCounter==2)
					{
						tmpImportFileRow.PrimaryNumber=tmpColumn.trim();
					}
					else if (ColumnCounter==3)
					{
						tmpImportFileRow.Operator=tmpColumn.trim();
					}
					else if (ColumnCounter==4)
					{
						tmpImportFileRow.PhoneNumber=tmpColumn.trim();
					}
					else if (ColumnCounter==6)
					{
						tmpImportFileRow.FirstPhoneNumber=tmpColumn.trim();
					}
					else if (ColumnCounter==8)
					{
						tmpImportFileRow.LastPhoneNumber=tmpColumn.trim();
					}
				}
				
				lstImportFileRow.add(tmpImportFileRow);
			}	
		}
		
		
		
	}
	
	public PageReference Cancel()
	{
		return null;
	}
	
	public PageReference InsertRecords()
	{
		
		list<LG_PortingNumber__c> lstPortedNumbersDelete = [select Id from LG_PortingNumber__c where LG_ProductConfiguration__c =:PCId];
		
		list<LG_PortingNumber__c> lstPortedNumbersInsert = new list<LG_PortingNumber__c>(); 
		
		for (cImportFileRow tmpImportFileRow : lstImportFileRow)
		{
			LG_PortingNumber__c tmpPortingNumbers = new LG_PortingNumber__c();
			tmpPortingNumbers.LG_FirstPhoneNumber__c = tmpImportFileRow.FirstPhoneNumber;
			tmpPortingNumbers.LG_LastPhoneNumber__c = tmpImportFileRow.LastPhoneNumber;
			tmpPortingNumbers.LG_Operator__c = tmpImportFileRow.Operator;
			tmpPortingNumbers.LG_PhoneNumber__c = tmpImportFileRow.PhoneNumber;
			tmpPortingNumbers.LG_PortingDate__c = Date.parse(tmpImportFileRow.PortingDate);
			tmpPortingNumbers.LG_PrimaryNumber__c=tmpImportFileRow.PrimaryNumber;
			tmpPortingNumbers.LG_Type__c='SB Telephony';
			
			if (ProductConfig.cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c)
				tmpPortingNumbers.LG_Opportunity__c=OppId;
			else
				tmpPortingNumbers.LG_Opportunity__c=null;
			
			tmpPortingNumbers.LG_ProductConfiguration__c = PCId;
	
			lstPortedNumbersInsert.add(tmpPortingNumbers);
		}
		
		
		if (lstPortedNumbersDelete.size()>0)
			delete lstPortedNumbersDelete;
			
		if (lstPortedNumbersInsert.size()>0)
			insert lstPortedNumbersInsert;
		
		lstImportFileRow.clear();
		fileBody=null;
		fileName='';
		
		SetData(PCId);
		
		return null;
	}


	public class cImportFileRow
	{
		public string FirstPhoneNumber {get;set;}
		public string LastPhoneNumber {get;set;}
		public string Operator {get;set;}
		public string PhoneNumber {get;set;}
		public string PortingDate {get;set;}
		public string PrimaryNumber {get;set;}
	}
}
public class LG_TelephoneUtility 
{
		
	public static list<LG_PortingNumber__c> CreatePortingStructure(string StructureType, string JSONString, string pPCId, string pOppId)
	{
		SohoTelephonyStructure tmpSohoTelephonyStructure;
		list<MobileTelephonyStructure> lstMobileTelephonyStructure;
		
		list<LG_PortingNumber__c> lstPortingNumber = new list<LG_PortingNumber__c>();
		
		LG_PortingNumber__c tmpPortingNumber;
		
		system.debug('***JSONString=' + JSONString);
		
		if (StructureType=='SOHO Telephony')
		{
			system.debug('********** SOHO Telephony=' + StructureType);
			if ((JSONString!='') && (JSONString!=null))
			{
				try
				{
					tmpSohoTelephonyStructure = (SohoTelephonyStructure) JSON.deserialize(JSONString, SohoTelephonyStructure.class);
					system.debug('***tmpSohoTelephonyStructure=' + tmpSohoTelephonyStructure);
				
					if (tmpSohoTelephonyStructure!=null)
					{
						if (tmpSohoTelephonyStructure.Existing_Phone_Numbers_0=='true' || tmpSohoTelephonyStructure.Existing_Phone_Numbers_0=='Yes')
						{
							tmpPortingNumber = new 	LG_PortingNumber__c();
							tmpPortingNumber.LG_PhoneNumber__c=tmpSohoTelephonyStructure.Telephone_Number_0;
							tmpPortingNumber.LG_CustomerName__c=tmpSohoTelephonyStructure.In_The_Name_Of_0;
							tmpPortingNumber.LG_Operator__c=tmpSohoTelephonyStructure.Telephone_Provider_0;
							tmpPortingNumber.LG_InDirectory__c=tmpSohoTelephonyStructure.Listing_In_The_Directory_0;
							tmpPOrtingNumber.LG_Opportunity__c=pOppId;
							tmpPOrtingNumber.LG_ProductConfiguration__c=pPCId;
							tmpPOrtingNumber.LG_Type__c='SOHO Telephony';
							lstPortingNumber.add(tmpPortingNumber);
						}				
						
						if (tmpSohoTelephonyStructure.Extra_Line_Porting_Number_0=='true' || tmpSohoTelephonyStructure.Extra_Line_Porting_Number_0=='Yes')
						{
							tmpPortingNumber = new 	LG_PortingNumber__c();
							tmpPortingNumber.LG_PhoneNumber__c=tmpSohoTelephonyStructure.Extra_Line_Telephone_Number_0;
							tmpPortingNumber.LG_CustomerName__c=tmpSohoTelephonyStructure.Extra_Line_In_The_Name_Of_0;
							tmpPortingNumber.LG_Operator__c=tmpSohoTelephonyStructure.Extra_Line_Telephone_Provider_0;
							tmpPortingNumber.LG_InDirectory__c=tmpSohoTelephonyStructure.Extra_Line_Listing_In_The_Directory_0;
							tmpPOrtingNumber.LG_Opportunity__c=pOppId;
							tmpPOrtingNumber.LG_ProductConfiguration__c=pPCId;
							tmpPOrtingNumber.LG_Type__c='SOHO Telephony';
							lstPortingNumber.add(tmpPortingNumber);
						}

						system.debug('****** lstPortingNumber=' + lstPortingNumber);
					}
				}
				catch (Exception ex)
				{
					LG_Util.SendAdminEmail(ex,'SOHO Porting');
				}
			}
		}
		else if (StructureType=='Mobile Telephony')
		{	
			if ((JSONString!='') && (JSONString!=null))
			{
				try
				{
					lstMobileTelephonyStructure = (List<MobileTelephonyStructure>)JSON.deserialize(JSONString, List<MobileTelephonyStructure>.class);
					if (lstMobileTelephonyStructure!=null)
					{
						for (MobileTelephonyStructure tmpMobileTelephonyStructure : lstMobileTelephonyStructure)
						{
							if (tmpMobileTelephonyStructure.simType=='port number')
							{
								tmpPortingNumber = new 	LG_PortingNumber__c();
								tmpPortingNumber.LG_ContractType__c=tmpMobileTelephonyStructure.contractType;
								tmpPortingNumber.LG_PhoneNumber__c=tmpMobileTelephonyStructure.currentNumber;
								tmpPortingNumber.LG_Operator__c=tmpMobileTelephonyStructure.currentProvider;
								tmpPortingNumber.LG_SIMcardnumber__c=tmpMobileTelephonyStructure.simNumber;
								tmpPortingNumber.LG_Tariff__c=tmpMobileTelephonyStructure.sectionName;
								tmpPortingNumber.LG_PortingDate__c=ConvertStringToDate(tmpMobileTelephonyStructure.dateOfPorting);
								tmpPOrtingNumber.LG_Opportunity__c=pOppId;
								tmpPOrtingNumber.LG_ProductConfiguration__c=pPCId;
								tmpPOrtingNumber.LG_Type__c='Mobile Telephony';
								
								lstPortingNumber.add(tmpPortingNumber);
							}
						}
					}
				}
				catch (Exception ex)
				{
					LG_Util.SendAdminEmail(ex,'Mobile Porting');
				}	
			}
		}
				
		
		system.debug('***tmpSohoTelephonyStructure=' + tmpSohoTelephonyStructure);
		
		system.debug('***lstMobileTelephonyStructure=' + lstMobileTelephonyStructure);
		system.debug('***lstPortingNumber=' + lstPortingNumber);
		
		return lstPortingNumber;
		
	}
	
	
	
	
	
	private static Date ConvertStringToDate(string tmpStrDate)
	{
		Date tmpDate = null;
		
		
		tmpDate = Date.valueOf(tmpStrDate);
		
		return tmpDate;
	}

	private class SohoTelephonyStructure
	{
		public string Existing_Phone_Numbers_0 {get;set;} //should be Phone_Porting_Number_0 - first record
		public string Telephone_Number_0 {get;set;} // -> LG_PortingNumber__c.LG_PhoneNumber__c
		public string In_The_Name_Of_0 {get;set;} // -> LG_PortingNumber__c.LG_CustomerName__c
		public string Telephone_Provider_0 {get;set;} // -> LG_PortingNumber__c.LG_Operator__c
		public string Listing_In_The_Directory_0 {get;set;} // -> LG_PortingNumber__c.LG_InDirectory__c
		public string Extra_Line_Porting_Number_0 {get;set;} // - second record
		public string Extra_Line_Telephone_Number_0 {get;set;} // -> LG_PortingNumber__c.LG_PhoneNumber__c
		public string Extra_Line_In_The_Name_Of_0 {get;set;} // -> LG_PortingNumber__c.LG_CustomerName__c
		public string Extra_Line_Telephone_Provider_0 {get;set;} // -> LG_PortingNumber__c.LG_Operator__c
		public string Extra_Line_Listing_In_The_Directory_0 {get;set;} // -> LG_PortingNumber__c.LG_InDirectory__c
	}
	
	private class MobileTelephonyStructure
	{
		public string simType {get;set;} // -> if new - don't read rest of structure
		public string contractType {get;set;} // -> LG_PortingNumber__c.LG_ContractType__c
		public string currentNumber {get;set;}  // -> LG_PortingNumber__c.LG_PhoneNumber__c
		public string currentProvider {get;set;} // -> LG_PortingNumber__c.LG_Operator__c
		public string simNumber {get;set;}  // -> LG_PortingNumber__c.LG_SIMcardnumber__c
		public string dateOfPorting {get;set;} // -> LG_PortingNumber__c.LG_PortingDate__c
		public string template {get;set;} 
		public string sectionId {get;set;}
		public string sectionName {get;set;} // -> LG_PortingNumber__c.LG_Tariff__c
	}
}
/**
* TODO: ApexDoc.
*/
public class KenanDataConnectionObjects {

	public static List<DataSource.Table> getTables(){
		List<DataSource.Table> tables = new List<DataSource.Table>();
		tables.add(getInvoiceDetailTable());
		tables.add(getAdjustmentTable());
		return tables;
	}

	private static DataSource.Table getInvoiceDetailTable(){
		DataSource.Table table = new DataSource.Table();
		table.name = 'InvoiceItem';
		table.labelPlural = 'Invoice Items';
		table.labelSingular = 'Invoice Item';
		table.nameColumn = 'ExternalId';
		table.columns = new List<DataSource.Column>();
		table.description = 'Invoice Line Items from Kenan FX';

		table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		table.columns.add(createColumn(0,'DisplayUrl', true, 'DisplayUrl', 255, 'DisplayUrl', null, null, true, DataSource.DataType.URL_TYPE));
		//accountExternalId (string, optional),
		table.columns.add(createColumn(0,'accountExternalId', true, 'Account External Id', 255, 'accountExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		//accountExternalIdType (integer, optional),
		table.columns.add(createColumn(0,'accountExternalIdType', true, 'Account External Id Type', 18, 'accountExternalIdType', null, null, true, DataSource.DataType.NUMBER_TYPE));
		//accountInternalId (integer, optional),
		table.columns.add(createColumn(0,'accountInternalId', true, 'Account Internal Id', 18, 'accountInternalId', null, null, true, DataSource.DataType.NUMBER_TYPE));
		//aggrUsageId (integer, optional),
		table.columns.add(createColumn(0,'aggrUsageId', true, 'aggrUsageId', 255, 'aggrUsageId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		//amount (integer, optional),
		table.columns.add(createColumn(2,'amount', true, 'Amount', 16, 'amount', null, null, true, DataSource.DataType.NUMBER_TYPE));
		//amountReduction (integer, optional),
		table.columns.add(createColumn(2,'amountReduction', true, 'Amount Reduction', 16, 'amountReduction', null, null, true, DataSource.DataType.NUMBER_TYPE));
		//amountReductionId (integer, optional),
		table.columns.add(createColumn(0,'amountReductionId', true, 'Amount Reduction Id', 18, 'amountReductionId', null, null, true, DataSource.DataType.NUMBER_TYPE));
		//annotation (string, optional),
		table.columns.add(createColumn(0,'annotation', true, 'Annotation', 512, 'annotation', null, null, true, DataSource.DataType.STRING_LONG_TYPE));		
		//archFlag (boolean, optional),
		table.columns.add(createColumn(0,'archFlag', true, 'Archive Flag', 0, 'archFlag', null, null, true, DataSource.DataType.BOOLEAN_TYPE));		
		//auxTaxInfo (string, optional),
		table.columns.add(createColumn(0,'auxTaxInfo', true, 'Aux Tax Info', 255, 'auxTaxInfo', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//billClass (integer, optional),
		//table.columns.add(createColumn(0,'billClass', true, 'Bill Class', 255, 'billClass', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//billInvoiceRow (integer, optional),
		table.columns.add(createColumn(0,'billInvoiceRow', true, 'Bill Invoice Row', 18, 'billInvoiceRow', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//billRefNo (integer, optional),
		table.columns.add(createColumn(0,'billRefNo', true, 'Bill Ref Number', 18, 'billRefNo', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//billRefResets (integer, optional),
		table.columns.add(createColumn(0,'billRefResets', true, 'Bill Ref Resets', 18, 'billRefResets', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//billSequenceNum (integer, optional),
		table.columns.add(createColumn(0,'billSequenceNum', true, 'Bill Sequence Number', 18, 'billSequenceNum', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//billingCategory (integer, optional),
		table.columns.add(createColumn(0,'billingCategory', true, 'Billing Category', 255, 'billingCategory', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//billingLevel (integer, optional),
		table.columns.add(createColumn(0,'billingLevel', true, 'Billing Level', 255, 'billingLevel', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//brevRcvCostCtr (integer, optional),
		table.columns.add(createColumn(0,'brevRcvCostCtr', true, 'B Rev Rcv Cost Ctr', 18, 'brevRcvCostCtr', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//cityTax (integer, optional),
		table.columns.add(createColumn(0,'cityTax', true, 'City Tax', 18, 'cityTax', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//componentId (integer, optional),
		table.columns.add(createColumn(0,'componentId', true, 'Component Id', 18, 'componentId', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//countyTax (integer, optional),
		table.columns.add(createColumn(0,'countyTax', true, 'County Tax', 18, 'countyTax', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//currencyCode (integer, optional),
		table.columns.add(createColumn(0,'currencyCode', true, 'Currency Code', 10, 'currencyCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//descriptionCode (integer, optional),
		table.columns.add(createColumn(0,'descriptionCode', true, 'Description Code', 255, 'descriptionCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//descriptionGroup (integer, optional),
		table.columns.add(createColumn(0,'descriptionGroup', true, 'Description Group', 255, 'descriptionGroup', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//descriptionText (string, optional),
		table.columns.add(createColumn(0,'descriptionText', true, 'Description Text', 255, 'descriptionText', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//discount (integer, optional),
		table.columns.add(createColumn(0,'discount', true, 'Discount', 18, 'discount', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//discountId (integer, optional),
		table.columns.add(createColumn(0,'discountId', true, 'Discount Id', 255, 'discountId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//elementId (integer, optional),
		table.columns.add(createColumn(0,'elementId', true, 'Element Id', 255, 'elementId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//equipStatus (integer, optional),
		table.columns.add(createColumn(0,'equipStatus', true, 'Equip Status', 255, 'equipStatus', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//federalTax (integer, optional),
		table.columns.add(createColumn(2,'federalTax', true, 'Federal Tax', 16, 'federalTax', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//fromDate (string, optional),
		table.columns.add(createColumn(0,'fromDate', true, 'From Date', 18, 'fromDate', null, null, true, DataSource.DataType.DATETIME_TYPE));		
		//geocode (string, optional),
		table.columns.add(createColumn(0,'geocode', true, 'Geocode', 255, 'geocode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//inclusiveTax (integer, optional),
		table.columns.add(createColumn(0,'inclusiveTax', true, 'Inclusive Tax', 18, 'inclusiveTax', null, null, true, DataSource.DataType.BOOLEAN_TYPE));		
		//languageCode (integer, optional),
		table.columns.add(createColumn(0,'languageCode', true, 'Language Code', 18, 'languageCode', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//lobId (integer, optional),
		table.columns.add(createColumn(0,'lobId', true, 'lobId', 255, 'lobId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//miscNumber1 (integer, optional),
		table.columns.add(createColumn(0,'miscNumber1', true, 'miscNumber1', 255, 'miscNumber1', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//miscNumber2 (integer, optional),
		table.columns.add(createColumn(0,'miscNumber2', true, 'miscNumber2', 255, 'miscNumber2', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//openItemId (integer, optional),
		table.columns.add(createColumn(0,'openItemId', true, 'Open Item Id', 255, 'openItemId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//otherTax (integer, optional),
		table.columns.add(createColumn(2,'otherTax', true, 'Other Tax', 16, 'otherTax', null, null, true, DataSource.DataType.NUMBER_TYPE ));		
		//packageId (integer, optional),
		table.columns.add(createColumn(0,'packageId', true, 'Package Id', 255, 'packageId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//pcmActiveDt (string, optional),
		table.columns.add(createColumn(0,'pcmActiveDt', true, 'pcmActiveDt', 18, 'pcmActiveDt', null, null, true, DataSource.DataType.DATETIME_TYPE ));		
		//prepSequence (integer, optional),
		table.columns.add(createColumn(0,'prepSequence', true, 'prepSequence', 255, 'prepSequence', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//processNum (string, optional),
		table.columns.add(createColumn(0,'processNum', true, 'processNum', 255, 'processNum', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//productLineId (integer, optional),
		table.columns.add(createColumn(0,'productLineId', true, 'productLineId', 255, 'productLineId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//profileId (integer, optional),
		table.columns.add(createColumn(0,'profileId', true, 'profileId', 255, 'profileId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//prorateCode (integer, optional),
		table.columns.add(createColumn(0,'prorateCode', true, 'prorateCode', 18, 'prorateCode', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//providerId (integer, optional),
		table.columns.add(createColumn(0,'providerId', true, 'providerId', 255, 'providerId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//rateCurrencyCode (integer, optional),
		table.columns.add(createColumn(0,'rateCurrencyCode', true, 'Rate Currency Code', 255, 'rateCurrencyCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//ratePeriod (string, optional),
		table.columns.add(createColumn(0,'ratePeriod', true, 'Rate Period', 255, 'ratePeriod', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//rateType (integer, optional),
		table.columns.add(createColumn(0,'rateType', true, 'Rate Type', 255, 'rateType', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//ratedAmount (integer, optional),
		table.columns.add(createColumn(2,'ratedAmount', true, 'Rated Amount', 16, 'ratedAmount', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//revRcvCostCtr (integer, optional),
		table.columns.add(createColumn(0,'revRcvCostCtr', true, 'revRcvCostCtr', 255, 'revRcvCostCtr', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//secondaryAmount (integer, optional),
		table.columns.add(createColumn(2,'secondaryAmount', true, 'Secondary Amount', 16, 'secondaryAmount', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//serverId (integer, optional),
		table.columns.add(createColumn(0,'serverId', true, 'serverId', 255, 'serverId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		////serviceExternalId (string, optional),
		//table.columns.add(createColumn(0,'auxTaxInfo', true, 'auxTaxInfo', 255, 'auxTaxInfo', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		////serviceExternalIdType (integer, optional),
		//table.columns.add(createColumn(0,'auxTaxInfo', true, 'auxTaxInfo', 255, 'auxTaxInfo', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//serviceInternalId (integer, optional),
		table.columns.add(createColumn(0,'serviceExternalId', true, 'serviceExternalId', 18, 'serviceExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		table.columns.add(createColumn(0,'serviceInternalId', true, 'serviceInternalId', 18, 'serviceInternalId', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//serviceInternalIdResets (integer, optional),
		table.columns.add(createColumn(0,'serviceInternalIdResets', true, 'serviceInternalIdResets', 18, 'serviceInternalIdResets', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//shortDescriptionText (string, optional),
		table.columns.add(createColumn(0,'shortDescriptionText', true, 'Short Description Text', 255, 'shortDescriptionText', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//stateTax (integer, optional),
		table.columns.add(createColumn(2,'stateTax', true, 'stateTax', 16, 'State Tax', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//statementDate (string, optional),
		table.columns.add(createColumn(0,'statementDate', true, 'Statement Date', 18, 'statementDate', null, null, true, DataSource.DataType.DATETIME_TYPE));		
		//subtypeCode (integer, optional),
		table.columns.add(createColumn(0,'subtypeCode', true, 'Sub Type Code', 255, 'subtypeCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//tax (integer, optional),
		table.columns.add(createColumn(2,'tax', true, 'tax', 16, 'Tax', null, null, true, DataSource.DataType.NUMBER_TYPE));		
		//taxPkgInstId (integer, optional),
		table.columns.add(createColumn(0,'taxPkgInstId', true, 'taxPkgInstId', 255, 'taxPkgInstId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//taxRate (integer, optional),
		table.columns.add(createColumn(0,'taxRate', true, 'Tax Rate', 255, 'taxRate', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//taxTypeCode (integer, optional),
		table.columns.add(createColumn(0,'taxTypeCode', true, 'Tax Type Code', 255, 'taxTypeCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		////testFlag (boolean, optional),
		//table.columns.add(createColumn(0,'auxTaxInfo', true, 'auxTaxInfo', 255, 'auxTaxInfo', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//toDate (string, optional),
		table.columns.add(createColumn(0,'toDate', true, 'To Date', 18, 'toDate', null, null, true, DataSource.DataType.DATETIME_TYPE));		
		//trackingDate (string, optional),
		table.columns.add(createColumn(0,'trackingDate', true, 'Tracking Date', 18, 'trackingDate', null, null, true, DataSource.DataType.DATETIME_TYPE));		
		//trackingId (integer, optional),
		table.columns.add(createColumn(0,'trackingId', true, 'Tracking Id', 255, 'trackingId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//trackingIdServ (integer, optional),
		table.columns.add(createColumn(0,'trackingIdServ', true, 'trackingIdServ', 255, 'trackingIdServ', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//transDate (string, optional),
		table.columns.add(createColumn(0,'transDate', true, 'Trans Date', 18, 'transDate', null, null, true, DataSource.DataType.DATETIME_TYPE));		
		//typeCode (integer, optional),
		table.columns.add(createColumn(0,'typeCode', true, 'Type Code', 255, 'typeCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//units (integer, optional),
		table.columns.add(createColumn(0,'units', true, 'Units', 255, 'units', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		
		//zoneClass (integer, optional)
		//table.columns.add(createColumn(0,'zoneClass', true, 'Zone Class', 255, 'zoneClass', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));		

		return table;

	}

	private static DataSource.Table getAdjustmentTable(){

		/*
		create Invoice adjustment Invoice BillRef and BillRefResets are in the REST URL
		{
		  "totalAmt": 200,
		  "accountExternalId":"mike78",
		  "accountExternalIdType":2,
		  "effectiveDate":"2016-07-08T12:00:00.000Z",
		  "openItemId":101,
		  "adjReasonCode":0,
		  //"transCode":4401,
		  "origType":0,
		  //"revRcvCostCtr":1,
		  "primaryUnitsType":403
		}
		*/

		DataSource.Table table = new DataSource.Table();
		table.name = 'Adjustment';
		table.labelPlural = 'Adjustments';
		table.labelSingular = 'Adjustment';
		table.nameColumn = 'ExternalId';
		table.columns = new List<DataSource.Column>();
		table.description = 'Invoice and Invoice Item Adjustments from Kenan FX';

		table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		table.columns.add(createColumn(0,'DisplayUrl', true, 'DisplayUrl', 255, 'DisplayUrl', null, null, true, DataSource.DataType.URL_TYPE));

		
		//accountExternalId (string, optional),
		table.columns.add(createColumn(0,'accountExternalId', true, 'accountExternalId', 255, 'accountExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		
		//accountExternalIdType (integer, optional),
		table.columns.add(createColumn(0,'accountExternalIdType', true, 'accountExternalIdType', 255, 'accountExternalIdType', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		
		//accountInternalId (integer, optional),
		table.columns.add(createColumn(0,'accountInternalId', true, 'accountInternalId', 255, 'accountInternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//adjReasonCode (integer, optional),
		table.columns.add(createColumn(0,'adjReasonCode', true, 'adjReasonCode', 255, 'adjReasonCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//annotation (string, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//archFlag (boolean, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//auxTaxInfo (string, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//avsAddressId (integer, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//avsResponseCode (string, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//balanceChgDate (string, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//billOrderNumber (string, optional),
		//table.columns.add(createColumn(0,'ExternalId', true, 'ExternalId', 255, 'ExternalId', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		
		//billRefNo (integer, optional),
		table.columns.add(createColumn(0,'billRefNo', true, 'billRefNo', 18, 'billRefNo', null, null, true, DataSource.DataType.NUMBER_TYPE));

		//billRefResets (integer, optional),
		table.columns.add(createColumn(0,'billRefResets', true, 'billRefResets', 18, 'billRefResets', null, null, true, DataSource.DataType.NUMBER_TYPE));

		//billingCategory (integer, optional),
		
		//brevRcvCostCtr (integer, optional),
		//table.columns.add(createColumn(0,'adjReasonCode', true, 'adjReasonCode', 255, 'adjReasonCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//ccardAccount (string, optional),
		
		//ccardCarrier (string, optional),
		
		//ccardExpire (string, optional),
		
		//chgDate (string, optional),
		
		//chgWho (string, optional),
		
		//cityTax (integer, optional),
		
		//clearingHouseId (string, optional),
		
		//combTaxRate (integer, optional),
		
		//countyTax (integer, optional),
		
		//currencyCode (integer, optional),
		table.columns.add(createColumn(0,'currencyCode', true, 'currencyCode', 255, 'currencyCode', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//currentFlag (boolean, optional),
		
		//discountAmt (integer, optional),
		
		//effectiveDate (string, optional),
		table.columns.add(createColumn(0,'effectiveDate', true, 'Effective Date', 255, 'effectiveDate', null, null, true, DataSource.DataType.DATETIME_TYPE));

		//federalTax (integer, optional),
		
		//fraudIndicator (integer, optional),
		
		//geocode (string, optional),
		
		//inactiveDate (string, optional),
		
		//isNegativeBillAdj (boolean, optional),
		
		//jurisdiction (integer, optional),
		
		//lastReviewedName (string, optional),
		
		//noBill (boolean, optional),
		
		//openItemId (integer, optional),
		
		//origBillInvoiceRow (integer, optional),
		
		//origBillRefNo (integer, optional),
		
		//origBillRefResets (integer, optional),
		
		//origMsgId (integer, optional),
		
		//origMsgId2 (integer, optional),
		
		//origMsgIdServ (integer, optional),
		
		//origProviderId (integer, optional),
		
		//origRcFromDate (string, optional),
		
		//origSplitRowNum (integer, optional),
		
		//origSubmitterName (string, optional),
		
		//origSubtype (integer, optional),
		
		//origTrackingDt (string, optional),
		
		//origTrackingId (integer, optional),
		
		//origTrackingIdServ (integer, optional),
		
		//origTransCode (integer, optional),
		
		//origType (integer, optional),
		table.columns.add(createColumn(0,'(R: 0, 2, 3, 4, 5, 7) When adjusting an InvoiceDetail or usage detail record, the value of the InvoiceDetail.TypeCode: 0 = miscellaneous adjustment 2 = adjustment against recurring charge 3 = adjustment against non-recurring charge	4 = adjustment against an adjustment 5 = adjustment against nondistributed taxes 7 = adjustment against usage charge', true, 'origType', 255, 'origType', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));
		
		//otherTax (integer, optional),
		
		//ownrFname (string, optional),
		
		//ownrLname (string, optional),
		
		//pendingFlag (boolean, optional),
		
		//prepayBalanceDesc (string, optional),
		
		//primaryUnits (integer, optional),

		//primaryUnitsType (integer, optional),
		table.columns.add(createColumn(0,'Required on Create. (R: 403) Unit type for Primary Units: 140 = Days 401 = Percent 402 = Date range 403 = Explicit amount 404 = Units', true, 'primaryUnitsType', 255, 'primaryUnitsType', null, null, true, DataSource.DataType.STRING_SHORT_TYPE));

		//profileId (integer, optional),
		
		//ratedFlag (boolean, optional),
		
		//requestId (integer, optional),
		
		//requestStatus (integer, optional),
		
		//revRcvCostCtr (integer, optional),
		
		//reviewDate (string, optional),
		
		//serverId (integer, optional),
		
		//serviceExternalId (string, optional),
		
		//serviceExternalIdType (integer, optional),
		
		//serviceInternalId (integer, optional),
		
		//serviceInternalIdResets (integer, optional),
		
		//stateTax (integer, optional),
		
		//supervisorName (string, optional),
		
		//taxClass (integer, optional),
		
		//taxJournalStatus (integer, optional),
		
		//taxPkgInstId (integer, optional),
		
		//taxTypeCode (integer, optional),
		
		//totalAmt (integer, optional),
		table.columns.add(createColumn(2,'totalAmt', true, 'Total Amount', 16, 'totalAmt', null, null, true, DataSource.DataType.NUMBER_TYPE));

		//trackingId (integer, optional),
		table.columns.add(createColumn(0,'trackingId', true, 'trackingId', 18, 'trackingId', null, null, true, DataSource.DataType.NUMBER_TYPE));

		//trackingIdCounter (integer, optional),
		
		//trackingIdServ (integer, optional),
		table.columns.add(createColumn(0,'trackingIdServ', true, 'trackingIdServ', 18, 'trackingIdServ', null, null, true, DataSource.DataType.NUMBER_TYPE));

		//transCode (integer, optional),
		
		//transFlag (string, optional),
		
		//transSign (integer, optional),
		
		//transTargetType (integer, optional),
		
		//transactDate (string, optional)

		
		return table;
	}


	private static DataSource.Column createColumn(Integer decimalPlaces, 
											String description,
											Boolean filterable,
											String label,
											Integer length, 
											String name,
											String referenceTargetField,
											String referenceTo,
											Boolean sortable,
											DataSource.DataType type){
		DataSource.Column col = new DataSource.Column();
		col.decimalPlaces = decimalPlaces;
		col.description = description;
		col.filterable = filterable;
		col.label = label;
		col.length = length; 
		col.name = name;
		col.referenceTargetField = referenceTargetField;
		col.referenceTo = referenceTo;
		col.sortable = sortable;
		col.type = type;
		return col;
	}

}
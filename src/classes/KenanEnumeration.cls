/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Enumeration used to disasemble the enumeration data into keys, fields and data
*/
global class KenanEnumeration {

	public String enumName { get; set; }
	
	public List<List<String>> dataList { get; set; }
	
	public List<String> fieldList { get; set; }
	
	public List<String> keyList { get; set; }

	public KenanEnumeration(){
		this.enumName = '';
		this.dataList = new List<List<String>>();
		this.fieldList = new List<String>();
		this.keyList = new List<String>();
	}

	/*
	*	Returns a List of Maps
	*	Each Map represents object field Name and the value for that particular row.
	*/
	public List<Map<String, String>> getValues(){
		//LogUtils.logInfo('KenanEnumeration.getValues enter',null, null);
		List<Map<String, String>> returnValues = new List<Map<String, String>>();
		Map<String, String> fieldMap = getFieldNames();

		for (List<String> rowValue : dataList){
			returnValues.add(getRowValue(rowValue, fieldMap));
		}
		KenanLogUtils.logInfo('KenanEnumeration.getValues exit', 'returnValues', returnValues);
		return returnValues;
	}

	public Map<String, String> getFieldNames(){
		//LogUtils.logInfo('KenanEnumeration.getFieldNames enter', null, null);
		Map<String, String> fieldsMap = new Map<String, String>();
		for (String fieldString : fieldList){
			List<String> fields = fieldString.split(':');
			fieldsMap.put(fields[0], fields[1]);
		}
		KenanLogUtils.log(LoggingLevel.WARN,'KenanEnumeration.getFieldNames for ' + enumName,'fieldsMap', fieldsMap);
		return fieldsMap;
	}

	private Map<String, String> getRowValue(List<String> rowValues, Map<String, String> fieldMap){
		//LogUtils.logInfo('KenanEnumeration.getRowValue enter', 'rowValues', rowValues);
		//system.debug('getRowValue:fieldMap:' + fieldMap);
		Map<String, String> rowMap = new Map<String, String>();
		Integer fieldIndex = 0;
		for(String key : fieldMap.keySet()){
			rowMap.put(key, rowValues[fieldIndex]);
			fieldIndex++;
		}
		KenanLogUtils.logInfo('KenanEnumeration.getRowValue exit', 'rowMap', rowMap);
		return rowMap;
	}

	public Map<String, String> getKeyFieldNames(){
		Map<String, String> fieldsMap = new Map<String, String>();
		for (String fieldString : keyList){
			List<String> fields = fieldString.split(':');
			fieldsMap.put(fields[0], fields[1]);
		}
		KenanLogUtils.logInfo('KenanEnumeration.getKeyFieldNames exit', 'fieldsMap', fieldsMap);
		return fieldsMap;
	}

}
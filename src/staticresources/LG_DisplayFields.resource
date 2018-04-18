{
  "isActive" : true, 
  "fieldMap" : [
    {
      "sfFieldName" : "LG_VisitStreet__c",
      "jsonField" : "streetName",
      "soapField" : "street",
      "resultVisible" : true,
      "displayLabel" : "Stra%C3%9Fe",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "street"
    },
    {
      "sfFieldName" : "LG_VisitHouseNumber__c",
      "jsonField" : "streetNrFirst",
      "soapField" : "streetNo",
      "resultVisible" : true,
      "displayLabel" : "Hausnummer",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "streetNo"
    },
    {
      "sfFieldName" : "LG_VisitHouseNumberExtension__c",
      "jsonField" : "streetNrFirstSuffix",  
      "soapField" : "streetNoSuffix",
      "resultVisible" : true,
      "displayLabel" : "Zusatz",
      "searchFilter" : true,
      "requiredParam" : false,
      "webServiceParam" : "streetNoSuffix"
    },
    {
      "sfFieldName" : "LG_VisitPostalCode__c",
      "jsonField" : "postcode",
      "soapField" : "zip",
      "resultVisible" : true,
      "displayLabel" : "Postleitzahl",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "zip"
    },
	{
      "sfFieldName" : "UM_VisitGeolocation__latitude__s",
      "jsonField" : "geoCoordinateNorth",
      "soapField" : "geoCoordinateNorth",
      "resultVisible" : true,
      "displayLabel" : "Besuchsadresse (Breitengrad)",
      "searchFilter" : false,
      "requiredParam" : true,
      "webServiceParam" : "geoCoordinateNorth"
    },
	{
      "sfFieldName" : "UM_VisitGeolocation__longitude__s",
      "jsonField" : "geoCoordinateEast",
      "soapField" : "geoCoordinateEast",
      "resultVisible" : true,
      "displayLabel" : "Besuchsadresse (L%C3%A4ngengrad)",
      "searchFilter" : false,
      "requiredParam" : true,
      "webServiceParam" : "geoCoordinateEast"
    },
    {
      "sfFieldName" : "LG_VisitCity__c",
      "jsonField" : "city",
      "soapField" : "city",
      "resultVisible" : true,
      "displayLabel" : "Stadt",
      "searchFilter" : true,
      "requiredParam" : false,
      "webServiceParam" : "city"
    },
    {
      "sfFieldName" : "UM_VisitStateProvince__c",
      "jsonField" : "region",
      "soapField" : "region",
      "resultVisible" : true,
      "displayLabel" : "Bundesland",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "LG_VisitAddressID__c",
      "jsonField" : "addressId",   
      "soapField" : "buildingId",
      "resultVisible" : false,
      "displayLabel" : "Address ID",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "UM_Analog__c",
      "jsonField" : "",   
      "soapField" : "mktAnalog",
      "resultVisible" : false,
      "displayLabel" : "Analog",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "UM_Digital__c",
      "jsonField" : "",   
      "soapField" : "mktDigital",
      "resultVisible" : false,
      "displayLabel" : "Digital",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "UM_Internet__c",
      "jsonField" : "",   
      "soapField" : "mktInternet",
      "resultVisible" : false,
      "displayLabel" : "Internet",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "UM_Mobile__c",
      "jsonField" : "",   
      "soapField" : "mktMobile",
      "resultVisible" : false,
      "displayLabel" : "Mobile",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "UM_Phone__c",
      "jsonField" : "",   
      "soapField" : "mktPhone",
      "resultVisible" : false,
      "displayLabel" : "Phone",
      "searchFilter" : false,
      "requiredParam" : false
    }
  ]
}
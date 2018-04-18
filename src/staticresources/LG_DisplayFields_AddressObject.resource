{
  "isActive" : true, 
  "fieldMap" : [
    {
      "sfFieldName" : "cscrm__Street__c",
      "jsonField" : "streetName",
      "soapField" : "street",
      "resultVisible" : true,
      "displayLabel" : "Street",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "street"
    },
    {
      "sfFieldName" : "LG_HouseNumber__c",
      "jsonField" : "streetNrFirst",
      "soapField" : "streetNo",
      "resultVisible" : true,
      "displayLabel" : "House Number",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "streetNo"
    },
    {
      "sfFieldName" : "LG_HouseNumberExtension__c",
      "jsonField" : "streetNrFirstSuffix",  
      "soapField" : "streetNoSuffix",
      "resultVisible" : true,
      "displayLabel" : "Ext.",
      "searchFilter" : true,
      "requiredParam" : false,
      "webServiceParam" : "streetNoSuffix"
    },
    {
      "sfFieldName" : "cscrm__Zip_Postal_Code__c",
      "jsonField" : "postcode",
      "soapField" : "zip",
      "resultVisible" : true,
      "displayLabel" : "Postal Code",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "zip"
    },
	{
      "sfFieldName" : "cscrm__Geolocation__latitude__s",
      "jsonField" : "geoCoordinateNorth",
      "soapField" : "geoCoordinateNorth",
      "resultVisible" : true,
      "displayLabel" : "Visit Geolocation (Latitude)",
      "searchFilter" : false,
      "requiredParam" : true,
      "webServiceParam" : "geoCoordinateNorth"
    },
	{
      "sfFieldName" : "cscrm__Geolocation__longitude__s",
      "jsonField" : "geoCoordinateEast",
      "soapField" : "geoCoordinateEast",
      "resultVisible" : true,
      "displayLabel" : "Visit Geolocation (Longitude)",
      "searchFilter" : false,
      "requiredParam" : true,
      "webServiceParam" : "geoCoordinateEast"
    },
    {
      "sfFieldName" : "cscrm__City__c",
      "jsonField" : "city",
      "soapField" : "city",
      "resultVisible" : true,
      "displayLabel" : "City",
      "searchFilter" : true,
      "requiredParam" : false,
      "webServiceParam" : "city"
    },
    {
      "sfFieldName" : "cscrm__State_Province__c",
      "jsonField" : "region",
      "soapField" : "region",
      "resultVisible" : true,
      "displayLabel" : "Region",
      "searchFilter" : false,
      "requiredParam" : false
    },    
    {
      "sfFieldName" : "LG_AddressID__c",
      "jsonField" : "addressId",   
      "soapField" : "buildingId",
      "resultVisible" : false,
      "displayLabel" : "Address ID",
      "searchFilter" : false,
      "requiredParam" : false
    }        
  ]
}
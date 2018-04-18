{
  "isActive" : true, 
  "fieldMap" : [
    {
      "sfFieldName" : "LG_VisitStreet__c",
      "jsonField" : "streetName",
      "resultVisible" : true,
      "displayLabel" : "Street",
      "searchFilter" : false,
      "requiredParam" : false
    },
    {
      "sfFieldName" : "LG_VisitHouseNumber__c",
      "jsonField" : "streetNrFirst",
      "resultVisible" : true,
      "displayLabel" : "House Number",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "houseFlatNumber"
    },
    {
      "sfFieldName" : "LG_VisitHouseNumberExtension__c",
      "jsonField" : "streetNrFirstSuffix",
      "resultVisible" : true,
      "displayLabel" : "Ext.",
      "searchFilter" : true,
      "requiredParam" : false,
      "webServiceParam" : "houseFlatExt"
    },
        {
      "sfFieldName" : "LG_VisitPostalCode__c",
      "jsonField" : "postcode",
      "resultVisible" : true,
      "displayLabel" : "Postal Code",
      "searchFilter" : true,
      "requiredParam" : true,
      "webServiceParam" : "postcode"
    },
    {
      "sfFieldName" : "LG_VisitCity__c",
      "jsonField" : "city",
      "resultVisible" : true,
      "displayLabel" : "City",
      "searchFilter" : false,
      "requiredParam" : false
    },
    {
      "sfFieldName" : "LG_VisitCountry__c",
      "jsonField" : "CountryName",
      "resultVisible" : true,
      "displayLabel" : "Country",
      "searchFilter" : false,
      "requiredParam" : false
    },
    {
      "sfFieldName" : "LG_VisitAddressID__c",
      "jsonField" : "addressId",
      "resultVisible" : false,
      "displayLabel" : "Address ID",
      "searchFilter" : false,
      "requiredParam" : false
    }
  ]
}
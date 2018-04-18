{
    "workAnywhereAction": "showOfflineAccounts",
    "adminMenu": {
        "Baskets": "manageBaskets",
        "Product Catalogue": "manageProducts"
    },
    "staticResources": [
        "csa_pmwidget",
        "CS_Custom",
        "CS_Labels",
        "csa_select2"
    ],
    "currency": {
        "code": "EUR",
        "htmlSymbol": "&euro;"
    },
    "notificationSettings": {
        "productBasket": {
            "alreadyUploadedNotification": true
        }
    },
    "ibanCheckUrl": "https://www.openiban.com/validate/{IBAN}",
    "pageLayouts": {
        "detailPageLayoutName": "CSADetails",
        "additionalPageLayouts": {
            "cscfga__Product_Basket__c": [
                "CSAPreConfiguration",
                "CSAPostConfiguration",
                "CSAPostConfigurationSOHO",
                "CSAPostConfigurationSmallBusiness"
            ]
        }
    },
    "tables": {
        "Configuration": {
            "isUGC": true,
            "standard": true,
            "offlineFields": ["cscfga__Product_Basket__c", "Json", "ThinConfigJson"],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "cscfga__Product_Basket__c",
                "type": "integer"
            }, {
                "path": "ThinConfigJson",
                "type": "string"
            }, {
                "path": "cscfga__Product_Family__c",
                "type": "string"
            }, {
                "path": "LG_Address__c",
                "type": "string"
            }, {
                "path": "csordtelcoa__Replaced_Service__c",
                "type": "string"
            }, {
                "path": "csordtelcoa__Replaced_Product_Configuration__c",
                "type": "string"
            }]
        },
        "Opportunity": {
            "filter": "OwnerId = {CURRENT USER}",
            "label": "Opportunity",
            "labelPlural": "Opportunities",
            "sequence": 1,
            "sfdc": true,
            "offlineFields": [
                "Updated"
            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }]
        },
        "Account": {
            "filter": "LG_AccountLeadStatus__c != 'Qualified' and LG_AccountLeadStatus__c != 'Disqualified' and OwnerId = {CURRENT USER}",
            "label": "Account",
            "labelPlural": "Accounts",
            "sfdc": true,
            "standard": true,
            "filteredDeleteSync": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }],
            "basketLinkField": "csbb__Account__c"
        },
        "Contact": {
            "filter": "Account.OwnerId = {CURRENT USER}",
            "label": "Contact",
            "labelPlural": "Contacts",
            "sfdc": true,
            "standard": true,
            "offlineFields": [],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "AccountId",
                "type": "string"
            }]
        },
        "cscfga__Product_Basket__c": {
            "filter": "OwnerId = {CURRENT USER}",
            "label": "Product Basket",
            "labelPlural": "Product Baskets",
            "isUGC": true,
            "sfdc": true,
            "standard": true,
            "offlineFields": ["Account__c", "Uploaded", "UploadedDate", "DeletedConfigs"],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "cfgoffline__Account__c",
                "type": "string"
            }, {
                "path": "cscfga__Opportunity__c",
                "type": "string"
            }, {
                "path": "csbb__Account__c",
                "type": "string"
            }, {
                "path": "Lead__c",
                "type": "string"
            }]
        },
        "csord__Service__c": {
            "filter": "csord__Subscription__r.csord__Account__r.OwnerId = {CURRENT USER}",
            "label": "Service",
            "labelPlural": "Services",
            "sfdc": true,
            "standard": true,
            "offlineFields": [
            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "LG_Address__c",
                "type": "string"
            }, {
                "path": "csord__Status__c",
                "type": "string"
            }, {
                "path": "LG_ContractStartDate__c",
                "type": "string"
            }, {
                "path": "LG_ContractEndDate__c",
                "type": "string"
            }, {
                "path": "LG_ProductFamily__c",
                "type": "string"
            }, {
                "path": "LG_ContractTerm__c",
                "type": "floating"
            }, {
                "path": "csordtelcoa__Product_Configuration__c",
                "type": "string"
            }, {
                "path": "UM_ProductDescription__c",
                "type": "string"
            }, {
                "path": "UM_UploadSpeed__c",
                "type": "floating"
            }, {
                "path": "UM_DownloadSpeed__c",
                "type": "floating"
            }, {
                "path": "LG_Quantity__c",
                "type": "floating"
            }]
        },
        "User": {
            "customSync": false,
            "label": "User",
            "labelPlural": "Users",
            "sfdc": true,
            "standard": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }]
        },
        "Lead": {
            "filter": "Status != 'Ready for Order' and Status != 'Qualified' and Status != 'Disqualified' and Status != 'Lost'",
            "deleteFilter": "Status != 'Ready for Order' and Status != 'Qualified' and Status != 'Disqualified' and Status != 'Lost'",
            "filteredDeleteSync": true,
            "useFilteredDeleteSync": true,
            "customSync": true,
            "label": "Lead",
            "labelPlural": "Leads",
            "sfdc": true,
            "offlineFields": [
                "Updated"
            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "Status",
                "type": "string"
            }]
        },
        "cscrm__Address__c": {
            "_comment": "on Profile pages this object is called Sites",
            "filter": "cscrm__Account__r.OwnerId = {CURRENT USER}",
            "customSync": false,
            "label": "Address",
            "labelPlural": "Addresses",
            "sfdc": true,
            "offlineFields": [
            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "LG_FullAddressDetails__c",
                "type": "string"
            }]
        },
        "cspmb__Price_Item__c": {
            "label": "Price Item",
            "labelPlural": "Price Items",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "cspmb__Billing_Frequency__c",
                "type": "string"
            }, {
                "path": "cspmb__Contract_Term__c",
                "type": "string"
            }, {
                "path": "cspmb__Currency_Code__c",
                "type": "string"
            }, {
                "path": "LG_Active_Formula__c",
                "type": "floating"
            }, {
                "path": "cspmb__One_Off_Charge__c",
                "type": "floating"
            }, {
                "path": "cspmb__Price_Item_Code__c",
                "type": "string"
            }, {
                "path": "cspmb__Price_Item_Description__c",
                "type": "string"
            }, {
                "path": "cspmb__Product_Definition_Name__c",
                "type": "string"
            }, {
                "path": "cspmb__Recurring_Charge__c",
                "type": "floating"
            }, {
                "path": "LG_ProductFamily__c",
                "type": "string"
            }, {
                "path": "LG_DownloadSpeed__c",
                "type": "floating"
             }, {
                "path": "LG_MarketSegment__c",
                "type": "string"
            }, {
                "path": "LG_AvailableForSalesChannels__c",
                "type": "string"
            }, {
                "path": "UM_NumberOfChannels__c",
                "type": "string"
            }, {
                "path": "UM_DownloadLimit__c",
                "type": "string"
            }, {
                "path": "UM_ShippingCost__c",
                "type": "floating"
            }, {
                "path": "UM_GuidingProductCode__c",
                "type": "string"
            }, {
                "path": "UM_Gateway__c",
                "type": "string"
            }, {
                "path": "UM_StandardAmountOfNumbers__c",
                "type": "floating"
            }, {
                "path": "UM_MaximalAmountOfNumbers__c",
                "type": "floating"
            }, {
                "path": "UM_OneOffContractID__c",
                "type": "string"
            }, {
                "path": "UM_RecurringContractID__c",
                "type": "string"
            }, {
                "path": "cspmb__Effective_Start_Date__c",
                "type": "string"
            }, {
                "path": "cspmb__Effective_End_Date__c",
                "type": "string"
            }, {
                "path": "LG_Discount__c",
                "type": "string"
            }]
        },
        "cspmb__Add_On_Price_Item__c": {
            "label": "Add On Price Item",
            "labelPlural": "Add On Price Items",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "cspmb__Billing_Frequency__c",
                "type": "string"
            }, {
                "path": "cspmb__Contract_Term__c",
                "type": "string"
            }, {
                "path": "cspmb__Currency_Code__c",
                "type": "string"
            }, {
                "path": "LG_Active_Formula__c",
                "type": "floating"
            }, {
                "path": "cspmb__One_Off_Charge__c",
                "type": "floating"
            }, {
                "path": "cspmb__Add_On_Price_Item_Code__c",
                "type": "string"
            }, {
                "path": "cspmb__Add_On_Price_Item_Description__c",
                "type": "string"
            }, {
                "path": "cspmb__Product_Definition_Name__c",
                "type": "string"
            }, {
                "path": "cspmb__Recurring_Charge__c",
                "type": "floating"
            }, {
                "path": "LG_ProductDefinitionType__c",
                "type": "string"
            }, {
                "path": "LG_ProductFamily__c",
                "type": "string"
            }, {
                "path": "LG_LegacyProductFormula__c",
                "type": "string"
            }, {
                "path": "LG_TypeOfPhoneRange__c",
                "type": "string"
            }, {
                "path": "cspmb__Effective_End_Date__c",
                "type": "string"
            }, {
                "path": "cspmb__Effective_Start_Date__c",
                "type": "string"
            }, {
                "path": "UM_Limits__c",
                "type": "string"
            }, {
                "path": "UM_BillingProductId__c",
                "type": "string"
            }, {
                "path": "UM_OneOffContractID__c",
                "type": "string"
            }, {
                "path": "UM_RecurringContractID__c",
                "type": "string"
            }, {
                "path": "UM_ServiceContractId__c",
                "type": "string"
            }, {
                "path": "UM_State__c",
                "type": "string"
            }, {
                "path": "UM_ParentProductType__c",
                "type": "string"
            }, {
                "path": "LG_Quantity__c",
                "type": "floating"
            }]
        },
        "LG_Discount__c": {
            "label": "Discount",
            "labelPlural": "Discounts",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "LG_Amount__c",
                "type": "floating"
            }, {
                "path": "LG_Business__c",
                "type": "string"
            }, {
                "path": "LG_ContractTerm__c",
                "type": "floating"
            }, {
                "path": "LG_Type__c",
                "type": "string"
            }, {
                "path": "LG_Months__c",
                "type": "floating"
            }, {
                "path": "LG_Active_Formula__c",
                "type": "floating"
            }, {
                "path": "LG_DefaultDiscount_Formula__c",
                "type": "floating"
            }, {
                "path": "LG_DiscountType__c",
                "type": "string"
            }, {
                "path": "LG_DiscountMessage__c",
                "type": "string"
            }, {
                "path": "LG_DiscountCode__c",
                "type": "string"
            }, {
                "path": "UM_ExternalId__c",
                "type": "string"
            }, {
                "path": "UM_ProductDefinitionsUsingDiscount__c",
                "type": "string"
            }]
        },
        "cspmb__Price_Item_Add_On_Price_Item_Association__c": {
            "label": "Price Item Add On Price Item Association",
            "labelPlural": "Price Item Add On Price Item Association",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "cspmb__Add_On_Price_Item__c",
                "type": "string"
            }, {
                "path": "cspmb__Price_Item__c",
                "type": "string"
            }, {
                "path": "Included__c",
                "type": "string"
            }, {
                "path": "cspmb__Group__c",
                "type": "string"
            }, {
                "path": "cspmb__Default_Quantity__c",
                "type": "floating"
            }, {
                "path": "Description__c",
                "type": "string"
            }, {
                "path": "cspmb__Max__c",
                "type": "floating"
            }, {
                "path": "cspmb__Min__c",
                "type": "floating"
            }, {
                "path": "cspmb__One_Off_Charge__c",
                "type": "floating"
            }, {
                "path": "cspmb__Recurring_Charge__c",
                "type": "floating"
            }, {
                "path": "cspmb__Overrides_Add_On_Charges__c",
                "type": "floating"
            }, {
                "path": "cspmb__Sequence__c",
                "type": "floating"
            }]
        },
        "LG_Discount_Setting__c": {
            "label": "Discount Setting",
            "labelPlural": "Discount Settings",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }]
        },
        "LG_ProductTechnicalDetails__c": {
            "label": "Product Technical Details",
            "labelPlural": "Product Technical Details",
            "sfdc": true,
            "offlineFields": [

            ],
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "LG_InstallationClass__c",
                "type": "string"
            }, {
                "path": "LG_InstallationLeadTime__c",
                "type": "floating"
            }, {
                "path": "LG_InstallationNeeded__c",
                "type": "floating"
            }]
        },
        "cscfga__Product_Configuration__c": {
            "filter": "OwnerId = {CURRENT USER}",
            "label": "Product Configuration",
            "labelPlural": "Product Configurations",
            "sfdc": true,
            "indexSpec": [{
                "path": "Id",
                "type": "string"
            }, {
                "path": "Name",
                "type": "string"
            }, {
                "path": "cscfga__Product_Basket__c",
                "type": "string"
            }, {
                "path": "ThinConfigJson",
                "type": "string"
            }, {
                "path": "cscfga__Product_Family__c",
                "type": "string"
            }, {
                "path": "LG_Address__c",
                "type": "string"
            }, {
                "path": "csordtelcoa__Replaced_Service__c",
                "type": "string"
            }, {
                "path": "csordtelcoa__Replaced_Product_Configuration__c",
                "type": "string"
            }]
        },
        "cscfga__Product_Definition__c": {
            "filter": "cscfga__Active__c = true AND cscfga__IsArchived__c = false AND LG_ShowInCloudSenseAnywhere__c = true"
        },
         "cscfga__Product_Category__c": {
            "filter": "cscfga__Active__c = true AND cscfga__Browseable__c = true AND LG_ShowInCloudSenseAnywhere__c = true"
        }
    },
    "lookupQueries": {
        "Lookup(TVLookupQuery)": "SELECT {cspmb__Price_Item__c:_soup} FROM {cspmb__Price_Item__c} WHERE ({cspmb__Price_Item__c:cspmb__Contract_Term__c} IS NULL OR {cspmb__Price_Item__c:cspmb__Contract_Term__c} = '[Contract Term]') AND {cspmb__Price_Item__c:LG_Active_Formula__c} = 1 AND {cspmb__Price_Item__c:LG_MarketSegment__c} = '[Market Segment]' AND {cspmb__Price_Item__c:name} LIKE '%[Product Type]%' AND {cspmb__Price_Item__c:name} LIKE '%[Activation Type]%'",
        "Lookup(ActiveServiceLookupQuery)": "SELECT {csord__Service__c:_soup} FROM {csord__Service__c} WHERE {csord__Service__c:csord__Status__c} != 'Inactive' AND {csord__Service__c:LG_Address__c} = '[Premise Id]' AND {csord__Service__c:LG_ProductFamily__c} IN ('Office Internet' , 'Company Internet')",
        "Lookup(WiFiLookupQuery)": "SELECT {cspmb__Price_Item__c:_soup} FROM {cspmb__Price_Item__c} WHERE {cspmb__Price_Item__c:name} = '[Product Type]' AND {cspmb__Price_Item__c:LG_Active_Formula__c} = 1"
    }

}

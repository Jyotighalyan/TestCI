/**
* Used as a utility class for Product Configurations.
* Using CS API retrieves all the data related to product configuration,
* including the attributes that are stored as JSON attachements.
*
* @author Tomislav Blazek
* @ticket SFOM-85
* @since  4/12/2016
*/
public class LG_ProductConfigurationUtil {

    private List<Id> prodConfIds;
    private Map<Id, List<KeyAttribute>> prodDefKeyAttsMap {
        set;
        get
        {
            if (prodDefKeyAttsMap == null)
            {
                populateProdDefKeyAttsMap();
            }
            return prodDefKeyAttsMap;
        }
    }
    private Map<Id, ProductConfiguration> prodConfsMap {
        set;
        get
        {
            if (prodConfsMap == null)
            {
                loadProductConfigurations();
            }
            return prodConfsMap;
        }
    }

    public LG_ProductConfigurationUtil(List<Id> prodConfIds)
    {
        this.prodConfIds = prodConfIds;
    }

    /**
     * Retrieves the product configurations data and returns
     * a map with Product Configuration Id as a key, and ProductConfiguration
     * object wrapper instance
     *
     * @author Tomislav Blazek
     * @ticket SFOM-85
     * @since  4/12/2016
     */
    public Map<Id, ProductConfiguration> getProductConfigurations()
    {
        return prodConfsMap;
    }

    /**
     * Retrieves the product configurations key attribute display values
     * sorted by key attribute sequence, and concatinated in one string.
     * For display/UI purpouses.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-85
     * @since  4/12/2016
     */
    public String getKeyAttributesPerProdConf(Id prodConfId)
    {
        return prodConfsMap.get(prodConfId).keyAttributes;
    }

    /**
     * Loads the product configuration data using CS API.
     * Populates the ProductConfiguration wrapper objects, and the related
     * Attribute and AttributeFields wrapper objects.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-85
     * @since  4/12/2016
     */
    private void loadProductConfigurations()
    {
        prodConfsMap = new Map<Id, ProductConfiguration>();

        Map<String, Object> mapProdConfs = cscfga.API_1.getProductConfigurations(prodConfIds);

        for (Id prodConfId : prodConfIds)
        {
            List<Attribute> atts = new List<Attribute>();
            List<cscfga__Attribute__c> attList = (List<cscfga__Attribute__c>)mapProdConfs.get(prodConfId + '-attributes');

            for (cscfga__Attribute__c att : attList)
            {
                List<cscfga__Attribute_Field__c> attFields = new List<cscfga__Attribute_Field__c>();
                if (mapProdConfs.containsKey(prodConfId + '-' + att.cscfga__Attribute_Definition__c + '-attributeFields'))
                {
                    attFields = (List<cscfga__Attribute_Field__c>)mapProdConfs.get(prodConfId + '-'
                                                                        + att.cscfga__Attribute_Definition__c
                                                                        + '-attributeFields');
                }
                atts.add(new Attribute(att, attFields));
            }
            prodConfsMap.put(prodConfId, new ProductConfiguration((cscfga__Product_Configuration__c)mapProdConfs.get(prodConfId), atts));

            //Populate the key attributes variable on the product configuration
            populateProdConfKeyAttributes(prodConfId);
        }
    }

    /**
     * Populates the Product Definition map of Key Attributes.
     * Map is used to see if the attribute is a key attribute for a particular
     * product configuration.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-85
     * @since  4/12/2016
     */
    private void populateProdDefKeyAttsMap()
    {
        prodDefKeyAttsMap = new Map<Id, List<KeyAttribute>>();
        if (!prodConfIds.isEmpty())
        {
            Set<Id> prodDefIds = new Set<Id>();
            List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, cscfga__Product_Definition__c
                                                                FROM cscfga__Product_Configuration__c
                                                                WHERE Id IN :prodConfIds];

            for(cscfga__Product_Configuration__c prodConf : prodConfs)
            {
                prodDefIds.add(prodConf.cscfga__Product_Definition__c);
            }

            List<cscfga__Product_Definition__c> prodDefs = [SELECT Id,
                                                            (SELECT Name, LG_KeyAttribute__c, LG_KeyAttributeSequence__c
                                                             FROM cscfga__Attribute_Definitions__r
                                                             WHERE LG_KeyAttribute__c = true)
                                                            FROM cscfga__Product_Definition__c
                                                            WHERE Id IN :prodDefIds];

            for(cscfga__Product_Definition__c prodDef : prodDefs)
            {
                if (!prodDef.cscfga__Attribute_Definitions__r.isEmpty())
                {
                    prodDefKeyAttsMap.put(prodDef.Id, new List<KeyAttribute>());

                    for(cscfga__Attribute_Definition__c attDef : prodDef.cscfga__Attribute_Definitions__r)
                    {
                        prodDefKeyAttsMap.get(prodDef.Id).add(new KeyAttribute(attDef.Name, attDef.LG_KeyAttributeSequence__c));
                    }
                }
            }
        }
    }

    /**
     * Populates the keyAttributes string variable on the product configuration
     * wrapper object.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-85
     * @since  4/12/2016
     */
    private void populateProdConfKeyAttributes(Id prodConfId)
    {
        ProductConfiguration prodConf = prodConfsMap.get(prodConfId);
        prodConf.keyAttributesList = prodDefKeyAttsMap.get(prodConf.prodConfiguration.cscfga__Product_Definition__c);
        if (prodConf.keyAttributesList == null)
        {
            prodConf.keyAttributesList = new List<KeyAttribute>();
        }

        for(KeyAttribute keyAtt : prodConf.keyAttributesList)
        {
            for (Attribute att : prodConf.attributes)
            {
                if (keyAtt.Name == att.attribute.Name)
                {
                    keyAtt.value = att.attribute.cscfga__Value__c;
                    keyAtt.displayValue = att.attribute.cscfga__Display_Value__c;
                    break;
                }
            }
        }

        //sort key attributes by sequence
        prodConf.keyAttributesList.sort();
        prodConf.keyAttributes = '';
        for(KeyAttribute keyAttribute : prodConf.keyAttributesList)
        {
            if (String.isNotBlank(keyAttribute.displayValue))
            {
                prodConf.keyAttributes = prodConf.keyAttributes + keyAttribute.displayValue.unescapeHtml4() + ', ';
            }
        }
        if (prodConf.keyAttributes.length() >=2)
        {
            prodConf.keyAttributes = prodConf.keyAttributes.substring(0, prodConf.keyAttributes.length() - 2);
        }
    }

    //Wrapper classes

    public class KeyAttribute implements Comparable {
        public String name;
        public String value;
        public String displayValue;
        public Decimal sequence;

        public KeyAttribute(String name, Decimal sequence)
        {
            this.name = name;
            this.sequence = sequence;
        }

        public Integer compareTo(Object compareTo)
        {
            KeyAttribute compareToKey = (KeyAttribute)compareTo;
            if (sequence == compareToKey.sequence) return 0;
            if (sequence > compareToKey.sequence) return 1;
            return -1;
        }
    }

    public class ProductConfiguration {
        public cscfga__Product_Configuration__c prodConfiguration;
        public String keyAttributes;
        public List<KeyAttribute> keyAttributesList;
        public List<Attribute> attributes;

        public ProductConfiguration(cscfga__Product_Configuration__c prodConf, List<Attribute> atts)
        {
            this.prodConfiguration = prodConf;
            this.attributes = atts;
        }
    }

    public class Attribute {
        public cscfga__Attribute__c attribute;
        public List<cscfga__Attribute_Field__c> attFields;

        public Attribute(cscfga__Attribute__c attribute, List<cscfga__Attribute_Field__c> attFields)
        {
            this.attribute = attribute;
            this.attFields = attFields;
        }
    }
}
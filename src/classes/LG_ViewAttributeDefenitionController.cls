public class LG_ViewAttributeDefenitionController {
    
	private static List<csord__Service__c> services;
    
    private static List<Id> prodConfigIds;
    private static List<cscfga__Product_Configuration__c> prodConf;
    private static LG_ProductConfigurationUtil util;
    private static Map<Id, LG_ProductConfigurationUtil.ProductConfiguration> productConfigIdMap;

    
    public LG_ViewAttributeDefenitionController(){
        //Empty constructor
    }
    public LG_ViewAttributeDefenitionController(ApexPages.StandardController stdController) {
	
    }
    
    @RemoteAction
    public static List<ServiceConfig> getServiceProductConfigurationDetails(String serviceId){
        
        if(serviceId == null || serviceId=='')
            throw new LG_Exception('Service Id is empty/Null');
        
        List<ServiceConfig> serviceConfigs = new List<ServiceConfig>();
        
        List<LG_ProductConfigurationUtil.KeyAttribute> keyAttributes;
         services = [SELECT Id,Name,csordtelcoa__Product_Configuration__c FROM csord__Service__c WHERE Id=:serviceId];
        prodConfigIds = new List<Id>();
        if(services.size() > 0){
            for(csord__Service__c s : services){
                system.debug(s.csordtelcoa__Product_Configuration__c);
                prodConfigIds.add(s.csordtelcoa__Product_Configuration__c);
            }
            
            util = new LG_ProductConfigurationUtil(prodConfigIds);
            
            system.debug(prodConfigIds);
            productConfigIdMap = util.getProductConfigurations();
            
            for(Id i : productConfigIdMap.keySet()){
                ServiceConfig s = new ServiceConfig();
                s.service = services.get(0);
                s.productConfiguration = productConfigIdMap.get(i).prodConfiguration;
                s.keyAttributes = productConfigIdMap.get(i).keyAttributesList;
                
                if(productConfigIdMap.get(i).attributes!=null && !productConfigIdMap.get(i).attributes.isEmpty()){
                list<LG_ProductConfigurationUtil.Attribute> tempAttributes = productConfigIdMap.get(i).attributes;
                s.attributes = new List<LG_ProductConfigurationUtil.Attribute>();
                for(LG_ProductConfigurationUtil.Attribute attribute : tempAttributes){
                    if(attribute!=null){
                        
                        if(attribute.attribute.cscfga__Value__c!=null && attribute.attribute.cscfga__Display_Value__c!=null && attribute.attribute.cscfga__Value__c!='' && attribute.attribute.cscfga__Display_Value__c!=''){
                        LG_ProductConfigurationUtil.Attribute tempAttribute = new LG_ProductConfigurationUtil.Attribute(attribute.attribute,new List<cscfga__Attribute_Field__c>());
                            for(cscfga__Attribute_Field__c attField : attribute.attFields){
                                if(attField!=null && attField.Name!=null && attField.cscfga__Value__c!=null){
                                    tempAttribute.attFields.add(attField);
                                }
                            }
                        s.keyAttributes = productConfigIdMap.get(i).keyAttributesList;
                        s.attributes.add(tempAttribute);
                        }
                    }
                }
                }
                serviceConfigs.add(s);
            }
        }
        
        
        
        return serviceConfigs;
    }
     
    
    //Custom class for holding values to be displayed in vf page
    public class ServiceConfig{
        public csord__Service__c service;
        public cscfga__Product_Configuration__c productConfiguration;
        public list<LG_ProductConfigurationUtil.KeyAttribute> keyAttributes;
		public list<LG_ProductConfigurationUtil.Attribute> attributes;
    }
}
/**
* 
* Control Panel/Service Console related stuf (configs, items and so on)
* 
* @author Petar Miletic
* @ticket SFOM-1396
* @since  07/08/2017
*/
public class Milestone_ControlPanel {

    private static List<Map<String, sObject>> controlPanelItems { get; set; }
    
    /*
     * Get Configuration by type (user defined JSON data)
    */
    public static String getConfiguration(String type) {
    	String jsonConfig = '';

		List<cssvc1__Service_Console_Component_Config__c> configs = [SELECT cssvc1__json__c, cssvc1__priority__c FROM cssvc1__Service_Console_Component_Config__c WHERE cssvc1__type__c = :type ORDER BY cssvc1__priority__c ASC LIMIT 1000];

		if (configs.size() > 0) {
			jsonConfig = configs.get(0).cssvc1__json__c;
		}

		return jsonConfig;
    }
}
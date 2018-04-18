/**
* 
* Utility helper class for all of those util methods that clutter main controller
* 
* @author Petar Miletic
* @ticket SFOM-1396
* @since  07/08/2017
*/
public class Milestone_UtilityHelper {

    /*
     * Resolve record type and get data based on that type
    */
    public static Account loadAccount(Id recordId) {

        if (recordId != null) {

            if (isAccountId(recordId)) 
            {
                return getAccount(recordId);
            }
            else if (isOrderId(recordId)) 
            {
                return getAccountForOrderId(recordId);
            }
            else if (isSubscriptionId(recordId)) 
            {
                return getAccountForSubscriptionId(recordId);
            }
            else if (isServiceId(recordId)) 
            {
                return getAccountForServiceId(recordId);
            }
            else if (isSolutionId(recordId)) 
            {
                return getAccountForSolutionId(recordId);
            }
        }
        return null;
    }

    /*
     * Check if object is Account
    */
    public static Boolean isAccountId(Id recordId) {
        return recordId != null && recordId.getSobjectType() == Account.sObjectType;
    }

    /*
     * Check if object is Order
    */
    public static Boolean isOrderId(Id recordId) {
        return recordId != null && recordId.getSobjectType() == csord__Order__c.sObjectType;
    }

    /*
     * Check if object is Subscription
    */
    public static Boolean isSubscriptionId(Id recordId) {
        return recordId != null && recordId.getSobjectType() == csord__Subscription__c.sObjectType;
    }

    /*
     * Check if object is Service
    */
    public static Boolean isServiceId(Id recordId) {
        return recordId != null && recordId.getSobjectType() == csord__Service__c.sObjectType;
    }

    /*
     * Check if object is Sub Only Process
    */
    public static Boolean isSubOnlyProcess(CSPOFA__Orchestration_Process__c p) {
        return p != null && p.get('csordtelcoa__Service__c') == null;
    }

    /*
     * Check if object is Order Only Process
    */
    public static Boolean isOrderOnlyProcess(CSPOFA__Orchestration_Process__c p) {
        return p != null && p.get('csordtelcoa__Subscription__c') == null && p.get('csordtelcoa__Service__c') == null;
    }

    /*
     * Check if object is Solution
    */
    public static Boolean isSolutionId(Id recordId) {
        return recordId != null && recordId.getSobjectType() == csord__Solution__c.sObjectType;
    }

    /*
     * Get object name
    */
    public static String getObjectType(Id recordId) {
        return String.valueOf(recordId.getSobjectType()).replace('csord__', '').replace('__c', '');
    }

    /*
     * Load Account data using Account Id
    */
    private static Account getAccount(Id recordId) {
        try {
            return [SELECT name FROM account WHERE Id = :recordId];
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Could not get account for id ' + recordId);
        }
        return null;
    }

    /*
     * Load Account data using Order Id
    */
    private static Account getAccountForOrderId(Id recordId) {
        try {
            return [SELECT csord__Account__r.name FROM csord__Order__c WHERE Id = :recordId].csord__account__r;
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Could not get account for id ' + recordId);
        }
        return null;
    }

    /*
     * Load Account data using Subscription Id
    */
    private static Account getAccountForSubscriptionId(Id recordId) {
        try {
            return [SELECT csord__Account__r.name FROM csord__Subscription__c WHERE Id = :recordId].csord__account__r;
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Could not get account for id ' + recordId);
        }
        return null;
    }

    /*
     * Load Account data using Service Id
    */
    private static Account getAccountForServiceId(Id recordId) {
        try {
            return [SELECT csord__Subscription__r.csord__account__r.name FROM csord__Service__c WHERE id = :recordId].csord__subscription__r.csord__account__r;
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Could not get account for id ' + recordId);
        }
        return null;
    }

    /*
     * Load Account data using Solution Id
    */
    private static Account getAccountForSolutionId(Id recordId) {
        try {
            return [SELECT csord__Account__r.Name FROM csord__Solution__c WHERE id = :recordId].csord__Account__r;
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Could not get account for id ' + recordId);
        }
        return null;
    }

    /*
     * Retrieve tab setup data
     * @configuration - json data (can be constructed on client side or retrieved from DB)
     * @useStoredJson - json data (retrieved from DB, currently the format is different and that is something that needs to change)
    */
    public static Milestone_NavigatorConfig getConfiguration(String configuration, Boolean useStoredJson) {

        Milestone_NavigatorConfig retval = new Milestone_NavigatorConfig();

        if (!String.isBlank(configuration)) {

            try {
                

                retval = (Milestone_NavigatorConfig)JSON.deserialize(configuration, Milestone_NavigatorConfig.class);

                /*String jsondata = '';
                Milestone_NavigatorConfig tabdata = null;

                if (useStoredJson) {
                    Map<String, Object> testMap = (Map<String, Object>)JSON.deserializeUntyped(configuration);

                    // Take tabs based on key
                    jsondata = JSON.serialize(testMap.get('tabs'));
                } else {
                    List<Object> testList = (List<Object>)JSON.deserializeUntyped(configuration);

                    // Take first object from the list
                    jsondata = JSON.serialize(testList[0]);
                }

                // Try and deserialize
                tabdata = (Milestone_NavigatorConfig)JSON.deserialize(jsondata, ControlPanel.TabSetup.class);

                if (tabdata != null) {
                    retval = tabdata;
                }*/

            } catch (Exception ex) {
                System.debug(LoggingLevel.WARN, 'Invalid configuration data!');
            }
        }

        return retval;
    }

    public static Milestone_ProcessViewConfig getProcesViewConfiguration(String configuration, Boolean useStoredJson) {

        Milestone_ProcessViewConfig retval = new Milestone_ProcessViewConfig();

        if (!String.isBlank(configuration)) {

            try {
                

                retval = (Milestone_ProcessViewConfig)JSON.deserialize(configuration, Milestone_ProcessViewConfig.class);

            } catch (Exception ex) {
                System.debug(LoggingLevel.WARN, 'Invalid configuration data!');
            }
        }

        return retval;
    }

    /**
     * Track Order- Milestone View
     *
     * Pauses Orchestrator Process
     *
     * @param  Id recordId (Solution/Suborder)
     * @author Petar Miletic
     * @ticket SFOM-373
     * @since  03/04/2017
    */
    public static String startPauseProcess(Id recordId) {
        
        String retval = 'Success';

        try {

            CSPOFA__Orchestration_Process__c obj = [SELECT Id, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c WHERE Id = :recordId LIMIT 1];
        
            obj.CSPOFA__Process_On_Hold__c = !obj.CSPOFA__Process_On_Hold__c;

            update obj;

        } catch (DmlException dmlex) {
            
            retval = dmlex.getMessage();
            System.debug(LoggingLevel.WARN, retval);

        } catch (Exception ex) {

            retval = ex.getMessage();
            System.debug(LoggingLevel.WARN, retval);
        }

        return JSON.serialize(retval);
    }
}
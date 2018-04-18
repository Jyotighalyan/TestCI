/**
 *
 * ProcessView Configuration structure
 *
 * @author Petar Miletic
 * @ticket SFOM-1396
 * @since  07/08/2017
*/
public class Milestone_ProcessViewConfig {

    public Boolean showCriticalPath { get; set; }
    public Boolean showTaskList { get; set; }
    public Boolean showCaseList { get; set; }
    public OrderSettings orderSettings { get; set; }
    public Inflight inflight { get; set; }
    public SuborderSettings suborderSettings { get; set; }
    public ItemSettings itemSettings { get; set; }

    public Boolean isValidSuborder() {

        return this.suborderSettings != null && 
                this.suborderSettings.enabled && 
                this.suborderSettings.orchestrationprocesslookup != null &&
                this.suborderSettings.suborderactions.buttonsAndActionsLookup != null;
    }

    public String getFullQuery() {

        if (String.isEmpty(this.suborderSettings.orchestrationprocesslookup) || String.isEmpty(this.suborderSettings.suborderactions.buttonsAndActionsLookup)) {
            return ' ';
        }

        String related = this.suborderSettings.orchestrationprocesslookup.replace('__c', '__r');
        return this.suborderSettings.orchestrationprocesslookup + ', ' + related + '.Name' + ', ' + this.suborderSettings.suborderactions.buttonsAndActionsLookup +  ', ';
    }

    public String getInflightButtons(string objectType) {

        if (objectType == 'order') {

            if (String.isEmpty(this.inflight.order.buttonsAndActionsLookup )) {
                return ' ';
            }

            return this.inflight.order.buttonsAndActionsLookup + ',';
        }

        return '';
    }

    public string getSuborderInfo() {

        if (this.suborderSettings != null && this.suborderSettings.OrchestratorRelatedSuborderInfo != null) {

            return this.suborderSettings.OrchestratorRelatedSuborderInfo + '.Id, ' + this.suborderSettings.OrchestratorRelatedSuborderInfo + '.Name,';
        }

        return '';
    }

    public string getSuborderInfoCondition() {

        if (this.suborderSettings != null && this.suborderSettings.OrchestrationProcessLookup != null) {

            return this.suborderSettings.OrchestrationProcessLookup + ' != null ';
        }

        return '';
    }

    public class OrderSettings
    {
        public OrderActions orderActions { get; set; }
    }

    public class ItemSettings
    {
        public string itemActions { get; set; }
    }

    public class ButtonsAndAction
    {
        public String action { get; set; }
        public String url { get; set; }
        public Boolean enabled { get; set; }
        public Boolean externalLink { get; set; }
        public String target { get; set; }
    }

    public class SuborderActions
    {
        public String objectType { get; set; }
        public Boolean enabled { get; set; }
        public Boolean pauseResumeButton { get; set; }
        public String buttonsAndActionsLookup { get; set; }
        public List<ButtonsAndAction> buttonsAndActions { get; set; }
    }

    public class SuborderSettings
    {
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public String OrchestratorRelatedSuborderInfo { get; set; }
        public SuborderActions suborderActions { get; set; }
    }

    public class OrderActions
    {
        public String objectType { get; set; }
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public Boolean pauseResumeButton { get; set; }
        public String buttonsAndActionsLookup { get; set; }
        public List<ButtonsAndAction> buttonsAndActions { get; set; }
    }

    public class Inflight
    {
        public InflightObjectConfig order { get; set; }
        /*public InflightObjectConfig csord__service__c { get; set; }
        public InflightObjectConfig csord__service__c { get; set; }
        public InflightObjectConfig csord__service__c { get; set; }*/
    }

    public class InflightObjectConfig
    {
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public String buttonsAndActionsField { get; set; }
        public String buttonsAndActionsLookup { get; set; }
        public Boolean pauseResumeButton { get; set; }
        public List<ButtonsAndAction> buttonsAndActions { get; set; }
    }
}
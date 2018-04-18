/**
 *
 * Navigator Configuration structure
 *
 * @author Petar Miletic
 * @ticket SFOM-1396
 * @since  08/08/2017
*/
public class Milestone_NavigatorConfig {

    public Tabs tabs { get; set; }
    public Deltavisualiser deltavisualiser { get; set; }

    public Boolean isValid() {

        if (this.tabs == null) {
            throw new Milestone_OrderNavigatorException('Invalid Configuration, tab data missing!');
        }

        return true;
    }

    public Boolean isSolutionTabEnabled() {
        return (this.tabs.solutions != null && this.tabs.solutions.enabled);
    }

    public String getOrderLookupField() {
        return this.tabs.orders == null ? '' : this.tabs.orders.OrchestrationProcessLookupFull;
    }

    public String getSubscriptionsLookupField() {
        return this.tabs.subscriptions == null ? '' : this.tabs.subscriptions.OrchestrationProcessLookupFull;
    }

    public String getSolutionLookupField() {
        return this.tabs.solutions == null ? '' : this.tabs.solutions.OrchestrationProcessLookupFull;
    }

    public class Deltavisualiser
    {
        public Delta delta { get; set; }
    }

    public class Delta
    {
        public Boolean enabled { get; set; }
        public String url { get; set; }
    }

    public class Tabs
    {
        public Orders orders { get; set; }
        public Subscriptions subscriptions { get; set; }
        public Solutions solutions { get; set; }
    }

    public class Orders
    {
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public String OrchestrationProcessLookupFull { get; set; }
    }

    public class Solutions
    {
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public String OrchestrationProcessLookupFull { get; set; }
    }

    public class Subscriptions
    {
        public Boolean enabled { get; set; }
        public String OrchestrationProcessLookup { get; set; }
        public String OrchestrationProcessLookupFull { get; set; }
    }
}
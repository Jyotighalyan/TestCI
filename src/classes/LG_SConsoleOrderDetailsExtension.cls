/**
* Custom SF Service Console
* 
* @author Petar Miletic
* @story SFOM-29
* @since  03/11/2016
*/
public class LG_SConsoleOrderDetailsExtension extends LG_ServiceConsoleBase {

    private final Case cs { get; set; }
    
    private csord__Order__c orderObject { get; set; }

    public csord__Order__c getOrder() {
        
        if (this.orderObject == null) {
            this.orderObject = getOrderRecord();
        }
        
        return this.orderObject; 
    }
    
    private List<csord__Order_Line_Item__c> orderLineItems { get; set; }
    
    public LG_SConsoleOrderDetailsExtension (ApexPages.StandardController stdController) {

        List<String> defaultFields = new List<String>();
        
        defaultFields.add('LG_Order__c');
        defaultFields.add('RecordType.Name');

        stdController.addFields(defaultFields);
        this.cs = (Case)stdController.getRecord();
    }

    private csord__Order__c getOrderRecord() {
        
        if (this.cs.LG_Order__c == null) {
            return new csord__Order__c();
        }
        
        csord__Order__c obj = [SELECT Id, Name, OwnerId FROM csord__Order__c WHERE Id = :this.cs.LG_Order__c]; 

        return obj;
    }
    
    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    /*
     * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }
    
    public PageReference save() {

        update this.orderObject;

        setMode(DisplayMode.detail);
        return null;
    }
    
    public PageReference cancel() {

        setMode(DisplayMode.detail);
        return null;
    }
    
    public PageReference inline() {
        
        setMode(DisplayMode.inlineEdit);
        
        // update this.orderObject;

        // setMode(DisplayMode.detail);
        return null;
    }
}
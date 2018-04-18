@isTest
public class LG_OpportunityOrderDetailControllerTest {

    public static testMethod void runTest() {
        // Create controller
        LG_OpportunityOrderDetailController controller = new LG_OpportunityOrderDetailController();
        controller.relatedTo = null;
        System.assertEquals(null, controller.getProductDetails());
        // Set Opportunity with no related records
        controller.relatedTo = new Opportunity();
        // Test Product Details
        List<LG_ProductDetail__c> productDetails = controller.getProductDetails();
        System.assertNotEquals(null, productDetails);
        System.assertEquals(0, productDetails.size());
        // Test number porting information
        LG_OpportunityOrderDetailController.NumberPortingInformation portingInformation = controller.getNumberPortingInformation();
        System.assertEquals(0, portingInformation.fixedLineNumbersSmall.size());
        System.assertEquals(0, portingInformation.fixedLineNumbersSOHO.size());
        System.assertEquals(0, portingInformation.mobileNumbers.size());
        System.assertEquals(0, portingInformation.getTotalCount());
        // Test parameterless NumberPortingInformation constructor
        portingInformation = new LG_OpportunityOrderDetailController.NumberPortingInformation();
        System.assertEquals(0, portingInformation.fixedLineNumbersSmall.size());
        System.assertEquals(0, portingInformation.fixedLineNumbersSOHO.size());
        System.assertEquals(0, portingInformation.mobileNumbers.size());
        System.assertEquals(0, portingInformation.getTotalCount());
        // Test retrieving comma-separated list of main products
        AggregateResult[] groupedResults = [select count(o.Id) MainProductCount, o.OpportunityId from OpportunityLineItem o where o.LG_MainOLI__c = true group by o.OpportunityId order by count(o.Id) desc];
        if (groupedResults.size() >= 1) {
            controller.relatedTo = new Opportunity(Id = (ID) groupedResults.get(0).get('OpportunityId'));
        }
        System.assertNotEquals(null, controller.getMainProducts());
    }
    
}
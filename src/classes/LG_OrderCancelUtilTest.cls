/**
 * Utillity class for Order Cancel
 *
 * @author Ganesh Subbiah
 * @ticket SFOM-562
 * @since  26/03/2017
*/
@IsTest
public class LG_OrderCancelUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('OMTestAccount', '321654987', 'Test', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        //Order
        csord__Order__c ord = new csord__Order__C(Name = 'Test Order', csord__Account__c =acc.id, csordtelcoa__Opportunity__c= opp.id, csord__Identification__c = '12345');
        ord.csord__Status2__c = 'Cancel Requested';
        insert ord;
        
        csord__Solution__c solutionObject = new csord__Solution__c ();
        solutionObject.Name = 'test';
        solutionObject.csord__Order__c =ord.Id;
        solutionObject.csord__Identification__c = 'Test';
        //solutionObject.csord__Order_Request__c= orderObj.id;
        insert solutionObject;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
         processTemplate.Name = 'Process template';
         insert processTemplate;
         
         CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
         orchProcess.Name = 'Orch Process';
         orchProcess.CSPOFA__Process_On_Hold__c = false;
         orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
         orchProcess.LG_Solution__c = solutionObject.Id;
         insert orchProcess;
         
         
        
        // Order Cancel Request  [0]
        // Follow-On Order [1]
        List<RecordType> objs = [SELECT Id, Name, IsActive FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Order Cancel Request', 'Follow-On Order') ORDER BY Name ASC];

        Case orderCancel = new Case();
        OrderCancel.RecordTypeId = objs[0].Id;
        OrderCancel.Status = 'New';
        OrderCancel.LG_Order__c = ord.Id;
        OrderCancel.LG_Solution__c= solutionObject.id;
        OrderCancel.Subject = 'Order Cancellation raised by order manager';
        
        insert OrderCancel;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest
    public static void orderCancelTest() {
        
        csord__Order__c ord = [SELECT Id, Name FROM csord__Order__c LIMIT 1];
        
        Test.startTest();
        
        Id caseId = LG_OrderCancelUtil.cancelOrder(ord.Id);

        Test.stopTest();
        
        List<Case> cases = [SELECT Id FROM Case WHERE RecordType.Name = 'Order Cancel Request' ];
        
        System.assertEquals(1, cases.size(), 'Invalid data');
    }
    
    @isTest
    public static void followOnOrderTest() {
        
        csord__Order__c ord = [SELECT Id, Name FROM csord__Order__c LIMIT 1];
        
        Test.startTest();
        
        Id caseId = LG_OrderCancelUtil.followOnOrder(ord.Id);

        Test.stopTest();
        
        List<Case> cases = [SELECT Id FROM Case WHERE RecordType.Name = 'Follow-On Order'];
        
        System.assertEquals(1, cases.size(), 'Invalid data');
    }
    
    @IsTest
    public static void errorTest() {

        // Trigger error by sending incorrect id        
        Id accountId = '0016E000002Qmq2';
        csord__Order__c ord = [SELECT Id, Name FROM csord__Order__c LIMIT 1]; 
        csord__Solution__c solution = [SELECT Id, Name FROM csord__Solution__c LIMIT 1];        
        Test.startTest();
        
        String orderCancel = LG_OrderCancelUtil.cancelOrder(accountId);
        String followOnOrder = LG_OrderCancelUtil.followOnOrder(accountId);
        String validateSubOrder = LG_OrderCancelUtil.validateSubOrderStatus(ord.Id);
        String updateOrchProcess =  LG_OrderCancelUtil.updateOrchProcess(solution.Id, 'pause');
        Test.stopTest();
        
        System.debug(orderCancel);
        System.debug(followOnOrder);
        
        System.assertEquals(false, LG_Util.IsValidId(orderCancel), 'Invalid data');
        System.assertEquals(false, LG_Util.IsValidId(followOnOrder), 'Invalid data');
        //SFOM-495, 538
        System.assertEquals(true, validateSubOrder.contains('There is already a cancellation request in progress for this order'));
        System.assertEquals(updateOrchProcess, 'Process Paused.');
    }
}
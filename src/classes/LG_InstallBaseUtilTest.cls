@isTest
private class LG_InstallBaseUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
        osOptions.LG_OrderPartiallyCompletedStatus__c                = 'Some Suborders Completed';
        osOptions.LG_OrderCompleteStatus__c                          = 'Completed';
        osOptions.LG_OrderCanceledStatus__c                          = 'Cancelled';
        osOptions.LG_ServiceDeactivatedStatus__c                     = 'Inactive';
        osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c = 'Closed Replaced';
        insert osOptions;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        insert opp;

        // Insert two Orders
        List<csord__Order__c> orders = new List<csord__Order__c>();
        csord__Order__c replacedOrder  = new csord__Order__c(Name = 'Test Replaced Order', csord__Status2__c = 'Completed', csord__Identification__c = '123456489');
        csord__Order__c canceledOrder  = new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'Cancelled', csord__Identification__c = '123456789', csordtelcoa__Opportunity__c = opp.Id);
        csord__Order__c completedOrder = new csord__Order__c(Name = 'Test Order Second', csord__Status2__c = 'Completed', csord__Identification__c = '123456799');
        orders.add(canceledOrder);
        orders.add(completedOrder);
        orders.add(replacedOrder);
        insert orders;

        csord__Subscription__c cancelSub = new csord__Subscription__c(csord__Identification__c = 'IdentSubCancel');
        insert cancelSub;

        insert new csordtelcoa__Subscription_MACDOpportunity_Association__c(csordtelcoa__Subscription__c = cancelSub.Id, csordtelcoa__Opportunity__c = opp.Id);

        csord__Subscription__c completeSub = new csord__Subscription__c(csord__Identification__c = 'IdentSubComplete');
        insert completeSub;

        csord__Subscription__c cancelReplacedSub = new csord__Subscription__c(csord__Identification__c = 'cancelReplacedSub');
        insert cancelReplacedSub;

        csord__Subscription__c completeReplacedSub = new csord__Subscription__c(csord__Identification__c = 'completeReplacedSub');
        insert completeReplacedSub;


        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c cancelServiceOne = new csord__Service__c(csord__Subscription__c = cancelSub.Id,
                                                                   csord__Identification__c = 'cancelServiceOne',
                                                                   csord__Order__c = canceledOrder.Id, UM_PICReason__c = 'test',LG_ProductFamily__c='SOHO');
        csord__Service__c comServiceOne = new csord__Service__c(csord__Subscription__c = completeSub.Id,
                                                                csord__Identification__c = 'comServiceOne',
                                                                csord__Order__c = completedOrder.Id,LG_ProductFamily__c='SOHO');
        csord__Service__c cancelServiceTwo = new csord__Service__c(csord__Subscription__c = cancelSub.Id,
                                                                   csord__Identification__c = 'cancelServiceTwo',
                                                                   csord__Order__c = canceledOrder.Id, UM_PICReason__c = 'test',LG_ProductFamily__c='SOHO');
        csord__Service__c comServiceTwo = new csord__Service__c(csord__Subscription__c = completeSub.Id,
                                                                csord__Identification__c = 'comServiceTwo',
                                                                csord__Order__c = completedOrder.Id,LG_ProductFamily__c='SOHO');
        csord__Service__c replacementCancelService = new csord__Service__c(csord__Subscription__c = cancelReplacedSub.Id,
                                                                           csord__Identification__c = 'replacementCancelService',
                                                                           csord__Order__c = replacedOrder.Id,LG_ProductFamily__c='SOHO');
        csord__Service__c replacementCompleteService = new csord__Service__c(csord__Subscription__c = completeReplacedSub.Id,
                                                                             csord__Identification__c = 'replacementCompleteService',
                                                                             csord__Order__c = replacedOrder.Id,LG_ProductFamily__c='SOHO');
        services.add(cancelServiceOne);
        services.add(comServiceOne);
        services.add(cancelServiceTwo);
        services.add(comServiceTwo);
        services.add(replacementCancelService);
        services.add(replacementCompleteService);
        insert services;

        cancelServiceTwo.csordtelcoa__Replaced_Service__c              = replacementCancelService.Id;
        replacementCancelService.csordtelcoa__Replacement_Service__c   = cancelServiceTwo.Id;
        comServiceTwo.csordtelcoa__Replaced_Service__c                 = replacementCompleteService.Id;
        replacementCompleteService.csordtelcoa__Replacement_Service__c = comServiceTwo.Id;
        update services;

        Asset completeAsset = new Asset(Name = 'CompleteAsset', AccountId = acc.Id, csord__Service__c = comServiceOne.Id);
        insert completeAsset;

        Asset cancelAsset = new Asset(Name = 'CancelAsset', AccountId = acc.Id, csord__Service__c = cancelServiceTwo.Id);

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    private static testmethod void updateInstallBaseStatuses()
    {
        Set<Id> orderIds = new Set<Id>();
        for (csord__Order__c order : [SELECT Id FROM csord__Order__c]) {
            orderIds.add(order.Id);
        }

        Test.startTest();
        LG_InstallBaseUtil util = new LG_InstallBaseUtil(orderIds);
        util.updateInstallBaseStatuses();
        Test.stopTest();

        List<Asset> assets = [SELECT Id, Status, Name FROM Asset];
        for (Asset asset : assets) {
            if (asset.Name == 'CompleteAsset') {
                System.assertEquals('Active', asset.Status, 'Asset should be Active');
            } else if (asset.Name == 'CancelAsset') {
                System.assertEquals('Inactive', asset.Status, 'Asset should be Inactive');

            }
        }

        List<csord__Service__c> services = [SELECT Id, csord__Identification__c, csord__Subscription__r.csord__Status__c, csord__Status__c
                                            FROM csord__Service__c];

        for (csord__Service__c service : services) {
            if (service.csord__Identification__c == 'cancelServiceOne') {
                System.assertEquals('Cancelled', service.csord__Status__c, 'Service status should be Cancelled');
            } else if (service.csord__Identification__c == 'cancelServiceTwo') {
                System.assertEquals('Cancelled', service.csord__Status__c, 'Service status should be Cancelled');
            } else if (service.csord__Identification__c == 'comServiceOne') {
                System.assertEquals('Active', service.csord__Status__c, 'Service status should be Active');
            } else if (service.csord__Identification__c == 'comServiceTwo') {
                System.assertEquals('Active', service.csord__Status__c, 'Service status should be Active');
            } else if (service.csord__Identification__c == 'replacementCancelService') {
                System.assertEquals('Active', service.csord__Status__c, 'Service status should be Active');
            }
        }
    }
}
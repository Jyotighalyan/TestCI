trigger LG_ServiceTrigger on csord__Service__c (before insert, before update, after insert, after update, before delete)
{
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

    if (notriggers == null || !notriggers.Flag__c)
    {
        List<Id> newTrigger = new List<Id>();
        for(csord__Service__c service : Trigger.New) {

            newTrigger.add( service.Id );
        }

        //system.debug('--+ [Trigger] Trigger.New: ' + newTrigger);
        //system.debug('--+ size: ' + newTrigger.size() );

        //system.debug('--+ [Trigger] Trigger.Old: ' + Trigger.oldMap);

        //system.debug('--+ [Trigger] IsInsert? '+Trigger.isInsert);
        //system.debug('--+ [Trigger] IsUpdate? '+Trigger.isUpdate);
        Boolean newInstance = false;
        if(Trigger.isInsert || (Trigger.isBefore && Trigger.isUpdate))
            newInstance = true;
        LG_ServiceTriggerHandler stHandler = LG_ServiceTriggerHandler.getInstance(Trigger.New, Trigger.oldMap, newInstance);

        if(Trigger.isBefore)
        {
            //if(Trigger.isInsert){
                // Srdan: There is no reason for this code to be run on insert, only update
                // stHandler.updateStatusOnService(Null);
            //}
            if(Trigger.isUpdate){

                //system.debug('--+ [Trigger] isBefore isUpdate ');
				//SFOM-2164 - START
                //stHandler.updateStatusOnService();
                //stHandler.updateServiceStatusAfterSync();
				//SFOM-2164 - END
            }

            if(Trigger.isInsert || Trigger.isUpdate)
            {
                UM_ServiceTriggerHandler.populateCancellationLetterArrivalDate(Trigger.New);
            }
			  //SFOM-2164
            if(trigger.isInsert){
                stHandler.onBeforeInsert(trigger.new);
				//SFOM-2378
                LG_ServiceTriggerHandler.setRootOrder(Trigger.new);
            }
        }

        if (Trigger.isAfter && Trigger.isInsert)
        {
            //system.debug('--+ [Trigger] isAfter isInsert ');

            stHandler.updateSubscriptionNumber();

            //Commented out as its redundant
            //stHandler.cloneSlaLineItem();
            UM_ServiceTriggerHandler.checkReplacementServiceOnCreate(Trigger.New);
            stHandler.setCloneWhenMigration();
        }

    //added as part of SFOM-616, code merging activity for UM and OMDEV


    if (Trigger.isAfter && Trigger.isUpdate) {
            //LG_ServiceTriggerHandler_OM.setVersionData(trigger.newMap, trigger.oldMap);
            LG_ServiceTriggerHandler.setVersionData(trigger.newMap, trigger.oldMap);
        }
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        {
            //system.debug('--+ [Trigger] isAfter ');
            //system.debug('--+ [Trigger] isInsert: '+Trigger.isInsert);
            //system.debug('--+ [Trigger] isUpdate: '+Trigger.isUpdate);
            stHandler.updateSubscriptionAddress();

            //SFOM-1099 changes starts
            stHandler.UM_updateEntitlementToSLA();

            //SFOM-1099 changes ends
            // Commented out as its redundant
            // stHandler.updateSubscriptionStatus(Trigger.newMap);

            // UMR-284
            stHandler.updateSubscriptionBillingAccount();

            stHandler.updateReplacedServiceContract();

            if(Trigger.isAfter && Trigger.isInsert) {
                // UMR-1107
                stHandler.updateContractDuration();
            }

            if(Trigger.isUpdate){
                stHandler.createContractOnServiceActiveStatus();
            }

            stHandler.synchroniseWithKenan();

            // UMR-499
            //Commented out as this was implemented in SFOM-1036
            //UM_SUM_ServiceTriggerHandler.createNumberBlockRecords(Trigger.isUpdate, Trigger.new, Trigger.oldMap);

            if(Trigger.isInsert) {

                //system.debug('--+ [Trigger] isInsert');

                //UMR-987
                //UM_ServiceTriggerHandler.createPortingProcessForPortIn(Trigger.new);
            }

            //UMR-497
            UM_ServiceTriggerHandler.sendEmailToSipwise(Trigger.new, Trigger.oldMap);

            if(Trigger.isUpdate){ 
    		stHandler.updateDependsOn(Trigger.new);
				}// very imp bracket for BHP-347
       //added as part of SFOM-616, code merging activity for UM and OMDEV
       //Commented out due to OMB-739 issue.
     //LG_ServiceTriggerHandler_OM.updateSubscriptionAddress(Trigger.new);

        }

        if (Trigger.isAfter && Trigger.isUpdate)
        {

            //system.debug('--+ [Trigger] IsAfter isUpdate');

            //UMR-683
            //stHandler.updateChildServicesAndSubscriptions();
            //stHandler.createContractOnServiceActiveStatus();

            stHandler.updateContractDuration();

            //UMR-679
            stHandler.serviceMACDTermination();

            //UMR-683
            stHandler.updateChildServicesAndSubscriptions();

            //Update Number Block Billing status after Service has been Activated
            stHandler.activateNumberBlocks();

            //SFOM-820
            stHandler.UM_updateSoltuionToComplete();

            //OMB-1847
            stHandler.UM_updateSubscriptionToActive();
            //UMR-686
            //stHandler.ceaseNumberBlockIDs(Trigger.oldMap);

            //UMR-448
            UM_ServiceTriggerHandler.checkCancelOpportunity(Trigger.new, Trigger.oldMap);

            //UMR-987
            UM_ServiceTriggerHandler.createPortingProcessForPortIn(Trigger.new,trigger.oldMap);
			
			//SFOM-1786 && OMB-1276
            stHandler.updateSubscStatusToInactive();

        }
        if (Trigger.isBefore && Trigger.isDelete)
        {

            for(csord__Service__c servicedel : Trigger.Old) {

                   if(servicedel.LG_ServiceStatus__c == 'Active')
                   {
                       servicedel.adderror('You cannot delete active services');
                   }
                   else
                   {

                   }
        }

        }
        //SFOM-1786
        if (Trigger.isBefore && Trigger.isUpdate)
        {
            //OMB-1970 - Start
           // stHandler.onBeforeUpdate(Trigger.New,Trigger.oldMap);
            //OMB-1970 - End

            for(csord__Service__c service1 : Trigger.New) {
			
			           //SFOM-2164 - START
                    if(service1.csord__status__c!=Trigger.oldMap.get(service1.id).csord__status__c && service1.LG_ServiceStatus__c!=service1.csord__status__c)
                        service1.LG_ServiceStatus__c = service1.csord__status__c;
                        
                    if(service1.LG_ServiceStatus__c!=Trigger.oldMap.get(service1.id).LG_ServiceStatus__c && service1.LG_ServiceStatus__c!=service1.csord__status__c)
                        service1.csord__status__c = service1.LG_ServiceStatus__c;
                    //SFOM-2164 - END

                if(service1.LG_ServiceStatus__c == 'Closed Replaced' && service1.LG_Action__c == 'Delete' && service1.csord__Deactivation_Date__c!=null)                   {
                       service1.LG_ServiceStatus__c = 'Inactive';
                       service1.csord__Status__c = 'Inactive';
                   }
                      //OMB-1970
                if(service1.csord__Status__c=='Closed Replaced' &&
                service1.csord__Deactivation_Date__c==null &&
                Trigger.oldMap.get(service1.id).csord__Status__c!='Closed Replaced' &&
                service1.LG_Replacement_Service_Change_Type__c!=null &&
                service1.LG_Replacement_Service_Change_Type__c=='Move'){
                
                system.debug(' in for 1970  satisying all condition oldServices.get(service.id).csord__Status__c--->'+Trigger.oldMap.get(service1.id).csord__Status__c);
                system.debug(' in for 1970  satisying all condition service.csord__status__c--->'+service1.csord__status__c);
                 service1.LG_ServiceStatus__c =Trigger.oldMap.get(service1.id).LG_ServiceStatus__c ;
               
                service1.csord__status__c=Trigger.oldMap.get(service1.id).csord__Status__c;
                }
				
				
				   //OMB-3542 revert status if partial terminate starts
                
                if(service1.csord__Status__c=='Closed Replaced' &&
                service1.csord__Deactivation_Date__c==null &&
                Trigger.oldMap.get(service1.id).csord__Status__c!='Closed Replaced' &&
                service1.csord__service__r!=null &&
                service1.csord__service__r.LG_Replacement_Service_Change_Type__c!=null &&
                service1.csord__service__r.LG_Replacement_Service_Change_Type__c=='Change'&&
                service1.LG_Action__c!='None'){
                
                system.debug(' in for 3542  satisying all condition oldServices.get(service.id).csord__Status__c--->'+Trigger.oldMap.get(service1.id).csord__Status__c);
				
                system.debug(' in for 3542  satisying all condition service.csord__status__c--->'+service1.csord__status__c);
                 service1.LG_ServiceStatus__c =Trigger.oldMap.get(service1.id).LG_ServiceStatus__c ;
               
                service1.csord__status__c=Trigger.oldMap.get(service1.id).csord__Status__c;
                }
                
                //OMB-3542 revert status if partial terminate ends
                   system.debug('in trigger-service1---'+service1);
                   
            }
                   
        	}

        }
    }

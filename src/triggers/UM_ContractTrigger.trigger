trigger UM_ContractTrigger on csconta__Contract__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        UM_ContractTriggerHandler.updateServiceOnContractUpdate(Trigger.newMap,Trigger.oldMap);
        }
}
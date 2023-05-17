trigger handlePolicyTrigger on Policy__c (before update,after insert) {
    System.debug('Context : Trigger.isAfter : '+Trigger.isAfter+' Trigger.isBefore: '+Trigger.isBefore+' Trigger.isUpdate:'+Trigger.isUpdate+' Trigger.isInsert:'+Trigger.isInsert);
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            PolicyTriggerHandler.checkEachTask(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        if (Trigger.isInsert) {
            //PolicyTriggerHandler.inActivatePreviousPolicies(Trigger.new);
        }
    }
}
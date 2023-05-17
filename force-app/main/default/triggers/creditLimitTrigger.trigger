trigger creditLimitTrigger on Credit_Limit__c (before insert) {
    System.debug('creditLimitTrigger Trigger called.');

    if(Trigger.isInsert){
        System.debug('Trigger Context Update.');
        clAndclaTriggerHandler.checkCL_Condition(trigger.new);
    }
}
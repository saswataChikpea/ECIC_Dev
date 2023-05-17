public with sharing class ApiAMLCheck {
    @InvocableMethod(label='AML Checking' description='')
    public static void getAMLChecking(List<ID> ids){
        Policy__c pol=[select Is_AML_Check_Pass__c from Policy__c where id = :ids];
        if(!pol.Is_AML_Check_Pass__c){
            pol.Is_AML_Check_Pass__c=true;
        }
        update pol;
        System.debug('Policy AML Checking Updated Succesfully.');
    }
}
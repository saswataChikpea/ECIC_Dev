public with sharing class BatchDeactivateLimitedAccessAccount implements Database.Batchable<sObject>, Database.Stateful{
    public Integer number_of_acc_deativated;
    public Decimal Period_of_Limited_Access;
    public List<Account> account_list;
    public BatchDeactivateLimitedAccessAccount() {
        number_of_acc_deativated = 0;
        List<ECIC_Settings__c> settings = [Select Id,Period_of_Limited_Access__c from ECIC_Settings__c LIMIT 1];
        Period_of_Limited_Access = settings[0].Period_of_Limited_Access__c;
        account_list = new List<Account>();
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        Date today = Date.today();
        String query = 'select Id,Name,Limited_Access__c,Limited_Access_Date__c from Account where Limited_Access__c=true and Is_Active__c=true and Limited_Access_Date__c!=null and Limited_Access_Date__c<:today';
        System.debug('query='+query);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Account> records){
        try{
        Date today = Date.today();
        System.debug('Account List='+records);
        System.debug('Period_of_Limited_Access='+Period_of_Limited_Access);
        List<Account> filtered_acc = new List<Account>();
        for(Account acc:records){
            Integer days_between = 0;
            days_between = (acc.Limited_Access_Date__c).daysBetween(today);
            System.debug('days_between='+days_between);
            if(days_between >= Period_of_Limited_Access)
                filtered_acc.add(acc);
        }
        account_list.addAll(filtered_acc);
        List<User> user_list = [select Name,Id,IsActive from User where AccountId in :filtered_acc];
        System.debug('user_list='+user_list);
        for(User each_user:user_list){
            each_user.IsActive = false;
            // each_user.Inactivated_From_Batch__c = true;
        }
        update user_list;
        List<Id> acc_ids = new List<Id>();
        for(Account ecah_acc:filtered_acc){
            ecah_acc.Limited_Access_Date__c = null;
            acc_ids.add(ecah_acc.Id);
        }
        }catch(Exception e) {
            ExceptionLogger.log(e, 'BatchDeactivateLimitedAccessAccount');
        }
        // update filtered_acc;
        /*for(Account ecah_acc:filtered_acc){
            try{
                SendEmailApex.sendEmailFuture(ecah_acc.Id, ecah_acc.Id, 'Immediate_Deactivate_User', false, '', '');
            } catch(Exception e) {
                System.debug('Exception in email sending='+e.getMessage());
            }
        }*/
        

    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        try{
        for(Account acc:account_list) {
            acc.Limited_Access_Date__c = null;
            SendEmailApex.sendEmailAccount(acc.Id, acc.Id, 'Immediate_Deactivate_User', false, null, null);
        }
        update account_list;
        System.debug('number_of_acc_deativated='+number_of_acc_deativated);
        }catch(Exception e) {
            ExceptionLogger.log(e, 'BatchDeactivateLimitedAccessAccount');
        }
    }
    

}
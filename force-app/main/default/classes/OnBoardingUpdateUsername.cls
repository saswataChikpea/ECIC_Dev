global with sharing class OnBoardingUpdateUsername implements Database.Batchable<sObject>, Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc){
        //return Database.getQueryLocator('select Id, Name, Username, ProfileId, Profile.Name from User where Profile.Name = \'EC-Reach Login Profile\'');
        return Database.getQueryLocator('Select Id, Name, Commencement_Date__c, Legacy_Policy_Type__c, Legacy_Customer_Number__c, Exporter__c from Policy__c where Commencement_Date__c = LAST_N_DAYS:1 and Is_User_Updated__c = false and Legacy_Customer_Number__c != null and Legacy_Policy_Type__c != null');
    }
    public void execute(Database.BatchableContext bc, List<Policy__c> policies){
        System.debug('#****'+policies);
        //select Id, Name, Username, Contact.Id, Profile.Name from user where AccountId = '0010l00001IGyYnAAL'
        try{
            updateUsername(policies);
        }catch(Exception e){
            ExceptionLogger.log(e, 'OnBoardingUpdateUsername');
        }
    }
    public void updateUsername(List<Policy__c> policies) {
        Map<Id, Policy__c> policyMap = new Map<Id, Policy__c>();
        //Set<Id> accountIds = new Set<Id>();
        for(Policy__c policy: policies){
            policyMap.put(policy.Exporter__c, policy);
            policy.Is_User_Updated__c = true;
            //accountIds.add(policy.Exporter__c);
        }
        System.debug('#****accountIds'+policyMap.keyset());
        List<User> users = [select Id, Name, AccountId, Username, Contact.Id from User where AccountId IN :policyMap.keyset()];
        List<Contact> contacts = new List<Contact>();//to update the contact for nitification
        for(User usr: users){
            System.debug('#****'+usr);
            if(policyMap.containsKey(usr.AccountId) && policyMap.get(usr.AccountId) != null){
                Policy__c policy = (Policy__c)policyMap.get(usr.AccountId);
                usr.Username = policy.Legacy_Customer_Number__c + policy.Legacy_Policy_Type__c + '@ec-reach.com.hk';
                Contact con = new Contact(Id=usr.Contact.Id);
                con.Username__c = policy.Legacy_Customer_Number__c + policy.Legacy_Policy_Type__c;
                contacts.add(con);
                System.debug('#****New user name='+usr.Username);
            }
        }
        
        System.debug('#****users='+users);
        update users;
        System.debug('#****policies='+policies);
        //update policies;
        System.debug('#****contacts='+contacts);
        //update contacts;
    }
    public void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =
        :BC.getJobId()];

        System.debug('The batch Apex job processed user updates ' + a.TotalJobItems +
         ' batches with '+ a.NumberOfErrors + ' failures.');

        // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // String[] toAddresses = new String[] {a.CreatedBy.Email};
        // mail.setToAddresses(toAddresses);
        // mail.setSubject('Apex Sharing Recalculation schedule email update' + a.Status);
        // mail.setPlainTextBody
        // ('The batch Apex job processed scoreCard update ' + a.TotalJobItems +
        // ' batches with '+ a.NumberOfErrors + ' failures.');
        // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

    global void execute(SchedulableContext sc){
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        OnBoardingUpdateUsername b = new OnBoardingUpdateUsername();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,50);
    }
    //   0 0 0 ? * * * every day 12am
    //Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
    public static String CRON_EXP = '0 0 0 ? * * *';
    public static void scheduleBatch(){
        // Schedule the job
        String jobId = System.schedule('ScheduledUsernameUpdate',
        CRON_EXP, new OnBoardingUpdateUsername());
        System.debug('#****ScheduledUsernameUpdate with job id ='+jobId);
    }
}
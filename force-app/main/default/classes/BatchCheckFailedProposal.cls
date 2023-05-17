public with sharing class BatchCheckFailedProposal {
    public String executeQuery;
    public BatchCheckFailedProposal() {
        System.debug('BatchCheckFailedProposal construtor');
        executeQuery='select id,Name, (select id from Proposals__r) from Account where CreatedDate >= LAST_N_DAYS:2';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchCheckFailedProposal start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchCheckFailedProposal execute');
        // List<Account> accList = new List<Account>();    
        List<String> accIDList = new List<String>();
        for (sObject s:scope) {
            Account acc=(Account)s;
            if (acc?.Proposals__r.size() == 0) {
                accIDList.add(String.valueOf(acc.id));
            }
            System.debug('acc :'+acc);
            
        }
        System.debug('accIDList : '+accIDList);
        if(accIDList != null && accIDList.size()>0){
            //SME_ConsoleHandler.createInvoiceForSBP(policyIDList);
            String emailMsg='These accounts have been created but failed to create proposal. Please find the list Below :\n ';
            emailMsg += String.join( accIDList, ', ' ); 
            System.debug(emailMsg);
            ExceptionLogger.auraLog(emailMsg, 'BatchCheckFailedProposal');
            ExceptionLogger.auraEmail(emailMsg);
        }else {
            ExceptionLogger.auraLog('No error found', 'BatchCheckFailedProposal');
            System.debug('BatchCheckFailedProposal:: no error found');
        }
        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchCheckFailedProposal finished');
    }
}
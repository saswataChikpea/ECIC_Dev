public with sharing class GetChatsForBot {
    @AuraEnabled(cacheable = true)
    public static List<Case> GetChatRecords() {

        List<Case> caseList= [Select Id ,CaseNumber, Subject , Status , Description FROM Case];
        return caseList;

    }
}
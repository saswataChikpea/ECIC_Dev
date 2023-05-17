public with sharing class ResponseData {
    @AuraEnabled
    public Boolean isSuccess{get;set;}
    @AuraEnabled
    public String responseMsg{get;set;}
}
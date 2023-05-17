public with sharing class CLEndorsement {
    @AuraEnabled
    public static List<Account> getSubsidiaryList(Id accId) {
        return [select Id,Name,Subsidiary_Address_Line1__c,Subsidiary_Address_Line2__c,Subsidiary_Address_Line3__c,Subsidiary_Address_Line4__c,Subsidiary_Country__c from Account where Type='Subsidiary' and ParentId=:accId];
    }
    @AuraEnabled
    public static List<Related_Endorsement__c> getEndorsement(Id policyId){
        try {
            Date to_day=Date.today();
            return [select Id,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,Endorsement_Type__r.Name,Effective_Date__c from Related_Endorsement__c where Policy__c=:policyId and Effective_Date__c<=:to_day];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string createSubsidiaryRelatedCL(Id cla_id, List<Id> sub_id){
        try {
            List<Subsidiary_Related_To_CL__c> sub_rel_cl = new List<Subsidiary_Related_To_CL__c>();
            for(Id each_sub_id:sub_id){
                sub_rel_cl.add(
                    new Subsidiary_Related_To_CL__c(Subsidiary__c=each_sub_id,
                    Credit_Limit_Application__c=cla_id)
                );
            }
            if(sub_rel_cl.size()>0)
            insert sub_rel_cl;
            return JSON.serialize(sub_rel_cl);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
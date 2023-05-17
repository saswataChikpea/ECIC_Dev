public without sharing class EcicDocumentTriggerHandler {
    public EcicDocumentTriggerHandler() {

    }
    
    @future
    public static void handleAfterTrigger(Set<Id> docIds){
        System.debug('handleAfterTrigger::'+docIds);
        List<ECIC_Document__c> docs=[select id,Document_Id__c,Account__c,Document_Type__c from ECIC_Document__c where id in:docIds];
        System.debug('ECIC_Document__c::'+docs);
        List<ECIC_Document__c> updateDocList= new List<ECIC_Document__c>();
        List<Account> updateAccList= new List<Account>();
        List<ContentDocument> updateContentDocList= new List<ContentDocument>();
        for (ECIC_Document__c ed : docs) {
            String docId1=String.valueOf(ed.Document_Id__c);
            System.debug('docId1::'+ed.Document_Id__c);
            if (ed.Document_Type__c =='BR Document' && docId1.startsWith('068')) {
                ContentVersion cv= [SELECT Id, ContentDocumentId,Title, FileExtension, VersionData FROM ContentVersion where Id = :ed.Document_Id__c];
                System.debug('content version::'+cv);
                ContentDocument cd=[select id,ownerId from ContentDocument where id=:cv.ContentDocumentId];
                System.debug(cd);
                Id userId=[select id, name,contact.AccountId from user where contact.AccountId=:ed.Account__c].id;
                System.debug('userId::'+userId);

                ed.Document_Id__c= cd.Id;
                updateDocList.add(ed);

                Account acc=[select id, Document_Id__c from Account where id=:ed.Account__c];
                acc.Document_Id__c = cd.Id;
                updateAccList.add(acc);

                if (userId!=null) {
                    cd.ownerId= userId;
                    updateContentDocList.add(cd);
                }
            }
        }   
        if (!updateAccList.isEmpty()) {
            update updateAccList;
        }
        if (!updateDocList.isEmpty()) {
            update updateDocList;
        }
        if (!updateContentDocList.isEmpty()) {
            update updateContentDocList;
        }
    }
}
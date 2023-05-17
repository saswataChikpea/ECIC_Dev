trigger changeDocumentStatusTrigger on ECIC_Document__c (After insert) {
    if(Trigger.isInsert && Trigger.isAfter){

        List<ECIC_Document__c> updateDocList= new List<ECIC_Document__c>();
        List<ContentDocument> updateContentDocList= new List<ContentDocument>();
        for (ECIC_Document__c ed : Trigger.new) {
            String docId=String.valueOf(ed.Document_Id__c);
            System.debug('docId::'+ed.Document_Id__c);
            if (ed.Document_Type__c =='BR Document' && docId.startsWith('068')) {
                ContentVersion cv= [SELECT Id, ContentDocumentId,Title, FileExtension, VersionData FROM ContentVersion where Id = :ed.Document_Id__c];
                System.debug('content version::'+cv);
                ContentDocument cd=[select id,ownerId from ContentDocument where id=:cv.ContentDocumentId];
                System.debug(cd);
                Id userId=[select id, name,contact.AccountId from user where contact.AccountId=:ed.Account__c].id;
                System.debug('userId::'+userId);

                ed.Document_Id__c= cd.Id;
                updateDocList.add(ed);

                if (userId!=null) {
                    cd.ownerId= userId;
                    updateContentDocList.add(cd);
                }
            }
        }   
        if (!updateDocList.isEmpty()) {
            update updateDocList;
        }
        if (!updateContentDocList.isEmpty()) {
            update updateContentDocList;
        }
    }
}
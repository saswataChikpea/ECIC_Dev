public with sharing class EndorsementFile { 
    public String pdfData{get;set;}
    public  EndorsementFile(){
        List<Endorsement__c> endList = [select id,name,(select Id, Name FROM Attachments) from Endorsement__c where name='EN67'];

        List<Document> documents = [select Id, Body, ContentType, BodyLength from Document where Id='0150l000000n83V'];
        pdfData = EncodingUtil.base64Encode(documents[0].Body);
        System.debug('pdfData=====>>'+pdfData);
       
    }
}
@RESTResource(urlMapping='/v1/AddCaseFiles/')
global class addCaseFilesAPI {
    @HTTPPost
    global static string addCaseFile(){
        
        String Ftitle , FfileExtension, FcontentLocation , FfirstPublishLocationId ,FversionDataString1,FversionDataString, FpathOnClient,fieldName, fieldValue ;
        Blob FversionDataBlob,FversionDataBlobPDF;
        
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonBody = req.requestBody.toString();
        System.debug('Body is '+jsonBody);
        
        JSONParser parser = JSON.createParser(jsonBody);
        
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                if(fieldName == 'Title'){
                    Ftitle = fieldValue;
                }
                if(fieldName == 'PathOnClient'){
                    FpathOnClient = fieldValue;
                    FfileExtension = FpathOnClient.substringAfter('.');
                }
                else if(fieldName == 'ContentLocation'){
                    FcontentLocation = fieldValue;
                }
                else if(fieldName == 'FirstPublishLocationId'){
                    FfirstPublishLocationId = fieldValue;
                }
                else if(fieldName == 'VersionData'){
                    System.debug('fieldValue = > '+fieldValue);
                    FversionDataBlob =EncodingUtil.base64Decode(fieldValue);
                 //   FversionDataBlobPDF = Blob.toPdf(fieldValue);//fieldValue
                    System.debug('FversionDataBlob'+FversionDataBlob);
                    System.debug('FversionDataString'+FversionDataString);
                }
            }   
        }
        ContentVersion c = New ContentVersion( 
            Title=Ftitle ,
            PathOnClient=FpathOnClient, 
            ContentLocation=FcontentLocation ,
            FirstPublishLocationId=FfirstPublishLocationId,
            VersionData= FversionDataBlob);//for pdf FversionDataBlobPDF
        
        insert c;
        return c.Id;
    }
}
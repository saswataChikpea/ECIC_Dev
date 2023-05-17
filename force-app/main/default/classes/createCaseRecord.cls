@RESTResource(urlMapping='/v1/CreateCase/')
global class createCaseRecord {
    @HTTPPost
    global static string createCaseRecord(){
        
        String Cstatus , Corigin , Csubject , Cpolicy, Cdesc, fieldName, fieldValue ;
        
        
        RestRequest req = RestContext.request;
        
        RestResponse res = RestContext.response;
        
        String jsonBody = req.requestBody.toString();
        
        System.debug('Body is '+jsonBody);
        
        JSONParser parser = JSON.createParser(jsonBody);
        
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                
                if(fieldName == 'Status'){
                    Cstatus = fieldValue;
                }
                else if(fieldName == 'Origin'){
                    Corigin = fieldValue;
                }
                else if(fieldName == 'Subject'){
                    Csubject = fieldValue;
                }
                else if(fieldName == 'Policy'){
                    Cpolicy = fieldValue;
                }
                else if(fieldName == 'Description'){
                    Cdesc = fieldValue;
                }
                
                
                
            }
            
        }
        
        //List<Policy__c> pol = New List<Policy__c>();
        
        Policy__c pol = [Select Id , name , Exporter__c, Exporter__r.Name from Policy__c where Name = :Cpolicy];
        
        System.debug('pol account Name'+ pol.Exporter__c);
        
        
        Case c = New Case(Status=Cstatus , Origin= Corigin , Subject = Csubject , Description = Cdesc ,  AccountId = pol.Exporter__c);
        
        insert c;
        
        return c.Id;
        
    }

}
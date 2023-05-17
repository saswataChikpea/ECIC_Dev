@RESTResource(urlMapping='/v1/getCase/')
global class getCaseRecordAPI {
    @httpGet
    global static List<Case> getCaseDetails(){
        
        Map<String, String> params = RestContext.request.params;
        String policyNumber = params.get('policyNumber');
        String responseData;
        Set<Id> accId = new Set<Id>();
        
        Policy__c pol = [select id,Exporter__c from Policy__c where Name =:policyNumber];
        accId.add(pol.Exporter__c);
        
        List<Case> cs = new List<Case>();
        cs = [Select id,CaseNumber,AccountId,Subject,Status,Description from Case where AccountId IN :accId ];
        return cs ;
          // responseData = '{id:'+c.id+' , Case Number : '+c.CaseNumber+' , Status : '+c.Status+' , Subject : '+c.Subject+' , Description: '+c.Description+'}';
           
        
       // RestContext.response.addHeader('Content-Type', 'application/json');
        //RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseData));   
        
    }
}
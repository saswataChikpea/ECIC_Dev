// this is for testing purpose only. do not migrate it.
// created by sayantan@chikpea.com


public with sharing class AccountWebService {
 
    public static Http http = new Http();
    public static HTTPResponse response;
    public static HttpRequest request;
 
    public class NewAccountRequestWrapper {
        public String name {get; set;}
        public String phone {get; set;}
    }
 
    public static void getAccount(Id accId) {
 
        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:SF_UAT_v1/services/apexrest/Account/' + accId);
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    }
 
    public static void addAccount(NewAccountRequestWrapper newAccount) {
 
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:SF_UAT_v1/services/apexrest/Account');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    }
 
    public static void deleteAccount(Id accId) {
 
        request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('callout:SF_UAT_v1/services/apexrest/Account/' + accId);
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    }
 
}
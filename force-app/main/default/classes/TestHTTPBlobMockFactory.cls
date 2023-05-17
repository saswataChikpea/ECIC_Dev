@isTest
public with sharing class TestHTTPBlobMockFactory implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected Blob body;
    protected Map<String, String> responseHeaders;
    public TestHTTPBlobMockFactory(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
        res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBodyAsBlob(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }    
}
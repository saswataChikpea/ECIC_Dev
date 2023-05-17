@RestResource(urlMapping='/ecic/v1')
global with sharing class ECIC_service {

  @HttpPost
    global static String doPost(String payload) {
        return 'received '+payload;
    }
}
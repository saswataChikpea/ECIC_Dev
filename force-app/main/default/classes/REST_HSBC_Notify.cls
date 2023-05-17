@RestResource(urlMapping='/receive/notification/')
global with sharing class REST_HSBC_Notify {

    @HttpPost
    global static String paymentNotification(String merId, String txnRef, 
        String currency_x, Integer amount, String proCode, String proMsg, String bankTxnId,
        String bankTxnTime, String suppInfo) {
        
        System.debug(merId);
        String res = '{\'status\': \'SUCCESS\'}';
        return res;
    }
}
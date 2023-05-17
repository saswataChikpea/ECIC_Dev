public with sharing class PaymentResponseCodeMsg {
    public static String getPaymentResponseMsg(String reasonCode,String language,String merchant_refrence) {
        System.debug('getPaymentResponseMsg reasonCode: '+reasonCode+' language :'+language);
        String actualMsg;
        Map<String,String> engResponseCodeVsMsgMap = new Map<String,string>();
        engResponseCodeVsMsgMap.put('100','Transaction successful. Reference Number: merchant_refrence .');
        engResponseCodeVsMsgMap.put('110','Transaction successful. Reference Number: merchant_refrence .');
        engResponseCodeVsMsgMap.put('200','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('201','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('230','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('520','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('102','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('202','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('203','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('204','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('205','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('207','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('208','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('210','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('211','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('221','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('222','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('231','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('232','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('233','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('234','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('236','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('240','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('475','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('476','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        engResponseCodeVsMsgMap.put('481','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');

        engResponseCodeVsMsgMap.put('104','Transaction unsuccessful. Reference Number: merchant_refrence For assistance, please contact Ms. Lee (2732 9011).');
        engResponseCodeVsMsgMap.put('150','Transaction unsuccessful. Reference Number: merchant_refrence For assistance, please contact Ms. Lee (2732 9011).');
        engResponseCodeVsMsgMap.put('151','Transaction unsuccessful. Reference Number: merchant_refrence For assistance, please contact Ms. Lee (2732 9011).');
        engResponseCodeVsMsgMap.put('152','Transaction unsuccessful. Reference Number: merchant_refrence For assistance, please contact Ms. Lee (2732 9011).');


        Map<String,String> traditionalChineseResponseCodeVsMsgMap = new Map<String,string>();
        traditionalChineseResponseCodeVsMsgMap.put('100','交易完成。參考編號: merchant_refrence');
        traditionalChineseResponseCodeVsMsgMap.put('110','交易完成。參考編號: merchant_refrence');
        traditionalChineseResponseCodeVsMsgMap.put('200','Transaction rejected. Reference Number: merchant_refrence For assistance, please contact your bank.');
        traditionalChineseResponseCodeVsMsgMap.put('201','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('230','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('520','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('102','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('202','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('203','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('204','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('205','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('207','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('208','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('210','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('211','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('221','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('222','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('231','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('232','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('233','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('234','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('236','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('240','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('475','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('476','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');
        traditionalChineseResponseCodeVsMsgMap.put('481','交易被拒絕。參考編號: merchant_refrence 如需協助，請聯絡您的銀行。');

        traditionalChineseResponseCodeVsMsgMap.put('104','交易未能完成。參考編號: merchant_refrence 如需協助，請聯絡李小姐(2732 9011)。');
        traditionalChineseResponseCodeVsMsgMap.put('150','交易未能完成。參考編號: merchant_refrence 如需協助，請聯絡李小姐(2732 9011)。');
        traditionalChineseResponseCodeVsMsgMap.put('151','交易未能完成。參考編號: merchant_refrence 如需協助，請聯絡李小姐(2732 9011)。');
        traditionalChineseResponseCodeVsMsgMap.put('152','交易未能完成。參考編號: merchant_refrence 如需協助，請聯絡李小姐(2732 9011)。');

        Map<String,String> simplifiedChineseResponseCodeVsMsgMap = new Map<String,string>();
        simplifiedChineseResponseCodeVsMsgMap.put('100','交易完成。参考编号: merchant_refrence');
        simplifiedChineseResponseCodeVsMsgMap.put('110','交易完成。参考编号: merchant_refrence');
        simplifiedChineseResponseCodeVsMsgMap.put('200','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('201','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('230','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('520','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('102','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('202','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('203','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('204','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('205','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('207','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('208','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('210','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('211','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('221','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('222','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('231','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('232','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('233','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('234','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('236','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('240','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('475','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('476','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');
        simplifiedChineseResponseCodeVsMsgMap.put('481','交易被拒绝。参考编号: merchant_refrence 如需协助，请联络您的银行。');

        simplifiedChineseResponseCodeVsMsgMap.put('104','交易未能完成。参考编号: merchant_refrence 如需协助，请联络李小姐(2732 9011)。');
        simplifiedChineseResponseCodeVsMsgMap.put('150','交易未能完成。参考编号: merchant_refrence 如需协助，请联络李小姐(2732 9011)。');
        simplifiedChineseResponseCodeVsMsgMap.put('151','交易未能完成。参考编号: merchant_refrence 如需协助，请联络李小姐(2732 9011)。');
        simplifiedChineseResponseCodeVsMsgMap.put('152','交易未能完成。参考编号: merchant_refrence 如需协助，请联络李小姐(2732 9011)。');

        if(language!= null && language.equals('en-us')){
            actualMsg = engResponseCodeVsMsgMap.get(reasonCode).replace('merchant_refrence', merchant_refrence);
        }else if(language!= null && language.equals('zh-cn')){
            actualMsg = traditionalChineseResponseCodeVsMsgMap.get(reasonCode).replace('merchant_refrence', merchant_refrence);
        }else if(language!= null && language.equals('zh-tw')){
            actualMsg = simplifiedChineseResponseCodeVsMsgMap.get(reasonCode).replace('merchant_refrence', merchant_refrence);
        }
        System.debug('actualMsg ===>'+actualMsg);
        return actualMsg;

    }
}
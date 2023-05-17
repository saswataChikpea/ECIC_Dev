@isTest
public with sharing class TestAPIUtility {
    
    //Class - CustomJWTPayloadGenerator
    //@isTest(SeeAllData=true)
    @isTest
    static void payloadgen(){
        
        TestCLDataFactory.insertECCSetting();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();

        Map<String, Object> jsonObject = new Map<String, Object>{'ID' => 'I12345'};
        String payload = CustomJWTPayloadGenerator.payloadgen(true, jsonObject);
        //String expected = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..RXhhbXBsZSBvZiBJVjI1Ng.iaWRo0AiXf_WMTUh8qRdRaGWNd2FXLBUdJ2NDsdapwfuvb99eoa0LTVTTZsbf3aSAFXcu_qjI_rbQ63L84QaIMvJjwQO4aJiTxIF1_pI4EBKjyHH7eXJHacuvxpWbeJtIhxqL4aIpg7y68Wm2fNWj_fQkXOH9Sqw2PFDJgflcYVyHvoPw6IeEXfjzaq9sCw5OhfJxrP8NWd-Y5xrRp2Gsx0tgNCKFC7M_lXDhXc86FAb4-DcCPUGfX_wffTOg4D_HFZ8PcyzgZwTb47jAt4S17rhXh57oURDUfSxyvMg8bc7OOXMQf7yYKhtEZ3VoU5Tq4qMI38mo8IXrHwQG6BtEdis2-0DoAsCmnYgUdyoE3uGBvW4YJ72QdIztneYcucd_XSHOKYt3Zgrk6qaokTHmDWsUMTvQoWlSO8jLnxJP157pZAuqzAyKr_6NWubFv5MjWI0laXSBr9feKf5d0QVn1KRo7b-hs3Ez9jiF7cbFAY7tZcXT2Hpo_rSkhUt5aE5Egq9FBE3LQUgmln2WGRSl3KyeTuahqYLC7ielNHH7nQ';
        //System.assertEquals(expected, payload);        
        Test.stopTest();
        
    }

    //Class - ResponseParserClass
    @IsTest
    static void responseParseMethod(){
        
        TestCLDataFactory.insertECCSetting();
        Test.startTest();
        String resp = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..1I_5XPae4D-Y5fc6R2FK8g.BGM7ZP3OKBJ9ClXEU1oEr9_FQfXDXxv37gS1AtWOneqQei8nJPh5QtSl2f5Tej92rhLyIBralBs9aZUFRpEVfrSJcTI--FFRTSFiuVGjjuk62yFpYYIj418G4XsVcwMKxu4PgKPI4-YaLn8XDOF_q6FceKojVBdmU-7lXZKLzrqvg9esawDrIjsG0JJdn-oPt4WQeMYU92GqkDoYJz4wIM55Vi1_MJ-ajY9xmYKApB_VjKaOYIo9cNOFXEBdJISifmLKxmM4QSob8Wzy_qG4SnBQHcsJzJT4OiSJugaQrZIRKsfk-lv9xg_ytc7DMebjUiImfEVJeeOVVfcrajwY_50TKvOt2TcbXr_oGZK_p6IUUVPHsYj7TIYsB6toh7m1i3jPauKuMFkExUj3Lu3NTuhffOdfZ2DGFacNhWCvL9icxZEmMJUsx1VJRWPwrnV2nr_F56N5qPm8QDwOXJfSJi5io0Tvz280f6BE505vhFVMi5MnwUX8Uac25mJdMySNqLQOu0Y2rAiiZsiSLmhiLy-Zvk4bSTGg6-IF4w3zdyTYs1whRTpsSkoq3IjEb9a4dOoSa5k_Rg-NV41LwpFYUQcqEvZuN3X3xT50xtl5oZ2NFW4QY5O72XCQopmks5MUdQibEtpa7y0qcP_f4OA0F2lThLu3ryN5d5F4jC9Sj6Ge5u2AViQVrjb-Kjec-JC3UlJzHeRrJJPQqRnxldXQo0nCwaN9jaSx9qComG2Ro0vgwmNj3iD0nOEE50wEwcNkXjlYF6IK1dYcuOpDZe4JLvjOgpA2PTtc1IKO6ChA48IG2Af2DcuMGVegdkbrACY4HmuhPR4Ws6gx8JIT7goGtnTvSViluPMD85dDrb2fgl_VE_3pm-QEXzgH6fK0T6P0l_kd4CSUfyDUSlc1VPnVC6IL3PNYGlvYHBqiI8_N_ob-3dkoQvwDt_WuPEfiJ4yeR0o4GZkXIEvheplfxhjyirble-RiMe9g_dysCqVmrwLsn7myhvbQrSVqyL6NILD4wnO32ddfYUfj6rWFg14I_SIW8rwMPj8rcFwTMqvoysk0iuXng9cKzkYY-lW5MIddax8TGqIVR4uUgQU-bXKilzxzLWzLRPz64M34hHKAoxLL5ezkyLGilbL1SiLG9uK9UU0w-O7Iqoz7GEl4VjVRl4QEzvu9T9AS_lO3QTsbfHjF5BEhPs0paqm_c_A4Ds96.MFkqb4yarymRCx_7raPv8wenbxxhLkdzS-v1b7dKzow';
        list<String> splitResp = resp.split('\\.');
        Map<String, String> decryptedKeyValue = ResponseParserClass.responseParseMethod(splitResp);
        Test.stopTest();
        
    }

    //Class - CustomBase64EnCodeDecodeClass
    @IsTest
    static void base64URLDecode(){
        
        String input = '1I/5XPae4D+Y5fc6R2FK8g';
        String expected = '1I/5XPae4D+Y5fc6R2FK8g==';
        String output = CustomBase64EnCodeDecodeClass.base64URLDecode(input);
        System.assertEquals(expected, output);
        
    }

    //Class - CustomBase64EnCodeDecodeClass
    @IsTest
    static void base64URLencode(){
        
        String headerValue = '{"enc":"A256CBC-HS512","alg":"dir"}';
        String b64URLEncodedHeader = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(headerValue));
        String expected = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0';
        System.assertEquals(expected, b64URLEncodedHeader);
        
    }

}
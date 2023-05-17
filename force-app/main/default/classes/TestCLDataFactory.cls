@isTest
public with sharing class TestCLDataFactory {
    public static Account createAccount() {
        Account acc = new Account(Name='TestAccount',
        Legacy_Customer_Number__c='1234');
        insert acc;
        return acc;
    }
    public static Plan__c createProduct(String plan_type){
        Plan__c prod = new Plan__c(Name=plan_type,
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        return prod;
    }
    public static Policy__c createPolicyWithSchedule(Id prod_id,Id acc_id) {
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod_id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Commencement_Date__c=Date.today().addMonths(-13),
        Issue_Date__c=Date.today().addDays(-5),
        Exporter__c=acc_id,        
        Is_Active__c=true);
        insert policy;
        Policy_Schedule__c schedule = new Policy_Schedule__c(
        Policy__c=policy.Id,
        Effective_Date__c=Date.today().addDays(-5),
        Issue_Date__c=Date.today().addDays(-5),
        Maximum_Liability__c=150000,
        Type__c='Schedule 1'
        );
        insert schedule;
        return policy;
    }
    public static Credit_Limit_Application__c createCLA(Id acc_id, Id policy_id){
        Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464',
                Legacy_Pre_Ref_No__c='787878',
                Application_Type__c='New'
            );
            insert cl_app;
            Outstanding_Payment__c op = new Outstanding_Payment__c(
                Shipment_Or_Invoice_Date__c=Date.today(),
                Gross_Invoice_Currency__c='HKD',
                Gross_Invoice_Amount__c=1000,
                Payment_Term_Type__c='OA',
                Payment_Term_Days__c=90,
                Credit_Limit_Application__c=cl_app.Id
            );
            insert op;
            return cl_app;
    }
    public static Credit_Limit_Application__c createDCLA(Id acc_id, Id policy_id){
        Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Amend_Buyer_Name__c='DEF',
                Amend_Buyer_Address_Line_1__c='jksbd',
                Amend_Buyer_Address_Line_2__c='kajbg',
                Amend_Buyer_Address_Line_3__c='asuifh',
                Amend_Buyer_Address_Line_4__c='uefg',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464',
                Legacy_Pre_Ref_No__c='787878',
                Is_Dcl__c=true
            );
            insert cl_app;
            return cl_app;
    }
    public static Credit_Limit__c createCL(Id acc_id, Id policy_id){
        Credit_Limit__c cl = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Amount__c=10000,
                CL_Status__c='Valid',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464'
            );
            insert cl;
            return cl;
    }
    public static Credit_Limit__c createDCL(Id acc_id, Id policy_id){
        Credit_Limit__c cl = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Amend_Buyer_Name__c='DEF',
                Amend_Buyer_Address_Line_1__c='jksbd',
                Amend_Buyer_Address_Line_2__c='kajbg',
                Amend_Buyer_Address_Line_3__c='asuifh',
                Amend_Buyer_Address_Line_4__c='uefg',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Amount__c=10000,
                CL_Status__c='Valid',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464',
                Is_Dcl__c=true
            );
            insert cl;
            return cl;
    }
    public static void insertECCSetting(){
        ECIC_Settings__c settings = new ECIC_Settings__c(
            Name='ECIC_UAT',
            Access_Token__c='eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyMFhGYktXemJad2tya0p3Tm1zRVJXb0xNSVVsckhnUllCbUloTDVGTHBRIn0.eyJleHAiOjE2MzI5MTIyNDgsImlhdCI6MTYzMjgyNTg0OCwianRpIjoiNzE0M2JlYjItYTM0Mi00NzliLWIyZmEtNzQ4MjRkYzQ1N2JiIiwiaXNzIjoiaHR0cDovL2tjL2F1dGgvcmVhbG1zL0RlbW8tUmVhbG0iLCJzdWIiOiIyZmM4YmVlYy00NjMyLTQyODQtYTc0NS0xNTQyMDczZDBlMzEiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJlY3JlYWNoX2RldiIsInNlc3Npb25fc3RhdGUiOiI0NDkzMjY0My1jMDM4LTRlODItOTI5NS04NWRiZjZmMmY0OTgiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbImFwcC1hZG1pbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InNwcmluZ2Jvb3QtbWljcm9zZXJ2aWNlIjp7InJvbGVzIjpbImFkbWluIl19LCJlY3JlYWNoX2RldiI6eyJyb2xlcyI6WyJhZG1pbiJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJpZ25hdGljYV9kZXYifQ.m2Wn7lRm42vL4RcTEqaxwbZ3WIuTR2Iai2wKMEv_i4RrILUwZdz8aujVFhGodBc9jyugBKVbd0nrcyZsRqn9WcRLoQYzMN97aGcVxxFhynvfAzQdnQiliMx-asOyYhoc69JSy4z8kO8Mc8PlcGViFAfavpzkVPX864PwK0MAjLR_TdMNMHDLxCgu0UD51SIELGcvKiRCWuzDQMbPJ3scxbrJ5Jz2ZMW2DV_rlhwS0y-gionUUd0YxswMEju6x1FE0Lc7oLLXkDr7m2ZEpWo_NbtM-1v6hcM9NySTBPSvhg_VIRDBF2e6CsJEZZAU_b3mzab-WP-3ByIUWx45HU3aXg',
            Access_Token_Updated__c=Datetime.newInstance(2021,09,28, 10,44,08),
            Access_Token_Valid_Upto__c=Datetime.newInstance(2021,12,28, 10,44,08),
            ecic_hmac_key__c='mt9c1Re4G6RiKUxnQawc9tBQ0k2WcWiKLTMuIl70aSA=',
            ecic_public_key__c='Gn4eB1ciYvofSIpiziYLtYoE2pplA7diCXgAwtdsB6k=',
            ecic_public_rsa_key__c='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0HO7JHzwJACDUlHowSIiNarDytbisV4QWBx6t9YPr7kJW2VoPEMRaTED2Qfja3pwqrowKq7j0Or5KLUeCf87Y7fo8vBjZTpcTiZcKZGnHFACsWUDLpn1MGtq4fDyCHEr9L6QNKqHd2psPBMSB37KSr+vpKT4bbrdD7qrkvbxddkB22P1juoVW7OlWfJxeecwacxiLd4HacskHxVW9NaFw5kCrckVtINmDjEP0jHlEXcQTB6ekZsCxf1qJAJyadt9BumcSsm0D0nhJurzhXwQfUVysMGLZqBglu4zS8J6h4rK0Kr7or5V8VrfapHFRBiNo0NhLE+6PayyRajX8XdkwIDAQAB',
            ecic_uat_hmac_key__c='mt9c1Re4G6RiKUxnQawc9tBQ0k2WcWiKLTMuIl70aSA=',
            ecic_uat_public_key__c='Gn4eB1ciYvofSIpiziYLtYoE2pplA7diCXgAwtdsB6k=',
            ecic_uat_public_rsa_key__c='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0HO7JHzwJACDUlHowSIiNarDytbisV4QWBx6t9YPr7kJW2VoPEMRaTED2Qfja3pwqrowKq7j0Or5KLUeCf87Y7fo8vBjZTpcTiZcKZGnHFACsWUDLpn1MGtq4fDyCHEr9L6QNKqHd2psPBMSB37KSr+vpKT4bbrdD7qrkvbxddkB22P1juoVW7OlWfJxeecwacxiLd4HacskHxVW9NaFw5kCrckVtINmDjEP0jHlEXcQTB6ekZsCxf1qJAJyadt9BumcSsm0D0nhJurzhXwQfUVysMGLZqBglu4zS8J6h4rK0Kr7or5V8VrfapHFRBiNo0NhLE+6PayyRajX8XdkwIDAQAB',
            ecic_private_rsa_key__c='Tn45mmt5+90+8kbQz8iT6q4071sC7G/UodrLJBAvPwutL0eXDW7rBpB7i0vpPVXtX6Ai4W3/aZW0e+823+QDlGbQLvyCcWbLQ9tTfpqsZuYkqzc494CXpwUAqWpCKH35618TIY1/h300CrvQzAUz5CQ3ve7m065SdaTX5FdmII4GqX+tdRKihVWP/7SXnasvhX4QekX0tAT1kXbndC4avaqUiuVVF1x8xN4pIxvW327iJiC8oc1nftULULysFbwStpAckwUPKCRGCQ62hrb5wMXPvFZLNrlPoFLgkWSggmn3aItx8762M/dXTSNy7WjupMTDjRA/pIhSTMjEf8ChcKACM5LNQWQRrWxBWEXJpfySsjA3WK95IwvffITVUwvBC1uGnIQuj8TZcu6WPnCeU/9fdUJ39HQBQVKu5N90b2n1/G5PVUj+rOPrGzYwCx9j5iGhUnvro5qiuNNkOsUbnbSDxcyGsgPYwr0XBgrhiZJxe6UmsLhWOspkarksyOSdmF7oTeifGqPreg9/DFQj4jv2wDiMicRIXvuvm6E0VkBvIFLPvUJxQy6mx6NVb1C+mAbf2KtzuzJC011nMXO6T9VzmwmELaH5ChqOBL4AWK3Odn1DnmJ3Amp+wjmA4UhZYZZrzDWTf//faO1Wx7NbcUU804CwDfZLJjVluyAJRgZ4m0EcYTMlVu0u2nyKpNGiRqOaZT41cYt+5cl12tXnIZXK8pGoLniV3pJAM5Tszjwe6MIMowyFsFUNloc9fms52NBniwdkuFa9HdZLz6GtwhuAD7N1C8kKlZFXeU5UPjY6fGxB7jzbrt/VircT7bfUZzg04UdfbOU1RvrxQ/+2DYP/Nc7v1e/Eb5UtoIwIC7ZRrxyXEQRnxKhnaOYQCBz3HzYU+WYJqovIEXHb31RvnW2SpmDdRIF2x2kXDxKj6ZZzsz8amidNlg7L3OejssUgBLr+LkQBQJWRcpjBgBZ3lNj6CAApprUrc4/V028hr2TCtuiYvai8QlfHA8lmNYIGoZldR+ytSDtf3jgXHiYevbGabzA62v2s/Q8MV+5GiEYGH4wrOAuN69KBW8/OAmBKJ+nBMrxSK1D30+9ZlSH5x4JDkkU2kUYqOp/kGvRmivlA1XSD3bPLtyAZWOINJ1CiYfpbeha0/LDb91cG/GmJ4rzPQICgH8IxHARLEc1fr4OwqtXnJAlzKF45R/8aqXD72DLsCTP8wJk29APcv7vlR3xTOPHnR607GdHVnZb7hsPet3t3US6K8S3vcZgVlZaMf81MhWWw+bGsBdeC3vNJNFApxKaek2fhteK2wc1hkmCRXOPoax386/OQ8tnOVykOzQrjAJNFGm9i8W0vV9cMubKs0+MihNN1IKIXpxbmEUd5ctTqpcZEJ3E+wLkMpG6PCUzK03Eryy/IBG1Dgcr7UjYded32H7uyFSOyrVhcJAKky2sGyjeSa5NtH8nnvLi9vFLcNfrYgg06uF57VVSlpY4jkR1FGmqoKykGHRqJDJxSmvJsGwjYUvlbckxIhpfob3CLE8ER5jfVpV7YT2FDSWyLjUF8yuzX4YnTLLlTjkEOI8exYTW7kExS1iH450Jk',
            ecic_uat_private_rsa_key__c='Tn45mmt5+90+8kbQz8iT6q4071sC7G/UodrLJBAvPwutL0eXDW7rBpB7i0vpPVXtX6Ai4W3/aZW0e+823+QDlGbQLvyCcWbLQ9tTfpqsZuYkqzc494CXpwUAqWpCKH35618TIY1/h300CrvQzAUz5CQ3ve7m065SdaTX5FdmII4GqX+tdRKihVWP/7SXnasvhX4QekX0tAT1kXbndC4avaqUiuVVF1x8xN4pIxvW327iJiC8oc1nftULULysFbwStpAckwUPKCRGCQ62hrb5wMXPvFZLNrlPoFLgkWSggmn3aItx8762M/dXTSNy7WjupMTDjRA/pIhSTMjEf8ChcKACM5LNQWQRrWxBWEXJpfySsjA3WK95IwvffITVUwvBC1uGnIQuj8TZcu6WPnCeU/9fdUJ39HQBQVKu5N90b2n1/G5PVUj+rOPrGzYwCx9j5iGhUnvro5qiuNNkOsUbnbSDxcyGsgPYwr0XBgrhiZJxe6UmsLhWOspkarksyOSdmF7oTeifGqPreg9/DFQj4jv2wDiMicRIXvuvm6E0VkBvIFLPvUJxQy6mx6NVb1C+mAbf2KtzuzJC011nMXO6T9VzmwmELaH5ChqOBL4AWK3Odn1DnmJ3Amp+wjmA4UhZYZZrzDWTf//faO1Wx7NbcUU804CwDfZLJjVluyAJRgZ4m0EcYTMlVu0u2nyKpNGiRqOaZT41cYt+5cl12tXnIZXK8pGoLniV3pJAM5Tszjwe6MIMowyFsFUNloc9fms52NBniwdkuFa9HdZLz6GtwhuAD7N1C8kKlZFXeU5UPjY6fGxB7jzbrt/VircT7bfUZzg04UdfbOU1RvrxQ/+2DYP/Nc7v1e/Eb5UtoIwIC7ZRrxyXEQRnxKhnaOYQCBz3HzYU+WYJqovIEXHb31RvnW2SpmDdRIF2x2kXDxKj6ZZzsz8amidNlg7L3OejssUgBLr+LkQBQJWRcpjBgBZ3lNj6CAApprUrc4/V028hr2TCtuiYvai8QlfHA8lmNYIGoZldR+ytSDtf3jgXHiYevbGabzA62v2s/Q8MV+5GiEYGH4wrOAuN69KBW8/OAmBKJ+nBMrxSK1D30+9ZlSH5x4JDkkU2kUYqOp/kGvRmivlA1XSD3bPLtyAZWOINJ1CiYfpbeha0/LDb91cG/GmJ4rzPQICgH8IxHARLEc1fr4OwqtXnJAlzKF45R/8aqXD72DLsCTP8wJk29APcv7vlR3xTOPHnR607GdHVnZb7hsPet3t3US6K8S3vcZgVlZaMf81MhWWw+bGsBdeC3vNJNFApxKaek2fhteK2wc1hkmCRXOPoax386/OQ8tnOVykOzQrjAJNFGm9i8W0vV9cMubKs0+MihNN1IKIXpxbmEUd5ctTqpcZEJ3E+wLkMpG6PCUzK03Eryy/IBG1Dgcr7UjYded32H7uyFSOyrVhcJAKky2sGyjeSa5NtH8nnvLi9vFLcNfrYgg06uF57VVSlpY4jkR1FGmqoKykGHRqJDJxSmvJsGwjYUvlbckxIhpfob3CLE8ER5jfVpV7YT2FDSWyLjUF8yuzX4YnTLLlTjkEOI8exYTW7kExS1iH450Jk',
            Intialization_Vector__c='Example of IV256',
            sf_private_rsa_key__c='MIIEpAIBAAKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8bUk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZNU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZrQIDAQABAoIBAHdNtTpjjvffjUE+c+r6ox7UM6FCNhGl1JnqnkVTaUC5pKXxidO1//iu+qQaHIcHk0RgeBEgGeLmg4ckU2uPxMQE8VHkalOWkiPBwjwgGG+XX1uXUSad6LFiorqVGlGk597vdypDq27U/mX6eLjrnAKT8cjyakXaHTZw4Kklu1e0/Ki8Z3408MED+QUlSPvqxnde/A5xJRO5hT6J1PdKizCxOd9FM5q2GC0OCFhnr6uBI0Td7ZuR1wxA3UFNEK33kWOxHCxGwhsw4PdSfLzk9gEUNO+hs5YPk/xeOSuZ3ZhEGyq9cGhMqVxsQCldUUcHX3K3xbXY59kD3E/d2SqxM4ECgYEA9MzmFWfcVA8nLnAzhVqjtB046cR2sbpEF8tJjkymzEAOflRfK68q5q2ua6mWIufZM3d3/xj472K1VlgU5VuF2cJ/ho1HR/PtykxUtpxcoKTiXfEulttQVZkAYcU4cKFIzcyC3KcztsCQBncknmam79q0knD11WV9OiAXgPQvRl0CgYEA25kMucQgqtmms58QNtEUwxEnpCglgIj6MebSaEiLOGQPXwLa/5lVvkXWSqtIof3gY0EREshHdiuJSqykmHf3QaSJFSQq20D060iGvcMmIrFvRMNSgqhjCcg0F/pZKJRH308uAx2p7GysJVjdyI8wgYzJdbKR7830c2CIuzYbC5ECgYEAmJNoyGiuc5nqMtBt3CztIWKhSVpRHF7a9/WVR+LQhzdZkTVnB+QqmhIgRywwzlqxDpnkqZNX/GQKX+GQTI+pslq+fw9pIRiQ2eiPWC3Gsb1y9VhQUGgq/t7Y1RdGITT1Goff/EUeP0ZvvgfeQ/f5Dj/DEg7jufiCf4rm+1G2cWUCgYALukS/twW3miAY/6myA8CEGmpvjeVS0/3opFcgUp98x3s6q8BeXiYCH2CuZC9g11ogct0ij6ehW/ndDxNLQTznOI5JnsDbLMDnv9vSTpW+zJMQrQ2/BJclcpe1oB0a2bBs8KGYcQEeKz+WTwSpLVx9zrMDoiHBGNKxRrqGpQEUwQKBgQCiIVNwRj5yaWPgUDm/LdxWyR4KwWbKtzHJiSvSTLR0BECfBZ6Vnrlmxt1E1h9/FTJNceuGtN8RzX0EhcD2kn2ZW7g3a0QJ5ahknrOMiLJhAi8OlnMXtSNmpr57bSHcYzfEg0byas4icuaq6Ss6ew9qYZzUwfnN7elYD43tML/Eug==',
            sf_public_rsa_key__c='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8bUk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZNU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZrQIDAQAB',
            sf_uat_private_rsa_key__c='MIIEpAIBAAKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8bUk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZNU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZrQIDAQABAoIBAHdNtTpjjvffjUE+c+r6ox7UM6FCNhGl1JnqnkVTaUC5pKXxidO1//iu+qQaHIcHk0RgeBEgGeLmg4ckU2uPxMQE8VHkalOWkiPBwjwgGG+XX1uXUSad6LFiorqVGlGk597vdypDq27U/mX6eLjrnAKT8cjyakXaHTZw4Kklu1e0/Ki8Z3408MED+QUlSPvqxnde/A5xJRO5hT6J1PdKizCxOd9FM5q2GC0OCFhnr6uBI0Td7ZuR1wxA3UFNEK33kWOxHCxGwhsw4PdSfLzk9gEUNO+hs5YPk/xeOSuZ3ZhEGyq9cGhMqVxsQCldUUcHX3K3xbXY59kD3E/d2SqxM4ECgYEA9MzmFWfcVA8nLnAzhVqjtB046cR2sbpEF8tJjkymzEAOflRfK68q5q2ua6mWIufZM3d3/xj472K1VlgU5VuF2cJ/ho1HR/PtykxUtpxcoKTiXfEulttQVZkAYcU4cKFIzcyC3KcztsCQBncknmam79q0knD11WV9OiAXgPQvRl0CgYEA25kMucQgqtmms58QNtEUwxEnpCglgIj6MebSaEiLOGQPXwLa/5lVvkXWSqtIof3gY0EREshHdiuJSqykmHf3QaSJFSQq20D060iGvcMmIrFvRMNSgqhjCcg0F/pZKJRH308uAx2p7GysJVjdyI8wgYzJdbKR7830c2CIuzYbC5ECgYEAmJNoyGiuc5nqMtBt3CztIWKhSVpRHF7a9/WVR+LQhzdZkTVnB+QqmhIgRywwzlqxDpnkqZNX/GQKX+GQTI+pslq+fw9pIRiQ2eiPWC3Gsb1y9VhQUGgq/t7Y1RdGITT1Goff/EUeP0ZvvgfeQ/f5Dj/DEg7jufiCf4rm+1G2cWUCgYALukS/twW3miAY/6myA8CEGmpvjeVS0/3opFcgUp98x3s6q8BeXiYCH2CuZC9g11ogct0ij6ehW/ndDxNLQTznOI5JnsDbLMDnv9vSTpW+zJMQrQ2/BJclcpe1oB0a2bBs8KGYcQEeKz+WTwSpLVx9zrMDoiHBGNKxRrqGpQEUwQKBgQCiIVNwRj5yaWPgUDm/LdxWyR4KwWbKtzHJiSvSTLR0BECfBZ6Vnrlmxt1E1h9/FTJNceuGtN8RzX0EhcD2kn2ZW7g3a0QJ5ahknrOMiLJhAi8OlnMXtSNmpr57bSHcYzfEg0byas4icuaq6Ss6ew9qYZzUwfnN7elYD43tML/Eug==',
            sf_uat_public_rsa_key__c='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8bUk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZNU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZrQIDAQAB',
            test_mode__c=true,
            ECIC_API_Client_ID__c='XXXXXXX_dev',
            ECIC_API_Client_Secret__c='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX4ade',
            ECIC_API_Password__c='XXXXXXXXXXXXXXXXXXX',
            ECIC_API_Username__c='XXXXXXXX_dev',
            ECIC_UAT_API_Client_ID__c='XXXXXXX_dev',
            ECIC_UAT_API_Client_Secret__c='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
            ECIC_UAT_API_Password__c='XXXXXXXXXXXXXXXXXXX',
            ECIC_UAT_API_Username__c='XXXXXXXX_dev'
        );
        insert settings;
        
    }

    public TestCLDataFactory() {

    }
}
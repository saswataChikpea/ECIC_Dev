@isTest
public with sharing class TestUpdateMasterListCustomMetadata {
	
    @isTest
    // 5.2
    static void testparseCntryJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"ctry_list\":[{\"ctry_code\":\"ABW\",\"ctry_name\":\"ARUBA\",\"ctry_name_hk\":\"阿魯巴島\"}]}}';
            String res = UpdateMasterListCustomMetadata.parseCntryJsonData(JData);        
        Test.stopTest();        
    }
    
    @isTest
    // 5.3
    static void testparseLegalTypeJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"legal_type_list\":[{\"code_group\":\"xx\",\"code\":\"xx\",\"code_value\":\"xxx\",\"code_desc\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseLegalTypeJsonData(JData);        
        Test.stopTest();        
    }
    
    /*
    @isTest
    // 5.4
    static void testparseProductJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"prd_list\":[{\"prd_code\":\"xx\",\"prd_desc\":\"xx\",\"prd_desc_hk\":\"xxx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseProductJsonData(JData);        
        Test.stopTest();        
    }
    */
    
    @isTest
    // 5.6
    static void testparseCurrencyJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"CCY_LIST\":[{\"CUR_CODE\":\"xx\",\"CODE\":\"xx\",\"CUR_DESC\":\"xxx\",\"cur_desc_hk\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseCurrencyJsonData(JData);        
        Test.stopTest();        
    }
    
    @isTest
    // 5.7
    static void testparsePaymentMethodJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"pay_method_list\":[{\"code_group\":\"xx\",\"code\":\"xx\",\"code_value\":\"xxx\",\"code_desc\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parsePaymentMethodJsonData(JData);        
        Test.stopTest();        
    }
        
    @isTest
    // 5.8
    static void testparseOriginCtryJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"ctry_list\":[{\"ctry_code\":\"xx\",\"ctry_name\":\"xx\",\"ctry_name_hk\":\"xxx\",\"code_desc\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseOriginCtryJsonData(JData);        
        Test.stopTest();        
    }
    
    @isTest
    // 5.9
    static void testparseDestCtryJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"ctry_list\":[{\"ctry_code\":\"xx\",\"ctry_name\":\"xx\",\"ctry_name_hk\":\"xxx\",\"pcy_type\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseDestCtryJsonData(JData);        
        Test.stopTest();        
    }
    
    @isTest
    // 5.10
    static void testparsePortOfLdgJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"ctry_list\":[{\"ctry_code\":\"xx\",\"ctry_name\":\"xx\",\"ctry_name_hk\":\"xxx\",\"pcy_type\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parsePortOfLdgJsonData(JData);        
        Test.stopTest();        
    }
    
    @isTest
    // 5.12
    static void testparseByrCtryJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"ctry_list\":[{\"ctry_code\":\"xx\",\"ctry_name\":\"xx\",\"ctry_name_hk\":\"xxx\",\"pcy_type\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseByrCtryJsonData(JData);        
        Test.stopTest();        
    }
    
    /*
    @isTest
    // 5.1
    static void testparseRegionJsonData(){        
        Test.startTest();
        string JData = '{\"rtn_code\":\"1\",\"rtn_msgs\":null,\"meta_data\":{\"dist_list\":[{\"dist_terr\":\"xx\",\"ctry_name\":\"xx\",\"ctry_name_hk\":\"xxx\",\"pcy_type\":\"xx\"}]}}';
           String res = UpdateMasterListCustomMetadata.parseRegionJsonData(JData);        
        Test.stopTest();        
    }
	*/
        
}
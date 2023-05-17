public with sharing class GetCustomMetaData {
    public GetCustomMetaData() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Legal_Type__mdt> getLegalType(){
        try {
            List<Legal_Type__mdt> map_cn = [select Id,code__c,code_desc__c,code_group__c,code_value__c from Legal_Type__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Product__mdt> getProduct(){
        try {
            List<Product__mdt> map_cn = [select Id,PRD_CODE__c,PRD_DESC__c from Product__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Industry__mdt> getIndustries(){
        // try {
            List<Industry__mdt> map_cn = [select Id,PRD_CODE__c,PRD_DESC__c from Industry__mdt];
            return map_cn;
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getCountryList(){
        // try {
            List<List_Storage__c> map_cn = [select Id,CTRY_CTRY_CODE__c,CTRY_CTRY_NAME__c,CTRY_CTRY_NAME_HK__c, CTRY_GRADE__c from List_Storage__c where List_Type__c='Country' and CTRY_Active__c=true];
            return map_cn;
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getProductList(){
        try {
            List<List_Storage__c> map_cn = [select Id, PRD_CODE__c, PRD_PCY_TYPE__c, PRD_DESC__c, PRD_DESC_HK__c from List_Storage__c where List_Type__c='Product' and PRD_Active__c=true];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<District__mdt> getDistrictTerritoryList(){
        // try {
            List<District__mdt> map_cn = [select Id,District__c,District_HK__c, District_Region__c, 
            District_Region_HK__c, District_Territory__c, District_Territory_HK__c, Sub_District__c, Sub_District_HK__c from District__mdt];
            return map_cn;
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getAllDistrictTerritoryList(){
        List<List_Storage__c> data = [select Id, DIST__c, DIST_HK__c, DIST_RGN__c, DIST_RGN_HK__c, DIST_TERR__c, DIST_TERR_HK__c, SUB_DIST__c, SUB_DIST_HK__c from List_Storage__c where List_Type__c='District' and DIST_Active__c = true];
        return data;
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getKnowAboutEcicList(){
        // try {
            List<List_Storage__c> data = [select Id, Refer_Code__c, Refer_Code_Desc__c, Refer_Code_Group__c, Refer_Code_Value__c from List_Storage__c where List_Type__c='Refer List' and Is_Community_Exposed__c=true];
            return data;
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getOriginCountryList() {
        // try{
            return [select Id,OrgCtryList_Country_Code__c,OrgCtryList_Country_Name__c,OrgCtryList_Country_Name_HK__c from List_Storage__c where List_Type__c='Origin Country' and OrgCtryList_Active__c=true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getDestinationCountryList() {
        // try{
            return [select Id,DestCtryList_Country_Code__c,DestCtryList_Country_Name__c,DestCtryList_Country_Name_HK__c from List_Storage__c where List_Type__c='Destination Country' and DestCtryList_Active__c=true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)//SUP 56, SBP 51, OMBP 70  
    public static List<List_Storage__c> getPortOfLoadingList(String policy_type) {
        // try{
            return [select Id,PortOfLdg_Country_Code__c,PortOfLdg_Country_Name__c,PortOfLdg_Country_Name_HK__c from List_Storage__c where List_Type__c='Port of Loading' and PortOfLdg_Active__c=true and PortOfLdg_Policy_Type__c=:policy_type];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getBuyerCountryList() {
        // try{
            return [select Id,ByrCtry_Country_Code__c,ByrCtry_Country_Name__c,ByrCtry_Country_Name_HK__c from List_Storage__c where List_Type__c='Buyer Country' and ByrCtry_Active__c=true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getBuyerCountryListByPolicy(string policy_type) {
        // try{
            return [select Id,ByrCtry_Country_Code__c,ByrCtry_Country_Name__c,ByrCtry_Country_Name_HK__c from List_Storage__c where List_Type__c='Buyer Country' and ByrCtry_Active__c=true and ByrCtry_Policy_Type__c=:policy_type];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getIndustryList() {
        // try{
            return [select Id, PRD_CODE__c, PRD_PCY_TYPE__c, PRD_DESC__c, PRD_DESC_HK__c, PRD_IS_SERVICE__c from List_Storage__c where List_Type__c='Industry' and Industry_Active__c=true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getIndustryListByPolicy(String policy_type) {
        // try{
            return [select Id, PRD_CODE__c, PRD_PCY_TYPE__c, PRD_DESC__c, PRD_DESC_HK__c, PRD_IS_SERVICE__c from List_Storage__c where List_Type__c='Industry' and Industry_Active__c=true and PRD_PCY_TYPE__c=:policy_type];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getLegalTypeList() {
        // try{
            return [select Id, LegalList_Code_Group__c, LegalList_Code__c, LegalList_Code_Value__c, LegalList_Code_Desc__c, LegalList_Active__c from List_Storage__c where List_Type__c='Legal Type' and LegalList_Active__c=true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getSchdule2CountryList(){
            List<List_Storage__c> map_cn = [select Id,CTRY_CTRY_CODE__c,CTRY_CTRY_NAME__c,CTRY_CTRY_NAME_HK__c, CTRY_GRADE__c, Special_Condition__c, Special_Condition_HK__c from List_Storage__c where List_Type__c='Schdule2' ];
            return map_cn;
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getClause70CountryList(){
            List<List_Storage__c> map_cn = [select Id,CTRY_CTRY_CODE__c,CTRY_CTRY_NAME__c,CTRY_CTRY_NAME_HK__c from List_Storage__c where List_Type__c='Clause70' ];
            return map_cn;
    }
    @AuraEnabled(cacheable=true)
    public static List<List_Storage__c> getOMBPClauseCountryList(){
            List<List_Storage__c> map_cn = [select Id,CTRY_CTRY_CODE__c,CTRY_CTRY_NAME__c,CTRY_CTRY_NAME_HK__c from List_Storage__c where List_Type__c='OMBPClause' ];
            return map_cn;
    }
}
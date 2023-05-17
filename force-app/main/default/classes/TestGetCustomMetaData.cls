@isTest
public with sharing class TestGetCustomMetaData {
   
    @IsTest
    static void commonTest(){
        GetCustomMetaData.getLegalType();
        GetCustomMetaData.getProduct();
        GetCustomMetaData.getIndustries();
        GetCustomMetaData.getCountryList();
        GetCustomMetaData.getDistrictTerritoryList();
        GetCustomMetaData.getKnowAboutEcicList();
        GetCustomMetaData.getOriginCountryList();
        GetCustomMetaData.getDestinationCountryList();
        GetCustomMetaData.getPortOfLoadingList('70');
        GetCustomMetaData.getBuyerCountryList();
        GetCustomMetaData.getIndustryList();
        GetCustomMetaData.getLegalTypeList();
        GetCustomMetaData.getBuyerCountryListByPolicy('70');
        GetCustomMetaData.getIndustryListByPolicy('70');
    }
}
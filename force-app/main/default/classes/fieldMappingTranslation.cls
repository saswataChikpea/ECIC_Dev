/*-----------------------------------------------
    Desc : class for field mappings and value translations
    created by : sayantan@chikpea.com
    created date : 28-Sep-2021
-------------------------------------------------*/
public with sharing class fieldMappingTranslation {

    //DEPRICATED: Functions based on metadata - 2021/12/09
    /* 
    public static List<Country__mdt> get_country_code_all(){
        // this is the updated method.
        // Country__mdt ccode = Country__mdt.getInstance(cname);
        List<Country__mdt> ccodeList = Country__mdt.getAll().values();
        System.debug('country code ====>'+ccodeList);
        return ccodeList;
    } 
    */
    public static List<List_Storage__c> get_country_code_all(){
        List<List_Storage__c> ccodeList = [SELECT Id, 
        ByrCtry_Country_Code__c, ByrCtry_Country_Name__c, OrgCtryList_Country_Code__c,
        OrgCtryList_Country_Name__c, DestCtryList_Country_Code__c, DestCtryList_Country_Name__c, 
        PortOfLdg_Country_Code__c, PortOfLdg_Country_Name__c, List_Type__c
        FROM List_Storage__c];
        System.debug('country code ====>'+ccodeList);
        return ccodeList;
    }

    public static String getCountryName(String countryCode) {
        List<List_Storage__c> ccList = fieldMappingTranslation.get_country_code_all();
        String buyerCountryName;
        for (List_Storage__c country : ccList){
            if(country.List_Type__c == 'Buyer Country' && country.ByrCtry_Country_Code__c.equalsIgnoreCase(countryCode)){
                buyerCountryName = country.ByrCtry_Country_Name__c;
                break;
            }
        }
        return buyerCountryName;
    }
    /*
    public static String get_country_code(String cname){
        // this is the updated method.
        String cname1;
        // Country__mdt ccode = Country__mdt.getInstance(cname);
        List<Country__mdt> ccodeList = Country__mdt.getAll().values();
        for (Country__mdt ccode : ccodeList){
            if(ccode.Full_Country_Name__c.equalsIgnoreCase(cname))
                cname1 = ccode.Country_Code__c;
        }
        System.debug('country code ====>'+cname1);
        return cname1;
    }
    public static List<Product__mdt> get_product_code_all(){
        List<Product__mdt> pcodeList = Product__mdt.getAll().values();
        System.debug('product code ====>'+pcodeList);
        return pcodeList;
    }
    public static String get_product_code(String pname){
        // this is the updated method.
        String pname1;
        // Country__mdt ccode = Country__mdt.getInstance(cname);
        List<Product__mdt> pcodeList = Product__mdt.getAll().values();
        for (Product__mdt pcode : pcodeList){
            if(pcode.PRD_DESC__c.equalsIgnoreCase(pname))
                pname1 = pcode.PRD_CODE__c;
        }
        System.debug('product code ====>'+pname1);
        return pname1;
    }
    */

    public static String get_product_code(String pname){
        String pname1;
        
       
        return pname1;
    }

    public static String convert_yes_no_code(String val){
        if (val != NULL && val.equalsIgnoreCase('yes')){
            return 'Y';
        }
        else if(val != NULL && val.equalsIgnoreCase('no')){
            return 'N';
        }
        else {
            return NULL;
        }
    }
    public static String convert_Mon_to_MM(String val){
        if(val.containsIgnoreCase('January'))
            return '01';
        if(val.containsIgnoreCase('February'))
            return '02';
        if(val.containsIgnoreCase('March'))
            return '03';
        if(val.containsIgnoreCase('April'))
            return '04';
        if(val.containsIgnoreCase('May'))
            return '05';
        if(val.containsIgnoreCase('June'))
            return '06';
        if(val.containsIgnoreCase('July'))
            return '07';
        if(val.containsIgnoreCase('August'))
            return '08';
        if(val.containsIgnoreCase('September'))
            return '09';
        if(val.containsIgnoreCase('October'))
            return '10';
        if(val.containsIgnoreCase('November'))
            return '11';
        if(val.containsIgnoreCase('December'))
            return '12';
        return NULL;
    }
    public static String convert_Year_to_YYYY(Decimal yr){
        return String.valueOf(yr);
    }
    public static String date_format(Date datevalue){
        String dateStr; 
        if(datevalue != NULL){
            dateStr= String.valueOf(datevalue.year()) + '-' + String.valueOf(datevalue.month()) + 
                '-' + String.valueOf(datevalue.day());
        }
        else {
            dateStr= String.valueOf(Date.today().year()) + '-' + String.valueOf(Date.today().month()) + 
                '-' + String.valueOf(Date.today().day());
        }
        System.debug('date_format to string ====>'+dateStr);
        return dateStr;
    }
    public static String date_format(DateTime datetimevalue){
        String dateStr;
        if(datetimevalue != NULL) {
            dateStr = String.valueOf(datetimevalue.year()) + '-' + String.valueOf(datetimevalue.month()) + 
                '-' + String.valueOf(datetimevalue.day());
        }
        else{
            dateStr = String.valueOf(DateTime.now().year()) + '-' + String.valueOf(DateTime.now().month()) + 
                '-' + String.valueOf(DateTime.now().day());
        }
        System.debug('date_format to string ====>'+dateStr);
        return dateStr;
    }
    public static Date string_to_date_format(String datestr){
        // String dateStr;
        Date dt1;
        if(datestr != NULL && datestr != ''){
            List<String> dateComponentsList = datestr.split('-');
            Integer year = Integer.valueOf(dateComponentsList[0]);
            Integer month = Integer.valueOf(dateComponentsList[1]);
            Integer day = Integer.valueOf(dateComponentsList[2]);
            dt1 = Date.newInstance(year, month, day);
            return dt1;
        }
        return dt1;
    }
    // YYYY-MM-DD HH:MM:SS
    public static DateTime string_to_datetime_format(String datestr){
        // String dateStr;
        DateTime dt1;
        if(datestr != NULL && datestr != ''){
            List<String> datetimeComponentsList = datestr.split(' ');
            List<String> dateComponentsList = datetimeComponentsList[0].split('-');
            List<String> timeComponentList = datetimeComponentsList[1].split(':');
            Integer year = Integer.valueOf(dateComponentsList[0]);
            Integer month = Integer.valueOf(dateComponentsList[1]);
            Integer day = Integer.valueOf(dateComponentsList[2]);
            Integer hour = Integer.valueOf(timeComponentList[0]);
            Integer minute = Integer.valueOf(timeComponentList[1]);
            Integer second = Integer.valueOf(timeComponentList[2]);
            // newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second)
            dt1 = DateTime.newInstance(year, month, day, hour, minute, second);
            return dt1;
        }
        return dt1;
    }
    public static String boolean_to_String(Boolean val){
        if(val)
            return 'Y';
        else {
            return 'N';
        }
    }
    public static Boolean string_to_boolean(String val){
        if(val== 'Y')
            return true;
        else {
            return false;
        }
    }

    public static String buildQueryAllString(List<Schema.DescribeFieldResult> queryFields,DescribeSObjectResult obj, String theId)
    {
        String query = 'select ';
        for(Schema.DescribeFieldResult dfr : queryFields)
        {
            query = query + dfr.getName() + ',';
        }
        query = query.subString(0,query.length() - 1);
        query = query + ' from ';
        query = query + obj.getName();
        query = query + ' where Id = \'';
        query = query + theId + '\'';
        system.debug('Build Query == ' + query);
        return query;
    }
    public static String get_all_fields_query(String objectID){
        Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        List<Schema.SObjectType> sobjects = schemaMap.values();
        List<Schema.DescribeFieldResult> fields = new List<Schema.DescribeFieldResult> ();
        List<Sobject> theObjectResults;
        Schema.DescribeSObjectResult objDescribe;
        List<Schema.SObjectField> tempFields;
        String getAllQuery;
        for(Schema.SObjectType objType : sobjects)
        {
            objDescribe = objType.getDescribe();
            String sobjectPrefix = objDescribe.getKeyPrefix();
            System.debug('sobjectPrefix=>'+sobjectPrefix+' objectID=>'+objectID);
            if(objectID != null && sobjectPrefix != null && objectID.startsWith(sobjectPrefix))
            {
                String objectType = objDescribe.getLocalName();
                Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                tempFields = fieldMap.values();
                for(Schema.SObjectField sof : tempFields)
                {
                    fields.add(sof.getDescribe());
                }
                getAllQuery = fieldMappingTranslation.buildQueryAllString(fields,objDescribe,objectID);
                break;
            }
        }
        return getAllQuery;
    }
    public static List<String> get_all_fields_from_ID (ID objectID){
        String objectAPIName = objectID.getSobjectType().getDescribe().getName();
        List<String> fieldList = new List<String> ();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectAPIName);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        fieldList.addAll(MapofField.keyset());
        return fieldList;
    }
    public static List<String> get_all_fields_from_APIName (String objectAPIName){
        // String objectAPIName = objectID.getSobjectType().getDescribe().getName();
        List<String> fieldList = new List<String> ();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectAPIName);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        fieldList.addAll(MapofField.keyset());
        return fieldList;
    }

    public static String cl_status_to_code(String status){
        // System.debug('status ===>'+status);
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('CLA Cancelled'))
                return 'CLA_CAN';
            if(status.equalsIgnoreCase('CLA inputted'))
                return 'CLA_NEW';
            if(status.equalsIgnoreCase('CLA passed to underwriting'))
                return 'CLA_UW';
            if(status.equalsIgnoreCase('CL Indication - cancelled'))
                return 'CLI_CAN';
            if(status.equalsIgnoreCase('CL Indication - approved'))
                return 'CLI_NEW';
            if(status.equalsIgnoreCase('CL Indication - not approved'))
                return 'NAP_CLI';
            if(status.equalsIgnoreCase('CL Indication - recommendation for approval'))
                return 'RCM_CLI';
            if(status.equalsIgnoreCase('CL - cancelled'))
                return 'CL_CAN';
            if(status.equalsIgnoreCase('CL - approved'))
                return 'CL_NEW';
            if(status.equalsIgnoreCase('CL - not approved'))
                return 'NAP_CL';
            if(status.equalsIgnoreCase('CL - recommendation for approval'))
                return 'CL_NEWRCM_CL';
        }
        return status;
    }
    public static String cl_code_to_status(String status){
        // System.debug('status ===>'+status);
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('CLA_CAN'))
                return 'CLA Cancelled';
            if(status.equalsIgnoreCase('CLA_NEW'))
                return 'CLA inputted';
            if(status.equalsIgnoreCase('CLA_UW'))
                return 'CLA passed to underwriting';
            if(status.equalsIgnoreCase('CLI_CAN'))
                return 'CL Indication - cancelled';
            if(status.equalsIgnoreCase('CLI_NEW'))
                return 'CL Indication - approved';
            if(status.equalsIgnoreCase('NAP_CLI'))
                return 'CL Indication - not approved';
            if(status.equalsIgnoreCase('RCM_CLI'))
                return 'CL Indication - recommendation for approval';
            if(status.equalsIgnoreCase('CL_CAN'))
                return 'CL - cancelled';
            if(status.equalsIgnoreCase('CL_NEW'))
                return 'CL - approved';
            if(status.equalsIgnoreCase('NAP_CL'))
                return 'CL - not approved';
            if(status.equalsIgnoreCase('CL_NEWRCM_CL'))
                return 'CL - recommendation for approval';
        }
        return status;
    }
    public static String cl_submission_type_to_code(String submtype){
        if (submtype != NULL && submtype != ''){
            if(submtype.equalsIgnoreCase('new')){
                return 'N';
            }
            if(submtype.equalsIgnoreCase('uplift')){
                return 'U';
            }
            if(submtype.equalsIgnoreCase('renew')){
                return 'R';
            }
        }
        return NULL;
    }
    public static String cl_submission_code_to_type(String submtype){
        if (submtype != NULL && submtype != ''){
            if(submtype.equalsIgnoreCase('N')){
                return 'new';
            }
            if(submtype.equalsIgnoreCase('U')){
                return 'uplift';
            }
            if(submtype.equalsIgnoreCase('R')){
                return 'renew';
            }
        }
        return NULL;
    }
    public static String cl_appli_type_to_code(String applicationtype){
        if (applicationtype != NULL && applicationtype != ''){
            if(applicationtype.equalsIgnoreCase('Export of service')){
                return 'SVC';
            }
            if(applicationtype.equalsIgnoreCase('Pre/Post-shipment')){
                return 'PREPOST';
            }
            if(applicationtype.equalsIgnoreCase('Export of goods')){
                return 'GD';
            }
        }
        return NULL;
    }
    public static String cl_appli_code_to_type(String applicationtype){
        if (applicationtype != NULL && applicationtype != ''){
            if(applicationtype.equalsIgnoreCase('SVC')){
                return 'Export of service';
            }
            if(applicationtype.equalsIgnoreCase('PREPOST')){
                return 'Pre/Post-shipment';
            }
            if(applicationtype.equalsIgnoreCase('GD')){
                return 'Export of goods';
            }
        }
        return NULL;
    }
    public static String cl_api_resp_code_to_status(String respsts){
        if (respsts != NULL && respsts != ''){
            if(respsts.equalsIgnoreCase('S')){
                return 'Success';
            }
            if(respsts.equalsIgnoreCase('P')){
                return 'Pending for underwriter to proceed';
            }
        }
        return NULL;
    }
    public static String cl_case_sts_to_code(String casests){
        if (casests != NULL && casests != ''){
            if(casests.equalsIgnoreCase('Processing')){
                return 'OS';
            }
            if(casests.equalsIgnoreCase('Accepted')){
                return 'AC';
            }
            if(casests.equalsIgnoreCase('Rejected')){
                return 'RJ';
            }
            if(casests.equalsIgnoreCase('Cancelled')){
                return 'CN';
            }
        }
        return NULL;
    }
    public static String cl_case_code_to_sts(String casests){
        if (casests != NULL && casests != ''){
            if(casests.equalsIgnoreCase('OS')){
                return 'Processing';
            }
            if(casests.equalsIgnoreCase('AC')){
                return 'Accepted';
            }
            if(casests.equalsIgnoreCase('RJ')){
                return 'Rejected';
            }
            if(casests.equalsIgnoreCase('CN')){
                return 'Cancelled';
            }
        }
        return NULL;
    }
    public static String plcy_type_to_code(String policyName){
        if (policyName != NULL && policyName != ''){
            if(policyName.containsIgnoreCase('SBP')){
                return '51';
            }
            if(policyName.containsIgnoreCase('SUP')){
                return '56';
            }
            if(policyName.containsIgnoreCase('OMBP')){
                return '70';
            }
        }
        return NULL;
    }
    public static String plcy_code_to_type(String policyCode){
        if (policyCode != NULL && policyCode != ''){
            if(policyCode.equalsIgnoreCase('51')){
                return 'SBP';
            }
            if(policyCode.equalsIgnoreCase('56')){
                return 'SUP';
            }
            if(policyCode.equalsIgnoreCase('70')){
                return 'OMBP';
            }
        }
        return NULL;
    }

    public static String plcy_status_to_code(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('Void'))
                return 'V';
            if(status.equalsIgnoreCase('Current policy record'))
                return 'C';
            if(status.equalsIgnoreCase('Processing renewal or quotation'))
                return 'W';
            if(status.equalsIgnoreCase('Accepted and waiting to commerce'))
                return 'N';
            if(status.equalsIgnoreCase('Expired policy record'))
                return 'E';
            if(status.equalsIgnoreCase('Previous policy record'))
                return 'P';
        }
        return NULL;
    }
    public static String plcy_code_to_status(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('V'))
                return 'Void';
            if(status.equalsIgnoreCase('C'))
                return 'Current policy record';
            if(status.equalsIgnoreCase('W'))
                return 'Processing renewal or quotation';
            if(status.equalsIgnoreCase('N'))
                return 'Accepted and waiting to commerce';
            if(status.equalsIgnoreCase('E'))
                return 'Expired policy record';
            if(status.equalsIgnoreCase('P'))
                return 'Previous policy record';
        }
        return NULL;
    }
    public static String plcy_req_type_to_char(String req_type){
        if(req_type != NULL && req_type != ''){
            if (req_type.equalsIgnoreCase('New policy')){
                return 'N';
            }
            if(req_type.equalsIgnoreCase('Renewal policy')){
                return 'R';
            }
        }
        return NULL;
    }
    public static String plcy_req_char_to_type(String req_type){
        if(req_type != NULL && req_type != ''){
            if (req_type.equalsIgnoreCase('N')){
                return 'New policy';
            }
            if(req_type.equalsIgnoreCase('R')){
                return 'Renewal policy';
            }
        }
        return NULL;
    }

    public static String rm_status_to_code(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('New'))
                return 'NEW';
            if(status.equalsIgnoreCase('Outstanding'))
                return 'OS';
            if(status.equalsIgnoreCase('Observation'))
                return 'OBS';
            if(status.equalsIgnoreCase('In Progress'))
                return 'IP';
            if(status.equalsIgnoreCase('Recommending'))
                return 'RCM';
            if(status.equalsIgnoreCase('Request Accepted'))
                return 'APAC';
            if(status.equalsIgnoreCase('Request Rejected'))
                return 'APRJ';
            if(status.equalsIgnoreCase('Completed'))
                return 'CO';
                if(status.equalsIgnoreCase('Rejected'))
                return 'CORJ';
            if(status.equalsIgnoreCase('Settled'))
                return 'COSTL';
                if(status.equalsIgnoreCase('Closed'))
                return 'COCO';
            if(status.equalsIgnoreCase('Voided'))
                return 'VO';
        }
        return NULL;
    }
    public static String rm_code_to_status(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('NEW'))
                return 'New';
            if(status.equalsIgnoreCase('OS'))
                return 'Outstanding';
            if(status.equalsIgnoreCase('OBS'))
                return 'Observation';
            if(status.equalsIgnoreCase('IP'))
                return 'In Progress';
            if(status.equalsIgnoreCase('RCM'))
                return 'Recommending';
            if(status.equalsIgnoreCase('APAC'))
                return 'Request Accepted';
            if(status.equalsIgnoreCase('APRJ'))
                return 'Request Rejected';
            if(status.equalsIgnoreCase('CO'))
                return 'Completed';
                if(status.equalsIgnoreCase('CORJ'))
                return 'Rejected';
            if(status.equalsIgnoreCase('COSTL'))
                return 'Settled';
                if(status.equalsIgnoreCase('COCO'))
                return 'Closed';
            if(status.equalsIgnoreCase('VO'))
                return 'Voided';
        }
        return NULL;
    }
    public static String pd_status_to_code(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('Outstanding'))
                return 'OS';
            if(status.equalsIgnoreCase('In Progress'))
                return 'IP';
            if(status.equalsIgnoreCase('Cases with disputes'))
                return 'D';
            if(status.equalsIgnoreCase('CP about to be made'))
                return 'CP';
            if(status.equalsIgnoreCase('Cases with repayment plan'))
                return 'R';
            if(status.equalsIgnoreCase('Cases pending documents (No doc.)'))
                return 'PD';
            if(status.equalsIgnoreCase('Cases pending PH\'s taking of loss minimization actions'))
                return 'ML';
            if(status.equalsIgnoreCase('Cases under examination, awaiting documents / clarifications from PH'))
                return 'UE';
            if(status.equalsIgnoreCase('Date of loss not lapsed'))
                return 'DOL';
            if(status.equalsIgnoreCase('Outstanding approval case'))
                return 'OA';
            if(status.equalsIgnoreCase('CP approved'))
                return 'AP';
            if(status.equalsIgnoreCase('PD Closed - Resolved'))
                return 'CORS';
            if(status.equalsIgnoreCase('PD Closed - Rejected'))
                return 'CORJ';
            if(status.equalsIgnoreCase('PD Closed - Written-off'))
                return 'COWO';
            if(status.equalsIgnoreCase('PD Closed'))
                return 'COCO';
        }
        return NULL;
    }
    public static String pd_code_to_status(String status){
        if(status != NULL && status != ''){
            if(status.equalsIgnoreCase('OS'))
                return 'Outstanding';
            if(status.equalsIgnoreCase('IP'))
                return 'In Progress';
            if(status.equalsIgnoreCase('D'))
                return 'Cases with disputes';
            if(status.equalsIgnoreCase('CP'))
                return 'CP about to be made';
            if(status.equalsIgnoreCase('R'))
                return 'Cases with repayment plan';
            if(status.equalsIgnoreCase('PD'))
                return 'Cases pending documents (No doc.)';
            if(status.equalsIgnoreCase('ML'))
                return 'Cases pending PH\'s taking of loss minimization actions';
            if(status.equalsIgnoreCase('UE'))
                return 'Cases under examination, awaiting documents / clarifications from PH';
            if(status.equalsIgnoreCase('DOL'))
                return 'Date of loss not lapsed';
            if(status.equalsIgnoreCase('OA'))
                return 'Outstanding approval case';
            if(status.equalsIgnoreCase('AP'))
                return 'CP approved';
            if(status.equalsIgnoreCase('CORS'))
                return 'PD Closed - Resolved';
            if(status.equalsIgnoreCase('CORJ'))
                return 'PD Closed - Rejected';
            if(status.equalsIgnoreCase('COWO'))
                return 'PD Closed - Written-off';
            if(status.equalsIgnoreCase('COCO'))
                return 'PD Closed';
        }
        return NULL;
    }

    public static String prpos_status_to_char(String status){
        if(status != NULL && status != ''){
            if (status.equalsIgnoreCase('O/S Proposal')){
                return 'O';
            }
            if(status.equalsIgnoreCase('Quotation')){
                return 'Q';
            }
            if (status.equalsIgnoreCase('Rejected')){
                return 'R';
            }
            if(status.equalsIgnoreCase('Void')){
                return 'V';
            }
        }
        return NULL;
    }
    public static String prpos_char_to_status(String status){
        if(status != NULL && status != ''){
            if (status.equalsIgnoreCase('O')){
                return 'O/S Proposal';
            }
            if(status.equalsIgnoreCase('Q')){
                return 'Quotation';
            }
            if (status.equalsIgnoreCase('R')){
                return 'Rejected';
            }
            if(status.equalsIgnoreCase('V')){
                return 'Void';
            }
        }
        return NULL;
    }
    
    public static String export_type_to_code(String status){
        if(status != NULL && status != ''){
            if (status.equalsIgnoreCase('Export of Goods (Post-shipment risk only)')){
                return 'GD';
            }
            if(status.equalsIgnoreCase('Export of Goods (Pre-shipment and post-shipment risk)')){
                return 'PREPOST';
            }
            if (status.equalsIgnoreCase('Export of Services')){
                return 'SVC';
            }
            if(status.equalsIgnoreCase('Export of Goods')){
                return 'GD';
            }
        }
        return NULL;
    }
}
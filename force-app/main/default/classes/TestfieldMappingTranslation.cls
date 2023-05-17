@isTest
public with sharing class TestfieldMappingTranslation {
    
    @IsTest
    static void convert_yes_no_code(){
        
        String result1 = fieldMappingTranslation.convert_yes_no_code('yes');
        System.assertEquals('Y', result1);
        String result2 = fieldMappingTranslation.convert_yes_no_code('No');
        System.assertEquals('N', result2);
        String result3 = fieldMappingTranslation.convert_yes_no_code('other');
        System.assertEquals(NULL, result3);
        
    }

    @IsTest
    static void includeAllMethod(){
        List<List_Storage__c> storageList=fieldMappingTranslation.get_country_code_all();
        System.assertEquals(storageList.isEmpty(), storageList.isEmpty());
        fieldMappingTranslation.convert_Year_to_YYYY(2022);
        fieldMappingTranslation.date_format(Date.today());
        fieldMappingTranslation.date_format(Datetime.now());
        fieldMappingTranslation.string_to_date_format('2022-12-12');
        fieldMappingTranslation.string_to_datetime_format('2021-12-10 05:52:34');
        fieldMappingTranslation.boolean_to_String(true);
        fieldMappingTranslation.boolean_to_String(false);
        fieldMappingTranslation.string_to_boolean('Y');
        fieldMappingTranslation.string_to_boolean('N');


        fieldMappingTranslation.convert_Mon_to_MM('January');
        fieldMappingTranslation.convert_Mon_to_MM('February');
        fieldMappingTranslation.convert_Mon_to_MM('March');
        fieldMappingTranslation.convert_Mon_to_MM('April');
        fieldMappingTranslation.convert_Mon_to_MM('May');
        fieldMappingTranslation.convert_Mon_to_MM('June');
        fieldMappingTranslation.convert_Mon_to_MM('July');
        fieldMappingTranslation.convert_Mon_to_MM('August');
        fieldMappingTranslation.convert_Mon_to_MM('September');
        fieldMappingTranslation.convert_Mon_to_MM('October');
        fieldMappingTranslation.convert_Mon_to_MM('November');

       
        String month = fieldMappingTranslation.convert_Mon_to_MM('December');
        System.assertEquals('12', month);
        Account acc = TestDataFactory.createAccount();
        fieldMappingTranslation.get_all_fields_query(acc.id);
        fieldMappingTranslation.get_all_fields_from_ID(acc.id);
        //fieldMappingTranslation.get_all_fields_from_APIName('Activity');
        fieldMappingTranslation.cl_status_to_code('CLA Cancelled');
        fieldMappingTranslation.cl_status_to_code('CLA inputted');
        fieldMappingTranslation.cl_status_to_code('CLA passed to underwriting');
        fieldMappingTranslation.cl_status_to_code('CL Indication - cancelled');
        fieldMappingTranslation.cl_status_to_code('CL Indication - approved');
        fieldMappingTranslation.cl_status_to_code('CL Indication - not approved');
        fieldMappingTranslation.cl_status_to_code('CL Indication - recommendation for approval');
        fieldMappingTranslation.cl_status_to_code('CL - cancelled');
        fieldMappingTranslation.cl_status_to_code('CL - approved');
        fieldMappingTranslation.cl_status_to_code('CL - not approved');
        fieldMappingTranslation.cl_status_to_code('CL - recommendation for approval');
        fieldMappingTranslation.cl_code_to_status('CLA_CAN');
        fieldMappingTranslation.cl_code_to_status('CLA_NEW');
        fieldMappingTranslation.cl_code_to_status('CLA_UW');
        fieldMappingTranslation.cl_code_to_status('CLI_CAN');
        fieldMappingTranslation.cl_code_to_status('CLI_NEW');
        fieldMappingTranslation.cl_code_to_status('NAP_CLI');
        fieldMappingTranslation.cl_code_to_status('RCM_CLI');
        fieldMappingTranslation.cl_code_to_status('CL_CAN');
        fieldMappingTranslation.cl_code_to_status('CL_NEW');
        fieldMappingTranslation.cl_code_to_status('NAP_CL');
        fieldMappingTranslation.cl_code_to_status('CL_NEWRCM_CL');

        fieldMappingTranslation.cl_submission_type_to_code('new');
        fieldMappingTranslation.cl_submission_type_to_code('uplift');
        fieldMappingTranslation.cl_submission_type_to_code('renew');
        fieldMappingTranslation.cl_submission_code_to_type('N');
        fieldMappingTranslation.cl_submission_code_to_type('U');
        fieldMappingTranslation.cl_submission_code_to_type('R');
        fieldMappingTranslation.cl_appli_type_to_code('Export of service');
        fieldMappingTranslation.cl_appli_type_to_code('Pre/Post-shipment');
        fieldMappingTranslation.cl_appli_type_to_code('Export of goods');
        fieldMappingTranslation.cl_appli_code_to_type('SVC');
        fieldMappingTranslation.cl_appli_code_to_type('PREPOST');
        fieldMappingTranslation.cl_appli_code_to_type('GD');
        fieldMappingTranslation.cl_api_resp_code_to_status('S');
        fieldMappingTranslation.cl_api_resp_code_to_status('P');

        fieldMappingTranslation.cl_case_sts_to_code('Processing');
        fieldMappingTranslation.cl_case_sts_to_code('Accepted');
        fieldMappingTranslation.cl_case_sts_to_code('Rejected');
        fieldMappingTranslation.cl_case_sts_to_code('Cancelled');
        fieldMappingTranslation.cl_case_code_to_sts('OS');
        fieldMappingTranslation.cl_case_code_to_sts('AC');
        fieldMappingTranslation.cl_case_code_to_sts('RJ');
        fieldMappingTranslation.cl_case_code_to_sts('CN');
        fieldMappingTranslation.plcy_type_to_code('SBP');
        fieldMappingTranslation.plcy_type_to_code('OMBP');
        fieldMappingTranslation.plcy_type_to_code('SUP');
        fieldMappingTranslation.plcy_code_to_type('51');
        fieldMappingTranslation.plcy_code_to_type('56');
        fieldMappingTranslation.plcy_code_to_type('70');
        fieldMappingTranslation.plcy_status_to_code('Void');
        fieldMappingTranslation.plcy_status_to_code('Current policy record');
        fieldMappingTranslation.plcy_status_to_code('Processing renewal or quotation');
        fieldMappingTranslation.plcy_status_to_code('Accepted and waiting to commerce');
        fieldMappingTranslation.plcy_status_to_code('Expired policy record');
        fieldMappingTranslation.plcy_status_to_code('Previous policy record');
        fieldMappingTranslation.plcy_code_to_status('V');
        fieldMappingTranslation.plcy_code_to_status('C');
        fieldMappingTranslation.plcy_code_to_status('W');
        fieldMappingTranslation.plcy_code_to_status('N');
        fieldMappingTranslation.plcy_code_to_status('E');
        fieldMappingTranslation.plcy_code_to_status('P');
        fieldMappingTranslation.plcy_req_type_to_char('New policy');
        fieldMappingTranslation.plcy_req_type_to_char('Renewal policy');
        fieldMappingTranslation.plcy_req_char_to_type('N');
        fieldMappingTranslation.plcy_req_char_to_type('R');
        fieldMappingTranslation.rm_status_to_code('New');
        fieldMappingTranslation.rm_status_to_code('Outstanding');
        fieldMappingTranslation.rm_status_to_code('Observation');
        fieldMappingTranslation.rm_status_to_code('In Progress');
        fieldMappingTranslation.rm_status_to_code('Recommending');
        fieldMappingTranslation.rm_status_to_code('Request Accepted');
        fieldMappingTranslation.rm_status_to_code('Request Rejected');
        fieldMappingTranslation.rm_status_to_code('Completed');
        fieldMappingTranslation.rm_status_to_code('Rejected');
        fieldMappingTranslation.rm_status_to_code('Settled');
        fieldMappingTranslation.rm_status_to_code('Closed');
        fieldMappingTranslation.rm_status_to_code('Voided');
        fieldMappingTranslation.rm_code_to_status('NEW');
        fieldMappingTranslation.rm_code_to_status('OS');
        fieldMappingTranslation.rm_code_to_status('OBS');
        fieldMappingTranslation.rm_code_to_status('IP');
        fieldMappingTranslation.rm_code_to_status('RCM');
        fieldMappingTranslation.rm_code_to_status('APAC');
        fieldMappingTranslation.rm_code_to_status('APRJ');
        fieldMappingTranslation.rm_code_to_status('CO');
        fieldMappingTranslation.rm_code_to_status('CORJ');
        fieldMappingTranslation.rm_code_to_status('COSTL');
        fieldMappingTranslation.rm_code_to_status('COCO');
        fieldMappingTranslation.rm_code_to_status('VO');
        fieldMappingTranslation.pd_status_to_code('Outstanding');
        fieldMappingTranslation.pd_status_to_code('In Progress');
        fieldMappingTranslation.pd_status_to_code('Cases with disputes');
        fieldMappingTranslation.pd_status_to_code('CP about to be made');
        fieldMappingTranslation.pd_status_to_code('Cases with repayment plan');
        fieldMappingTranslation.pd_status_to_code('Cases pending documents (No doc.)');
        fieldMappingTranslation.pd_status_to_code('Cases pending PH\'s taking of loss minimization actions');
        fieldMappingTranslation.pd_status_to_code('Cases under examination, awaiting documents / clarifications from PH');
        fieldMappingTranslation.pd_status_to_code('Date of loss not lapsed');
        fieldMappingTranslation.pd_status_to_code('Outstanding approval case');
        fieldMappingTranslation.pd_status_to_code('CP approved');
        fieldMappingTranslation.pd_status_to_code('PD Closed - Resolved');
        fieldMappingTranslation.pd_status_to_code('PD Closed - Rejected');
        fieldMappingTranslation.pd_status_to_code('PD Closed - Written-off');
        fieldMappingTranslation.pd_status_to_code('PD Closed');
        fieldMappingTranslation.pd_code_to_status('OS');
        fieldMappingTranslation.pd_code_to_status('IP');
        fieldMappingTranslation.pd_code_to_status('D');
        fieldMappingTranslation.pd_code_to_status('CP');
        fieldMappingTranslation.pd_code_to_status('R');
        fieldMappingTranslation.pd_code_to_status('PD');
        fieldMappingTranslation.pd_code_to_status('ML');
        fieldMappingTranslation.pd_code_to_status('UE');
        fieldMappingTranslation.pd_code_to_status('DOL');
        fieldMappingTranslation.pd_code_to_status('OA');
        fieldMappingTranslation.pd_code_to_status('AP');
        fieldMappingTranslation.pd_code_to_status('CORS');
        fieldMappingTranslation.pd_code_to_status('CORJ');
        fieldMappingTranslation.pd_code_to_status('COWO');
        fieldMappingTranslation.pd_code_to_status('COCO');
        fieldMappingTranslation.prpos_status_to_char('O/S Proposal');
        fieldMappingTranslation.prpos_status_to_char('Quotation');
        fieldMappingTranslation.prpos_status_to_char('Rejected');
        fieldMappingTranslation.prpos_status_to_char('Void');
        fieldMappingTranslation.prpos_char_to_status('O');
        fieldMappingTranslation.prpos_char_to_status('Q');
        fieldMappingTranslation.prpos_char_to_status('R');
        fieldMappingTranslation.prpos_char_to_status('V');
        fieldMappingTranslation.export_type_to_code('Export of Goods (Post-shipment risk only)');
        fieldMappingTranslation.export_type_to_code('Export of Goods (Pre-shipment and post-shipment risk)');
        fieldMappingTranslation.export_type_to_code('Export of Services');
        String res=fieldMappingTranslation.export_type_to_code('Export of Goods');
        System.assertEquals('GD', res);



    }

   

}
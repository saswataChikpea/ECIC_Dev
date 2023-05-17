/* eslint-disable  no-console */
import { api, LightningElement, track } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ID_FIELD from '@salesforce/schema/Policy__c.Id';
import USED_CL_FIELD from '@salesforce/schema/Policy__c.Used_Credit_check__c';
import CL_ID_FIELD from '@salesforce/schema/Credit_Limit__c.Id';
import IS_UPLIFTED_FIELD from '@salesforce/schema/Credit_Limit__c.Is_Uplifted__c';
import CLA_ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import CLA_REF_NO from '@salesforce/schema/Credit_Limit_Application__c.Legacy_Ref_No__c';
import CLA_PRE_REF_NO from '@salesforce/schema/Credit_Limit_Application__c.Legacy_Pre_Ref_No__c';
import createOutstandingPaymentBuyer from '@salesforce/apex/CLApplicationRecord.createOutstandingPaymentBuyer';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';
import getProductDetails from '@salesforce/apex/CLProductDetails.getProductDetails';
import createSBPInvoice from '@salesforce/apex/CLInvoice.createSBPInvoice';
import updatePolicyCCFAura from '@salesforce/apex/ECIC_API_PolicyMgmt.updatePolicyCCFAura';
import createCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.createCLApplicationAura';
import createSubsidiaryRelatedCL from '@salesforce/apex/CLEndorsement.createSubsidiaryRelatedCL';

import Cancel_Credit_Limit_Application from '@salesforce/label/c.Cancel_Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Policyholder from '@salesforce/label/c.Policyholder';
import Export_of_Goods_Export_of_Services from '@salesforce/label/c.Export_of_Goods_Export_of_Services';
import Are_you_holding_a_valid_credit_limit_on_the from '@salesforce/label/c.Are_you_holding_a_valid_credit_limit_on_the';
import buyer_small from '@salesforce/label/c.buyer_small';
import Buyer from '@salesforce/label/c.Buyer';
import Client from '@salesforce/label/c.Client';
import client_small from '@salesforce/label/c.client_small';
import Country_Market from '@salesforce/label/c.Country_Market';
import Will_the_goods_to_be_sold_to_the_Hong_Kong_exporter_be_exported from '@salesforce/label/c.Will_the_goods_to_be_sold_to_the_Hong_Kong_exporter_be_exported';
import Destination_Country_Market from '@salesforce/label/c.Destination_Country_Market';
import Will_the_service_be_ultabately_rendered_to_an_overseas_client from '@salesforce/label/c.Will_the_service_be_ultabately_rendered_to_an_overseas_client';
import Name from '@salesforce/label/c.Name';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Goods_Involved from '@salesforce/label/c.Goods_Involved';
import Services_Involved from '@salesforce/label/c.Services_Involved';
import Application_Amount_for_pre_shipment_HKD from '@salesforce/label/c.Application_Amount_for_pre_shipment_HKD';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Days from '@salesforce/label/c.Days';
import Application_Amount_for_post_shipment_HKD from '@salesforce/label/c.Application_Amount_for_post_shipment_HKD';
import Application_Amount_HKD from '@salesforce/label/c.Application_Amount_HKD';
import Is_this_your_new_buyer from '@salesforce/label/c.Is_this_your_new_buyer';
import How_many_years_have_you_been_trading_with_this from '@salesforce/label/c.How_many_years_have_you_been_trading_with_this';
import Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this';
import Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this';
import Has_the from '@salesforce/label/c.Has_the';
import previously_cancelled_from_the_order_unilaterally from '@salesforce/label/c.previously_cancelled_from_the_order_unilaterally';
import Any_payment_currently_overdue_from_this from '@salesforce/label/c.Any_payment_currently_overdue_from_this';
import ILC_or_payment_in_advance_transactions from '@salesforce/label/c.ILC_or_payment_in_advance_transactions';
import Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for from '@salesforce/label/c.Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for';
import in_the_last_12_months_HKD from '@salesforce/label/c.in_the_last_12_months_HKD';
import Is_there_any_amount_currently_unpaid_for_more_than from '@salesforce/label/c.Is_there_any_amount_currently_unpaid_for_more_than';
import days_from_the_due_date_for_this from '@salesforce/label/c.days_from_the_due_date_for_this';
import Unpaid_Shipment_Details from '@salesforce/label/c.Unpaid_Shipment_Details';
import Shipment_Invoice_date from '@salesforce/label/c.Shipment_Invoice_date';
import Gross_Invoice_Value_Currency from '@salesforce/label/c.Gross_Invoice_Value_Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Due_Date from '@salesforce/label/c.Due_Date';
import Remark from '@salesforce/label/c.Remark';
import Do_you_have_any_orders_confirmed_negotiation_with_this from '@salesforce/label/c.Do_you_have_any_orders_confirmed_negotiation_with_this';
import Please_provide_the_amount_and_payment_terms_of_the_orders from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_orders';
import When_will_the_shipments_commence from '@salesforce/label/c.When_will_the_shipments_commence';
import Remarks from '@salesforce/label/c.Remarks';
import What_is_the_amount_of_ILC_payment_in_advance_received_in_respect_of_the_orders from '@salesforce/label/c.What_is_the_amount_of_ILC_payment_in_advance_received_in_respect_of_the_orders';
import We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our from '@salesforce/label/c.We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our';
import Back from '@salesforce/label/c.Back';
import Cancel from '@salesforce/label/c.Cancel';
import Submit from '@salesforce/label/c.Submit';
import Save_and_Exit from '@salesforce/label/c.Save_and_Exit';



export default class ClApplicationConfirmationSBP extends LightningElement {
    @track label ={
        Cancel_Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,Policyholder,Export_of_Goods_Export_of_Services,
        Are_you_holding_a_valid_credit_limit_on_the,buyer_small,Buyer,Client,client_small,Country_Market,Will_the_goods_to_be_sold_to_the_Hong_Kong_exporter_be_exported,
        Destination_Country_Market,Will_the_service_be_ultabately_rendered_to_an_overseas_client,Name,Address,Registration_Number_If_any,Goods_Involved,
        Services_Involved,Application_Amount_for_pre_shipment_HKD,Payment_Terms,Days,Application_Amount_for_post_shipment_HKD,Application_Amount_HKD,
        Is_this_your_new_buyer,How_many_years_have_you_been_trading_with_this,Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this,
        Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this,Has_the,previously_cancelled_from_the_order_unilaterally,Any_payment_currently_overdue_from_this,
        ILC_or_payment_in_advance_transactions,Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for,in_the_last_12_months_HKD,
        Is_there_any_amount_currently_unpaid_for_more_than,days_from_the_due_date_for_this,Unpaid_Shipment_Details,Shipment_Invoice_date,Gross_Invoice_Value_Currency,
        Gross_Invoice_Value_Amount,Due_Date,Remark,Do_you_have_any_orders_confirmed_negotiation_with_this,Please_provide_the_amount_and_payment_terms_of_the_orders,
        When_will_the_shipments_commence,Remarks,What_is_the_amount_of_ILC_payment_in_advance_received_in_respect_of_the_orders,Back,Cancel,
        We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our,Submit,Save_and_Exit


    }
    @track showCheckFacilityModal = false;
    @api clconfirmationdata;
    @api clconfirmationapidata;
    @api policydetail;
    @track loading = false;
    @track user_type = this.label.Buyer;
    @track user_type_small = this.label.buyer_small;
    @track isRendered = false;
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: 'Section A (Buyer Information)' };
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: true, label: 'Section B (Trading Experience)' };
    @track section3 = { Id: 3, iconName: 'utility:down', isSectionOpen: true, label: 'Section C (Order Information)' };
    @track flag_unpaid_shipment = false;
    @track first_declaration = false;
    @track second_declaration = false;
    @track disable_submit = true;
    @track new_cla_id = '';
    @track is_preshipment = false;
    @track is_new_buyer = false;
    @track is_service = false;
    @track is_hkg_buyer = false;
    @track unpaid_days = 60;
    @track is_miscellaneous = false;
    @track application_amount = '';
    @track shipment_payment_terms_amount = '';
    @track unpaid_amount = '';
    @track payment_term_order_amount = '';
    @track order_payment_terms_amount_12months = '';
    @track application_amount_pre_shipment = '';
    @track received_payment_amount = '';
    @track acc_id = '';
    @track is_order_confirm = false;
    @track order_payment_terms_days_12month_amount;
    @track shipment_payment_terms_days_amount;
    @track order_payment_term_days_amount;
    @track pending_invoice_list = [];
    @track is_draft = false;
    @track show_confirm_order_amount = false;
    @track settings = [];
    @track is_new_purchase = false;
    @track created_cla_id = '';
    @track buyer_sub_country_match = false;
    @track subsidiaries_not_exist = [];


    expandHandler1(event) {
        this.section1.isSectionOpen = !this.section1.isSectionOpen
        this.section1.iconName = this.section1.isSectionOpen ? 'utility:up' : 'utility:down'

    }
    expandHandler2(event) {
        this.section2.isSectionOpen = !this.section2.isSectionOpen
        this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    expandHandler3(event) {
        this.section3.isSectionOpen = !this.section3.isSectionOpen
        this.section3.iconName = this.section3.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    handleCancel() {
        var params = {
            'api_params': '',
            'Pagename': 'ApplicationRecord',
        }
        let event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: params
        });
        this.dispatchEvent(event1);
    }

    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;

    }
    
    handleFirstDeclaration(e) {
        this.first_declaration = e.target.checked;
        this.disable_submit = this.first_declaration === true ? false : true;
    }
    handleSecondDeclaration(e) {
        this.second_declaration = e.target.checked;
        this.disable_submit = this.first_declaration === true && this.second_declaration === true ? false : true;
    }
    formatDate() {
        /*var curDate = new Date();
        if (curDate.getMonth() == 11) {
            var current = new Date(curDate.getFullYear() + 1, 0, curDate.getDate());
        } else {
            var current = new Date(curDate.getFullYear(), curDate.getMonth() + 1, curDate.getDate());
        }
        const today = current.getFullYear() + '-' + String(current.getMonth()).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today*/
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    consumeAvailableCL() {

        let used_cl = this.policydetail.Used_Credit_check__c;
        if ((used_cl === null) || (used_cl === '') || (used_cl === undefined) || (used_cl === 'undefined')) {
            used_cl = 0;
        }
        used_cl = used_cl + 1;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.policydetail.Id;
        fields[USED_CL_FIELD.fieldApiName] = used_cl;
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                //console.log('cl quota consumed');
                // this.callcreateCLApplicationAura();
                // this.callupdatePolicyCCFAura();
                this.loading = false;
                var params = {
                    'Pagename': 'RedirectCLARecord',
                    'cl_id': this.new_cla_id
                }
                let event1 = new CustomEvent('handlepagechange', {
                    detail: params
                });
                this.dispatchEvent(event1);
            })
            .catch(error => {
                //console.log('error in cl quota consume', JSON.stringify(error));
                console.error('error in cl quota consume', JSON.stringify(error));
            });
    }
    updateCLUplift(){
        const fields = {};
        fields[CL_ID_FIELD.fieldApiName] = this.clconfirmationdata.credit_limit_id;
        fields[IS_UPLIFTED_FIELD.fieldApiName] = true;
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                //console.log('cl isUplift updated');                
            })
            .catch(error => {
                //console.log('error in cl isUplift', JSON.stringify(error));
                console.error('error in cl isUplift', JSON.stringify(error));
            });
    }


    /*createCLA(buyer_id) {
        //console.log("createCLA");
        var all_fields = this.clconfirmationapidata;

        let cl_fields = all_fields.credit_limit_fields;
        //console.log("fields=" + JSON.stringify(fields));
        //console.log("buyer_id=" + buyer_id);
        try {
            var fields = {
                'Buyer__c': buyer_id,
                ...cl_fields
            };
            //console.log("updated fields=" + JSON.stringify(fields));
            var objRecordInput = { 'apiName': 'Credit_Limit__c', fields };
            //console.log("createCLA objRecordInput=" + JSON.stringify(objRecordInput));
            createRecord(objRecordInput).then(response => {
                //console.log('cla created with Id: ' + response.id);
                
            }).catch(error => {
                //console.log('cla Error: ' + error.toString());
            });
        } catch (e) {
            console.error(e.toString() + " " + e);
        }
    }*/
    handleSave() {
        this.loading = true;
        this.is_draft = true;
        try{
        var fields = [];
        fields = {
            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
            'Is_Draft__c': true,            
            'Application_Date__c': this.formatDate(),
            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country,
            'DNB_DUNS__c': this.clconfirmationdata.duns_no,
            'Buyer_Source__c': this.clconfirmationdata.buyer_source,
            'Agency_Ref__c': this.clconfirmationdata.buyer_agency_ref,
            'Buyer_Name__c': this.clconfirmationdata.buyer_name,
            'CL_Amount__c': '',
            'CL_Application_Amount__c': this.clconfirmationdata.application_amount,
            'CL_Status__c': 'Processing',
            'CL_Type__c': 'CLA',
            'Destination_Market__c': this.clconfirmationdata.destination_country,
            'Export_Type__c': this.clconfirmationdata.exportType,
            'Exporter__c': this.clconfirmationdata.acc_id,
            'Harmonized_Code__c': this.clconfirmationdata.harmonized_code,
            'Market_of_Origin__c': this.clconfirmationdata.country_origin,
            'Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days,
            'Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value,
            'Policy__c': this.policydetail.Id,
            'Policy_Fee__c': '',
            'Port_Of_Loading__c': this.clconfirmationdata.shipment_country,
            'Premium__c': '',
            'Ref_No__c': '',
            'Buyer_Registration_Number__c' : this.clconfirmationdata.registration_no,
            'Goods_or_Services_Involved__c': this.clconfirmationdata.goods_involved,
            'Specific_Goods_Involved__c': this.clconfirmationdata.specific_goods_involved,
            'Is_New_Buyer__c': this.clconfirmationdata.is_new_buyer,
            'Buyer_Trading_Time__c': this.clconfirmationdata.buyer_trading_time,
            'Shipment_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.shipment_payment_terms_amount,
            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
            'Pre_Shipment_Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value_pre_shipment,
            'Pre_Shipment_Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days_pre_shipment,
            'CL_Pre_Shipment_Application_AMount__c': this.clconfirmationdata.application_amount_pre_shipment,
            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
            'Order_Payment_Term_Days_12_Months__c': this.clconfirmationdata.order_payment_terms_days_12month,
            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
            'Order_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.order_payment_term_method3_12months,
            'Order_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.order_payment_term_method4_12months,
            'Order_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.order_payment_term_method5_12months,

            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,
            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
            'Order_Payment_Term_Days__c': this.clconfirmationdata.order_payment_term_days,
            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
            'Remarks__c': this.clconfirmationdata.remarks,
            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported,
            'Received_Order_Payment_Term_Days__c': this.clconfirmationdata.received_payment_term_days,
            'Received_Order_Payment_Term_Method1__c': this.clconfirmationdata.received_payment_term_method1,
            'Received_Order_Payment_Term_Method2__c': this.clconfirmationdata.received_payment_term_method2

        }
        //console.log('Fields=',JSON.stringify(fields));
        var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
        createRecord(objRecordInput).then(response => {
            //console.log('cla created with Id: ' + response.id);  
            if (this.clconfirmationdata.draft_id !== '') {
                DeleteDraft({
                    cla_id: this.clconfirmationdata.draft_id
                }).then((result) => {
                    //console.log('Old draft deleted');
                })
                .catch((error) => {
                    //console.log('error on Old draft delete::', JSON.stringify(error));
                    console.error('error Old draft delete::', JSON.stringify(error));
                });
            }                      
            if (this.clconfirmationdata.pending_invoice_list.length > 0) {
                //console.log('outstanding payment exist');               
                this.callcreateOutstandingPaymentBuyer(response.id);
            } else {
                var params = {
                    'api_params': '',
                    'Pagename': 'ApplicationRecord',
                }
                let event1 = new CustomEvent('handlepagechange', {
                    detail: params
                });
                this.dispatchEvent(event1);
            }      
        }).catch(error => {
            //console.log('cla Error: ' + JSON.stringify(error));
            console.error('cla Error: ' + JSON.stringify(error));
        });
    }catch(exception){
        //console.log('exception: ' + JSON.stringify(exception));
        console.error('exception: ' + JSON.stringify(exception));
    }
    }
    callcreateCLApplicationAura(){
        createCLApplicationAura({
            'clApplicationID': this.created_cla_id
        }).then((result) => {
            //console.log('callcreateCLApplicationAura response=',JSON.stringify(result));
            const fields = {};
            let result_json = JSON.parse(result);
            fields[CLA_ID_FIELD.fieldApiName] = this.created_cla_id;
            fields[CLA_REF_NO.fieldApiName] = result_json.meta_data.ref_no;
            if(result_json.meta_data.hasOwnProperty('pre_ref_no')){
                fields[CLA_PRE_REF_NO.fieldApiName] = result_json.meta_data.pre_ref_no;
            }
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                    //console.log('cla ref no updated');                
                })
                .catch(error => {
                    //console.log('error in cla ref no update', JSON.stringify(error));
                    console.error('error cla ref no update', JSON.stringify(error));
                });
        })
        .catch((error) => {
            //console.log("error in updatePolicyCCFAura", JSON.stringify(error));
            console.error("error in updatePolicyCCFAura", JSON.stringify(error));
        });
    }
    callupdatePolicyCCFAura(){
        //console.log('callupdatePolicyCCFAura');
        try{
        updatePolicyCCFAura({
            'policyID': this.policydetail.Id
        }).then((result) => {
            //console.log('updatePolicyCCFAura response=',JSON.stringify(result));
        })
            .catch((error) => {
                //console.log("error in updatePolicyCCFAura", JSON.stringify(error));
                console.error("error in updatePolicyCCFAura", JSON.stringify(error));
            });
        }catch(Exception){
            //console.log('Exception='+JSON.stringify(Exception));
        }
    }

    callcreateOutstandingPaymentBuyer(cla_id) {
        //console.log('callcreateOutstandingPaymentBuyer');
        createOutstandingPaymentBuyer({
            op_json: this.clconfirmationdata.pending_invoice_list,
            cla_id: cla_id
        }).then((result) => {
            //console.log("outstanding payment record created");
            if(this.is_draft) {
                var params = {
                    'api_params': '',
                    'Pagename': 'ApplicationRecord',
                }
                let event1 = new CustomEvent('handlepagechange', {
                    // detail contains only primitives
                    detail: params
                });
                this.dispatchEvent(event1);
            } else {
                if(!this.is_new_purchase)
                this.consumeAvailableCL();
            }
        })
            .catch((error) => {
                //console.log("error in outstanding payment record creation", JSON.stringify(error));
                console.error("error in outstanding payment record creation", JSON.stringify(error));
            });
    }

    isValid() {
        return true;
    }
    handleConfirm(e) {
        this.loading = true;
        //console.log("handleConfirm");
        try {
            if (this.isValid()) {
                if((this.subsidiaries_not_exist.length>0) && (this.is_service)) {
                    if(this.buyer_sub_country_match){
                        const event = new ShowToastEvent({
                            title: 'Alert',
                            message: 'Please contact the ECIC SME team to create an EN68 endorsement.',
                            variant: 'alert'
                        });
                        this.dispatchEvent(event);
                    } else {
                        const event = new ShowToastEvent({
                            title: 'Alert',
                            message: 'Please contact the ECIC SME team to create an EN70 endorsement.',
                            variant: 'alert'
                        });
                        this.dispatchEvent(event);
                    }                    
                } else if(this.subsidiaries_not_exist.length>0) {
                    if(this.buyer_sub_country_match){
                        const event = new ShowToastEvent({
                            title: 'Alert',
                            message: 'Please contact the ECIC SME team to create an EN67 endorsement.',
                            variant: 'alert'
                        });
                        this.dispatchEvent(event);
                    } else {
                        const event = new ShowToastEvent({
                            title: 'Alert',
                            message: 'Please contact the ECIC SME team to create an EN69 endorsement.',
                            variant: 'alert'
                        });
                        this.dispatchEvent(event);
                    }
                }
                if (this.policydetail.Available_Credit_Check__c > 0) {
                    var fields = [];
                    
                    if (this.clconfirmationdata.uplift_reapply === 'Reapply') {
                        fields = {
                            'Credit_Limit_Id__c': this.clconfirmationdata.credit_limit_id,
                            'Credit_Limit_Id2__c': this.clconfirmationdata.credit_limit_id2,
                            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
                            'Application_Date__c': this.formatDate(),
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country,
                            'Buyer_Name__c': this.clconfirmationdata.buyer_name,
                            'DNB_DUNS__c': this.clconfirmationdata.duns_no,
                            'Buyer_Source__c': this.clconfirmationdata.buyer_source,
                            'Agency_Ref__c': this.clconfirmationdata.buyer_agency_ref,
                            'CL_Amount__c': '',
                            'CL_Application_Amount__c': this.clconfirmationdata.application_amount,
                            'CL_Status__c': 'Processing',
                            'CL_Type__c': 'CLA',
                            'Destination_Market__c': this.clconfirmationdata.destination_country,
                            'Export_Type__c': this.clconfirmationdata.exportType,
                            'Exporter__c': this.policydetail.Exporter__r.Id,
                            'Harmonized_Code__c': this.clconfirmationdata.harmonized_code,
                            'Market_of_Origin__c': this.clconfirmationdata.country_origin,
                            'Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days,
                            'Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value,
                            'Policy__c': this.policydetail.Id,
                            'Policy_Fee__c': '',
                            'Port_Of_Loading__c': this.clconfirmationdata.shipment_country,
                            'Premium__c': '',
                            'Ref_No__c': '',
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.registration_no,
                            'Goods_or_Services_Involved__c': this.clconfirmationdata.goods_involved,
                            'Specific_Goods_Involved__c': this.clconfirmationdata.specific_goods_involved,
                            'Is_New_Buyer__c': this.clconfirmationdata.is_new_buyer,
                            'Buyer_Trading_Time__c': this.clconfirmationdata.buyer_trading_time,
                            'Shipment_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.shipment_payment_terms_amount,
                            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
                            'Pre_Shipment_Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value_pre_shipment,
                            'Pre_Shipment_Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days_pre_shipment,
                            'CL_Pre_Shipment_Application_AMount__c': this.clconfirmationdata.application_amount_pre_shipment,
                            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
                            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
                            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
                            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
                            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
                            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
                            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
                            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
                            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
                            'Order_Payment_Term_Days_12_Months__c': this.clconfirmationdata.order_payment_terms_days_12month,
                            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
                            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
                            'Order_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.order_payment_term_method3_12months,
                            'Order_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.order_payment_term_method4_12months,
                            'Order_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.order_payment_term_method5_12months,

                            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
                            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
                            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
                            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
                            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
                            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,
                            //received_payment_term_days

                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
                            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
                            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
                            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
                            'Order_Payment_Term_Days__c': this.clconfirmationdata.order_payment_term_days,
                            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
                            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
                            'Remarks__c': this.clconfirmationdata.remarks,
                            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
                            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
                            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported,
                            'Received_Order_Payment_Term_Days__c': this.clconfirmationdata.received_payment_term_days,
                            'Received_Order_Payment_Term_Method1__c': this.clconfirmationdata.received_payment_term_method1,
                            'Received_Order_Payment_Term_Method2__c': this.clconfirmationdata.received_payment_term_method2
                        }
                    } else {
                        fields = {
                            'Application_Date__c': this.formatDate(),
                            'Application_Type__c': 'New',
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country,
                            'Buyer_Name__c': this.clconfirmationdata.buyer_name,
                            'DNB_DUNS__c': this.clconfirmationdata.duns_no,
                            'Buyer_Source__c': this.clconfirmationdata.buyer_source,
                            'Agency_Ref__c': this.clconfirmationdata.buyer_agency_ref,
                            'CL_Amount__c': '',
                            'CL_Application_Amount__c': this.clconfirmationdata.application_amount,
                            'CL_Status__c': 'Processing',
                            'CL_Type__c': 'CLA',
                            'Destination_Market__c': this.clconfirmationdata.destination_country,
                            'Export_Type__c': this.clconfirmationdata.exportType,
                            'Exporter__c': this.policydetail.Exporter__r.Id,
                            'Market_of_Origin__c': this.clconfirmationdata.country_origin,
                            'Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days,
                            'Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value,
                            'Policy__c': this.policydetail.Id,
                            'Policy_Fee__c': '',
                            'Port_Of_Loading__c': this.clconfirmationdata.shipment_country,
                            'Premium__c': '',
                            'Ref_No__c': '',
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.registration_no,
                            'Goods_or_Services_Involved__c': this.clconfirmationdata.goods_involved,
                            'Specific_Goods_Involved__c': this.clconfirmationdata.specific_goods_involved,
                            'Is_New_Buyer__c': this.clconfirmationdata.is_new_buyer,
                            'Buyer_Trading_Time__c': this.clconfirmationdata.buyer_trading_time,
                            'Shipment_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.shipment_payment_terms_amount,
                            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
                            'Pre_Shipment_Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value_pre_shipment,
                            'Pre_Shipment_Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days_pre_shipment,
                            'CL_Pre_Shipment_Application_AMount__c': this.clconfirmationdata.application_amount_pre_shipment,
                            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
                            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
                            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
                            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
                            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
                            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
                            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
                            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
                            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
                            'Order_Payment_Term_Days_12_Months__c': this.clconfirmationdata.order_payment_terms_days_12month,
                            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
                            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
                            'Order_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.order_payment_term_method3_12months,
                            'Order_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.order_payment_term_method4_12months,
                            'Order_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.order_payment_term_method5_12months,
                            
                            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
                            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
                            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
                            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
                            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
                            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,

                            
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,

                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
                            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
                            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
                            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
                            'Order_Payment_Term_Days__c': this.clconfirmationdata.order_payment_term_days,
                            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
                            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
                            'Remarks__c': this.clconfirmationdata.remarks,
                            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
                            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
                            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported,
                            'Received_Order_Payment_Term_Days__c': this.clconfirmationdata.received_payment_term_days,
                            'Received_Order_Payment_Term_Method1__c': this.clconfirmationdata.received_payment_term_method1,
                            'Received_Order_Payment_Term_Method2__c': this.clconfirmationdata.received_payment_term_method2

                        }
                    }
                    var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
                    createRecord(objRecordInput).then(response => {
                        //console.log('cla created with Id: ' + response.id);
                        this.created_cla_id = response.id;
                        if (this.clconfirmationdata.draft_id !== '') {
                            DeleteDraft({
                                cla_id: this.clconfirmationdata.draft_id
                            }).then((result) => {
                                //console.log('Old draft deleted');
                            })
                            .catch((error) => {
                                //console.log('error on Old draft delete::', JSON.stringify(error));
                                console.error('error Old draft delete::', JSON.stringify(error));
                            });
                        }
                        if ((this.clconfirmationdata.uplift_reapply === 'Uplift') || (this.clconfirmationdata.uplift_reapply === 'Reapply')) {
                            this.new_cla_id = this.clconfirmationdata.credit_limit_id;
                        } else {
                            this.new_cla_id = response.id;
                        }
                        
                        if (this.clconfirmationdata.pending_invoice_list.length > 0) {
                            this.callcreateOutstandingPaymentBuyer(response.id);
                        } else {
                            this.consumeAvailableCL();
                        }
                        if(this.clconfirmationdata.selected_subsiaries.length > 0) {
                            createSubsidiaryRelatedCL({
                                cla_id:response.id, 
                                sub_id:this.clconfirmationdata.selected_subsiaries
                            }).then(response=>{
                                console.log('createSubsidiaryRelatedCL',response);
                            }).catch((Exception)=>{
                                console.log('Error createSubsidiaryRelatedCL',JSON.stringify(Exception));
                            });
                        }
                        
                        /* var params = {
                             'Pagename': 'RedirectCLARecord',
                             'cl_id': response.id
                         }
                         let event1 = new CustomEvent('handlepagechange', {
                             // detail contains only primitives
                             detail: params
                         });
                         this.dispatchEvent(event1);*/
                    }).catch(error => {
                        //console.log('cla Error: ' + JSON.stringify(error));
                        console.error('cla Error: ' + JSON.stringify(error));
                    });

                    

                
                } else {
                    if(this.settings.Extra_Credit_Check__c){
                        this.is_new_purchase = true;
                        if (!confirm("You have no credit check facilities remaining. You will be charged for an additional credit check facility if you proceed to submit this credit limit application.")) {
                            //console.log('"::::No');
                            var params = {
                                'api_params': '',
                                'Pagename': 'ApplicationRecord',
                            }
                            let event1 = new CustomEvent('handlepagechange', {
                                // detail contains only primitives
                                detail: params
                            });
                            this.dispatchEvent(event1);     
                            
                        } else {
                            //console.log('::::Yes');
                            var fields = [];
                    
                    if (this.clconfirmationdata.uplift_reapply === 'Reapply') {
                        fields = {
                            'Credit_Limit_Id__c': this.clconfirmationdata.credit_limit_id,
                            'Credit_Limit_Id2__c': this.clconfirmationdata.credit_limit_id2,
                            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
                            'Application_Date__c': this.formatDate(),
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country,
                            'Buyer_Name__c': this.clconfirmationdata.buyer_name,
                            'CL_Amount__c': '',
                            'CL_Application_Amount__c': this.clconfirmationdata.application_amount,
                            'CL_Status__c': 'Processing',
                            'CL_Type__c': 'CLA',
                            'Destination_Market__c': this.clconfirmationdata.destination_country,
                            'Export_Type__c': this.clconfirmationdata.exportType,
                            'Exporter__c': this.policydetail.Exporter__r.Id,
                            'Harmonized_Code__c': this.clconfirmationdata.harmonized_code,
                            'Market_of_Origin__c': this.clconfirmationdata.country_origin,
                            'Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days,
                            'Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value,
                            'Policy__c': this.policydetail.Id,
                            'Policy_Fee__c': '',
                            'Port_Of_Loading__c': this.clconfirmationdata.shipment_country,
                            'Premium__c': '',
                            'Ref_No__c': '',
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.registration_no,
                            'Goods_or_Services_Involved__c': this.clconfirmationdata.goods_involved,
                            'Specific_Goods_Involved__c': this.clconfirmationdata.specific_goods_involved,
                            'Is_New_Buyer__c': this.clconfirmationdata.is_new_buyer,
                            'Buyer_Trading_Time__c': this.clconfirmationdata.buyer_trading_time,
                            'Shipment_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.shipment_payment_terms_amount,
                            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
                            'Pre_Shipment_Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value_pre_shipment,
                            'Pre_Shipment_Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days_pre_shipment,
                            'CL_Pre_Shipment_Application_AMount__c': this.clconfirmationdata.application_amount_pre_shipment,
                            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
                            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
                            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
                            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
                            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
                            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
                            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
                            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
                            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
                            'Order_Payment_Term_Days_12_Months__c': this.clconfirmationdata.order_payment_terms_days_12month,
                            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
                            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
                            'Order_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.order_payment_term_method3_12months,
                            'Order_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.order_payment_term_method4_12months,
                            'Order_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.order_payment_term_method5_12months,

                            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
                            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
                            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
                            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
                            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
                            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,
                            
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
                            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
                            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
                            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
                            'Order_Payment_Term_Days__c': this.clconfirmationdata.order_payment_term_days,
                            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
                            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
                            'Remarks__c': this.clconfirmationdata.remarks,
                            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
                            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
                            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported,
                            'Received_Order_Payment_Term_Days__c': this.clconfirmationdata.received_payment_term_days,
                            'Received_Order_Payment_Term_Method1__c': this.clconfirmationdata.received_payment_term_method1,
                            'Received_Order_Payment_Term_Method2__c': this.clconfirmationdata.received_payment_term_method2
                        }
                    } else {
                        fields = {
                            'Application_Date__c': this.formatDate(),
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country,
                            'Buyer_Name__c': this.clconfirmationdata.buyer_name,
                            'CL_Amount__c': '',
                            'CL_Application_Amount__c': this.clconfirmationdata.application_amount,
                            'CL_Status__c': 'Processing',
                            'CL_Type__c': 'CLA',
                            'Destination_Market__c': this.clconfirmationdata.destination_country,
                            'Export_Type__c': this.clconfirmationdata.exportType,
                            'Exporter__c': this.policydetail.Exporter__r.Id,
                            'Market_of_Origin__c': this.clconfirmationdata.country_origin,
                            'Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days,
                            'Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value,
                            'Policy__c': this.policydetail.Id,
                            'Policy_Fee__c': '',
                            'Port_Of_Loading__c': this.clconfirmationdata.shipment_country,
                            'Premium__c': '',
                            'Ref_No__c': '',
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.registration_no,
                            'Goods_or_Services_Involved__c': this.clconfirmationdata.goods_involved,
                            'Specific_Goods_Involved__c': this.clconfirmationdata.specific_goods_involved,
                            'Is_New_Buyer__c': this.clconfirmationdata.is_new_buyer,
                            'Buyer_Trading_Time__c': this.clconfirmationdata.buyer_trading_time,
                            'Shipment_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.shipment_payment_terms_amount,
                            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
                            'Pre_Shipment_Payment_Term_Type__c': this.clconfirmationdata.payment_terms_value_pre_shipment,
                            'Pre_Shipment_Payment_Term_Days__c': this.clconfirmationdata.payment_terms_days_pre_shipment,
                            'CL_Pre_Shipment_Application_AMount__c': this.clconfirmationdata.application_amount_pre_shipment,
                            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
                            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
                            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
                            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
                            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
                            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
                            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
                            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
                            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
                            'Order_Payment_Term_Days_12_Months__c': this.clconfirmationdata.order_payment_terms_days_12month,
                            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
                            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
                            'Order_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.order_payment_term_method3_12months,
                            'Order_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.order_payment_term_method4_12months,
                            'Order_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.order_payment_term_method5_12months,
                            
                            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
                            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
                            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
                            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
                            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
                            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,
                            
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,

                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
                            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
                            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
                            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
                            'Order_Payment_Term_Days__c': this.clconfirmationdata.order_payment_term_days,
                            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
                            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
                            'Remarks__c': this.clconfirmationdata.remarks,
                            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
                            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
                            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported,
                            'Received_Order_Payment_Term_Days__c': this.clconfirmationdata.received_payment_term_days,
                            'Received_Order_Payment_Term_Method1__c': this.clconfirmationdata.received_payment_term_method1,
                            'Received_Order_Payment_Term_Method2__c': this.clconfirmationdata.received_payment_term_method2

                        }
                    }
                    var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
                    createRecord(objRecordInput).then(response => {
                        //console.log('cla created with Id: ' + response.id);
                        if (this.clconfirmationdata.draft_id !== '') {
                            DeleteDraft({
                                cla_id: this.clconfirmationdata.draft_id
                            }).then((result) => {
                                //console.log('Old draft deleted');
                            })
                            .catch((error) => {
                                //console.log('error on Old draft delete::', JSON.stringify(error));
                                console.error('error Old draft delete::', JSON.stringify(error));
                            });
                        }
                        if ((this.clconfirmationdata.uplift_reapply === 'Uplift') || (this.clconfirmationdata.uplift_reapply === 'Reapply')) {
                            this.new_cla_id = this.clconfirmationdata.credit_limit_id;
                        } else {
                            this.new_cla_id = response.id;
                        }
                        
                        if (this.clconfirmationdata.pending_invoice_list.length > 0) {
                            this.callcreateOutstandingPaymentBuyer(response.id);
                        }
                        if(this.clconfirmationdata.selected_subsiaries.length > 0) {
                            createSubsidiaryRelatedCL({
                                cla_id:response.id, 
                                sub_id:this.clconfirmationdata.selected_subsiaries
                            }).then(response=>{
                                console.log('createSubsidiaryRelatedCL',response);
                            }).catch((Exception)=>{
                                console.log('Error createSubsidiaryRelatedCL',JSON.stringify(Exception));
                            });
                        }
                        var json_ob = {
                            'amount':this.settings.Cost_of_Extra_Credit_Check__c,
                            'cla_id':response.id,
                            'account':this.policydetail.Exporter__r.Id,
                            'policy_id':this.policydetail.Id,
                            'Used_Credit_check__c':this.policydetail.Used_Credit_check__c
                        }
                        createSBPInvoice({
                            json_ob:json_ob
                        }).then((result) => {
                            //console.log('createSBPInvoice Invoicelineid=',result);
                            this.loading = false;
                            var params = {
                                'Pagename': 'RedirectCLARecord',
                                'cl_id': this.new_cla_id
                            }
                            let event1 = new CustomEvent('handlepagechange', {
                                detail: params
                            });
                            this.dispatchEvent(event1);
                        })
                        .catch((error) => {
                            //console.log('error on createSBPInvoice::', JSON.stringify(error));
                            console.error('error createSBPInvoice::', JSON.stringify(error));
                        });
                        
                    }).catch(error => {
                        //console.log('cla Error: ' + JSON.stringify(error));
                        console.error('cla Error: ' + JSON.stringify(error));
                    });
                        }

                    } else {
                        this.showToast('You have no credit check facilities remaining. You cannot submit this credit limit application.');
                    }
                }

            }
        } catch (e) {
            //console.log('Exception', JSON.stringify(e));
            console.error('Exception', JSON.stringify(e));
        }
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    handleEdit(e) {
        let section = e.currentTarget.dataset.id;
        //console.log('section=',section);
        // this.clconfirmationdata.push({'section':section});
        let event1 = new CustomEvent('handlepagechange', {
            detail: {
                Pagename: 'ApplynewSBP',
                accId: this.acc_id,
                clRecordEdit: this.clconfirmationdata,
                section: section
            }
        });
        this.dispatchEvent(event1);
    }
    callgetSettings(){
        //console.log('callgetSettings');
        getProductDetails({
            'prd_name':'SBP'
        })
        .then((result) => {
            console.log('getProductDetails result=',JSON.stringify(result));  
            this.settings = result;              
        })
        .catch(error => {
            //console.log('error in cl isUplift', JSON.stringify(error));
            console.error('error in cl isUplift', JSON.stringify(error));
        });
    }
    renderedCallback() {

        if (!this.isRendered) {
            // //console.log('today=',this.formatDate());
            this.isRendered = true;
            this.callgetSettings();
            //console.log('policydetail=', JSON.stringify(this.policydetail));
            console.log('clconfirmationdata', JSON.stringify(this.clconfirmationdata));
            
            
            this.acc_id = this.clconfirmationdata.acc_id;

            if (this.clconfirmationdata.exportType === 'Export of Services') {
                this.user_type = this.label.Client;
                this.user_type_small = this.label.client_small;
                this.is_preshipment = false;
                this.is_service = true;
                this.section1.label = 'Part A (Client Information)';
            } else {
                if(this.clconfirmationdata.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)'){
                    this.is_preshipment = true;
                    this.is_service = false;
                } else {
                    this.is_preshipment = false;
                    this.is_service = false;
                }
                this.user_type = this.label.Buyer;
                this.user_type_small = this.label.buyer_small;
                this.section1.label = 'Part A (Buyer Information)';
            }

            if(this.is_service){
                if(this.clconfirmationdata.selected_subsiaries.length > 0) {
                    for(var i=0; i<this.clconfirmationdata.selected_subsiaries.length; i++) {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            if(this.clconfirmationdata.selected_subsiaries[i] == this.clconfirmationdata.subsidiaries[j].Id) {
                                if(this.clconfirmationdata.subsidiaries[j].Subsidiary_Country__c.trim() == this.clconfirmationdata.buyer_country){
                                    this.buyer_sub_country_match = true;
                                }
                            }
                        }
                    }
                
                    console.log('buyer_sub_country_match=',this.buyer_sub_country_match);
                    let is_sub_exist = false;
                    if(this.buyer_sub_country_match) {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            is_sub_exist=false;
                            for(var i=0; i<this.clconfirmationdata.endorsement_list.length; i++) {
                                if(this.clconfirmationdata.endorsement_list[i].Endorsement_Type__r.Name == 'EN68') {
                                    if(this.clconfirmationdata.endorsement_list[i].hasOwnProperty('Subsidiary__c')) {
                                        if(this.clconfirmationdata.endorsement_list[i].Subsidiary__c == this.clconfirmationdata.subsidiaries[j])
                                        is_sub_exist=true;
                                    }
                                }
                            }
                            if(!is_sub_exist)
                            this.subsidiaries_not_exist.push(this.clconfirmationdata.subsidiaries[j]);
                        }
                    } else {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            is_sub_exist=false;
                            for(var i=0; i<this.clconfirmationdata.endorsement_list.length; i++) {
                                if(this.clconfirmationdata.endorsement_list[i].Endorsement_Type__r.Name == 'EN70') {
                                    if(this.clconfirmationdata.endorsement_list[i].hasOwnProperty('Subsidiary__c')) {
                                        if(this.clconfirmationdata.endorsement_list[i].Subsidiary__c == this.clconfirmationdata.subsidiaries[j])
                                        is_sub_exist=true;
                                    }
                                }
                            }
                            if(!is_sub_exist)
                            this.subsidiaries_not_exist.push(this.clconfirmationdata.subsidiaries[j]);
                        }
                    }
                    console.log('subsidiaries_not_exist=',JSON.stringify(this.subsidiaries_not_exist));
                }
            } else {
                if(this.clconfirmationdata.selected_subsiaries.length > 0) {
                    for(var i=0; i<this.clconfirmationdata.selected_subsiaries.length; i++) {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            if(this.clconfirmationdata.selected_subsiaries[i] == this.clconfirmationdata.subsidiaries[j].Id) {
                                if(this.clconfirmationdata.subsidiaries[j].Subsidiary_Country__c.trim() == this.clconfirmationdata.buyer_country){
                                    this.buyer_sub_country_match = true;
                                }
                            }
                        }
                    }
                
                    console.log('buyer_sub_country_match=',this.buyer_sub_country_match);
                    let is_sub_exist = false;
                    if(this.buyer_sub_country_match) {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            is_sub_exist=false;
                            for(var i=0; i<this.clconfirmationdata.endorsement_list.length; i++) {
                                if(this.clconfirmationdata.endorsement_list[i].Endorsement_Type__r.Name == 'EN67') {
                                    if(this.clconfirmationdata.endorsement_list[i].hasOwnProperty('Subsidiary__c')) {
                                        if(this.clconfirmationdata.endorsement_list[i].Subsidiary__c == this.clconfirmationdata.subsidiaries[j])
                                        is_sub_exist=true;
                                    }
                                }
                            }
                            if(!is_sub_exist)
                            this.subsidiaries_not_exist.push(this.clconfirmationdata.subsidiaries[j]);
                        }
                    } else {
                        for(var j=0; j<this.clconfirmationdata.subsidiaries.length; j++) {
                            is_sub_exist=false;
                            for(var i=0; i<this.clconfirmationdata.endorsement_list.length; i++) {
                                if(this.clconfirmationdata.endorsement_list[i].Endorsement_Type__r.Name == 'EN69') {
                                    if(this.clconfirmationdata.endorsement_list[i].hasOwnProperty('Subsidiary__c')) {
                                        if(this.clconfirmationdata.endorsement_list[i].Subsidiary__c == this.clconfirmationdata.subsidiaries[j])
                                        is_sub_exist=true;
                                    }
                                }
                            }
                            if(!is_sub_exist)
                            this.subsidiaries_not_exist.push(this.clconfirmationdata.subsidiaries[j]);
                        }
                    }
                    console.log('subsidiaries_not_exist=',JSON.stringify(this.subsidiaries_not_exist));
                }
            }

            if (this.clconfirmationdata.unpaid_amount === 'Yes') {
                this.flag_unpaid_shipment = true;
                let self=this;
                this.clconfirmationdata.pending_invoice_list.map((each_list)=>{
                    self.pending_invoice_list.push({
                        ...each_list,
                        'InvoiceAmount_formatted': Number(each_list.InvoiceAmount).toLocaleString()
                    })
                })
            }
            if (this.clconfirmationdata.is_new_buyer === 'Yes') {
                this.is_new_buyer = true;
            } else {
                this.is_new_buyer = false;
            }
            
            if (this.clconfirmationdata.buyer_country === 'Hong Kong'){
                this.is_hkg_buyer = true;
                this.unpaid_days = 30;
            } else {
                this.is_hkg_buyer = false;
                this.unpaid_days = 60;
            }
            if (this.clconfirmationdata.goods_involved === 'Miscellaneous (Products)'){
                this.is_miscellaneous = true;
            } else {
                this.is_miscellaneous = false;
            }
            if (this.clconfirmationdata.order_confirm_negotiation_value === 'No') {
                this.is_order_confirm = false;
            } else {
                this.is_order_confirm = true;
            }
            this.application_amount = Number(this.clconfirmationdata.application_amount).toLocaleString();
            this.shipment_payment_terms_amount = Number(this.clconfirmationdata.shipment_payment_terms_amount).toLocaleString();
            // this.unpaid_amount = Number(this.clconfirmationdata.unpaid_amount).toLocaleString();
            if(this.clconfirmationdata.payment_term_order_amount!==''){
                this.payment_term_order_amount = Number(this.clconfirmationdata.payment_term_order_amount).toLocaleString();
                this.show_confirm_order_amount = true;
            } else {
                this.payment_term_order_amount = ''
                this.show_confirm_order_amount = false;
            }

            this.order_payment_terms_amount_12months = Number(this.clconfirmationdata.order_payment_terms_amount_12months).toLocaleString();
            this.application_amount_pre_shipment = Number(this.clconfirmationdata.application_amount_pre_shipment).toLocaleString();
            if(this.clconfirmationdata.received_payment_amount !== '')
                this.received_payment_amount = Number(this.clconfirmationdata.received_payment_amount).toLocaleString();
            else
                this.received_payment_amount = ''
            
            if(this.clconfirmationdata.order_payment_terms_days_12month!=='')
                this.order_payment_terms_days_12month_amount = Number(this.clconfirmationdata.order_payment_terms_days_12month).toLocaleString();
            
            if(this.clconfirmationdata.shipment_payment_terms_days!=='')
                this.shipment_payment_terms_days_amount = Number(this.clconfirmationdata.shipment_payment_terms_days).toLocaleString();
            
            if(this.clconfirmationdata.order_payment_term_days!=='')
                this.order_payment_term_days_amount = Number(this.clconfirmationdata.order_payment_term_days).toLocaleString();
            
        }
    }
}
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
import createOutstandingPaymentBuyer from '@salesforce/apex/CLApplicationRecord.createOutstandingPaymentBuyer';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';
import updatePolicyCCFAura from '@salesforce/apex/ECIC_API_PolicyMgmt.updatePolicyCCFAura';
import createCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.createCLApplicationAura';
import getLatestValidBRDocument from '@salesforce/apex/CompanyDetails.getLatestValidBRDocument';
import sendEmailAccount from '@salesforce/apex/SendEmailApex.sendEmailAccount';
import createTask from '@salesforce/apex/TaskManagement.createTask';

import Credit_Limit_Application from '@salesforce/label/c.Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Policyholder from '@salesforce/label/c.Policyholder';
import Export_of_Goods_Export_of_Services from '@salesforce/label/c.Export_of_Goods_Export_of_Services';
import Are_you_holding_a_valid_credit_limit_on_the from '@salesforce/label/c.Are_you_holding_a_valid_credit_limit_on_the';
import buyer_small from '@salesforce/label/c.buyer_small';
import client_small from '@salesforce/label/c.client_small';
import Buyer from '@salesforce/label/c.Buyer';
import Client from '@salesforce/label/c.Client';
import Uplift_Reapply from '@salesforce/label/c.Uplift_Reapply';
import Country_Market from '@salesforce/label/c.Country_Market';
import Name from '@salesforce/label/c.Name';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Harmonized_Code from '@salesforce/label/c.Harmonized_Code';
import Application_Amount_HKD from '@salesforce/label/c.Application_Amount_HKD';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Country_Market_of_Shipment_Port_of_Loading from '@salesforce/label/c.Country_Market_of_Shipment_Port_of_Loading';
import Destination_Country_Market from '@salesforce/label/c.Destination_Country_Market';
import Country_Market_of_Origin from '@salesforce/label/c.Country_Market_of_Origin';
import Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for from '@salesforce/label/c.Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for';
import Does_this from '@salesforce/label/c.Does_this';
import have_any_unpaid from '@salesforce/label/c.have_any_unpaid';
import whether_due_or_not from '@salesforce/label/c.whether_due_or_not';
import Unpaid_Shipment_Details from '@salesforce/label/c.Unpaid_Shipment_Details';
import Shipment_Invoice_date from '@salesforce/label/c.Shipment_Invoice_date';
import Gross_Invoice_Value_Currency from '@salesforce/label/c.Gross_Invoice_Value_Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Due_Date from '@salesforce/label/c.Due_Date';
import Remark from '@salesforce/label/c.Remark';
import We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our from '@salesforce/label/c.We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our';
import We_declare_that_our_annual_sales_turnover_is_below_HK_30_million from '@salesforce/label/c.We_declare_that_our_annual_sales_turnover_is_below_HK_30_million';
import Back from '@salesforce/label/c.Back';
import Cancel from '@salesforce/label/c.Cancel';
import Save_and_Exit from '@salesforce/label/c.Save_and_Exit';
import Submit from '@salesforce/label/c.Submit';
import Section_A_Buyer_Information from '@salesforce/label/c.Section_A_Buyer_Information';
import Section_B_Trading_Experience from '@salesforce/label/c.Section_B_Trading_Experience';
import Part_A_Client_Information from '@salesforce/label/c.Part_A_Client_Information';
import Part_A_Buyer_Information from '@salesforce/label/c.Part_A_Buyer_Information';

export default class ClApplicationConfirmation extends LightningElement {

    @track label ={
        Part_A_Buyer_Information,Part_A_Client_Information,Section_B_Trading_Experience,Section_A_Buyer_Information,Submit,Save_and_Exit,Cancel,Back,We_declare_that_our_annual_sales_turnover_is_below_HK_30_million,We_declare_that_the_information_given_in_this_application_is_to_the_best_of_our,Remark,Due_Date,Gross_Invoice_Value_Amount,Gross_Invoice_Value_Currency,Shipment_Invoice_date,Unpaid_Shipment_Details,whether_due_or_not,Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,Policyholder,
        Export_of_Goods_Export_of_Services,Are_you_holding_a_valid_credit_limit_on_the,buyer_small,client_small,Buyer,Client,
        Uplift_Reapply,Country_Market,Name,Address,Registration_Number_If_any,Harmonized_Code,Application_Amount_HKD,
        Payment_Terms,Country_Market_of_Shipment_Port_of_Loading,Destination_Country_Market,Country_Market_of_Origin,Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for,
        Does_this,have_any_unpaid
    }

    @track showCheckFacilityModal = false;
    @api clconfirmationdata;
    @api clconfirmationapidata;
    @api policydetail;
    @track loading = false;
    @track user_type = this.label.Buyer;
    @track user_type_small = this.label.buyer_small;
    @track shipment_or_invoice = 'shipments'
    @track isRendered = false;
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: this.label.Section_A_Buyer_Information };
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: true, label: this.label.Section_B_Trading_Experience };
    @track flag_unpaid_shipment = false;
    @track first_declaration = false;
    @track second_declaration = false;
    @track disable_submit = true;
    @track new_cla_id = '';
    @track acc_id = '';
    @track application_amount = '';
    @track show_uplift_reapply = false;
    @track pending_invoice_list = [];
    @track is_draft = false;
    @track created_cla_id = '';
    @track br_doc = [];

    expandHandler1(event) {
        this.section1.isSectionOpen = !this.section1.isSectionOpen
        this.section1.iconName = this.section1.isSectionOpen ? 'utility:up' : 'utility:down'

    }
    expandHandler2(event) {
        this.section2.isSectionOpen = !this.section2.isSectionOpen
        this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
    }

    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;

    }
    callgetLatestValidBRDocument(){
        getLatestValidBRDocument({
            'acc_id':this.acc_id
        }).then((result)=>{
            if(result.length>0)
                this.br_doc = result[0];
            //consele.log('brdocument result',JSON.stringify(result));
            //consele.log('br_doc',JSON.stringify(this.br_doc));
        }).catch((exception)=>{
            //consele.log('Exception in getLatestValidBRDocument',JSON.stringify(exception));
        });
    }
    renderedCallback() {

        if (!this.isRendered) {
            // //consele.log('today=',this.formatDate());
            this.isRendered = true;
            //consele.log('policydetail=', this.policydetail);
            //consele.log('clconfirmationdata', JSON.stringify(this.clconfirmationdata));
            this.acc_id = this.clconfirmationdata.acc_id;
            this.callgetLatestValidBRDocument();

            if (this.clconfirmationdata.exportType === 'Export of Services') {
                this.user_type = this.label.Client;
                this.user_type_small = this.label.client_small;
                this.section1.label = this.label.Part_A_Client_Information;
                this.shipment_or_invoice = 'invoices';
            } else {
                this.user_type = this.label.Buyer;
                this.user_type_small = this.label.buyer_small;
                this.section1.label = this.label.Part_A_Buyer_Information;
                this.shipment_or_invoice = 'shipments'
            }
            if (this.clconfirmationdata.unpaid_shipment === 'Yes') {
                this.flag_unpaid_shipment = true;
                let self=this;
                
                this.clconfirmationdata.pending_invoice_list.map((each_list)=>{
                    self.pending_invoice_list.push({
                        ...each_list,
                        'InvoiceAmount_formatted': Number(each_list.InvoiceAmount).toLocaleString()
                    })
                })
            }
            if(this.clconfirmationdata.uplift_reapply.trim() !== ''){
                this.show_uplift_reapply = true;
            }
            
            // if(this.clconfirmationdata.application_amount){
                this.application_amount = this.clconfirmationdata.application_amount;
                this.application_amount = Number(this.application_amount).toLocaleString()
            // }
            //consele.log('application_amount=',this.application_amount);
        }
    }
    handleFirstDeclaration(e) {
        this.first_declaration = e.target.checked;
        this.disable_submit = this.first_declaration === true && this.second_declaration === true ? false : true;
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
                //consele.log('cl quota consumed');
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
                //consele.log('error in cl quota consume', JSON.stringify(error));
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
                //consele.log('cl isUplift updated');                
            })
            .catch(error => {
                //consele.log('error in cl isUplift', JSON.stringify(error));
                console.error('error in cl isUplift', JSON.stringify(error));
            });
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
    handleEdit(e) {
        let section = e.currentTarget.dataset.id;
        //consele.log('section=',section);
        // this.clconfirmationdata.push({'section':section});
        let event1 = new CustomEvent('handlepagechange', {
            detail: {
                Pagename: 'ApplynewOMBP',
                accId: this.acc_id,
                clRecordEdit: this.clconfirmationdata,
                section: section
            }
        });
        this.dispatchEvent(event1);
    }


    handleSave() {
        this.loading = true;
        this.is_draft = true;
        var fields = [];
        fields = {
            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
            'Is_Draft__c': true,
            'Application_Date__c': this.formatDate(),
            'Existing_valid_Credit_Limit_on_Buyer__c': this.clconfirmationdata.is_credit_limit_exist,
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
            'CL_Status__c': '',
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
            'Shipment_Payment_Term_Days_12_Months__c': this.clconfirmationdata.shipment_payment_terms_days,
            'Shipment_Payment_Term_Type_12_Months__c': this.clconfirmationdata.shipment_payment_terms_value,
            'Previously_Cancelled_Order_Unilaterally__c': this.clconfirmationdata.unilaterally_cancel_order,
            'Unpaid_Overdue_Order__c': this.clconfirmationdata.overdue_payment_order,
            'Shipment_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.shipment_payment_term_method1,
            'Shipment_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.shipment_payment_term_method2,
            'Shipment_Payment_Term_Method_12_Months3__c': this.clconfirmationdata.shipment_payment_term_method3,
            'Shipment_Payment_Term_Method_12_Months4__c': this.clconfirmationdata.shipment_payment_term_method4,
            'Shipment_Payment_Term_Method_12_Months5__c': this.clconfirmationdata.shipment_payment_term_method5,
            'Order_Payment_Term_Amount_12_Months__c': this.clconfirmationdata.order_payment_terms_amount_12months,
            'Order_Payment_Term_Method_12_Months1__c': this.clconfirmationdata.order_payment_term_method1_12months,
            'Order_Payment_Term_Method_12_Months2__c': this.clconfirmationdata.order_payment_term_method2_12months,
            'Order_Payment_Term_Type_12_Months__c': this.clconfirmationdata.order_payment_terms_type_12months,
            'Confirm_Order_Payment_Terms_Method1__c': this.clconfirmationdata.confirm_order_payment_terms_method1,
            'Confirm_Order_Payment_Terms_Method2__c': this.clconfirmationdata.confirm_order_payment_terms_method2,
            'Confirm_Order_Payment_Terms_Method3__c': this.clconfirmationdata.confirm_order_payment_terms_method3,
            'Confirm_Order_Payment_Terms_Method4__c': this.clconfirmationdata.confirm_order_payment_terms_method4,
            'Confirm_Order_Payment_Terms_Method5__c': this.clconfirmationdata.confirm_order_payment_terms_method5,
                                    
            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,

            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,
            'Order_Confirmed_or_Negotiation__c': this.clconfirmationdata.order_confirm_negotiation_value,
            'Order_Payment_Term_Days__c':this.clconfirmationdata.order_payment_term_days,
            'Order_Payment_Term_Amount__c': this.clconfirmationdata.payment_term_order_amount,
            'Order_Payment_Term_Type__c': this.clconfirmationdata.order_payment_terms_value,
            'Shipment_Commence_Month__c': this.clconfirmationdata.shipment_commencement_month,
            'Shipment_Commence_Year__c': this.clconfirmationdata.shipment_commencement_year,
            'Remarks__c': this.clconfirmationdata.remarks,
            'Received_Order_Amount__c': this.clconfirmationdata.received_payment_amount,
            'Received_Order_Payment_Type__c': this.clconfirmationdata.received_payment_term,
            'Overseas_Goods_or_Services__c': this.clconfirmationdata.hkg_goods_exported

        }
        //consele.log('Fields=',JSON.stringify(fields));
        var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
        createRecord(objRecordInput).then(response => {
            //consele.log('cla draft created with Id: ' + response.id);  
            if (this.clconfirmationdata.draft_id !== '') {
                DeleteDraft({
                    cla_id: this.clconfirmationdata.draft_id
                }).then((result) => {
                    //consele.log('Old draft deleted');
                })
                .catch((error) => {
                    //consele.log('error on Old draft delete::', JSON.stringify(error));
                    console.error('error Old draft delete::', JSON.stringify(error));
                });
            }                      
            if (this.clconfirmationdata.pending_invoice_list.length > 0) {
                //consele.log('outstanding payment exist');               
                this.callcreateOutstandingPaymentBuyer(response.id);
            } else {
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
        }).catch(error => {
            //consele.log('cla Error: ' + JSON.stringify(error));
            console.error('cla Error: ' + JSON.stringify(error));
        });
            
    }
    callcreateCLApplicationAura(){
        createCLApplicationAura({
            'clApplicationID': this.created_cla_id
        }).then((result) => {
            //consele.log('createCLApplicationAura=',result);
            const fields = {};
            let result_json = JSON.parse(result);
            fields[CLA_ID_FIELD.fieldApiName] = this.created_cla_id;
            fields[CLA_REF_NO.fieldApiName] = result_json.meta_data.ref_no;
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                    //consele.log('cla ref no updated');                
                })
                .catch(error => {
                    //consele.log('error in cla ref no update', JSON.stringify(error));
                    console.error('error cla ref no update', JSON.stringify(error));
                });
                //consele.log('callcreateCLApplicationAura response=',JSON.stringify(result));

            })
        .catch((error) => {
            //consele.log("error in callcreateCLApplicationAura", JSON.stringify(error));
            console.error("error in callcreateCLApplicationAura", JSON.stringify(error));
        });
    }
    callupdatePolicyCCFAura(){
        updatePolicyCCFAura({
            'policyID': this.policydetail.Id
        }).then((result) => {
            //consele.log('updatePolicyCCFAura response=',JSON.stringify(result));
        })
            .catch((error) => {
                //consele.log("error in updatePolicyCCFAura", JSON.stringify(error));
                console.error("error in updatePolicyCCFAura", JSON.stringify(error));
            });
    }

    callcreateOutstandingPaymentBuyer(cla_id) {
        //consele.log('callcreateOutstandingPaymentBuyer');
        createOutstandingPaymentBuyer({
            op_json: this.clconfirmationdata.pending_invoice_list,
            cla_id: cla_id
        }).then((result) => {
            //consele.log("outstanding payment record created");
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
                this.consumeAvailableCL();
            }
        })
            .catch((error) => {
                //consele.log("error in outstanding payment record creation", JSON.stringify(error));
                console.error("error in outstanding payment record creation", JSON.stringify(error));
            });
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    getDaysBetween(first_day, second_day) {
        const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
        const diffDays = Math.round(Math.abs((first_day - second_day) / oneDay));
        // //consele.log('getDaysBetween diffDays=',diffDays);
        return diffDays;
    }

    isValid() {
        let is_valid = true;
        if(this.br_doc !== []) {
            var expiry_date = Date.parse(this.br_doc.Expiry_Date__c);
            var today = Date.parse(new Date());
            //consele.log('expiry_date=',expiry_date);
            //consele.log('today=',today);
            if(today > expiry_date){
                var dd = String(new Date().getDate()).padStart(2, '0');
                var mm = String(new Date().getMonth() + 1).padStart(2, '0'); //January is 0!
                var yyyy = new Date().getFullYear();
                today = yyyy + '-' + mm + '-' + dd;
                var past_expiry_date = this.getDaysBetween(new Date(today),new Date(this.br_doc.Expiry_Date__c));
                //consele.log('past_expiry_date=',past_expiry_date);
                if(past_expiry_date > 30){
                    is_valid = false;
                    this.showToast('Please upload a valid BR.');
                } else {
                    //consele.log('BR expired less than a month.');
                    is_valid = true;
                    createTask({
                        'subject': 'Follow up for expired BR.',
                        'description': 'BR has been expired for ' +  this.acc_id + '. Please follow up.',
                        'priority':'High',
                        'type':'',
                        'assignedTo':'',
                        'relatedID':this.acc_id
                    }).then((result) => {
                        //consele.log('br expired task',result);
                    }).catch((error) => {
                        //consele.log(error);
                    });
                    /*sendEmailAccount({
                        'accId': this.acc_id, 
                        'whatId': this.acc_id,
                        'templateName': 'BR_Expiry_Prior_Notification',
                        'ccSME': false,
                        'attachmentIds':null,
                        'runtimeAttachmentUrls':null
                    }).then((result) => {
                        //consele.log('sendEmailAccount response',result);
                    }).catch((error) => {
                        //consele.log(error);
                    });*/
                }                
            }
            // is_valid = false;
        } else {
            this.showToast('Please upload a BR.');
            is_valid = false;
        }
        return is_valid;
    }
    handleConfirm(e) {
        
        //consele.log("handleConfirm");
        try {
            if (this.isValid()) {
                if (this.policydetail.Available_Credit_Check__c > 0) {
                    this.loading = true;
                    var fields = [];
                    
                    if (this.clconfirmationdata.uplift_reapply === 'Uplift') {
                        this.updateCLUplift();
                        fields = {
                            'Credit_Limit_Id__c': this.clconfirmationdata.credit_limit_id,
                            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
                            'Application_Date__c': this.formatDate(),
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
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
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.Buyer_Registration_Number__c,
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,

                            'Legacy_Port_Of_Loading__c': this.clconfirmationdata.legacy_shipment_country,
                            'Legacy_Market_of_Origin__c': this.clconfirmationdata.legacy_country_origin,
                            'Legacy_Destination_Market__c': this.clconfirmationdata.legacy_destination_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country
                        }
                    } else if (this.clconfirmationdata.uplift_reapply === 'Reapply') {
                        fields = {
                            'Credit_Limit_Id__c': this.clconfirmationdata.credit_limit_id,
                            'Application_Type__c': this.clconfirmationdata.uplift_reapply,
                            'Application_Date__c': this.formatDate(),
                            'Buyer_Address_Line_1__c': this.clconfirmationdata.buyer_address_line1,
                            'Buyer_Address_Line_2__c': this.clconfirmationdata.buyer_address_line2,
                            'Buyer_Address_Line_3__c': this.clconfirmationdata.buyer_address_line3,
                            'Buyer_Address_Line_4__c': this.clconfirmationdata.buyer_address_line4,
                            'Buyer_Code__c': this.clconfirmationdata.buyer_code,
                            'Buyer_Country__c': this.clconfirmationdata.buyer_country,
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
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.Buyer_Registration_Number__c,
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,

                            'Legacy_Port_Of_Loading__c': this.clconfirmationdata.legacy_shipment_country,
                            'Legacy_Market_of_Origin__c': this.clconfirmationdata.legacy_country_origin,
                            'Legacy_Destination_Market__c': this.clconfirmationdata.legacy_destination_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country
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
                            'Buyer_Registration_Number__c' : this.clconfirmationdata.Buyer_Registration_Number__c,
                            'Is_Unpaid_Amount__c': this.clconfirmationdata.unpaid_amount,
                            'Is_Unpaid_Shipment__c': this.clconfirmationdata.unpaid_shipment,

                            'Legacy_Port_Of_Loading__c': this.clconfirmationdata.legacy_shipment_country,
                            'Legacy_Market_of_Origin__c': this.clconfirmationdata.legacy_country_origin,
                            'Legacy_Destination_Market__c': this.clconfirmationdata.legacy_destination_country,
                            'Legacy_Buyer_Country__c': this.clconfirmationdata.legacy_buyer_country
                        }
                    }
                    var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
                    
                    try{
                        console.log('objRecordInput=',JSON.stringify(objRecordInput));
                    createRecord(objRecordInput).then(response => {
                        console.log('cla created with Id: ' + response.id);
                        this.created_cla_id = response.id;
                        if (this.clconfirmationdata.draft_id !== '') {
                            DeleteDraft({
                                cla_id: this.clconfirmationdata.draft_id
                            }).then((result) => {
                                //consele.log('Old draft deleted');
                            })
                            .catch((error) => {
                                //consele.log('error on Old draft delete::', JSON.stringify(error));
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
                        console.log('cla Error: ' + JSON.stringify(error));
                        console.error('cla Error: ' + JSON.stringify(error));
                    });
                    } catch(Exception) {
                        console.log('Exception==='+JSON.stringify(Exception));
                    }

                    /*var params = {
                        'Pagename': 'RedirectCLARecord',
                        'cl_id': response.id
                    }
                    this.consumeAvailableCL(params);*/

                } else {
                    this.showToast('You have no credit check facilities remaining. You cannot submit this credit limit application.');
                }

            }
        } catch (e) {
            //consele.log('Exception', JSON.stringify(e));
            console.error('Exception', JSON.stringify(e));
        }
    }
}
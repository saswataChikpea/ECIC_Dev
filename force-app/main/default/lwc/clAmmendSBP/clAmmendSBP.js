import { LightningElement, track, api } from 'lwc';
import getCreditLimitApplicationRecordByID from '@salesforce/apex/CLApplicationRecord.getCreditLimitApplicationRecordByID';

import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import AMMEND_AMOUNT_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Application_Amount__c';
import AMMEND_PAYMENT_TERM_DAYS_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Payment_Term_Days__c';
import AMMEND_PAYMENT_TERM_TYPE_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Payment_Term_Type__c';
import AMMEND_PRE_SHIPMENT_AMOUNT_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Pre_Shipment_Application_Amount__c';
import AMMEND_PRE_SHIPMENT_PAYMENT_TERM_DAYS_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Pre_Shipment_Payment_Term_Days__c';
import AMMEND_PRE_SHIPMENT_PAYMENT_TERM_TYPE_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Ammend_Pre_Shipment_Payment_Term_Type__c';
import amendCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.amendCLApplicationAura';

import Buyer from '@salesforce/label/c.Buyer';
import Credit_Limit_Application from '@salesforce/label/c.Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Policyholder from '@salesforce/label/c.Policyholder';
import Export_of_Goods_Export_of_Services from '@salesforce/label/c.Export_of_Goods_Export_of_Services';
import buyer_small from '@salesforce/label/c.buyer_small';
import Are_you_holding_a_valid_credit_limit_on_the from '@salesforce/label/c.Are_you_holding_a_valid_credit_limit_on_the';
import Country_Market from '@salesforce/label/c.Country_Market';
import Name from '@salesforce/label/c.Name';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Goods_Involved from '@salesforce/label/c.Goods_Involved';
import Services_Involved from '@salesforce/label/c.Services_Involved';
import Application_Amount_for_pre_shipment_HKD from '@salesforce/label/c.Application_Amount_for_pre_shipment_HKD';
import Application_Amount_for_post_shipment_HKD from '@salesforce/label/c.Application_Amount_for_post_shipment_HKD';
import Application_Amount_HKD from '@salesforce/label/c.Application_Amount_HKD';
import Is_this_your_new_buyer from '@salesforce/label/c.Is_this_your_new_buyer';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import How_long_have_you_been_trading_with_this from '@salesforce/label/c.How_long_have_you_been_trading_with_this';
import Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this';
import in_the_last_12_months_HKD from '@salesforce/label/c.in_the_last_12_months_HKD';
import Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this';
import Has_the from '@salesforce/label/c.Has_the';
import previously_cancelled_from_the_order_unilaterally from '@salesforce/label/c.previously_cancelled_from_the_order_unilaterally';
import Any_payment_currently_overdue_from_this from '@salesforce/label/c.Any_payment_currently_overdue_from_this';
import ILC_or_payment_in_advance_transactions from '@salesforce/label/c.ILC_or_payment_in_advance_transactions';
import amount_unpaid_for_more_than_30_days from '@salesforce/label/c.amount_unpaid_for_more_than_30_days';
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
import Client from '@salesforce/label/c.Client';
import client_small from '@salesforce/label/c.client_small';
import Section_A_Buyer_Information from '@salesforce/label/c.Section_A_Buyer_Information';
import Section_A_Client_Information from '@salesforce/label/c.Section_A_Client_Information';
import Section_B_Trading_Experience from '@salesforce/label/c.Section_B_Trading_Experience';
import Section_C_Order_Information from '@salesforce/label/c.Section_C_Order_Information';


export default class ClAmmendSBP extends LightningElement {

    @track label = {
        Buyer,Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,Policyholder,
        Export_of_Goods_Export_of_Services,buyer_small,Are_you_holding_a_valid_credit_limit_on_the,Country_Market,Name,
        Address,Registration_Number_If_any,Goods_Involved,Services_Involved,Application_Amount_for_pre_shipment_HKD,Payment_Terms,
        Application_Amount_for_post_shipment_HKD,Application_Amount_HKD,Is_this_your_new_buyer,How_long_have_you_been_trading_with_this,
        Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this,in_the_last_12_months_HKD,Please_provide_the_amount_and_payment_terms_of_the_orders_you_made_to_this,
        Has_the,previously_cancelled_from_the_order_unilaterally,Any_payment_currently_overdue_from_this,ILC_or_payment_in_advance_transactions,
        amount_unpaid_for_more_than_30_days,Unpaid_Shipment_Details,Shipment_Invoice_date,Gross_Invoice_Value_Currency,Gross_Invoice_Value_Amount,
        Due_Date,Remark,Do_you_have_any_orders_confirmed_negotiation_with_this,Please_provide_the_amount_and_payment_terms_of_the_orders,When_will_the_shipments_commence,
        Remarks,What_is_the_amount_of_ILC_payment_in_advance_received_in_respect_of_the_orders,Client,client_small,
        Section_A_Buyer_Information,Section_A_Client_Information,Section_B_Trading_Experience,Section_C_Order_Information


    }

    @track showCheckFacilityModal = false;
    @api cla_id;
    @track clconfirmationdata = [];
    @api policydetail;
    @track loading = false;
    @track user_type = this.label.Buyer;
    @track user_type_small = this.label.buyer_small;
    @track isRendered = false;
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: this.label.Section_A_Buyer_Information };
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: this.label.Section_B_Trading_Experience };
    @track section3 = { Id: 3, iconName: 'utility:down', isSectionOpen: false, label: this.label.Section_C_Order_Information };
    @track flag_unpaid_shipment = false;
    @track first_declaration = false;
    @track second_declaration = false;
    @track disable_submit = true;
    @track new_cla_id = '';
    @track is_preshipment = false;
    @track is_new_buyer = false;
    @track is_service = false;
    @track application_amount_max = 5000000;
    @track application_amount_min = 50000;
    @track application_amount = '';
    @track pre_shipment_application_amount = '';
    @track pre_shipment_payment_term_type = '';
    @track pre_shipment_payment_term_days = '';
    @track payment_term_type = '';
    @track payment_term_days = '';
    @track is_miscellaneous = false;
    @track shipment_payment_terms_amount = '';
    @track order_payment_terms_amount_12months = '';

    @track payment_terms = [
        { value: 'DA', label: 'DA' },
        { value: 'DP', label: 'DP' },
        { value: 'OA', label: 'OA' }
    ];
    handlePreShipmentPaymentTermTypeChange(e) {
        this.pre_shipment_payment_term_type = e.target.value;
    }
    handlePreShipmentPaymentTermDaysChange(e) {
        this.pre_shipment_payment_term_days = e.target.value;
    }
    handlePaymentTermTypeChange(e) {
        this.payment_term_type = e.target.value;
    }
    handlePaymentTermDaysChange(e) {
        this.payment_term_days = e.target.value;
    }

    handleCLAAmountChange(e) {
        this.application_amount = e.target.value;
    }
    handlePreShipmentCLAAmountChange(e) {
        this.pre_shipment_application_amount = e.target.value;
    }
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

    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;

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
        var curDate = new Date();
        if (curDate.getMonth() == 11) {
            var current = new Date(curDate.getFullYear() + 1, 0, curDate.getDate());
        } else {
            var current = new Date(curDate.getFullYear(), curDate.getMonth() + 1, curDate.getDate());
        }

        const today = current.getFullYear() + '-' + String(current.getMonth()).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
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
    
    

    isValid() {
        return true;
    }
    handleConfirm(e) {
        this.loading = true;
        //console.log("handleConfirm");
        //console.log('this.application_amount',this.application_amount);
        //console.log('this.payment_term_type',this.payment_term_type);
        //console.log('this.payment_term_days',this.payment_term_days);
        //console.log('this.pre_shipment_application_amount',this.pre_shipment_application_amount);
        //console.log('this.pre_shipment_payment_term_days',this.pre_shipment_payment_term_days);
        //console.log('this.pre_shipment_payment_term_type',this.pre_shipment_payment_term_type);
        try {
            if (this.isValid()) {
                const fields = {};
                fields[ID_FIELD.fieldApiName] = this.cla_id;
                fields[AMMEND_AMOUNT_FIELD.fieldApiName] = this.application_amount;
                fields[AMMEND_PAYMENT_TERM_TYPE_FIELD.fieldApiName] = this.payment_term_type;
                fields[AMMEND_PAYMENT_TERM_DAYS_FIELD.fieldApiName] = this.payment_term_days;
                fields[AMMEND_PRE_SHIPMENT_AMOUNT_FIELD.fieldApiName] = this.pre_shipment_application_amount;
                fields[AMMEND_PRE_SHIPMENT_PAYMENT_TERM_DAYS_FIELD.fieldApiName] = this.pre_shipment_payment_term_days;
                fields[AMMEND_PRE_SHIPMENT_PAYMENT_TERM_TYPE_FIELD.fieldApiName] = this.pre_shipment_payment_term_type;
                const recordInput = { fields };
                updateRecord(recordInput)
                    .then(() => {
                        //console.log('cla record updated');
                        // this.callamendCLApplicationAura();
                        var params = {
                            'api_params': '',
                            'Pagename': 'ApplicationRecord',
                        }
                        let event1 = new CustomEvent('handlepagechange', {
                            // detail contains only primitives
                            detail: params
                        });
                        this.dispatchEvent(event1);
                    })
                    .catch(error => {
                        //console.log('error in cla ammend', JSON.stringify(error));
                        console.error('error in cla ammend', JSON.stringify(error));
                    });

            } else {

            }


        } catch (e) {
            
            //console.log('Exception', JSON.stringify(e));
            console.error('Exception', JSON.stringify(e));
        }
    }
    callamendCLApplicationAura(){
        amendCLApplicationAura({
            clApplicationID : this.cla_id,
            reqType:'A'
        }).then((response) => {
            //console.log('amendCLApplicationAura:',response);            
        })
        .catch(error => {
            //console.log('error in amendCLApplicationAura', JSON.stringify(error));
            console.error('error amendCLApplicationAura', JSON.stringify(error));
        });
    }
    callgetCreditLimitApplicationRecordByID() {
        getCreditLimitApplicationRecordByID({ 'cla_id': this.cla_id })
            .then((result) => {
                //console.log('cla record===', JSON.stringify(result));
                this.clconfirmationdata = result;
                if (this.clconfirmationdata.Payment_Term_Days__c) {
                    this.payment_term_days = this.clconfirmationdata.Payment_Term_Days__c;
                }
                if (this.clconfirmationdata.Payment_Term_Type__c) {
                    this.payment_term_type = this.clconfirmationdata.Payment_Term_Type__c;
                }
                if (this.clconfirmationdata.Pre_Shipment_Payment_Term_Type__c) {
                    this.pre_shipment_payment_term_type = this.clconfirmationdata.Pre_Shipment_Payment_Term_Type__c;
                }
                if (this.clconfirmationdata.Pre_Shipment_Payment_Term_Days__c) {
                    this.pre_shipment_payment_term_days = this.clconfirmationdata.Pre_Shipment_Payment_Term_Days__c;
                }
                if (this.clconfirmationdata.CL_Application_Amount__c) {
                    this.application_amount = this.clconfirmationdata.CL_Application_Amount__c;
                }
                if (this.clconfirmationdata.CL_Pre_Shipment_Application_AMount__c) {
                    this.pre_shipment_application_amount = this.clconfirmationdata.CL_Pre_Shipment_Application_AMount__c;
                }
                if (this.clconfirmationdata.Export_Type__c === 'Export of Services') {
                    this.user_type = this.label.Client;
                    this.user_type_small = this.label.client_small;
                    this.is_preshipment = false;
                    this.is_service = true;
                    this.section1.label = this.label.Section_A_Client_Information;
                } else {
                    this.section1.label = this.label.Section_A_Buyer_Information;
                    if (this.clconfirmationdata.Export_Type__c === 'Export of Goods (Pre-shipment and post-shipment risk)') {
                        this.is_preshipment = true;
                        this.is_service = false;
                    } else {
                        this.is_preshipment = false;
                        this.is_service = false;
                    }
                    this.user_type = this.label.Buyer;
                    this.user_type_small = this.label.buyer_small;
                }
                if (this.clconfirmationdata.Is_Unpaid_Amount__c === 'Yes') {
                    this.flag_unpaid_shipment = true;
                }
                if (this.clconfirmationdata.Is_New_Buyer__c === 'No') {
                    this.is_new_buyer = true;
                }
                if (this.clconfirmationdata.Goods_or_Services_Involved__c === 'Miscellaneous (Products)'){
                    this.is_miscellaneous = true;
                } else {
                    this.is_miscellaneous = false;
                }
                if(this.clconfirmationdata.Shipment_Payment_Term_Amount_12_Months__c) {
                    this.shipment_payment_terms_amount = Number(this.clconfirmationdata.Shipment_Payment_Term_Amount_12_Months__c).toLocaleString();
                }
                if(this.clconfirmationdata.Order_Payment_Term_Amount_12_Months__c) {
                    this.order_payment_terms_amount_12months = Number(this.clconfirmationdata.Order_Payment_Term_Amount_12_Months__c).toLocaleString();
                }

            }).catch((error) => {
                //console.log('error=', JSON.stringify(error));
                console.console.error(); ('error=', JSON.stringify(error));
            });
    }
    renderedCallback() {

        if (!this.isRendered) {
            // //console.log('today=',this.formatDate());
            this.isRendered = true;
            //console.log('policydetail=', JSON.stringify(this.policydetail));
            //console.log('clconfirmationdata', JSON.stringify(this.clconfirmationdata));
            this.callgetCreditLimitApplicationRecordByID();

        }
    }
}
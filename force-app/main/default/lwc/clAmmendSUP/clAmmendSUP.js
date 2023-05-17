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

import Credit_Limit_Application from '@salesforce/label/c.Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Policyholder from '@salesforce/label/c.Policyholder';
import Buyer from '@salesforce/label/c.Buyer';
import Country_Market from '@salesforce/label/c.Country_Market';
import Name from '@salesforce/label/c.Name';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Goods_Involved from '@salesforce/label/c.Goods_Involved';
import Application_Amount_HKD from '@salesforce/label/c.Application_Amount_HKD';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Is_this_your_new_buyer from '@salesforce/label/c.Is_this_your_new_buyer';
import How_long_have_you_been_trading_with_this from '@salesforce/label/c.How_long_have_you_been_trading_with_this';
import Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this';
import in_the_last_12_months_HKD from '@salesforce/label/c.in_the_last_12_months_HKD';
import Is_there_any_amount_currently_unpaid_for_more_than_60_days_from_the_due_date_for from '@salesforce/label/c.Credit_Limit_Application';
import Unpaid_Shipment_Details from '@salesforce/label/c.Unpaid_Shipment_Details';
import Shipment_Invoice_date from '@salesforce/label/c.Shipment_Invoice_date';
import Gross_Invoice_Value_Currency from '@salesforce/label/c.Gross_Invoice_Value_Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Due_Date_CLA from '@salesforce/label/c.Due_Date_CLA';
import Remark from '@salesforce/label/c.Remark';
import Do_you_have_any_orders_confirmed_negotiation_with_this from '@salesforce/label/c.Do_you_have_any_orders_confirmed_negotiation_with_this';
import Please_provide_the_amount_and_payment_terms_of_the_orders from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_orders';
import When_will_the_shipments_commence from '@salesforce/label/c.When_will_the_shipments_commence';



export default class ClAmmendSBP extends LightningElement {

    @track label={
        Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,
        Policyholder,Buyer,Country_Market,Name,Address,Registration_Number_If_any,Goods_Involved,Application_Amount_HKD,
        Payment_Terms,Is_this_your_new_buyer,How_long_have_you_been_trading_with_this,Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this,
        in_the_last_12_months_HKD,Is_there_any_amount_currently_unpaid_for_more_than_60_days_from_the_due_date_for,
        Unpaid_Shipment_Details,Shipment_Invoice_date,Gross_Invoice_Value_Currency,Gross_Invoice_Value_Amount,Due_Date_CLA,Remark,
        Do_you_have_any_orders_confirmed_negotiation_with_this,Please_provide_the_amount_and_payment_terms_of_the_orders,
        When_will_the_shipments_commence


        
    }

    @track showCheckFacilityModal = false;
    @api cla_id;
    @track clconfirmationdata = [];
    @api policydetail;
    @track loading = false;
    @track buyer_label = this.label.Buyer;
    @track buyer_label_small = 'buyer';
    @track isRendered = false;
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: 'Section A (Buyer Information)' };
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: 'Section B (Trading Experience)' };
    @track section3 = { Id: 3, iconName: 'utility:down', isSectionOpen: false, label: 'Section C (Order Information)' };
    @track flag_unpaid_shipment = false;
    @track first_declaration = false;
    @track second_declaration = false;
    @track disable_submit = true;
    @track new_cla_id = '';
    @track is_preshipment = false;
    @track is_new_buyer = false;
    @track is_service = false;
    @track application_amount_max = 3000000;
    @track application_amount_min = 50000;
    @track application_amount = '';
    @track pre_shipment_application_amount = '';
    @track pre_shipment_payment_term_type = '';
    @track pre_shipment_payment_term_days = '';
    @track payment_term_type = '';
    @track payment_term_days = '';
    @track payment_term_order_amount = '';
    @track is_miscellaneous = false;
    @track shipment_payment_terms_amount = '';

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
                if (this.clconfirmationdata.Goods_or_Services_Involved__c === 'Miscellaneous (Products)'){
                    this.is_miscellaneous = true;
                } else {
                    this.is_miscellaneous = false;
                }
                // if (this.clconfirmationdata.Pre_Shipment_Payment_Term_Type__c) {
                //     this.pre_shipment_payment_term_type = this.clconfirmationdata.Pre_Shipment_Payment_Term_Type__c;
                // }
                // if (this.clconfirmationdata.Pre_Shipment_Payment_Term_Days__c) {
                //     this.pre_shipment_payment_term_days = this.clconfirmationdata.Pre_Shipment_Payment_Term_Days__c;
                // }
                if (this.clconfirmationdata.CL_Application_Amount__c) {
                    this.application_amount = this.clconfirmationdata.CL_Application_Amount__c;
                }
                if(this.clconfirmationdata.Order_Payment_Term_Amount__c) {
                    this.payment_term_order_amount = Number(this.clconfirmationdata.Order_Payment_Term_Amount__c).toLocaleString();
                }
                if(this.clconfirmationdata.Shipment_Payment_Term_Amount_12_Months__c) {
                    this.shipment_payment_terms_amount = Number(this.clconfirmationdata.Shipment_Payment_Term_Amount_12_Months__c).toLocaleString();
                }
                // if (this.clconfirmationdata.CL_Pre_Shipment_Application_AMount__c) {
                //     this.pre_shipment_application_amount = this.clconfirmationdata.CL_Pre_Shipment_Application_AMount__c;
                // }
                /*if (this.clconfirmationdata.Export_Type__c === 'Export of Services') {
                    this.buyer_label = 'Client';
                    this.buyer_label_small = 'client';
                    this.is_preshipment = false;
                    this.is_service = true;
                } else {
                    if (this.clconfirmationdata.Export_Type__c === 'Export Goods(Pre-shipment and Post-shipment risk)') {
                        this.is_preshipment = true;
                        this.is_service = false;
                    } else {
                        this.is_preshipment = false;
                        this.is_service = false;
                    }
                    this.buyer_label = 'Buyer';
                    this.buyer_label_small = 'buyer';
                }*/
                if (this.clconfirmationdata.Is_Unpaid_Amount__c === 'Yes') {
                    this.flag_unpaid_shipment = true;
                }
                if (this.clconfirmationdata.Is_New_Buyer__c === 'No') {
                    this.is_new_buyer = true;
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
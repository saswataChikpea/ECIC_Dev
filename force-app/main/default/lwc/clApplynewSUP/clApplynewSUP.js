import { LightningElement, track, api, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getExistingBuyers from '@salesforce/apex/CLApplicationRecord.getExistingBuyers';
// import getCountryList from '@salesforce/apex/CLApplicationRecord.getCountryList';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';
import createOutstandingPaymentBuyer from '@salesforce/apex/CLApplicationRecord.createOutstandingPaymentBuyer';
import serchBuyerDetailsAura from '@salesforce/apex/ECIC_CL_API_Methods.serchBuyerDetailsAura';
import getProductList from '@salesforce/apex/GetCustomMetaData.getProductList';
import getBuyerCountryListByPolicy from '@salesforce/apex/GetCustomMetaData.getBuyerCountryListByPolicy';

import Credit_Limit_Application from '@salesforce/label/c.Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import CL_Application_Draft from '@salesforce/label/c.CL_Application_Draft';
import Required_field_DCL from '@salesforce/label/c.Required_field_DCL';
import Self_Underwritten_Policy_is_only_applicable_to_Hong_Kong_exporters_with_annual from '@salesforce/label/c.Self_Underwritten_Policy_is_only_applicable_to_Hong_Kong_exporters_with_annual';
import Policyholder_Must_be_the_contractual_seller from '@salesforce/label/c.Policyholder_Must_be_the_contractual_seller';
import Are_you_holding_a_valid_credit_limit_on_the_buyer from '@salesforce/label/c.Are_you_holding_a_valid_credit_limit_on_the_buyer';
import Client from '@salesforce/label/c.Client';
import Buyer from '@salesforce/label/c.Buyer';
import Country_Market from '@salesforce/label/c.Country_Market';
import Name from '@salesforce/label/c.Name';
import Search from '@salesforce/label/c.Search';
import Or from '@salesforce/label/c.Or';
import Registration_No from '@salesforce/label/c.Registration_No';
import Please_Wait from '@salesforce/label/c.Please_Wait';
import Search_Result from '@salesforce/label/c.Search_Result';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Goods_Involved from '@salesforce/label/c.Goods_Involved';
import Please_Specify from '@salesforce/label/c.Please_Specify';
import Application_Amount_HKD from '@salesforce/label/c.Application_Amount_HKD';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Days from '@salesforce/label/c.Days';
import Is_this_your_new_buyer from '@salesforce/label/c.Is_this_your_new_buyer';
import How_many_years_have_you_been_trading_with_this_buyer from '@salesforce/label/c.How_many_years_have_you_been_trading_with_this_buyer';
import Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this_bu from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this_bu';
import OA from '@salesforce/label/c.OA';
import DP from '@salesforce/label/c.DP';
import DA from '@salesforce/label/c.DA';
import Payment_in_advance from '@salesforce/label/c.Payment_in_advance';
import ILC from '@salesforce/label/c.ILC';
import Is_there_any_amount_currently_unpaid_for_more_than_60_days_from_the_due_date from '@salesforce/label/c.Is_there_any_amount_currently_unpaid_for_more_than_60_days_from_the_due_date';
import Unpaid_Shipment_Details from '@salesforce/label/c.Unpaid_Shipment_Details';
import Shipment from '@salesforce/label/c.Shipment';
import Invoice_date from '@salesforce/label/c.Invoice_date';
import Gross_Invoice_Value_Currency from '@salesforce/label/c.Gross_Invoice_Value_Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Due_Date from '@salesforce/label/c.Due_Date';
import Remarks from '@salesforce/label/c.Remarks';
import Do_you_have_any_orders_confirmed_negotiation_with_this_buyer from '@salesforce/label/c.Do_you_have_any_orders_confirmed_negotiation_with_this_buyer';
import Please_provide_the_amount_and_payment_terms_of_the_orders from '@salesforce/label/c.Please_provide_the_amount_and_payment_terms_of_the_orders';
import When_will_the_shipments_commence from '@salesforce/label/c.When_will_the_shipments_commence';
import Cancel from '@salesforce/label/c.Cancel';
import Save_and_Exit from '@salesforce/label/c.Save_and_Exit';
import Next from '@salesforce/label/c.Next';
import Part_C_Order_Information from '@salesforce/label/c.Part_C_Order_Information';
import Part_B_Trading_Experience from '@salesforce/label/c.Part_B_Trading_Experience';
import Part_A_Buyer_Information from '@salesforce/label/c.Part_A_Buyer_Information';
import Export_Goods_Post_shipment_risk_only from '@salesforce/label/c.Export_Goods_Post_shipment_risk_only';
import Export_Goods_Pre_shipment_and_Post_shipment_risk from '@salesforce/label/c.Export_Goods_Pre_shipment_and_Post_shipment_risk';
import Export_Services from '@salesforce/label/c.Export_Services';
import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';
import Reapply from '@salesforce/label/c.Reapply';
import Uplift from '@salesforce/label/c.Uplift';
import Yes_orders_under_negotiation from '@salesforce/label/c.Yes_orders_under_negotiation';
import Yes_orders_confirmed from '@salesforce/label/c.Yes_orders_confirmed';
import OA_90days from '@salesforce/label/c.OA_90days';
import getProductDetails from '@salesforce/apex/CLProductDetails.getProductDetails';

export default class ClApplynewSUP extends LightningElement {

    @track label= {
        Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,CL_Application_Draft,
        Required_field_DCL,Self_Underwritten_Policy_is_only_applicable_to_Hong_Kong_exporters_with_annual,Policyholder_Must_be_the_contractual_seller,
        Are_you_holding_a_valid_credit_limit_on_the_buyer,Buyer,Client,Country_Market,Name,Search,Or,Registration_No,Please_Wait,Search_Result,
        Address,Registration_Number_If_any,Goods_Involved,Please_Specify,Application_Amount_HKD,Payment_Terms,Days,Is_this_your_new_buyer,
        How_many_years_have_you_been_trading_with_this_buyer,Please_provide_the_amount_and_payment_terms_of_the_shipments_you_made_to_this_bu,OA,DP,DA,
        ILC,Payment_in_advance,Is_there_any_amount_currently_unpaid_for_more_than_60_days_from_the_due_date,Unpaid_Shipment_Details,Shipment,Invoice_date,
        Gross_Invoice_Value_Currency,Gross_Invoice_Value_Amount,Due_Date,Remarks,Do_you_have_any_orders_confirmed_negotiation_with_this_buyer,
        Please_provide_the_amount_and_payment_terms_of_the_orders,When_will_the_shipments_commence,Cancel,Save_and_Exit,Next,
        Part_A_Buyer_Information,Part_B_Trading_Experience,Part_C_Order_Information,Export_Goods_Post_shipment_risk_only,
        Export_Goods_Pre_shipment_and_Post_shipment_risk,Export_Services,Yes,No,Uplift,Reapply,Yes_orders_confirmed,Yes_orders_under_negotiation,
        OA_90days
        


    }
    @api policyinfo;
    @track is_rendered = false;
    @track account_name = "";
    @track acc_id = "";
    @track policy_no = "";
    @track policy_type = "";
    @track available_credit_check_facility = "";
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: this.label.Part_A_Buyer_Information }
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: this.label.Part_B_Trading_Experience }
    @track section3 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: this.label.Part_C_Order_Information }
    @api exportType = "";
    @api unpaid_amount = "";
    @api unpaid_shipment = "";
    @api user_type = this.label.Buyer;
    @api show_buyernameeng_info = false;
    @api msg_buyernameeng_info = "The buyer/ client is the one who has the contractual obligation to pay for the goods/ services, but not the agent of the consignee.";
    @api show_application_amount_info = false;
    @api msg_application_amount_info = "The credit limit applied for should reflect more or less the maximum amount owed or likely to be owed by your buyer/ client concerned at any one time from the credit limit effective date within 90 calendar days";
    @api show_payment_term_info = false;
    @api msg_payment_term_info = "Cash against documents (CAD), cash on delivery (COD), documents against payment (DP), documents against acceptance (DA) or open account (OA) for a period not exceeding 90 calendar days.";
    @api chineesenameoptions = [
        { label: 'abcd', value: 'abcd' },
        { label: 'Address', value: 'Address' },
    ];
    @api all_correct_consign = false;
    @api allcorrectoption = [
        { label: '', value: 'true' }
    ];
    @api buyer_address_line1 = "";
    @api buyer_address_line2 = "";
    @api buyer_address_line3 = "";
    @api buyer_address_line4 = "";
    @api annual_sales = false;
    @api policy_holder = "";
    @api buyer_code = "";
    @api buyer_name_english = "";
    @api buyer_name = "";
    @api buyer_country = "";
    @track legacy_buyer_country = '';
    @api buyer_name_chinese = "";
    @api application_amount = "";
    @track application_amount_pre_shipment = "";
    @api registration_no = "";
    @api harmonized_code = "";
    @api buyer_full_address = "";
    @api label_payment_term_info = this.label.Payment_Term_OA_DA_DP_90_days;
    @api hide_payment_term_info_icon = false;
    @api hide_country_lists = false;
    @api label_unpaid_shipment = "shipments";
    @api flag_unpaid_shipment = false;
    @api shipment_country = "";
    @api destination_country = "";
    @track is_preshipment = false;
    @track is_postshipment = false;
    @track is_service = false;
    @track export_options = [
        { label: this.label.Export_Goods_Post_shipment_risk_only, value: 'Export Goods(Post-shipment risk only)', isChecked: false },
        { label: this.label.Export_Goods_Pre_shipment_and_Post_shipment_risk, value: 'Export Goods(Pre-shipment and Post-shipment risk)', isChecked: false },
        { label: this.label.Export_Services, value: 'Export of Services', isChecked: false }
    ];
    @track existing_credit_limit = [
        { label: this.label.Yes, value: 'Yes', isChecked: false },
        { label: this.label.No, value: 'No', isChecked: false },
    ];
    @api is_credit_limit_exist = '';
    @track unpaid_options = [
        { label: this.label.Yes, value: 'Yes', isChecked: false },
        { label: this.label.No, value: 'No', isChecked: false },
    ];
    @track new_buyer_options = [
        { label: this.label.Yes, value: 'Yes', isChecked: false },
        { label: this.label.No, value: 'No', isChecked: false },
    ];
    @track hkg_goods_exported = '';
    @track uplift_reapply_option = [
        { label: this.label.Uplift, value: 'Uplift', isChecked: false },
        { label: this.label.Reapply, value: 'Reapply', isChecked: false },
    ];
    @api uplift_reapply = '';



    @track payment_terms = [
        { value: 'DA', label: this.label.DA },
        { value: 'DP', label: this.label.DP },
        { value: 'OA', label: this.label.OA }
    ];
    @track invoice_payment_terms = [
        { value: 'DA', label: this.label.DA },
        { value: 'DP', label: this.label.DP },
        { value: 'OA', label: this.label.OA }
    ];
    // @track CurrencyList = [
    //     { value: 'USD', label: 'USD' },
    //     { value: 'INR', label: 'INR' },
    // ];

    @track payment_terms_value = 'OA';
    @track payment_terms_days = 120;
    @track payment_terms_value_pre_shipment = '';
    @track payment_terms_days_pre_shipment = '';
    @track submit_enable = false;
    @track invoiceList = [];
    @track index = 0;
    isLoaded = false;
    @track invoiceDate;
    @track invoiceCurrency;
    @track invoiceAmount;
    @track paymentTermsType;
    @track paymentTermsDays;
    @track invoiceDueDate;
    @track invoiceRemark;
    inv = {
        InvoiceDate: this.invoiceDate,
        InvoiceCurrency: this.invoiceCurrency,
        InvoiceAmount: this.invoiceAmount,
        PaymentTermsType: this.paymentTermsType,
        PaymentTermsDays: this.paymentTermsDays,
        InvoiceDueDate: this.invoiceDueDate,
        InvoiceRemark: this.invoiceRemark
    };
    @track showBuyerModal = false;
    @track buyer_info_disable = false;
    @track buyer_info = [];
    @track showCheckFacilityModal = false;
    @api policy_detail = [];
    @track existing_buyer_list = [];
    @track show_buyer_select = false;
    @track enable_buyer_edit = false;
    @track show_buyer_section = false;
    @track manual_buyer_input = false;
    @track country_origin = '';
    @track search_buyer = false;
    @track show_buyer_search_link = false;
    @track buyer_search_result = [];
    @track credit_limit_record = [];
    @track credit_limit_id = '';
    @track isNewApplication = true;
    @track application_amount_min = 50000;
    @track application_amount_max = 3000000;
    @track application_amount_step = 10000;
    @track isClUplifted = false;
    @track clExpiryDate = '';
    @track clEffectiveDate = '';
    @track show_qs_4_5 = false;
    @track goods_involved = '';
    @track specific_goods_involved = '';
    @track is_new_buyer = '';
    @track buyer_trading_time = '';
    @track payment_term_amount = '';
    @track show_new_buyer_detail = false;
    @track payment_term_order_amount = '';
    @track shipment_commencement_month = '';
    @track shipment_commencement_year = '';
    @track remarks = '';
    @track order_confirm_negotiation_options = [
        { value: 'Yes, orders confirmed ', label: this.label.Yes_orders_confirmed },
        { value: 'Yes, orders under negotiation', label: this.label.Yes_orders_under_negotiation },
        { value: 'No', label: this.label.No }
    ];
    @track order_confirm_negotiation_value = '';
    @track show_order_confirm_negotiation_detail = false;
    @track shipment_payment_terms_value = '';
    @track order_payment_terms_value = '';
    @track order_payment_term_days = '';
    @track order_payment_term_ = '';
    @track unilaterally_cancel_order = '';
    @track overdue_payment_order = '';
    @track received_payment_amount = '';
    @track received_payment_term = '';
    @track shipment_payment_terms_amount = '';
    @track shipment_payment_terms_days = '';
    @track shipment_payment_term_method1 = '';
    @track shipment_payment_term_method1_id = false;
    @track shipment_payment_term_method2 = '';
    @track shipment_payment_term_method_id = false;
    @track shipment_payment_term_method3 = '';
    @track shipment_payment_term_method_id = false;
    @track shipment_payment_term_method4 = '';
    @track shipment_payment_term_method4_id = false;
    @track shipment_payment_term_method5 = '';
    @track shipment_payment_term_method5_id = false;

    @track order_payment_terms_amount_12months = '';
    @track order_payment_term_method1_12months = '';
    @track order_payment_term_method2_12months = '';
    @track order_payment_terms_type_12months = '';

    @track confirm_order_payment_terms_method1 = '';
    @track confirm_order_payment_terms_method1_id = false;
    @track confirm_order_payment_terms_method2 = '';
    @track confirm_order_payment_terms_method2_id = false;
    @track confirm_order_payment_terms_method3 = '';
    @track confirm_order_payment_terms_method3_id = false;
    @track confirm_order_payment_terms_method4 = '';
    @track confirm_order_payment_terms_method4_id = false;
    @track confirm_order_payment_terms_method5 = '';
    @track confirm_order_payment_terms_method5_id = false;
    @track is_miscellaneous = false;
    @track countryOptions = [];
    @track loading = false;
    @track draft_id = '';
    @track search_buyer_name  = '';
    @track search_buyer_reg_no = '';
    @track search_buyer_name_disable  = false;
    @track search_buyer_reg_no_disable = false;
    @track mandatory_mark = '*';
    @track buyer_search_loading = false;
    // @track buyer_source = '';
    // @track duns_no = '';
    // @track agency_ref = '';
    @track goodsOptions = [];

    @track duns_no = '';
    @track buyer_source = '';
    @track buyer_agency_ref = '';
    @track buyer_country_options = [];
    @track product_details = [];

    @wire(getProductDetails,{prd_name:'$policy_type'})
    handleProductDetails({ error, data }) {
        console.log('handleProductDetails data=',JSON.stringify(data));
        if (data) {
            this.application_amount_min = data.Minimum_Credit_Limit_Amount__c;
            this.application_amount_max = data.Maximum_Credit_Limit_Amount__c;
            this.application_amount_step = data.CL_Amount_Step__c;
            this.payment_terms_value = data.Default_Payment_Term_Type__c;
            this.payment_terms_days = data.Default_Payment_Term_Days__c;            
        }
        if (error) {
            console.error('Error',JSON.stringify(error));
        }
    }

    @wire(getBuyerCountryListByPolicy,{policy_type:'56'})
    handleBuyerCountryList({ error, data }) {
        //console.log('handleBuyerCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.buyer_country_options = data.map((each_el)=>({label:each_el.ByrCtry_Country_Name__c,value:each_el.ByrCtry_Country_Name__c,code:each_el.ByrCtry_Country_Code__c}));
            this.buyer_country_options.sort((a, b) => a.value.localeCompare(b.value))

            // this.countryOptions = result.map((country)=>({label:country.Full_Country_Name__c,value:country.Full_Country_Name__c,code:country.Country_Code__c}));
            // this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            // this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
        }
        if (error) {
            console.error('error in getBuyerCountryList=' + JSON.stringify(error))
        }
    }

    

    @wire(getProductList)
    handleProductList({ error, data }) {
        console.log('handleProductList data=' + JSON.stringify(data))
        if (data) {            
            this.goodsOptions = data.map((each_el)=>({label:each_el.PRD_DESC__c,value:each_el.PRD_DESC__c}));
            // //console.log(' list data=' + JSON.stringify(test))
            this.goodsOptions.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in handleProductList=' + JSON.stringify(error))

        }
    }

    expandHandler1(event) {
        //console.log('expandHandler=', event.currentTarget.id);
        let id = event.currentTarget.id + ""
        id = id.split("-")[0];
        // this.section_array.forEach((cl) => {
        this.section1.isSectionOpen = !this.section1.isSectionOpen
        this.section1.iconName = this.section1.isSectionOpen ? 'utility:up' : 'utility:down'
        //:'utility:down',
        // });
        //console.log('after modify section1=', JSON.stringify(this.section1));

    }
    expandHandler2(event) {
        this.section2.isSectionOpen = !this.section2.isSectionOpen
        this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    expandHandler3() {
        this.section3.isSectionOpen = !this.section3.isSectionOpen
        this.section3.iconName = this.section3.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    handleHkgGoodsExported(e) {
        this.hkg_goods_exported = e.detail.selectedValue;
    }

    addRow() {


        //var i = JSON.parse(JSON.stringify(this.index));
        var i = this.index;
        //console.log('i=', i);


        /*this.accountList.push ({
            sobjectType: 'Account',
            Name: '',
            AccountNumber : '',
            Phone: '',
            key : i
        });*/
        this.inv.key = i;
        this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));

        //console.log('Enter ', JSON.stringify(this.invoiceList));
        this.index = this.index + 1;

    }
    removeRow(event) {
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if (this.invoiceList.length > 1) {
            this.invoiceList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        } else if (this.invoiceList.length == 1) {
            this.invoiceList = [];
            this.index = 0;
            this.isLoaded = false;
        }

        //this.dispatchEvent(new CustomEvent('deleterow', {detail: this.index}));
        ////console.log(' After adding Record List ', this.dispatchEvent);
    }
    handleInvoiceDate(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceDate = e.target.value;
    }
    handleInvoiceValue(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceAmount = e.target.value;
    }
    handleInvoiceCurrencyChange(e) {
        //console.log("handleInvoiceCurrencyChange");
        //console.log("currency type", e.target.value);
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        //console.log('key', key);
        //console.log('this.invoiceList', JSON.stringify(this.invoiceList));
        try {
            this.invoiceList[key].InvoiceCurrency = e.target.value;
        } catch (exception) {
            //console.log('exception', JSON.stringify(exception));
            console.error('exception', JSON.stringify(exception));
        }
        //console.log('this.invoiceList', JSON.stringify(this.invoiceList));
    }
    handleInvoicePaymentTermChange(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].PaymentTermsType = e.target.value;
    }
    handleInvoicePaymentTermDays(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].PaymentTermsDays = e.target.value;
    }
    handleInvoiceDueDate(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceDueDate = e.target.value;
    }
    handleInvoiceRemarks(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceRemark = e.target.value;
    }
    handleCreditLimitExist(e) {
        this.existing_buyer_list = [];
        //console.log('handleCreditLimitExist');
        this.is_credit_limit_exist = e.detail.selectedValue;
        if (this.is_credit_limit_exist === 'Yes') {
            this.existing_buyer_list = this.buyer_info.map((buyer) => ({ label: buyer.Buyer_Name__c, value: buyer.Buyer_Code__c }));
            //console.log('existing_buyer_list', JSON.stringify(this.existing_buyer_list));
            this.show_buyer_select = true;
            this.enable_buyer_edit = false;
            this.manual_buyer_input = false;
            this.show_buyer_section = false;
            this.show_buyer_search_link = false;
            this.uplift_reapply = this.label.Reapply;
        } else {
            this.existing_buyer_list = [];
            this.show_buyer_select = false;
            this.show_buyer_section = true;
            this.enable_buyer_edit = true;
            this.manual_buyer_input = true;
            this.show_buyer_search_link = true;
            //--------remove buyer info
            this.buyer_address_line1 = '';
            this.buyer_address_line2 = '';
            this.buyer_address_line3 = '';
            this.buyer_address_line4 = '';
            this.buyer_code = '';
            this.buyer_name = '';
            this.buyer_country = '';
            this.registration_no = '';
            this.uplift_reapply = '';
        }
    }
    handleBuyerChange(e) {
        //console.log('selected buyer=', e.detail.value);
        var selected_buyer_code = e.detail.value;
        let self = this;
        this.buyer_info.map((buyer) => {
            if (buyer.Buyer_Code__c === selected_buyer_code) {
                // console.log('selected buyer=', JSON.stringify(buyer));
                self.credit_limit_id = buyer.Id;
                self.isClUplifted = buyer.Is_Uplifted__c;
                self.clExpiryDate = buyer.Expiry_Date__c;
                self.clEffectiveDate = buyer.CL_Effective_Date__c;
                if (buyer.Buyer_Address_Line_1__c) {
                    self.buyer_address_line1 = buyer.Buyer_Address_Line_1__c;
                }
                if (buyer.Buyer_Address_Line_2__c) {
                    self.buyer_address_line2 = buyer.Buyer_Address_Line_2__c;
                }
                if (buyer.Buyer_Address_Line_3__c) {
                    self.buyer_address_line3 = buyer.Buyer_Address_Line_3__c;
                }
                if (buyer.Buyer_Address_Line_4__c) {
                    self.buyer_address_line4 = buyer.Buyer_Address_Line_4__c;
                }
                if (buyer.Buyer_Code__c) {
                    self.buyer_code = buyer.Buyer_Code__c;
                }
                if (buyer.Buyer_Name__c) {
                    self.buyer_name = buyer.Buyer_Name__c;
                }
                if (buyer.Buyer_Country__c) {
                    self.buyer_country = buyer.Buyer_Country__c;
                }
                // if (buyer.Buyer_Registration_Number__c) {
                //     self.registration_no = buyer.Buyer_Registration_Number__c;
                // }
            }
        });
        this.show_buyer_select = false;
        this.show_buyer_section = true;
    }
    handleEdit(e) {
        this.enable_buyer_edit = true;
    }
    handleUpliftReapplyChange(e) {
        this.uplift_reapply = e.detail.selectedValue;
    }

    handleExportTypeChange(e) {
        this.exportType = e.detail.selectedValue;
        //console.log("handleExportTypeChange selected export type ", e.detail.selectedValue);
        if (this.exportType === "Export of Services") {
            this.user_type = this.label.Client;
            this.label_payment_term_info = this.label.OA_90days;
            this.hide_payment_term_info_icon = true;
            this.show_payment_term_info = false;
            this.hide_country_lists = true;
            this.label_unpaid_shipment = "invoices for services rendered";
            this.is_service = true;
            this.is_postshipment = false;
            this.is_preshipment = false;
        } else {
            this.user_type = this.label.Buyer;
            this.label_payment_term_info = this.label.Payment_Term_OA_DA_DP_90_days;
            this.hide_payment_term_info_icon = false;
            this.hide_country_lists = false;
            this.label_unpaid_shipment = "shipments";
            if (this.exportType === 'Export Goods(Post-shipment risk only)') {
                this.is_service = false;
                this.is_postshipment = true;
                this.is_preshipment = false;
            } else if (this.exportType === 'Export Goods(Pre-shipment and Post-shipment risk)') {
                this.is_service = false;
                this.is_postshipment = false;
                this.is_preshipment = true;
            }
        }
    }
    handleCLAmountChange(e) {
        this.application_amount = e.target.value;
        this.application_amount = this.application_amount.toLocaleString();
    }
    handleCLAPreShipmentAmountChange(e) {
        this.application_amount_pre_shipment = e.target.value;
    }
    handleOriginCountryChange(e) {
        this.country_origin = e.target.value;
    }
    handleBuyerCountryChange(e) {
        //console.log("country", e.target.value);
        this.buyer_country = e.target.value;
        this.show_qs_4_5 = this.buyer_country === 'HKG' ? true : false;
        let self = this;
        this.buyer_country_options.map((country)=>{if(country.value === self.buyer_country){self.legacy_buyer_country = country.code}});
    }
    handleShipmentCountryChange(e) {
        this.shipment_country = e.target.value;
    }
    handleDestinationCountryChange(e) {
        this.destination_country = e.target.value;
    }
    handlePaymentTermChange(e) {
        this.payment_terms_value = e.target.value;
    }
    handlePaymentTermDaysChange(e) {
        this.payment_terms_days = e.target.value;
    }
    handlePreShipmentPaymentTermChange(e) {
        this.payment_terms_value_pre_shipment = e.target.value;
    }
    handlePreShipmentPaymentTermDaysChange(e) {
        this.payment_terms_days_pre_shipment = e.target.value;
    }
    handleNewBuyer(e) {
        this.is_new_buyer = e.detail.selectedValue;
        if (this.is_new_buyer === 'Yes') {
            this.show_new_buyer_detail = false;
        } else {
            this.show_new_buyer_detail = true;
        }
    }
    handleShipmentPaymentTerm(e) {
        this.shipment_payment_terms_value = e.target.value;
    }
    handleShipmentPaymentTermAmount(e) {
        this.shipment_payment_terms_amount = e.target.value;
    }
    handleShipmentPaymentTermDays(e) {
        this.shipment_payment_terms_days = e.target.value;
    }


    handleOrderPaymentTermsAmount12Months(e) {
        this.order_payment_terms_amount_12months = e.target.value;
    }
    handleOrderPaymentTermType12Months(e) {
        this.order_payment_terms_type_12months = e.target.value;
    }
    handleOrderPaymentTermMethod112Months(e) {
        if (e.target.checked) {
            this.order_payment_term_method1_12months = 'ILC';
        } else {
            this.order_payment_term_method1_12months = '';
        }
    }
    handleOrderPaymentTermMethod212Months(e) {
        if (e.target.checked) {
            this.order_payment_term_method2_12months = 'Payment in advance';
        } else {
            this.order_payment_term_method2_12months = '';
        }
    }
    handleShipmentPaymentTermMethod1(e) {
        if (e.target.checked) {
            this.shipment_payment_term_method1 = 'ILC';
        } else {
            this.shipment_payment_term_method1 = '';
        }
        //console.log('handleShipmentPaymentTermMethod1', this.shipment_payment_term_method1)
    }
    handleShipmentPaymentTermMethod2(e) {
        if (e.target.checked) {
            this.shipment_payment_term_method2 = 'Payment in advance';
        } else {
            this.shipment_payment_term_method2 = '';
        }
        //console.log('handleShipmentPaymentTermMethod2', this.shipment_payment_term_method2)
    }

    handleShipmentPaymentTermMethod3(e) {
        if (e.target.checked) {
            this.shipment_payment_term_method3 = 'DA';
        } else {
            this.shipment_payment_term_method3 = '';
        }

    }
    handleShipmentPaymentTermMethod4(e) {
        if (e.target.checked) {
            this.shipment_payment_term_method4 = 'DP';
        } else {
            this.shipment_payment_term_method4 = '';
        }
    }
    handleShipmentPaymentTermMethod5(e) {
        if (e.target.checked) {
            this.shipment_payment_term_method5 = 'OA';
        } else {
            this.shipment_payment_term_method5 = '';
        }
    }
    handleConfirmOrderPaymentTermMethod1(e) {
        if (e.target.checked) {
            this.confirm_order_payment_terms_method1 = 'ILC';
        } else {
            this.confirm_order_payment_terms_method1 = '';
        }
        //console.log('handleShipmentPaymentTermMethod1', this.shipment_payment_term_method1)
    }
    handleConfirmOrderPaymentTermMethod2(e) {
        if (e.target.checked) {
            this.confirm_order_payment_terms_method2 = 'Payment in advance';
        } else {
            this.confirm_order_payment_terms_method2 = '';
        }
        //console.log('handleShipmentPaymentTermMethod1', this.shipment_payment_term_method1)
    }
    handleConfirmOrderPaymentTermMethod3(e) {
        if (e.target.checked) {
            this.confirm_order_payment_terms_method3 = 'DA';
        } else {
            this.confirm_order_payment_terms_method3 = '';
        }
    }
    handleConfirmOrderPaymentTermMethod4(e) {
        if (e.target.checked) {
            this.confirm_order_payment_terms_method4 = 'DP';
        } else {
            this.confirm_order_payment_terms_method4 = '';
        }
    }
    handleConfirmOrderPaymentTermMethod5(e) {
        if (e.target.checked) {
            this.confirm_order_payment_terms_method5 = 'OA';
        } else {
            this.confirm_order_payment_terms_method5 = '';
        }
    }
    handleUnilaterallyCancelOrder(e) {
        this.unilaterally_cancel_order = e.detail.selectedValue;
    }
    handleOverduePaymentOrder(e) {
        this.overdue_payment_order = e.detail.selectedValue;
    }
    handleUnpaidAmountChange(e) {
        this.unpaid_amount = e.detail.selectedValue;
        //console.log("Unpaid amount change", this.unpaid_amount);
        if (this.unpaid_amount === "Yes") {
            this.flag_unpaid_shipment = true;

            var i = this.index;

            this.inv.key = i;
            this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));
            this.index++;
        } else {
            this.flag_unpaid_shipment = false;
            this.index = 0;
            this.invoiceList = [];

        }
    }
    handleBuyerTradingTime(e) {
        this.buyer_trading_time = e.target.value;
    }
    handlePaymentTermAmount(e) {
        this.payment_term_amount = e.target.value;
    }
    handleUnpaidShipmentChange(e) {
        this.unpaid_shipment = e.detail.selectedValue;
        //console.log("Unpaid shipment change", this.unpaid_shipment);
        if (this.unpaid_shipment === "Yes") {
            this.flag_unpaid_shipment = true;
            this.index++;

            var i = this.index;

            this.inv.key = i;
            this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));
        } else {
            this.flag_unpaid_shipment = false;
            this.index = 0;
            this.invoiceList = [];

        }
    }
    handleOrderConfirmNegotiationChange(e) {
        this.order_confirm_negotiation_value = e.target.value;
        if (this.order_confirm_negotiation_value.substring(0, 3) === 'Yes') {
            this.show_order_confirm_negotiation_detail = true;
        } else {
            this.show_order_confirm_negotiation_detail = false;
        }
        if (this.order_confirm_negotiation_value === 'Yes, orders confirmed'){
            this.mandatory_mark = '*'
        } else {
            this.mandatory_mark = ''
        }
    }
    handlePaymentTermOrderAmount(e) {
        this.payment_term_order_amount = e.target.value;
    }
    handleOrderPaymentTermChange(e) {
        this.order_payment_terms_value = e.target.value;
    }
    handleOrderPanymentTermDays(e) {
        this.order_payment_term_days = e.target.value;
    }
    handlePaymentTermOrderType(e) {
        this.order_payment_term_type = e.target.value;
    }
    handleShipmentCommenceMonth(e) {
        this.shipment_commencement_month = e.target.value;
        //console.log('month=', e.target.value);
    }
    handleShipmentCommenceYear(e) {
        this.shipment_commencement_year = e.target.value;
        //console.log('year=', e.target.value);
    }
    handleRemarks(e) {
        this.remarks = e.target.value;
    }
    handleReceivedPaymentAmount(e) {
        this.received_payment_amount = e.target.value;
    }
    handleReceivedPaymentTermChange(e) {
        this.received_payment_term = e.target.value;
    }
    handleAllCorrectChange(e) {
        this.all_correct_consign = !this.all_correct_consign;
        //console.log("updated val", this.all_correct_consign);
        if ((this.annual_sales === true) && (this.all_correct_consign === true)) {
            this.submit_enable = true;
        } else {
            this.submit_enable = false;
        }
    }
    handleAnualSalesChange(e) {
        this.annual_sales = !this.annual_sales;
        //console.log("annual sales", this.annual_sales);
        if ((this.annual_sales === true) && (this.all_correct_consign === true)) {
            this.submit_enable = true;
        } else {
            this.submit_enable = false;
        }
    }

    handleBuyerNameChange(e) {
        this.buyer_name = e.target.value;
        this.buyer_code = '';
    }
    handleApplicationAmountInfo(e) {
        this.show_application_amount_info = true;
    }
    handlePaymentTermInfo(e) {
        this.show_payment_term_info = true;
    }
    handlePolicyHolder(e) {
        this.policy_holder = e.target.value;
    }
    handleBuyercodeChange(event) {
        this.buyer_code = event.target.value;
    }

    handleBuyerAddressEnglishL1(e) {
        this.buyer_address_line1 = e.target.value;
        this.buyer_code = '';
    }
    handleBuyerAddressEnglishL2(e) {
        this.buyer_address_line2 = e.target.value;
        this.buyer_code = '';
    }
    handleBuyerAddressEnglishL3(e) {
        this.buyer_address_line3 = e.target.value;
        this.buyer_code = '';
    }
    handleBuyerAddressEnglishL4(e) {
        this.buyer_address_line4 = e.target.value;
        this.buyer_code = '';
    }
    // handleApplicationAmount(e) {
    //     let amount = e.target.value
    //     this.application_amount = amount.replace('$', '');
    // }
    handleRegistration(e) {
        this.registration_no = e.target.value;
    }
    handleHarmonizedCode(e) {
        this.harmonized_code = e.target.value;
    }
    handleGoods(e) {
        this.goods_involved = e.target.value;
        if (this.goods_involved === 'Miscellaneous (Products)') {
            this.is_miscellaneous = true;
        } else {
            this.is_miscellaneous = false;
        }
    }
    handleGoodsSpecify(e) {
        this.specific_goods_involved = e.target.value;
    }
    searchValidation(){
        let form_valid = true;
        if(this.buyer_country.trim() === ''){
            form_valid = false;
            let msg = 'Please select buyer country.';
            this.showToast(msg);
        } else if((this.search_buyer_name.length<5)&&(this.search_buyer_reg_no.length<5)){
            form_valid = false;
            let msg = 'Minimum 5 characters required for searrch.';
            this.showToast(msg);
        }
        return form_valid;
    }
    handleSearchBuyerName(e) {
        this.search_buyer_name = e.target.value;//search_buyer_reg_no_disable
        if(this.search_buyer_name.length > 0)
            this.search_buyer_reg_no_disable = true;
        else
            this.search_buyer_reg_no_disable = false;
    }
    handleSearchRegno(e) {
        this.search_buyer_reg_no = e.target.value;
        if(this.search_buyer_reg_no.length > 0)
            this.search_buyer_name_disable = true;
        else
            this.search_buyer_name_disable = false;
    }
    callserchBuyerDetailsAura(){
        let country_code = '';
        let self = this;
        this.buyer_search_loading = true;
        this.buyer_country_options.map((each_el)=>{
            if(self.buyer_country === each_el.value){
                country_code = each_el.code;
            }
        })
        
        serchBuyerDetailsAura({
            'buyer_country': country_code,
            'buyer_name': this.search_buyer_name,
            'br_no': this.search_buyer_reg_no
        }).then((result) => {
            console.log('serchBuyerDetailsAura response=',result);
            this.buyer_search_loading = false;
            let buyer_list = JSON.parse(result);
            if(buyer_list.meta_data.byr_list.length>0) {
                let buyer_search_list = buyer_list.meta_data.byr_list;
                buyer_search_list.map((each_el,i)=>{
                    self.buyer_search_result.push({...each_el,'index':i+1})
                });
                console.log('buyer_search_result formatted=',JSON.stringify(this.buyer_search_result));
            }
        })
            .catch((error) => {
                //console.log("error in serchBuyerDetailsAura", JSON.stringify(error));
                console.error("error in serchBuyerDetailsAura", JSON.stringify(error));
            });
    }
    handleBuyerSearch(e) {
        if(this.searchValidation()){
            // this.callserchBuyerDetailsAura();
            this.buyer_search_result = [];
            this.showBuyerModal = true;
            /*this.buyer_search_result.push({
                'buyer_name': 'ABC Buyer',
                'buyer_code': '12345',
                'buyer_address1': 'Unit 123',
                'buyer_address2': '456 Dune street',
                'buyer_address3': 'Michigan',
                'buyer_address4': 'USA',
                'buyer_country': 'United States of America',
                'buyer_reg_no': 'R7979'
            });
            this.buyer_search_result.push({
                'buyer_name': 'LPG Buyer',
                'buyer_code': '90505',
                'buyer_address1': 'Unit 123',
                'buyer_address2': '90 jkl st.',
                'buyer_address3': 'California',
                'buyer_address4': 'USA',
                'buyer_country': 'United States of America',
                'buyer_reg_no': 'R8080'
            });*/
        }
    }
    handleShowBuyerSearch() {
        this.search_buyer = true;
    }
    handleBuyerSelect(e) {
        console.log('handleBuyerSelect, buyer code=', e.currentTarget.dataset.id);
        let selected_buyer_index = e.currentTarget.dataset.id;
        console.log('selected_buyer_index='+selected_buyer_index);
        let self = this;
        this.buyer_search_result.map((buyer) => {
            if (buyer.index == selected_buyer_index) {
                if (buyer.byr_addr_1) {
                    self.buyer_address_line1 = buyer.byr_addr_1;
                }
                if (buyer.byr_addr_2) {
                    self.buyer_address_line2 = buyer.byr_addr_2;
                }
                if (buyer.byr_addr_3) {
                    self.buyer_address_line3 = buyer.byr_addr_3;
                }
                if (buyer.byr_addr_4) {
                    self.buyer_address_line4 = buyer.byr_addr_4;
                }
                if (buyer.byr_code) {
                    self.buyer_code = buyer.byr_code;
                }
                if (buyer.byr_name) {
                    self.buyer_name = buyer.byr_name;
                }
                if (buyer.duns_no) {
                    self.duns_no = buyer.duns_no;
                }
                if (buyer.source) {
                    self.buyer_source = buyer.source;
                }
                if (buyer.agency_ref) {
                    self.buyer_agency_ref = buyer.agency_ref;
                }
                // if (buyer.buyer_country) {
                //     self.buyer_country = buyer.buyer_country;
                // }
                // if (buyer.buyer_reg_no) {
                //     self.registration_no = buyer.buyer_reg_no;
                // }
            }
        });
        this.showBuyerModal = false;
        this.search_buyer = false;
        this.enable_buyer_edit = false;
    }

    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;
    }
    formatDate() {
        //console.log('formatDate');
        let d = new Date();
        let month = '' + (d.getMonth() + 1);
        let day = '' + d.getDate();
        let year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;
        return [year, month, day].join('-');
    }
    getDaysBetween(first_day, second_day) {
        const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
        const diffDays = Math.round(Math.abs((first_day - second_day) / oneDay));
        // //console.log('getDaysBetween diffDays=',diffDays);
        return diffDays;
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
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
    checkValidation() {
        try {
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
            var yyyy = today.getFullYear();
            today = yyyy + '-' + mm + '-' + dd;
            //console.log('checking validation');
            let form_valid = true;
            // //console.log('this.harmonized_code',this.harmonized_code);
            // //console.log('this.harmonized_code.length',this.harmonized_code.length);
            //console.log('this.uplift_reapply', this.uplift_reapply);
            //console.log('isClUplifted=', this.isClUplifted);
            /*if ((this.harmonized_code === "") || (this.harmonized_code.trim().length === 0)) {
                form_valid = false;//`[data-id="${harmonized_code}"]`
                //this.template.querySelector("lightning-input[data-id='${harmonized_code}']").focus();
                //console.log('harmonised code error');
                this.showToast("Please Enter Harmonized Code");
                
            } else*/
            if (this.is_credit_limit_exist.trim() === '') {
                form_valid = false;
                let msg = 'Please select if you have a valid credit limit with this buyer or not.';
                this.showToast(msg);
            } else if (this.buyer_country.trim() === '') {
                form_valid = false;
                let msg = 'Please Select buyer Country / Market';
                this.showToast(msg);
            } else if (this.buyer_name.trim().length < 3) {
                form_valid = false;
                let msg = 'Invalid Buyer Name.';
                this.showToast(msg);
            } else if (this.buyer_address_line1.trim().length < 2) {
                form_valid = false;
                let msg = 'Invalid Buyer Address.';
                this.showToast(msg);
            } else if ((this.application_amount === '') || (this.application_amount <= 0)) {
                form_valid = false;
                let msg = 'Invalid Application Amount.';
                this.showToast(msg);
            } else if (this.goods_involved.trim() === '') {
                form_valid = false;
                let msg = 'Please select Goods Involved.';
                this.showToast(msg);
            } else if ((this.goods_involved.trim() === 'Miscellaneous (Products)') && (this.specific_goods_involved.trim() === '')) {
                form_valid = false;
                let msg = 'Please specify the goods.';
                this.showToast(msg);
            } else if (this.is_new_buyer === '') {
                form_valid = false;
                let msg = 'Please answer on - Is this your new buyer?';
                this.showToast(msg);
            } else if (this.is_new_buyer === 'No') {
                if ((this.buyer_trading_time === '' ) || (this.buyer_trading_time <= 0)){
                    form_valid = false;
                    let msg = 'Invalid answer of the question - How many years have you been trading with this buyer?';
                    this.showToast(msg);
                } else if ((this.shipment_payment_terms_amount === '') || (this.shipment_payment_terms_amount <= 0)) {
                    form_valid = false;
                    let msg = 'Invalid amount in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                    this.showToast(msg);
                } else if ((this.shipment_payment_term_method1 === '') && (this.shipment_payment_term_method2 === '') && (this.shipment_payment_term_method3 === '') && (this.shipment_payment_term_method4 === '') && (this.shipment_payment_term_method5 === '')){
                    form_valid = false;
                    let msg = 'Invalid payment term in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                    this.showToast(msg);
                } else if ((this.shipment_payment_terms_days === '') || (this.shipment_payment_terms_days <= 0)) {
                    form_valid = false;
                    let msg = 'Invalid amount in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                    this.showToast(msg);
                }
                if (this.unpaid_amount.trim() === '') {
                    form_valid = false;
                    let msg = 'Please answer the question : Is there any amount currently unpaid for more than 60 days from the due date for this buyer?';
                    this.showToast(msg);
                } else if ((this.unpaid_amount.trim() === 'Yes') && (this.invoiceList.length === 0)) {
                    form_valid = false;
                    let msg = 'Please provide Unpaid Shipment Details';
                    this.showToast(msg);
                }
                if ((this.unpaid_amount.trim() === 'Yes') && (this.invoiceList.length !== 0)) {
                    for (var i = 0; i < this.invoiceList.length; i++) {
    
                        if (!this.invoiceList[i].hasOwnProperty('InvoiceDate')) {
                            form_valid = false;
                            let msg = 'Invalid Shipment / Invoice date';
                            this.showToast(msg);
                        } else if (!this.invoiceList[i].hasOwnProperty('InvoiceCurrency')){
                            form_valid = false;
                            let msg = 'Invalid Gross Invoice Value (Currency)';
                            this.showToast(msg);
                        } else if ((!this.invoiceList[i].hasOwnProperty('InvoiceAmount')) || (!this.invoiceList[i].hasOwnProperty('InvoiceAmount'))){
                            form_valid = false;
                            let msg = 'Invalid Gross Invoice Value (Amount)';
                            this.showToast(msg);
                        } else if (!this.invoiceList[i].hasOwnProperty('PaymentTermsType')){
                            form_valid = false;
                            let msg = 'Invalid Payment Terms';
                            this.showToast(msg);
                        } else if (!this.invoiceList[i].hasOwnProperty('PaymentTermsDays')){
                            form_valid = false;
                            let msg = 'Invalid Payment Terms Days';
                            this.showToast(msg);
                        } else if (!this.invoiceList[i].hasOwnProperty('InvoiceDueDate')) {
                            form_valid = false;
                            let msg = 'Invalid Due Date';
                            this.showToast(msg);
                        }
                        //console.log('InvoiceDate',this.invoiceList[i].InvoiceDate);
                        //console.log('InvoiceDueDate',this.invoiceList[i].InvoiceDueDate);
                        // console.log('Due date = ',this.getDaysBetween(new Date(today) , new Date(this.invoiceList[i].InvoiceDueDate)));
                        let due_date = this.getDaysBetween(new Date(today) , new Date(this.invoiceList[i].InvoiceDueDate));
                        if (due_date > 30) {
                            form_valid = false;
                            let msg = 'Credeit Limit can not be applied with due over 30 days.';
                            this.showToast(msg);
                        }
                        //             InvoiceDate: this.invoiceDate,
                        // InvoiceCurrency: this.invoiceCurrency,
                        // InvoiceAmount: this.invoiceAmount,
                        // PaymentTermsType: this.paymentTermsType,
                        // PaymentTermsDays: this.paymentTermsDays,
                        // InvoiceDueDate: this.invoiceDueDate,
                        // InvoiceRemark: this.invoiceRemark
                    }
                    
                }
            }
            
            if (this.order_confirm_negotiation_value.trim() === '') {
                form_valid = false;
                let msg = 'Please answer the question - Do you have any orders confirmed/ negotiation with this buyer?';
                this.showToast(msg);
            } else if (this.order_confirm_negotiation_value === 'Yes, orders confirmed') {
                if ((this.payment_term_order_amount === '') || (this.payment_term_order_amount <= 0)) {
                    form_valid = false;
                    let msg = 'Invalid amount in - Please provide the amount and payment terms of the orders';
                    this.showToast(msg);
                } else if ((this.confirm_order_payment_terms_method1 === '') && (this.confirm_order_payment_terms_method2 === '') && (this.confirm_order_payment_terms_method3 === '') && (this.confirm_order_payment_terms_method4 === '') && (this.confirm_order_payment_terms_method5 === '')){
                    form_valid = false;
                    let msg = 'Invalid payment term in - Please provide the amount and payment terms of the orders';
                    this.showToast(msg);
                } /*else if ((this.order_payment_term_days === '') || (this.order_payment_term_days <= 0)) {
                    form_valid = false;
                    let msg = 'Invalid amount in - Please provide the amount and payment terms of the orders';
                    this.showToast(msg);
                }*/ 
            }
            
            if (this.uplift_reapply === 'Reapply') {
                //console.log('reapply error');
                if ((this.unpaid_amount === 'Yes') || (this.unpaid_shipment === 'Yes')) {
                    //console.log('unpaid error');
                    form_valid = false;
                    let msg = 'This credit limit cannot be reapplied.';
                    this.showToast(msg);
                } else {
                    this.unpaid_amount = 'No';
                    this.unpaid_shipment = 'No';
                }
            }
            //console.log('form_valid', form_valid);
            return form_valid;
        } catch (error) {
            //console.log('error=', JSON.stringify(error));
            console.error('error=', JSON.stringify(error));
        }
    }

    handleNext() {
        try {
            //console.log('this.exportType', this.exportType);
            //console.log('this.goods_involved', this.goods_involved);
            //console.log('is_new_buyer', this.is_new_buyer);
            //console.log('this.buyer_trading_time', this.buyer_trading_time);
            //console.log('this.payment_term_amount', this.payment_term_amount);
            //console.log('this.unpaid_amount', this.unpaid_amount);
            //console.log('this.invoiceList', this.invoiceList);
            //console.log('this.payment_term_order_amount', this.payment_term_order_amount);
            //console.log('this.shipment_commencement_month', this.shipment_commencement_month);
            //console.log('this.shipment_commencement_year', this.shipment_commencement_year);
            //console.log('remarks', this.remarks);
            //console.log('this.specific_goods_involved', this.specific_goods_involved);
            if (this.checkValidation()) {
                var fields = {
                    draft_id: this.draft_id,
                    acc_id: this.acc_id,
                    credit_limit_id: this.credit_limit_id,
                    application_amount: this.application_amount,
                    exportType: this.exportType,
                    buyer_address_line1: this.buyer_address_line1,
                    buyer_address_line2: this.buyer_address_line2,
                    buyer_address_line3: this.buyer_address_line3,
                    buyer_address_line4: this.buyer_address_line4,
                    buyer_code: this.buyer_code,
                    buyer_name: this.buyer_name,
                    buyer_country: this.buyer_country,
                    legacy_buyer_country: this.legacy_buyer_country,
                    duns_no: this.duns_no,
                    buyer_source: this.buyer_source,
                    buyer_agency_ref: this.buyer_agency_ref,
                    registration_no: this.registration_no,
                    harmonized_code: this.harmonized_code,
                    payment_terms_value: this.payment_terms_value,
                    payment_terms_days: this.payment_terms_days,
                    shipment_country: this.shipment_country,
                    destination_country: this.destination_country,
                    country_origin: this.country_origin,
                    pending_invoice_list: this.invoiceList,
                    is_credit_limit_exist: this.is_credit_limit_exist,
                    uplift_reapply: this.uplift_reapply,
                    unpaid_amount: this.unpaid_amount,
                    unpaid_shipment: this.unpaid_shipment,
                    goods_involved: this.goods_involved,
                    specific_goods_involved: this.specific_goods_involved,
                    is_new_buyer: this.is_new_buyer,
                    buyer_trading_time: this.buyer_trading_time,
                    payment_term_amount: this.payment_term_amount,
                    payment_term_order_amount: this.payment_term_order_amount,
                    shipment_commencement_year: this.shipment_commencement_year,
                    remarks: this.remarks,

                    shipment_payment_terms_amount: this.shipment_payment_terms_amount,
                    shipment_payment_terms_value: this.shipment_payment_terms_value,
                    shipment_payment_terms_days: this.shipment_payment_terms_days,
                    payment_term_amount: this.payment_term_amount,
                    unilaterally_cancel_order: this.unilaterally_cancel_order,
                    overdue_payment_order: this.overdue_payment_order,
                    order_confirm_negotiation_value: this.order_confirm_negotiation_value,
                    payment_term_order_amount: this.payment_term_order_amount,
                    order_payment_terms_value: this.order_payment_terms_value,
                    order_payment_term_days: this.order_payment_term_days,
                    shipment_commencement_month: this.shipment_commencement_month,
                    received_payment_amount: this.received_payment_amount,
                    received_payment_term: this.received_payment_term,
                    hkg_goods_exported: this.hkg_goods_exported,

                    order_payment_terms_amount_12months: this.order_payment_terms_amount_12months,
                    order_payment_term_method1_12months: this.order_payment_term_method1_12months,
                    order_payment_term_method2_12months: this.order_payment_term_method2_12months,
                    order_payment_terms_type_12months: this.order_payment_terms_type_12months,
                    shipment_payment_term_method1: this.shipment_payment_term_method1,
                    shipment_payment_term_method2: this.shipment_payment_term_method2,
                    shipment_payment_term_method3: this.shipment_payment_term_method3,
                    shipment_payment_term_method4: this.shipment_payment_term_method4,
                    shipment_payment_term_method5: this.shipment_payment_term_method5,

                    confirm_order_payment_terms_method1: this.confirm_order_payment_terms_method1,
                    confirm_order_payment_terms_method2: this.confirm_order_payment_terms_method2,
                    confirm_order_payment_terms_method3: this.confirm_order_payment_terms_method3,
                    confirm_order_payment_terms_method4: this.confirm_order_payment_terms_method4,
                    confirm_order_payment_terms_method5: this.confirm_order_payment_terms_method5
                };
                //console.log('after json creation');
                var params = {
                    'cl_fields': fields,
                    'Pagename': 'ApplicationConfirmationSUP',
                    'policy_detail': this.policy_detail
                }
                let event1 = new CustomEvent('handlepagechange', {
                    // detail contains only primitives
                    detail: params
                });
                this.dispatchEvent(event1);
            }
        } catch (error) {
            //console.log('error=', JSON.stringify(error));
            console.error('error=', JSON.stringify(error));
        }
    }
    handleDraft() {
        var params = {
            'api_params': '',
            'Pagename': 'ApplicationDraft',
            'policy_detail': this.policy_detail
        }
        let event1 = new CustomEvent('handlepagechange', {
            detail: params
        });
        this.dispatchEvent(event1);
    }
    checkDraftValidation() {
        let form_valid = true;
        if (this.buyer_country.trim() === '') {
            form_valid = false;
            let msg = 'Please Select buyer Country / Market';
            this.showToast(msg);
        } else if (this.buyer_name.trim().length < 3) {
            form_valid = false;
            let msg = 'Invalid Buyer Name.';
            this.showToast(msg);
        } else if (this.buyer_address_line1.trim().length < 2) {
            form_valid = false;
            let msg = 'Invalid Buyer Address.';
            this.showToast(msg);
        }
        return form_valid;
    }

    handleSave() {
        if(this.checkDraftValidation()){
        this.loading = true;
        //console.log("handleSave");
        //console.log("policy_detail=", this.policy_detail);
        
        var fields = [];
        fields = {
            'Application_Type__c': this.uplift_reapply,
            'Is_Draft__c': true,
            'Application_Date__c': this.formatDate(),
            'Existing_valid_Credit_Limit_on_Buyer__c': this.is_credit_limit_exist,
            'Buyer_Address_Line_1__c': this.buyer_address_line1,
            'Buyer_Address_Line_2__c': this.buyer_address_line2,
            'Buyer_Address_Line_3__c': this.buyer_address_line3,
            'Buyer_Address_Line_4__c': this.buyer_address_line4,
            'Buyer_Code__c': this.buyer_code,
            'Buyer_Country__c': this.buyer_country,
            'Legacy_Buyer_Country__c': this.legacy_buyer_country,
            'Buyer_Name__c': this.buyer_name,
            'DNB_DUNS__c': this.duns_no,
            'Buyer_Source__c': this.buyer_source,
            'Agency_Ref__c': this.buyer_agency_ref,
            'CL_Amount__c': '',
            'CL_Application_Amount__c': this.application_amount,
            'CL_Status__c': '',
            'CL_Type__c': 'CLA',
            'Destination_Market__c': this.destination_country,
            'Export_Type__c': this.exportType,
            'Exporter__c': this.acc_id,
            'Harmonized_Code__c': this.harmonized_code,
            'Market_of_Origin__c': this.country_origin,
            'Payment_Term_Days__c': this.payment_terms_days,
            'Payment_Term_Type__c': this.payment_terms_value,
            'Policy__c': this.policy_detail.Id,
            'Policy_Fee__c': '',
            'Port_Of_Loading__c': this.shipment_country,
            'Premium__c': '',
            'Ref_No__c': '',
            'Buyer_Registration_Number__c' : this.registration_no,
            'Goods_or_Services_Involved__c': this.goods_involved,
            'Specific_Goods_Involved__c': this.specific_goods_involved,
            'Is_New_Buyer__c': this.is_new_buyer,
            'Buyer_Trading_Time__c': this.buyer_trading_time,
            'Shipment_Payment_Term_Amount_12_Months__c': this.shipment_payment_terms_amount,
            'Shipment_Payment_Term_Days_12_Months__c': this.shipment_payment_terms_days,
            'Shipment_Payment_Term_Type_12_Months__c': this.shipment_payment_terms_value,
            'Previously_Cancelled_Order_Unilaterally__c': this.unilaterally_cancel_order,
            'Unpaid_Overdue_Order__c': this.overdue_payment_order,
            'Shipment_Payment_Term_Method_12_Months1__c': this.shipment_payment_term_method1,
            'Shipment_Payment_Term_Method_12_Months2__c': this.shipment_payment_term_method2,
            'Shipment_Payment_Term_Method_12_Months3__c': this.shipment_payment_term_method3,
            'Shipment_Payment_Term_Method_12_Months4__c': this.shipment_payment_term_method4,
            'Shipment_Payment_Term_Method_12_Months5__c': this.shipment_payment_term_method5,
            'Order_Payment_Term_Amount_12_Months__c': this.order_payment_terms_amount_12months,
            'Order_Payment_Term_Method_12_Months1__c': this.order_payment_term_method1_12months,
            'Order_Payment_Term_Method_12_Months2__c': this.order_payment_term_method2_12months,
            'Order_Payment_Term_Type_12_Months__c': this.order_payment_terms_type_12months,
            'Confirm_Order_Payment_Terms_Method1__c': this.confirm_order_payment_terms_method1,
            'Confirm_Order_Payment_Terms_Method2__c': this.confirm_order_payment_terms_method2,
            'Confirm_Order_Payment_Terms_Method3__c': this.confirm_order_payment_terms_method3,
            'Confirm_Order_Payment_Terms_Method4__c': this.confirm_order_payment_terms_method4,
            'Confirm_Order_Payment_Terms_Method5__c': this.confirm_order_payment_terms_method5,
            
                        
            'Is_Unpaid_Amount__c': this.unpaid_amount,

            'Is_Unpaid_Shipment__c': this.unpaid_shipment,
            'Order_Confirmed_or_Negotiation__c': this.order_confirm_negotiation_value,
            'Order_Payment_Term_Days__c':this.order_payment_term_days,
            'Order_Payment_Term_Amount__c': this.payment_term_order_amount,
            'Order_Payment_Term_Type__c': this.order_payment_terms_value,
            'Shipment_Commence_Month__c': this.shipment_commencement_month,
            'Shipment_Commence_Year__c': this.shipment_commencement_year,
            'Remarks__c': this.remarks,
            'Received_Order_Amount__c': this.received_payment_amount,
            'Received_Order_Payment_Type__c': this.received_payment_term,
            'Overseas_Goods_or_Services__c': this.hkg_goods_exported

        }
        //console.log('Fields=',JSON.stringify(fields));
        var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
        createRecord(objRecordInput).then(response => {
            //console.log('cla created with Id: ' + response.id);  
            if (this.draft_id !== '') {
                DeleteDraft({
                    cla_id: this.draft_id
                }).then((result) => {
                    //console.log('Old draft deleted');
                })
                .catch((error) => {
                    //console.log('error on Old draft delete::', JSON.stringify(error));
                    console.error('error Old draft delete::', JSON.stringify(error));
                });
            }                      
            if (this.invoiceList.length > 0) {
                //console.log('outstanding payment exist');               
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
            //console.log('cla Error: ' + JSON.stringify(error));
            console.error('cla Error: ' + JSON.stringify(error));
        });    
    }    
    }
    callcreateOutstandingPaymentBuyer(cla_id) {
        createOutstandingPaymentBuyer({
            op_json: this.invoiceList,
            cla_id: cla_id
        }).then((result) => {
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
            .catch((error) => {
                //console.log("error in outstanding payment record creation", JSON.stringify(error));
                console.error("error in outstanding payment record creation", JSON.stringify(error));
            });
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
    callgetExistingBuyers() {
        getExistingBuyers({
            policy_id: this.policy_detail.Id
        })
            .then((result) => {
                //console.log("Existing buyer=", JSON.stringify(result));
                this.buyer_info = result;
            })
            .catch((error) => {
                //console.log('error::', JSON.stringify(error));
                console.error('error::', JSON.stringify(error));
            });
    }
    /*callgetCountryList() {
        getCountryList()
        .then((result) => {
            // //console.log("Country list=", JSON.stringify(result));
            this.countryOptions = result.map((country)=>({label:country.Full_Country_Name__c,value:country.Full_Country_Name__c,code:country.Country_Code__c}));
            this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
        })
        .catch((error) => {
            //console.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        });
    }*/
    renderedCallback() {
        if (!this.is_rendered) {

            this.is_rendered = true;
            //console.log("policyinfo=", JSON.stringify(this.policyinfo));

            if (Object.keys(this.policyinfo).length > 0) {
                let accId = this.policyinfo.accId;
                this.acc_id = this.policyinfo.accId;
                getPolicyDetails({
                    acc_id: accId
                })
                    .then((result) => {
                        //console.log("Policy details=", JSON.stringify(result));
                        this.policy_detail = result;
                        this.account_name = result.Exporter__r.Name;
                        this.policy_no = result.Legacy_Customer_Number__c;
                        this.policy_type = result.Product__r.Name;
                        this.available_credit_check_facility = result.Available_Credit_Check__c;
                        this.callgetExistingBuyers();
                        // this.callgetCountryList();
                    })
                    .catch((error) => {

                        //console.log(error);
                    });
                if (this.policyinfo.hasOwnProperty('clRecord')) {
                    //console.log('application_type=', this.policyinfo.clRecord[0].application_type);
                    if (this.policyinfo.clRecord[0].application_type === 'Uplift') {
                        this.isNewApplication = false;
                        this.credit_limit_record = this.policyinfo.clRecord[0];
                        //console.log('credit_limit_record=', JSON.stringify(this.credit_limit_record));

                        this.credit_limit_id = this.credit_limit_record.Id;
                        this.application_amount = this.credit_limit_record.CL_Application_Amount__c;
                        this.application_amount_min = this.application_amount;
                        this.exportType = this.credit_limit_record.Export_Type__c;
                        //console.log('export type', this.credit_limit_record.Export_Type__c);
                        this.buyer_address_line1 = this.credit_limit_record.Buyer_Address_Line_1__c;
                        //console.log('this.credit_limit_record.Buyer_Address_Line_1__c', this.credit_limit_record.Buyer_Address_Line_1__c);
                        this.buyer_address_line2 = this.credit_limit_record.Buyer_Address_Line_2__c;
                        this.buyer_address_line3 = this.credit_limit_record.Buyer_Address_Line_3__c;
                        this.buyer_address_line4 = this.credit_limit_record.Buyer_Address_Line_4__c;
                        this.buyer_code = this.credit_limit_record.Buyer_Code__c;
                        this.buyer_name = this.credit_limit_record.Buyer_Name__c;
                        this.buyer_country = this.credit_limit_record.Buyer_Country__c;
                        this.registration_no = this.credit_limit_record.Buyer_Registration_Number__c;
                        this.harmonized_code = this.credit_limit_record.Harmonized_Code__c;
                        this.payment_terms_value = this.credit_limit_record.Payment_Term_Type__c;
                        this.payment_terms_days = this.credit_limit_record.Payment_Term_Days__c;
                        this.shipment_country = this.credit_limit_record.Port_Of_Loading__c;
                        this.destination_country = this.credit_limit_record.Destination_Market__c;
                        this.country_origin = this.credit_limit_record.Market_of_Origin__c;
                        this.uplift_reapply = this.credit_limit_record.application_type;
                        this.clExpiryDate = this.credit_limit_record.Expiry_Date__c;
                        this.clApplicationDate = this.credit_limit_record.Application_Date__c;
                        this.show_buyer_section = true;
                        this.manual_buyer_input = false;
                        // this.show_buyer_select = true;
                    } else if (this.policyinfo.clRecord[0].application_type === 'Reapply') {
                        this.isNewApplication = false;
                        this.credit_limit_record = this.policyinfo.clRecord[0];
                        //console.log('credit_limit_record=', JSON.stringify(this.credit_limit_record));

                        this.credit_limit_id = this.credit_limit_record.Id;
                        this.application_amount = this.credit_limit_record.CL_Application_Amount__c;
                        // this.application_amount_min = this.application_amount;
                        this.exportType = this.credit_limit_record.Export_Type__c;
                        //console.log('export type', this.credit_limit_record.Export_Type__c);
                        this.buyer_address_line1 = this.credit_limit_record.Buyer_Address_Line_1__c;
                        this.buyer_address_line2 = this.credit_limit_record.Buyer_Address_Line_2__c;
                        this.buyer_address_line3 = this.credit_limit_record.Buyer_Address_Line_3__c;
                        this.buyer_address_line4 = this.credit_limit_record.Buyer_Address_Line_4__c;
                        this.buyer_code = this.credit_limit_record.Buyer_Code__c;
                        this.buyer_name = this.credit_limit_record.Buyer_Name__c;
                        this.buyer_country = this.credit_limit_record.Buyer_Country__c;
                        this.registration_no = this.credit_limit_record.Buyer_Registration_Number__c;
                        this.harmonized_code = this.credit_limit_record.Harmonized_Code__c;
                        this.payment_terms_value = this.credit_limit_record.Payment_Term_Type__c;
                        this.payment_terms_days = this.credit_limit_record.Payment_Term_Days__c;
                        this.shipment_country = this.credit_limit_record.Port_Of_Loading__c;
                        this.destination_country = this.credit_limit_record.Destination_Market__c;
                        this.country_origin = this.credit_limit_record.Market_of_Origin__c;
                        this.uplift_reapply = this.credit_limit_record.application_type;
                        this.clExpiryDate = this.credit_limit_record.Expiry_Date__c;
                        this.clApplicationDate = this.credit_limit_record.Application_Date__c;
                        this.show_buyer_section = true;
                        this.manual_buyer_input = false;
                        this.goods_involved = this.credit_limit_record.Goods_or_Services_Involved__c;
                        this.specific_goods_involved = this.credit_limit_record.Specific_Goods_Involved__c;

                        // this.show_buyer_select = true;
                    }
                } else if (this.policyinfo.hasOwnProperty('clRecordEdit')) {
                    //console.log('Edit section');
                    let clrecordEditInfo = this.policyinfo.clRecordEdit;
                    //console.log('clrecordEditInfo', JSON.stringify(clrecordEditInfo));
                    let new_inv_list = [];
                    this.show_buyer_section = true;
                    this.manual_buyer_input = false;

                    this.application_amount = clrecordEditInfo.application_amount;
                    this.exportType = clrecordEditInfo.exportType;
                    this.buyer_address_line1 = clrecordEditInfo.buyer_address_line1;
                    this.buyer_address_line2 = clrecordEditInfo.buyer_address_line2;
                    this.buyer_address_line3 = clrecordEditInfo.buyer_address_line3;
                    this.buyer_address_line4 = clrecordEditInfo.buyer_address_line4;
                    this.buyer_code = clrecordEditInfo.buyer_code;
                    this.buyer_name = clrecordEditInfo.buyer_name;
                    this.buyer_country = clrecordEditInfo.buyer_country;
                    this.legacy_buyer_country = clrecordEditInfo.legacy_buyer_country;
                    this.buyer_source = clrecordEditInfo.buyer_source;
                    this.duns_no = clrecordEditInfo.duns_no;
                    this.buyer_agency_ref = clrecordEditInfo.buyer_agency_ref;
                    this.registration_no = clrecordEditInfo.registration_no;
                    this.harmonized_code = clrecordEditInfo.harmonized_code;
                    this.payment_terms_value = clrecordEditInfo.payment_terms_value;
                    this.payment_terms_days = clrecordEditInfo.payment_terms_days;
                    this.shipment_country = clrecordEditInfo.shipment_country;
                    this.destination_country = clrecordEditInfo.destination_country;
                    this.country_origin = clrecordEditInfo.country_origin;
                    new_inv_list = clrecordEditInfo.pending_invoice_list;
                    this.is_credit_limit_exist = clrecordEditInfo.is_credit_limit_exist;
                    this.uplift_reapply = clrecordEditInfo.uplift_reapply;
                    this.unpaid_amount = clrecordEditInfo.unpaid_amount;
                    this.unpaid_shipment = clrecordEditInfo.unpaid_shipment;
                    this.goods_involved = clrecordEditInfo.goods_involved;
                    this.specific_goods_involved = clrecordEditInfo.specific_goods_involved;
                    this.is_new_buyer = clrecordEditInfo.is_new_buyer;
                    this.buyer_trading_time = clrecordEditInfo.buyer_trading_time;
                    this.payment_term_amount = clrecordEditInfo.payment_term_amount;
                    this.payment_term_order_amount = clrecordEditInfo.payment_term_order_amount;
                    this.shipment_commencement_year = clrecordEditInfo.shipment_commencement_year;
                    this.remarks = clrecordEditInfo.remarks;

                    this.shipment_payment_terms_amount = clrecordEditInfo.shipment_payment_terms_amount;
                    this.shipment_payment_terms_value = clrecordEditInfo.shipment_payment_terms_value;
                    this.payment_term_amount = clrecordEditInfo.payment_term_amount;
                    this.unilaterally_cancel_order = clrecordEditInfo.unilaterally_cancel_order;
                    this.overdue_payment_order = clrecordEditInfo.overdue_payment_order;
                    this.order_confirm_negotiation_value = clrecordEditInfo.order_confirm_negotiation_value;
                    this.payment_term_order_amount = clrecordEditInfo.payment_term_order_amount;
                    this.order_payment_terms_value = clrecordEditInfo.order_payment_terms_value;
                    this.shipment_commencement_month = clrecordEditInfo.shipment_commencement_month;
                    this.received_payment_amount = clrecordEditInfo.received_payment_amount;
                    this.received_payment_term = clrecordEditInfo.received_payment_term;
                    this.hkg_goods_exported = clrecordEditInfo.hkg_goods_exported;

                    this.order_payment_terms_amount_12months = clrecordEditInfo.order_payment_terms_amount_12months;
                    this.order_payment_term_method1_12months = clrecordEditInfo.order_payment_term_method1_12months;
                    this.order_payment_term_method2_12months = clrecordEditInfo.order_payment_term_method2_12months;
                    this.order_payment_terms_type_12months = clrecordEditInfo.order_payment_terms_type_12months;
                    this.shipment_payment_term_method1 = clrecordEditInfo.shipment_payment_term_method1;
                    this.shipment_payment_term_method2 = clrecordEditInfo.shipment_payment_term_method2;
                    this.shipment_payment_term_method3 = clrecordEditInfo.shipment_payment_term_method3;
                    this.shipment_payment_term_method4 = clrecordEditInfo.shipment_payment_term_method4;
                    this.shipment_payment_term_method5 = clrecordEditInfo.shipment_payment_term_method5;
                    this.confirm_order_payment_terms_method1 = clrecordEditInfo.confirm_order_payment_terms_method1;
                    this.confirm_order_payment_terms_method2 = clrecordEditInfo.confirm_order_payment_terms_method2;
                    this.confirm_order_payment_terms_method3 = clrecordEditInfo.confirm_order_payment_terms_method3;
                    this.confirm_order_payment_terms_method4 = clrecordEditInfo.confirm_order_payment_terms_method4;
                    this.confirm_order_payment_terms_method5 = clrecordEditInfo.confirm_order_payment_terms_method5;
                    this.shipment_payment_terms_days = clrecordEditInfo.shipment_payment_terms_days;
                    this.order_payment_term_days = clrecordEditInfo.order_payment_term_days;

                    if(this.goods_involved === 'Miscellaneous (Products)') {
                        this.is_miscellaneous = true;
                    } else {
                        this.is_miscellaneous = false;
                    } 
                    if (this.confirm_order_payment_terms_method1 === 'ILC') {
                        this.confirm_order_payment_terms_method1_id = true;
                    }
                    if (this.confirm_order_payment_terms_method2 === 'Payment in advance') {
                        this.confirm_order_payment_terms_method2_id = true;
                    }
                    if (this.confirm_order_payment_terms_method3 === 'DA') {
                        this.confirm_order_payment_terms_method3_id = true;
                    }
                    if (this.confirm_order_payment_terms_method4 === 'DP') {
                        this.confirm_order_payment_terms_method4_id = true;
                    }
                    if (this.confirm_order_payment_terms_method5 === 'OA') {
                        this.confirm_order_payment_terms_method5_id = true;
                    }
                    //------------------------------
                    if (this.shipment_payment_term_method1 === 'ILC') {
                        this.shipment_payment_term_method1_id = true;
                    }
                    if (this.shipment_payment_term_method2 === 'Payment in advance') {
                        this.shipment_payment_term_method2_id = true;
                    }
                    if (this.shipment_payment_term_method3 === 'DA') {
                        this.shipment_payment_term_method3_id = true;
                    }
                    if (this.shipment_payment_term_method4 === 'DP') {
                        this.shipment_payment_term_method4_id = true;
                    }
                    if (this.shipment_payment_term_method5 === 'OA') {
                        this.shipment_payment_term_method5_id = true;
                    }
                    //------------------------------
                    if (this.unpaid_amount === 'Yes') {
                        this.flag_unpaid_shipment = true;
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                        let self = this;
                        this.index = new_inv_list.length;
                        //console.log('new_inv_list.length=',new_inv_list.length);
                        new_inv_list.map((each_inv) => {
                            self.invoiceList.push({
                                key: each_inv.key,
                                InvoiceDate: each_inv.InvoiceDate,
                                InvoiceCurrency: each_inv.InvoiceCurrency,
                                InvoiceAmount: each_inv.InvoiceAmount,
                                PaymentTermsType: each_inv.PaymentTermsType,
                                PaymentTermsDays: each_inv.PaymentTermsDays,
                                InvoiceDueDate: each_inv.InvoiceDueDate,
                                InvoiceRemark: each_inv.InvoiceRemark
                            });
                        });
                        //console.log('this.invoiceList=',JSON.stringify(this.invoiceList));
                    } else {
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.is_new_buyer === 'No') {
                        this.show_new_buyer_detail = true;
                        this.new_buyer_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                        
                    } else {
                        this.show_new_buyer_detail = false;
                        this.new_buyer_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    }
                    if (this.is_credit_limit_exist === 'Yes') {
                        this.existing_credit_limit = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    } else {
                        this.existing_credit_limit = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.order_confirm_negotiation_value.substring(0, 3) === 'Yes') {
                        this.show_order_confirm_negotiation_detail = true;
                    }

                    /*let open_section = this.policyinfo.section;
                    if (open_section === 'section1') {
                        this.section1.isSectionOpen = true;
                        this.section1.iconName = 'utility:up';
                        this.section2.isSectionOpen = false;
                        this.section2.iconName = 'utility:down';
                        this.section3.isSectionOpen = false;
                        this.section3.iconName = 'utility:down';
                    } else if (open_section === 'section2') {
                        this.section2.isSectionOpen = true;
                        this.section2.iconName = 'utility:up';
                        this.section1.isSectionOpen = false;
                        this.section1.iconName = 'utility:down';
                    } else {
                        this.section3.isSectionOpen = true;
                        this.section3.iconName = 'utility:up';
                        this.section1.isSectionOpen = false;
                        this.section1.iconName = 'utility:down';
                        this.section2.isSectionOpen = false;
                        this.section2.iconName = 'utility:down';
                    }*/
                    //             this.section2.isSectionOpen = !this.section2.isSectionOpen
                    // this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
                } else if (this.policyinfo.hasOwnProperty('clRecordDraft')) {
                    let clrecordDraftInfo = this.policyinfo.clRecordDraft;
                    //console.log('clrecordEditInfo', JSON.stringify(clrecordDraftInfo));
                    let new_inv_list = [];
                    this.show_buyer_section = true;
                    this.manual_buyer_input = false;
                    this.draft_id = clrecordDraftInfo.Id;
                    
                    if(clrecordDraftInfo.CL_Application_Amount__c)
                        this.application_amount = clrecordDraftInfo.CL_Application_Amount__c;
                    if(clrecordDraftInfo.Export_Type__c)
                        this.exportType = clrecordDraftInfo.Export_Type__c;
                    if(clrecordDraftInfo.Buyer_Address_Line_1__c)
                        this.buyer_address_line1 = clrecordDraftInfo.Buyer_Address_Line_1__c;
                    if(clrecordDraftInfo.Buyer_Address_Line_2__c)
                        this.buyer_address_line2 = clrecordDraftInfo.Buyer_Address_Line_2__c;
                    if(clrecordDraftInfo.Buyer_Address_Line_3__c)
                        this.buyer_address_line3 = clrecordDraftInfo.Buyer_Address_Line_3__c;
                    if(clrecordDraftInfo.Buyer_Address_Line_4__c)
                        this.buyer_address_line4 = clrecordDraftInfo.Buyer_Address_Line_4__c;
                    if(clrecordDraftInfo.Buyer_Code__c)
                        this.buyer_code = clrecordDraftInfo.Buyer_Code__c;
                    if(clrecordDraftInfo.Buyer_Name__c)
                        this.buyer_name = clrecordDraftInfo.Buyer_Name__c;
                    if(clrecordDraftInfo.Buyer_Country__c)
                        this.buyer_country = clrecordDraftInfo.Buyer_Country__c;
                    if(clrecordDraftInfo.Legacy_Buyer_Country__c)
                        this.legacy_buyer_country = clrecordDraftInfo.Legacy_Buyer_Country__c;
                    if(clrecordDraftInfo.Buyer_Registration_Number__c)
                        this.registration_no = clrecordDraftInfo.Buyer_Registration_Number__c;
                    if(clrecordDraftInfo.Buyer_Source__c)
                        this.buyer_source = clrecordDraftInfo.Buyer_Source__c;
                    if(clrecordDraftInfo.DNB_DUNS__c)
                        this.duns_no = clrecordDraftInfo.DNB_DUNS__c;
                    if(clrecordDraftInfo.Agency_Ref__c)
                        this.buyer_agency_ref = clrecordDraftInfo.Agency_Ref__c;
                    if(clrecordDraftInfo.Harmonized_Code__c)
                        this.harmonized_code = clrecordDraftInfo.Harmonized_Code__c;
                    if(clrecordDraftInfo.Payment_Term_Type__c)
                        this.payment_terms_value = clrecordDraftInfo.Payment_Term_Type__c;
                    if(clrecordDraftInfo.Payment_Term_Days__c)
                        this.payment_terms_days = clrecordDraftInfo.Payment_Term_Days__c;
                    if(clrecordDraftInfo.Port_Of_Loading__c)
                        this.shipment_country = clrecordDraftInfo.Port_Of_Loading__c;
                    if(clrecordDraftInfo.Destination_Market__c)
                        this.destination_country = clrecordDraftInfo.Destination_Market__c;
                    if(clrecordDraftInfo.Market_of_Origin__c)
                        this.country_origin = clrecordDraftInfo.Market_of_Origin__c;
                    if(clrecordDraftInfo.Outstanding_Payments__r)
                        new_inv_list = clrecordDraftInfo.Outstanding_Payments__r;
                    if(clrecordDraftInfo.Existing_valid_Credit_Limit_on_Buyer__c)
                        this.is_credit_limit_exist = clrecordDraftInfo.Existing_valid_Credit_Limit_on_Buyer__c;
                    if(clrecordDraftInfo.Application_Type__c)
                        this.uplift_reapply = clrecordDraftInfo.Application_Type__c;
                    if(clrecordDraftInfo.Is_Unpaid_Amount__c)
                        this.unpaid_amount = clrecordDraftInfo.Is_Unpaid_Amount__c;
                    if(clrecordDraftInfo.Is_Unpaid_Shipment__c)
                        this.unpaid_shipment = clrecordDraftInfo.Is_Unpaid_Shipment__c;
                    if(clrecordDraftInfo.Goods_or_Services_Involved__c)
                        this.goods_involved = clrecordDraftInfo.Goods_or_Services_Involved__c;
                    if(clrecordDraftInfo.Specific_Goods_Involved__c)
                        this.specific_goods_involved = clrecordDraftInfo.Specific_Goods_Involved__c;
                    if(clrecordDraftInfo.Is_New_Buyer__c)
                        this.is_new_buyer = clrecordDraftInfo.Is_New_Buyer__c;
                    if(clrecordDraftInfo.Buyer_Trading_Time__c)
                        this.buyer_trading_time = clrecordDraftInfo.Buyer_Trading_Time__c;
                    // if(clrecordDraftInfo.Buyer_Trading_Time__c)
                    // this.payment_term_amount = clrecordDraftInfo.payment_term_amount;
                    if(clrecordDraftInfo.Order_Payment_Term_Amount__c)
                        this.payment_term_order_amount = clrecordDraftInfo.Order_Payment_Term_Amount__c;
                    if(clrecordDraftInfo.Shipment_Commence_Year__c)
                        this.shipment_commencement_year = clrecordDraftInfo.Shipment_Commence_Year__c.toString();
                    if(clrecordDraftInfo.Remarks__c)
                        this.remarks = clrecordDraftInfo.Remarks__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Amount_12_Months__c)
                        this.shipment_payment_terms_amount = clrecordDraftInfo.Shipment_Payment_Term_Amount_12_Months__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Type_12_Months__c)
                        this.shipment_payment_terms_value = clrecordDraftInfo.Shipment_Payment_Term_Type_12_Months__c;
                    // if(clrecordDraftInfo.Shipment_Payment_Term_Type_12_Months__c)
                    // this.payment_term_amount = clrecordDraftInfo.payment_term_amount;
                    if(clrecordDraftInfo.Previously_Cancelled_Order_Unilaterally__c)
                        this.unilaterally_cancel_order = clrecordDraftInfo.Previously_Cancelled_Order_Unilaterally__c;
                    
                    if(clrecordDraftInfo.Unpaid_Overdue_Order__c)
                        this.overdue_payment_order = clrecordDraftInfo.Unpaid_Overdue_Order__c;
                    if(clrecordDraftInfo.Order_Confirmed_or_Negotiation__c)
                        this.order_confirm_negotiation_value = clrecordDraftInfo.Order_Confirmed_or_Negotiation__c;
                    if(clrecordDraftInfo.Order_Payment_Term_Type__c)
                        this.order_payment_terms_value = clrecordDraftInfo.Order_Payment_Term_Type__c;
                    if(clrecordDraftInfo.Shipment_Commence_Month__c)
                        this.shipment_commencement_month = clrecordDraftInfo.Shipment_Commence_Month__c;
                    if(clrecordDraftInfo.Received_Order_Amount__c)
                        this.received_payment_amount = clrecordDraftInfo.Received_Order_Amount__c;
                    if(clrecordDraftInfo.Received_Order_Payment_Type__c)
                        this.received_payment_term = clrecordDraftInfo.Received_Order_Payment_Type__c;
                    if(clrecordDraftInfo.Order_Confirmed_or_Negotiation__c)
                        this.Overseas_Goods_or_Services__c = clrecordDraftInfo.hkg_goods_exported;

                    if(clrecordDraftInfo.Order_Payment_Term_Amount_12_Months__c)
                        this.order_payment_terms_amount_12months = clrecordDraftInfo.Order_Payment_Term_Amount_12_Months__c;
                    if(clrecordDraftInfo.Order_Payment_Term_Method_12_Months1__c)
                        this.order_payment_term_method1_12months = clrecordDraftInfo.Order_Payment_Term_Method_12_Months1__c;
                    if(clrecordDraftInfo.Order_Payment_Term_Method_12_Months2__c)
                        this.order_payment_term_method2_12months = clrecordDraftInfo.Order_Payment_Term_Method_12_Months2__c;
                    if(clrecordDraftInfo.Order_Payment_Term_Type_12_Months__c)
                        this.order_payment_terms_type_12months = clrecordDraftInfo.Order_Payment_Term_Type_12_Months__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months1__c)
                        this.shipment_payment_term_method1 = clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months1__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months2__c)
                        this.shipment_payment_term_method2 = clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months2__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months3__c)
                        this.shipment_payment_term_method3 = clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months3__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months4__c)
                        this.shipment_payment_term_method4 = clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months4__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months5__c)
                        this.shipment_payment_term_method5 = clrecordDraftInfo.Shipment_Payment_Term_Method_12_Months5__c;
                    if(clrecordDraftInfo.Confirm_Order_Payment_Terms_Method1__c)
                        this.Confirm_Order_Payment_Terms_Method1__c = clrecordDraftInfo.Confirm_Order_Payment_Terms_Method1__c;
                    if(clrecordDraftInfo.Confirm_Order_Payment_Terms_Method2__c)
                        this.confirm_order_payment_terms_method2 = clrecordDraftInfo.Confirm_Order_Payment_Terms_Method2__c;
                    if(clrecordDraftInfo.Confirm_Order_Payment_Terms_Method3__c)
                        this.confirm_order_payment_terms_method3 = clrecordDraftInfo.Confirm_Order_Payment_Terms_Method3__c;
                    if(clrecordDraftInfo.Confirm_Order_Payment_Terms_Method4__c)
                        this.confirm_order_payment_terms_method4 = clrecordDraftInfo.Confirm_Order_Payment_Terms_Method4__c;
                    if(clrecordDraftInfo.Confirm_Order_Payment_Terms_Method5__c)
                        this.confirm_order_payment_terms_method5 = clrecordDraftInfo.Confirm_Order_Payment_Terms_Method5__c;
                    if(clrecordDraftInfo.Shipment_Payment_Term_Days_12_Months__c)
                        this.shipment_payment_terms_days = clrecordDraftInfo.Shipment_Payment_Term_Days_12_Months__c;
                    if(clrecordDraftInfo.Order_Payment_Term_Days__c)
                        this.order_payment_term_days = clrecordDraftInfo.Order_Payment_Term_Days__c;

                    if(this.goods_involved === 'Miscellaneous (Products)') {
                        this.is_miscellaneous = true;
                    } else {
                        this.is_miscellaneous = false;
                    } 
                    if (this.confirm_order_payment_terms_method1 === 'ILC') {
                        this.confirm_order_payment_terms_method1_id = true;
                    }
                    if (this.confirm_order_payment_terms_method2 === 'Payment in advance') {
                        this.confirm_order_payment_terms_method2_id = true;
                    }
                    if (this.confirm_order_payment_terms_method3 === 'DA') {
                        this.confirm_order_payment_terms_method3_id = true;
                    }
                    if (this.confirm_order_payment_terms_method4 === 'DP') {
                        this.confirm_order_payment_terms_method4_id = true;
                    }
                    if (this.confirm_order_payment_terms_method5 === 'OA') {
                        this.confirm_order_payment_terms_method5_id = true;
                    }
                    //------------------------------
                    if (this.shipment_payment_term_method1 === 'ILC') {
                        this.shipment_payment_term_method1_id = true;
                    }
                    if (this.shipment_payment_term_method2 === 'Payment in advance') {
                        this.shipment_payment_term_method2_id = true;
                    }
                    if (this.shipment_payment_term_method3 === 'DA') {
                        this.shipment_payment_term_method3_id = true;
                    }
                    if (this.shipment_payment_term_method4 === 'DP') {
                        this.shipment_payment_term_method4_id = true;
                    }
                    if (this.shipment_payment_term_method5 === 'OA') {
                        this.shipment_payment_term_method5_id = true;
                    }
                    //------------------------------
                    if (this.unpaid_amount === 'Yes') {
                        this.flag_unpaid_shipment = true;
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                        let self = this;
                        this.index = new_inv_list.length;
                        //console.log('new_inv_list.length=',new_inv_list.length);
                        let new_inv_list1 = [];
                        new_inv_list.map((each_el,i)=>{
                            new_inv_list1.push({
                                key:i,
                                ...each_el
                            })
                        });
                        //console.log('new_inv_list1=',JSON.stringify(new_inv_list1));
                        let Shipment_Or_Invoice_Date__c,Gross_Invoice_Currency__c,Gross_Invoice_Amount__c,Payment_Term_Type__c,Payment_Term_Days__c,Due_Date__c,Remarks__c;

                        new_inv_list.map((each_inv,i) => {
                            if(each_inv.Shipment_Or_Invoice_Date__c)
                                Shipment_Or_Invoice_Date__c=each_inv.Shipment_Or_Invoice_Date__c;
                            else
                                Shipment_Or_Invoice_Date__c=''
                            if(each_inv.Gross_Invoice_Currency__c)
                                Gross_Invoice_Currency__c=each_inv.Gross_Invoice_Currency__c;
                            else
                                Gross_Invoice_Currency__c=''
                            if(each_inv.Gross_Invoice_Amount__c)
                                Gross_Invoice_Amount__c=each_inv.Gross_Invoice_Amount__c;
                            else
                                Gross_Invoice_Amount__c=''
                            if(each_inv.Payment_Term_Type__c)
                                Payment_Term_Type__c=each_inv.Payment_Term_Type__c;
                            else
                                Payment_Term_Type__c=''
                            if(each_inv.Payment_Term_Days__c)
                                Payment_Term_Days__c=each_inv.Payment_Term_Days__c;
                            else
                                Payment_Term_Days__c=''
                            if(each_inv.Due_Date__c)
                                Due_Date__c=each_inv.Due_Date__c;
                            else
                                Due_Date__c=''
                            if(each_inv.Remarks__c)
                                Remarks__c=each_inv.Remarks__c;
                            else
                                Remarks__c=''
                            
                            self.invoiceList.push({
                                key: i,
                                InvoiceDate: Shipment_Or_Invoice_Date__c,
                                InvoiceCurrency: Gross_Invoice_Currency__c,
                                InvoiceAmount: Gross_Invoice_Amount__c,
                                PaymentTermsType: Payment_Term_Type__c,
                                PaymentTermsDays: Payment_Term_Days__c,
                                InvoiceDueDate: Due_Date__c,
                                InvoiceRemark: Remarks__c
                            });
                        });
                        //console.log('this.invoiceList=',JSON.stringify(this.invoiceList));
                    } else if (this.unpaid_amount === 'No') {
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.is_new_buyer === 'No') {
                        this.show_new_buyer_detail = true;
                        this.new_buyer_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                        
                    } else if (this.is_new_buyer === 'Yes') {
                        this.show_new_buyer_detail = false;
                        this.new_buyer_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    }
                    if (this.is_credit_limit_exist === 'Yes') {
                        this.existing_credit_limit = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    } else {
                        this.existing_credit_limit = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.order_confirm_negotiation_value.substring(0, 3) === 'Yes') {
                        this.show_order_confirm_negotiation_detail = true;
                    }

                    
                    
                }

            }
        }

    }
    get yearOptions() {
        var d = new Date();
        var n = d.getFullYear();
        var year_arr = [
            { label: (n - 1).toString(), value: (n - 1).toString() },
            { label: n.toString(), value: n.toString() },
            { label: (n + 1).toString(), value: (n + 1).toString() }
        ];
        // var year_arr = [
        //     { label: '2020', value: '2020' },
        //     { label: '2021', value: '2021' },
        //     { label: '2022', value: '2022' }
        // ]
        return year_arr;
    }
    get monthOptions() {
        return [
            { label: "January", value: "January" },
            { label: "February", value: "February" },
            { label: "March", value: "March" },
            { label: "April", value: "April" },
            { label: "May", value: "May" },
            { label: "June", value: "June" },
            { label: "July", value: "July" },
            { label: "August", value: "August" },
            { label: "September", value: "September" },
            { label: "October", value: "October" },
            { label: "November", value: "November" },
            { label: "December", value: "December" }
        ]
    }
    get servicesOptions() {
        return [
            { label: "Services", value: "Services" },
            { label: "Services - Freight Forwarding", value: "Services - Freight Forwarding" },

        ].sort((a, b) => a.value.localeCompare(b.value))
    }
    /*get goodsOptions() {
        return [
            { label: "Textiles", value: "Textiles" },
            { label: "Clothing", value: "Clothing" },
            { label: "Electronics", value: "Electronics" },
            { label: "Electrical Appliances", value: "Electrical Appliances" },
            { label: "Toys", value: "Toys" },
            { label: "Watches & Clocks", value: "Watches & Clocks" },
            { label: "Jewellery", value: "Jewellery" },
            { label: "Footware", value: "Footware" },
            { label: "Plastic Articles", value: "Plastic Articles" },
            { label: "Travel Goods", value: "Travel Goods" },
            { label: "Metallic Products", value: "Metallic Products" },
            { label: "Food", value: "Food" },
            { label: "Printed Matters", value: "Printed Matters" },
            { label: "Artificial Flowers", value: "Artificial Flowers" },
            { label: "Cameras & Optical Goods", value: "Cameras & Optical Goods" },
            { label: "Chemical Products", value: "Chemical Products" },
            { label: "Mineral Products", value: "Mineral Products" },
            { label: "Office & Stationery Supplies", value: "Office & Stationery Supplies" },
            { label: "Papers", value: "Papers" },
            { label: "Miscellaneous (Products)", value: "Miscellaneous (Products)" },
            { label: "Furniture", value: "Furniture" }

        ].sort((a, b) => a.value.localeCompare(b.value))
    }*/
    get CurrencyList() {
        return [{ "label": "AUD", "value": "AUD" }, { "label": "CAD", "value": "CAD" }, { "label": "CHF", "value": "CHF" }, { "label": "DEM", "value": "DEM" }, { "label": "EUR", "value": "EUR" }, { "label": "GBP", "value": "GBP" }, { "label": "JPY", "value": "JPY" }, { "label": "NZD", "value": "NZD" }, { "label": "SGD", "value": "SGD" }, { "label": "USD", "value": "USD" }, { "label": "ATS", "value": "ATS" }, { "label": "BEF", "value": "BEF" }, { "label": "CNY", "value": "CNY" }, { "label": "DKK", "value": "DKK" }, { "label": "IEP", "value": "IEP" }, { "label": "NLG", "value": "NLG" }, { "label": "NOK", "value": "NOK" }, { "label": "SEK", "value": "SEK" }, { "label": "TWD", "value": "TWD" }, { "label": "ZAR", "value": "ZAR" }, { "label": "FIM", "value": "FIM" }, { "label": "PTE", "value": "PTE" }, { "label": "HKD", "value": "HKD" }, { "label": "ECU", "value": "ECU" }, { "label": "MYR", "value": "MYR" }, { "label": "ALL", "value": "ALL" }, { "label": "DZD", "value": "DZD" }, { "label": "AMD", "value": "AMD" }, { "label": "BSD", "value": "BSD" }, { "label": "BHD", "value": "BHD" }, { "label": "BDT", "value": "BDT" }, { "label": "BBD", "value": "BBD" }, { "label": "BZD", "value": "BZD" }, { "label": "XOF", "value": "XOF" }, { "label": "BMD", "value": "BMD" }, { "label": "BTN", "value": "BTN" }, { "label": "BOB", "value": "BOB" }, { "label": "BWP", "value": "BWP" }, { "label": "BRL", "value": "BRL" }, { "label": "BND", "value": "BND" }, { "label": "BIF", "value": "BIF" }, { "label": "XAF", "value": "XAF" }, { "label": "CVE", "value": "CVE" }, { "label": "KYD", "value": "KYD" }, { "label": "CLP", "value": "CLP" }, { "label": "COP", "value": "COP" }, { "label": "KMF", "value": "KMF" }, { "label": "CRC", "value": "CRC" }, { "label": "HRK", "value": "HRK" }, { "label": "CUP", "value": "CUP" }, { "label": "CZK", "value": "CZK" }, { "label": "DJF", "value": "DJF" }, { "label": "XCD", "value": "XCD" }, { "label": "DOP", "value": "DOP" }, { "label": "ECS", "value": "ECS" }, { "label": "EGP", "value": "EGP" }, { "label": "SVC", "value": "SVC" }, { "label": "ETB", "value": "ETB" }, { "label": "FKP", "value": "FKP" }, { "label": "FJD", "value": "FJD" }, { "label": "XPF", "value": "XPF" }, { "label": "GMD", "value": "GMD" }, { "label": "GIP", "value": "GIP" }, { "label": "GRD", "value": "GRD" }, { "label": "GTQ", "value": "GTQ" }, { "label": "GNF", "value": "GNF" }, { "label": "GYD", "value": "GYD" }, { "label": "HTG", "value": "HTG" }, { "label": "HNL", "value": "HNL" }, { "label": "HUF", "value": "HUF" }, { "label": "ISK", "value": "ISK" }, { "label": "INR", "value": "INR" }, { "label": "IDR", "value": "IDR" }, { "label": "IRR", "value": "IRR" }, { "label": "IQD", "value": "IQD" }, { "label": "ILS", "value": "ILS" }, { "label": "JMD", "value": "JMD" }, { "label": "JOD", "value": "JOD" }, { "label": "KHR", "value": "KHR" }, { "label": "KZT", "value": "KZT" }, { "label": "KES", "value": "KES" }, { "label": "KRW", "value": "KRW" }, { "label": "KWD", "value": "KWD" }, { "label": "LAK", "value": "LAK" }, { "label": "LBP", "value": "LBP" }, { "label": "LSL", "value": "LSL" }, { "label": "LRD", "value": "LRD" }, { "label": "LYD", "value": "LYD" }, { "label": "LTL", "value": "LTL" }, { "label": "LUF", "value": "LUF" }, { "label": "MOP", "value": "MOP" }, { "label": "MKD", "value": "MKD" }, { "label": "MWK", "value": "MWK" }, { "label": "MVR", "value": "MVR" }, { "label": "MRU", "value": "MRU" }, { "label": "MUR", "value": "MUR" }, { "label": "MDL", "value": "MDL" }, { "label": "MNT", "value": "MNT" }, { "label": "MAD", "value": "MAD" }, { "label": "MMK", "value": "MMK" }, { "label": "NPR", "value": "NPR" }, { "label": "ANG", "value": "ANG" }, { "label": "NGN", "value": "NGN" }, { "label": "KPW", "value": "KPW" }, { "label": "OMR", "value": "OMR" }, { "label": "PKR", "value": "PKR" }, { "label": "PAB", "value": "PAB" }, { "label": "PGK", "value": "PGK" }, { "label": "PYG", "value": "PYG" }, { "label": "PEN", "value": "PEN" }, { "label": "PHP", "value": "PHP" }, { "label": "PLN", "value": "PLN" }, { "label": "QAR", "value": "QAR" }, { "label": "RON", "value": "RON" }, { "label": "RWF", "value": "RWF" }, { "label": "STN", "value": "STN" }, { "label": "SAR", "value": "SAR" }, { "label": "SCR", "value": "SCR" }, { "label": "SLL", "value": "SLL" }, { "label": "SIT", "value": "SIT" }, { "label": "SBD", "value": "SBD" }, { "label": "SOS", "value": "SOS" }, { "label": "LKR", "value": "LKR" }, { "label": "SHP", "value": "SHP" }, { "label": "SZL", "value": "SZL" }, { "label": "SYP", "value": "SYP" }, { "label": "TZS", "value": "TZS" }, { "label": "THB", "value": "THB" }, { "label": "TOP", "value": "TOP" }, { "label": "TTD", "value": "TTD" }, { "label": "TND", "value": "TND" }, { "label": "TRL", "value": "TRL" }, { "label": "UGX", "value": "UGX" }, { "label": "AED", "value": "AED" }, { "label": "UYW", "value": "UYW" }, { "label": "UZS", "value": "UZS" }, { "label": "VUV", "value": "VUV" }, { "label": "VES", "value": "VES" }, { "label": "VND", "value": "VND" }, { "label": "WST", "value": "WST" }, { "label": "YER", "value": "YER" }, { "label": "YUN", "value": "YUN" }, { "label": "CDF", "value": "CDF" }, { "label": "KGS", "value": "KGS" }, { "label": "NAD", "value": "NAD" }, { "label": "GEL", "value": "GEL" }, { "label": "ROL", "value": "ROL" }, { "label": "BAM", "value": "BAM" }, { "label": "AWG", "value": "AWG" }, { "label": "AFN", "value": "AFN" }, { "label": "AOA", "value": "AOA" }, { "label": "ARS", "value": "ARS" }, { "label": "AZN", "value": "AZN" }, { "label": "BGN", "value": "BGN" }, { "label": "BYN", "value": "BYN" }, { "label": "ERN", "value": "ERN" }, { "label": "GHS", "value": "GHS" }, { "label": "MGA", "value": "MGA" }, { "label": "MXN", "value": "MXN" }, { "label": "MZN", "value": "MZN" }, { "label": "NIO", "value": "NIO" }, { "label": "RSD", "value": "RSD" }, { "label": "RUB", "value": "RUB" }, { "label": "SDG", "value": "SDG" }, { "label": "SRD", "value": "SRD" }, { "label": "TJS", "value": "TJS" }, { "label": "TMT", "value": "TMT" }, { "label": "TRY", "value": "TRY" }, { "label": "UAH", "value": "UAH" }, { "label": "ZMW", "value": "ZMW" }, { "label": "ZWL", "value": "ZWL" }, { "label": "SSP", "value": "SSP" }].sort((a, b) => a.value.localeCompare(b.value));
    }
    // get countryOptions() {
    //     return [
    //         { label: "Australia", value: "Australia" },
    //         { label: "Austria", value: "Austria" },
    //         { label: "Belgium", value: "Belgium" },
    //         { label: "Bermuda", value: "Bermuda" },
    //         { label: "Brunei Darussalam", value: "Brunei Darussalam" },
    //         { label: "Canada", value: "Canada" },
    //         { label: "Chile", value: "Chile" },
    //         { label: "China", value: "China" },
    //         { label: "Czechia", value: "Czechia" },
    //         { label: "Denmark", value: "Denmark" },
    //         { label: "Finland", value: "Finland" },
    //         { label: "France", value: "France" },
    //         { label: "Gabon Germany", value: "Gabon Germany" },
    //         { label: "Holy See", value: "Holy See" },
    //         { label: "Ireland", value: "Ireland" },
    //         { label: "Italy", value: "Italy" },
    //         { label: "Japan", value: "Japan" },
    //         { label: "Korea, Republic of ", value: "Korea, Republic of " },
    //         { label: "Kuwait", value: "Kuwait" },
    //         { label: "Liechtensteni", value: "Liechtensteni" },
    //         { label: "Luxembourg", value: "Luxembourg" },
    //         { label: "Macao", value: "Macao" },
    //         { label: "Manoco", value: "Manoco" },
    //         { label: "Netherlands", value: "Netherlands" },
    //         { label: "New Zealand", value: "New Zealand" },
    //         { label: "Norway", value: "Norway" },
    //         { label: "Oman", value: "Oman" },
    //         { label: "Portugal", value: "Portugal" },
    //         { label: "Qatar", value: "Qatar" },
    //         { label: "San Marino", value: "San Marino" },
    //         { label: "Saudi Arabia", value: "Saudi Arabia" },
    //         { label: "Singapore", value: "Singapore" },
    //         { label: "Spain", value: "Spain" },
    //         { label: "Sweden", value: "Sweden" },
    //         { label: "Switzerland", value: "Switzerland" },
    //         { label: "Taiwan", value: "Taiwan" },
    //         { label: "United Arab Emirates", value: "United Arab Emirates" },
    //         { label: "United Kindom", value: "United Kindom" },
    //         { label: "United States of America", value: "United States of America" },
    //         { label: "Aland Island", value: "Aland Island" },
    //         { label: "American Samoa", value: "American Samoa" },
    //         { label: "Andorra", value: "Andorra" },
    //         { label: "Anguilla", value: "Anguilla" },
    //         { label: "Aruba", value: "Aruba" },
    //         { label: "Bahamas", value: "Bahamas" },
    //         { label: "Bonaire, Sint Eustatius and Saba", value: "Bonaire, Sint Eustatius and Saba" },
    //         { label: "Botswana", value: "Botswana" },
    //         { label: "Bouvet Island", value: "Bouvet Island" },
    //         { label: "Brazil", value: "Brazil" },
    //         { label: "British Indian Ocean Territory", value: "British Indian Ocean Territory" },
    //         { label: "Cayman Islands", value: "Cayman Islands" },
    //         { label: "Christmas Island", value: "Christmas Island" },
    //         { label: "Cocos (Keeling) Islands", value: "Cocos (Keeling) Islands" },
    //         { label: "Colombia", value: "Colombia" },
    //         { label: "Cook Islands", value: "Cook Islands" },
    //         { label: "Curacao", value: "Curacao" },
    //         { label: "Cuyprus", value: "Cuyprus" },
    //         { label: "Estonia", value: "Estonia" },
    //         { label: "Eswatini", value: "Eswatini" },
    //         { label: "Falkland Island (Malvinas)", value: "Falkland Island (Malvinas)" },
    //         { label: "Faroe", value: "Faroe" },
    //         { label: "French Guiana", value: "French Guiana" },
    //         { label: "French Polynesia", value: "French Polynesia" },
    //         { label: "French Southern Territories", value: "French Southern Territories" },
    //         { label: "Gibraltar", value: "Gibraltar" },
    //         { label: "Greenland", value: "Greenland" },
    //         { label: "Guadeloupe", value: "Guadeloupe" },
    //         { label: "Guam", value: "Guam" },
    //         { label: "Guernsey", value: "Guernsey" },
    //         { label: "Heard Island and McDonald Islands", value: "Heard Island and McDonald Islands" },
    //         { label: "Hungary", value: "Hungary" },
    //         { label: "Iceland", value: "Iceland" },
    //         { label: "India", value: "India" },
    //         { label: "Indonesia", value: "Indonesia" },
    //         { label: "Isle of Man", value: "Isle of Man" },
    //         { label: "Israel", value: "Israel" },
    //         { label: "Jersey", value: "Jersey" },
    //         { label: "Latvia", value: "Latvia" },
    //         { label: "Lithuania", value: "Lithuania" },
    //         { label: "Malaysia", value: "Malaysia" },
    //         { label: "Malta", value: "Malta" },
    //         { label: "Martinique", value: "Martinique" },
    //         { label: "Mauritius", value: "Mauritius" },
    //         { label: "Mayotee", value: "Mayotee" },
    //         { label: "Mexico", value: "Mexico" },
    //         { label: "Montserrat", value: "Montserrat" },
    //         { label: "Morocco", value: "Morocco" },
    //         { label: "Namibia", value: "Namibia" },
    //         { label: "New Caledonia", value: "New Caledonia" },
    //         { label: "Niue", value: "Niue" },
    //         { label: "Norflol Island", value: "Norflol Island" },
    //         { label: "Northern Mariana Islands", value: "Northern Mariana Islands" },
    //         { label: "Panama", value: "Panama" },
    //         { label: "Peru", value: "Peru" },
    //         { label: "Philippines", value: "Philippines" },
    //         { label: "Pitcairn", value: "Pitcairn" },
    //         { label: "Poland", value: "Poland" },
    //         { label: "Puerto Rico", value: "Puerto Rico" },
    //         { label: "Reunion", value: "Reunion" },
    //         { label: "Romania", value: "Romania" },
    //         { label: "Russian Federation", value: "Russian Federation" },
    //         { label: "Saint Barthelemy", value: "Saint Barthelemy" },
    //         { label: "Saint Helena, Ascension and Tristan Da Cunha", value: "Saint Helena, Ascension and Tristan Da Cunha" },
    //         { label: "Saint Pierre and Miquelon", value: "Saint Pierre and Miquelon" },
    //         { label: "Sint Maarten (Dutch Part)", value: "Sint Maarten (Dutch Part)" },
    //         { label: "Slovakia", value: "Slovakia" },
    //         { label: "Slovenia", value: "Slovenia" },
    //         { label: "South Africa", value: "South Africa" },
    //         { label: "South Georgia and the South Sandwich Islands", value: "South Georgia and the South Sandwich Islands" },
    //         { label: "Svalbard and Jan Mayen", value: "Svalbard and Jan Mayen" },
    //         { label: "Thailand", value: "Thailand" },
    //         { label: "Tokelau", value: "Tokelau" },
    //         { label: "Trinidad and Tobago", value: "Trinidad and Tobago" },
    //         { label: "Turks and Caicas Islands", value: "Turks and Caicas Islands" },
    //         { label: "Uruguay", value: "Uruguay" },
    //         { label: "Virgin Islands, British", value: "Virgin Islands, British" },
    //         { label: "Virgin Islands, U.S.", value: "Virgin Islands, U.S." },
    //         { label: "Wallis and Futuna", value: "Wallis and Futuna" },
    //         { label: "Algeria", value: "Algeria" },
    //         { label: "Angola", value: "Angola" },
    //         { label: "Argentina", value: "Argentina" },
    //         { label: "Azerbaijan", value: "Azerbaijan" },
    //         { label: "Bahrain", value: "Bahrain" },
    //         { label: "Bangladesh", value: "Bangladesh" },
    //         { label: "Barbodas", value: "Barbodas" },
    //         { label: "Benin", value: "Benin" },
    //         { label: "Bhutan", value: "Bhutan" },
    //         { label: "Bolivia (Plurinational State of)", value: "Bolivia (Plurinational State of)" },
    //         { label: "Bulgaria", value: "Bulgaria" },
    //         { label: "Burkina Faso", value: "Burkina Faso" },
    //         { label: "Cabo Verde", value: "Cabo Verde" },
    //         { label: "Cameroon", value: "Cameroon" },
    //         { label: "Comoros", value: "Comoros" },
    //         { label: "Costa Rica", value: "Costa Rica" },
    //         { label: "Croatia", value: "Croatia" },
    //         { label: "Djibouti", value: "Djibouti" },
    //         { label: "Dominica", value: "Dominica" },
    //         { label: "Dominican Republic", value: "Dominican Republic" },
    //         { label: "Ecuador", value: "Ecuador" },
    //         { label: "Egypt", value: "Egypt" },
    //         { label: "El Salvador", value: "El Salvador" },
    //         { label: "Equatorial Guinea", value: "Equatorial Guinea" },
    //         { label: "Ethiopia", value: "Ethiopia" },
    //         { label: "Fiji", value: "Fiji" },
    //         { label: "Ghana", value: "Ghana" },
    //         { label: "Greece", value: "Greece" },
    //         { label: "Guatemala", value: "Guatemala" },
    //         { label: "Honduras", value: "Honduras" },
    //         { label: "Iran, Islamic Republic of", value: "Iran, Islamic Republic of" },
    //         { label: "Jamaica", value: "Jamaica" },
    //         { label: "Jordan", value: "Jordan" },
    //         { label: "Kazakhstan", value: "Kazakhstan" },
    //         { label: "Kenya", value: "Kenya" },
    //         { label: "Lao People's Democratic Repubic", value: "Lao People's Democratic Repubic" },
    //         { label: "Lesotho", value: "Lesotho" },
    //         { label: "Maldives", value: "Maldives" },
    //         { label: "Mali", value: "Mali" },
    //         { label: "Manogolia", value: "Manogolia" },
    //         { label: "Myanmar", value: "Myanmar" },
    //         { label: "Nepal", value: "Nepal" },
    //         { label: "Niger", value: "Niger" },
    //         { label: "Nigeria", value: "Nigeria" },
    //         { label: "Pakistan", value: "Pakistan" },
    //         { label: "Papua New Guinea", value: "Papua New Guinea" },
    //         { label: "Paraguay", value: "Paraguay" },
    //         { label: "Saint Lucia", value: "Saint Lucia" },
    //         { label: "Saint Vincent and the Grenadines", value: "Saint Vincent and the Grenadines" },
    //         { label: "Samoa", value: "Samoa" },
    //         { label: "Sao Tome and Principe", value: "Sao Tome and Principe" },
    //         { label: "Serbia", value: "Serbia" },
    //         { label: "Senegal", value: "Senegal" },
    //         { label: "Seychelles", value: "Seychelles" },
    //         { label: "Solomon Islands", value: "Solomon Islands" },
    //         { label: "Srilanka", value: "Srilanka" },
    //         { label: "Suriname", value: "Suriname" },
    //         { label: "Togo", value: "Togo" },
    //         { label: "Tonga", value: "Tonga" },
    //         { label: "Tunisia", value: "Tunisia" },
    //         { label: "Turkey", value: "Turkey" },
    //         { label: "Vanuatu", value: "Vanuatu" },
    //         { label: "Vietnam", value: "Vietnam" },

    //     ].sort((a, b) => a.value.localeCompare(b.value))
    // }
}
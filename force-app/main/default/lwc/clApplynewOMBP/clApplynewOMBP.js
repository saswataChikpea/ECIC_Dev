/* eslint-disable  no-console */
import { LightningElement, track, api, wire } from 'lwc';
import { createRecord,getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getExistingBuyers from '@salesforce/apex/CLApplicationRecord.getExistingBuyers';
// import getCountryList from '@salesforce/apex/CLApplicationRecord.getCountryList';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';
import createOutstandingPaymentBuyer from '@salesforce/apex/CLApplicationRecord.createOutstandingPaymentBuyer';
import serchBuyerDetailsAura from '@salesforce/apex/ECIC_CL_API_Methods.serchBuyerDetailsAura';
import validateHrmCodeAura from '@salesforce/apex/ECIC_CL_API_Methods.validateHrmCodeAura';
import getOriginCountryList from '@salesforce/apex/GetCustomMetaData.getOriginCountryList';
import getDestinationCountryList from '@salesforce/apex/GetCustomMetaData.getDestinationCountryList';
import getPortOfLoadingList from '@salesforce/apex/GetCustomMetaData.getPortOfLoadingList';
import getBuyerCountryListByPolicy from '@salesforce/apex/GetCustomMetaData.getBuyerCountryListByPolicy';
import getProductDetails from '@salesforce/apex/CLProductDetails.getProductDetails';


import Credit_Limit_Application from '@salesforce/label/c.Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import CL_Application_Draft from '@salesforce/label/c.CL_Application_Draft';
import Required_field_DCL from '@salesforce/label/c.Required_field_DCL';
import Online_Micro_Business_Policy_is_only_applicable_to_Hong_Kong_exporters from '@salesforce/label/c.Online_Micro_Business_Policy_is_only_applicable_to_Hong_Kong_exporters';
import Policyholder_Must_be_the_contractual_seller from '@salesforce/label/c.Policyholder_Must_be_the_contractual_seller';
import Export_of_Goods_Export_of_Services from '@salesforce/label/c.Export_of_Goods_Export_of_Services';
import Are_you_holding_a_valid_credit_limit_on_the from '@salesforce/label/c.Are_you_holding_a_valid_credit_limit_on_the';
import client_small from '@salesforce/label/c.client_small';
import Client from '@salesforce/label/c.Client';
import buyer_small from '@salesforce/label/c.buyer_small';
import Buyer from '@salesforce/label/c.Buyer';
import Uplift_Reapply from '@salesforce/label/c.Uplift_Reapply';
import Country_Market from '@salesforce/label/c.Country_Market';
import Search from '@salesforce/label/c.Search';
import Name from '@salesforce/label/c.Name';
import Or from '@salesforce/label/c.Or';
import Registration_No from '@salesforce/label/c.Registration_No';
import Please_Wait from '@salesforce/label/c.Please_Wait';
import Search_Result from '@salesforce/label/c.Search_Result';
import Address from '@salesforce/label/c.Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Harmonized_Code from '@salesforce/label/c.Harmonized_Code';
import Search_Harmonized_Code_Census_and_Statistics_Department from '@salesforce/label/c.Search_Harmonized_Code_Census_and_Statistics_Department';
import Days from '@salesforce/label/c.Days';
import Country_Market_of_Shipment_Port_of_Loading from '@salesforce/label/c.Country_Market_of_Shipment_Port_of_Loading';
import Destination_Country_Market from '@salesforce/label/c.Destination_Country_Market';
import Country_Market_of_Origin from '@salesforce/label/c.Country_Market_of_Origin';
import Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for from '@salesforce/label/c.Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for';
import Does_this from '@salesforce/label/c.Does_this';
import have_any_unpaid from '@salesforce/label/c.have_any_unpaid';
import whether_due_or_not from '@salesforce/label/c.whether_due_or_not';
import Unpaid_Shipment_Details from '@salesforce/label/c.Unpaid_Shipment_Details';
import Shipment from '@salesforce/label/c.Shipment';
import Invoice_date from '@salesforce/label/c.Invoice_date';
import Gross_Invoice_Value_Currency from '@salesforce/label/c.Gross_Invoice_Value_Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Due_Date from '@salesforce/label/c.Due_Date';
import Remarks from '@salesforce/label/c.Remarks';
import Cancel from '@salesforce/label/c.Cancel';
import Save_and_Exit from '@salesforce/label/c.Save_and_Exit';
import Next from '@salesforce/label/c.Next';
import Section_A_Buyer_Information from '@salesforce/label/c.Section_A_Buyer_Information';
import Section_B_Trading_Experience from '@salesforce/label/c.Section_B_Trading_Experience';
import Export_of_Goods from '@salesforce/label/c.Export_of_Goods';
import Export_of_Services from '@salesforce/label/c.Export_of_Services';
import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';
import Uplift from '@salesforce/label/c.Uplift';
import Reapply from '@salesforce/label/c.Reapply';
import DP from '@salesforce/label/c.DP';
import DA from '@salesforce/label/c.DA';
import OA from '@salesforce/label/c.OA';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Section_A_Client_Information from '@salesforce/label/c.Section_A_Client_Information';
import shipments from '@salesforce/label/c.shipments';
import invoices from '@salesforce/label/c.invoices';
import OA_90days from '@salesforce/label/c.OA_90days';
import Payment_Term_OA_DA_DP_90_days from '@salesforce/label/c.Payment_Term_OA_DA_DP_90_days';
import Search_Company from '@salesforce/label/c.Search_Company';
import invoices_for_services_rendered from '@salesforce/label/c.invoices_for_services_rendered';
import Application_Amount from '@salesforce/label/c.Application_Amount';



export default class ClApplynewOMBP extends LightningElement {


    @track label ={
        Country_Market_of_Origin,Destination_Country_Market,Country_Market_of_Shipment_Port_of_Loading,Search_Harmonized_Code_Census_and_Statistics_Department,Country_Market,Uplift_Reapply,Buyer,buyer_small,Client,client_small,
        Online_Micro_Business_Policy_is_only_applicable_to_Hong_Kong_exporters,Required_field_DCL,CL_Application_Draft,Is_there_any_amount_currently_unpaid_for_more_than_30_days_from_the_due_date_for,
        Policy_Type,Policy_Number,Company_Name,Credit_Limit_Application,Free_Credit_Check_Facility_Balance,Address,Registration_Number_If_any,Harmonized_Code,Days,whether_due_or_not,
        Policyholder_Must_be_the_contractual_seller,Export_of_Goods_Export_of_Services,Are_you_holding_a_valid_credit_limit_on_the,Search,Name,Or,Registration_No,Search_Result,
        Please_Wait,Does_this,have_any_unpaid,Unpaid_Shipment_Details,Shipment,Invoice_date,Gross_Invoice_Value_Currency,Gross_Invoice_Value_Amount,Due_Date,
        Remarks,Cancel,Save_and_Exit,Next,Section_A_Buyer_Information,Section_B_Trading_Experience,Export_of_Goods,Export_of_Services,Yes,No,
        Uplift,Reapply,DA,DP,OA,Payment_Terms,Section_A_Client_Information,shipments,invoices,OA_90days,Payment_Term_OA_DA_DP_90_days,
        Search_Company,invoices_for_services_rendered,Application_Amount

    }
    @api policyinfo;
    @track is_rendered = false;
    @track account_name = "";
    @track acc_id = "";
    @track policy_no = "";
    @track policy_type = "";
    @track available_credit_check_facility = "";
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: this.label.Section_A_Buyer_Information }
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: this.label.Section_B_Trading_Experience }
    @api exportType = "";
    @api unpaid_amount = "";
    @api unpaid_shipment = "";
    @api user_type = this.label.Buyer;
    @track user_type_small = this.label.buyer_small;
    @track shipment_or_invoice = this.label.shipments;
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
    @track legacy_buyer_country = "";
    @api buyer_name_chinese = "";
    @api application_amount = "";
    @track application_amount2 = "";
    @api registration_no = "";
    @api harmonized_code = "";
    @api buyer_full_address = "";
    @api label_payment_term_info = this.label.Payment_Term_OA_DA_DP_90_days;
    @api hide_payment_term_info_icon = false;
    @api hide_country_lists = false;
    @api label_unpaid_shipment = this.label.shipments;
    @api flag_unpaid_shipment = false;
    @api shipment_country = "";
    @track legacy_shipment_country = "";
    @api destination_country = "";
    @track legacy_destination_country = "";
    @track export_options = [
        { label: this.label.Export_of_Goods, value: 'Export of Goods', isChecked: false },
        { label: this.label.Export_of_Services, value: 'Export of Services', isChecked: false },
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
    @track unpaid_shipment_options = [
        { label: this.label.Yes, value: 'Yes', isChecked: false },
        { label: this.label.No, value: 'No', isChecked: false },
    ];
    @track uplift_reapply_option = [
        { label: this.label.Uplift, value: 'Uplift', isChecked: false },
        { label: this.label.Reapply, value: 'Reapply', isChecked: false },
    ];
    @api uplift_reapply = '';

    @track Countrylist1 = [
        { value: 'India', label: 'India' },
        { value: 'China', label: 'China' },
        { value: 'Japan', label: 'Japan' },
    ];
    @track ApplicationAmount = [
        { value: '$100000', label: '$100000' },
        { value: '$150000', label: '$150000' },
        { value: '$200000', label: '$200000' },
    ];
    // @track CurrencyList = [
    //     { value: 'USD', label: 'USD' },
    //     { value: 'INR', label: 'INR' },
    // ];
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
    @track payment_terms_value = 'OA';
    @track payment_terms_days = 120;
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
    @track legacy_country_origin = '';
    @track search_buyer = false;
    @track show_buyer_search_link = false;
    @track buyer_search_result = [];
    @track credit_limit_record = [];
    @track credit_limit_id = '';
    @track isNewApplication = true;
    @track application_amount_min = 100000;
    @track application_amount_max = 800000;
    @track application_amount_step = 10000;
    @track isClUplifted = false;
    @track clExpiryDate = '';
    @track clEffectiveDate = '';
    @track show_uplift_reapplt_option = false;
    @track countryOptions = [];
    @track draft_id = '';
    @track loading = false;
    @track search_buyer_name  = '';
    @track search_buyer_reg_no = '';
    @track search_buyer_name_disable  = false;
    @track search_buyer_reg_no_disable = false;
    @track select_buyer_placeholder = 'Select Buyer';
    @track buyer_search_loading = false;

    @track duns_no = '';
    @track buyer_source = '';
    @track buyer_agency_ref = '';
    @track origin_country_options = [];
    @track destination_country_options = [];
    @track port_of_loading_options = [];
    @track buyer_country_options = [];
    @track legacy_policy_type ;
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
            if (Object.keys(this.policyinfo).length > 0) {
                if (this.policyinfo.hasOwnProperty('clRecord')) {
                    if (this.policyinfo.clRecord[0].application_type === 'Uplift') {
                        let app_amount_temp = this.credit_limit_record.CL_Application_Amount__c;
                        app_amount_temp = app_amount_temp.replace(',', '');
                        this.application_amount_min = Number(app_amount_temp);
                    }
                }
            }
        }
        if (error) {
            console.error('Error',JSON.stringify(error));
        }
    }
    
    @wire(getOriginCountryList)
    handleOriginCountryList({ error, data }) {
        // //consele.log('handleOriginCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.origin_country_options = data.map((each_el)=>({label:each_el.OrgCtryList_Country_Name__c,value:each_el.OrgCtryList_Country_Name__c}));
            this.origin_country_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in handleOriginCountryList=' + JSON.stringify(error))

        }
    }
    @wire(getDestinationCountryList)
    handleDestinationCountryList({ error, data }) {
        // //consele.log('handleDestinationCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.destination_country_options = data.map((each_el)=>({label:each_el.DestCtryList_Country_Name__c,value:each_el.DestCtryList_Country_Name__c}));
            this.destination_country_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in getDestinationCountryList=' + JSON.stringify(error))
        }
    }
    @wire(getPortOfLoadingList,{policy_type: '$legacy_policy_type'})
    handlePortOfLoadingList({ error, data }) {
        //consele.log('handlePortOfLoadingList data=' + JSON.stringify(data))
        if (data) {            
            this.port_of_loading_options = data.map((each_el)=>({label:each_el.PortOfLdg_Country_Name__c,value:each_el.PortOfLdg_Country_Name__c}));
            this.port_of_loading_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in getPortOfLoadingList=' + JSON.stringify(error))
        }
    }
    @wire(getBuyerCountryListByPolicy,{policy_type:'70'})
    handleBuyerCountryList({ error, data }) {
        //consele.log('handleBuyerCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.buyer_country_options = data.map((each_el)=>({label:each_el.ByrCtry_Country_Name__c,value:each_el.ByrCtry_Country_Name__c,code:each_el.ByrCtry_Country_Code__c}));
            this.buyer_country_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in getBuyerCountryList=' + JSON.stringify(error))
        }
    }

    expandHandler1(event) {
        //consele.log('expandHandler=', event.currentTarget.id);
        let id = event.currentTarget.id + ""
        id = id.split("-")[0];
        // this.section_array.forEach((cl) => {
        this.section1.isSectionOpen = !this.section1.isSectionOpen
        this.section1.iconName = this.section1.isSectionOpen ? 'utility:up' : 'utility:down'
        //:'utility:down',
        // });
        //consele.log('after modify section1=', JSON.stringify(this.section1));

    }
    expandHandler2(event) {
        this.section2.isSectionOpen = !this.section2.isSectionOpen
        this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
    }

    addRow() {


        //var i = JSON.parse(JSON.stringify(this.index));
        var i = this.index;

        /*this.accountList.push ({
            sobjectType: 'Account',
            Name: '',
            AccountNumber : '',
            Phone: '',
            key : i
        });*/
        this.inv.key = i;
        this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));
        this.index = this.index + 1;
        //consele.log('Enter ', JSON.stringify(this.invoiceList));


    }
    removeRow(event) {
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        //consele.log('key=',key);
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
        ////consele.log(' After adding Record List ', this.dispatchEvent);
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
        //consele.log("handleInvoiceCurrencyChange");
        //consele.log("currency type", e.target.value);
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceCurrency = e.target.value;
        // //consele.log(e.detail.selectedValue);
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
        //consele.log('handleCreditLimitExist');
        this.is_credit_limit_exist = e.detail.selectedValue;
        if (this.is_credit_limit_exist === 'Yes') {
            this.existing_buyer_list = this.buyer_info.map((buyer) => ({ label: buyer.Buyer_Name__c, value: buyer.Buyer_Code__c }));
            //consele.log('existing_buyer_list', JSON.stringify(this.existing_buyer_list));
            this.show_buyer_select = true;
            this.enable_buyer_edit = false;
            this.manual_buyer_input = false;
            this.show_buyer_section = false;
            this.show_buyer_search_link = false;
            this.show_uplift_reapplt_option = true;


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
            this.show_uplift_reapplt_option = false;
        }
    }
    handleBuyerChange(e) {
        //consele.log('selected buyer=', e.detail.value);
        var selected_buyer_code = e.detail.value;
        let self = this;
        this.buyer_info.map((buyer) => {
            if (buyer.Buyer_Code__c === selected_buyer_code) {
                //consele.log('selected buyer=', JSON.stringify(buyer));
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
        //consele.log("handleExportTypeChange selected export type ", e.detail.selectedValue);
        if (this.exportType === "Export of Services") {
            this.user_type = this.label.Client;
            this.user_type_small = this.label.client_small;
            this.shipment_or_invoice = this.label.invoices;
            this.label_payment_term_info = this.label.OA_90days;
            this.hide_payment_term_info_icon = true;
            this.show_payment_term_info = false;
            this.hide_country_lists = true;
            this.label_unpaid_shipment = this.label.invoices_for_services_rendered;
            this.section1.label = this.label.Section_A_Client_Information;
            this.select_buyer_placeholder = 'Select Client';
        } else {
            this.user_type = this.label.Buyer;
            this.user_type_small = this.label.buyer_small;
            this.shipment_or_invoice = this.label.shipments;
            this.label_payment_term_info = this.label.Payment_Term_OA_DA_DP_90_days;
            this.hide_payment_term_info_icon = false;
            this.hide_country_lists = false;
            this.label_unpaid_shipment = this.label.shipments;
            this.section1.label = this.label.Section_A_Buyer_Information;
            this.select_buyer_placeholder = 'Select Buyer';
        }
    }
    handleCLAmountChange(e) {
        this.application_amount = e.target.value;
        this.application_amount = this.application_amount.toLocaleString();
        this.application_amount2 = e.target.value;
    }
    handleOriginCountryChange(e) {
        this.country_origin = e.target.value;        
    }
    handleBuyerCountryChange(e) {
        this.buyer_country = e.target.value;
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
    handleUnpaidAmountChange(e) {
        this.unpaid_amount = e.detail.selectedValue;
        //consele.log("Unpaid amount change", this.unpaid_amount);
    }
    handleUnpaidShipmentChange(e) {
        this.unpaid_shipment = e.detail.selectedValue;
        //consele.log("Unpaid shipment change", this.unpaid_shipment);
        if (this.unpaid_shipment === "Yes") {
            this.flag_unpaid_shipment = true;
            var i = this.index;

            this.inv.key = i;
            this.index = this.index + 1;
            this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));
        } else {
            this.flag_unpaid_shipment = false;
            this.index = 0;
            this.invoiceList = [];

        }
    }
    handleAllCorrectChange(e) {
        this.all_correct_consign = !this.all_correct_consign;
        //consele.log("updated val", this.all_correct_consign);
        if ((this.annual_sales === true) && (this.all_correct_consign === true)) {
            this.submit_enable = true;
        } else {
            this.submit_enable = false;
        }
    }
    handleAnualSalesChange(e) {
        this.annual_sales = !this.annual_sales;
        //consele.log("annual sales", this.annual_sales);
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
        //consele.log("handleBuyercode", event.target.value);
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
            //consele.log('serchBuyerDetailsAura response=',result);
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
                //consele.log("error in serchBuyerDetailsAura", JSON.stringify(error));
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
                'buyer_country': 'USA',
                'buyer_reg_no': 'R7979'
            });
            this.buyer_search_result.push({
                'buyer_name': 'LPG Buyer',
                'buyer_code': '90505',
                'buyer_address1': 'Unit 123',
                'buyer_address2': '90 jkl st.',
                'buyer_address3': 'California',
                'buyer_address4': 'USA',
                'buyer_country': 'USA',
                'buyer_reg_no': 'R8080'
            });*/
        }
    }
    handleShowBuyerSearch() {
        this.search_buyer = true;
    }
    handleBuyerSelect(e) {
        //consele.log('handleBuyerSelect, buyer code=', e.currentTarget.dataset.id);
        let selected_buyer_code = e.currentTarget.dataset.id;
        let self = this;
        this.buyer_search_result.map((buyer) => {
            if (buyer.index == selected_buyer_code) {
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
        //consele.log('handleCreditCheckFacility');
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;
    }
    formatDate() {
        //consele.log('formatDate');
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
    getDaysBetween(first_day, second_day) {
        const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
        const diffDays = Math.round(Math.abs((first_day - second_day) / oneDay));
        // //consele.log('getDaysBetween diffDays=',diffDays);
        return diffDays;
    }
    checkValidation() {
        try {
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
            var yyyy = today.getFullYear();
            today = yyyy + '-' + mm + '-' + dd;
            //consele.log('checking validation');
            let form_valid = true;
            // //consele.log('this.harmonized_code',this.harmonized_code);
            // //consele.log('this.harmonized_code.length',this.harmonized_code.length);
            //consele.log('this.uplift_reapply', this.uplift_reapply);
            //consele.log('isClUplifted=', this.isClUplifted);
            /*if ((this.harmonized_code === "") || (this.harmonized_code.trim().length === 0)) {
                form_valid = false;//`[data-id="${harmonized_code}"]`
                //this.template.querySelector("lightning-input[data-id='${harmonized_code}']").focus();
                //consele.log('harmonised code error');
                this.showToast("Please Enter Harmonized Code");
                
            } else*/
            //consele.log('invoice length=',this.invoiceList.length);
            //consele.log('unpaid_shipment=',this.unpaid_shipment);
            //consele.log('buyer_address_line1=',this.buyer_address_line1);
            //consele.log('buyer_address_line2=',this.buyer_address_line2);
            //consele.log('buyer_address_line3=',this.buyer_address_line3);
            //consele.log('buyer_address_line4=',this.buyer_address_line4);
            //consele.log('buyer_address_line4 length=',this.buyer_address_line4.length);
            if (this.exportType.trim() === '') {
                form_valid = false;
                let msg = 'Please select Export of Goods/ Export of Services.';
                this.showToast(msg);
            } else if (this.is_credit_limit_exist.trim() === '') {
                form_valid = false;
                let msg = 'Please select if you have a valid credit limit with this buyer or not.';
                this.showToast(msg);
            } else if (this.buyer_name.trim().length < 3) {
                form_valid = false;
                let msg = 'Invalid Buyer Name.';
                this.showToast(msg);
            } else if (this.buyer_address_line1.trim().length < 2) {
                form_valid = false;
                let msg = 'Invalid Buyer Address.';
                this.showToast(msg);
            } else if (this.buyer_country.trim() === '') {
                form_valid = false;
                let msg = 'Please Select ' + this.user_type + ' Country / Market';
                this.showToast(msg);
            } else if ((this.application_amount === '') || (this.application_amount <= 0)) {
                form_valid = false;
                let msg = 'Invalid Application Amount.';
                this.showToast(msg);
            } else if (this.harmonized_code.length < 8) {
                form_valid = false;
                let msg = 'Invalid Harmonized Code.';
                this.showToast(msg);
            } else if (this.exportType.trim() === 'Export of Goods') {
                //consele.log('this.exportType=',this.exportType);
                if (this.shipment_country.trim() === '') {
                    form_valid = false;
                    let msg = 'Please select Country / Market of Shipment (Port of Loading).';
                    this.showToast(msg);
                } else if (this.destination_country.trim() === '') {
                    form_valid = false;
                    let msg = 'Please select Destination Country / Market.';
                    this.showToast(msg);
                } else if (this.country_origin.trim() === '') {
                    form_valid = false;
                    let msg = 'Please select Country / Market of Origin.';
                    this.showToast(msg);
                }
            }
             if (this.unpaid_amount.trim() === '') {
                form_valid = false;
                let msg = 'Please select: Is there any amount currently unpaid for more than 30 days from the due date for this' + this.user_type_small + '?';
                this.showToast(msg);
            } else if (this.unpaid_shipment.trim() === '') {
                form_valid = false;
                let msg = 'Please select: Does this ' + this.user_type_small + ' have any unpaid, ' + this.shipment_or_invoice +' (whether due or not)?';
                this.showToast(msg);
            } else if ((this.unpaid_shipment.trim() === 'Yes') && (this.invoiceList.length === 0)) {
                form_valid = false;
                let msg = 'Please provide Unpaid Shipment Details';
                this.showToast(msg);
            }
            if ((this.unpaid_shipment.trim() === 'Yes') && (this.invoiceList.length !== 0)) {
                //consele.log('Condition matched invoiceList=',JSON.stringify(this.invoiceList));
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
            if (this.unpaid_amount === 'Yes') {
                //consele.log('unpaid error');
                form_valid = false;
                let msg = 'You can not apply for a credit limit on this buyer if there are any amounts currently unpaid for more than 30 days from the due date. Please submit a risk management case.';
                this.showToast(msg);
            } else if (this.uplift_reapply === 'Uplift') {
                if (this.isClUplifted) {
                    form_valid = false;
                    let msg = 'You cannot uplift this credit limit.';
                    this.showToast(msg);
                } else {
                    //consele.log('this.clExpiryDate', this.clExpiryDate);
                    //consele.log('this.CL_Effective_Date__c', this.clEffectiveDate);
                    //consele.log('this.clExpiryDate.toString()).valueOf()', new Date(this.clExpiryDate.toString()).valueOf());
                    let date_dif = new Date(today.toString()).valueOf() <= new Date(this.clExpiryDate.toString()).valueOf() ? this.getDaysBetween(new Date(this.clEffectiveDate), new Date(today)) : '';
                    //consele.log('date_dif=', date_dif);

                    if ((date_dif !== '') && (date_dif >= 91)) {
                        form_valid = false;
                        let msg = 'You cannot uplift this credit limit.';
                        this.showToast(msg);
                    } else if ((this.unpaid_amount === 'Yes') || (this.unpaid_shipment === 'Yes')) {
                        //consele.log('unpaid error');
                        form_valid = false;
                        let msg = 'You can not ' + this.uplift_reapply + ' this credit limit.';
                        this.showToast(msg);
                    } else {
                        this.unpaid_amount = 'No';
                        this.unpaid_shipment = 'No';
                    }
                }
            } else if (this.uplift_reapply === 'Reapply') {
                //consele.log('Reapply');
                //consele.log('clEffectiveDate', this.clEffectiveDate);
                //consele.log('clExpiryDate', this.clExpiryDate);
                let date_dif = new Date(today.toString()).valueOf() <= new Date(this.clExpiryDate.toString()).valueOf() ? this.getDaysBetween(new Date(this.clEffectiveDate), new Date(today)) : '';
                //consele.log('date_dif', date_dif);
                if ((date_dif !== '') && ((date_dif <= 90) || (date_dif > 120))) {
                    form_valid = false;
                    let msg = 'You cannot reapply this credit limit.';
                    this.showToast(msg);
                } else if ((this.unpaid_amount === 'Yes') || (this.unpaid_shipment === 'Yes')) {
                    //consele.log('unpaid error');
                    form_valid = false;
                    let msg = 'You cannot reapply this credit limit.';
                    this.showToast(msg);
                } else {
                    this.unpaid_amount = 'No';
                    this.unpaid_shipment = 'No';
                }
            } else if ((this.uplift_reapply === 'Uplift') || (this.uplift_reapply === 'Reapply')) {
                //consele.log('uplift error');
                if ((this.unpaid_amount === 'Yes') || (this.unpaid_shipment === 'Yes')) {
                    //consele.log('unpaid error');
                    form_valid = false;
                    let msg = 'You cannot uplift this credit limit.';
                    this.showToast(msg);
                } else {
                    this.unpaid_amount = 'No';
                    this.unpaid_shipment = 'No';
                }
            }
            //consele.log('form_valid', form_valid);
            return form_valid;
        } catch (error) {
            //consele.log('error=', JSON.stringify(error));
            console.error('error=', JSON.stringify(error));
        }
    }
    validateHarmonizedCode(){
        /*this.loading = true;
        validateHrmCodeAura({
            hrmCode:this.harmonized_code
        })
        .then((result) => {
            //consele.log('validateHrmCodeAura=',result);
            this.loading = false;
            let result_json = JSON.parse(result);
            if(result_json.rtn_code == 1) {*/
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
                    legacy_shipment_country: this.legacy_shipment_country,
                    destination_country: this.destination_country,
                    legacy_destination_country: this.legacy_destination_country,
                    country_origin: this.country_origin,
                    legacy_country_origin: this.legacy_country_origin,
                    pending_invoice_list: this.invoiceList,
                    is_credit_limit_exist: this.is_credit_limit_exist,
                    uplift_reapply: this.uplift_reapply,
                    unpaid_amount: this.unpaid_amount,
                    unpaid_shipment: this.unpaid_shipment
                };
                var params = {
                    'cl_fields': fields,
                    'Pagename': 'ApplicationConfirmation',
                    'policy_detail': this.policy_detail
                }
                let event1 = new CustomEvent('handlepagechange', {
                    // detail contains only primitives
                    detail: params
                });
                this.dispatchEvent(event1);
            /*} else {
                let msg = 'Invalid Harmonized Code.';
                this.showToast(msg);
            }
        })
        .catch((error) => {
            //consele.log('error on validateHrmCodeAura::', JSON.stringify(error));
            console.error('error on validateHrmCodeAura::', JSON.stringify(error));
        });*/
    }

    handleNext() {
        if (this.checkValidation()) {
            this.validateHarmonizedCode();
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
        //consele.log("handleSave");
        //consele.log("policy_detail=", this.policy_detail);
        
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
        //consele.log('Fields=',JSON.stringify(fields));
        var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
        createRecord(objRecordInput).then(response => {
            //consele.log('cla created with Id: ' + response.id);  
            if (this.draft_id !== '') {
                DeleteDraft({
                    cla_id: this.draft_id
                }).then((result) => {
                    //consele.log('Old draft deleted');
                })
                .catch((error) => {
                    //consele.log('error on Old draft delete::', JSON.stringify(error));
                    console.error('error Old draft delete::', JSON.stringify(error));
                });
            }                      
            if (this.invoiceList.length > 0) {
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
                //consele.log("error in outstanding payment record creation", JSON.stringify(error));
                console.error("error in outstanding payment record creation", JSON.stringify(error));
            });
    }
    callgetExistingBuyers() {
        getExistingBuyers({
            policy_id: this.policy_detail.Id
        })
            .then((result) => {
                //consele.log("Existing buyer=", JSON.stringify(result));
                this.buyer_info = result;
            })
            .catch((error) => {
                //consele.log('error::', JSON.stringify(error));
                console.error('error::', JSON.stringify(error));
            });
    }
    /*callgetCountryList() {
        getCountryList()
        .then((result) => {
            this.countryOptions = result.map((country)=>({label:country.Full_Country_Name__c,value:country.Full_Country_Name__c,code:country.Country_Code__c}));
            this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
        })
        .catch((error) => {
            //consele.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        });
    }*/
    renderedCallback() {
        if (!this.is_rendered) {
            this.is_rendered = true;
            //consele.log("policyinfo=", JSON.stringify(this.policyinfo));

            if (Object.keys(this.policyinfo).length > 0) {
                let accId = this.policyinfo.accId;
                this.acc_id = this.policyinfo.accId;
                getPolicyDetails({
                    acc_id: accId
                })
                    .then((result) => {
                        //consele.log("Policy details=", JSON.stringify(result));
                        this.policy_detail = result;
                        this.account_name = result.Exporter__r.Name;
                        this.policy_no = result.Legacy_Customer_Number__c;
                        this.policy_type = result.Product__r.Name;
                        this.available_credit_check_facility = result.Available_Credit_Check__c;
                        this.legacy_policy_type = result.Legacy_Policy_Type__c;
                        this.callgetExistingBuyers();
                        // this.callgetCountryList();
                    })
                    .catch((error) => {

                        //consele.log(error);
                    });
                if (this.policyinfo.hasOwnProperty('clRecord')) {
                    //consele.log('application_type=', this.policyinfo.clRecord[0].application_type);
                    if (this.policyinfo.clRecord[0].application_type === 'Uplift') {
                        this.isNewApplication = false;
                        this.credit_limit_record = this.policyinfo.clRecord[0];
                        //consele.log('credit_limit_record=', JSON.stringify(this.credit_limit_record));

                        this.credit_limit_id = this.credit_limit_record.Id;
                        let app_amount_temp = this.credit_limit_record.CL_Application_Amount__c;
                        app_amount_temp = app_amount_temp.replace(',', '');
                        this.application_amount = Number(app_amount_temp);
                        this.application_amount_min = this.application_amount;
                        this.exportType = this.credit_limit_record.Export_Type__c;
                        //consele.log('export type', this.credit_limit_record.Export_Type__c);
                        if(this.credit_limit_record.Buyer_Address_Line_1__c) {
                            this.buyer_address_line1 = this.credit_limit_record.Buyer_Address_Line_1__c;
                        }
                        
                        //consele.log('this.credit_limit_record.Buyer_Address_Line_1__c', this.credit_limit_record.Buyer_Address_Line_1__c);
                        if(this.credit_limit_record.Buyer_Address_Line_2__c) {
                            this.buyer_address_line2 = this.credit_limit_record.Buyer_Address_Line_2__c;
                        }
                        if(this.credit_limit_record.Buyer_Address_Line_3__c) {
                            this.buyer_address_line3 = this.credit_limit_record.Buyer_Address_Line_3__c;
                        }
                        if(this.credit_limit_record.Buyer_Address_Line_4__c) {
                            this.buyer_address_line4 = this.credit_limit_record.Buyer_Address_Line_4__c;
                        }
                        this.buyer_code = this.credit_limit_record.Buyer_Code__c;
                        this.buyer_name = this.credit_limit_record.Buyer_Name__c;
                        this.buyer_country = this.credit_limit_record.Buyer_Country__c;
                        this.registration_no = this.credit_limit_record.Buyer_Registration_Number__c;
                        this.harmonized_code = this.credit_limit_record.Harmonized_Code__c;
                        // this.payment_terms_value = this.credit_limit_record.Payment_Term_Type__c;
                        // this.payment_terms_days = this.credit_limit_record.Payment_Term_Days__c;
                        this.shipment_country = this.credit_limit_record.Port_Of_Loading__c;
                        this.destination_country = this.credit_limit_record.Destination_Market__c;
                        this.country_origin = this.credit_limit_record.Market_of_Origin__c;
                        this.uplift_reapply = this.credit_limit_record.application_type;
                        this.clExpiryDate = this.credit_limit_record.Expiry_Date__c;
                        this.clEffectiveDate = this.credit_limit_record.CL_Effective_Date__c;
                        this.clApplicationDate = this.credit_limit_record.Application_Date__c;
                        this.show_buyer_section = true;
                        this.manual_buyer_input = false;
                        this.show_uplift_reapplt_option = true;
                        this.is_credit_limit_exist = 'Yes';
                        if (this.exportType === 'Export of Goods') {
                            this.user_type = this.label.Buyer;
                            this.user_type_small = this.label.buyer_small;
                            this.shipment_or_invoice = this.label.shipments;

                        } else {
                            this.user_type = this.label.Client;
                            this.user_type_small = this.label.client_small;
                            this.section1.label = this.label.Section_A_Client_Information;
                            this.shipment_or_invoice = this.label.invoices;
                        }
                        let self = this;
                        this.countryOptions.map((country)=>{if(country.value === self.country_origin){self.legacy_country_origin = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.buyer_country){self.legacy_buyer_country = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.shipment_country){self.legacy_shipment_country = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.destination_country){self.legacy_destination_country = country.code}});
                        // this.show_buyer_select = true;
                    } else if (this.policyinfo.clRecord[0].application_type === 'Reapply') {
                        this.isNewApplication = false;
                        this.credit_limit_record = this.policyinfo.clRecord[0];
                        //consele.log('credit_limit_record=', JSON.stringify(this.credit_limit_record));

                        this.credit_limit_id = this.credit_limit_record.Id;
                        //consele.log('this.credit_limit_record.CL_Application_Amount__c=', this.credit_limit_record.CL_Application_Amount__c);
                        let app_amount_temp = this.credit_limit_record.CL_Application_Amount__c;
                        app_amount_temp = app_amount_temp.replace(',', '');
                        this.application_amount = Number(app_amount_temp);
                        //consele.log('application_amount=', this.application_amount);
                        // this.application_amount_min = this.application_amount;
                        this.exportType = this.credit_limit_record.Export_Type__c;
                        //consele.log('export type', this.credit_limit_record.Export_Type__c);
                        if(this.credit_limit_record.Buyer_Address_Line_1__c) {
                            this.buyer_address_line1 = this.credit_limit_record.Buyer_Address_Line_1__c;
                        }
                        if(this.credit_limit_record.Buyer_Address_Line_2__c) {
                            this.buyer_address_line2 = this.credit_limit_record.Buyer_Address_Line_2__c;
                        }
                        if(this.credit_limit_record.Buyer_Address_Line_3__c) {
                            this.buyer_address_line3 = this.credit_limit_record.Buyer_Address_Line_3__c;
                        }
                        if(this.credit_limit_record.Buyer_Address_Line_4__c) {
                            this.buyer_address_line4 = this.credit_limit_record.Buyer_Address_Line_4__c;
                        }
                        this.buyer_code = this.credit_limit_record.Buyer_Code__c;
                        this.buyer_name = this.credit_limit_record.Buyer_Name__c;
                        this.buyer_country = this.credit_limit_record.Buyer_Country__c;
                        this.registration_no = this.credit_limit_record.Buyer_Registration_Number__c;
                        this.harmonized_code = this.credit_limit_record.Harmonized_Code__c;
                        // this.payment_terms_value = this.credit_limit_record.Payment_Term_Type__c;
                        // this.payment_terms_days = this.credit_limit_record.Payment_Term_Days__c;
                        this.shipment_country = this.credit_limit_record.Port_Of_Loading__c;
                        this.destination_country = this.credit_limit_record.Destination_Market__c;
                        this.country_origin = this.credit_limit_record.Market_of_Origin__c;
                        this.uplift_reapply = this.credit_limit_record.application_type;
                        this.clExpiryDate = this.credit_limit_record.Expiry_Date__c;
                        this.clEffectiveDate = this.credit_limit_record.CL_Effective_Date__c;
                        this.clApplicationDate = this.credit_limit_record.Application_Date__c;
                        this.show_buyer_section = true;
                        this.manual_buyer_input = false;
                        this.show_uplift_reapplt_option = true;
                        this.is_credit_limit_exist = 'Yes';
                        if (this.exportType === 'Export of Goods') {
                            this.user_type = this.label.Buyer;
                            this.user_type_small = this.label.buyer_small;
                            this.shipment_or_invoice = this.label.shipments;

                        } else {
                            this.user_type = this.label.Client;
                            this.user_type_small = this.label.client_small;
                            this.section1.label = this.label.Section_A_Client_Information;
                            this.shipment_or_invoice = this.label.invoices;
                        }
                        let self = this;
                        this.countryOptions.map((country)=>{if(country.value === self.country_origin){self.legacy_country_origin = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.buyer_country){self.legacy_buyer_country = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.shipment_country){self.legacy_shipment_country = country.code}});
                        this.countryOptions.map((country)=>{if(country.value === self.destination_country){self.legacy_destination_country = country.code}});
                        // this.show_buyer_select = true;
                    }
                } else if (this.policyinfo.hasOwnProperty('clRecordEdit')) {
                    //consele.log('Edit section');
                    let clrecordEditInfo = this.policyinfo.clRecordEdit;
                    //consele.log('clrecordEditInfo', JSON.stringify(clrecordEditInfo));
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
                    this.legacy_shipment_country = clrecordEditInfo.legacy_shipment_country;
                    this.destination_country = clrecordEditInfo.destination_country;
                    this.legacy_destination_country = clrecordEditInfo.destination_country;
                    this.country_origin = clrecordEditInfo.country_origin;
                    this.legacy_country_origin = clrecordEditInfo.legacy_country_origin;
                    new_inv_list = clrecordEditInfo.pending_invoice_list;
                    this.is_credit_limit_exist = clrecordEditInfo.is_credit_limit_exist;
                    this.uplift_reapply = clrecordEditInfo.uplift_reapply;
                    this.unpaid_amount = clrecordEditInfo.unpaid_amount;
                    this.unpaid_shipment = clrecordEditInfo.unpaid_shipment;

                    if (this.unpaid_amount === 'Yes') {
                        //this.flag_unpaid_shipment = true;
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    } else {
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.is_credit_limit_exist === 'Yes') {
                        //this.flag_unpaid_shipment = true;
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
                    if (this.uplift_reapply === 'Uplift') {
                        //this.flag_unpaid_shipment = true;
                        this.uplift_reapply_option = [
                            { label: this.label.Uplift, value: 'Uplift', isChecked: true },
                            { label: this.label.Reapply, value: 'Reapply', isChecked: false },
                        ];
                        this.show_uplift_reapplt_option = true;
                    } else if (this.uplift_reapply === 'Reapply') {
                        this.uplift_reapply_option = [
                            { label: this.label.Uplift, value: 'Uplift', isChecked: false },
                            { label: this.label.Reapply, value: 'Reapply', isChecked: true },
                        ];
                        this.show_uplift_reapplt_option = true;
                    }
                    if (this.exportType === 'Export of Goods') {
                        //this.flag_unpaid_shipment = true;
                        this.export_options = [
                            { label: this.label.Export_of_Goods, value: 'Export of Goods', isChecked: true },
                            { label: this.label.Export_of_Services, value: 'Export of Services', isChecked: false },
                        ];
                    } else {
                        this.export_options = [
                            { label: this.label.Export_of_Goods, value: 'Export of Goods', isChecked: false },
                            { label: this.label.Export_of_Services, value: 'Export of Services', isChecked: true },
                        ];
                        this.section1.label = this.label.Section_A_Client_Information;
                        this.user_type = this.label.Client;
                        this.user_type_small = this.label.client_small;
                        this.shipment_or_invoice = this.label.invoices;
                    }



                    if (this.unpaid_shipment === 'Yes') {
                        this.flag_unpaid_shipment = true;
                        this.unpaid_shipment_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                        let self = this;
                        this.index = new_inv_list.length;
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
                        })
                    } else {
                        this.unpaid_shipment_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    /*let open_section = this.policyinfo.section;
                    if (open_section === 'section1') {
                        this.section1.isSectionOpen = true;
                        this.section1.iconName = 'utility:up';
                        this.section2.isSectionOpen = false;
                        this.section2.iconName = 'utility:down';
                    } else {
                        this.section2.isSectionOpen = true;
                        this.section2.iconName = 'utility:up';
                        this.section1.isSectionOpen = false;
                        this.section1.iconName = 'utility:down';
                    }*/
                } else if (this.policyinfo.hasOwnProperty('clRecordDraft')) {
                    let clrecordDraftInfo = this.policyinfo.clRecordDraft;
                    //consele.log('clrecordEditInfo', JSON.stringify(clrecordDraftInfo));
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
                    // if(clrecordDraftInfo.Is_New_Buyer__c)
                    //     this.is_new_buyer = clrecordDraftInfo.Is_New_Buyer__c;
                                        
                    if(this.goods_involved === 'Miscellaneous (Products)') {
                        this.is_miscellaneous = true;
                    } else {
                        this.is_miscellaneous = false;
                    }                    
                    
                    if (this.unpaid_shipment === 'Yes') {
                        this.flag_unpaid_shipment = true;
                        this.unpaid_shipment_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                        let self = this;
                        this.index = new_inv_list.length;
                        //consele.log('new_inv_list.length=',new_inv_list.length);
                        let new_inv_list1 = [];
                        new_inv_list.map((each_el,i)=>{
                            new_inv_list1.push({
                                key:i,
                                ...each_el
                            })
                        });
                        //consele.log('new_inv_list1=',JSON.stringify(new_inv_list1));
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
                        //consele.log('this.invoiceList=',JSON.stringify(this.invoiceList));
                    } else if (this.unpaid_shipment === 'No') {
                        this.unpaid_shipment_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }

                    if (this.unpaid_amount === 'Yes') {
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: true },
                            { label: this.label.No, value: 'No', isChecked: false },
                        ];
                    } else if (this.unpaid_amount === 'No') {
                        this.unpaid_options = [
                            { label: this.label.Yes, value: 'Yes', isChecked: false },
                            { label: this.label.No, value: 'No', isChecked: true },
                        ];
                    }
                    if (this.exportType === 'Export of Goods') {
                        //this.flag_unpaid_shipment = true;
                        this.export_options = [
                            { label: this.label.Export_of_Goods, value: 'Export of Goods', isChecked: true },
                            { label: this.label.Export_of_Services, value: 'Export of Services', isChecked: false },
                        ];
                    } else if (this.exportType === 'Export of Services') {
                        this.export_options = [
                            { label: this.label.Export_of_Goods, value: 'Export of Goods', isChecked: false },
                            { label: this.label.Export_of_Services, value: 'Export of Services', isChecked: true },
                        ];
                        this.section1.label = this.label.Section_A_Client_Information;
                        this.user_type = this.label.Client;
                        this.user_type_small = this.label.client_small;
                        this.shipment_or_invoice = this.label.invoices;
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
                }

            }
        }
        /*this.buyer_info.push({
            'buyer_name':'ABC Buyer',
            'buyer_code':'12345',
            'buyer_address1':'Unit 123',
            'buyer_address2':'456 Dune street',
            'buyer_address3':'Michigan',
            'buyer_address4':'USA',
            'buyer_country':'USA',
            'buyer_reg_no':'R7979'
        });
        this.buyer_info.push({
            'buyer_name':'LPG Buyer',
            'buyer_code':'90505',
            'buyer_address1':'Unit 123',
            'buyer_address2':'90 jkl st.',
            'buyer_address3':'California',
            'buyer_address4':'USA',
            'buyer_country':'USA',
            'buyer_reg_no':'R8080'
        });*/

    }
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
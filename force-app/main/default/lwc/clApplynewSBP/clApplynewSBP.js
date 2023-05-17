import { LightningElement, track, api, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getExistingBuyers from '@salesforce/apex/CLApplicationRecord.getExistingBuyers';
// import getCountryList from '@salesforce/apex/CLApplicationRecord.getCountryList';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';
import serchBuyerDetailsAura from '@salesforce/apex/ECIC_CL_API_Methods.serchBuyerDetailsAura';
import getProduct from '@salesforce/apex/GetCustomMetaData.getProduct';
import getBuyerCountryListByPolicy from '@salesforce/apex/GetCustomMetaData.getBuyerCountryListByPolicy';

export default class ClApplynewSBP extends LightningElement {
    @api policyinfo;
    @track is_rendered = false;
    @track account_name = "";
    @track acc_id = "";
    @track policy_no = "";
    @track policy_type = "";
    @track available_credit_check_facility = "";
    @track section1 = { Id: 1, iconName: 'utility:up', isSectionOpen: true, label: 'Part A (Buyer Information)' }
    @track section2 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: 'Part B (Trading Experience)' }
    @track section3 = { Id: 2, iconName: 'utility:down', isSectionOpen: false, label: 'Part C (Order Information)' }
    @api exportType = "";
    @api unpaid_amount = "";
    @api unpaid_shipment = "";
    @api user_type = "Buyer";
    @track user_type_small = 'buyer';
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
    @api label_payment_term_info = "Payment Term OA / DA / DP ≤ 90 days";
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
        { label: 'Export of Goods (Post-shipment risk only)', value: 'Export of Goods (Post-shipment risk only)', isChecked: false },
        { label: 'Export of Goods (Pre-shipment and post-shipment risk)', value: 'Export of Goods (Pre-shipment and post-shipment risk)', isChecked: false },
        { label: 'Export of Services', value: 'Export of Services', isChecked: false }
    ];
    @track existing_credit_limit = [
        { label: 'Yes', value: 'Yes', isChecked: false },
        { label: 'No', value: 'No', isChecked: false },
    ];
    @api is_credit_limit_exist = '';
    @track unilaterally_cancel_order_options = [
        { label: 'Yes', value: 'Yes', isChecked: false },
        { label: 'No', value: 'No', isChecked: false },
    ];
    @track unilaterally_cancel_order = '';
    @track hkg_goods_exported = '';
    @track hkg_goods_exported_options =[
        { label: 'Yes', value: 'Yes', isChecked: false },
        { label: 'No', value: 'No', isChecked: false },
    ];
    @track uplift_reapply_option = [
        { label: 'Uplift', value: 'Uplift', isChecked: false },
        { label: 'Reapply', value: 'Reapply', isChecked: false },
    ];
    @api uplift_reapply = '';
  
    
    
    @track payment_terms = [
        { value: 'DA', label: 'DA' },
        { value: 'DP', label: 'DP' },
        { value: 'OA', label: 'OA' }
    ];
    @track invoice_payment_terms = [
        { value: 'DA', label: 'DA' },
        { value: 'DP', label: 'DP' },
        { value: 'OA', label: 'OA' }
    ];
    
    @track payment_terms_value = 'OA';
    @track payment_terms_days = 120;
    @track payment_terms_value_pre_shipment = 'OA';
    @track payment_terms_days_pre_shipment = 120;
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
    @track credit_limit_id2 = '';
    @track isNewApplication = true;
    @track application_amount_min = 50000;
    @track application_amount_max = 5000000;
    @track isClUplifted = false;
    @track clExpiryDate = '';
    @track clEffectiveDate = '';
    @track show_qs_4_5 = false;
    @track goods_involved = '';
    @track specific_goods_involved = '';
    @track is_new_buyer = '';
    @track new_buyer_options = [
        { label: 'Yes', value: 'Yes', isChecked: false },
        { label: 'No', value: 'No', isChecked: false },
    ];
    @track buyer_trading_time = '';
    @track payment_term_amount = '';
    @track show_new_buyer_detail = false;
    @track payment_term_order_amount = '';
    @track shipment_commencement_month = '';
    @track shipment_commencement_year = '';
    @track remarks = '';
    @track order_confirm_negotiation_options = [
        { value: 'Yes, orders confirmed', label: 'Yes, orders confirmed' },
        { value: 'Yes, orders under negotiation', label: 'Yes, orders under negotiation' },
        { value: 'No', label: 'No' }
    ];
    @track order_confirm_negotiation_value = '';
    @track show_order_confirm_negotiation_detail = false;
    @track shipment_payment_terms_value = '';
    @track shipment_payment_terms_days = '';
    @track order_payment_terms_value = '';
    @track order_payment_term_days = '';
    
    @track overdue_payment_order = '';
    @track overdue_payment_order_options = [
        { label: 'Yes', value: 'Yes', isChecked: false },
        { label: 'No', value: 'No', isChecked: false },
    ];
    @track received_payment_amount = '';
    @track received_payment_term = '';
    @track received_payment_term_days = '';
    @track received_payment_term_method1 = '';
    @track received_payment_term_method1_id = false;
    @track received_payment_term_method2 = '';
    @track received_payment_term_method2_id = false;
    @track shipment_payment_terms_amount = '';
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
    @track order_payment_term_method1_12months_id = false;
    @track order_payment_term_method2_12months = '';
    @track order_payment_term_method2_12months_id = false;
    @track order_payment_term_method3_12months = '';
    @track order_payment_term_method3_12months_id = false;
    @track order_payment_term_method4_12months = '';
    @track order_payment_term_method4_12months_id = false;
    @track order_payment_term_method5_12months = '';
    @track order_payment_term_method5_12months_id = false;
    @track order_payment_terms_type_12months = '';
    @track order_payment_terms_days_12month = '';

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
    @track unpaid_days = 60;
    @track countryOptions = [];
    @track loading = false;
    @track draft_id = '';
    @track secB_q2 = 'How many years have you been trading with this buyer?';
    @track secB_q3 = 'shipments you made to this buyer'
    @track search_buyer_name  = '';
    @track search_buyer_reg_no = '';
    @track search_buyer_name_disable  = false;
    @track search_buyer_reg_no_disable = false;
    @track select_buyer_placeholder = 'Select Buyer';
    @track mandatory_mark = '*';
    @track buyer_search_loading = false;
    @track goodsOptions = [];
    @track duns_no = '';
    @track buyer_source = '';
    @track buyer_agency_ref = '';
    @track buyer_country_options = [];

    @wire(getBuyerCountryListByPolicy,{policy_type:'51'})
    handleBuyerCountryList({ error, data }) {
        //console.log('handleBuyerCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.buyer_country_options = data.map((each_el)=>({label:each_el.ByrCtry_Country_Name__c,value:each_el.ByrCtry_Country_Name__c}));
            this.buyer_country_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in getBuyerCountryList=' + JSON.stringify(error))
        }
    }
    

    @wire(getProduct)
    handleProductList({ error, data }) {
        //console.log('handleProductList data=' + JSON.stringify(data))
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
        this.section1.isSectionOpen = !this.section1.isSectionOpen
        this.section1.iconName = this.section1.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    expandHandler2(event) {
        this.section2.isSectionOpen = !this.section2.isSectionOpen
        this.section2.iconName = this.section2.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    expandHandler3(){
        this.section3.isSectionOpen = !this.section3.isSectionOpen
        this.section3.iconName = this.section3.isSectionOpen ? 'utility:up' : 'utility:down'
    }
    handleHkgGoodsExported(e){
        this.hkg_goods_exported = e.detail.selectedValue;
    }

    addRow() {
        var i = this.index;        
        this.inv.key = i;
        this.invoiceList.push(JSON.parse(JSON.stringify(this.inv)));
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
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.invoiceList[key].InvoiceCurrency = e.target.value;
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
        this.is_credit_limit_exist = e.detail.selectedValue;
        if (this.is_credit_limit_exist === 'Yes') {
            let buyer_list_with_duplicates = this.buyer_info.map((buyer) => ({ label: buyer.Buyer_Name__c, value: buyer.Buyer_Code__c }));
            var out = [];

            for (var i = 0; i < buyer_list_with_duplicates.length; i++) {
                var unique = true;
                for (var j = 0; j < out.length; j++) {
                    if ((buyer_list_with_duplicates[i].label === buyer_list_with_duplicates[j].label) && (buyer_list_with_duplicates[i].value === buyer_list_with_duplicates[j].value)) {
                        unique = false;
                    }
                }
                if (unique) {
                    out.push(buyer_list_with_duplicates[i]);
                }
            }
            
            this.existing_buyer_list = out;
            this.show_buyer_select = true;
            this.enable_buyer_edit = false;
            this.manual_buyer_input = false;
            this.show_buyer_section = false;
            this.show_buyer_search_link = false;
            this.uplift_reapply = 'Reapply';
        } else {
            this.existing_buyer_list = [];
            this.show_buyer_select = false;
            this.show_buyer_section = true;
            this.enable_buyer_edit = true;
            this.manual_buyer_input = true;
            this.show_buyer_search_link = true;
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
        var selected_buyer_code = e.detail.value;
        let self = this;
        let selected_buyer_array = [];
        this.buyer_info.map((buyer) => {
            if (buyer.Buyer_Code__c === selected_buyer_code) {
                //console.log('selected buyer=', JSON.stringify(buyer));
                selected_buyer_array.push(buyer);
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
                if (selected_buyer_array.length > 1) {
                    self.credit_limit_id = selected_buyer_array[0].Id;
                    self.credit_limit_id2 = selected_buyer_array[1].Id;
                } else {
                    self.credit_limit_id = selected_buyer_array[0].Id;
                }
            }
        });
        this.show_buyer_select = false;
        this.show_buyer_section = true;
        this.show_qs_4_5 = this.buyer_country.toUpperCase() === 'HONG KONG'? true : false;
        this.unpaid_days = this.buyer_country.toUpperCase() === 'HONG KONG'? 30 : 60;
        if (this.buyer_code.includes('HKG')) {
            this.unpaid_days = 30;
        } 
        
        this.countryOptions.map((country)=>{if(country.value === self.buyer_country){self.legacy_buyer_country = country.code}});
    }
    handleEdit(e) {
        this.enable_buyer_edit = true;
    }
    handleUpliftReapplyChange(e) {
        this.uplift_reapply = e.detail.selectedValue;
    }

    handleExportTypeChange(e) {
        this.exportType = e.detail.selectedValue;
        if (this.exportType === "Export of Services") {
            this.user_type = "Client";
            this.user_type_small = 'client';
            this.label_payment_term_info = "OA ≤ 90days";
            this.hide_payment_term_info_icon = true;
            this.show_payment_term_info = false;
            this.hide_country_lists = true;
            this.label_unpaid_shipment = "invoices for services rendered";
            this.is_service = true;
            this.is_postshipment = false;
            this.is_preshipment = false;
            this.section1.label = 'Part A (Client Information)';
            this.goods_involved = '';
            this.secB_q2 = 'How long have you been rendering services to this client?'
            this.secB_q3 = 'service rendered to the client';
            this.select_buyer_placeholder = 'Select Client';
        } else {
            this.user_type = "Buyer";
            this.user_type_small = 'buyer';
            this.label_payment_term_info = "Payment Term OA / DA / DP ≤ 90 days";
            this.hide_payment_term_info_icon = false;
            this.hide_country_lists = false;
            this.label_unpaid_shipment = "shipments";
            this.section1.label = 'Part A (Buyer Information)';
            this.goods_involved = '';
            this.secB_q2 = 'How many years have you been trading with this buyer?'
            this.secB_q3 = 'shipments you made to this buyer';
            this.select_buyer_placeholder = 'Select Buyer';

            if(this.exportType === 'Export of Goods (Post-shipment risk only)') {
                this.is_service = false;
                this.is_postshipment = true;
                this.is_preshipment = false;
            } else if(this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') {
                this.is_service = false;
                this.is_postshipment = false;
                this.is_preshipment = true;
            }
        } 
    }
    handleCLAmountChange(e) {
        this.application_amount = e.target.value;
    }
    handleCLAPreShipmentAmountChange(e) {
        this.application_amount_pre_shipment = e.target.value;
    }
    handleOriginCountryChange(e) {
        this.country_origin = e.target.value;
    }
    handleBuyerCountryChange(e) {
        this.buyer_country = e.target.value;
        this.show_qs_4_5 = this.buyer_country.toUpperCase() === 'HONG KONG'? true : false;
        this.unpaid_days = this.buyer_country.toUpperCase() === 'HONG KONG'? 30 : 60;
        if (this.buyer_code.includes('HKG')) {
            this.unpaid_days = 30;
        }
        let self = this;
        this.countryOptions.map((country)=>{if(country.value === self.buyer_country){self.legacy_buyer_country = country.code}});
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
        if (this.is_new_buyer === 'Yes'){
            this.show_new_buyer_detail = false;
        } else {
            this.show_new_buyer_detail = true;
        }
    }
    handleShipmentPaymentTerm(e) {
        this.shipment_payment_terms_value = e.target.value;
    }
    handleShipmentPaymentTermDays(e) {
        this.shipment_payment_terms_days = e.target.value;
    }
    handleShipmentPaymentTermAmount(e) {
        this.shipment_payment_terms_amount = e.target.value;
    }
    handleOrderPaymentTermsAmount12Months(e) {
        this.order_payment_terms_amount_12months = e.target.value;
    }
    handleOrderPaymentTermType12Months(e) {
        this.order_payment_terms_type_12months = e.target.value;
    }
    handleOrderPaymentTermDays12Month(e) {
        this.order_payment_terms_days_12month = e.target.value;
    }
    handleOrderPaymentTermMethod112Months(e) {
        if(e.target.checked)
            this.order_payment_term_method1_12months = 'ILC';
        else 
            this.order_payment_term_method1_12months = '';
    }
    handleOrderPaymentTermMethod212Months(e) {
        if(e.target.checked)
            this.order_payment_term_method2_12months = 'Payment in advance';
        else 
            this.order_payment_term_method2_12months = '';
    }
    handleOrderPaymentTermMethod312Months(e) {
        if(e.target.checked)
            this.order_payment_term_method3_12months = 'DA';
        else
            this.order_payment_term_method3_12months = ''; 
        
    }
    handleOrderPaymentTermMethod412Months(e) {
        if(e.target.checked){
            this.order_payment_term_method4_12months = 'DP';
        } else {
            this.order_payment_term_method4_12months = '';
        }
    }
    handleOrderPaymentTermMethod512Months(e) {
        if(e.target.checked){
            this.order_payment_term_method5_12months = 'OA';
        } else {
            this.order_payment_term_method5_12months = '';
        } 
    }
    //---
    handleShipmentPaymentTermMethod1(e) {
        if(e.target.checked){
            this.shipment_payment_term_method1 = 'ILC';
        } else {
            this.shipment_payment_term_method1 = '';
        }        
        //console.log('handleShipmentPaymentTermMethod1',this.shipment_payment_term_method1)      
    }
    handleShipmentPaymentTermMethod2(e) {
        if(e.target.checked){
            this.shipment_payment_term_method2 = 'Payment in advance';
        } else {
            this.shipment_payment_term_method2 = '';
        }  
        //console.log('handleShipmentPaymentTermMethod2',this.shipment_payment_term_method2)      
    }
    handleShipmentPaymentTermMethod3(e) {
        if(e.target.checked){
            this.shipment_payment_term_method3 = 'DA';
        } else {
            this.shipment_payment_term_method3 = '';
        }  
        
    }
    handleShipmentPaymentTermMethod4(e) {
        if(e.target.checked){
            this.shipment_payment_term_method4 = 'DP';
        } else {
            this.shipment_payment_term_method4 = '';
        }
    }
    handleShipmentPaymentTermMethod5(e) {
        if(e.target.checked){
            this.shipment_payment_term_method5 = 'OA';
        } else {
            this.shipment_payment_term_method5 = '';
        } 
    }
    handleUnilaterallyCancelOrder(e) {
        this.unilaterally_cancel_order = e.detail.selectedValue;
    }
    handleOverduePaymentOrder(e){
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
        if (this.order_confirm_negotiation_value.substring(0,3) === 'Yes'){
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
    handlePaymentTermOrderAmount(e){
        this.payment_term_order_amount = e.target.value;
    }
    handleOrderPaymentTermChange(e) {
        this.order_payment_terms_value = e.target.value;
    }
    handleOrderPanymentTermDays(e) {
        this.order_payment_term_days = e.target.value;
    }
    handleConfirmOrderPaymentTermMethod1(e) {
        if(e.target.checked){
            this.confirm_order_payment_terms_method1 = 'ILC';
        } else {
            this.confirm_order_payment_terms_method1 = '';
        }        
        //console.log('handleShipmentPaymentTermMethod1',this.shipment_payment_term_method1)      
    }
    handleConfirmOrderPaymentTermMethod2(e) {
        if(e.target.checked){
            this.confirm_order_payment_terms_method2 = 'Payment in advance';
        } else {
            this.confirm_order_payment_terms_method2 = '';
        }        
        //console.log('handleShipmentPaymentTermMethod1',this.shipment_payment_term_method1)      
    }
    handleConfirmOrderPaymentTermMethod3(e) {
        if(e.target.checked){
            this.confirm_order_payment_terms_method3 = 'DA';
        } else {
            this.confirm_order_payment_terms_method3 = '';
        }
    }
    handleConfirmOrderPaymentTermMethod4(e) {
        if(e.target.checked){
            this.confirm_order_payment_terms_method4 = 'DP';
        } else {
            this.confirm_order_payment_terms_method4 = '';
        }
    }
    handleConfirmOrderPaymentTermMethod5(e) {
        if(e.target.checked){
            this.confirm_order_payment_terms_method5 = 'OA';
        } else {
            this.confirm_order_payment_terms_method5 = '';
        }
    }
    handleShipmentCommenceMonth(e){
        this.shipment_commencement_month = e.target.value;
        //console.log('month=',e.target.value);
    }
    handleShipmentCommenceYear(e){
        this.shipment_commencement_year = e.target.value;
        //console.log('year=',e.target.value);
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
    handleReceivedPaymentTermDays(e) {
        this.received_payment_term_days = e.target.value;
    }
    handleReceivedPaymentTermMethod1(e) {
        if(e.target.checked){
            this.received_payment_term_method1 = 'ILC';
        } else {
            this.received_payment_term_method1 = '';
        }
    }
    handleReceivedPaymentTermMethod2(e) {
        if(e.target.checked){
            this.received_payment_term_method2 = 'Payment in advance';
        } else {
            this.received_payment_term_method2 = '';
        }
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
        //console.log("handleBuyercode", event.target.value);
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
        if(this.goods_involved === 'Miscellaneous (Products)') {
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
        this.search_buyer_name = e.target.value;
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
        this.countryOptions.map((each_el)=>{
            if(self.buyer_country === each_el.value){
                country_code = each_el.code;
            }
        })
        
        serchBuyerDetailsAura({
            'buyer_country': country_code,
            'buyer_name': this.search_buyer_name,
            'br_no': this.search_buyer_reg_no
        }).then((result) => {
            //console.log('serchBuyerDetailsAura response=',result);
            this.buyer_search_loading = false;
            let buyer_list = JSON.parse(result);
            if(buyer_list.meta_data.byr_list.length>0)
                this.buyer_search_result = buyer_list.meta_data.byr_list
        })
            .catch((error) => {
                //console.log("error in serchBuyerDetailsAura", JSON.stringify(error));
                console.error("error in serchBuyerDetailsAura", JSON.stringify(error));
            });
    }
    handleBuyerSearch(e) {
        if(this.searchValidation()){
            this.buyer_search_result = [];
            this.showBuyerModal = true;
            // this.callserchBuyerDetailsAura();
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
        //console.log('handleBuyerSelect, buyer code=', e.currentTarget.dataset.id);
        let selected_buyer_code = e.currentTarget.dataset.id;
        let self = this;
        this.buyer_search_result.map((buyer) => {
            if (buyer.byr_code === selected_buyer_code) {
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
            if (this.exportType.trim() === '') {
                form_valid = false;
                let msg = 'Please select Export of Goods(post-shipment risk only)/ Export of Goods (pre-shipment and post-shipment risk)/ Export of Services.';
                this.showToast(msg);
            } else if (this.is_credit_limit_exist.trim() === '') {
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
            } else if ((this.show_qs_4_5) && (this.hkg_goods_exported==='No')) {
                form_valid = false;
                let msg = 'Only contracts of sale between Policyholder and a Hong Kong buyer for export of goods to an overseas country are insurable under the policy.';
                this.showToast(msg);
            } else if (this.buyer_address_line1.trim().length < 2) {
                form_valid = false;
                let msg = 'Invalid Buyer Address.';
                this.showToast(msg);
            } else if (((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && (this.goods_involved.trim() === '')) {
                form_valid = false;
                let msg = 'Please select Goods Involved.';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Services')  && (this.goods_involved.trim() === '')) {
                form_valid = false;
                let msg = 'Please select Services Involved.';
                this.showToast(msg);
            } else if ((this.goods_involved.trim() === 'Miscellaneous (Products)') && (this.specific_goods_involved.trim() === '')) {
                form_valid = false;
                let msg = 'Please specify the goods.';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Goods (Post-shipment risk only)') && ((this.application_amount === '') || (this.application_amount <= 0))) {
                form_valid = false;
                let msg = 'Invalid Application Amount.';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Services') && ((this.application_amount === '') || (this.application_amount <= 0))) {
                form_valid = false;
                let msg = 'Invalid Application Amount.';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && ((this.application_amount_pre_shipment === '') || (this.application_amount_pre_shipment <= 0))) {
                form_valid = false;
                let msg = 'Invalid Application Amount for Pre-Shipment (HKD).';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && ((this.application_amount === '') || (this.application_amount <= 0))) {
                form_valid = false;
                let msg = 'Invalid Application Amount for Post-Shipment (HKD).';
                this.showToast(msg);
            }  else if (((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && (this.is_new_buyer === '')) {
                form_valid = false;
                let msg = 'Please answer on - Is this your new buyer?';
                this.showToast(msg);
            } else if ((this.exportType === 'Export of Services') && (this.is_new_buyer === '')) {
                form_valid = false;
                let msg = 'Please answer on - Is this your new client?';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && ((this.buyer_trading_time === '' ) || (this.buyer_trading_time <= 0))) {
                form_valid = false;
                let msg = 'Invalid answer of the question - How many years have you been trading with this buyer?';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Services') && ((this.buyer_trading_time === '' ) || (this.buyer_trading_time <= 0))) {
                form_valid = false;
                let msg = 'Invalid answer of the question - How many years have you been trading with this client?';
                this.showToast(msg);
            }  //----------
            else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && ((this.order_payment_terms_amount_12months === '') || (this.order_payment_terms_amount_12months <= 0))) {
                form_valid = false;
                let msg = 'Invalid amount in - Please provide the amount and payment terms of the orders you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && ((this.order_payment_term_method1_12months === '') && (this.order_payment_term_method2_12months === '') && (this.order_payment_term_method3_12months === '') && (this.order_payment_term_method4_12months === '') && (this.order_payment_term_method5_12months === ''))){
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the orders you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && ((this.order_payment_terms_days_12month === '') || (this.order_payment_terms_days_12month <= 0))) {
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the orders you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } 
            
            else if ((this.is_new_buyer === 'No') && ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && ((this.shipment_payment_terms_amount === '') || (this.shipment_payment_terms_amount <= 0))) {
                form_valid = false;
                let msg = 'Invalid amount in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Services') && ((this.shipment_payment_terms_amount === '') || (this.shipment_payment_terms_amount <= 0))) {
                form_valid = false;
                let msg = 'Invalid amount in - Please provide the amount and payment terms of the shipments you made to this client in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && ((this.shipment_payment_term_method1 === '') && (this.shipment_payment_term_method2 === '') && (this.shipment_payment_term_method3 === '') && (this.shipment_payment_term_method4 === '') && (this.shipment_payment_term_method5 === ''))){
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Services') && ((this.shipment_payment_term_method1 === '') && (this.shipment_payment_term_method2 === '') && (this.shipment_payment_term_method3 === '') && (this.shipment_payment_term_method4 === '') && (this.shipment_payment_term_method5 === ''))){
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the shipments you made to this client in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && ((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && ((this.shipment_payment_terms_days === '') || (this.shipment_payment_terms_days <= 0))) {
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the shipments you made to this buyer in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Services') && ((this.shipment_payment_terms_days === '') || (this.shipment_payment_terms_days <= 0))) {
                form_valid = false;
                let msg = 'Invalid payment term in - Please provide the amount and payment terms of the shipments you made to this client in the last 12 months (HKD)';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && (this.unilaterally_cancel_order === '')) {
                form_valid = false;
                let msg = 'Please answer the question : Has the buyer previously cancelled from the order unilaterally?';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') && (this.overdue_payment_order === '')) {
                form_valid = false;
                let msg = 'Please answer the question : Are there any payment currently overdue from this buyer under ILC or payment in advance transactions?';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.unpaid_amount.trim() === '')) {
                form_valid = false;
                let msg = 'Please answer the question : Is there any amount currently unpaid for more than 60 days from the due date for this buyer?';
                this.showToast(msg);
            } else if ((this.is_new_buyer === 'No') && (this.unpaid_amount.trim() === 'Yes') && (this.invoiceList.length === 0)) {
                form_valid = false;
                let msg = 'Please provide Unpaid Shipment Details';
                this.showToast(msg);
            } else if ((this.unpaid_amount.trim() === 'Yes') && (this.invoiceList.length !== 0)) {
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
                    
                }
                
            }
            if (((this.exportType === 'Export of Goods (Pre-shipment and post-shipment risk)') || (this.exportType === 'Export of Goods (Post-shipment risk only)')) && (this.order_confirm_negotiation_value.trim() === '')) {
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
                    let msg = 'Invalid payment term in - Please provide the amount and payment terms of the orders';
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
            return form_valid;
        } catch (error) {
            //console.log('error=', JSON.stringify(error));
            console.error('error=', JSON.stringify(error));
        }
    }

    handleNext() {
        try{
        
        if (this.checkValidation()) {
            var fields = {
                draft_id:this.draft_id,
                acc_id: this.acc_id,
                credit_limit_id: this.credit_limit_id,
                credit_limit_id2: this.credit_limit_id2,
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
                application_amount_pre_shipment: this.application_amount_pre_shipment,
                payment_terms_value_pre_shipment: this.payment_terms_value_pre_shipment,
                payment_terms_days_pre_shipment: this.payment_terms_days_pre_shipment,
                shipment_payment_terms_amount: this.shipment_payment_terms_amount,
                shipment_payment_terms_value: this.shipment_payment_terms_value,
                payment_term_amount: this.payment_term_amount,
                unilaterally_cancel_order: this.unilaterally_cancel_order,
                overdue_payment_order: this.overdue_payment_order,
                order_confirm_negotiation_value: this.order_confirm_negotiation_value,
                payment_term_order_amount: this.payment_term_order_amount,
                order_payment_terms_value: this.order_payment_terms_value,
                shipment_commencement_month: this.shipment_commencement_month,
                received_payment_amount: this.received_payment_amount,
                received_payment_term: this.received_payment_term,
                hkg_goods_exported: this.hkg_goods_exported,
                order_payment_terms_amount_12months: this.order_payment_terms_amount_12months,
                order_payment_term_method1_12months: this.order_payment_term_method1_12months,
                order_payment_term_method2_12months: this.order_payment_term_method2_12months,
                order_payment_term_method3_12months: this.order_payment_term_method3_12months,
                order_payment_term_method4_12months: this.order_payment_term_method4_12months,
                order_payment_term_method5_12months: this.order_payment_term_method5_12months,
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
                confirm_order_payment_terms_method5: this.confirm_order_payment_terms_method5,
                order_payment_terms_days_12month: this.order_payment_terms_days_12month,
                shipment_payment_terms_days: this.shipment_payment_terms_days,
                shipment_payment_terms_days: this.shipment_payment_terms_days,
                received_payment_term_days: this.received_payment_term_days,
                order_payment_term_days: this.order_payment_term_days,
                received_payment_term_method1: this.received_payment_term_method1,
                received_payment_term_method2: this.received_payment_term_method2
            };
            //console.log('after json creation');
            var params = {
                'cl_fields': fields,
                'Pagename': 'ApplicationConfirmationSBP',
                'policy_detail': this.policy_detail
            }
            let event1 = new CustomEvent('handlepagechange', {
                detail: params
            });
            this.dispatchEvent(event1);
        }
        }catch(error) {
            //console.log('error=',JSON.stringify(error));
            console.error('error=',JSON.stringify(error));
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
        //console.log("policy_detail=", JSON.stringify(this.policy_detail));
        try{
        var fields = [];
        fields = {
            'Application_Type__c': this.uplift_reapply,
            'Is_Draft__c': true,            
            'Application_Date__c': this.formatDate(),
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
            'CL_Status__c': 'Processing',
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
            'Buyer_Registration_Number__c' : this.Buyer_Registration_Number__c,
            'Goods_or_Services_Involved__c': this.goods_involved,
            'Specific_Goods_Involved__c': this.specific_goods_involved,
            'Is_New_Buyer__c': this.is_new_buyer,
            'Buyer_Trading_Time__c': this.buyer_trading_time,
            'Shipment_Payment_Term_Amount_12_Months__c': this.shipment_payment_terms_amount,
            'Shipment_Payment_Term_Type_12_Months__c': this.shipment_payment_terms_value,
            'Pre_Shipment_Payment_Term_Type__c': this.payment_terms_value_pre_shipment,
            'Pre_Shipment_Payment_Term_Days__c': this.payment_terms_days_pre_shipment,
            'CL_Pre_Shipment_Application_AMount__c': this.application_amount_pre_shipment,
            'Previously_Cancelled_Order_Unilaterally__c': this.unilaterally_cancel_order,
            'Unpaid_Overdue_Order__c': this.overdue_payment_order,
            'Shipment_Payment_Term_Method_12_Months1__c': this.shipment_payment_term_method1,
            'Shipment_Payment_Term_Method_12_Months2__c': this.shipment_payment_term_method2,
            'Shipment_Payment_Term_Method_12_Months3__c': this.shipment_payment_term_method3,
            'Shipment_Payment_Term_Method_12_Months4__c': this.shipment_payment_term_method4,
            'Shipment_Payment_Term_Method_12_Months5__c': this.shipment_payment_term_method5,
            'Shipment_Payment_Term_Days_12_Months__c': this.shipment_payment_terms_days,
            'Order_Payment_Term_Amount_12_Months__c': this.order_payment_terms_amount_12months,
            'Order_Payment_Term_Days_12_Months__c': this.order_payment_terms_days_12month,
            'Order_Payment_Term_Method_12_Months1__c': this.order_payment_term_method1_12months,
            'Order_Payment_Term_Method_12_Months2__c': this.order_payment_term_method2_12months,
            'Order_Payment_Term_Method_12_Months3__c': this.order_payment_term_method3_12months,
            'Order_Payment_Term_Method_12_Months4__c': this.order_payment_term_method4_12months,
            'Order_Payment_Term_Method_12_Months5__c': this.order_payment_term_method5_12months,

            'Order_Payment_Term_Type_12_Months__c': this.order_payment_terms_type_12months,
            'Confirm_Order_Payment_Terms_Method1__c': this.confirm_order_payment_terms_method1,
            'Confirm_Order_Payment_Terms_Method2__c': this.confirm_order_payment_terms_method2,
            'Confirm_Order_Payment_Terms_Method3__c': this.confirm_order_payment_terms_method3,
            'Confirm_Order_Payment_Terms_Method4__c': this.confirm_order_payment_terms_method4,
            'Confirm_Order_Payment_Terms_Method5__c': this.confirm_order_payment_terms_method5,
            'Is_Unpaid_Amount__c': this.unpaid_amount,
            'Is_Unpaid_Shipment__c': this.unpaid_shipment,
            'Order_Confirmed_or_Negotiation__c': this.order_confirm_negotiation_value,
            'Order_Payment_Term_Amount__c': this.payment_term_order_amount,
            'Order_Payment_Term_Type__c': this.order_payment_terms_value,
            'Order_Payment_Term_Days__c': this.order_payment_term_days,
            'Shipment_Commence_Month__c': this.shipment_commencement_month,
            'Shipment_Commence_Year__c': this.shipment_commencement_year,
            'Remarks__c': this.remarks,
            'Received_Order_Amount__c': this.received_payment_amount,
            'Received_Order_Payment_Type__c': this.received_payment_term,
            'Overseas_Goods_or_Services__c': this.hkg_goods_exported,
            'Received_Order_Payment_Term_Days__c': this.received_payment_term_days,
            'Received_Order_Payment_Term_Method1__c': this.received_payment_term_method1,
            'Received_Order_Payment_Term_Method2__c': this.received_payment_term_method2

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
    /*callgetCountryList() {
        getCountryList()
        .then((result) => {
            this.countryOptions = result.map((country)=>({label:country.Full_Country_Name__c,value:country.Full_Country_Name__c,code:country.Country_Code__c}));
            this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
        })
        .catch((error) => {
            console.error('error::', JSON.stringify(error));
        });
    }*/
    setFieldValues(){
        if(this.received_payment_term_method1 === 'ILC') {
            this.received_payment_term_method1_id = true;
        }
        if(this.received_payment_term_method2 === 'Payment in advance') {
            this.received_payment_term_method2_id = true;
        }

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
        if (this.order_payment_term_method1_12months === 'ILC') {
            this.order_payment_term_method1_12months_id = true;
        }
        if (this.order_payment_term_method2_12months === 'Payment in advance') {
            this.order_payment_term_method2_12months_id = true;
        }
        if (this.order_payment_term_method3_12months === 'DA') {
            this.order_payment_term_method3_12months_id = true;
        }
        if (this.order_payment_term_method4_12months === 'DP') {
            this.order_payment_term_method4_12months_id = true;
        }
        if (this.order_payment_term_method5_12months === 'OA') {
            this.order_payment_term_method5_12months_id = true;
        }
        if (this.overdue_payment_order === 'Yes') {
            this.overdue_payment_order_options = [
                { label: 'Yes', value: 'Yes', isChecked: true },
                { label: 'No', value: 'No', isChecked: false },
            ];
        } else {
            this.overdue_payment_order_options = [
                { label: 'Yes', value: 'Yes', isChecked: false },
                { label: 'No', value: 'No', isChecked: true },
            ];
        }
        if (this.is_new_buyer === 'No') {
            this.show_new_buyer_detail = true;
            this.new_buyer_options = [
                { label: 'Yes', value: 'Yes', isChecked: false },
                { label: 'No', value: 'No', isChecked: true },
            ];
            
        } else if (this.is_new_buyer === 'Yes') {
            this.show_new_buyer_detail = false;
            this.new_buyer_options = [
                { label: 'Yes', value: 'Yes', isChecked: true },
                { label: 'No', value: 'No', isChecked: false },
            ];
        }
        if (this.is_credit_limit_exist === 'Yes') {
            this.existing_credit_limit = [
                { label: 'Yes', value: 'Yes', isChecked: true },
                { label: 'No', value: 'No', isChecked: false },
            ];
        } else {
            this.existing_credit_limit = [
                { label: 'Yes', value: 'Yes', isChecked: false },
                { label: 'No', value: 'No', isChecked: true },
            ];
        }
        if (this.unilaterally_cancel_order === 'Yes') {
            this.unilaterally_cancel_order_options = [
                { label: 'Yes', value: 'Yes', isChecked: true },
                { label: 'No', value: 'No', isChecked: false },
            ];
        } else {
            this.unilaterally_cancel_order_options = [
                { label: 'Yes', value: 'Yes', isChecked: false },
                { label: 'No', value: 'No', isChecked: true },
            ];
        }
        
        if (this.exportType.trim() === 'Export of Goods (Post-shipment risk only)') {
            this.export_options = [
                { label: 'Export of Goods (Post-shipment risk only)', value: 'Export of Goods (Post-shipment risk only)', isChecked: true },
                { label: 'Export of Goods (Pre-shipment and post-shipment risk)', value: 'Export of Goods (Pre-shipment and post-shipment risk)', isChecked: false },
                { label: 'Export of Services', value: 'Export of Services', isChecked: false }
            ];
            this.user_type = "Buyer";
            this.user_type_small = 'buyer';
            this.label_payment_term_info = "Payment Term OA / DA / DP ≤ 90 days";
            this.hide_payment_term_info_icon = false;
            this.hide_country_lists = false;
            this.label_unpaid_shipment = "shipments";
            this.section1.label = 'Part A (Buyer Information)';
            this.is_service = false;
            this.is_postshipment = true;
            this.is_preshipment = false;
        } else if (this.exportType.trim() === 'Export of Goods (Pre-shipment and post-shipment risk)') {
            this.export_options = [
                { label: 'Export of Goods (Post-shipment risk only)', value: 'Export of Goods (Post-shipment risk only)', isChecked: false },
                { label: 'Export of Goods (Pre-shipment and post-shipment risk)', value: 'Export of Goods (Pre-shipment and post-shipment risk)', isChecked: true },
                { label: 'Export of Services', value: 'Export of Services', isChecked: false }
            ];
            this.user_type = "Buyer";
            this.user_type_small = 'buyer';
            this.label_payment_term_info = "Payment Term OA / DA / DP ≤ 90 days";
            this.hide_payment_term_info_icon = false;
            this.hide_country_lists = false;
            this.label_unpaid_shipment = "shipments";
            this.section1.label = 'Part A (Buyer Information)';
            this.is_service = false;
            this.is_postshipment = false;
            this.is_preshipment = true;
        } else if (this.exportType.trim() === 'Export of Services') {
            this.export_options = [
                { label: 'Export of Goods (Post-shipment risk only)', value: 'Export of Goods (Post-shipment risk only)', isChecked: false },
                { label: 'Export of Goods (Pre-shipment and post-shipment risk)', value: 'Export of Goods (Pre-shipment and post-shipment risk)', isChecked: false },
                { label: 'Export of Services', value: 'Export of Services', isChecked: true }
            ];
            this.user_type = "Client";
            this.user_type_small = 'client';
            this.label_payment_term_info = "OA ≤ 90days";
            this.hide_payment_term_info_icon = true;
            this.show_payment_term_info = false;
            this.hide_country_lists = true;
            this.label_unpaid_shipment = "invoices for services rendered";
            this.is_service = true;
            this.is_postshipment = false;
            this.is_preshipment = false;
            this.section1.label = 'Part A (Client Information)';
            this.secB_q2 = 'How long have you been rendering services to this client?'
            this.secB_q3 = 'service rendered to the client';
        }
        if (this.order_confirm_negotiation_value.substring(0, 3) === 'Yes') {
            this.show_order_confirm_negotiation_detail = true;
        }
        this.show_qs_4_5 = this.buyer_country.toUpperCase() === 'HONG KONG'? true : false;
        this.unpaid_days = this.buyer_country.toUpperCase() === 'HONG KONG'? 30 : 60;
        
    }
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
                    //console.log('application_type=',this.policyinfo.clRecord[0].application_type);
                    if (this.policyinfo.clRecord[0].application_type === 'Reapply') {
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
                        this.legacy_buyer_country = clrecordEditInfo.legacy_buyer_country;
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
                    }
                }  else if (this.policyinfo.hasOwnProperty('clRecordEdit')) {
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
                    this.buyer_source = clrecordEditInfo.buyer_source;
                    this.duns_no = clrecordEditInfo.duns_no;
                    this.buyer_agency_ref = clrecordEditInfo.buyer_agency_ref;
                    this.legacy_buyer_country = clrecordEditInfo.legacy_buyer_country;
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
                    this.order_payment_term_method3_12months = clrecordEditInfo.order_payment_term_method3_12months;
                    this.order_payment_term_method4_12months = clrecordEditInfo.order_payment_term_method4_12months;
                    this.order_payment_term_method5_12months = clrecordEditInfo.order_payment_term_method5_12months;

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

                    this.application_amount_pre_shipment = clrecordEditInfo.application_amount_pre_shipment;
                    this.order_payment_terms_amount_12months = clrecordEditInfo.order_payment_terms_amount_12months;
                    this.order_payment_terms_days_12month = clrecordEditInfo.order_payment_terms_days_12month;

                    this.received_payment_term_method1 = clrecordEditInfo.received_payment_term_method1;
                    this.received_payment_term_method2 = clrecordEditInfo.received_payment_term_method2;
                    
                    this.setFieldValues();
                    if (this.unpaid_amount === 'Yes') {
                        this.unpaid_options = [
                            { label: 'Yes', value: 'Yes', isChecked: true },
                            { label: 'No', value: 'No', isChecked: false },
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
                        });
                    } else {
                        this.unpaid_options = [
                            { label: 'Yes', value: 'Yes', isChecked: false },
                            { label: 'No', value: 'No', isChecked: true },
                        ];
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
                } else if (this.policyinfo.hasOwnProperty('clRecordDraft')) {
                    let clrecordDraftInfo = this.policyinfo.clRecordDraft;
                    //console.log('clrecordDraftInfo', JSON.stringify(clrecordDraftInfo));
                    let new_inv_list = [];
                    this.show_buyer_section = true;
                    this.manual_buyer_input = false;
                    this.draft_id = clrecordDraftInfo.Id;
                    
                    if(clrecordDraftInfo.CL_Application_Amount__c)
                        this.application_amount = clrecordDraftInfo.CL_Application_Amount__c;
                    if(clrecordDraftInfo.CL_Pre_Shipment_Application_AMount__c)
                        this.application_amount_pre_shipment = clrecordDraftInfo.CL_Pre_Shipment_Application_AMount__c;
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
                    if(clrecordDraftInfo.Buyer_Source__c)
                        this.buyer_source = clrecordDraftInfo.Buyer_Source__c;
                    if(clrecordDraftInfo.DNB_DUNS__c)
                        this.duns_no = clrecordDraftInfo.DNB_DUNS__c;
                    if(clrecordDraftInfo.Agency_Ref__c)
                        this.buyer_agency_ref = clrecordDraftInfo.Agency_Ref__c;
                    if(clrecordDraftInfo.Buyer_Registration_Number__c)
                        this.registration_no = clrecordDraftInfo.Buyer_Registration_Number__c;
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
                    if(clrecordDraftInfo.Pre_Shipment_Payment_Term_Days__c)
                        this.payment_terms_days_pre_shipment = clrecordDraftInfo.Pre_Shipment_Payment_Term_Days__c
                    if(clrecordDraftInfo.Pre_Shipment_Payment_Term_Type__c)
                        this.payment_terms_value_pre_shipment = clrecordDraftInfo.Pre_Shipment_Payment_Term_Type__c
                    if(clrecordDraftInfo.Received_Order_Payment_Term_Method1__c)
                        this.received_payment_term_method1 = clrecordDraftInfo.Received_Order_Payment_Term_Method1__c
                    if(clrecordDraftInfo.Received_Order_Payment_Term_Method2__c)
                        this.received_payment_term_method2 = clrecordDraftInfo.Received_Order_Payment_Term_Method2__c    
                    if(clrecordDraftInfo.Order_Payment_Term_Days_12_Months__c)
                        this.order_payment_terms_days_12month = clrecordDraftInfo.Order_Payment_Term_Days_12_Months__c    
                    if(clrecordDraftInfo.Order_Payment_Term_Method_12_Months3__c)
                        this.order_payment_term_method3_12months = clrecordDraftInfo.Order_Payment_Term_Method_12_Months3__c    
                    if(clrecordDraftInfo.Order_Payment_Term_Method_12_Months4__c)
                        this.order_payment_term_method4_12months = clrecordDraftInfo.Order_Payment_Term_Method_12_Months4__c    
                    if(clrecordDraftInfo.Order_Payment_Term_Method_12_Months5__c)
                        this.order_payment_term_method5_12months = clrecordDraftInfo.Order_Payment_Term_Method_12_Months5__c    
                        
                     
                    this.setFieldValues();
                    
                    if (this.unpaid_amount === 'Yes') {
                        this.flag_unpaid_shipment = true;
                        this.unpaid_options = [
                            { label: 'Yes', value: 'Yes', isChecked: true },
                            { label: 'No', value: 'No', isChecked: false },
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
                            { label: 'Yes', value: 'Yes', isChecked: false },
                            { label: 'No', value: 'No', isChecked: true },
                        ];
                    }
                    
                    if (this.is_credit_limit_exist === 'Yes') {
                        this.existing_credit_limit = [
                            { label: 'Yes', value: 'Yes', isChecked: true },
                            { label: 'No', value: 'No', isChecked: false },
                        ];
                    } else {
                        this.existing_credit_limit = [
                            { label: 'Yes', value: 'Yes', isChecked: false },
                            { label: 'No', value: 'No', isChecked: true },
                        ];
                    }
                    if (this.order_confirm_negotiation_value.substring(0, 3) === 'Yes') {
                        this.show_order_confirm_negotiation_detail = true;
                    }

                    
                    
                }


            }
        }
        
    }
    get CurrencyList() {
        return  [{"label":"AUD","value":"AUD"},{"label":"CAD","value":"CAD"},{"label":"CHF","value":"CHF"},{"label":"DEM","value":"DEM"},{"label":"EUR","value":"EUR"},{"label":"GBP","value":"GBP"},{"label":"JPY","value":"JPY"},{"label":"NZD","value":"NZD"},{"label":"SGD","value":"SGD"},{"label":"USD","value":"USD"},{"label":"ATS","value":"ATS"},{"label":"BEF","value":"BEF"},{"label":"CNY","value":"CNY"},{"label":"DKK","value":"DKK"},{"label":"IEP","value":"IEP"},{"label":"NLG","value":"NLG"},{"label":"NOK","value":"NOK"},{"label":"SEK","value":"SEK"},{"label":"TWD","value":"TWD"},{"label":"ZAR","value":"ZAR"},{"label":"FIM","value":"FIM"},{"label":"PTE","value":"PTE"},{"label":"HKD","value":"HKD"},{"label":"ECU","value":"ECU"},{"label":"MYR","value":"MYR"},{"label":"ALL","value":"ALL"},{"label":"DZD","value":"DZD"},{"label":"AMD","value":"AMD"},{"label":"BSD","value":"BSD"},{"label":"BHD","value":"BHD"},{"label":"BDT","value":"BDT"},{"label":"BBD","value":"BBD"},{"label":"BZD","value":"BZD"},{"label":"XOF","value":"XOF"},{"label":"BMD","value":"BMD"},{"label":"BTN","value":"BTN"},{"label":"BOB","value":"BOB"},{"label":"BWP","value":"BWP"},{"label":"BRL","value":"BRL"},{"label":"BND","value":"BND"},{"label":"BIF","value":"BIF"},{"label":"XAF","value":"XAF"},{"label":"CVE","value":"CVE"},{"label":"KYD","value":"KYD"},{"label":"CLP","value":"CLP"},{"label":"COP","value":"COP"},{"label":"KMF","value":"KMF"},{"label":"CRC","value":"CRC"},{"label":"HRK","value":"HRK"},{"label":"CUP","value":"CUP"},{"label":"CZK","value":"CZK"},{"label":"DJF","value":"DJF"},{"label":"XCD","value":"XCD"},{"label":"DOP","value":"DOP"},{"label":"ECS","value":"ECS"},{"label":"EGP","value":"EGP"},{"label":"SVC","value":"SVC"},{"label":"ETB","value":"ETB"},{"label":"FKP","value":"FKP"},{"label":"FJD","value":"FJD"},{"label":"XPF","value":"XPF"},{"label":"GMD","value":"GMD"},{"label":"GIP","value":"GIP"},{"label":"GRD","value":"GRD"},{"label":"GTQ","value":"GTQ"},{"label":"GNF","value":"GNF"},{"label":"GYD","value":"GYD"},{"label":"HTG","value":"HTG"},{"label":"HNL","value":"HNL"},{"label":"HUF","value":"HUF"},{"label":"ISK","value":"ISK"},{"label":"INR","value":"INR"},{"label":"IDR","value":"IDR"},{"label":"IRR","value":"IRR"},{"label":"IQD","value":"IQD"},{"label":"ILS","value":"ILS"},{"label":"JMD","value":"JMD"},{"label":"JOD","value":"JOD"},{"label":"KHR","value":"KHR"},{"label":"KZT","value":"KZT"},{"label":"KES","value":"KES"},{"label":"KRW","value":"KRW"},{"label":"KWD","value":"KWD"},{"label":"LAK","value":"LAK"},{"label":"LBP","value":"LBP"},{"label":"LSL","value":"LSL"},{"label":"LRD","value":"LRD"},{"label":"LYD","value":"LYD"},{"label":"LTL","value":"LTL"},{"label":"LUF","value":"LUF"},{"label":"MOP","value":"MOP"},{"label":"MKD","value":"MKD"},{"label":"MWK","value":"MWK"},{"label":"MVR","value":"MVR"},{"label":"MRU","value":"MRU"},{"label":"MUR","value":"MUR"},{"label":"MDL","value":"MDL"},{"label":"MNT","value":"MNT"},{"label":"MAD","value":"MAD"},{"label":"MMK","value":"MMK"},{"label":"NPR","value":"NPR"},{"label":"ANG","value":"ANG"},{"label":"NGN","value":"NGN"},{"label":"KPW","value":"KPW"},{"label":"OMR","value":"OMR"},{"label":"PKR","value":"PKR"},{"label":"PAB","value":"PAB"},{"label":"PGK","value":"PGK"},{"label":"PYG","value":"PYG"},{"label":"PEN","value":"PEN"},{"label":"PHP","value":"PHP"},{"label":"PLN","value":"PLN"},{"label":"QAR","value":"QAR"},{"label":"RON","value":"RON"},{"label":"RWF","value":"RWF"},{"label":"STN","value":"STN"},{"label":"SAR","value":"SAR"},{"label":"SCR","value":"SCR"},{"label":"SLL","value":"SLL"},{"label":"SIT","value":"SIT"},{"label":"SBD","value":"SBD"},{"label":"SOS","value":"SOS"},{"label":"LKR","value":"LKR"},{"label":"SHP","value":"SHP"},{"label":"SZL","value":"SZL"},{"label":"SYP","value":"SYP"},{"label":"TZS","value":"TZS"},{"label":"THB","value":"THB"},{"label":"TOP","value":"TOP"},{"label":"TTD","value":"TTD"},{"label":"TND","value":"TND"},{"label":"TRL","value":"TRL"},{"label":"UGX","value":"UGX"},{"label":"AED","value":"AED"},{"label":"UYW","value":"UYW"},{"label":"UZS","value":"UZS"},{"label":"VUV","value":"VUV"},{"label":"VES","value":"VES"},{"label":"VND","value":"VND"},{"label":"WST","value":"WST"},{"label":"YER","value":"YER"},{"label":"YUN","value":"YUN"},{"label":"CDF","value":"CDF"},{"label":"KGS","value":"KGS"},{"label":"NAD","value":"NAD"},{"label":"GEL","value":"GEL"},{"label":"ROL","value":"ROL"},{"label":"BAM","value":"BAM"},{"label":"AWG","value":"AWG"},{"label":"AFN","value":"AFN"},{"label":"AOA","value":"AOA"},{"label":"ARS","value":"ARS"},{"label":"AZN","value":"AZN"},{"label":"BGN","value":"BGN"},{"label":"BYN","value":"BYN"},{"label":"ERN","value":"ERN"},{"label":"GHS","value":"GHS"},{"label":"MGA","value":"MGA"},{"label":"MXN","value":"MXN"},{"label":"MZN","value":"MZN"},{"label":"NIO","value":"NIO"},{"label":"RSD","value":"RSD"},{"label":"RUB","value":"RUB"},{"label":"SDG","value":"SDG"},{"label":"SRD","value":"SRD"},{"label":"TJS","value":"TJS"},{"label":"TMT","value":"TMT"},{"label":"TRY","value":"TRY"},{"label":"UAH","value":"UAH"},{"label":"ZMW","value":"ZMW"},{"label":"ZWL","value":"ZWL"},{"label":"SSP","value":"SSP"}].sort((a, b) => a.value.localeCompare(b.value));
    }
    get yearOptions() {
        var d = new Date();
        var n = d.getFullYear();
        var year_arr = [
            { label: (n-1).toString(), value: (n-1).toString() },
            { label: n.toString(), value: n.toString() },
            { label: (n+1).toString(), value: (n+1).toString() }
        ];
        
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
    
    
}
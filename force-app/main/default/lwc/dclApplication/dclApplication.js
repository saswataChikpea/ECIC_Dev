import { LightningElement, track, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import UsrId from '@salesforce/user/Id';
import getPolicyHolder from '@salesforce/apex/ClPolicy.getPolicyHolder';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CLA_ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import CLA_REF_NO from '@salesforce/schema/Credit_Limit_Application__c.Legacy_Ref_No__c';
import getExistingDCL from '@salesforce/apex/CLApplicationRecord.getExistingDCL';
import serchBuyerDetailsAura from '@salesforce/apex/ECIC_CL_API_Methods.serchBuyerDetailsAura';
// import getCountryList from '@salesforce/apex/CLApplicationRecord.getCountryList';
import createDCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.createDCLApplicationAura';
import getBuyerCountryListByPolicy from '@salesforce/apex/GetCustomMetaData.getBuyerCountryListByPolicy';

import Discretionary_Credit_Limit_Application from '@salesforce/label/c.Discretionary_Credit_Limit_Application';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Required_field_DCL from '@salesforce/label/c.Required_field_DCL';
import Buyer_Country_Market from '@salesforce/label/c.Buyer_Country_Market';
import Search_Buyer from '@salesforce/label/c.Search_Buyer';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Or from '@salesforce/label/c.Or';
import Registration_No from '@salesforce/label/c.Registration_No';
import Search from '@salesforce/label/c.Search';
import Please_Wait from '@salesforce/label/c.Please_Wait';
import Search_Result from '@salesforce/label/c.Search_Result';
import Buyer_Address from '@salesforce/label/c.Buyer_Address';
import Registration_Number_If_any from '@salesforce/label/c.Registration_Number_If_any';
import Cancel from '@salesforce/label/c.Cancel';
import Submit from '@salesforce/label/c.Submit';


export default class DclApplication extends LightningElement {

    @track label ={
        Discretionary_Credit_Limit_Application,Company_Name,Policy_Number,Policy_Type,Required_field_DCL,Buyer_Country_Market,
        Search_Buyer,Buyer_Name,Or,Registration_No,Search,Please_Wait,Search_Result,Buyer_Address,Registration_Number_If_any,
        Cancel,Submit
    }

    @track policy_detail = [];
    @track account_name = '';
    @track policy_no = '';
    @track policy_type = '';
    @track policy_id = '';
    @track accId = '';
    @track has_rendered = false;
    @track buyer_name = '';
    @track prev_buyer_name = '';
    @track buyer_country = '';
    @track search_buyer = false;
    @track buyer_search_result = [];
    @track enable_buyer_edit = true;
    @track buyer_address_line1 = '';
    @track buyer_address_line2 = '';
    @track buyer_address_line3 = '';
    @track buyer_address_line4 = '';
    @track prev_buyer_address_line1 = '';
    @track prev_buyer_address_line2 = '';
    @track prev_buyer_address_line3 = '';
    @track prev_buyer_address_line4 = '';
    @track registration_no = '';
    @track loading = false;
    @track new_cla_id = '';
    @track search_buyer_name  = '';
    @track search_buyer_reg_no = '';
    @track search_buyer_name_disable  = false;
    @track search_buyer_reg_no_disable = false;
    @track select_buyer_placeholder = 'Select Buyer';
    @track buyer_search_loading = false;
    @track countryOptions = [];
    @track duns_no = '';
    @track buyer_source = '';
    @track buyer_agency_ref = '';
    @track buyer_country_options = [];
    @track allow_dcl_create = true;

    @wire(getBuyerCountryListByPolicy,{policy_type:'51'})
    handleBuyerCountryList({ error, data }) {
        //console.log('handleBuyerCountryList data=' + JSON.stringify(data))
        if (data) {            
            this.buyer_country_options = data.map((each_el)=>({label:each_el.ByrCtry_Country_Name__c,value:each_el.ByrCtry_Country_Name__c,code:each_el.ByrCtry_Country_Code__c}));
            this.buyer_country_options.sort((a, b) => a.value.localeCompare(b.value))
        }
        if (error) {
            console.error('error in getBuyerCountryList=' + JSON.stringify(error))
        }
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
    handleRegistration(e) {
        this.registration_no = e.target.value;
    }


    handleBuyerNameChange(e) {
        this.buyer_name = e.target.value;
        this.buyer_code = '';
    }
    handleBuyerCountryChange(e) {
        this.buyer_country = e.target.value;
    }
    handleShowBuyerSearch() {
        this.search_buyer = true;
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
        // console.log('buyer_country_options=',JSON.stringify(this.buyer_country_options));
        this.buyer_country_options.map((each_el)=>{
            if(self.buyer_country === each_el.value){
                country_code = each_el.code;
            }
        })
        // console.log('country_code='+country_code);
        
        serchBuyerDetailsAura({
            'buyer_country': country_code,
            'buyer_name': this.search_buyer_name,
            'br_no': this.search_buyer_reg_no
        }).then((result) => {
            // console.log('serchBuyerDetailsAura response=',result);
            this.buyer_search_loading = false;
            let buyer_list = JSON.parse(result);
            if(buyer_list.meta_data.byr_list.length>0) {
                let buyer_search_list = buyer_list.meta_data.byr_list;
                buyer_search_list.map((each_el,i)=>{
                    self.buyer_search_result.push({...each_el,'index':i+1})
                });
            }
        })
            .catch((error) => {
                //console.log("error in serchBuyerDetailsAura", JSON.stringify(error));
                console.error("error in serchBuyerDetailsAura", JSON.stringify(error));
            });
    }
    handleBuyerSearch(e) {
        if(this.searchValidation()) {
            this.callserchBuyerDetailsAura();
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
    handleBuyerSelect(e) {
        //console.log('handleBuyerSelect, buyer code=', e.currentTarget.dataset.id);
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
    handleEdit(e) {
        this.enable_buyer_edit = true;
    }
    formatDate() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    isValid() {
        //console.log('this.buyer_address_line1=',this.buyer_address_line1);
        //console.log('this.buyer_address_line2=',this.buyer_address_line2);
        //console.log('this.buyer_address_line3=',this.buyer_address_line3);
        //console.log('this.buyer_address_line4=',this.buyer_address_line4);
        try{
        if( (this.buyer_country.trim().length < 3) || (this.buyer_country.trim() === '')) {
            this.showToast('Invalid buyer country');
            return false;
        } else if( (this.buyer_name.trim().length < 2) || (this.buyer_name.trim() === '')) {
            this.showToast('Invalid buyer name');
            return false;
        } else if( (this.buyer_address_line1.trim().length < 2) || (this.buyer_address_line1.trim() === '')) {
            this.showToast('Invalid address');
            return false;
        } 
        }catch(error){
            //console.log('error=',JSON.stringify(error));
        }
        return true;
        
        
    }
    callcreateDCLApplicationAura(){
        createDCLApplicationAura({
            clApplicationID:this.new_cla_id
        }).then((result)=>{
            let result_json = JSON.parse(result);
            //console.log('callcreateDCLApplicationAura result',result);
            const fields = {};
            fields[CLA_ID_FIELD.fieldApiName] = this.new_cla_id;
            fields[CLA_REF_NO.fieldApiName] = result_json.meta_data.ref_no;
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                    //console.log('cla ref no updated');                
                })
                .catch(error => {
                    //console.log('error in cla ref no update', JSON.stringify(error));
                    console.error('error cla ref no update', JSON.stringify(error));
                });

        }).catch(error => {
            //console.log('createDCLApplicationAura Error: ' + JSON.stringify(error));
            console.error('createDCLApplicationAura Error: ' + JSON.stringify(error));
        });
    }
    createDCL(){
        var fields = {
            'Exporter__c': this.accId,
            'Policy__c': this.policy_id,
            'Application_Date__c': this.formatDate(),
            'Buyer_Address_Line_1__c': this.buyer_address_line1,
            'Buyer_Address_Line_2__c': this.buyer_address_line2,
            'Buyer_Address_Line_3__c': this.buyer_address_line3,
            'Buyer_Address_Line_4__c': this.buyer_address_line4,
            'Buyer_Code__c': this.buyer_code,
            'Buyer_Country__c': this.buyer_country,
            'Buyer_Registration_Number__c' : this.registration_no,
            'Buyer_Name__c': this.buyer_name,
            'DNB_DUNS__c': this.duns_no,
            'Buyer_Source__c': this.buyer_source,
            'Agency_Ref__c': this.buyer_agency_ref,
            'CL_Status__c': 'Processing',
            'CL_Type__c': 'CLA',
            'Is_DCL__c': true
        }
        var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
        createRecord(objRecordInput).then(response => {
            //console.log('cla created with Id: ' + response.id);
            this.new_cla_id = response.id;
            this.callcreateDCLApplicationAura();
            var params = {
                'Pagename': 'RedirectdclRecord',
                'cl_id': this.new_cla_id
            }
            let event1 = new CustomEvent('handlepagechange', {
                detail: params
            });
            this.dispatchEvent(event1);
        }).catch(error => {
            this.loading = false;
            this.showToast('Some internal error occurred. Please try again later.');
            //console.log('cla Error: ' + JSON.stringify(error));
            console.error('cla Error: ' + JSON.stringify(error));
        });
    }
    callgetExistingDCL(){
        //console.log('callgetExistingDCL');
        this.loading = true;
        let self = this;
        getExistingDCL({
            policy_id:this.policy_detail.Id,
            buyer_code:this.buyer_code
        }).then((result) => {
            this.loading = false;
            //console.log('getExistingDCL=',JSON.stringify(result));
            if(result.clList.length > 0) {
                let clList = result.clList;
                clList.map((cl_list)=>{
                    if(cl_list.Is_DCL__c) {
                        if((self.prev_buyer_address_line1.trim() === self.buyer_address_line1.trim()) && (self.prev_buyer_address_line2.trim() === self.buyer_address_line2.trim()) && (self.prev_buyer_address_line3.trim() === self.buyer_address_line3.trim()) && (self.prev_buyer_address_line4.trim() === self.buyer_address_line4.trim()) && (self.prev_buyer_name.trim() === self.buyer_name.trim())){
                            let msg = 'There is a valid discretionary credit limit on '+self.buyer_name+ ' ('+self.buyer_code+'). Your application will not be processed. If you have any queries, please feel free to contact our SME Team at.'
                            self.showToast(msg);
                            return;
                        }
                    } else {
                        if((self.prev_buyer_address_line1.trim() === self.buyer_address_line1.trim()) && (self.prev_buyer_address_line2.trim() === self.buyer_address_line2.trim()) && (self.prev_buyer_address_line3.trim() === self.buyer_address_line3.trim()) && (self.prev_buyer_address_line4.trim() === self.buyer_address_line4.trim()) && (self.prev_buyer_name.trim() === self.buyer_name.trim())){
                            let msg = 'You have previously submitted a credit limit application on '+self.buyer_name+' ('+self.buyer_code+'). Your application will not be processed. If you have any queries, please feel free to contact our SME Team at ';
                            self.showToast(msg);
                            return;
                        }
                    }
                })

            } else if(result.claList.length > 0) {
                //console.log('clalist length=',result.claList.length);
                let claList = result.claList;
                                    
                    if((self.prev_buyer_address_line1.trim() === self.buyer_address_line1.trim()) && (self.prev_buyer_address_line2.trim() === self.buyer_address_line2.trim()) && (self.prev_buyer_address_line3.trim() === self.buyer_address_line3.trim()) && (self.prev_buyer_address_line4.trim() === self.buyer_address_line4.trim()) && (self.prev_buyer_name.trim() === self.buyer_name.trim())){
                        let msg = 'You have previously submitted a credit limit application on '+self.buyer_name+' ('+self.buyer_code+'). Your application will not be processed. If you have any queries, please feel free to contact our SME Team at ';
                        self.showToast(msg);
                        return;
                    }                 
            } 
            //console.log('everything is okay');
            this.createDCL();
            
        })
        .catch((error) => {
            console.error(error);
        });
    }
    handleSubmit() {
        // this.loading = true;
        try {
            if (this.isValid()) {
                //console.log('valid');
                this.callgetExistingDCL();
               /* var fields = {
                    'Exporter__c': this.accId,
                    'Policy__c': this.policy_id,
                    'Application_Date__c': this.formatDate(),
                    'Buyer_Address_Line_1__c': this.buyer_address_line1,
                    'Buyer_Address_Line_2__c': this.buyer_address_line2,
                    'Buyer_Address_Line_3__c': this.buyer_address_line3,
                    'Buyer_Address_Line_4__c': this.buyer_address_line4,
                    'Buyer_Code__c': this.buyer_code,
                    'Buyer_Country__c': this.buyer_country,
                    'Buyer_Name__c': this.buyer_name,
                    'CL_Status__c': 'Processing',
                    'CL_Type__c': 'CLA',
                    'Is_DCL__c': true
                }
                var objRecordInput = { 'apiName': 'Credit_Limit_Application__c', fields };
                createRecord(objRecordInput).then(response => {
                    //console.log('cla created with Id: ' + response.id);
                    this.new_cla_id = response.id;
                    this.loading = false;
                    var params = {
                        'Pagename': 'RedirectdclRecord',
                        'cl_id': this.new_cla_id
                    }
                    let event1 = new CustomEvent('handlepagechange', {
                        detail: params
                    });
                    this.dispatchEvent(event1);
                }).catch(error => {
                    this.loading = false;
                    //console.log('cla Error: ' + JSON.stringify(error));
                    console.error('cla Error: ' + JSON.stringify(error));
                });*/
            }
        } catch (e) {
            //console.log('Exception', JSON.stringify(e));
            console.error('Exception', JSON.stringify(e));
        }
    }
    handleCancel(e) {
        var params = {
            'Pagename': 'dclRecord',
            'cl_id': this.new_cla_id
        }
        let event1 = new CustomEvent('handlepagechange', {
            detail: params
        });
        this.dispatchEvent(event1);
    }

    getPolicy() {
        getPolicyDetails({
            acc_id: this.accId
        })
            .then((result) => {
                //console.log("Policy details=", JSON.stringify(result));
                this.policy_detail = result;
                this.account_name = result.Exporter__r.Name;
                this.policy_no = result.Legacy_Customer_Number__c;
                this.policy_type = result.Product__r.Name;
                this.policy_id = result.Id;
                if(result.Exporter__r.Limited_Access__c)
                this.allow_dcl_create = false
            })
            .catch((error) => {
                console.error(error);
            });
    }
    /*get countryOptions() {
        return [
            { label: "Australia", value: "Australia" },
            { label: "Austria", value: "Austria" },
            { label: "Belgium", value: "Belgium" },
            { label: "Bermuda", value: "Bermuda" },
            { label: "Brunei Darussalam", value: "Brunei Darussalam" },
            { label: "Canada", value: "Canada" },
            { label: "Chile", value: "Chile" },
            { label: "China", value: "China" },
            { label: "Czechia", value: "Czechia" },
            { label: "Denmark", value: "Denmark" },
            { label: "Finland", value: "Finland" },
            { label: "France", value: "France" },
            { label: "Gabon Germany", value: "Gabon Germany" },
            { label: "Holy See", value: "Holy See" },
            { label: "Ireland", value: "Ireland" },
            { label: "Italy", value: "Italy" },
            { label: "Japan", value: "Japan" },
            { label: "Korea, Republic of ", value: "Korea, Republic of " },
            { label: "Kuwait", value: "Kuwait" },
            { label: "Liechtensteni", value: "Liechtensteni" },
            { label: "Luxembourg", value: "Luxembourg" },
            { label: "Macao", value: "Macao" },
            { label: "Manoco", value: "Manoco" },
            { label: "Netherlands", value: "Netherlands" },
            { label: "New Zealand", value: "New Zealand" },
            { label: "Norway", value: "Norway" },
            { label: "Oman", value: "Oman" },
            { label: "Portugal", value: "Portugal" },
            { label: "Qatar", value: "Qatar" },
            { label: "San Marino", value: "San Marino" },
            { label: "Saudi Arabia", value: "Saudi Arabia" },
            { label: "Singapore", value: "Singapore" },
            { label: "Spain", value: "Spain" },
            { label: "Sweden", value: "Sweden" },
            { label: "Switzerland", value: "Switzerland" },
            { label: "Taiwan", value: "Taiwan" },
            { label: "United Arab Emirates", value: "United Arab Emirates" },
            { label: "United Kindom", value: "United Kindom" },
            { label: "United States of America", value: "United States of America" },
            { label: "Aland Island", value: "Aland Island" },
            { label: "American Samoa", value: "American Samoa" },
            { label: "Andorra", value: "Andorra" },
            { label: "Anguilla", value: "Anguilla" },
            { label: "Aruba", value: "Aruba" },
            { label: "Bahamas", value: "Bahamas" },
            { label: "Bonaire, Sint Eustatius and Saba", value: "Bonaire, Sint Eustatius and Saba" },
            { label: "Botswana", value: "Botswana" },
            { label: "Bouvet Island", value: "Bouvet Island" },
            { label: "Brazil", value: "Brazil" },
            { label: "British Indian Ocean Territory", value: "British Indian Ocean Territory" },
            { label: "Cayman Islands", value: "Cayman Islands" },
            { label: "Christmas Island", value: "Christmas Island" },
            { label: "Cocos (Keeling) Islands", value: "Cocos (Keeling) Islands" },
            { label: "Colombia", value: "Colombia" },
            { label: "Cook Islands", value: "Cook Islands" },
            { label: "Curacao", value: "Curacao" },
            { label: "Cuyprus", value: "Cuyprus" },
            { label: "Estonia", value: "Estonia" },
            { label: "Eswatini", value: "Eswatini" },
            { label: "Falkland Island (Malvinas)", value: "Falkland Island (Malvinas)" },
            { label: "Faroe", value: "Faroe" },
            { label: "French Guiana", value: "French Guiana" },
            { label: "French Polynesia", value: "French Polynesia" },
            { label: "French Southern Territories", value: "French Southern Territories" },
            { label: "Gibraltar", value: "Gibraltar" },
            { label: "Greenland", value: "Greenland" },
            { label: "Guadeloupe", value: "Guadeloupe" },
            { label: "Guam", value: "Guam" },
            { label: "Guernsey", value: "Guernsey" },
            { label: "Heard Island and McDonald Islands", value: "Heard Island and McDonald Islands" },
            { label: "Hungary", value: "Hungary" },
            { label: "Iceland", value: "Iceland" },
            { label: "India", value: "India" },
            { label: "Indonesia", value: "Indonesia" },
            { label: "Isle of Man", value: "Isle of Man" },
            { label: "Israel", value: "Israel" },
            { label: "Jersey", value: "Jersey" },
            { label: "Latvia", value: "Latvia" },
            { label: "Lithuania", value: "Lithuania" },
            { label: "Malaysia", value: "Malaysia" },
            { label: "Malta", value: "Malta" },
            { label: "Martinique", value: "Martinique" },
            { label: "Mauritius", value: "Mauritius" },
            { label: "Mayotee", value: "Mayotee" },
            { label: "Mexico", value: "Mexico" },
            { label: "Montserrat", value: "Montserrat" },
            { label: "Morocco", value: "Morocco" },
            { label: "Namibia", value: "Namibia" },
            { label: "New Caledonia", value: "New Caledonia" },
            { label: "Niue", value: "Niue" },
            { label: "Norflol Island", value: "Norflol Island" },
            { label: "Northern Mariana Islands", value: "Northern Mariana Islands" },
            { label: "Panama", value: "Panama" },
            { label: "Peru", value: "Peru" },
            { label: "Philippines", value: "Philippines" },
            { label: "Pitcairn", value: "Pitcairn" },
            { label: "Poland", value: "Poland" },
            { label: "Puerto Rico", value: "Puerto Rico" },
            { label: "Reunion", value: "Reunion" },
            { label: "Romania", value: "Romania" },
            { label: "Russian Federation", value: "Russian Federation" },
            { label: "Saint Barthelemy", value: "Saint Barthelemy" },
            { label: "Saint Helena, Ascension and Tristan Da Cunha", value: "Saint Helena, Ascension and Tristan Da Cunha" },
            { label: "Saint Pierre and Miquelon", value: "Saint Pierre and Miquelon" },
            { label: "Sint Maarten (Dutch Part)", value: "Sint Maarten (Dutch Part)" },
            { label: "Slovakia", value: "Slovakia" },
            { label: "Slovenia", value: "Slovenia" },
            { label: "South Africa", value: "South Africa" },
            { label: "South Georgia and the South Sandwich Islands", value: "South Georgia and the South Sandwich Islands" },
            { label: "Svalbard and Jan Mayen", value: "Svalbard and Jan Mayen" },
            { label: "Thailand", value: "Thailand" },
            { label: "Tokelau", value: "Tokelau" },
            { label: "Trinidad and Tobago", value: "Trinidad and Tobago" },
            { label: "Turks and Caicas Islands", value: "Turks and Caicas Islands" },
            { label: "Uruguay", value: "Uruguay" },
            { label: "Virgin Islands, British", value: "Virgin Islands, British" },
            { label: "Virgin Islands, U.S.", value: "Virgin Islands, U.S." },
            { label: "Wallis and Futuna", value: "Wallis and Futuna" },
            { label: "Algeria", value: "Algeria" },
            { label: "Angola", value: "Angola" },
            { label: "Argentina", value: "Argentina" },
            { label: "Azerbaijan", value: "Azerbaijan" },
            { label: "Bahrain", value: "Bahrain" },
            { label: "Bangladesh", value: "Bangladesh" },
            { label: "Barbodas", value: "Barbodas" },
            { label: "Benin", value: "Benin" },
            { label: "Bhutan", value: "Bhutan" },
            { label: "Bolivia (Plurinational State of)", value: "Bolivia (Plurinational State of)" },
            { label: "Bulgaria", value: "Bulgaria" },
            { label: "Burkina Faso", value: "Burkina Faso" },
            { label: "Cabo Verde", value: "Cabo Verde" },
            { label: "Cameroon", value: "Cameroon" },
            { label: "Comoros", value: "Comoros" },
            { label: "Costa Rica", value: "Costa Rica" },
            { label: "Croatia", value: "Croatia" },
            { label: "Djibouti", value: "Djibouti" },
            { label: "Dominica", value: "Dominica" },
            { label: "Dominican Republic", value: "Dominican Republic" },
            { label: "Ecuador", value: "Ecuador" },
            { label: "Egypt", value: "Egypt" },
            { label: "El Salvador", value: "El Salvador" },
            { label: "Equatorial Guinea", value: "Equatorial Guinea" },
            { label: "Ethiopia", value: "Ethiopia" },
            { label: "Fiji", value: "Fiji" },
            { label: "Ghana", value: "Ghana" },
            { label: "Greece", value: "Greece" },
            { label: "Guatemala", value: "Guatemala" },
            { label: "Honduras", value: "Honduras" },
            { label: "Iran, Islamic Republic of", value: "Iran, Islamic Republic of" },
            { label: "Jamaica", value: "Jamaica" },
            { label: "Jordan", value: "Jordan" },
            { label: "Kazakhstan", value: "Kazakhstan" },
            { label: "Kenya", value: "Kenya" },
            { label: "Lao People's Democratic Repubic", value: "Lao People's Democratic Repubic" },
            { label: "Lesotho", value: "Lesotho" },
            { label: "Maldives", value: "Maldives" },
            { label: "Mali", value: "Mali" },
            { label: "Manogolia", value: "Manogolia" },
            { label: "Myanmar", value: "Myanmar" },
            { label: "Nepal", value: "Nepal" },
            { label: "Niger", value: "Niger" },
            { label: "Nigeria", value: "Nigeria" },
            { label: "Pakistan", value: "Pakistan" },
            { label: "Papua New Guinea", value: "Papua New Guinea" },
            { label: "Paraguay", value: "Paraguay" },
            { label: "Saint Lucia", value: "Saint Lucia" },
            { label: "Saint Vincent and the Grenadines", value: "Saint Vincent and the Grenadines" },
            { label: "Samoa", value: "Samoa" },
            { label: "Sao Tome and Principe", value: "Sao Tome and Principe" },
            { label: "Serbia", value: "Serbia" },
            { label: "Senegal", value: "Senegal" },
            { label: "Seychelles", value: "Seychelles" },
            { label: "Solomon Islands", value: "Solomon Islands" },
            { label: "Srilanka", value: "Srilanka" },
            { label: "Suriname", value: "Suriname" },
            { label: "Togo", value: "Togo" },
            { label: "Tonga", value: "Tonga" },
            { label: "Tunisia", value: "Tunisia" },
            { label: "Turkey", value: "Turkey" },
            { label: "Vanuatu", value: "Vanuatu" },
            { label: "Vietnam", value: "Vietnam" },

        ].sort((a, b) => a.value.localeCompare(b.value))
    }*/
    /*callgetCountryList() {
        getCountryList()
        .then((result) => {
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
        if (!this.has_rendered) {
            this.has_rendered = true;
            getPolicyHolder({ 'user_id': UsrId })
                .then((result) => {
                    //console.log('accountId===', result);
                    this.accId = result;
                    this.getPolicy();
                    // this.callgetCountryList();

                }).catch((error) => {

                    //console.log(error);
                });
        }
    }
}
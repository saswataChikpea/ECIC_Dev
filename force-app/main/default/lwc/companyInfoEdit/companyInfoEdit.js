import { api, LightningElement, track, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Account.Id';
import NAME_FIELD from '@salesforce/schema/Account.Name_Backup__c';
import REG_FIELD from '@salesforce/schema/Account.Registration_Number_Backup__c';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import MOBILE_FIELD from '@salesforce/schema/Account.Mobile__c';
import GOODS_FIELD from '@salesforce/schema/Account.Goods_or_Services__c';
import LEGAL_FIELD from '@salesforce/schema/Account.Legal_Type__c';
import LANGUAGE_FIELD from '@salesforce/schema/Account.Language_of_Correspondence__c';
import BANK_FIELD from '@salesforce/schema/Account.Bank_Account__c';
import COR_ADD1_FIELD from '@salesforce/schema/Account.Correspondence_Address_Line_1__c';
import COR_ADD2_FIELD from '@salesforce/schema/Account.Correspondence_Address_Line_2__c';
import COR_ADD3_FIELD from '@salesforce/schema/Account.Correspondence_Address_Line_3__c';
import COR_TERITORRY_FIELD from '@salesforce/schema/Account.Correspondence_Territory__c';
import COR_DIS_FIELD from '@salesforce/schema/Account.Correspondence_District__c';
import REG_ADDL1_FIELD from '@salesforce/schema/Account.Registered_Address_Line_1_Backup__c';
import REG_ADDL2_FIELD from '@salesforce/schema/Account.Registered_Address_Line_2_Backup__c';
import REG_ADDL3_FIELD from '@salesforce/schema/Account.Registered_Address_Line_3_Backup__c';
import REG_DIST_FIELD from '@salesforce/schema/Account.Registered_District_Backup__c';
import REG_TERR_FIELD from '@salesforce/schema/Account.Registered_Territory_Backup__c';
import DOCUMENT_ID_FIELD from '@salesforce/schema/Account.Document_Id__c';
import IS_UDER_REVIEW_FIELD from '@salesforce/schema/Account.Is_Under_Review__c';
import AMEND_EFFECTIVE_DATE_FIELD from '@salesforce/schema/Account.Amend_Effective_Date__c';
import updateCompanyInfo from '@salesforce/apex/CompanyDetails.updateCompanyInfo';
// import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';
// import GOODS_OF_SERVICES from '@salesforce/schema/Account.Goods_or_Services__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ATTACHMENT_ID_FIELD from '@salesforce/schema/Attachment.Id';
import ATTACHMENT_NAME_FIELD from '@salesforce/schema/Attachment.Name';

// import updateAttachment from '@salesforce/apex/CompanyDetails.updateAttachment';
import getDistrictTerritoryList from '@salesforce/apex/GetCustomMetaData.getDistrictTerritoryList';
import getLegalType from '@salesforce/apex/CompanyDetails.getLegalType';
import getProduct from '@salesforce/apex/CompanyDetails.getProduct';
import Registered_Company_Name from '@salesforce/label/c.Registered_Company_Name';
import Registered_Company_Address from '@salesforce/label/c.Registered_Company_Address';
import Office_Telephone_No from '@salesforce/label/c.Office_Telephone_No';
import Goods_Services from '@salesforce/label/c.Goods_Services';
import Upload_BR_Certificate_to_confirm from '@salesforce/label/c.Upload_BR_Certificate_to_confirm';
import Business_Registration_Number from '@salesforce/label/c.Business_Registration_Number';
import Correspondence_Company_Address from '@salesforce/label/c.Correspondence_Company_Address';
import Legal_Type from '@salesforce/label/c.Legal_Type';
import Language_Of_Correspondence from '@salesforce/label/c.Language_Of_Correspondence';
import request_is_being_processed from '@salesforce/label/c.request_is_being_processed';
import OK from '@salesforce/label/c.OK';
import Update from '@salesforce/label/c.Update';
import CP_Effective_Date from '@salesforce/label/c.CP_Effective_Date';
import Registered_District from '@salesforce/label/c.Registered_District';
import Registered_Territory from '@salesforce/label/c.Registered_Territory';
import Correspondence_District from '@salesforce/label/c.Correspondence_District';
import Correspondence_Territory from '@salesforce/label/c.Correspondence_Territory';
import Bank_account from '@salesforce/label/c.Bank_account';
import Select_Legal_Type from '@salesforce/label/c.Select_Legal_Type';
import Select_Goods_or_Services from '@salesforce/label/c.Select_Goods_or_Services';

import getLegalTypeList from '@salesforce/apex/GetCustomMetaData.getLegalTypeList';
import getIndustryListByPolicy from '@salesforce/apex/GetCustomMetaData.getIndustryListByPolicy';
import createTask from '@salesforce/apex/TaskManagement.createTask';
import getPolicyType from '@salesforce/apex/CompanyDetails.getPolicyType';
import getAllDistrictTerritoryList from '@salesforce/apex/GetCustomMetaData.getAllDistrictTerritoryList';

export default class CompanyInfoEdit extends LightningElement {

    @track label={
        Registered_Company_Name,Registered_Company_Address,Office_Telephone_No,Goods_Services,Upload_BR_Certificate_to_confirm,
        Business_Registration_Number,Correspondence_Company_Address,Legal_Type,Language_Of_Correspondence,request_is_being_processed,
        OK,Update,CP_Effective_Date,Registered_District,Registered_Territory,Correspondence_District,
        Correspondence_Territory,Bank_account,Select_Legal_Type,Select_Goods_or_Services
    }


    @api companyinfo = [];
    // @track territory_options = [
    //     { label: 'North', value: 'North' },
    //     { label: 'South', value: 'South' },
    //     { label: 'East', value: 'East' },
    //     { label: 'West', value: 'West' },
    //     { label: 'Central', value: 'Central' },
    // ];
    @track reg_territory_value = '';
    @track show_confirmation = false;
    @track company_name = "";
    @track reg_address_line1 = '';
    @track reg_address_line2 = '';
    @track reg_address_line3 = '';
    //--------------
    @track prev_company_name = "";
    @track prev_reg_address_line1 = '';
    @track prev_reg_address_line2 = '';
    @track prev_reg_address_line3 = '';
    @track prev_reg_territory_value = '';
    @track prev_reg_district_value = '';
    @track prev_reg_no = '';
    //--------------
    @track cor_address_line1 = '';
    @track cor_address_line2 = '';
    @track cor_address_line3 = '';
    @track cor_territory_value = '';
    @track cor_district_value = '';

    @track reg_no = '';
    @track tel_no = '';
    @track acc_id = '';
    @track language_correspondence = '';
    @track bank_acc = false;
    @track documentid = '';
    @track document_name = '';
    @track error_msg = '';
    @track mob_no = '';
    // @track districtTerritory = [];
    @track districtTerritory = {
        "Hong Kong": [
          "Kennedy Town",
          "Shek Tong Tsui",
          "Sai Ying Pun",
          "Sheung Wan",
          "Central",
          "Admiralty",
          "Mid-levels",
          "Peak",
          "Wan Chai",
          "Causeway Bay",
          "Happy Valley",
          "Tai Hang",
          "So Kon Po",
          "Jardine's Lookout",
          "Tin Hau",
          "Braemar Hill",
          "North Point",
          "Quarry Bay",
          "Sai Wan Ho",
          "Shau Kei Wan",
          "Chai Wan",
          "Siu Sai Wan",
          "Pok Fu Lam",
          "Aberdeen",
          "Ap Lei Chau",
          "Wong Chuk Hang",
          "Shouson Hill",
          "Repulse Bay",
          "Chung Hom Kok",
          "Stanley",
          "Tai Tam",
          "Shek O"
        ],
        "Kowloon": [
          "Tsim Sha Tsui",
          "Yau Ma Tei",
          "West Kowloon Reclamation",
          "King's Park",
          "Mong Kok",
          "Tai Kok Tsui",
          "Mei Foo",
          "Lai Chi Kok",
          "Cheung Sha Wan",
          "Sham Shui Po",
          "Shek Kip Mei",
          "Yau Yat Tsuen,Tai Wo Ping",
          "Stonecutters Island",
          "Hung Hom",
          "To Kwa Wan",
          "Ma Tau Kok",
          "Ma Tau Wai",
          "Kai Tak",
          "Kowloon City",
          "Ho Man Tin",
          "Kowloon Tong",
          "Beacon Hill",
          "San Po Kong",
          "Wong Tai Sin",
          "Tung Tau",
          "Wang Tau Hom",
          "Lok Fu",
          "Diamond Hill",
          "Tsz Wan Shan",
          "Ngau Chi Wan",
          "Ping Shek",
          "Kowloon Bay",
          "Ngau Tau Kok",
          "Jordan Valley",
          "Kwun Tong",
          "Sau Mau Ping",
          "Lam Tin",
          "Yau Tong",
          "Lei Yue Mun"
        ],
        "New Territories": [
          "Kwai Chung",
          "Tsing Yi",
          "Tsuen Wan",
          "Lei Muk Shue",
          "Ting Kau",
          "Sham Tseng",
          "Tsing Lung Tau",
          "Ma Wan",
          "Sunny Bay",
          "Tai Lam Chung",
          "So Kwun Wat",
          "Tuen Mun",
          "Lam Tei",
          "Hung Shui Kiu",
          "Ha Tsuen",
          "Lau Fau Shan",
          "Tin Shui Wai",
          "Yuen Long",
          "San Tin",
          "Lok Ma Chau",
          "Kam Tin",
          "Shek Kong",
          "Pat Heung",
          "Fanling",
          "Luen Wo Hui",
          "Sheung Shui",
          "Shek Wu Hui",
          "Sha Tau Kok",
          "Luk Keng",
          "Wu Kau Tang",
          "Tai Po Market",
          "Tai Po",
          "Tai Po Kau",
          "Tai Mei Tuk",
          "Shuen Wan",
          "Cheung Muk Tau",
          "Kei Ling Ha",
          "Tai Wai",
          "Sha Tin",
          "Fo Tan",
          "Ma Liu Shui",
          "Wu Kai Sha",
          "Ma On Shan",
          "Clear Water Bay",
          "Sai Kung",
          "Tai Mong Tsai",
          "Tseung Kwan O",
          "Hang Hau",
          "Tiu Keng Leng",
          "Ma Yau Tong",
          "Cheung Chau",
          "Peng Chau",
          "Lantau Island(including Tung Chung)",
          "Lamma Island"
        ]
      }
    @track territory_options = Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el }))
    // @track territory_options = [];
    @track registeredDistrictOptions = [];
    @track correspondenceDistrictOptions = [];
    

    // @track show_upload = true;

    // @track district_options = [
    //     { label: 'Western District', value: 'Western District' },
    //     { label: 'Eastern District', value: 'Eastern District' },
    //     { label: 'Northern District', value: 'Northern District' }
    // ];
    @track reg_district_value = '';

    @track legal_options /*= [
        { label: 'Partnership', value: 'Partnership' },
        { label: 'Client', value: 'Client' }
    ];*/
    @track legal_value = '';

    @track goods_options /*= [
        { label: 'Electronics', value: 'Electronics' },
        { label: 'Shipping', value: 'Shipping' }
    ];*/
    @track goods_value = '';
    @track is_rendered = false;
    @track acceptedFormats = ['.pdf', '.png', '.jpg'];
    @track language_option = [{ label: 'English', value: 'English' },
    { label: 'Chinese', value: 'Chinese' }];
    @track min_effective_date = '';
    @track effective_date = '';
    @track policy_type = '';
    // @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    // objectInfo;

    // @wire(getPicklistValues,
    //     {
    //         recordTypeId: '$objectInfo.data.defaultRecordTypeId', 
    //         fieldApiName: GOODS_OF_SERVICES
    //     }
    // )goods_options;


    @wire(getIndustryListByPolicy, {'policy_type':'$policy_type'})
    callgetProduct({ error, data }) {
        if (data) {
            // //console.log("ProductList:" + JSON.stringify(data));
            // this.productList = data
            this.goods_options = [];
            let goods = data.map((el)=>({ label: el.PRD_DESC__c, value: el.PRD_DESC__c }));
            this.goods_options = [...new Set(goods)]
        }
        else {
            //console.log('error::', JSON.stringify(error));
        }
    }
    @wire(getLegalTypeList, {})
    callgetLegalTypeList({ error, data }) {
        if (data) {
            console.log("getLegalTypeList:" + JSON.stringify(data));
            this.legal_options = [];
            let legal_types = data.length && data
                .map(el => ({ label: el.LegalList_Code_Desc__c, value: el.LegalList_Code_Desc__c, code: el.LegalList_Code__c }))
            // .sort((a, b) => a.label.localeCompare(b.label))
            this.legal_options = [...new Set(legal_types)]
        }
        else {
            //console.log('error::', JSON.stringify(error));
        }
    }
    @wire(getAllDistrictTerritoryList)
    handleDistrictTerritoryList({ error, data }) {
        if (data) {            
           console.log('getAllDistrictTerritoryList data=',JSON.stringify(data));
        }
        if (error) {
            console.error('error in handleDistrictTerritoryList=' + JSON.stringify(error))
        }
    }

    closeModal(e) {
        const closeEvent = new CustomEvent("closeeditmodal", {
        })
        this.dispatchEvent(closeEvent);
    }
    handleTerrytoryChange(e) {
        this.registeredDistrictOptions = [];
        this.reg_territory_value = e.detail.value;
        //this.registeredDistrictOptions = this.this.districtTerritory[this.reg_territory_value] ? this.districtTerritory[this.reg_territory_value].map((el) => ({ label: el, value: el })) : [];
                        
        let temp = this.districtTerritory[this.reg_territory_value] ? this.districtTerritory[this.reg_territory_value].map((el) => ({ label: el, value: el })) : [];
        this.registeredDistrictOptions.splice(0,this.registeredDistrictOptions.length,...temp);
        this.registeredDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
        this.reg_district_value='';
    }
    handleDistrictChange(e) {
        this.reg_district_value = e.detail.value;
    }
    handleMobileNo(e) {
        this.mob_no = e.detail.value;
    }
    handleLegalChange(e) {
        this.legal_value = e.detail.value;
    }
    handleGoodChange(e) {
        this.goods_value = e.detail.value;
    }
    handleUploadFinished(e) {
        console.log('upload finished==', JSON.stringify(e.detail));
        this.documentid = e.detail.files[0].documentId;
        this.document_name = e.detail.files[0].name;
        //console.log('documentid=' + this.documentid);
        /*updateAttachment({Id:this.documentid})
        .then((result) => {
            //console.log('result=',JSON.stringify(result));
        })
        .catch((error) => {
            //console.log('error=',JSON.stringify(error));
            console.error('error=',JSON.stringify(error));
        });*/
        /*const fields = {};
            try {
                fields[ATTACHMENT_ID_FIELD.fieldApiName] = this.documentid;
                fields[ATTACHMENT_NAME_FIELD.fieldApiName] = 'testing_pratik';

                const recordInput = { fields };
                    updateRecord(recordInput)
                        .then(() => {
                            //console.log('attachment updated');
                                
                        })
                        .catch(error => {
                            //console.log('error in attachment update', error.body.message);
                        });
            }catch(exception){
                //console.log('Exception=',JSON.stringify(exception));
            }*/
    }
    handleCorsDistrictChange(e) {
        this.cor_district_value = e.detail.value;
    }
    handleCorsTerrytoryChange(e) {        
        this.correspondenceDistrictOptions = [];
        this.cor_territory_value = e.detail.value;        
        let temp = this.districtTerritory[this.cor_territory_value] ? this.districtTerritory[this.cor_territory_value].map((el) => ({ label: el, value: el })) : [];
        this.correspondenceDistrictOptions.splice(0,this.correspondenceDistrictOptions.length,...temp);
        this.correspondenceDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
        this.cor_district_value = '';
        
    }
    handleCorsAddressLine1(e) {
        this.cor_address_line1 = e.detail.value;
    }
    handleCorsAddressLine2(e) {
        this.cor_address_line2 = e.detail.value;
    }
    handleCorsAddressLine3(e) {
        this.cor_address_line3 = e.detail.value;
    }
    handleRegAddressLine1(e) {
        this.reg_address_line1 = e.detail.value;
    }
    handleRegAddressLine2(e) {
        this.reg_address_line2 = e.detail.value;
    }
    handleRegAddressLine3(e) {
        this.reg_address_line3 = e.detail.value;
    }
    checkValidation() {
        let is_valid = true;
        //console.log('checkValidation');
        //console.log('this.reg_no=', this.reg_no);
        //console.log('this.reg_no=', this.reg_no.length);
        let pattern = /[a-zA-Z]+[(@!#\$%\^\&*\)\(+=._-]{1,}/;
        if ((this.tel_no === '') || (this.tel_no.length === 0) || (this.tel_no === null) || (this.tel_no.length < 6) ) {
            this.error_msg = 'Invalid Office Telephone No.';
            is_valid = false;
        }
        if ((this.mob_no === '') || (this.mob_no.length === 0) || (this.mob_no === null) || (this.mob_no.length < 6) ) {
            this.error_msg = 'Invalid Mobile Number';
            is_valid = false;
        }
        // if(this.reg_no){
        // if ((this.reg_no.length !== 8) || (this.reg_no === 'undefined') || (this.reg_no === undefined)) {
        //     this.error_msg = 'Invalid Registration No.';
        //     is_valid = false;
        // }
        // }else{
        //     this.error_msg = 'Invalid Registration No.';
        //     is_valid = false;
        // }
        // if (this.cor_address_line1.length < 5) {
        //     this.error_msg = 'Invalid correspondence Address';
        //     is_valid = false;
        // }
        if (this.cor_address_line1.length < 2) {
            this.error_msg = 'Invalid Correspondence Address';
            is_valid = false;
        }
        if (this.reg_address_line1.length < 2) {
            this.error_msg = 'Invalid Registered Company Address';
            is_valid = false;
        }
        //console.log('pattern=', /[^a-zA-Z\-\/ /]/.test(this.company_name));
        if (this.company_name.length < 2) {
            this.error_msg = 'Invalid Registered Company Name';
            is_valid = false;
        }
        if ((this.documentid !== '') && (this.effective_date === '')) {
            this.error_msg = 'Invalid Effective Date';
            is_valid = false;
        }
        return is_valid;
    }
    handleUpdate(e) {
        //console.log('handleUpdate');
        let is_valid = this.checkValidation();

        if (is_valid) {
            const fields = {};
            try {
                fields[ID_FIELD.fieldApiName] = this.acc_id;

                fields[PHONE_FIELD.fieldApiName] = this.tel_no;
                fields[MOBILE_FIELD.fieldApiName] = this.mob_no;
                fields[GOODS_FIELD.fieldApiName] = this.goods_value;
                fields[LEGAL_FIELD.fieldApiName] = this.legal_value;
                fields[LANGUAGE_FIELD.fieldApiName] = this.language_correspondence;
                fields[BANK_FIELD.fieldApiName] = this.bank_acc;
                fields[COR_ADD1_FIELD.fieldApiName] = this.cor_address_line1;
                fields[COR_ADD2_FIELD.fieldApiName] = this.cor_address_line2;
                fields[COR_ADD3_FIELD.fieldApiName] = this.cor_address_line3;
                fields[COR_TERITORRY_FIELD.fieldApiName] = this.cor_territory_value;
                fields[COR_DIS_FIELD.fieldApiName] = this.cor_district_value;

                if (this.documentid !== '') {
                    fields[NAME_FIELD.fieldApiName] = this.company_name;
                    fields[REG_FIELD.fieldApiName] = this.reg_no;
                    fields[DOCUMENT_ID_FIELD.fieldApiName] = this.documentid;
                    fields[REG_ADDL1_FIELD.fieldApiName] = this.reg_address_line1;
                    fields[REG_ADDL2_FIELD.fieldApiName] = this.reg_address_line2;
                    fields[REG_ADDL3_FIELD.fieldApiName] = this.reg_address_line3;
                    fields[REG_DIST_FIELD.fieldApiName] = this.reg_district_value;
                    fields[REG_TERR_FIELD.fieldApiName] = this.reg_territory_value;
                    fields[AMEND_EFFECTIVE_DATE_FIELD.fieldApiName] = this.effective_date;
                    fields[IS_UDER_REVIEW_FIELD.fieldApiName] = true;
                    
                    const recordInput = { fields };
                        updateRecord(recordInput)
                            .then(() => {
                                //console.log('Account updated');
                                this.createDocumentRecord();
                                this.show_confirmation = true;
                            })
                            .catch(error => {
                                // console.log('error in account update', error.body.message);
                            });
                } else {
                    //console.log('reg_address_line1=',this.reg_address_line1);
                    //console.log('prev_reg_address_line1=',this.prev_reg_address_line1);
                    if ((this.prev_reg_no !== this.reg_no) || (this.prev_company_name !== this.company_name) || (this.prev_reg_address_line1 !== this.reg_address_line1) || (this.prev_reg_address_line2 !== this.reg_address_line2) || (this.prev_reg_address_line3 !== this.reg_address_line3) || (this.prev_reg_district_value !== this.reg_district_value) || (this.prev_reg_territory_value !== this.reg_territory_value)) {
                        this.showToast('Please upload a BR as supporting document, in order to change the company name / business registration number / registered company address.');
                    } else {

                        const recordInput = { fields };
                        updateRecord(recordInput)
                            .then(() => {
                                //console.log('Account updated');
                                this.show_confirmation = true;
                            })
                            .catch(error => {
                                //console.log('error in account update', JSON.stringify(error));
                            });
                    }
                }

            } catch (error) {
                //console.log('exception=', JSON.stringify(error));
                console.error('Error=', JSON.stringify(error));
            }
        } else {
            this.showToast(this.error_msg);
        }
    }
    createDocumentRecord() {
        var fields = [];
        fields = {
            'Account__c': this.acc_id,
            'Document_Id__c': this.documentid,
            'Document_Type__c': 'BR Document',
            'Status__c': 'New',
            'Received_Date__c': this.today,
            'BR_Number__c': this.reg_no
        }
        var objRecordInput = { 'apiName': 'ECIC_Document__c', fields };
        createRecord(objRecordInput).then(response => {
            createTask({
                'subject': 'Company Information updated.',
                'description': 'Company Information has been updated. Please verify.',
                'priority':'High',
                'type':'',
                'assignedTo':'',
                'relatedID':this.acc_id
            }).then((result) => {
                //console.log('br expired task',result);
            }).catch((error) => {
                //console.log(error);
            });
            //console.log('Document record created with Id: ' + response.id);                                
                 
        }).catch(error => {
            //console.log('Doc record Error: ' + JSON.stringify(error));
            console.error('Doc record Error: ' + JSON.stringify(error));
        });    

    }	
    get today() {	
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



    handleCompanyName(e) {
        this.company_name = e.target.value;
    }
    handleCompanyAddress1(e) {
        this.address_line1 = e.target.value;
    }
    handleCompanyAddress2(e) {
        this.address_line2 = e.target.value;
    }
    handleCompanyAddress3(e) {
        this.address_line3 = e.target.value;
    }
    handleRegNo(e) {
        this.reg_no = e.target.value;
        // //console.log(this.reg_no);
    }
    handleTelNo(e) {
        this.tel_no = e.target.value;
    }
    handleLanguage(e) {
        this.language_correspondence = e.target.value;
    }
    handleBankAcc(e) {
        //console.log('bankaccount=', e.target.checked);
        this.bank_acc = e.target.checked;
    }
    handleEffectiveDate(e) {
        this.effective_date = e.target.value;
    }
    // registeredTerritory = ""
    // correspondenceTerritory = ""
    // district_options 
    
    
    // get registeredDistrictOptions() {
    //     //console.log('this.reg_territory_value',this.reg_territory_value);

    //     return this.districtTerritory[this.reg_territory_value] ? this.districtTerritory[this.reg_territory_value].map((el) => ({ label: el, value: el })) : []
    // }
    // get correspondenceDistrictOptions() {
    //     return this.districtTerritory[this.cor_territory_value] ? this.districtTerritory[this.cor_territory_value].map((el) => ({ label: el, value: el })) : []
    // }
    formatDate(date) {
        var curDate = new Date(date);
        if (curDate.getMonth() == 11) {
            var current = new Date(curDate.getFullYear() + 1, 0, curDate.getDate());
        } else {
            var current = new Date(curDate.getFullYear(), curDate.getMonth() + 1, curDate.getDate());
        }

        const today = current.getFullYear() + '-' + String(current.getMonth()).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    callgetDistrictTerritory(){
        getDistrictTerritoryList()
        .then((result) => {
            //console.log("territory result", JSON.stringify(result));            
            /*let territory_list = [];
            result.map((each_el)=>{territory_list.push(each_el.District_Territory__c)});
            let unique_territory_list = territory_list.filter((v, i, a) => a.indexOf(v) === i);
            unique_territory_list.sort((a, b) => a.localeCompare(b));
            let temp_district_territory = [];
            unique_territory_list.map((each_terr)=>{
                let dist_list = [];
                result.map((each_el)=>{
                    if(each_el.District_Territory__c.trim() === each_terr.trim())
                    dist_list.push(each_el.District__c)
                })
                temp_district_territory.push({[each_terr]:dist_list});
            })
            let final_district_territory = [];*/
            /*let territory_list={}
            result.forEach(el => {
                if (territory_list[el.District_Territory__c]) {
                    territory_list[el.District_Territory__c] =[...territory_list[el.District_Territory__c], el.District__c]
                }else{
                territory_list[el.District_Territory__c] = [el.District__c]
                }
            });
            this.districtTerritory=territory_list;
            //console.log('final_district_territory=',JSON.stringify(this.districtTerritory));
            this.territory_options = Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el }))
            if (this.companyinfo.Correspondence_Territory__c) {
                //console.log('this.companyinfo.Correspondence_Territory__c=',this.companyinfo.Correspondence_Territory__c);
                this.cor_territory_value = this.companyinfo.Correspondence_Territory__c;
                this.correspondenceDistrictOptions = this.districtTerritory[this.cor_territory_value] ? this.districtTerritory[this.cor_territory_value].map((el) => ({ label: el, value: el })) : [];
                this.correspondenceDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
            }
            if (this.companyinfo.Registered_Territory__c) {
                this.reg_territory_value = this.companyinfo.Registered_Territory__c;
                this.prev_reg_territory_value = this.companyinfo.Registered_Territory__c;
                this.registeredDistrictOptions = this.districtTerritory[this.reg_territory_value] ? this.districtTerritory[this.reg_territory_value].map((el) => ({ label: el, value: el })) : [];
                this.registeredDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
            }*/
        })
        .catch((error) => {
            //console.log('error=', error);
        });
    }
    callProduct(){
        getProduct()
        .then((result) => {
            //console.log("callProduct result", JSON.stringify(result));
            this.goods_options = result.map((el)=>({ label: el.PRD_DESC__c, value: el.PRD_DESC__c }));
            // this.legal_options = result.map((el)=>({ label: el.code_value__c, value: el.code_value__c }))
        })
        .catch((error) => {
            //console.log('error=', error);
        });
    }
    callLegalType(){
        getLegalType()
        .then((result) => {
            //console.log("legaltype result", JSON.stringify(result));
            this.legal_options = result.map((el)=>({ label: el.code_value__c, value: el.code_value__c }))
        })
        .catch((error) => {
            //console.log('error=', error);
        });
    }
    callgetPolicyType() {
        console.log('accId=',this.acc_id);
        getPolicyType({
            acc_id: this.acc_id
        })
            .then((result) => {
                console.log("Policy details=", JSON.stringify(result));
                this.policy_type = result;
            })
            .catch((error) => {
                //consele.log("error");                
                console.error(error);
            });
    }
    renderedCallback() {
        if (!this.is_rendered) {
            this.is_rendered = true;
            this.callgetDistrictTerritory();
            this.callLegalType();
            // this.callProduct();
            var today = this.formatDate(new Date());
            // console.log('companyinfo=',JSON.stringify(this.companyinfo));
            this.min_effective_date = this.today;
            this.acc_id = this.companyinfo.Id;
            this.callgetPolicyType();
            if (this.companyinfo.Name) {
                this.company_name = this.companyinfo.Name;
                this.prev_company_name = this.companyinfo.Name;
            }
            if (this.companyinfo.Legal_Type__c) {
                this.legal_value = this.companyinfo.Legal_Type__c;
            }
            if (this.companyinfo.Goods_or_Services__c) {
                this.goods_value = this.companyinfo.Goods_or_Services__c;
            }
            if (this.companyinfo.Registration_Number__c) {
                this.reg_no = this.companyinfo.Registration_Number__c;
                this.prev_reg_no = this.companyinfo.Registration_Number__c;
            }
            if (this.companyinfo.Phone) {
                this.tel_no = this.companyinfo.Phone;
            }
            if (this.companyinfo.Mobile__c) {
                this.mob_no = this.companyinfo.Mobile__c;
            }
            if (this.companyinfo.Language_of_Correspondence__c) {
                this.language_correspondence = this.companyinfo.Language_of_Correspondence__c;
            }
            this.bank_acc = this.companyinfo.Bank_Account__c;
            if (this.companyinfo.Registered_Address_Line_1__c) {
                this.reg_address_line1 = this.companyinfo.Registered_Address_Line_1__c;
                this.prev_reg_address_line1 = this.companyinfo.Registered_Address_Line_1__c;
            }
            if (this.companyinfo.Registered_Address_Line_2__c) {
                this.reg_address_line2 = this.companyinfo.Registered_Address_Line_2__c;
                this.prev_reg_address_line2 = this.companyinfo.Registered_Address_Line_2__c;
            }
            if (this.companyinfo.Registered_Address_Line_3__c) {
                this.reg_address_line3 = this.companyinfo.Registered_Address_Line_3__c;
                this.prev_reg_address_line3 = this.companyinfo.Registered_Address_Line_3__c;
            }
            if (this.companyinfo.Registered_District__c) {
                this.reg_district_value = this.companyinfo.Registered_District__c;
                this.prev_reg_district_value = this.companyinfo.Registered_District__c;
            }
            if (this.companyinfo.Registered_Territory__c) {
                this.reg_territory_value = this.companyinfo.Registered_Territory__c;
                this.prev_reg_territory_value = this.companyinfo.Registered_Territory__c;
                this.registeredDistrictOptions = this.districtTerritory[this.reg_territory_value] ? this.districtTerritory[this.reg_territory_value].map((el) => ({ label: el, value: el })) : [];
                this.registeredDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
            }
            if (this.companyinfo.Correspondence_Address_Line_1__c) {
                this.cor_address_line1 = this.companyinfo.Correspondence_Address_Line_1__c;
            }
            if (this.companyinfo.Correspondence_Address_Line_2__c) {
                this.cor_address_line2 = this.companyinfo.Correspondence_Address_Line_2__c;
            }
            if (this.companyinfo.Correspondence_Address_Line_3__c) {
                this.cor_address_line3 = this.companyinfo.Correspondence_Address_Line_3__c;
            }
            if (this.companyinfo.Correspondence_District__c) {
                this.cor_district_value = this.companyinfo.Correspondence_District__c;
            }
            if (this.companyinfo.Correspondence_Territory__c) {
                //console.log('this.companyinfo.Correspondence_Territory__c=',this.companyinfo.Correspondence_Territory__c);
                this.cor_territory_value = this.companyinfo.Correspondence_Territory__c;
                this.correspondenceDistrictOptions = this.districtTerritory[this.cor_territory_value] ? this.districtTerritory[this.cor_territory_value].map((el) => ({ label: el, value: el })) : [];
                this.correspondenceDistrictOptions.sort((a, b) => a.label.localeCompare(b.label));
            }
        }

    }
}
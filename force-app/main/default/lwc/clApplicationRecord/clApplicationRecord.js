/* eslint-disable  no-console */
import { api, LightningElement, track, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import searchCL from '@salesforce/apex/CLApplicationRecord.getCreditLimitRecord';
// import newclr from '@salesforce/apex/CLApplicationRecord.getCreditLimitRecordByID';
import UsrId from '@salesforce/user/Id';
import getCLListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLListByPolicy';
import getCLAListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLAListByPolicy';

import getPolicyHolder from '@salesforce/apex/ClPolicy.getPolicyHolder';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import CLA_ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import CLA_STATUS_FIELD from '@salesforce/schema/Credit_Limit_Application__c.CL_Status__c';
import createOMBPInvoice from '@salesforce/apex/CLInvoice.createOMBPInvoice';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getProductDetails from '@salesforce/apex/CLProductDetails.getProductDetails';


import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Search_Credit_Limit_Record from '@salesforce/label/c.Search_Credit_Limit_Record';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Status from '@salesforce/label/c.Status';
import Credit_Limit_small from '@salesforce/label/c.Credit_Limit_small';
import Date_from_to from '@salesforce/label/c.Date_from_to';
import Issue from '@salesforce/label/c.Issue';
import Effective from '@salesforce/label/c.Effective';
import Credit_Limit_Record from '@salesforce/label/c.Credit_Limit_Record';
import Ordered_by from '@salesforce/label/c.Ordered_by';
import Application_Date_CL from '@salesforce/label/c.Application_Date_CL';
import Date_CL from '@salesforce/label/c.Date_CL';
import Credit_Limit_Number from '@salesforce/label/c.Credit_Limit_Number';
import No_record_found from '@salesforce/label/c.No_record_found';
import Progress_40 from '@salesforce/label/c.Progress_40';
import Expiry_Date from '@salesforce/label/c.Expiry_Date';
import Uplift_Credit_Limit from '@salesforce/label/c.Uplift_Credit_Limit';
import Reapply_Credit_Limit from '@salesforce/label/c.Reapply_Credit_Limit';
import Amend_Application from '@salesforce/label/c.Amend_Application';
import Cancel_Application from '@salesforce/label/c.Cancel_Application';
import Cancel_Credit_Limit from '@salesforce/label/c.Cancel_Credit_Limit';
import Reject_Credit_Limit from '@salesforce/label/c.Reject_Credit_Limit';
import Credit_Limit_Application_Amount_HKD from '@salesforce/label/c.Credit_Limit_Application_Amount_HKD';
import Buyer_Address from '@salesforce/label/c.Buyer_Address';
import Credit_Limit_Amount_HKD from '@salesforce/label/c.Credit_Limit_Amount_HKD';
import Premium_HKD from '@salesforce/label/c.Premium_HKD';
import Reference_Number from '@salesforce/label/c.Reference_Number';
import Remark from '@salesforce/label/c.Remark';
import Effective_Date_CL from '@salesforce/label/c.Effective_Date_CL';
import Valid from '@salesforce/label/c.Valid';
import Invalid from '@salesforce/label/c.Invalid';
import Waiting_for_payment from '@salesforce/label/c.Waiting_for_payment';
import Processing from '@salesforce/label/c.Processing';
import Step1 from '@salesforce/label/c.Step1';
import Step2 from '@salesforce/label/c.Step2';
import Step3 from '@salesforce/label/c.Step3';
import Step4 from '@salesforce/label/c.Step4';
import Step5 from '@salesforce/label/c.Step5';
import Application_Received from '@salesforce/label/c.Application_Received';
import Gathering_Information from '@salesforce/label/c.Gathering_Information';
import Application_under_Assessment from '@salesforce/label/c.Application_under_Assessment';
import Assessment_Completed from '@salesforce/label/c.Assessment_Completed';
import Gathering_Additional_Information from '@salesforce/label/c.Gathering_Additional_Information';
import Accept_Indication from '@salesforce/label/c.Accept_Indication';
import Uplift_Application from '@salesforce/label/c.Uplift_Application';
import New_Application from '@salesforce/label/c.New_Application';
import Search from '@salesforce/label/c.Search';
import Clear_Filters from '@salesforce/label/c.Clear_Filters';
import Export from '@salesforce/label/c.Export';



export default class ClApplicationRecord extends NavigationMixin(LightningElement) {

    @track label = {
        Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,Search_Credit_Limit_Record,
        Buyer_Code,Buyer_Name,Status,Credit_Limit_small,Date_from_to,Issue,Effective,Credit_Limit_Record,Ordered_by,
        Application_Date_CL,Date_CL,No_record_found,Progress_40,Credit_Limit_Number,Expiry_Date,Uplift_Credit_Limit,
        Reapply_Credit_Limit,Amend_Application,Cancel_Application,Cancel_Credit_Limit,Reject_Credit_Limit,Credit_Limit_Application_Amount_HKD,
        Buyer_Address,Credit_Limit_Amount_HKD,Premium_HKD,Reference_Number,Remark,Effective_Date_CL,Valid,Invalid,
        Waiting_for_payment,Processing,Step1,Step2,Step3,Step4,Step5,Application_Received,Gathering_Information,Application_under_Assessment,
        Assessment_Completed,Gathering_Additional_Information,Accept_Indication,Uplift_Application,New_Application,Search,Clear_Filters,Export
    }

    queryTermBuyerCode
    UsrId = UsrId;
    @track accId = '';
    /*@wire(getPolicyHolder, { 'user_id': UsrId })
    wiredPolicyHolder({ error, data }) {
        if (data) {
            //consele.log('Policy data',JSON.stringify(data));
        } else if (error) {
            console.error(error);
        }
    }*/


    @track StatusList = [
        { value: 'Valid', label: this.label.Valid },
        { value: 'Invalid', label: this.label.Invalid },
        { value: 'Waiting for payment', label: this.label.Waiting_for_payment },
        { value: 'Processing', label: this.label.Processing }

     ];
    // @track StatusList = [
    //     { value: 'Valid', label: 'Valid' },
    //     { value: 'Invalid', label: 'Invalid' },
    //     { value: 'Waiting for payment', label: 'Waiting for payment' },
    //     { value: 'Processing', label: 'Processing' }

    // ];
    @api search_buyer_code = null;
    @api search_buyer_name = null;
    @api search_status = null;
    @api search_from_date = null;
    @api search_to_date = null;
    @track clRecord = [];
    @track show_cl_record = false;
    @api clrid = "";
    @track has_rendered = false;
    @track account_name = "";
    @track policy_no = "";
    @track policy_type = "";
    @track policy_id = "";
    @track show_checkbox_spinner = true;
    @track available_credit_check_facility = '';
    @track showCheckFacilityModal = false;
    @api policy_detail = [];
    @track showCancelCLAModal = false;
    @track showCancelCLModal = false;    
    @track steps = [
        {
            id:1,
            name: this.label.Step1,
            des: this.label.Application_Received
        },
        {
            id:2,
            name: this.label.Step2,
            des: this.label.Gathering_Information
        },
        {
            id:3,
            name: this.label.Step3,
            des: this.label.Application_under_Assessment
        },
        {
            id:4,
            name: this.label.Step4,
            des: this.label.Gathering_Additional_Information
        },
        {
            id:5,
            name: this.label.Step5,
            des: this.label.Assessment_Completed
        }
    ];
    @track effective_or_issue_date = '';
    @track application_text_class = 'blue_text';
    @track effective_date_text_class = 'black_text';
    @track cl_app_date_search_type = '';
    @track cl_eff_date_search_type='';
    @track cancel_cl_id = '';
    @track rejectModal = false;
    @track reject_cl_id = '';
    @track reject_cl_approve_date = '';
    @track domainBaseURL = '';
    @track allow_cl_create = true;
    @track product_detail = [];
    
   callgetProductDetails(){
        getProductDetails({
            'prd_name':this.policy_type
        }).then((result)=>{
            this.product_detail = result;
        }).catch((error)=>{
            console.log('error in getProductDetails',JSON.stringify(error));
        });
   } 
    // handleProductDetails({ error, data }) {
    //     console.log('handleProductDetails=',JSON.stringify(data));
    //     if (data) {
    //         this.product_detail = data;            
    //     }
    //     if (error) {
    //         console.error('Error',JSON.stringify(error));
    //     }
    // }

    handleStatusChange(e) {
        //consele.log(e.target.value);
        this.search_status = e.target.value;
    }
    handleBuyerCode(e) {
        this.search_buyer_code = e.target.value;
    }
    handleBuyerName(e) {
        this.search_buyer_name = e.target.value;
    }
    // handleStatusChange(e) {
    //     this.search_status = e.target.value;
    // }
    handleEffectiveDateFrom(e) {
        this.search_from_date = e.target.value;
    }
    handleEffectiveDateTo(e) {
        this.search_to_date = e.target.value;
    }
    expandHandler(event) {
        //consele.log('expandHandler=', event.currentTarget.id);
        let id = event.currentTarget.id + ""
        id = id.split("-")[0];
        this.clRecord.forEach((cl) => {
            cl.isSectionOpen = id === cl.Id ? !cl.isSectionOpen : cl.isSectionOpen
            cl.iconName = id === cl.Id && cl.isSectionOpen ? 'utility:up' : 'utility:down'
            //:'utility:down',
        })

    }
    handleClearFilter(e) {
        this.clRecord = [];
        
        this.search_status = '';
        this.search_buyer_name = '';
        this.search_buyer_code = '';
        this.search_status = '';
        this.search_from_date = '';
        this.search_to_date = '';
        this.show_checkbox_spinner = true;
        this.getCLList();
    }
    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;
    }
    handleCancelCLA(e){
        this.cancel_cl_id = e.currentTarget.dataset.id;
        this.showCancelCLAModal = true;        
    }
    handleCancelCLAModalClose(){
        this.showCancelCLAModal = false;
        this.show_checkbox_spinner = true;
        this.clRecord = [];
        this.getCLList();
    }
    handleCancelCL(e) {
        this.cancel_cl_id = e.currentTarget.dataset.id;
        this.showCancelCLModal = true;
    }
    handleRejectCL(e) {        
        let self = this;
        this.reject_cl_id = e.currentTarget.dataset.id;
        this.clRecord.map((each_rec) => {
            if(each_rec.Id === self.reject_cl_id)
            self.reject_cl_approve_date = each_rec.Approve_Date__c
        })
        this.rejectModal = true;        
    }
    handleRejectCLModalClose() {
        this.rejectModal = false;
    }
    handleCancelCLModalClose() {
        this.showCancelCLModal = false;
    }
    copySelectedFields (originObject, fieldNamesArray)
    {
        var obj = {};

        if (fieldNamesArray === null)
            return obj;

        for (var i = 0; i < fieldNamesArray.length; i++) {
            obj[fieldNamesArray[i]] = originObject[fieldNamesArray[i]];
        }

        return obj;
    };

    handleExcel() {
        // let temp_cl_record = this.copySelectedFields(this.clRecord,['Name','CL_Amount__c','CL_Status__c','CL_No__c']);

        let temp_cl_record = JSON.parse(JSON.stringify(this.clRecord));
        // this.clRecord.map((each_rec)=>{
        //     temp_cl_record.push({
        //         ...each_rec
        //     });
        // })
        //consele.log('temp_cl_record='+JSON.stringify(temp_cl_record));
        for(var i = 0; i < temp_cl_record.length; i++){
            delete temp_cl_record[i]['Id'];
            delete temp_cl_record[i]['isSectionOpen'];
            delete temp_cl_record[i]['iconName'];
            delete temp_cl_record[i]['class'];
            delete temp_cl_record[i]['uplift_btn'];
            delete temp_cl_record[i]['renew_btn'];
            delete temp_cl_record[i]['uplift_rec_exist'];
            delete temp_cl_record[i]['Is_Uplifted__c'];
            delete temp_cl_record[i]['reapply_rec_exist'];
            delete temp_cl_record[i]['show_cancel_cl'];
            delete temp_cl_record[i]['show_premium'];
        }
        //consele.log('temp_cl_record=',JSON.stringify(temp_cl_record));
        // temp_cl_record.forEach( obj => renameKey( obj, '_id', 'id' ) );
        /*temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_Status__c", "Status"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_Amount__c", "CL Amount"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_No__c", "CL Number"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Application_Date__c", "Application Date"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Address_Line_1__c", "Buyer Address Line 1"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Address_Line_2__c", "Buyer Address Line 2"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Address_Line_3__c", "Buyer Address Line 3"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Address_Line_4__c", "Buyer Address Line 4"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Country__c", "Buyer Country"));
        temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("Buyer_Name__c", "Buyer Name"));*/
        // temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_Status__c", "Status"));
        // temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_Status__c", "Status"));
        // temp_cl_record = JSON.parse(JSON.stringify(temp_cl_record).replace("CL_Status__c", "Status"));

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        var json = temp_cl_record
        var fields = Object.keys(json[0])
        var replacer = function(key, value) { return value === null ? '' : value } 
        var csv = json.map(function(row){
        return fields.map(function(fieldName){
            return JSON.stringify(row[fieldName], replacer)
        }).join(',')
        })
        //consele.log('fields=',fields);
        csv.unshift(fields.join(',')) // add header column
        csv = csv.join('\r\n');
        downloadElement.href = 'data:application/excel;charset=utf-8,' + encodeURI(csv);
        
        
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download ='Credit Limit.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }
    sortByEffectiveDate() {
        return function (a, b) {      
          // equal items sort equally
          if (a.CL_Effective_Date__c === b.CL_Effective_Date__c) {
              return 0;
          }
          // nulls sort after anything else
          else if (a.CL_Effective_Date__c === null) {
              return 1;
          }
          else if (b.CL_Effective_Date__c === null) {
              return -1;
          }          
          else { 
              return a.CL_Effective_Date__c < b.CL_Effective_Date__c ? 1 : -1;
          }      
        };      
    }
    sortByEffectiveDateAsc() {
        return function (a, b) {      
          // equal items sort equally
          if (a.CL_Effective_Date__c === b.CL_Effective_Date__c) {
              return 0;
          }
          // nulls sort after anything else
          else if (b.CL_Effective_Date__c === null) {
              return 1;
          }
          else if (a.CL_Effective_Date__c === null) {
              return -1;
          }          
          else { 
              return b.CL_Effective_Date__c < a.CL_Effective_Date__c ? 1 : -1;
          }      
        };      
    }
    sortByApplicationDate() {
        return function (a, b) {      
          // equal items sort equally
          if (a.Application_Date__c === b.Application_Date__c) {
              return 0;
          }
          // nulls sort after anything else
          else if (a.Application_Date__c === null) {
              return 1;
          }
          else if (b.Application_Date__c === null) {
              return -1;
          }          
          else { 
              return a.Application_Date__c < b.Application_Date__c ? 1 : -1;
          }      
        };      
    }
    sortByApplicationDateAsc() {
        return function (a, b) {      
          // equal items sort equally
          if (a.Application_Date__c === b.Application_Date__c) {
              return 0;
          }
          // nulls sort after anything else
          else if (b.Application_Date__c === null) {
              return 1;
          }
          else if (a.Application_Date__c === null) {
              return -1;
          }          
          else { 
              return b.Application_Date__c < a.Application_Date__c ? 1 : -1;
          }      
        };      
    }
      
    handleApplicationDateSort(e) {
        //consele.log('handleApplicationDateSort');
        let cl_rec = this.clRecord;
        this.clRecord = [];
        // cl_rec.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
        if ((this.cl_app_date_search_type ==='')||(this.cl_app_date_search_type ==='asc')){
            cl_rec.sort(this.sortByApplicationDate());
            this.cl_app_date_search_type ='desc';
        } else {
            cl_rec.sort(this.sortByApplicationDateAsc());
            this.cl_app_date_search_type ='asc';
        }
        this.clRecord = cl_rec;
        this.application_text_class = 'blue_text';
        this.effective_date_text_class = 'black_text';
    }
    handleEffectiveDateSort(e) {
        let cl_rec = this.clRecord;
        this.clRecord = [];
        if ((this.cl_eff_date_search_type ==='')||(this.cl_eff_date_search_type ==='asc')){
            cl_rec.sort(this.sortByEffectiveDate());
            this.cl_eff_date_search_type ='desc';
        } else {
            cl_rec.sort(this.sortByEffectiveDateAsc());
            this.cl_eff_date_search_type ='asc';
        }
        
        this.clRecord = cl_rec;  
        this.application_text_class = 'black_text';
        this.effective_date_text_class = 'blue_text';      
    }
    handleSearch(e) {
        this.show_checkbox_spinner = true;
        //consele.log("handleSearch");
        //consele.log("this.search_buyer_code=" + this.search_buyer_code);
        //consele.log("this.search_buyer_name=" + this.search_buyer_name);
        //consele.log("this.search_status=" + this.search_status);
        //consele.log("this.search_from_date=" + this.search_from_date);
        //consele.log("this.search_to_date=" + this.search_to_date);
        var reappliedClaList = [];
        var upliftedClaList = [];
        searchCL({
            buyer_name: this.search_buyer_name,
            buyer_code: this.search_buyer_code,
            status: this.search_status,
            from_date: this.search_from_date,
            to_date: this.search_to_date,
            policy_id: this.policy_id
        })
            .then((result) => {
                //consele.log("result=", JSON.stringify(result));
                //consele.log('cla length=',result.claList.length);
                //consele.log('cl length=',result.clList.length);
                let claList = result.claList;
                let clList = result.clList;
                this.show_checkbox_spinner = false;
                this.clRecord = [];
                let self = this;
                var today = new Date();
                var dd = String(today.getDate()).padStart(2, '0');
                var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                var yyyy = today.getFullYear();
                today = yyyy + '-' + mm + '-' + dd;
                if ((claList.length > 0) || (clList.length > 0)) {
                    this.clRecord = [];
                    //consele.log('search result=',JSON.stringify(result));
                    clList.map(function (each_cl, index) {
                        let classval = '';
                        let show_uplift = false;
                        let show_renew = false;
                        let show_cancel_cl = false;
                        let show_premium = false;
                        let show_cl_notification = false;
                        if (each_cl.CL_Progress_Step__c == 1)
                            classval = 'slds-progress-bar__value progress1';
                        else if (each_cl.CL_Progress_Step__c == 2)
                            classval = 'slds-progress-bar__value progress2';
                        else if (each_cl.CL_Progress_Step__c == 3)
                            classval = 'slds-progress-bar__value progress3';
                        else if (each_cl.CL_Progress_Step__c == 4)
                            classval = 'slds-progress-bar__value progress4';
                        else if (each_cl.CL_Progress_Step__c == 5)
                            classval = 'slds-progress-bar__value progress5';
                        //consele.log('each_cl',JSON.stringify(each_cl));
                        try{
                            if (self.policy_type === 'OMBP') {
                                show_premium = true;
                            }                            
                        if ((each_cl.Expiry_Date__c) && (self.policy_type === 'OMBP')) {
                            if(each_cl.Expiry_Date__c){
                            let date_dif = new Date(today.toString()).valueOf() <= new Date(each_cl.Expiry_Date__c.toString()).valueOf() ? self.getDaysBetween(new Date(today), new Date(each_cl.Expiry_Date__c)) : '';
                                
                            if ((date_dif !== '') && (date_dif >= 1) && (date_dif <= 60) && (each_cl.CL_Status__c === 'Valid') && (self.policy_type === 'OMBP') && (!each_cl.Is_Uplifted__c)) {
                                show_uplift = true;
                            } else {
                                show_uplift = false;
                            }

                            if ((date_dif !== '') && (date_dif >= 61) && (date_dif <= 90) && (self.policy_type === 'OMBP')) {
                                show_renew = true;
                            } else {
                                show_renew = false;
                            }
                            }
                        } else if (self.policy_type === 'SBP') {
                            show_renew = true;
                            show_cancel_cl = true;
                            //'show_ammend': show_ammend,
                            //'show_cancel_application': show_cancel_application
                        }
                        if (each_cl.CL_Application_Amount__c){
                            each_cl.CL_Application_Amount__c = each_cl.CL_Application_Amount__c.toLocaleString();
                        }
                        if (each_cl.CL_Amount__c){
                            each_cl.CL_Amount__c = each_cl.CL_Amount__c.toLocaleString();
                        }
                        if (each_cl.Premium__c){
                            each_cl.Premium__c = each_cl.Premium__c.toLocaleString();
                        }
                        if(each_cl.CL_Approve_Letter__c) {
                            show_cl_notification = true;
                        }
                        self.clRecord.push({
                            ...each_cl,
                            'isSectionOpen': false,
                            'iconName': 'utility:down',
                            'class': classval,
                            'uplift_btn': show_uplift,
                            'renew_btn': show_renew,
                            'uplift_rec_exist': false,
                            'reapply_rec_exist': false,
                            'show_cancel_cl': show_cancel_cl,
                            'show_premium': show_premium,
                            'show_cl_notification': show_cl_notification
                        });
                        // valid Date wise filtering  
                        }catch(exception){
                            //consele.log('exception',JSON.stringify(exception));
                            console.error('exception',JSON.stringify(exception));
                        }                      
                    });
                    //------------
                    //consele.log('after cl and before cla');
                    claList.map(function (each_cl, index) {
                        let classval = '';
                        let show_uplift = false;
                        let show_renew = false;
                        let show_ammend = false;
                        let show_cancel_application = false;
                        let show_premium = false;

                        
                        if (each_cl.CL_Progress_Step__c == 1)
                            classval = 'slds-progress-bar__value progress1';
                        else if (each_cl.CL_Progress_Step__c == 2)
                            classval = 'slds-progress-bar__value progress2';
                        else if (each_cl.CL_Progress_Step__c == 3)
                            classval = 'slds-progress-bar__value progress3';
                        else if (each_cl.CL_Progress_Step__c == 4)
                            classval = 'slds-progress-bar__value progress4';
                        else if (each_cl.CL_Progress_Step__c == 5)
                            classval = 'slds-progress-bar__value progress5';

                        if (self.policy_type === 'SBP') {
                            show_ammend = true;
                            show_cancel_application = true;                            
                        } else if (self.policy_type === 'SUP') {
                            show_ammend = true;
                            show_cancel_application = true;
                        } else {
                            show_premium = true;
                        }
                        
                        /*if (each_cl.Application_Type__c === 'Reapply') {
                            //consele.log('uplift CLA ID=', each_cl.Id);
                            reappliedClaList.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'show_ammend': show_ammend,
                                'show_cancel_application': show_cancel_application
                            });
                        } else*/ if (each_cl.Application_Type__c === 'Uplift'){
                            if (each_cl.CL_Application_Amount__c){
                                each_cl.CL_Application_Amount__c = each_cl.CL_Application_Amount__c.toLocaleString();
                            }
                            if (each_cl.CL_Amount__c){
                                each_cl.CL_Amount__c = each_cl.CL_Amount__c.toLocaleString();
                            }
                            if (each_cl.Premium__c){
                                each_cl.Premium__c = each_cl.Premium__c.toLocaleString();
                            }
                            upliftedClaList.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew
                            });
                        } else {     
                            if (each_cl.CL_Application_Amount__c){
                                each_cl.CL_Application_Amount__c = each_cl.CL_Application_Amount__c.toLocaleString();
                            }
                            if (each_cl.CL_Amount__c){
                                each_cl.CL_Amount__c = each_cl.CL_Amount__c.toLocaleString();
                            }
                            if (each_cl.Premium__c){
                                each_cl.Premium__c = each_cl.Premium__c.toLocaleString();
                            }                       
                            self.clRecord.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'uplift_rec_exist': false,
                                'reapply_rec_exist': false,
                                'show_ammend': show_ammend,
                                'show_cancel_application': show_cancel_application,
                                'show_premium': show_premium
                            });                            
                        }
                    });
                    //consele.log('after cl and cla');
                    upliftedClaList.map((each_uplifted_cla) => {                        
                        for (var i = 0; i < self.clRecord.length; i++) {
                            if (self.clRecord[i].Id === each_uplifted_cla.Credit_Limit_Id__c) {
                                self.clRecord[i].uplift_rec_exist = true;
                                self.clRecord[i].uplifted_cla_rec = each_uplifted_cla;
                            }
                            // //consele.log('Id=',JSON.stringify(temp_clRecord[i]));
                        }
                    });
                    reappliedClaList.map((each_reapplied_cla) => {
                        for (var i = 0; i < self.clRecord.length; i++) {
                            if (self.clRecord[i].Id === each_reapplied_cla.Credit_Limit_Id__c) {
                                self.clRecord[i].reapply_rec_exist = true;
                                self.clRecord[i].reapplied_cla_rec = each_reapplied_cla;
                            }
                            // //consele.log('Id=',JSON.stringify(temp_clRecord[i]));
                        }
                    })
                    // self.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
                    self.clRecord.sort(function (a, b) {
                        if (b.Application_Date__c && a.Application_Date__c)            
                           return  b.Application_Date__c.localeCompare(a.Application_Date__c);
                    });
                    // //consele.log('processed search result=',JSON.stringify(self.clRecord));
                    //---------------
                    this.show_cl_record = true;
                    //--------------------------------
                    /*result.map(function(res,i){
                        //consele.log('res',res);
                        if (res.CL_Status__c === 'Valid'){
                            res["blue_status"]=false;
                            res["green_status"]=true;
                            res["red_status"]=false;
                            res["isSectionOpen"]=false;
                            
                        } else if (res.CL_Status__c === 'Invalid'){
                            res["blue_status"]=false;
                            res["green_status"]=false;
                            res["red_status"]=true;
                            res["isSectionOpen"]=false;
                            
                        } else {
                            res["blue_status"]=true;
                            res["green_status"]=false;
                            res["red_status"]=false;
                            res["isSectionOpen"]=false;
                            
                        }
                    });
                    //consele.log("result after",result);
                    this.show_cl_record = true;
                    this.clRecord = result;*/
                } else {
                    this.show_checkbox_spinner = false;
                    this.show_cl_record = false;
                    this.clRecord = [];
                }

            })
            .catch((error) => {
                this.show_checkbox_spinner = false;
                this.show_cl_record = false;
                this.clRecord = [];
                //consele.log('error:', JSON.stringify(error));
                console.error('error:', JSON.stringify(error));
            });
    }

    handleOpenClApplyNew(e) {
        //consele.log("handleOpenClApplyNew");
        if (this.policy_type === 'OMBP') {
            let event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    Pagename: 'ApplynewOMBP',
                    accId: this.accId
                }
            });
            this.dispatchEvent(event1);
        } else if (this.policy_type === 'SBP') {
            let event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    Pagename: 'ApplynewSBP',
                    accId: this.accId
                }
            });
            this.dispatchEvent(event1);
        } else if (this.policy_type === 'SUP') {
            let event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    Pagename: 'ApplynewSUP',
                    accId: this.accId
                }
            });
            this.dispatchEvent(event1);
        }
    }

    handleUpLift(e) {
        var cl_id = e.currentTarget.dataset.id;
        var cl_record = [];
        this.clRecord.map((each_record) => {
            if (each_record.Id === cl_id) {
                cl_record.push({
                    'application_type': 'Uplift',
                    ...each_record
                });
            }
        });
        if ((this.policy_type === 'OMBP') && (cl_record.length > 0)) {
            //consele.log('cl_record before', JSON.stringify(cl_record));

            let event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    Pagename: 'ApplynewOMBP',
                    accId: this.accId,
                    clRecord: cl_record
                }
            });
            this.dispatchEvent(event1);
        }
    }

    handleReapply(e) {
        var cl_id = e.currentTarget.dataset.id;
        var cl_record = [];
        this.clRecord.map((each_record) => {
            if (each_record.Id === cl_id) {
                cl_record.push({
                    'application_type': 'Reapply',
                    ...each_record
                });
            }
        });        
        if ((this.policy_type === 'OMBP') && (cl_record.length > 0)) {
            let event1 = new CustomEvent('handlepagechange', {
                detail: {
                    Pagename: 'ApplynewOMBP',
                    accId: this.accId,
                    clRecord: cl_record
                }
            });
            this.dispatchEvent(event1);
        } else if ((this.policy_type === 'SUP') && (cl_record.length > 0)) {
            let event1 = new CustomEvent('handlepagechange', {
                detail: {
                    Pagename: 'ApplynewSUP',
                    accId: this.accId,
                    clRecord: cl_record
                }
            });
            this.dispatchEvent(event1);
        }
    }
    handleAmmend(e) {
        var cla_id = e.currentTarget.dataset.id;
        //consele.log('cla_id=',cla_id);
        if (this.policy_type === 'SBP') {
            let event1 = new CustomEvent('handlepagechange', {
                detail: {
                    Pagename: 'AmmendSBP',
                    accId: this.accId,
                    policy_detail: this.policy_detail,
                    cla_id: cla_id
                }
            });
            this.dispatchEvent(event1);
        } else if (this.policy_type === 'SUP') {
            let event1 = new CustomEvent('handlepagechange', {
                detail: {
                    Pagename: 'AmmendSUP',
                    accId: this.accId,
                    policy_detail: this.policy_detail,
                    cla_id: cla_id
                }
            });
            this.dispatchEvent(event1);
        }
    }



    handleBuyerCodeKeyUp(e) {
        let isEnterKey = e.keyCode === 13;
        if (isEnterKey) {
            this.queryTermBuyerCode = e.target.value;
            //consele.log("queryTermBuyerCode=", this.queryTermBuyerCode);
        }
    }
    handleOpenClApplicationConfirmation(e) {
        //consele.log("handleOpenClApplicationConfirmation");
        let event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: {
                Pagename: 'ApplicationConfirmation',
            }
        });
        this.dispatchEvent(event1);
    }
    handleIndicationAccept(e) {
        try{
        //consele.log('handleIndicationAccept')
        this.show_checkbox_spinner = true;
        var cl_id = e.currentTarget.dataset.id;
        var selected_cl_rec = [];
        //consele.log('cl_id=',cl_id);
        let self = this;
        this.clRecord.map((each_cl)=>{
            if(cl_id === each_cl.Id){
                selected_cl_rec.push({
                  ...each_cl,
                  policy_id: self.policy_detail.Id,
                  account: self.accId  
                });
            }
        })   
        //consele.log('selected_cl_rec=',JSON.stringify(selected_cl_rec));
        if(selected_cl_rec.length > 0) {
            if(selected_cl_rec[0].CL_Amount__c)
                selected_cl_rec[0].CL_Amount__c = selected_cl_rec[0].CL_Amount__c.replace(/\D/g,'');
            //consele.log('selected record=',JSON.stringify(selected_cl_rec));
            createOMBPInvoice({
                'json_ob':selected_cl_rec[0]
            }).then((result) => {
                //consele.log("invoice created with id=",result);
                this.clRecord = [];
                this.getCLList();
            }).catch(error => {
                this.show_checkbox_spinner = false;
                //consele.log('error in invoice creation', JSON.stringify(error));
                console.error('error in invoice creation', JSON.stringify(error));
            });
        }

    }catch(exception){
        //consele.log("Exception=",JSON.stringify(exception));
    }
        /*const fields = {};
        fields[CLA_ID_FIELD.fieldApiName] = cl_id;
        fields[CLA_STATUS_FIELD.fieldApiName] = 'Credit limit indication accepted';
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {    
                this.clRecord = [];
                this.getCLList()
            })
            .catch(error => {
                //consele.log('error in cla status', JSON.stringify(error));
                console.error('error in cl status', JSON.stringify(error));
            });*/
    }
    handleOpenCancelNotification(e) {
        /*var cl_id = e.currentTarget.dataset.id;
        let currentOpenTab = '';
        console.log('handleOpenCancelNotification id='+cl_id);
        console.log('domainBaseURL=',this.domainBaseURL);
        if(this.policy_type === 'SUP') {
            currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/CLACancelSUP?Id='+ cl_id;
        } else if(this.policy_type === 'OMBP') {
            currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/CLACancel?Id='+ cl_id;
        } else if(this.policy_type === 'SBP') {
            currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/CLACancelSBP?Id='+ cl_id;
        }    
        const urlWithParameters = currentOpenTab+'&renderAs=PDF';
        
        console.log('urlWithParameters...'+urlWithParameters);
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
            url: urlWithParameters
        }
        }, false);*/
        var link = e.currentTarget.dataset.link;
        console.log('link=',link);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
                attributes: {
                url: link
            }
        }, false);
    }
    handleOpenCLNotification(e){
        var link = e.currentTarget.dataset.link;
        console.log('link=',link);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
                attributes: {
                url: link
            }
        }, false);
    }
    getCLList() {
        var step1 = ['SO Process - O/S Online Policy CLA', 'AO Process – My O/S Job', 'AO Process - O/S CLA with Overdue Premium'];
        var step2 = ['Manual approval - O/S CLA (Await Credit Report)', 'Pre-approved limit – O/S CLA (Awaiting Credit Report)', 'Express Approval Module – O/S CLA (Awaiting Credit Report)'];
        var step3 = ['Manual approval - O/S CLA (Adq Info Rec’d)', 'Pre-approved limit – O/S CLA (Adq Info Rec’d)', 'Express Approval Module – O/S CLA (Adq Info Rec’d)', 'Manual approval - O/S CLA (Recommended to You)', 'Pre-approved limit - O/S CLA (For review/proceed)', 'Express Approval Module – O/S CLA (For review/proceed'];
        var step4 = ['Manual approval - O/S CLA (Under Clarification with credit agency)', 'Pre-approved limit - O/S CLA (Under Clarification with credit agency)', 'Express Approval Module –O/S CLA (Under Clarification with credit agency)', 'Manual approval - O/S CLA (Under Clarification with PH/exporter/buyer)', 'Pre-approved limit -O/S CLA (Under Clarification with PH/exporter/buyer)', 'Express Approval Module –O/S CLA (Under Clarification with PH/exporter/buyer)'];
        var step5 = ['CL_NEW (Credit Limit Approved)', 'CLI_NEW (Credit Limit Indication Approved)'];
        getCLListByPolicy({
            policy_id: this.policy_id
        })
            .then((result) => {
                // this.show_checkbox_spinner = false;
                // console.log("cl_list=", JSON.stringify(result));
                if (result.length > 0) {
                    this.show_cl_record = true;

                    let self = this;
                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                    var yyyy = today.getFullYear();
                    var show_rejection = false;
                    var approve_days = 0;
                    
                    today = yyyy + '-' + mm + '-' + dd;
                    result.map(function (each_cl, index) {
                        let classval = '';
                        let show_uplift = false;
                        let show_renew = false;
                        let show_cancel_cl = false;
                        let show_premium = false;
                        let show_cl_notification = false;
                        if (each_cl.CL_Progress_Step__c == 1)
                            classval = 'slds-progress-bar__value progress1';
                        else if (each_cl.CL_Progress_Step__c == 2)
                            classval = 'slds-progress-bar__value progress2';
                        else if (each_cl.CL_Progress_Step__c == 3)
                            classval = 'slds-progress-bar__value progress3';
                        else if (each_cl.CL_Progress_Step__c == 4)
                            classval = 'slds-progress-bar__value progress4';
                        else if (each_cl.CL_Progress_Step__c == 5)
                            classval = 'slds-progress-bar__value progress5';
                        
                        if (self.policy_type === 'SBP') {
                            if (each_cl.CL_Status__c === 'Valid') {
                                show_renew = false;
                                show_cancel_cl = true;
                            }                            
                        }
                        if (self.policy_type === 'SUP') {
                            if (each_cl.CL_Status__c === 'Valid') {
                                show_renew = false;
                                show_cancel_cl = true;
                            }                            
                        }
                        if((each_cl.Approve_Date__c) && (each_cl.CL_Application_Amount__c) && (each_cl.CL_Amount__c) && ((self.policy_type === 'SUP') || (self.policy_type === 'SBP'))){
                            approve_days = self.getDaysBetween(new Date(each_cl.Approve_Date__c), new Date(today));
                            let approved_percentage = (each_cl.CL_Amount__c/each_cl.CL_Application_Amount__c) * 100;
                            // console.log('within clgetlist',JSON.stringify(self.product_detail));
                            if(self.product_detail.Range_of_Acceptance_Rates__c){
                                let acceptance_rate = self.product_detail.Range_of_Acceptance_Rates__c;
                                console.log('acceptance_rate=',acceptance_rate);
                                show_rejection = ((approve_days < 14) && (approved_percentage < 60)) ? true:false;
                            }
                            show_cancel_cl = show_rejection ? false: true;
                            //consele.log('show_rejection=',show_rejection);
                        }

                        if ((each_cl.Expiry_Date__c) && (each_cl.CL_Status__c === 'Valid') && (self.policy_type === 'OMBP')) {
                            let date_dif = new Date(today.toString()).valueOf() <= new Date(each_cl.Expiry_Date__c.toString()).valueOf() ? self.getDaysBetween(new Date(each_cl.CL_Effective_Date__c), new Date(today)) : '';
                            if ((date_dif !== '') && (date_dif >= 1) && (date_dif <= 60) && (each_cl.CL_Status__c === 'Valid') && (self.policy_type === 'OMBP') && (!each_cl.Is_Uplifted__c)) {
                                show_uplift = true;
                            } else {
                                show_uplift = false;
                            }

                            if ((date_dif !== '') && (date_dif >= 61) && (date_dif <= 90) && (each_cl.CL_Status__c === 'Valid')) {
                                show_renew = true;
                            } else {
                                show_renew = false;
                            }

                        }

                        if(each_cl.CL_Approve_Letter__c) {
                            show_cl_notification = true;
                        }
                        
                        if (self.policy_type === 'OMBP') {
                            show_premium = true;
                        }
                        if (self.clrid === each_cl.Id) {
                            self.clRecord.push({
                                ...each_cl,
                                'isSectionOpen': true,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'uplift_rec_exist': false,
                                'reapply_rec_exist': false,
                                'show_cancel_cl': show_cancel_cl,
                                'show_premium': show_premium,
                                'show_rejection' : show_rejection,
                                'show_cl_notification': show_cl_notification
                            });
                        } else {
                            self.clRecord.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'uplift_rec_exist': false,
                                'reapply_rec_exist': false,
                                'show_cancel_cl': show_cancel_cl,
                                'show_premium': show_premium,
                                'show_rejection' : show_rejection,
                                'show_cl_notification': show_cl_notification
                            });
                        }
                        // valid Date wise filtering
                        // //consele.log('Expiry date=', each_cl.Expiry_Date__c);
                    });
                    let clrecord_list = [];
                    this.clRecord.map((each_rec)=>{
                        if (each_rec.CL_Application_Amount__c){
                            each_rec.CL_Application_Amount__c = each_rec.CL_Application_Amount__c.toLocaleString();
                        }
                        if (each_rec.CL_Amount__c){
                            each_rec.CL_Amount__c = each_rec.CL_Amount__c.toLocaleString();
                        }
                        if (each_rec.Premium__c){
                            each_rec.Premium__c = each_rec.Premium__c.toLocaleString();
                        }
                        
                        clrecord_list.push(each_rec);
                    });
                    this.clRecord = clrecord_list;
                    // this.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
                    this.clRecord.sort(function (a, b) {
                        if (b.Application_Date__c && a.Application_Date__c)            
                           return  b.Application_Date__c.localeCompare(a.Application_Date__c);
                    });
                    this.getCLAList();
                    // //consele.log("updated cl ist=", JSON.stringify(this.clRecord));
                } else {
                    this.getCLAList();
                    // this.show_cl_record = false;
                    // this.show_checkbox_spinner = false;
                }
            })
            .catch((error) => {

                //consele.log(error);
            });
    }
    getCLAList() {
        var step1 = ['SO Process - O/S Online Policy CLA', 'AO Process – My O/S Job', 'AO Process - O/S CLA with Overdue Premium'];
        var step2 = ['Manual approval - O/S CLA (Await Credit Report)', 'Pre-approved limit – O/S CLA (Awaiting Credit Report)', 'Express Approval Module – O/S CLA (Awaiting Credit Report)'];
        var step3 = ['Manual approval - O/S CLA (Adq Info Rec’d)', 'Pre-approved limit – O/S CLA (Adq Info Rec’d)', 'Express Approval Module – O/S CLA (Adq Info Rec’d)', 'Manual approval - O/S CLA (Recommended to You)', 'Pre-approved limit - O/S CLA (For review/proceed)', 'Express Approval Module – O/S CLA (For review/proceed'];
        var step4 = ['Manual approval - O/S CLA (Under Clarification with credit agency)', 'Pre-approved limit - O/S CLA (Under Clarification with credit agency)', 'Express Approval Module –O/S CLA (Under Clarification with credit agency)', 'Manual approval - O/S CLA (Under Clarification with PH/exporter/buyer)', 'Pre-approved limit -O/S CLA (Under Clarification with PH/exporter/buyer)', 'Express Approval Module –O/S CLA (Under Clarification with PH/exporter/buyer)'];
        var step5 = ['CL_NEW (Credit Limit Approved)', 'CLI_NEW (Credit Limit Indication Approved)'];
        var upliftedClaList = [];
        var reappliedClaList = [];
        getCLAListByPolicy({
            policy_id: this.policy_id
        })
            .then((result) => {
                this.show_checkbox_spinner = false;
                console.log("clA_list=", JSON.stringify(result));
                // claList = result;
                // claList.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
                // //consele.log("sorted CLA_list",JSON.stringify(claList));
                if (result.length > 0) {
                    this.show_cl_record = true;
                    // this.clRecord = [];
                    let self = this;
                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                    var yyyy = today.getFullYear();
                    today = yyyy + '-' + mm + '-' + dd;
                    result.map(function (each_cl, index) {
                        let classval = '';
                        let show_uplift = false;
                        let show_renew = false;
                        let show_ammend = false;
                        let show_cancel_application = false;
                        let show_cancel_cl = false;
                        let show_premium = false;
                        let show_indication_accept = false;
                        let show_cancel_letter_btn = false;

                        if (each_cl.CL_Progress_Step__c == 1)
                            classval = 'slds-progress-bar__value progress1';
                        else if (each_cl.CL_Progress_Step__c == 2)
                            classval = 'slds-progress-bar__value progress2';
                        else if (each_cl.CL_Progress_Step__c == 3)
                            classval = 'slds-progress-bar__value progress3';
                        else if (each_cl.CL_Progress_Step__c == 4)
                            classval = 'slds-progress-bar__value progress4';
                        else if (each_cl.CL_Progress_Step__c == 5)
                            classval = 'slds-progress-bar__value progress5';
                        /*if (step1.includes(each_cl.ECIC_Internal_System_Status__c)) {
                            classval = 'slds-progress-bar__value progress1';
                        } else if (step2.includes(each_cl.ECIC_Internal_System_Status__c)) {
                            classval = 'slds-progress-bar__value progress2';
                        } else if (step3.includes(each_cl.ECIC_Internal_System_Status__c)) {
                            classval = 'slds-progress-bar__value progress3';
                        } else if (step4.includes(each_cl.ECIC_Internal_System_Status__c)) {
                            classval = 'slds-progress-bar__value progress4';
                        } else if (step5.includes(each_cl.ECIC_Internal_System_Status__c)) {
                            classval = 'slds-progress-bar__value progress5';
                        }*/
                        /*if (each_cl.Expiry_Date__c) {
                            let date_dif = new Date(today.toString()).valueOf() <= new Date(each_cl.Expiry_Date__c.toString()).valueOf() ? self.getDaysBetween(new Date(today), new Date(each_cl.Expiry_Date__c)) : '';
                            if ((date_dif !== '') && (date_dif >= 1) && (date_dif <= 60)) {
                                show_uplift = true;
                            } else {
                                show_uplift = false;
                            }

                            if ((date_dif !== '') && (date_dif >= 61) && (date_dif <= 90)) {
                                show_renew = true;
                            } else {
                                show_renew = false;
                            }

                        }*/
                        if (self.policy_type === 'SBP') {
                            if (each_cl.CL_Status__c === 'Processing') {
                                show_ammend = true;
                                show_cancel_application = true;
                            } else if((each_cl.CL_Status__c === 'Invalid') && (each_cl.CLA_Cancel_Letter__c)) {
                                show_cancel_letter_btn = true;
                            }                            
                        } else if (self.policy_type === 'SUP') {
                            if (each_cl.CL_Status__c === 'Processing') {
                                show_ammend = true;
                                show_cancel_application = true;
                            } else if((each_cl.CL_Status__c == 'Invalid') && (each_cl.CLA_Cancel_Letter__c)) {
                                show_cancel_letter_btn = true;
                            }
                            
                        }
                        if (self.policy_type === 'OMBP') {
                            show_premium = true;
                            //consele.log('status=',each_cl.CL_Status__c);
                            if (each_cl.CL_Status__c.trim() === 'Pending for acceptance') {
                                show_indication_accept = true;
                                //consele.log('show_indication_accept=',show_indication_accept);
                            } else if((each_cl.CL_Status__c == 'Invalid') && (each_cl.CLA_Cancel_Letter__c)) {
                                show_cancel_letter_btn = true;
                            }
                        }
                        /*if (each_cl.Application_Type__c === 'Reapply') {
                            //consele.log('uplift CLA ID=', each_cl.Id);
                            reappliedClaList.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'show_ammend': show_ammend,
                                'show_cancel_application': show_cancel_application
                            });
                        } else*/ if (each_cl.Application_Type__c === 'Uplift'){
                            upliftedClaList.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'uplift_btn': show_uplift,
                                'renew_btn': show_renew,
                                'show_ammend': show_ammend,
                                'show_cancel_application': show_cancel_application,
                                'show_indication': show_indication_accept
                            });
                        } else {
                            if (self.clrid === each_cl.Id) {
                                self.clRecord.push({
                                    ...each_cl,
                                    'isSectionOpen': true,
                                    'iconName': 'utility:down',
                                    'class': classval,
                                    'uplift_btn': show_uplift,
                                    'renew_btn': show_renew,
                                    'uplift_rec_exist': false,
                                    'reapply_rec_exist': false,
                                    'show_ammend': show_ammend,
                                    'show_cancel_application': show_cancel_application,
                                    'show_premium': show_premium,
                                    'show_indication': show_indication_accept,
                                    'show_cancel_letter_btn': show_cancel_letter_btn
                                });
                            } else {
                                
                                self.clRecord.push({
                                    ...each_cl,
                                    'isSectionOpen': false,
                                    'iconName': 'utility:down',
                                    'class': classval,
                                    'uplift_btn': show_uplift,
                                    'renew_btn': show_renew,
                                    'uplift_rec_exist': false,
                                    'reapply_rec_exist': false,
                                    'show_ammend': show_ammend,
                                    'show_cancel_application': show_cancel_application,
                                    'show_premium': show_premium,
                                    'show_indication': show_indication_accept,
                                    'show_cancel_letter_btn': show_cancel_letter_btn
                                });
                            }
                        }
                    });
                    
                    upliftedClaList.map((each_uplifted_cla) => {                        
                        for (var i = 0; i < self.clRecord.length; i++) {
                            if (self.clRecord[i].Id === each_uplifted_cla.Credit_Limit_Id__c) {
                                self.clRecord[i].uplift_rec_exist = true;
                                if(each_uplifted_cla.CL_Application_Amount__c){
                                    each_uplifted_cla.CL_Application_Amount__c = each_uplifted_cla.CL_Application_Amount__c.toLocaleString();
                                }
                                if(each_uplifted_cla.CL_Amount__c){
                                    each_uplifted_cla.CL_Amount__c = each_uplifted_cla.CL_Amount__c.toLocaleString();
                                }
                                if(each_uplifted_cla.Premium__c){
                                    each_uplifted_cla.Premium__c = each_uplifted_cla.Premium__c.toLocaleString();
                                }
                                self.clRecord[i].uplifted_cla_rec = each_uplifted_cla;
                                
                            }
                            // //consele.log('Id=',JSON.stringify(temp_clRecord[i]));
                        }
                    });
                    /*reappliedClaList.map((each_reapplied_cla) => {
                        for (var i = 0; i < self.clRecord.length; i++) {
                            if (self.clRecord[i].Id === each_reapplied_cla.Credit_Limit_Id__c) {
                                self.clRecord[i].reapply_rec_exist = true;
                                if(each_reapplied_cla.CL_Application_Amount__c){
                                    each_reapplied_cla.CL_Application_Amount__c = each_reapplied_cla.CL_Application_Amount__c.toLocaleString();
                                }
                                if(each_reapplied_cla.CL_Amount__c){
                                    each_reapplied_cla.CL_Amount__c = each_reapplied_cla.CL_Amount__c.toLocaleString();
                                }
                                if(each_reapplied_cla.Premium__c){
                                    each_reapplied_cla.Premium__c = each_reapplied_cla.Premium__c.toLocaleString();
                                }
                                self.clRecord[i].reapplied_cla_rec = each_reapplied_cla;
                                
                            }
                            // //consele.log('Id=',JSON.stringify(temp_clRecord[i]));
                        }
                    })*/
                    let clrecord_list = [];
                    this.clRecord.map((each_rec)=>{
                        if (each_rec.CL_Application_Amount__c){
                            each_rec.CL_Application_Amount__c = each_rec.CL_Application_Amount__c.toLocaleString();
                        }
                        if (each_rec.CL_Amount__c){
                            each_rec.CL_Amount__c = each_rec.CL_Amount__c.toLocaleString();
                        }
                        if (each_rec.Premium__c){
                            each_rec.Premium__c = each_rec.Premium__c.toLocaleString();
                        }
                        
                        clrecord_list.push(each_rec);
                    });
                    this.clRecord = clrecord_list;
                    // this.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
                    this.clRecord.sort(function (a, b) {
                        if (b.Application_Date__c && a.Application_Date__c)            
                           return  b.Application_Date__c.localeCompare(a.Application_Date__c);
                    });

                    //consele.log("updated cl ist=", JSON.stringify(this.clRecord));
                } else {
                    // this.show_cl_record = false;
                    // this.show_checkbox_spinner = false;
                }
            })
            .catch((error) => {

                //consele.log(error);
            });

    }
    loadPromise() {
        this.clRecord = [];
        let self = this;
        var p1 = new Promise((resolve, reject) => {
            resolve(self.getCLList());
        });
        var p2 = new Promise((resolve, reject) => {
            resolve(self.getCLAList());
        });
        Promise.all([p1, p2]).then(() => {
            //consele.log('record size=', this.clRecord.length);
            this.show_checkbox_spinner = false;
        })


        /*.then(() => {
            //consele.log('promise call successful');
            this.show_checkbox_spinner = false;
            this.show_cl_record = true;
            //consele.log('record size=',self.clRecord.length);
            self.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
            //consele.log('cl list after sort',JSON.stringify(self.clRecord));
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.error({
                message: 'Error occured on promise',
                error
            });
        })*/
    }
    getDomainBaseURLJS(){
        getDomainBaseURL({}).then(data => {
            console.log('getDomainBaseURL success :'+JSON.stringify(data));
            this.domainBaseURL = data;

        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    getDaysBetween(first_day, second_day) {
        const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
        const diffDays = Math.round(Math.abs((first_day - second_day) / oneDay));
        // //consele.log('getDaysBetween diffDays=',diffDays);
        return diffDays;
    }
    getPolicy() {
        //consele.log("getPolicy method");
        getPolicyDetails({
            acc_id: this.accId
        })
            .then((result) => {
                console.log("Policy details=", JSON.stringify(result));
                this.policy_detail = result;
                this.account_name = result.Exporter__r.Name;
                this.policy_no = result.Legacy_Customer_Number__c;
                this.policy_type = result.Product__r.Name;
                if(result.Exporter__r.Limited_Access__c)
                this.allow_cl_create = false
                if((this.policy_type === 'SUP') || (this.policy_type === 'SBP')){
                    this.effective_or_issue_date = this.label.Issue
                } else {
                    this.effective_or_issue_date = this.label.Effective
                }
                
                //this.effective_date = result.Commencement_Date__c;
                this.policy_id = result.Id;
                this.available_credit_check_facility = result.Available_Credit_Check__c;
                this.callgetProductDetails();
                this.getCLList();
                this.getDomainBaseURLJS();
                // this.loadPromise();
            })
            .catch((error) => {

                //consele.log("error");
                console.error('e.name => ' + error.name);
                console.error('e.message => ' + error.message);
                console.error('e.stack => ' + error.stack);
                console.error(error);
            });
    }
    
    renderedCallback() {
        //consele.log("renderedCallback clapplicationrecord");
        //consele.log("UsrId ::======" + UsrId);
        if (!this.has_rendered) {
            this.has_rendered = true;

            getPolicyHolder({ 'user_id': UsrId })
                .then((result) => {
                    //consele.log('accountId===', result);
                    this.accId = result;
                    this.getPolicy();

                }).catch((error) => {

                    //consele.log(error);
                });

            /*if (this.clrid !== "") {
                //consele.log("New credit limit Id=",this.clrid);
                newclr({
                    clrid:this.clrid
                })
                .then((result) => {
                    //consele.log("result=",result); 
                    
                    if (result.length > 0) {
                        result.map(function(res,i){
                            //consele.log('res',res);
                            if (res.CL_Status__c === 'Valid'){
                                res["blue_status"]=false;
                                res["green_status"]=true;
                                res["red_status"]=false;
                                
                            } else if (res.CL_Status__c === 'Invalid'){
                                res["blue_status"]=false;
                                res["green_status"]=false;
                                res["red_status"]=true;
                                
                            } else {
                                res["blue_status"]=true;
                                res["green_status"]=false;
                                res["red_status"]=false;
                                
                            }
                        });
                        this.show_cl_record = true;
                        this.clRecord = result;
                    } else {
                        this.show_cl_record = false;
                        this.clRecord = [];
                    }
                              
                })
                .catch((error) => {
                    
                    //consele.log(error);
                });
            }*/
        }
    }
}
import { api,track, LightningElement } from 'lwc';
import UsrId from '@salesforce/user/Id';

import getPolicyHolder from '@salesforce/apex/ClPolicy.getPolicyHolder';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getDCLDCLAListByPolicy from '@salesforce/apex/CLApplicationRecord.getDCLDCLAListByPolicy';
import searchCL from '@salesforce/apex/CLApplicationRecord.getDiscretionaryCreditLimitRecord';

import Discretionary_Credit_Limit_Record from '@salesforce/label/c.Discretionary_Credit_Limit_Record';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Search_Discretionary_Credit_Limit_Record from '@salesforce/label/c.Search_Discretionary_Credit_Limit_Record';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Status from '@salesforce/label/c.Status';
import Credit_Limit_Issue_Date_from_to from '@salesforce/label/c.Credit_Limit_Issue_Date_from_to';
import to from '@salesforce/label/c.to';
import Search from '@salesforce/label/c.Search';
import Clear_Filters from '@salesforce/label/c.Clear_Filters';
import Ordered_by from '@salesforce/label/c.Ordered_by';
import Application_Date_CL from '@salesforce/label/c.Application_Date_CL';
import Credit_Limit_Issue_Date from '@salesforce/label/c.Credit_Limit_Issue_Date';
import CA_Ref_No from '@salesforce/label/c.CA_Ref_No';
import No_record_found from '@salesforce/label/c.No_record_found';
import Reference_Number from '@salesforce/label/c.Reference_Number';
import Buyer_Address from '@salesforce/label/c.Buyer_Address';
import Application_Completion_Date from '@salesforce/label/c.Application_Completion_Date';
import Cancellation_Date from '@salesforce/label/c.Cancellation_Date';
import Cancel_Discretionary_Credit_Limit from '@salesforce/label/c.Cancel_Discretionary_Credit_Limit';
import Update_Buyer_Name_and_or_Address from '@salesforce/label/c.Update_Buyer_Name_and_or_Address';


export default class DclApplicationRecord extends LightningElement {

    @track label ={
        Discretionary_Credit_Limit_Record,Company_Name,Policy_Number,Policy_Type,Search_Discretionary_Credit_Limit_Record,Buyer_Code,
        Buyer_Name,Status,Credit_Limit_Issue_Date_from_to,to,Search,Clear_Filters,Ordered_by,Application_Date_CL,Credit_Limit_Issue_Date,
        CA_Ref_No,No_record_found,Reference_Number,Buyer_Address,Application_Completion_Date,Cancellation_Date,Cancel_Discretionary_Credit_Limit,
        Update_Buyer_Name_and_or_Address
    }

    @api clrid;
    UsrId = UsrId;
    @track accId = '';
    @track policy_detail = [];
    @track account_name = '';
    @track policy_no = '';
    @track policy_type = '';
    @track policy_id = '';
    @track accId = '';
    @track has_rendered = false;
    @track show_checkbox_spinner = false;
    @track show_cl_record = false;
    @track clRecord = [];
    @track show_amend_dcl = false;
    @track dcl_info = [];
    @track search_status = '';
    @track search_buyer_code = '';
    @track search_buyer_name = '';
    @track search_from_date = '';
    @track search_to_date = '';
    @track dispaly_cancel_modal = false;

    @track StatusList = [
        { value: 'Valid', label: 'Valid' },
        { value: 'Invalid', label: 'Invalid' },
        { value: 'Processing', label: 'Processing' }
    ];
    @track application_text_class = 'blue_text';
    @track effective_date_text_class = 'black_text';


    handleStatusChange(e) {
        console.log(e.target.value);
        this.search_status = e.target.value;
    }
    handleBuyerCode(e) {
        this.search_buyer_code = e.target.value;
    }
    handleBuyerName(e) {
        this.search_buyer_name = e.target.value;
    }
    handleEffectiveDateFrom(e) {
        this.search_from_date = e.target.value;
    }
    handleEffectiveDateTo(e) {
        this.search_to_date = e.target.value;
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
      
    handleApplicationDateSort(e) {
        console.log('handleApplicationDateSort');
        let cl_rec = this.clRecord;
        this.clRecord = [];
        // cl_rec.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
        cl_rec.sort(this.sortByApplicationDate());
        this.clRecord = cl_rec;
        this.application_text_class = 'blue_text';
        this.effective_date_text_class = 'black_text';
    }
    handleEffectiveDateSort(e) {
        let cl_rec = this.clRecord;
        this.clRecord = [];
        
        cl_rec.sort(this.sortByEffectiveDate());
        this.clRecord = cl_rec;  
        this.application_text_class = 'black_text';
        this.effective_date_text_class = 'blue_text';      
    }
    handleSearch(e) {
        this.show_checkbox_spinner = true;
        console.log("handleSearch");
        console.log("this.search_buyer_code=" + this.search_buyer_code);
        console.log("this.search_buyer_name=" + this.search_buyer_name);
        console.log("this.search_status=" + this.search_status);
        console.log("this.search_from_date=" + this.search_from_date);
        console.log("this.search_to_date=" + this.search_to_date);
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
                console.log("result=", JSON.stringify(result));
                console.log('cla length=',result.claList.length);
                console.log('cl length=',result.clList.length);
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
                    console.log('search result=',JSON.stringify(result));
                    clList.map(function (each_cl, index) {
                        let classval = '';
                        
                        let show_cancel_cl = false;
                        /*if (each_cl.CL_Status__c === 'Processing') {
                            classval = 'slds-progress-bar__value progress3';

                        } else if (each_cl.CL_Status__c === 'Valid') {
                            classval = 'slds-progress-bar__value progress5';

                        } else {
                            classval = 'slds-progress-bar__value progress2';

                        }*/
                        console.log('each_cl',JSON.stringify(each_cl));
                        try{
                            let is_amend = false;
                            let is_cancelable = false;
                            if ((each_cl.CL_Status__c === 'Valid') || (each_cl.CL_Status__c === 'Accepted')){
                                is_amend = true;
                                is_cancelable = true;
                            }
                            self.clRecord.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'is_amend': is_amend,                                
                                'is_cancelable': is_cancelable,
                                'record_type':'Credit_Limit__c'
                                
                            });
                        // valid Date wise filtering  
                        }catch(exception){
                            console.log('exception',JSON.stringify(exception));
                            console.error('exception',JSON.stringify(exception));
                        }                      
                    });
                    //------------
                    console.log('after cl and before cla');
                    claList.map(function (each_cl, index) {
                        let classval = '';
                        
                        
                            //'show_cancel_application': show_cancel_application
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
                            let is_amend = false;
                            if ((each_cl.CL_Status__c.trim() === 'Processing')){
                                is_amend = true;                                
                            }
                        
                                                    
                            self.clRecord.push({
                                ...each_cl,
                                'isSectionOpen': false,
                                'iconName': 'utility:down',
                                'class': classval,
                                'is_amend': is_amend,
                                'is_cancelable':false,
                                'record_type':'Credit_Limit_Application__c'
                            });                            
                        
                    });
                    console.log('after cl and cla');
                    
                    
                    self.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
                    //---------------
                    this.show_cl_record = true;
                    
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
                console.log('error:', JSON.stringify(error));
                console.error('error:', JSON.stringify(error));
            });
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
        this.callgetDCLDCLAListByPolicy();
    }

    handleDisplayamenddclmodal(e){
        this.show_amend_dcl = false;
    }
    handleDisplayCancelmodal(e) {
        this.dispaly_cancel_modal = false;
    }
    handleOpenDCLCancel(e) {
        let id = e.currentTarget.dataset.id;
        let self = this;
        console.log('selected id=',id);
        this.clRecord.map((each_cl) => {
            if (id === each_cl.Id) {
                console.log('each_cl',JSON.stringify(each_cl));
                self.dcl_info = each_cl;
            }
        });  
        this.dispaly_cancel_modal = true;
    }
    
    openAmendDCLModal(e) {
        let id = e.currentTarget.dataset.id;
        let self = this;
        console.log('selected id=',id);
        this.clRecord.map((each_cl) => {
            if (id === each_cl.Id) {
                console.log('each_cl',JSON.stringify(each_cl));
                self.dcl_info = each_cl;
            }
        });        
        this.show_amend_dcl = true;
    }

    expandHandler(event) {
        try{
        console.log('expandHandler=', event.currentTarget.id);
        console.log('Before update clRecord=',JSON.stringify(this.clRecord));
        let id = event.currentTarget.id + ""
        id = id.split("-")[0];
        let temp_clRecord = this.clRecord;
        this.clRecord = [];
        
        temp_clRecord.forEach((cl) => {
            cl.isSectionOpen = id === cl.Id ? !cl.isSectionOpen : cl.isSectionOpen
            cl.iconName = id === cl.Id && cl.isSectionOpen ? 'utility:up' : 'utility:down'
            //:'utility:down',
        });
        this.clRecord = temp_clRecord;
        }catch(error){
            console.log('error=',JSON.stringify(error));
            console.error('error=',JSON.stringify(error));
        }
        console.log('clRecord=',JSON.stringify(this.clRecord));

    }
    getPolicy() {
        getPolicyDetails({
            acc_id: this.accId
        })
            .then((result) => {
                console.log("Policy details=", JSON.stringify(result));
                this.policy_detail = result;
                this.account_name = result.Exporter__r.Name;
                this.policy_no = result.Legacy_Customer_Number__c;
                this.policy_type = result.Product__r.Name;
                this.policy_id = result.Id;
                this.callgetDCLDCLAListByPolicy();
            })
            .catch((error) => {
                console.error(error);
            });
    }
    callgetDCLDCLAListByPolicy(){
        getDCLDCLAListByPolicy({
            policy_id: this.policy_id
        })
        .then((result) => {
            console.log('result=',JSON.stringify(result));
            let claList = result.claList;
            let clList = result.clList;
            this.show_checkbox_spinner = false;
            this.clRecord = [];
            let self = this;
            if ((claList.length > 0) || (clList.length > 0)) {
                this.clRecord = [];
                console.log('search result=',JSON.stringify(result));
                clList.map(function (each_cl, index) {
                    let is_amend = false;
                    let is_cancelable = false;
                    if ((each_cl.CL_Status__c === 'Valid') || (each_cl.CL_Status__c === 'Accepted')){
                        is_amend = true;
                        is_cancelable = true;
                    }
                    self.clRecord.push({
                        ...each_cl,
                        'isSectionOpen': false,
                        'iconName': 'utility:down',
                        'is_amend': is_amend,
                        'is_cancelable': is_cancelable,
                        'record_type':'Credit_Limit__c'
                        // 'class': classval,
                        // 'uplift_btn': show_uplift,
                        // 'renew_btn': show_renew,
                        // 'uplift_rec_exist': false,
                        // 'reapply_rec_exist': false,
                        // 'show_cancel_cl': show_cancel_cl
                        
                    });
                });
                claList.map(function (each_cl, index) {
                    let is_amend = false;                    
                        if ((each_cl.CL_Status__c.trim() === 'Processing')){
                            is_amend = true;
                        }
                    if(self.clrid === each_cl.Id){
                        
                        self.clRecord.push({
                            ...each_cl,
                            'isSectionOpen': true,
                            'iconName': 'utility:down',
                            'is_amend': is_amend,
                            'is_cancelable': false,
                            'record_type':'Credit_Limit_Application__c'
                        });
                    } else {
                        self.clRecord.push({
                            ...each_cl,
                            'isSectionOpen': false,
                            'iconName': 'utility:down',
                            'is_amend': is_amend,
                            'is_cancelable': false
                        });
                    }
                    
                });
                this.show_cl_record = true;
                self.clRecord.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));
            } else {
                this.show_checkbox_spinner = false;
                this.show_cl_record = false;
                this.clRecord = [];
            }
        })
        .catch((error) => {
            console.log('error=',error);
        });
    }
    renderedCallback(){
        if (!this.has_rendered) {
            this.has_rendered = true;
            getPolicyHolder({ 'user_id': UsrId })
                .then((result) => {
                    console.log('accountId===', result);
                    this.accId = result;
                    this.getPolicy();
                    

                }).catch((error) => {

                    console.log(error);
                });
        }
    }
}
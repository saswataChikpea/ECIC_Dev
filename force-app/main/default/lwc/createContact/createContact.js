import { LightningElement,track,api } from 'lwc';
import { createRecord,updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import sendEmailSME from '@salesforce/apex/SendContactCreateEmailToSME.sendEmailSME';
// import UsrId from '@salesforce/user/Id';

export default class CreateContact extends LightningElement {
    //onclosecreatecontactmodal
    @api accountid;
    @track first_name = "";
    @track last_name = "";
    @track phone = "";
    @track email = "";
    @track position = "";
    @track refresh_contact = false;
    @track show_confirmation = false;
    @track createmsg = '';
    @track error_msg = '';

    // UsrId = UsrId;
    handleFirstName(e) {
        this.first_name = e.target.value;
    }
    handleLastName(e) {
        this.last_name = e.target.value;
    }
    handleEmail(e) {
        this.email = e.target.value;
    }
    handlePhone(e) {
        this.phone = e.target.value;
    }
    handlePosition(e) {
        this.position = e.target.value;
    }
    checkValidation() {
        let is_valid = true;
        // let validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        let validRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if((this.first_name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.first_name))) {
            this.error_msg = 'Invalid First Name';
            is_valid = false;
        }
        if((this.last_name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.last_name))) {
            this.error_msg = 'Invalid Last Name';
            is_valid = false;
        }
        if(!validRegex.test(this.email)) {
            this.error_msg = 'Invalid Email Address';
            is_valid = false;
        }
        if ((this.phone === '') || (this.phone === null) || (this.phone.length < 6)) {
            this.error_msg = 'Invalid Contact Number.';
            is_valid = false;
        }
        if((this.position.length < 3) || (/[^a-zA-Z\-\/ /./]/.test(this.position))) {
            this.error_msg = 'Invalid Title';
            is_valid = false;
        }
        return is_valid;
    }
    handleSubmit(e){
        // var fields = {
        //     'AccountId': this.accountid,
        //     'FirstName': this.first_name,
        //     'LastName': this.last_name,
        //     'Phone': this.phone,
        //     'Email': this.email,
        //     'Position__c': this.position
        // };
        let is_valid = this.checkValidation();

        if (is_valid) {
        var fields = {
            'Name' : this.first_name,
            'Contact_Last_Name__c' : this.last_name, 
            'Account__c' : this.accountid, 
            'Contact_No__c' : this.phone,
            'Position__c' : this.position,
            'Email__c': this.email,            
        };
        console.log("updated fields=" + JSON.stringify(fields));
        var objRecordInput = { 'apiName': 'Custom_Contact__c', fields };
        console.log("contact objRecordInput=" + JSON.stringify(objRecordInput));
        createRecord(objRecordInput).then(response => {
            console.log('contact created with Id: ' + response.id);
            //this.loading = false;
            this.refresh_contact=true;
            this.show_confirmation = true;
            this.createmsg = 'Contact created.';
            // this.closeModal();
            // this.callsendEmailSME(response.id);
            
            
        }).catch(error => {
            this.show_confirmation = true;
            this.createmsg = 'Some error has occurred. Please try later.'
            console.log('contact create Error: ' + JSON.stringify(error));
            console.error(error.toString(), JSON.stringify(error));
        });
        } else {
            this.showToast(this.error_msg);
        }
    }
    // callsendEmailSME(cont_id){
    //     sendEmailSME({
    //         'templateName':'Contact_Person_Updated',
    //         'whatId':cont_id,
    //         'userId':UsrId
    //     }).then(response => {
    //         console.log('sendEmailSME response=',response);
    //     }).catch(error => {
    //         console.log('Error in sendEmailSME',JSON.stringify(error));
    //     });
    // }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    closeModal(e) {
        let detail = {
            refresh: this.refresh_contact
        }
        const closeEvent = new CustomEvent("closecreatecontactmodal", {
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
}
import { LightningElement,api, track } from 'lwc';
import CL_ID_FIELD from '@salesforce/schema/Credit_Limit__c.Id';
import CL_REJECT_REQUEST_DATE_FIELD from '@salesforce/schema/Credit_Limit__c.Reject_Request_Date__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CLA_STATUS_FIELD from '@salesforce/schema/Credit_Limit_Application__c.CL_Status__c';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import cancelCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.cancelCLApplicationAura';

export default class ClRejectCreditLimit extends LightningElement {
    @api clid;
    @api clapprovedate;
    @track reject_date = '';
    closeModal(){
        // alert("closemodal");
        let detail = {
            type:"Reject"
        }
        const closeEvent = new CustomEvent("reject",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
    handleRejectionDate(e){
        this.reject_date = e.target.value;
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    callcancelCLApplicationAura(){
        cancelCLApplicationAura({
            'clApplicationID':this.clid, 
            'reqType':'cl_reject'
        }).then((result) => {
                //console.log('cancelCLApplicationAura response=',result);           
            })
            .catch((error) => {
                //console.log("error in cancelCLApplicationAura", JSON.stringify(error));
                console.error("error in cancelCLApplicationAura", JSON.stringify(error));
            });
    }
    checkValidation(){
        var today = Date.parse(new Date());
        var app_date = Date.parse(this.clapprovedate);
        var rej_date = Date.parse(this.reject_date);
        //console.log('today=',today);
        //console.log('app_date=',app_date);
        //console.log('rej_date=',rej_date);
        if(rej_date <= today && rej_date >= app_date)
            return true;
        else {
            this.showToast('Invalid rejection date.');
            return false;
        }
    }
    handleSubmit(e) {
        //console.log('reject cl=',this.clid);
        //console.log('reject_date=',this.reject_date);
        if(this.checkValidation()) {
            const fields = {};
            fields[CL_ID_FIELD.fieldApiName] = this.clid;
            fields[CL_REJECT_REQUEST_DATE_FIELD.fieldApiName] = this.reject_date;
            const recordInput = { fields };
                updateRecord(recordInput)
                    .then(() => {
                        //console.log('CL updated');
                        // this.callcancelCLApplicationAura();
                        this.closeModal();
                    })
                    .catch(error => {
                        //console.log('error in account update', error.body.message);
                    });            
        }
        
    }
}
import { api, LightningElement, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cancelCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.cancelCLApplicationAura';
import getCreditLimitRecordByID from '@salesforce/apex/CLApplicationRecord.getCreditLimitRecordByID';
import CalculateMLSBP from '@salesforce/apex/CLApiHandler.CalculateMLSBP';
import CL_ID_FIELD from '@salesforce/schema/Credit_Limit__c.Id';
import CL_STATUS_FIELD from '@salesforce/schema/Credit_Limit__c.CL_Status__c';
import sendEmailAccount from '@salesforce/apex/SendEmailApex.sendEmailAccount';

export default class ClCancelAPICall extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isLoading;
    retrievedRecordId = false;
    @track clRecord = [];
    // renderedCallback() {
    //     if (!this.retrievedRecordId && this.recordId) {
    //         this.isLoading = false;
    //         this.retrievedRecordId = true; // Escape case from recursion
    //         console.log('Found recordId: ' + this.recordId);

    //         // Execute some function or backend controller call that needs the recordId
    //     }
    // }
    @api
    invoke(){
        this.isLoading=true;
        //alert('Invoke called!!!');
        console.log('Inside Invoke recordId:' +this.recordId);        
        this.callgetCreditLimitRecordByID();
        // this.callcancelCLApplicationAura();
    }

    callgetCreditLimitRecordByID() {
        getCreditLimitRecordByID({
            'cl_id':this.recordId
        }).then((response)=>{
            this.clRecord = response;
            console.log('clRecord',JSON.stringify(this.clRecord));
        }).catch(error => {
            console.log('error in getCreditLimitRecordByID', JSON.stringify(error));
            console.error('error in getCreditLimitRecordByID', JSON.stringify(error));
        });
    }

    callcancelCLApplicationAura() {
        console.log('callcancelCLApplicationAura');
        cancelCLApplicationAura({
            'clApplicationID':this.recordId,
            'reqType':'cl_cancel'
        }).then((response) => {    
                console.log(response);
                this.isLoading = !this.isLoading;
                let res_json = JSON.parse(response);
                console.log('res_json.rtn_code==',res_json.rtn_code);
                this.callsendEmailAccount();
                if (res_json.rtn_code == 1) {
                    if ((res_json.meta_data.sts == 'S') || (res_json.meta_data.sts == 's')) {
                        const fields = {};
                        fields[CL_ID_FIELD.fieldApiName] = this.recordId;
                        fields[CL_STATUS_FIELD.fieldApiName] = 'Invalid';
                        const recordInput = { fields };
                        updateRecord(recordInput)
                            .then(() => {
                                // this.callsendEmailAccount();
                                if(this.clRecord.Policy__r.Product__r.Name == 'SBP'){
                                    this.callCalculateMLSBP();
                                }  
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Success',
                                        message: 'Credit Limit cancelled successfully',
                                        // mode : 'sticky',
                                        variant: 'success'
                                    })
                                );
                                console.log('Status updated');
                            })
                            .catch(error => {
                                console.log('error in cla status', JSON.stringify(error));
                                console.error('error in cl status', JSON.stringify(error));
                            });
                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Failed to cancel Credit Limit',
                            // mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }
            })
            .catch(error => {
                this.isLoading = !this.isLoading;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to cancel Credit Limit',
                        // mode : 'sticky',
                        variant: 'error'
                    })
                );
                console.log('error in cancelCLApplicationAura', JSON.stringify(error));
                console.error('error in cancelCLApplicationAura', JSON.stringify(error));
            });
    }
    callsendEmailAccount() {
        console.log('callsendEmailAccount whatId=',this.recordId);
        
        sendEmailAccount({
            'accId':this.clRecord.Exporter__c,
            'whatId':this.recordId,
            'templateName':'H1_CL_Cancellation',
            'ccSME':false,
            'attachmentIds':null,
            'runtimeAttachmentUrls':null
        }).then((response)=>{
            console.log('sendEmailAccount response',response);
        }).catch((error)=>{
            console.log('error:',JSON.stringify(error));
        })
    }
    callCalculateMLSBP() {
        CalculateMLSBP({
            policy_id:this.clRecord.Policy__c,
            accId:this.clRecord.Exporter__c
        }).then().catch((error)=>{
            console.log('error:',JSON.stringify(error));
        })
    }
}
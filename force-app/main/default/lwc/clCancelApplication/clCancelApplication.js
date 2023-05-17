import { LightningElement,api, track } from 'lwc';
import CLA_ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import CLA_STATUS_FIELD from '@salesforce/schema/Credit_Limit_Application__c.CL_Status__c';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import cancelCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.cancelCLApplicationAura';

import Cancel_Credit_Limit_Application from '@salesforce/label/c.Cancel_Credit_Limit_Application';
import Please_confirm_if_you_would_like_to_cancel_this_credit_limit_application from '@salesforce/label/c.Please_confirm_if_you_would_like_to_cancel_this_credit_limit_application';
import The_Credit_Check_Facility_has_been_already_deducted_and_will_not_be_reinstated from '@salesforce/label/c.The_Credit_Check_Facility_has_been_already_deducted_and_will_not_be_reinstated';
import Submit from '@salesforce/label/c.Submit';


export default class ClCancelApplication extends LightningElement {

    @track label = {
        Cancel_Credit_Limit_Application,Please_confirm_if_you_would_like_to_cancel_this_credit_limit_application,
        The_Credit_Check_Facility_has_been_already_deducted_and_will_not_be_reinstated,Submit
    }

    @api clid;
    closeModal(){
        // alert("closemodal");
        let detail = {
            type:"cancel"
        }
        const closeEvent = new CustomEvent("cancelcla",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
    callcancelCLApplicationAura() {
        cancelCLApplicationAura({
            'clApplicationID':this.clid,
            'reqType':'cla_cancel'
        }).then((response) => {    
                console.log(response);

                let res_json = JSON.parse(response);
                console.log('res_json.rtn_code=',res_json.rtn_code);
                if (res_json.rtn_code == 1) {
                    if ((res_json.meta_data.sts == 'S') || (res_json.meta_data.sts == 's')) {
                        const fields = {};
                        fields[CLA_ID_FIELD.fieldApiName] = this.clid;
                        fields[CLA_STATUS_FIELD.fieldApiName] = 'Invalid';
                        const recordInput = { fields };
                        updateRecord(recordInput)
                            .then(() => {  
                                console.log('Status updated');
                            })
                            .catch(error => {
                                console.log('error in cla status', JSON.stringify(error));
                                console.error('error in cl status', JSON.stringify(error));
                            });
                    }
                }
            })
            .catch(error => {
                console.log('error in cancelCLApplicationAura', JSON.stringify(error));
                console.error('error in cancelCLApplicationAura', JSON.stringify(error));
            });
    }
    handleSubmit(e) {
        console.log('cancel cla=',this.clid);
        const fields = {};
        fields[CLA_ID_FIELD.fieldApiName] = this.clid;
        fields[CLA_STATUS_FIELD.fieldApiName] = 'Request for Cancellation';
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {  
                // this.callcancelCLApplicationAura();
                this.closeModal();
            })
            .catch(error => {
                console.log('error in cla status', JSON.stringify(error));
                console.error('error in cl status', JSON.stringify(error));
            });
    }
}
import { api, LightningElement, track } from 'lwc';
import cancelCLApplicationAura from '@salesforce/apex/ECIC_CL_API_Methods.cancelCLApplicationAura';

import Cancel_Discretionary_Credit_Limit from '@salesforce/label/c.Cancel_Discretionary_Credit_Limit';
import Please_confirm_if_you_would_like_to_cancel_this_discretionary_credit_limit from '@salesforce/label/c.Please_confirm_if_you_would_like_to_cancel_this_discretionary_credit_limit';
import Submit from '@salesforce/label/c.Submit';


export default class DclCancel extends LightningElement {

    @track label = {
        Cancel_Discretionary_Credit_Limit,Please_confirm_if_you_would_like_to_cancel_this_discretionary_credit_limit,
        Submit
    }

    @api dcldetail = [];
    closeModal(){
        // alert("closemodal");
        let detail = {
            type:"cancel"
        }
        const closeEvent = new CustomEvent("displaycancelchange",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
    callcancelCLApplicationAura() {
        cancelCLApplicationAura({
            'clApplicationID':this.dcldetail.Id,
            'reqType':'dcl_cancel'
        }).then((response) => {    
                console.log(response);

                let res_json = JSON.parse(response);
                console.log('res_json.rtn_code=',res_json.rtn_code);
                if (res_json.rtn_code == 1) {
                    if ((res_json.meta_data.sts == 'S') || (res_json.meta_data.sts == 's')) {
                        const fields = {};
                        fields[CLA_ID_FIELD.fieldApiName] = this.dcldetail.Id;
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
        this.callcancelCLApplicationAura();
        this.closeModal();
    }
    renderedCallback() {
        // console.log('dcldetail=',JSON.stringify(this.dcldetail));
    }
}
import { api, LightningElement,track } from 'lwc';
import createTask from '@salesforce/apex/TaskManagement.createTask';
import CL_ID_FIELD from '@salesforce/schema/Credit_Limit__c.Id';

import Cancel_Credit_Limit from '@salesforce/label/c.Cancel_Credit_Limit';
import Please_specify_the_reason_of_cancelling_this_credit_limit from '@salesforce/label/c.Please_specify_the_reason_of_cancelling_this_credit_limit';
import Other_reason_s from '@salesforce/label/c.Other_reason_s';
import Submit from '@salesforce/label/c.Submit';
import No_future_business_with_the_buyer from '@salesforce/label/c.No_future_business_with_the_buyer';
import No_future_business_with_the_buyer_on_credit_terms from '@salesforce/label/c.No_future_business_with_the_buyer_on_credit_terms';
import Adverse_information_was_noted_on_the_buyer from '@salesforce/label/c.Adverse_information_was_noted_on_the_buyer';
import Others from '@salesforce/label/c.Others';


export default class ClCancelCreditLimit extends LightningElement {

    @track label = {
        Cancel_Credit_Limit,Please_specify_the_reason_of_cancelling_this_credit_limit,Other_reason_s,Submit,
        No_future_business_with_the_buyer,No_future_business_with_the_buyer_on_credit_terms,Adverse_information_was_noted_on_the_buyer,
        Others
    }

    @api clid;
    @track cancel_options = [
        { label: this.label.No_future_business_with_the_buyer, value: 'No future business with the buyer'},
        { label: this.label.No_future_business_with_the_buyer_on_credit_terms, value: 'No future business with the buyer on credit terms'},
        { label: this.label.Adverse_information_was_noted_on_the_buyer, value: 'Adverse information was noted on the buyer'},
        { label: this.label.Others, value: 'Others'}        
    ];
    @track cancel_options_val;
    @track cancel_reason;
    handleCancelOptionChange(e) {
        console.log(e.target.value);
        this.cancel_options_val = e.target.value;
    }
    handleReasonText(e) {
        // console.log(e.target.value);
        this.cancel_reason = e.target.value;
    }
    closeModal(){
        let detail = {
            type:"cancel"
        }
        const closeEvent = new CustomEvent("cancelcl",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
    handleSubmit(e) {
        console.log('handleSubmit');
        console.log('clid=',this.clid);
        try{
            createTask({ 'subject': 'Cancel Credit Limit Request',
                'description':this.cancel_options_val + ', ' + this.cancel_reason,
                'priority':'High',
                'type':'',
                'assignedTo':'',
                'relatedID':this.clid
            }).then((result) => {
                console.log('cl cancel',result);
                this.closeModal();

                }).catch((error) => {
                    console.log(error);
                });
            }catch(exception){
                console.log('Exception',JSON.stringify(exception));
            }
        
    }
    renderedCallback(){
        console.log('clid=',this.clid);
    }
}
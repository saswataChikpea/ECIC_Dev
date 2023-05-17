import { api, LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DESCRIPTION_FIELD from '@salesforce/schema/Account.Description';
import ID_FIELD from '@salesforce/schema/Account.Id';
import createQuote from '@salesforce/apex/QuotationManager.createQuote'
import getQuotation from '@salesforce/apex/OnboardingCreateSiteUser.getQuotation'
import applyQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyQuoteAura'

export default class CreateQuoteAction extends LightningElement {
    @api recordId;
    @api invoke() {
        console.log("Inside create quote action.");
        console.log("Record Id is " + this.recordId);
        createQuote({ id: this.recordId }).then(data => {
            console.log('createQuote response success :' + JSON.stringify(data))
            try {
                //now create account and dispatchhandlepagechange from create account method
                console.log(' ====> createQuote')
                if (data.statusCode == 100) {
                    console.log('createQuote success in salesforce')// now need to call APPly quotation API
                    // alert('You have created a quote successfully.')
                    // this.prepareQuoteAPI(data.quotations[0])//after ecic
                    this.showToast("Quotation created successfully", 'Success', 'success')
                }
                //window.location.href = data.siteUrl
            } catch (error) {
                console.error('Error: 01 Cannot create Quote : ');
                console.error('Error: 01 Cannot create Quote : ' + JSON.stringify(error));
                this.error = 'Sign up failed'
                if (error.body) {
                    if (Array.isArray(error.body)) {
                        this.exceptionDetail = error.body.map(e => e.message).join(', ')
                    } else if (typeof error.body.message === 'string') {
                        this.exceptionDetail = error.body.message
                    }
                } else {
                    this.exceptionDetail = error
                }
            }
        }).catch(error => {
            console.error('Error: 02 Cannot create Quote : ' + error);
            console.error('Error: 02 Cannot create Quote : ' + JSON.stringify(error));
            this.error = 'Sign up failed'
            if (error.body) {
                if (Array.isArray(error.body)) {
                    this.exceptionDetail = error.body.map(e => e.message).join(', ')
                } else if (typeof error.body.message === 'string') {
                    this.exceptionDetail = error.body.message
                }
            } else {
                this.exceptionDetail = error
            }
        });
    }
    prepareQuoteAPI(quotation) {
        getQuotation({ Id: quotation.Id }).then(data => {
            console.log('getQuotation::', JSON.stringify(data));
            let req = {
                ACCOUNT_ID: data.Account__r.Id,
                PROPOSAL_ID: data.Proposal__r.Master_Proposal__c ? data.Proposal__r.Master_Proposal__c : data.Proposal__r.Id,
                QUOTATION_ID: data.Id,
                CUS_NO: data.Proposal__r.CUS_NO__c,
                PCY_TYPE: data.Proposal__r.Policy_Type__c,
                ISS_DATE: data.Issue_Date__c,
                ACC_DATE: this.today,//********Acceptence Date before acceptance or after */
                STS: "A",

                QUO_EXP_DATE: data.Expiry_Date__c
            }
            console.log("Call quotation API::", JSON.stringify(req));


            applyQuoteAura({ jsonObject: req }).then(res => {
                let data = JSON.parse(res)
                console.log("applyQuoteAura success::", data);
                let temp = {}
                if (data.rtn_code && data.rtn_code == '1') {
                    // this.callCreatePolicy()
                    this.showToast("Quotation created successfully", 'Success', 'success')
                } else {
                    // this.showToast("Something went wrong. Ple")
                    this.showToast('Something went wrong while creating quotation. Please try again later.')
                }
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":null}

            }).catch(error => {
                // this.showToast("Something went wrong creating proposal. Please try again")
                this.showToast('Something went wrong while creating quotation. Please try again later.')
                console.error('Error: 03 Cannot create quotation : ' + error);
                console.error('Error: 03 Cannot create quotation : ' + JSON.stringify(error));
                if (error.body) {
                    if (Array.isArray(error.body)) {
                        this.exceptionDetail = error.body.map(e => e.message).join(', ')
                    } else if (typeof error.body.message === 'string') {
                        this.exceptionDetail = error.body.message
                    }
                } else {
                    this.exceptionDetail = error
                }
            });
        })
    }
    get today() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    showToast = (message, title, variant) => {
        try {
            if (this.isLocal) {
                alert(message || "")
                return
            }
            const toastEvent = new ShowToastEvent({
                title: title || 'Error!',
                message: message || "",
                variant: variant || 'error'
            })
            this.dispatchEvent(toastEvent)
        } catch (error) {
            console.error(error)
        }

    }
}
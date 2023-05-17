/* eslint-disable  no-console */
import { api, LightningElement, track } from 'lwc';

export default class ClContainer extends LightningElement {
    @track showApplynewOMBP = false;
    @track showApplynewSBP = false;
    @track showApplynewSUP = false;
    @track showApplicationRecord = true;
    @track showCLApplicationConfirmation = false;
    @track showCLApplicationConfirmationSBP = false;
    @track showCLApplicationConfirmationSUP = false;
    @track showAmmendSBP = false;
    @track showAmmendSUP = false;
    @track dashBoard = false;
    @track showApplicationDraft = false;
    @api cl_fields = [];
    @api clConfirmationPageData = [];
    @api clConfirmationApiData = [];
    @track clId = "";
    @track claId = '';
    @track redirectApplicationRecord = false;
    @api policyInfo = [];
    @track is_first_load = false;
    handleChange(e) {
        console.log("e.detail.Pagename=",e.detail.Pagename);        
        if (e.detail.Pagename === "ApplynewOMBP" ){
            this.policyInfo = e.detail;
            this.showApplynewOMBP = true;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showAmmendSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "ApplynewSBP" ){
            this.policyInfo = e.detail;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = true;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "ApplynewSUP" ){
            this.policyInfo = e.detail;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = true;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if(e.detail.Pagename === "ApplicationConfirmationSBP") {
            this.policyInfo = e.detail.policy_detail;
            this.showCLApplicationConfirmation = false;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.cl_fields = e.detail.cl_fields;
            // this.clConfirmationPageData = e.detail.page_fields;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = true;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if(e.detail.Pagename === "ApplicationConfirmationSUP") {
            this.policyInfo = e.detail.policy_detail;
            this.showCLApplicationConfirmation = false;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.cl_fields = e.detail.cl_fields;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = true;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if(e.detail.Pagename === "ApplicationConfirmation") {
            this.policyInfo = e.detail.policy_detail;
            this.showCLApplicationConfirmation = true;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.cl_fields = e.detail.cl_fields;
            // this.clConfirmationPageData = e.detail.page_fields;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "RedirectCLARecord"){
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = true;
            this.clId = e.detail.cl_id;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "AmmendSBP"){
            this.claId = e.detail.cla_id;
            this.policyInfo = e.detail.policy_detail;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.claId = e.detail.cla_id;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = true;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "AmmendSUP"){
            this.claId = e.detail.cla_id;
            this.policyInfo = e.detail.policy_detail;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.claId = e.detail.cla_id;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = true;
            this.showApplicationDraft = false;
        } else if (e.detail.Pagename === "ApplicationDraft"){
            this.claId = e.detail.cla_id;
            this.policyInfo = e.detail.policy_detail;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.claId = e.detail.cla_id;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = true;
        } else {
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = true;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = false;
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        }
    }
    renderedCallback(){
        console.log('clContainer renderedcallback');
        if(!this.is_first_load) {
            this.is_first_load = true;
            this.showApplynewOMBP = false;
            this.showApplynewSBP = false;
            this.showApplicationRecord = false;
            this.showCLApplicationConfirmation = false;
            this.redirectApplicationRecord = true;
            this.clId = '';
            this.dashBoard = false;
            this.showCLApplicationConfirmationSBP = false;
            this.showAmmendSBP = false;
            this.showApplynewSUP = false;
            this.showCLApplicationConfirmationSUP = false;
            this.showAmmendSUP = false;
            this.showApplicationDraft = false;
        }
    }

}
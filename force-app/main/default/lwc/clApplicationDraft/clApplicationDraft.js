import { api, LightningElement, track,wire } from 'lwc';
import getCLADraftListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLADraftListByPolicy';
import { refreshApex } from '@salesforce/apex';
import DeleteDraft from '@salesforce/apex/CLApplicationRecord.DeleteDraft';

import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Details from '@salesforce/label/c.Details';
import Application_Date_CL from '@salesforce/label/c.Application_Date_CL';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import New_Credit_Limit_Application from '@salesforce/label/c.New_Credit_Limit_Application';
import Credit_Limit_Application_Draft_Record from '@salesforce/label/c.Credit_Limit_Application_Draft_Record';


export default class ClApplicationDraft extends LightningElement {

    @track label = {
        Company_Name,Policy_Number,Policy_Type,Free_Credit_Check_Facility_Balance,Details,Application_Date_CL,
        Buyer_Code,Buyer_Name,New_Credit_Limit_Application,Credit_Limit_Application_Draft_Record
    }

    policyId = '';
    @api policydetail;
    @track isRendered = false;
    
    @track loading = false;
    @track showCheckFacilityModal = false;
    @track cla_list = [];
    

    handleCreditCheckFacility(e) {
        this.showCheckFacilityModal = true;
    }
    handleDisplayccfmodal(e) {
        this.showCheckFacilityModal = false;
    }
    
    callgetCLADraftListByPolicy() {
        getCLADraftListByPolicy({policy_id:this.policyId})
        .then((result) => {
            this.loading = false;
            //console.log('draftlist=',JSON.stringify(result));
            this.cla_list = result;        
        })
        .catch((error) => {
            //console.log('error on get draft::', JSON.stringify(error));
            console.error('error get draft::', JSON.stringify(error));
        });
    }
    
    handleEdit(e) {
        let selected_id = e.currentTarget.dataset.id;
        let selected_cla = [];
        let page_name='';
        this.cla_list.forEach((cla) => {
            if (selected_id === cla.Id)
            selected_cla = cla;            
        })
        
        if (this.policydetail.Product__r.Name === 'SUP'){
            page_name = 'ApplynewSUP';
        } else if (this.policydetail.Product__r.Name === 'SBP'){
            page_name = 'ApplynewSBP';
        } else if (this.policydetail.Product__r.Name === 'OMBP'){
            page_name = 'ApplynewOMBP';
        }
        //console.log('selected cla=',JSON.stringify(selected_cla));
        let event1 = new CustomEvent('handlepagechange', {
            detail: {
                Pagename: page_name,
                accId: this.policydetail.Exporter__r.Id,
                clRecordDraft: selected_cla                
            }
        });
        this.dispatchEvent(event1);
    }
    handleDelete(e) {
        let selected_id = e.currentTarget.dataset.id;
        this.loading = true;
        DeleteDraft({
            cla_id: selected_id
        }).then((result) => {
            //console.log('Old draft deleted');
            this.callgetCLADraftListByPolicy();
        })
        .catch((error) => {
            //console.log('error on Old draft delete::', JSON.stringify(error));
            console.error('error Old draft delete::', JSON.stringify(error));
        });
    }
    handleNewCLA(e) {
        let page_name='';
        if (this.policydetail.Product__r.Name === 'SUP'){
            page_name = 'ApplynewSUP';
        } else if (this.policydetail.Product__r.Name === 'SBP'){
            page_name = 'ApplynewSBP';
        } else if (this.policydetail.Product__r.Name === 'OMBP'){
            page_name = 'ApplynewOMBP';
        } 
        let event1 = new CustomEvent('handlepagechange', {
            detail: {
                Pagename: page_name,
                accId: this.policydetail.Exporter__r.Id                
            }
        });
        this.dispatchEvent(event1);
    }
    renderedCallback() {
        if (!this.isRendered) {
            // //console.log('today=',this.formatDate());            
            this.isRendered = true;
            this.loading = true;
            //console.log('policydetail=', JSON.stringify(this.policydetail));
            this.policyId = this.policydetail.Id;
            this.callgetCLADraftListByPolicy();
        }
    }

}
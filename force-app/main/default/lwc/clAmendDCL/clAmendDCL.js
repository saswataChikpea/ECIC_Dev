import { LightningElement, track,api } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Credit_Limit__c.Id';
import ADDRL1_FIELD from '@salesforce/schema/Credit_Limit__c.Amend_Buyer_Address_Line_1__c';
import ADDRL2_FIELD from '@salesforce/schema/Credit_Limit__c.Amend_Buyer_Address_Line_2__c';
import ADDRL3_FIELD from '@salesforce/schema/Credit_Limit__c.Amend_Buyer_Address_Line_3__c';
import ADDRL4_FIELD from '@salesforce/schema/Credit_Limit__c.Amend_Buyer_Address_Line_4__c';
import NAME_FIELD from '@salesforce/schema/Credit_Limit__c.Amend_Buyer_Name__c';

import CLA_ID_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Id';
import CLA_ADDRL1_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Amend_Buyer_Address_Line_1__c';
import CLA_ADDRL2_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Amend_Buyer_Address_Line_2__c';
import CLA_ADDRL3_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Amend_Buyer_Address_Line_3__c';
import CLA_ADDRL4_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Amend_Buyer_Address_Line_4__c';
import CLA_NAME_FIELD from '@salesforce/schema/Credit_Limit_Application__c.Amend_Buyer_Name__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import amendDCLAura from '@salesforce/apex/ECIC_CL_API_Methods.amendDCLAura';

import Update_Buyer_Name_and_or_Address from '@salesforce/label/c.Update_Buyer_Name_and_or_Address';
import Current_Buyer_Name from '@salesforce/label/c.Current_Buyer_Name';
import New_Buyer_Name from '@salesforce/label/c.New_Buyer_Name';
import Current_Buyer_Address from '@salesforce/label/c.Current_Buyer_Address';
import New_Buyer_Address from '@salesforce/label/c.New_Buyer_Address';
import Cancel from '@salesforce/label/c.Cancel';
import Submit from '@salesforce/label/c.Submit';


export default class ClAmendDCL extends LightningElement {

    @track label = {
        Update_Buyer_Name_and_or_Address,Current_Buyer_Name,New_Buyer_Name,Current_Buyer_Address,New_Buyer_Address,
        Cancel,Submit
    }

    @api dcldetail = [];
    @track is_rendered = false;
    @track edit_buyer_name = false;
    @track edit_buyer_add = false;
    @track new_buyer_name = '';
    @track new_buyer_add1 = '';
    @track new_buyer_add2 = '';
    @track new_buyer_add3 = '';
    @track new_buyer_add4 = '';
    @track object_type = '';


    handleBuyerNameChange(e) {
        this.new_buyer_name = e.target.value;
    }
    handleBuyerAdd1Change(e) {
        this.new_buyer_add1 = e.target.value;
    }
    handleBuyerAdd2Change(e) {
        this.new_buyer_add2 = e.target.value;
    }
    handleBuyerAdd3Change(e) {
        this.new_buyer_add3 = e.target.value;
    }
    handleBuyerAdd4Change(e) {
        this.new_buyer_add4 = e.target.value;
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    isValid(){
        if((this.edit_buyer_name) && ((this.new_buyer_name.trim() === '') || (this.new_buyer_name.trim().length<3))){
            this.showToast('Invalid buyer name');
            return false;
        } else if ((this.edit_buyer_add) && ((this.new_buyer_add1.trim() === '') || (this.new_buyer_add1.trim().length < 2))) {
            this.showToast('Invalid buyer address');
            return false;
        } else if((!this.edit_buyer_add) && (!this.edit_buyer_name)) {
            this.showToast('No update found');
            return false;
        } else {
            return true;
        }
        
    }
    handleSubmit(e) {
        
        try{
        if (this.isValid()) { 
            const fields = {};
            if(this.object_type == 'Credit_Limit_Application__c'){
                fields[CLA_ID_FIELD.fieldApiName] = this.dcldetail.Id;
                fields[CLA_ADDRL1_FIELD.fieldApiName] = this.new_buyer_add1;
                fields[CLA_ADDRL2_FIELD.fieldApiName] = this.new_buyer_add2;
                fields[CLA_ADDRL3_FIELD.fieldApiName] = this.new_buyer_add3;
                fields[CLA_ADDRL4_FIELD.fieldApiName] = this.new_buyer_add4;
                fields[CLA_NAME_FIELD.fieldApiName] = this.new_buyer_name;
            } else {
                fields[ID_FIELD.fieldApiName] = this.dcldetail.Id;
                fields[ADDRL1_FIELD.fieldApiName] = this.new_buyer_add1;
                fields[ADDRL2_FIELD.fieldApiName] = this.new_buyer_add2;
                fields[ADDRL3_FIELD.fieldApiName] = this.new_buyer_add3;
                fields[ADDRL4_FIELD.fieldApiName] = this.new_buyer_add4;
                fields[NAME_FIELD.fieldApiName] = this.new_buyer_name;
            }           
            
            const recordInput = { fields };
                updateRecord(recordInput)
                    .then(() => {
                        // this.callamendDCLAura();
                        this.closeModal();
                    })
                    .catch(error => {
                        this.showToast('Some internal error occurred. Please try again later');
                        //console.log('error in cla ammend', JSON.stringify(error));
                        console.error('error in cla ammend', JSON.stringify(error));
                    });
        }
    }catch(console){
        //console.log('error=',JSON.stringify(error));
        console.error('error=',JSON.stringify(error));
    }
    }
    renderedCallback(){
        if(!this.is_rendered){
            this.is_rendered = true;
            //console.log('dcldetail=',JSON.stringify(this.dcldetail));
            this.object_type = this.dcldetail.record_type;
        }
    }
    handleEditBuyerName() {
        this.edit_buyer_name = true;
    }
    handleEditBuyerAddress(){
        this.edit_buyer_add = true;
    }
    callamendDCLAura() {
        amendDCLAura({
            'clApplicationID':this.dcldetail.Id
        }).then((result) => {
            //console.log('amendDCLAura response=',JSON.stringify(result));
        })
        .catch((error) => {
            //console.log("error in amendDCLAura", JSON.stringify(error));
            console.error("error in amendDCLAura", JSON.stringify(error));
        });
    }
    closeModal(){
        // alert("closemodal");
        let detail = {
            type:"cancel"
        }
        const closeEvent = new CustomEvent("displayamenddclchange",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }

}
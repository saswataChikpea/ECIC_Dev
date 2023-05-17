import { LightningElement, track,api } from 'lwc';
// import getCLListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLListByPolicy';
import getCLCLAListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLCLAListByPolicy';

import Credit_Check_Facility from '@salesforce/label/c.Credit_Check_Facility';
import Free_Credit_Check_Facility from '@salesforce/label/c.Free_Credit_Check_Facility';
import Free_Credit_Check_Facility_Utilized from '@salesforce/label/c.Free_Credit_Check_Facility_Utilized';
import Free_Credit_Check_Facility_Balance from '@salesforce/label/c.Free_Credit_Check_Facility_Balance';
import Credit_Limit_Application_Record from '@salesforce/label/c.Credit_Limit_Application_Record';
import Application_Date_CL from '@salesforce/label/c.Application_Date_CL';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';


export default class ClCheckFacility extends LightningElement {

    @track label = {
        Credit_Check_Facility,Free_Credit_Check_Facility,Free_Credit_Check_Facility_Utilized,Free_Credit_Check_Facility_Balance,
        Credit_Limit_Application_Record,Application_Date_CL,Buyer_Code,Buyer_Name
    }

    @api policydetail=[];
    @track is_rendered = false;
    @track free_credit = "";
    @track credit_utilized = "";
    @track paid_credit = "";
    @track free_credit_balance = "";
    @track cl_list = [];
    renderedCallback(){
        let self = this;
        if (!this.is_rendered){
            this.is_rendered = true;
            //console.log("policydetail=",JSON.stringify(this.policydetail));
            if (Object.keys(this.policydetail).length > 0) {
                this.free_credit = this.policydetail.Free_Credit_Check__c;
                this.credit_utilized = this.policydetail.Used_Credit_check__c;
                this.paid_credit = this.policydetail.Paid_Credit_Check__c;
                this.free_credit_balance = this.policydetail.Available_Credit_Check__c;
                
                getCLCLAListByPolicy({
                    'policy_id':this.policydetail.Id
                }).then((result) => {                    
                    let tot_list = [];
                    result.clList.map((each_cl)=>{
                        self.cl_list.push(each_cl);
                    });
                    result.claList.map((each_cl)=>{
                        self.cl_list.push(each_cl);
                    })
                    // tot_list.push(result.clList);
                    // tot_list.push(result.claList);
                    this.cl_list.sort((a, b) => b.Application_Date__c.localeCompare(a.Application_Date__c));

                    // console.log("getCLCLAListByPolicy=", JSON.stringify(tot_list));
                    
                })
                .catch((error) => {
                    console.error('error=',JSON.stringify(error));
                    //console.log('error=',JSON.stringify(error));
                });
            }
        }
    }
    closeModal(){
        // alert("closemodal");
        let detail = {
            type:"cancel"
        }
        const closeEvent = new CustomEvent("displayclfacilitychange",{
            detail:detail
        })
        this.dispatchEvent(closeEvent);
    }
}
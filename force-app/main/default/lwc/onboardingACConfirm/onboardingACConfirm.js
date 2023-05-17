import { api, LightningElement, wire } from 'lwc';
import getLastProposal from "@salesforce/apex/OnboardingCreateSiteUser.getLastProposal";

export default class OnboardingACConfirm extends LightningElement {
    @api proposal;
    @api usrId;
    companyName
    companyEmail
    proposalId

    connectedCallback() {
        console.log("create account confirm connected Callback proposal=", this.proposal, this.usrId)
        // if (this.proposal) {
        //     this.companyName = this.proposal.Company_Name__c ? this.proposal.Company_Name__c : ""
        //     this.companyEmail = this.proposal.Company_Email__c ? this.proposal.Company_Email__c : ""
        //     this.proposalId = this.proposal.Proposal_Id ? this.proposal.Proposal_Id : ""
        // }
    }
    @wire(getLastProposal, { usrId: '$usrId' })
    proposalDataCallback({ error, data }) {
        if (data) {
            console.log("data= " + JSON.stringify(data, null, '\t'))
            this.companyName = data.Company_Name__c
            this.companyEmail = data.Company_Email__c
            this.proposalId = data.Name
        } else if (error) {
            console.error('Error: 04 Unable to load data : ' + JSON.stringify(error));
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
    }

    navDashboard() {
        console.log('navDashboard')
        if (this.usrId) {
            console.log('redirecting to dashboard')
            window.location.href = './dashboard'
        } else {
            window.location.href = './login'
        }
    }
}
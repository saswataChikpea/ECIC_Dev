import { api, LightningElement } from 'lwc';
import getCompleteProposal from '@salesforce/apex/OnboardingCreateSiteUser.getCompleteProposal'
import applyProposalAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyProposalAura'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SubmitProposalLegacyAction extends LightningElement {
    @api recordId;
    @api invoke() {
        console.log("Inside submit proposal legacy action.");
        console.log("Record Id is " + this.recordId);

        getCompleteProposal({ id: this.recordId }).then(initialProposal => {
            console.log("initialProposal::", JSON.stringify(initialProposal));
            const p = initialProposal
            // Insurable_Buyers__c
            let buyerCNTLabel = ''
            let lastBuyerCNTLabel = ''

            if (0 <= p.Insurable_Turnover__c && p.Insurable_Turnover__c <= 1000000) {
                buyerCNTLabel = 'BYR_CNT_UP_TO_1M'
                lastBuyerCNTLabel = 'LAST_BYR_CNT_UP_TO_1M'
            } else if (1000001 <= p.Insurable_Turnover__c && p.Insurable_Turnover__c <= 5000000) {
                buyerCNTLabel = 'BYR_CNT_1M_TO_5M'
                lastBuyerCNTLabel = 'LAST_BYR_CNT_1M_TO_5M'
            } else if (p.Insurable_Turnover__c > 5000000) {
                buyerCNTLabel = 'BYR_CNT_OVER_5M'
                lastBuyerCNTLabel = 'LAST_BYR_CNT_OVER_5M'
            }
            const data = {
                "ACCOUNT_ID": p.Account__c,
                "CONT_PERSON_ID": p.Account__c,
                "PROPOSAL_ID": proposalId,
                "PCY_TYPE": p.Policy_Type__c,
                "RECV_DATE": p.Receive_Date__c,
                "BR_NO": p.BR_Number__c,
                "STS": 'O',

                "LAST_2_YR_BAD_DEBT": p.Bad_Debt_Amount__c,
                "OVER_30_DAY_OD_AMT": p.Overdue_Amount__c,

                "IM_PCT": Number(p.Indemnity_Percentage__c),

                "IND_CODE": p.Goods_And_Service__c,
                // "RVW_EXP_DATE": '2021-11-08',
                COMMENCE_DATE: p.Policy_Commence_Date__c ? p.Policy_Commence_Date__c : p.Receive_Date__c || this.today,
                "CUS_NAME": p.Company_Name__c,
                "SETUP_DATE": p.Corporate_Incorporation_Date__c,
                "LEGAL_TYPE": 'PROP',
                "BR_EXP_DATE": p.BR_Expiry_Date__c,
                "OFF_ADDR_1": p.Registered_Address_Line_1__c,
                "OFF_ADDR_2": p.Registered_Address_Line_2__c,
                "OFF_ADDR_3": p.Registered_Address_Line_3__c,
                "OFF_ADDR_4": p.Registered_Territory__c,
                "OFF_ADDR_DIST": p.Registered_District__c,
                "COR_ADDR_1": p.Correspondence_Address_Line_1__c,
                "COR_ADDR_2": p.Correspondence_Address_Line_2__c,
                "COR_ADDR_3": p.Correspondence_Address_Line_3__c,
                "COR_ADDR_4": p.Correspondence_Territory__c,
                "COR_ADDR_DIST": p.Correspondence_District__c,

                "LANG_TYPE": p.Language_of_Correspondence__c == "English" ? 'E' : 'T',
                "CONT_PERSON_NAME": p.Contact_Name__c,
                "CONT_PERSON_TITLE": p.Title__c,
                "CONT_PERSON_EMAIL": p.Company_Email__c,
                "CONT_PERSON_MOBILE": p.Mobile_Number__c,
                "RENEWAL": p.Auto_Renewal__c == "Automatic Renewal" ? "AUTO" : "MANU",
                "APP_REASON": p.Application_Reason__c,
                "NQL": Number(p.NQL_Amount__c),
                [buyerCNTLabel]: p.Insurable_Buyers__c,
                [lastBuyerCNTLabel]: p.Insurable_Buyers__c,

                //additional other than required
                // EXP_LAST_FY_TOT_TO: p.
                REF_BY_LIST: p.Know_About_Hkecic__c,
                COM_TEL_NO: p.Company_Telephone_Number__c,
            }
            console.log("calling applyProposal::", JSON.stringify(data));
            // this.callCreateProposalAPI(data)

        }).catch(error => {
            console.error(error);
            this.showToast('Unable to fetch data. Please try again later.')
        })
    }
    callCreateProposalAPI(data) {
        let pId = data['PROPOSAL_ID']
        // console.log("callCreateProposalAPI::");
        applyProposalAura({ jsonObject: data }).then(res => {
            let data = JSON.parse(res)
            console.log("applyProposalAura success::", data);
            let temp = {}
            if (data.rtn_code == '1') {
                temp = {
                    Id: pId,
                    CUS_NO__c: data['meta_data']['cus_no'],
                    Is_Legacy_Verified__c: true,
                    Is_Error__c: false,
                    Legacy_Response__c: JSON.stringify(data)
                }

                console.log("call updateProposal::", pId, temp);
                updateProposal({ data: temp }).then(data => {
                    console.log("updateProposal success:", data)
                    this.showAccountCreationSuccessful()
                }).catch(error => {
                    this.showToast("Something went wrong creating proposal. Please try again")
                    console.log("updateProposal error:", error)
                })
            } else {
                temp = {
                    Id: pId,
                    Is_Legacy_Verified__c: false,
                    Is_Error__c: true,
                    Legacy_Response__c: JSON.stringify(data),
                }
                console.log("call updateProposal::", pId, temp);
                updateProposal({ data: temp }).then(data => {
                    console.log("updateProposal success:", data)
                    this.showProposalCreatedWithError()
                }).catch(error => {
                    console.log("updateProposal error:", error)
                    this.showToast("Something went wrong creating proposal. Please try again")
                })
            }
        }).catch(error => {
            // this.showToast("Something went wrong creating proposal. Please try again")
            console.error('Error: 03 Cannot create applyProposalAura : ' + error);
            console.error('Error: 03 Cannot create applyProposalAura : ' + JSON.stringify(error));
            this.error = 'Failed to create applyProposalAura'
            if (error.body) {
                if (Array.isArray(error.body)) {
                    this.exceptionDetail = error.body.map(e => e.message).join(', ')
                } else if (typeof error.body.message === 'string') {
                    this.exceptionDetail = error.body.message
                }
            } else {
                this.exceptionDetail = error
            }
            let temp1 = {
                Id: pId,
                Is_Error__c: true,
                Legacy_Response__c: JSON.stringify(error),
            }
            updateProposal({ data: temp1 }).then(data => {
                this.showProposalCreatedWithError()
                console.log("updateProposal success:", data)
            }).catch(error => {
                this.showToast("Something went wrong creating proposal. Please try again")
                console.log("updateProposal error:", error)
            })
        });
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
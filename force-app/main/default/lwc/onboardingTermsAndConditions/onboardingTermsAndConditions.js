import { api, LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import initMethod from '@salesforce/apex/FetchCmsContent.initMethod';
import createProposal from '@salesforce/apex/OnboardingCreateSiteUser.createProposal'
import applyProposalAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyProposalAura'
import updateProposal from "@salesforce/apex/OnboardingCreateSiteUser.updateProposal";
import UsrId from '@salesforce/user/Id'
import Sales_Turnover_declaration from '@salesforce/label/c.Sales_Turnover_declaration';
import Terms_Conditions from '@salesforce/label/c.Terms_Conditions';
import Personal_Information from '@salesforce/label/c.Personal_Information';
import Terms_and_Conditions_Disclaimers_and_Indemnities from '@salesforce/label/c.Terms_and_Conditions_Disclaimers_and_Indemnities';


export default class OnboardingTermsAndConditions extends LightningElement {

    @track label = {
        Sales_Turnover_declaration, Terms_Conditions, Personal_Information, Terms_and_Conditions_Disclaimers_and_Indemnities

    }

    @api proposal //= { Past_Turnover__c: 'HKD 20,000,001 – 30,000,000' }
    @track btnDisabled = false//true;
    disableNextClass = ""//"disabled"
    usrId = UsrId

    @track showFirstPage = true
    @track showSecondPage = false
    sectionHeading = this.label.Terms_and_Conditions_Disclaimers_and_Indemnities

    @track checkbox1Value = false
    @track checkbox2Value = false
    checkbox_turnover = false
    turnoverMessage = ""
    showCheckboxError = false
    checkboxNotSelectedErrorMsg = "Please accept all the terms & conditions to continue."
    @api isMultipleProposal
    @api selectedProductName

    isLoaded = false
    connectedCallback() {
        if (!this.termsData) {
            this.isLoaded = false
        }
        console.log("connectedCallback: isMultipleProposal" + JSON.stringify(this.isMultipleProposal))
        console.log("connected callback=> proposal:", this.proposal)
        console.log("connected callback=> selectedProductName:", this.selectedProductName)
        if (this.proposal) {
            this.proposal = { ...this.proposal }
        }
        this.turnoverMessage = this.getTurnoverMessage()
        console.log("turnoverMessage::", this.turnoverMessage);
    }
    getTurnoverMessage() {
        if (this.selectedProductName == 'OMBP')
            return ' HKD 30 million'
        return ' HKD 50 million'
    }
    escapeRegExp = (string) => {
        return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
    }
    replaceValue = (str, match, replacement) => {
        return str.replace(new RegExp(escapeRegExp(match), 'g'), () => replacement);
    }

    replaceAll(str, find, replace) {
        return str.replace(new RegExp(find, 'g'), replace);
    }

    getFormattedString = (st) => {
        st = st.replace(/&amp;nbsp;/g, " ");
        st = st.replace(/&amp;quot;/g, '"');
        st = st.replace(/&amp;copy;/g, '(c)');
        st = this.replaceAll(st, '&gt;', ">")
        st = this.replaceAll(st, '&lt;', "<")
        return st
    }

    termsData = ""
    PIData = ""
    @wire(initMethod)
    getResults({ error, data }) {
        if (data) {
            this.isLoaded = true
            console.log('results : ' + JSON.stringify(data));
            for (let t in data) {
                if (data[t].title === 'Onboarding_Terms_And_Conditions') {
                    this.termsData = this.getFormattedString(data[t].contentNodes.body.value)
                    // this.termsData = data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<").replaceAll('&quot;', '"');
                    // this.proposal['Terms_And_Conditions']=t.managedContentId
                }
                else if (data[t].title === 'Onboarding_Personal_information_collection') {
                    this.PIData = this.getFormattedString(data[t].contentNodes.body.value)
                    // this.proposal['Terms_And_Conditions']=t.managedContentId
                }
            }
        } else if (error) {
            this.isLoaded = true
            console.log('error : ' + JSON.stringify(error));
            this.error = error;
            this.record = undefined;
        }
    }
    // get termsData() {
    //     console.log('this.counter : ' + this.counter);
    //     console.log('results : ' + JSON.stringify(this.results));
    //     for (let t in this.results.data) {
    //         if (this.results.data[t].title === 'Onboarding_Terms_And_Conditions') {
    //             return this.results.data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<");
    //         }
    //         // else if (this.results.data[t].title === 'Onboarding_Personal_information_collection') {
    //         //     this.PIData = this.results.data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<");
    //         // }
    //         return "Hard coded data"
    //     }
    // }
    // get PIData() {
    //     console.log('this.counter : ' + this.counter);
    //     console.log('results : ' + JSON.stringify(this.results));
    //     for (let t in this.results.data) {
    //         // if (this.results.data[t].title === 'Onboarding_Terms_And_Conditions') {
    //         //     this.termsData = this.results.data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<");
    //         // }
    //         if (this.results.data[t].title === 'Onboarding_Personal_information_collection') {
    //             return this.results.data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<");
    //         }
    //         return "Hard coded data"

    //     }
    // }

    handleCheckboxChange(event) {
        console.log(event.currentTarget.name, event.currentTarget.checked)
        if (event.currentTarget.checked) {
            this.showCheckboxError = false
        }
        if (event.currentTarget.name == "checkbox1")
            this.checkbox1Value = event.currentTarget.checked ? true : false
        else if (event.currentTarget.name == "checkbox2")
            this.checkbox2Value = event.currentTarget.checked ? true : false
        else if (event.currentTarget.name = "checkbox_turnover") {
            this.checkbox_turnover = event.currentTarget.checked ? true : false
        }

    }
    confirmSubmitTerms() {
        console.log(' ====> confirmCubmitTerms')
        if (!this.checkbox2Value) {
            this.showCheckboxError = true
        } else {
            this.showCheckboxError = false
            this.showCreateAccount()
        }
    }
    showAccountCreationSuccessful() {
        console.log(' ====> showAccountCreationSuccessful')
        this.showToast("Policy application is submitted successfully. Redirecting to dashboard", 'Success', 'success')
        setTimeout(() => {
            this.navDashboard()
        }, 3000);
        // const redUrl = '/ECReach/s/onboarding'
        // console.log("redirecting to :", redUrl);
        // window.location.href = redUrl
    }
    callCreateProposal() {
        // //alert('callCreateProposal')
        console.log("callCreateProposal: " + JSON.stringify(this.proposal))
        // this.callCreateProposalAPI()
        createProposal({ proposal: this.proposal }).then(data => {
            console.log(' ====> created Proposal id =', data)
            console.log("create proposal success: " + JSON.stringify(data))
            this.proposal.Proposal_Id = data
            // this.showToast("")
            this.prepareProposal(data)

            // this.showAccountCreationSuccessful()
        }).catch(error => {
            this.showToast("Something went wrong creating proposal. Please try again")
            console.error('Error: 03 Cannot create Proposal : ' + error);
            console.error('Error: 03 Cannot create Proposal : ' + JSON.stringify(error));
            this.error = 'Failed to create proposal'
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
    get today() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }

    prepareProposal(proposalId) {
        const p = this.proposal
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
            "RECV_DATE": '2021-10-20',
            "BR_NO": p.BR_Number__c,
            "STS": 'O',

            "LAST_2_YR_BAD_DEBT": p.Bad_Debt_Amount__c,
            "OVER_30_DAY_OD_AMT": p.Overdue_Amount__c,

            "IM_PCT": Number(p.Indemnity_Ratio__c),

            "IND_CODE": p.Goods_And_Service__c,
            // "RVW_EXP_DATE": '2021-11-08',
            COMMENCE_DATE: p.Policy_Commence_Date__c ? p.Policy_Commence_Date__c : p.Receive_Date__c || this.today,
            "CUS_NAME": p.Company_Name__c,
            "SETUP_DATE": p.Corporate_Incorporation_Date__c,
            "LEGAL_TYPE": p.Company_Legal_Type__c || 'PROP',
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
            "CONT_PERSON_NAME": (p.First_Name__c || '') + ' ' + p.Last_Name__c,
            // "CONT_PERSON_NAME": p.Contact_Name__c,

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
        this.callCreateProposalAPI(data)

    }
    callCreateProposalAPI(data) {
        let pId = data.PROPOSAL_ID
        // console.log("callCreateProposalAPI::");
        applyProposalAura({ jsonObject: data }).then(res => {
            let data = JSON.parse(res)
            console.log("applyProposalAura success::", data);
            let temp = {}
            if (data.rtn_code == '1') {
                temp = {
                    Id: pId,
                    CUS_NO__c: data.meta_data.cus_no,
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
    }/*
    callCreateProposalAPI(data) {
        let pId = data['PROPOSAL_ID']
        // console.log("callCreateProposalAPI::");
        applyProposalAura({ jsonObject: data }).then(res => {

            let data = JSON.parse(res)
            console.log("applyProposalAura success::", data);
            let temp = {}
            if (data.rtn_code && data.rtn_code == '1') {
                temp = {
                    Id: pId,
                    CUS_NO__c: data['meta_data']['cus_no'],
                    Is_Legacy_Verified__c: true,
                    Is_Error__c: false,
                    Legacy_Response__c: JSON.stringify(data)
                }
            } else {
                temp = {
                    Id: pId,
                    Is_Legacy_Verified__c: false,
                    Legacy_Response__c: JSON.stringify(data),
                }
            }
            console.log("call updateProposal::", pId, temp);
            updateProposal({ data: temp }).then(data => {
                console.log("updateProposal success:", data)
            }).catch(error => {
                console.log("updateProposal error:", error)
            })
            this.showAccountCreationSuccessful()
        }).catch(error => {
            // this.showToast("Something went wrong creating proposal. Please try again")
            this.showAccountCreationSuccessful()
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
                console.log("updateProposal success:", data)
            }).catch(error => {
                console.log("updateProposal error:", error)
            })
        });
    }*/
    showProposalCreatedWithError() {
        this.showToast("Policy application is submitted with errors. Redirecting to dashboard")
        setTimeout(() => {
            this.navDashboard()
        }, 3000);
    }
    showCreateAccount() {
        console.log(' ====> showCreateAccount')
        if (this.isMultipleProposal) {
            this.callCreateProposal()
        } else {
            const event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: { pageId: 'showOnboardingCreateAccount', proposal: this.proposal }
            });
            this.dispatchEvent(event1)
        }
    }
    showPrevious() {
        console.log(' ====> showPrevious')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: "showOnboardingProposalConfirmation" }
        });
        this.dispatchEvent(event1)
    }
    togglePage() {
        if (this.showFirstPage && !this.checkbox1Value) {
            this.showCheckboxError = true
            return
        }
        if (this.showFirstPage && !this.checkbox_turnover) {
            this.showCheckboxError = true
            return
        }
        this.showCheckboxError = false
        // this.btnDisabled = true //After ecic stopped working
        // this.disableNextClass = "disabled"
        this.showFirstPage = this.showFirstPage ? false : true
        this.showSecondPage = this.showSecondPage ? false : true
        this.sectionHeading = this.showFirstPage ? "Please read and accept the Terms and Conditions." : "Please read and accept the Personal Information Collection and Privacy Policy Statement."
    }
    handleScroll(event) {
        // this.btnDisabled = event.target.scrollTop + 50 >= (event.target.scrollHeight - event.target.offsetHeight) ? false : true
        // this.disableNextClass = event.target.scrollTop + 50 >= (event.target.scrollHeight - event.target.offsetHeight) ? "" : "disabled"

        this.btnDisabled = false
        this.disableNextClass = ""
    }
    showToast = (message, title, variant) => {
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
import { LightningElement, track, wire } from 'lwc'
import UsrId from '@salesforce/user/Id'
import UsrPhone from '@salesforce/schema/User.Phone'
import UsrMPhone from '@salesforce/schema/User.MobilePhone'
import UsrRoleName from '@salesforce/schema/User.UserRole.Name'
import UsrManagerId from '@salesforce/schema/User.ManagerId'
import getProducts from '@salesforce/apex/OnBoarding.getProducts'
import getOnboardingSetting from '@salesforce/apex/OnBoarding.getOnboardingSetting'
import initSMSVerify from '@salesforce/apex/OnboardingCreateSiteUser.initSMSVerify'
// import verifySMS from '@salesforce/apex/OnboardingCreateSiteUser.verifySMS'
import getVerificationStatus from '@salesforce/apex/OnboardingCreateSiteUser.getVerificationStatus'
import createProposal from '@salesforce/apex/OnboardingCreateSiteUser.createProposal'
import getProposalData from '@salesforce/apex/OnboardingCreateSiteUser.getProposalData'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import initEmailVerify from '@salesforce/apex/OnboardingCreateSiteUser.initEmailVerify'
import verifyEmail from '@salesforce/apex/OnboardingCreateSiteUser.verifyEmail'
import { createRecord } from 'lightning/uiRecordApi' //updateRecord
import getProposal from "@salesforce/apex/OnboardingCreateSiteUser.getProposal";
import getProposalFromQuote from "@salesforce/apex/OnboardingCreateSiteUser.getProposalFromQuote";
import applyProposalAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyProposalAura'
import updateProposal from "@salesforce/apex/OnboardingCreateSiteUser.updateProposal";
import UserPreferencesShowStreetAddressToGuestUsers from '@salesforce/schema/User.UserPreferencesShowStreetAddressToGuestUsers'
import { CurrentPageReference } from 'lightning/navigation';

export default class OnboardingContainer extends LightningElement {
    @track error = false
    @track exceptionDetail
    @track retUrl
    usrId = UsrId
    UsrPhone = UsrPhone
    UsrMPhone = UsrMPhone
    UsrRoleName = UsrRoleName
    UsrManagerId = UsrManagerId

    unsavedData = false

    @track verificationStatus
    @track showProductCom = false
    @track showOnboardingPI = false
    @track showOnboardingDP = false
    @track showAccountCreation = false
    @track showOnboardingFillInProposal = false
    @track showOnboardingProposalConfirmation = false
    @track showOnboardingTermsAndConditions = false
    @track showOnboardingACConfirm = false
    @track selected_product
    @track proposal
    @track showOnboardingHome = false
    @track products
    @track boardingSetting
    @track brFile
    @track productSearchError
    @track initialProposal = {}
    @track isMultipleProposal = false
    @track isReviseQuote = false
    @track reviseQuoteId
    @track selectedProductName
    @track quote
    @track language
    // @api
    // setElementId(sel_element){
    //     this.elementId = sel_element
    // }
    connectedCallback() {
        if (this.unsavedData)
            window.addEventListener("beforeunload", function (e) {
                var confirmationMessage = 'It looks like you have been editing something. '
                    + 'If you leave before saving, your changes will be lost.';

                (e || window.event).returnValue = confirmationMessage; //Gecko + IE
                return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
            });
        this.getProducts()
        // todo check CurrentPageReference for update or multiple proposal/ quote
        let createNewProposal = this.getUrlParamValue(window.location.href, 'createNewProposal');
        let rq = this.getUrlParamValue(window.location.href, 'rq');
        let id = this.getUrlParamValue(window.location.href, 'id');
        console.log("connectedCallback:: createNewProposal=", createNewProposal);
        console.log("connectedCallback:: rq=", rq + " id=", id);
        console.log("connectedCallback:: usrId=", this.usrId);
        if (createNewProposal) {
            // this.showOnboardingDP()
            this.isMultipleProposal = true
            // load
            // this.showOnboardingDP = true
            this.prepareForShowingDP()
        } else if (rq && id) {
            //rq== revise quotation
            this.isReviseQuote = true
            this.reviseQuoteId = id
            this.getPropsalWithQutoeId(id)
        }
        else {
            this.callverificationStatus()
        }
    }
    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }
    prepareForShowingDP() {
        if (this.getProposalFinished && this.isMultipleProposal) {
            this.proposal = { ...this.previousProposal }
            this.showOnboardingDP = true
        }
    }
    getProposalFinished
    previousProduct
    previousProposal
    @wire(getProposal, { usrId: '$usrId' })
    proposalData({ error, data }) {
        if (data) {
            console.log("previous getProposal data= " + JSON.stringify(data, null, '\t'))
            let temp = {}
            temp.Contact_Name__c = data.Contact_Name__c
            temp.Past_Turnover__c = data.Past_Turnover__c
            temp.Future_Turnover__c = data.Future_Turnover__c
            temp.Insurable_Turnover__c = data.Insurable_Turnover__c
            temp.Insurable_Buyers__c = data.Insurable_Buyers__c
            temp.Sales_Amount_Range__c = data.Sales_Amount_Range__c
            temp.BR_Document__c = data.BR_Document__c
            temp.Corporate_Incorporation_Date__c = data.Corporate_Incorporation_Date__c
            temp.Registered_Territory__c = data.Registered_Territory__c
            temp.Registered_District__c = data.Registered_District__c
            temp.Registered_Address_Line_1__c = data.Registered_Address_Line_1__c
            temp.Registered_Address_Line_2__c = data.Registered_Address_Line_2__c
            temp.Registered_Address_Line_3__c = data.Registered_Address_Line_3__c
            temp.Correspondence_Address_Line_1__c = data.Correspondence_Address_Line_1__c
            temp.Correspondence_Address_Line_2__c = data.Correspondence_Address_Line_2__c
            temp.Correspondence_Address_Line_3__c = data.Correspondence_Address_Line_3__c
            temp.Registered_Correspondence_Same__c = data.Registered_Correspondence_Same__c
            temp.Company_Address_Correspondence__c = data.Company_Address_Correspondence__c
            temp.Correspondence_Territory__c = data.Correspondence_Territory__c
            temp.Correspondence_District__c = data.Correspondence_District__c
            temp.Application_Reason__c = data.Application_Reason__c
            temp.Company_Legal_Type__c = data.Company_Legal_Type__c
            temp.Bank_Account__c = data.Bank_Account__c

            temp.Title__c = data.Title__c
            temp.Company_Email__c = data.Company_Email__c
            temp.Mobile_Number__c = data.Mobile_Number__c
            temp.Company_Telephone_Number__c = data.Company_Telephone_Number__c ? data.Company_Telephone_Number__c : ""
            temp.Company_Name__c = data.Company_Name__c
            temp.Know_About_Hkecic__c = data.Know_About_Hkecic__c
            temp.BR_Number__c = data.BR_Number__c ? data.BR_Number__c : ""
            temp.BR_Expiry_Date__c = data.BR_Expiry_Date__c || ''
            temp.First_Name__c = data.First_Name__c || ''
            temp.Last_Name__c = data.Last_Name__c || ''
            temp.Account__c = data.Account__c


            // if (this.isMultipleProposal) {
            this.previousProduct = data.Product__c
            this.previousProposal = { ...temp }
            // this.showOnboardingDP = true
            // }
            this.getProposalFinished = true
            this.prepareForShowingDP()
            // this.companyName = data.Company_Name__c
            // this.companyEmail = data.Company_Email__c
            // this.proposalId = data.Name
            console.log("previousProposal:::=>", JSON.stringify(this.previousProposal));
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
    getPropsalWithQutoeId(id) {
        getProposalFromQuote({ id: id }).then(data => {
            console.log("getPropsalWithQutoeId:::", JSON.stringify(data));
            this.proposal = { ...data.Proposal__c }
            this.proposal.Policy_Commence_Date_old = this.proposal.Policy_Commence_Date__c
            this.proposal.Policy_Commence_Date__c = ""
            this.quote = { ...data.Quote__c }
            this.selected_product = this.proposal.Product__c
            this.showOnboardingDP = true
        }).catch(error => {
            console.error("getPropsalWithQutoeId err", JSON.stringify(error));
        })
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.language = currentPageReference.state.language
        console.log("currentPageReference::", JSON.stringify(currentPageReference), this.language);


    }

    @wire(getProposalData, { usrId: '$usrId' })//from account object
    proposalDataCallback({ error, data }) {
        if (data) {
            // console.log("proposalDataCallback data= " + data)
            this.accountId = data.Id
            this.initialProposal = JSON.parse(data.Proposal_Data__c)
            this.initialProposal.Account__c = data.Id

            console.log("initial proposal data= " + JSON.stringify(this.initialProposal, null, '\t'))
            // this.prepareProposal(data)


        } else if (error) {
            console.error('Error: 04 Unable to load data : ' + error);
            console.error("Unable to read proposal data" + JSON.stringify(error, null, '\t'))
            console.error('Error: 04 Unable to load data : ' + JSON.stringify(error));
            this.error = 'Error: 04 Unable to load data'
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

    // @wire(getVerificationStatus, { usrId: '$usrId' })
    callverificationStatus() {
        getVerificationStatus({ usrId: this.usrId }).then(data => {
            let pageToShow = ""
            console.log("onboarding container verificationStatusCallback data= " + JSON.stringify(data, null, '\t'))
            //this.accountId = data.Id
            this.verificationStatus = data
            if (data.EMAIL__c) {
                // this.showOnboardingACConfirm = true
                pageToShow = "showOnboardingACConfirm"
            } else {
                // this.showOnboardingHome = true
                pageToShow = "showOnboardingHome"

            }
            this.handleFlowFirstTime(pageToShow)

        }).catch(error => {
            // this.showOnboardingHome = true
            // pageToShow = "showOnboardingHome"
            console.error("Unable to read proposal data" + JSON.stringify(error))
            this.handleFlowFirstTime("showOnboardingHome")

        })
        //  else {
        //     // this.showOnboardingHome = true
        //     pageToShow = "showOnboardingHome"
        // }
        // if (this.showOnboardingHome && this.usrId) {
        //     //alert('You have an existing proposal')
        //     this.unsavedData = false
        //     // this.showOnboardingHome = false
        //     // this.showAccountCreation = true
        //     pageToShow = "showAccountCreation"
        // }
        // this.handleFlowFirstTime(pageToShow)
    }
    @wire(getOnboardingSetting, { source: 'onboardingMaster' })
    getOnboarSetting({ error, data }) {
        if (data) {
            console.log('####Onboarding_Setting data=' + JSON.stringify(data))
            this.boardingSetting = data
        }
        if (error) {
            console.error('####Onboarding_Setting error=' + JSON.stringify(error))
            error = 'Guest user need access to Onboarding Settings'
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

    handleFlowFirstTime(pageId) {

        if (pageId == 'showOnboardingHome' && this.usrId) {
            this.callInitEmailVerify()
        } else if (pageId == 'showOnboardingHome') {
            // this.showOnboardingHome = true//changing the flow
            this.showOnboardingPI = true
        } else if (pageId == 'showOnboardingACConfirm') {
            this.showOnboardingACConfirm = true
        } else if (pageId === 'showOnboardingCreateAccount') {
            // this.showAccountCreation = true
            // todo init email verify
            this.callInitEmailVerify()

        }
    }
    callInitEmailVerify() {
        initEmailVerify({ userId: this.usrId, password: "not_needed" }).then(data => {
            console.log('initEmailVerify success :' + JSON.stringify(data))
            try {
                this.showOtpModal()
            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
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
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
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

    showOtpModal() {
        console.log(' ====> showOtpModal')
        const modal = this.template.querySelector('c-custom-modal')
        modal.showModal()
    }
    hideOtpModal() {
        console.log(' ====> showOtpModal')
        const modal = this.template.querySelector('c-custom-modal')
        modal.hideModal()
    }
    handleOTP(event) {
        console.log("handleOtp=" + event)
        this.vcode = event.detail.inputTxtValue
        this.callVerifyEmail()
    }
    resendOTP(event) {
        console.log("Requesting for resend");
        this.callInitEmailVerify()
    }
    callVerifyEmail() {
        console.log('======>callVerifyEmail :' + this.vcode)
        verifyEmail({ code: this.vcode }).then(data => {//, accountId: this.accountId 
            console.log("OTP verification result:::", JSON.stringify(data))
            try {
                if ('statusCode' in data) {
                    if (data.statusCode == 200) {
                        //now create account and dispatchhandlepagechange from create account method
                        console.log(' ====> handleOnboardingFillInProposal')
                        //window.location.href = data.siteUrl
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Success!',
                            message: 'Your email has been verified successfully',
                            variant: 'success'
                        }))
                        // this.hideOtpModal()
                        this.updateAccount()//update is email verified
                    } else {
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Error!',
                            message: data.message,
                            variant: 'error'
                        }))
                    }
                } else {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error!',
                        message: 'Something went wrong! Please try again later',
                        variant: 'error'
                    }))
                }

            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
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
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
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
    updateAccount() {
        let record1 = {
            apiName: 'Verification_Method__c',
            fields: {
                Account__c: this.accountId,
                EMAIL__c: true
            },
        };
        console.log("update verification method::", record1);
        createRecord(record1)
            .then(() => {
                // todo submit proposal from account first time
                console.log('Update verification success:: creating proposal');
                this.hideOtpModal()
                this.callCreateProposal()
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Success',
                //         message: 'Record Is Updated',
                //         variant: 'success',
                //     }),
                // );
                // this.showAccountCreationSuccessful()
            })
            .catch(error => {
                console.error('Error: 03 Cannot create verification method: ' + error);
                console.error('Error: 03 Cannot create verification method: ' + JSON.stringify(error));
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
    callCreateProposal() {
        //alert('callCreateProposal')
        console.log("callCreateProposal: " + JSON.stringify(this.initialProposal))
        createProposal({ proposal: this.initialProposal }).then(data => {
            console.log(' ====> created Proposal id =', data)
            console.log("create proposal success: " + JSON.stringify(data))
            // this.proposal['Proposal_Id'] = data
            // const event1 = new CustomEvent('handlepagechange', {
            //     // detail contains only primitives
            //     detail: { pageId: 'showOnboardingFillInProposal', proposal: this.proposal}
            // });
            // this.dispatchEvent(event1)
            // todo
            this.prepareProposal(data)
            // this.showAccountCreationSuccessful()

        }).catch(error => {
            console.error('Error: 03 Cannot create Proposal : ' + error);
            console.error('Error: 03 Cannot create Proposal : ' + JSON.stringify(error));
            this.error = 'Failed to create proposal'
            // if (error.body) {
            //     if (Array.isArray(error.body)) {
            //         this.exceptionDetail = error.body.map(e => e.message).join(', ')
            //     } else if (typeof error.body.message === 'string') {
            //         this.exceptionDetail = error.body.message
            //     }
            // } else {
            //     this.exceptionDetail = error
            // }
        });
    }
    get today() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    prepareProposal(proposalId) {
        const p = this.initialProposal
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
        // this.callCreateProposalAPI(data) // commenting API call after ECIC stopped working
        this.showAccountCreationSuccessful()

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
    }
    showProposalCreatedWithError() {
        this.showToast("Policy application is submitted with errors. Redirecting to dashboard")
        setTimeout(() => {
            this.navDashboard()
        }, 3000);
    }
    showAccountCreationSuccessful() {
        this.resetAllPage()
        this.showOnboardingACConfirm = true
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

    handleProductSelected(event) {
        console.log('handlePageChange ====> handleProductSelected', event.detail.selected_product)
        this.selected_product = event.detail.selected_product
    }
    handlePageChange(event) {
        console.log('handlePageChange ====> ')
        const pageId = event.detail.pageId
        this.retUrl = event.detail.source
        if ('selected_product' in event.detail)
            this.selected_product = event.detail.selected_product
        console.log('pageId ====> ' + JSON.stringify(pageId))

        try {
            console.log('event.detail=' + JSON.stringify(event.detail))
        } catch (e) {
        }
        this.resetAllPage()

        if (pageId === 'showOnboardingPI') {
            this.showOnboardingPI = true
        } else if (pageId === 'showOnboardingDP') {
            this.showOnboardingDP = true
        } else if (pageId === 'showOnboardingCreateAccount') {
            this.showAccountCreation = true
        } else if (pageId === 'showOnboardingFillInProposal') {
            this.showOnboardingFillInProposal = true
        } else if (pageId == 'showOnboardingHome') {
            this.showOnboardingHome = true
        } else if (pageId == 'showProductCom') {
            this.showProductCom = true
        } else if (pageId == 'showOnboardingACConfirm') {
            this.showOnboardingACConfirm = true
        } else if (pageId == 'showOnboardingProposalConfirmation') {
            this.showOnboardingProposalConfirmation = true
        } else if (pageId == 'showOnboardingTermsAndConditions') {
            this.showOnboardingTermsAndConditions = true
        }

        if (event.detail.proposal) {
            this.proposal = { ...event.detail.proposal }
            console.log('on boarding container handlePageChange proposal ====> ' + JSON.stringify(this.proposal))
        }
        if (event.detail.brFile) {
            this.brFile = { ...event.detail.brFile }
            console.log('on boarding container handlePageChange brFile ====> ' + JSON.stringify(this.brFile))
        }
        if (event.detail.products) {
            this.products = [...event.detail.products]
            console.log('on boarding container handlePageChange products ====> ' + JSON.stringify(this.products))
        }
        if ('productSearchError' in event.detail) {
            this.productSearchError = event.detail.productSearchError
            console.log('on boarding container handlePageChange productSearchError ====> ' + JSON.stringify(this.productSearchError))
        }
        if ('selectedProductName' in event.detail) {
            this.selectedProductName = event.detail.selectedProductName
            console.log('on boarding container handlePageChange selectedProductName ====> ' + JSON.stringify(this.selectedProductName))

        }

    }
    resetAllPage() {
        this.showOnboardingHome = false
        this.showProductCom = false
        this.showOnboardingPI = false
        this.showOnboardingDP = false
        this.showOnboardingFillInProposal = false
        this.showOnboardingProposalConfirmation = false
        this.showOnboardingTermsAndConditions = false
        this.showAccountCreation = false
        this.showOnboardingACConfirm = false
    }
    getProducts() {
        console.log('getProducts called.');
        getProducts({}).then(data => {
            console.log('getProducts success :' + JSON.stringify(data));
            try {
                this.products = data;
                // console.log('this.products ::'+JSON.stringify(this.products));
                for (let p in data) {
                    // console.log('Seq---->'+data[p].Display_Sequence__c);
                    if (data[p].Display_Sequence__c === 1) {
                        this.productOmbpId = data[p].Id;
                    } else if (data[p].Display_Sequence__c === 2) {
                        this.productSbpId = data[p].Id;
                    } else if (data[p].Display_Sequence__c === 3) {
                        this.productSupId = data[p].Id;
                    }
                }
            } catch (error) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Occurred.',
                        message: error.toString(),
                        mode: 'sticky',
                        variant: 'error'
                    })
                );
            }
        }).catch(error => {
            console.error('Cannot fetch Product : ' + error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.toString(),
                    mode: 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    callInitSMSVerify() {
        initSMSVerify({ userId: this.usrId, password: this.password }).then(data => {
            console.log('initSMSVerify success :' + JSON.stringify(data))
            try {
                //now create account and dispatchhandlepagechange from create account method
                console.log(' ====> initSMSVerify')
                //window.location.href = data.siteUrl
                this.showOtpModal()
            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
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
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
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
    @track vcode
    // callVerifySMS() {
    //     console.log('======>callVerifySMS :' + this.vcode)
    //     verifySMS({ code: this.vcode }).then(data => {//, accountId: this.accountId 

    //         try {
    //             //now create account and dispatchhandlepagechange from create account method
    //             console.log(' ====> handleOnboardingFillInProposal')
    //             //window.location.href = data.siteUrl
    //             this.dispatchEvent(new ShowToastEvent({
    //                 title: 'Success!',
    //                 message: 'Your phone has been verified successfully',
    //                 variant: 'success'
    //             }))

    //             this.updateAccount()//update is SMS verified
    //         } catch (error) {
    //             console.error('Error: 01 Cannot create Account : ');
    //             console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
    //             this.error = 'Sign up failed'
    //             if (error.body) {
    //                 if (Array.isArray(error.body)) {
    //                     this.exceptionDetail = error.body.map(e => e.message).join(', ')
    //                 } else if (typeof error.body.message === 'string') {
    //                     this.exceptionDetail = error.body.message
    //                 }
    //             } else {
    //                 this.exceptionDetail = error
    //             }
    //         }
    //     }).catch(error => {
    //         console.error('Error: 02 Cannot create Account : ' + error);
    //         console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
    //         this.error = 'Sign up failed'
    //         if (error.body) {
    //             if (Array.isArray(error.body)) {
    //                 this.exceptionDetail = error.body.map(e => e.message).join(', ')
    //             } else if (typeof error.body.message === 'string') {
    //                 this.exceptionDetail = error.body.message
    //             }
    //         } else {
    //             this.exceptionDetail = error
    //         }
    //     });
    // }
    // showOtpModal() {
    //     console.log(' ====> showOtpModal')
    //     const modal = this.template.querySelector('c-custom-modal')
    //     modal.showModal()
    // }
    // handleOTP(event) {
    //     console.log("handleClone=" + event)
    //     this.vcode = event.detail.inputTxtValue
    //     this.callVerifySMS()
    // }
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
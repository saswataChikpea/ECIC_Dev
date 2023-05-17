import { api, LightningElement, track, wire } from 'lwc'
import createAccount from '@salesforce/apex/OnboardingCreateSiteUser.createAccount'
import createProposal from '@salesforce/apex/OnboardingCreateSiteUser.createProposal'
import getProposalData from '@salesforce/apex/OnboardingCreateSiteUser.getProposalData'
// import { getRecord } from 'lightning/uiRecordApi';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import initEmailVerify from '@salesforce/apex/OnboardingCreateSiteUser.initEmailVerify'
import verifyEmail from '@salesforce/apex/OnboardingCreateSiteUser.verifyEmail'
import { createRecord } from 'lightning/uiRecordApi' //updateRecord

import A_verification_code_has_been_sent_to_your_registered_email_address_Please_enter from '@salesforce/label/c.A_verification_code_has_been_sent_to_your_registered_email_address_Please_enter';
import Close from '@salesforce/label/c.Close';
import Password_must_contain from '@salesforce/label/c.Password_must_contain';
import At_least_8_characters from '@salesforce/label/c.At_least_8_characters';
import At_least_1_uppercase_letter from '@salesforce/label/c.At_least_1_uppercase_letter';
import At_least_1_lowercase_letter from '@salesforce/label/c.At_least_1_lowercase_letter';
import At_least_1_number from '@salesforce/label/c.At_least_1_number';
import At_least_1_special_character from '@salesforce/label/c.At_least_1_special_character';
import Back from '@salesforce/label/c.Back';
import Confirm from '@salesforce/label/c.Confirm';
import Company_Name from '@salesforce/label/c.Company_Name';
import First_Name from '@salesforce/label/c.First_Name';
import Last_Name from '@salesforce/label/c.Last_Name';
import Email from '@salesforce/label/c.Email';
import Mobile from '@salesforce/label/c.Mobile';
import User_Id from '@salesforce/label/c.User_Id';
import Password from '@salesforce/label/c.Password';
import Confirm_Password from '@salesforce/label/c.Confirm_Password';
import A_verification_code_has_been_sent_to_your_registered_email_address from '@salesforce/label/c.A_verification_code_has_been_sent_to_your_registered_email_address';
import Sign_up_failed from '@salesforce/label/c.Sign_up_failed';
import Your_email_has_been_verified_successfully from '@salesforce/label/c.Your_email_has_been_verified_successfully';


export default class OnboardingCreateAccount extends LightningElement {
    @track label ={
        A_verification_code_has_been_sent_to_your_registered_email_address_Please_enter,Close,Password_must_contain,At_least_8_characters,
        At_least_1_uppercase_letter,At_least_1_lowercase_letter,At_least_1_number,At_least_1_special_character,Back,
        Confirm,Company_Name,First_Name,Last_Name,Email,Mobile,User_Id,Password,Confirm_Password,A_verification_code_has_been_sent_to_your_registered_email_address,
        Sign_up_failed,Your_email_has_been_verified_successfully
    }
    accountId
    @track error = false
    @track exceptionDetail
    @track vcode
    name = ''

    @api usrId
    @api proposal
    @api retUrl = 'showOnboardingFillInProposal'
    @track isModalOpen = false
    @api verificationStatus
    @api brFile
    isLoaded = false

    passwordHintClass = "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"

    //Select contact.AccountId from user where id='0050x000005gGyGAAU'

    accountOb = {}
    userDetail = {}

    // @wire(getRecord, { recordId: '$usrId', fields: ['contact.AccountId'] })
    // usrRecordsCallback({error, data}){
    //     if(data){
    //         console.log("data= "+JSON.stringify(data, null, '\t'))
    //     }else if(error){
    //         console.error("plan record error= "+JSON.stringify(error, null, '\t'))
    //     }
    // }
    // this.isLocal=true
    // proposal = { "Company_Name__c": "demo", "Company_Legal_Type__c": "Partnership", "Indemnity_Ratio__c": "0", "Registered_Correspondence_Same__c": "true", "Contact_Name__c": "FirstName LastName", "Company_Email__c": "ari@gmail.com", "Mobile_Number__c": "234554353" }

    // @wire(getProposalData, { usrId: '$usrId' })
    // proposalDataCallback({ error, data }) {
    //     if (data) {
    //         console.log("data= " + JSON.stringify(data, null, '\t'))
    //         this.accountId = data.Id
    //         this.proposal = JSON.parse(data.Proposal_Data__c)
    //         this.proposal.Account__c = data.Id

    //         console.log("proposal data= " + JSON.stringify(this.proposal, null, '\t'))

    //         if (this.usrId && (!data.Is_Email_Verified__c)) {
    //             this.callCreateProposal()
    //         }
    //     } else if (error) {
    //         console.error("Unable to read proposal data" + JSON.stringify(error, null, '\t'))
    //         console.error('Error: 04 Unable to load data : ' + error);
    //         console.error('Error: 04 Unable to load data : ' + JSON.stringify(error));
    //         this.error = 'Error: 04 Unable to load data'
    //         if (error.body) {
    //             if (Array.isArray(error.body)) {
    //                 this.exceptionDetail = error.body.map(e => e.message).join(', ')
    //             } else if (typeof error.body.message === 'string') {
    //                 this.exceptionDetail = error.body.message
    //             }
    //         } else {
    //             this.exceptionDetail = error
    //         }
    //     }
    // }



    @track account_fields = [
        { "fieldName": "Account_Name", "valueKey": "Company_Name__c", "readOnly": true, "label": this.label.Company_Name, "placeholder": "Company Name", "required": true, "type": "text" },
        { "fieldName": "FirstName", "valueKey": "First_Name__c", "readOnly": true, "label": this.label.First_Name, "placeholder": "First Name", "required": true, "type": "text" },
        { "fieldName": "LastName", "valueKey": "Last_Name__c", "readOnly": true, "label": this.label.Last_Name, "placeholder": "Last Name", "required": true, "type": "text" },
        { "fieldName": "Email", "valueKey": "Company_Email__c", "readOnly": true, "label": this.label.Email, "placeholder": "Email", "required": true, "type": "text" },
        { "fieldName": "Mobile", "valueKey": "Mobile_Number__c", "readOnly": true, "label": this.label.Mobile, "placeholder": "Mobile", "required": true, "type": "text" },
        { "fieldName": "Username", "valueKey": "Company_Email__c", "readOnly": false, "label": this.label.User_Id, "placeholder": "User Id", "required": true, "type": "text" },
        {
            "fieldName": "Password", "Value": "", "label": this.label.Password, "placeholder": "Password ", "help": "Password must contain:  \
        \at least 8 characters, \
        \at least 1 uppercase letter, \
        \at least 1 lowercase letter, \
        \at least 1 number, \
        \at least 1 special character", "required": true, "type": "password",
            "className": "slds-form-element",
            "iconName": "utility:preview"
        },
        { "fieldName": "Confirm_Password", "label": this.label.Confirm_Password, "placeholder": "Retype password", "required": true, "type": "password" }]

    @track passwordField

    connectedCallback() {
        this.isLoaded = true
        console.log('proposal=' + JSON.stringify(this.proposal))
        console.log('brfile=' + JSON.stringify(this.brFile))
        console.log('onboarding create acc verificationStatus=' + JSON.stringify(this.verificationStatus))
        console.log("userId=>", this.usrId)
        if (this.proposal) {
            this.account_fields.forEach(el => {
                if (el.fieldName == "Password") {
                    this.passwordField = el
                }
                // if (el.valueKey === 'First_Name') {
                //     if (this.proposal.Contact_Name__c) {
                //         const temp = this.proposal.Contact_Name__c.split(" ")
                //         el.Value = this.proposal.Contact_Name__c.replace(temp[temp.length - 1], "")
                //         this.userDetail["FirstName"] = this.proposal.Contact_Name__c.replace(temp[temp.length - 1], "")
                //     }
                // } else if (el.valueKey === 'Last_Name') {
                //     if (this.proposal.Contact_Name__c) {
                //         const temp = this.proposal.Contact_Name__c.split(" ")
                //         el.Value = temp[temp.length - 1]
                //         this.userDetail["LastName"] = temp[temp.length - 1]
                //     }
                // }
                else {
                    if (this.proposal[el.valueKey])
                        el.Value = this.proposal[el.valueKey]
                    this.userDetail[el.fieldName] = this.proposal[el.valueKey]
                }
            })

            this.userDetail["Account_Name"] = this.proposal.Company_Name__c
        }
        // if (this.usrId && (!this.verificationStatus || !this.verificationStatus.EMAIL__c)) {
        //     console.log('callInitEmailVerify=====>')
        //     this.callInitEmailVerify()
        // }
    }
    callInitEmailVerify() {
        this.isLoaded = false
        initEmailVerify({ userId: this.usrId, password: this.password }).then(data => {
            this.isLoaded = true
            console.log('initEmailVerify success :' + JSON.stringify(data))
            try {
                this.showToast(this.label.A_verification_code_has_been_sent_to_your_registered_email_address, "Success!", 'success')
                //now create account and dispatchhandlepagechange from create account method
                console.log(' ====> initEmailVerify')
                //window.location.href = data.siteUrl
                this.showOtpModal()
            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
                this.error = this.label.Sign_up_failed
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
            this.isLoaded = true
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
            this.error = this.label.Sign_up_failed
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
    //{"message":"Token not valid","statusCode":0}
    callVerifyEmail() {
        console.log('======>callVerifyEmail :' + this.vcode)
        this.isLoaded = false
        verifyEmail({ code: this.vcode }).then(data => {//, accountId: this.accountId 
            this.isLoaded = true
            console.log("OTP verification result:::", JSON.stringify(data))
            try {
                if ('statusCode' in data) {
                    if (data.statusCode == 200) {
                        //now create account and dispatchhandlepagechange from create account method
                        console.log("message:  ", "Your email has been verified successfully")
                        //window.location.href = data.siteUrl
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Success!',
                            message: this.label.Your_email_has_been_verified_successfully,
                            variant: 'success'
                        }))
                        this.updateAccount()//update is email verified
                    } else {
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Error!',
                            message: this.getProperErrorMessage(data.message + ''),
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
                this.error = this.label.Sign_up_failed
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
            this.isLoaded = true
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
            this.error = this.label.Sign_up_failed
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

    //set email verified true
    updateAccount() {
        let record = {
            fields: {
                Id: this.accountId,
                Is_Email_Verified__c: true,
            },
        };
        /*
        updateRecord(record)
            // eslint-disable-next-line no-unused-vars
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record Is Updated',
                        variant: 'success',
                    }),
                );

                //show account creation successful page
                this.showAccountCreationSuccessful()
            })
            .catch(error => {
                console.error('Error: 02 Cannot update Account : ' + error);
                console.error('Error: 02 Cannot update Account : ' + JSON.stringify(error));
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
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Error on data save',
                //         message: error.message.body,
                //         variant: 'error',
                //     }),
                // );
            });
            */

        let record1 = {
            apiName: 'Verification_Method__c',
            fields: {
                Account__c: this.accountId,
                EMAIL__c: true
            },
        };
        createRecord(record1)
            // eslint-disable-next-line no-unused-vars
            .then(() => {
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Success',
                //         message: 'Record Is Updated',
                //         variant: 'success',
                //     }),
                // );
                console.log("success: verification method object updated");
                //show account creation successful page
                this.showAccountCreationSuccessful()
            })
            .catch(error => {
                console.error('Error: 03 Cannot create verification method: ' + error);
                console.error('Error: 03 Cannot create verification method: ' + JSON.stringify(error));
                this.error = this.label.Sign_up_failed
                if (error.body) {
                    if (Array.isArray(error.body)) {
                        this.exceptionDetail = error.body.map(e => e.message).join(', ')
                    } else if (typeof error.body.message === 'string') {
                        this.exceptionDetail = error.body.message
                    }
                } else {
                    this.exceptionDetail = error
                }
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Error on data save',
                //         message: error.message.body,
                //         variant: 'error',
                //     }),
                // );
            });
    }

    handleInputChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        try {
            console.log('targetName=' + targetName)
            console.log('targetValue=' + targetValue)
            this.validateField(targetName)
        } catch (e) {
        }
    }
    validateField(targetName) {
        let inputField = this.template.querySelector(`[data-id='${targetName}']`);
        let targetValue = inputField.value
        if (targetName == "Password") {
            this.passwordField.Value = targetValue
            if (!this.checkPassword(targetValue)) {
                this.passwordField.errMsg = "The password requirements are not met."
                this.passwordField.className = "slds-form-element slds-has-error"
                return false
            }
            else {
                // inputField.setCustomValidity("");
                // inputField.reportValidity();
                this.passwordField.errMsg = ""
                this.passwordField.className = "slds-form-element"
                this.passwordField.Value = targetValue
                this.userDetail[targetName] = targetValue
                return true
            }
        } else if (targetName == 'Confirm_Password') {
            let inputField = this.template.querySelector(`[data-id='${targetName}']`);
            if (targetValue != this.userDetail.Password) {
                inputField.setCustomValidity("Comfirm password doesn't match");
                inputField.reportValidity();
                return false
            }
            else {
                inputField.setCustomValidity("");
                inputField.reportValidity();
                this.userDetail[targetName] = targetValue
                return true
            }
        } else {
            this.userDetail[targetName] = targetValue
            return true
        }
    }
    handlePasswordShowHide() {
        // if (this.passwordField.type == 'password') {
        //     this.passwordField.ty
        // }
        console.log("vlavlaj")
        this.passwordField.type = this.passwordField.type == 'password' ? 'text' : 'password'
        this.passwordField.iconName = this.passwordField.type == 'password' ? "utility:preview" : "utility:hide"
    }
    checkPassword = (password) => {
        return !!password.match(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#_?!@$%^&*-]).{8,}$/)
    };
    togglePasswordHint() {
        console.log(this.passwordHintClass)
        this.passwordHintClass = this.passwordHintClass == 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"
    }


    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }

    // handleTermAndConditionsSubmit(event) {

    //     if (!this.proposal) {
    //         this.proposal = { Account__c: '0012100000v1WHFAA2', Company_Name__c: 'test1' }
    //     }//TODO: hard code
    //     console.log("Terms and condition accepted")

    //     this.accountOb.Name = this.userDetail.Account_Name
    //     //this.accountOb.Name = userDetail.Name //TODO: add more account fields

    //     console.log("accountOb: " + JSON.stringify(this.accountOb))
    //     console.log("proposal: " + JSON.stringify(this.proposal))
    //     console.log("userDetail: " + JSON.stringify(this.userDetail))
    //     this.isModalOpen = false;
    //     this.callCreateAccount()
    // }
    getProperErrorMessage(msg) {
        if (msg.toLowerCase().includes('already exists')) {
            return "This email ID already exists."
        } else if (msg.toLowerCase().includes("token not valid")) {
            return "Incorrect verification code."
        } else {
            return msg
        }
    }

    callCreateAccount() {
        this.accountOb.Name = this.userDetail.Account_Name
        //this.accountOb.Name = userDetail.Name //TODO: add more account fields
        this.isLoaded = false
        console.log("accountOb: " + JSON.stringify(this.accountOb))
        console.log("userDetail: " + JSON.stringify(this.userDetail))

        if (!this.validateField("Password") || !this.validateField('Confirm_Password')) {
            return
        }
        console.log("all valid fields")


        const proposal_st = JSON.stringify(this.proposal)
        createAccount({ accDetail: this.accountOb, userDetail: this.userDetail, proposal: proposal_st, brFile: this.brFile, brNo: this.proposal.BR_Number__c }).then(data => {
            this.isLoaded = true
            console.log('createAccount success :' + JSON.stringify(data))
            try {
                //now create account and dispatchhandlepagechange from create account method
                console.log(' ====> handleOnboardingFillInProposal')
                window.location.href = data.siteUrl
            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
                this.error = this.label.Sign_up_failed
                if (error.body) {
                    if (Array.isArray(error.body)) {
                        this.exceptionDetail = error.body.map(e => e.message).join(', ')
                    } else if (typeof error.body.message === 'string') {
                        this.exceptionDetail = error.body.message.replace('[', '').replace(']', '')
                        this.showToast(this.getProperErrorMessage(error.body.message.replace('[', '').replace(']', '')))
                    }
                } else {
                    this.exceptionDetail = error
                }
            }
        }).catch(error => {
            this.isLoaded = true
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
            this.error = this.label.Sign_up_failed
            if (error.body) {
                if (Array.isArray(error.body)) {
                    this.exceptionDetail = error.body.map(e => e.message).join(', ')
                } else if (typeof error.body.message === 'string') {
                    this.exceptionDetail = error.body.message.replace('[', '').replace(']', '')
                    this.showToast(this.getProperErrorMessage(error.body.message.replace('[', '').replace(']', '')))
                }
            } else {
                this.exceptionDetail = error
            }
        });
    }

    callCreateProposal() {
        //alert('callCreateProposal')
        console.log("callCreateProposal: " + JSON.stringify(this.proposal))
        createProposal({ proposal: this.proposal }).then(data => {
            console.log(' ====> created Proposal id =', data)
            console.log("create proposal success: " + JSON.stringify(data))
            this.proposal['Proposal_Id'] = data
            // const event1 = new CustomEvent('handlepagechange', {
            //     // detail contains only primitives
            //     detail: { pageId: 'showOnboardingFillInProposal', proposal: this.proposal}
            // });
            // this.dispatchEvent(event1)
        }).catch(error => {
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
    showOtpModal() {
        console.log(' ====> showOtpModal')
        const modal = this.template.querySelector('c-custom-modal')
        modal.showModal()
    }
    handleOTP(event) {
        console.log("handleClone=" + event)
        this.vcode = event.detail.inputTxtValue
        this.callVerifyEmail()
    }
    resendOTP(event) {
        console.log("Requesting for resend");
        this.callInitEmailVerify()
    }
    showPrevious() {
        console.log(' ====> showPrevious')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: "showOnboardingTermsAndConditions" }
        });
        this.dispatchEvent(event1)
    }
    showAccountCreationSuccessful() {
        console.log(' ====> showAccountCreationSuccessful')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: "showOnboardingACConfirm", proposal: this.proposal }
        });
        this.dispatchEvent(event1)
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
}
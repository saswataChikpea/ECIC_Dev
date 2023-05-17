import { LightningElement } from 'lwc';
import createAccount from '@salesforce/apex/OnboardingCreateSiteUser.createAccount'
import checkDupliateEmail from '@salesforce/apex/OnboardingCreateSiteUser.checkDupliateEmail'
import EmailVerifySuccessful from '@salesforce/apex/OnboardingCreateSiteUser.EmailVerifySuccessful'

import applyProposalAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyProposalAura'
import amendProposalAura from '@salesforce/apex/ECIC_API_PolicyMgmt.amendProposalAura'
import applyQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyQuoteAura'
import ammendQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.ammendQuoteAura'
import getProposalData from '@salesforce/apex/OnboardingCreateSiteUser.getProposalData';
import updateProposal from "@salesforce/apex/OnboardingCreateSiteUser.updateProposal";
import createProposal from "@salesforce/apex/OnboardingCreateSiteUser.createProposal";
import UsrId from '@salesforce/user/Id'
import checkTermOthPcyPHAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkTermOthPcyPHAura'//6.8

import saveAuthorizedPersons from "@salesforce/apex/OnboardingCreateSiteUser.saveAuthorizedPersons";
import updateBRDocument from "@salesforce/apex/OnboardingCreateSiteUser.updateBRDocument";


export default class DummyAccountCreation extends LightningElement {
    usrId = UsrId

    accountOb = { "Name": "arindam" }
    userDetail = {
        "Account_Name": "ecic test data", "FirstName": "", "LastName": "aridummy5", "Email": "arindam@chikpea.com", "Mobile": "237",
        "Username": "aridummy5@chikpea.com", "Password": "Get2work$", "Confirm_Password": "Get2work$"
    }
    brFile = {
        "file": "2FtrcXmzT9i69ZtGDEiBBEREY%2BFBLlcjqiodZBIJFiwYAHs7bu0Sp8CNKKgQAghhBCNKCgQQgghRCMKCoQQQgjRiIICIYQQQjT6P8%2BQ4O5m9dX6AAAAAElFTkSuQmCC",
        "filename": "zen7.png"
    }

    // dummyProposal = { 'Account__c': '0010l00001MgliIAAR', "company_name__c": "supchinese", "company_email__c": "saswata@chikpea.com", "Past_Turnover__c": "HKD 10,000,001 – 20,000,000", "Future_Turnover__c": "HKD 20,000,001 – 30,000,000", "Insurable_Turnover__c": 123, "Sales_Amount_Range__c": 321, "Insurable_Buyers__c": "123", "Self_Approving_CL__c": "No", "Buyer_Country_Market__c": "ALAND ISLANDS;ALBANIA", "Product__c": "a070l00000Aj0x5AAB", "Indemnity_Ratio__c": "20", "NQL__c": "5", "Base_Rate_Per_Anum__c": 1.2, "Base_Loading__c": 40, "Policy_Type__c": "56", "Indemnity_Percentage__c": "60", "NQL_Amount__c": "50000", "Auto_Renewal__c": "Automatic Renewal", "Language_of_Correspondence__c": "English", "Policy_Commence_Date__c": "2021-12-01", "Maximum_Liability__c": "1500000", "Company_Legal_Type__c": "Partnership", "Bank_Account__c": "false", "Payment_Option__c": "One-Off", "Goods_And_Service__c": "12", "Bad_Debt_Amount__c": 123121, "Overdue_Amount__c": 123131, "BR_Number__c": "12312312", "BR_Expiry_Date__c": "2022-02-25", "BR_Document__c": "TEST_UPLOAD - Copy.pdf", "Corporate_Incorporation_Date__c": "2021-10-31", "Registered_Territory__c": "KOWLOON", "Registered_District__c": "SHAM SHUI PO", "Registered_Correspondence_Same__c": "true", "Correspondence_Territory__c": "KOWLOON", "Correspondence_District__c": "SHAM SHUI PO", "Application_Reason__c": "Financing", "Contact_Name__c": "Saswata Chinese", "Title__c": "test", "Company_Telephone_Number__c": "1235467890", "Know_About_Hkecic__c": "Advertisement: Magazine", "Benificiary_Owners__c": "[{\"name\":\"test\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"test\",\"FirstName\":\"\"}]", "Buyer_List__c": "[{\"name\":\"\",\"address\":\"\",\"country\":\"\",\"key\":0,\"editable\":true}]", "Registered_Address_Line_1__c": "23351 lane", "Registered_Address_Line_2__c": "", "Registered_Address_Line_3__c": "", "Correspondence_Address_Line_1__c": "23351 lane", "Correspondence_Address_Line_2__c": "", "Correspondence_Address_Line_3__c": "", "Country_Market_Of_Shipment__c": "[{\"no\":1,\"country\":\"Algeria\",\"percentage\":100,\"key\":0,\"editable\":true}]", "Destination_Country_Market__c": "[{\"no\":1,\"country\":\"Algeria\",\"percentage\":100,\"key\":0,\"editable\":true}]", "Country_Market_Of_Origin__c": "[{\"no\":1,\"country\":\"Bahrain\",\"percentage\":100,\"key\":0,\"editable\":true}]", "Receive_Date__c": "2021-11-05", "Mobile_Number__c": "123123121" }
    dummyProposal = { 'Account__c': '0015Y000039KZRqQAO', "Company_Name__c": "TEST", "Company_Email__c": "arindam@chikpea.com", "Past_Turnover__c": "HKD 1-10,000,000", "Future_Turnover__c": "HKD 20,000,001 – 30,000,000", "Insurable_Turnover__c": 765, "Insurable_Buyers__c": "765", "Sales_Amount_Range__c": 65, "Self_Approving_CL__c": "Yes", "Buyer_Country_Market__c": "ETHIOPIA", "Product__c": "a005Y00002IIL4TQAX", "Indemnity_Percentage__c": "0", "Policy_Type__c": "70", "Base_Rate_Per_Quarter__c": 0.8, "Final_Premium_Rate__c": "0.80", "Indemnity_Ratio__c": "90", "Auto_Renewal__c": "Automatic Renewal", "Language_of_Correspondence__c": "English", "Maximum_Liability__c": 500000, "Company_Legal_Type__c": "LTDC", "Bank_Account__c": "true", "Goods_And_Service__c": "451301", "Bad_Debt_Amount__c": 765, "Overdue_Amount__c": 765, "Benificiary_Owners__c": "[{\"name\":\"Arindam Director\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"Director\",\"FirstName\":\"Arindam\"}]", "Buyer_List__c": "[{\"name\":\"\",\"address\":\"\",\"country\":\"\",\"key\":0,\"editable\":true}]", "Registered_Address_Line_1__c": "line1", "Registered_Address_Line_2__c": "", "Registered_Address_Line_3__c": "", "Correspondence_Address_Line_1__c": "line1", "Correspondence_Address_Line_2__c": "", "Correspondence_Address_Line_3__c": "", "Country_Market_Of_Shipment__c": "[{\"no\":1,\"country\":\"\",\"percentage\":\"\",\"key\":0,\"editable\":true}]", "Destination_Country_Market__c": "[{\"no\":1,\"country\":\"\",\"percentage\":\"\",\"key\":0,\"editable\":true}]", "Country_Market_Of_Origin__c": "[{\"no\":1,\"country\":\"\",\"percentage\":\"\",\"key\":0,\"editable\":true}]", "Receive_Date__c": "2022-02-15", "Company_Legal_Type_Label__c": "Limited Co.", "Goods_And_Service_Label__c": "Export trading of canned foods", "BR_Number__c": "22222222", "BR_Expiry_Date__c": "2028-02-23", "BR_Document__c": "ecic-banner.png", "Corporate_Incorporation_Date__c": "2022-01-30", "Registered_Territory__c": "New Territories", "Registered_District__c": "Kwai Chung", "Registered_Correspondence_Same__c": "true", "Correspondence_Territory__c": "New Territories", "Correspondence_District__c": "Kwai Chung", "Application_Reason__c": "Credit Control", "First_Name__c": "Arindam", "Last_Name__c": "Mondal", "Title__c": "TEST", "Company_Telephone_Number__c": "234536", "Mobile_Number__c": "87687678", "Enable_SMS_Notification__c": "true", "Know_About_Hkecic__c": "REF-PH" }
    callcreateproposal() {
        createProposal({ proposal: this.dummyProposal }).then(data => {
            console.log("createProposal::", data);

        }).catch(error => {
            console.error(error);
        })
    }
    createAccount() {
        const proposal_st = JSON.stringify(this.proposal)
        createAccount({ accDetail: this.accountOb, userDetail: this.userDetail, proposal: proposal_st, brFile: this.brFile }).then(data => {
            this.isLoaded = true
            console.log('createAccount success :' + JSON.stringify(data))
            try {
                //now create account and dispatchhandlepagechange from create account method
                console.log(' ====> handleOnboardingFillInProposal')
                window.location.href = data.siteUrl
            } catch (error) {
                console.error('Error: 01 Cannot create Account : ');
                console.error('Error: 01 Cannot create Account : ' + JSON.stringify(error));
                this.error = 'Sign up failed'

            }
        }).catch(error => {
            this.isLoaded = true
            console.error('Error: 02 Cannot create Account : ' + error);
            console.error('Error: 02 Cannot create Account : ' + JSON.stringify(error));
            this.error = 'Sign up failed'
            if (error.body) {
                if (Array.isArray(error.body)) {
                    this.exceptionDetail = error.body.map(e => e.message).join(', ')
                } else if (typeof error.body.message === 'string') {
                    this.exceptionDetail = error.body.message.replace('[', '').replace(']', '')
                    // this.showToast(this.getProperErrorMessage(error.body.message.replace('[', '').replace(']', '')))
                }
            } else {
                this.exceptionDetail = error
            }
        });
    }
    updateProposalclick() {
        const temp = {
            Id: 'a0B0l00000ACLPuEAP',
            Is_Legacy_Verified__c: "true"
            // Legacy_Response__c: "JSON.stringify(data)"
        }
        console.log("call updateProposal::", temp);
        updateProposal({ p: temp }).then(data => {
            console.log("updateProposal success:", data)
        }).catch(error => {
            console.log("updateProposal error:", error)
        })

    }
    getProperErrorMessage(msg) {
        if (msg.toLowerCase().includes('already exists')) {
            return "This email ID already exists."
        } else if (msg.toLowerCase().includes("token not valid")) {
            return "Incorrect verification code."
        }
        return msg

    }
    updateBrDocument() {
        updateBRDocument({ userId: this.usrId }).then(data => {
            console.log("Br docuemnt updated successfully.", data);
        }).catch(error => {
            console.error("Br update failed::", JSON.stringify(error));
        })
    }

    callCreateProposalAPI() {
        console.log("callCreateProposalAPI::");
        applyProposalAura({ jsonObject: this.proposalAPIData }).then(data => {
            console.log("applyProposalAura", data);
            // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"cus_no":"372530"}}
        }).catch(error => {
            // {"rtn_code":"-1","rtn_msgs":[{"msg_id":1,"msg_code":"-21","msg_data":"cus_no/pcy_type","msg_desc":"Record already exists"}],"meta_data":null}
            // this.showToast("Something went wrong creating proposal. Please try again")
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
    callAmendProposalAura() {
        console.log('amendProposalAura::');
        let jsonObject = {
            "ACCOUNT_ID": '0010l00001M1JWqAAN',
            "PROPOSAL_ID": 'a0B0l00000AAgojEAD',
            "PCY_TYPE": 51,
            CUS_NO: 372526,
            "BR_NO": '23456789',
            // MAJ_MKT_1: "USA",
            // MAJ_MKT_2: "HKG",
            // MAJ_MKT_3: "CHN"
            IND_CODE: "451402"
        }
        amendProposalAura({ jsonObject: jsonObject }).then(data => {
            console.log("amendProposalAura::", data);
            // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"result":"N"}}
        }).catch(error => {
            // this.showToast("Something went wrong creating proposal. Please try again")
            console.error('Error: 03 Cannot ammend proposal : ' + error);
            console.error('Error: 03 Cannot ammend proposal : ' + JSON.stringify(error));
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
    callCreateQuotationAPI() {
        console.log("callCreateQuotationAPI::");
        applyQuoteAura({ jsonObject: this.quotationData }).then(data => {
            console.log("applyQuoteAura::", data);
            // {"rtn_code":"1","rtn_msgs":null,"meta_data":null}
        }).catch(error => {
            // this.showToast("Something went wrong creating proposal. Please try again")
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
    }
    callAmmendQuoteAura() {
        console.log('ammendQuoteAura::');
        let jsonObject = {
            ACCOUNT_ID: "0010l00001M1JWqAAN",
            PROPOSAL_ID: "a0B0l00000AAgojEAD",
            QUOTATION_ID: "a0H5D000003u7SAUAY",
            CUS_NO: 372526,
            PCY_TYPE: "51",
            ISS_DATE: "2021-10-21",
            ACC_DATE: "2021-10-21",//********Acceptence Date before acceptance or after */
            STS: "R",
            QUO_EXP_DATE: "2021-10-30"
        }
        ammendQuoteAura({ jsonObject: jsonObject }).then(data => {
            console.log("ammendQuoteAura::", data);
            // {"rtn_code":"1","rtn_msgs":null,"meta_data":null}
        }).catch(error => {
            // this.showToast("Something went wrong creating proposal. Please try again")
            console.error('Error: 03 Cannot ammend quotation : ' + error);
            console.error('Error: 03 Cannot ammend quotation : ' + JSON.stringify(error));
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

    checkHoldOSOnlinePlcyAuraAPI() {
        checkTermOthPcyPHAura({ PCY_TYPE: "70", BR_NO: "22222226" }).then(data => {//6.8 To check if the prospect has any offline proposal / quotation
            console.log("checkTermOthPcyPHAura 6.8::", data);
            const res2 = JSON.parse(data).meta_data
            if (res2.result == 'N') {
                this.verificationCompletionCount += 1
                this.followUpcreateVerification()
            } else {
                this.showToast('This BR number is already used by another active policy')
            }
        }).catch(error => {
            console.log("checkTermOthPcyPHAura::error", error);
            this.showToast('Something went wrong. Please try again later.')
        })

    }

    callsaveAuthorizedPersons() {
        let d = [
            {
                "name": "arindam",
                "type": "Director",
                "key": 0,
                "editable": true,
                "LastName": "arindam",
                "FirstName": ""
            }
        ]
        saveAuthorizedPersons({ data: JSON.stringify(d), accId: '0010l00001M1JWqAAN' })
    }

    // Is Legacy Verified checkbox
    // Legacy Response long text
    // Customer Number string 6
    // Proposal Record Id number
    // Error Code string
    // Reason For Termination
    proposal = {
        "Company_Name__c": "ari31",
        "Company_Email__c": "arindam@chikpea.com",
        "Past_Turnover__c": "HKD 10,000,001 – 20,000,000",
        "Future_Turnover__c": "HKD 1-10,000,000",
        "Insurable_Turnover__c": "4",
        "Sales_Amount_Range__c": "4",
        "Insurable_Buyers__c": "4",
        "Self_Approving_CL__c": "No",
        "Buyer_Country_Market__c": "Australia",
        "Product__c": "a070l00000Aj0x6AAB",
        "Indemnity_Ratio__c": "0",
        "Auto_Renewal__c": "Automatic Renewal",
        "Policy_Commence_Date__c": "2021-10-01",
        "Company_Legal_Type__c": "Partnership",
        "Bank_Account__c": "true",
        "Payment_Option__c": "Quarterly",
        "Goods_And_Service__c": "Artificial Flowers",
        "Language_Of_Correspondence__c": "English",
        "Overdue_Amount__c": "4",
        "Bad_Debt_Amount__c": "4",
        "Benificiary_Owners__c": "[{\"name\":\"sdfds\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"sdfds\",\"FirstName\":\"\"}]",
        "Buyer_List__c": "[{\"name\":\"\",\"address\":\"\",\"country\":\"\",\"key\":0,\"editable\":true}]",
        "Company_Address_Registered__c": "{\"readOnly\":false,\"address_line_1\":\"1\",\"address_line_2\":\"\",\"address_line_3\":\"\",\"terriitory\":\"\",\"district\":\"\"}",
        "Company_Address_Correspondence__c": "{\"readOnly\":true,\"address_line_1\":\"1\",\"address_line_2\":\"\",\"address_line_3\":\"\",\"terriitory\":\"\",\"district\":\"\"}",
        "Country_Market_Of_Shipment__c": "[{\"no\":1,\"country\":\"\",\"percentage\":0,\"key\":0,\"editable\":true}]",
        "Destination_Country_Market__c": "[{\"no\":1,\"country\":\"\",\"percentage\":0,\"key\":0,\"editable\":true}]",
        "Country_Market_Of_Origin__c": "[{\"no\":1,\"country\":\"\",\"percentage\":0,\"key\":0,\"editable\":true}]",
        "BR_Number__c": "45645456",
        "BR_Expiry_Date__c": "2021-09-30",
        "BR_Document__c": "zen5.png",
        "Corporate_Incorporation_Date__c": "2021-09-12",
        "Registered_Territory__c": "Kowloon",
        "Registered_District__c": "Tsim Sha Tsui",
        "Registered_Correspondence_Same__c": "true",
        "Correspondence_Territory__c": "Kowloon",
        "Correspondence_District__c": "Tsim Sha Tsui",
        "Application_Reason__c": "Credit Control",
        "Contact_Name__c": "ari",
        "Title__c": "abc",
        "Company_Telephone_Number__c": "34",
        "Mobile_Number__c": "34",
        "Know_About_Hkecic__c": "Facebook"
    }
    quotationData = {
        ACCOUNT_ID: "0010l00001M1JWqAAN",
        PROPOSAL_ID: "a0B0l00000AAgojEAD",
        QUOTATION_ID: "a0H5D000003u7SAUAY",
        CUS_NO: 372526,
        PCY_TYPE: "51",
        ISS_DATE: "2021-10-21",
        ACC_DATE: "2021-10-21",//********Acceptence Date before acceptance or after */
        STS: "A",
        QUO_EXP_DATE: "2021-10-30"
    }
    proposalAPIData = {
        "ACCOUNT_ID": '0010l00001M1JWqAAN',
        "PROPOSAL_ID": 'a0B0l00000AAgojEAD',
        "PCY_TYPE": 51,
        "RECV_DATE": '2021-10-20',
        "BR_NO": '23456789',
        "STS": 'O',
        // "ISS_DATE": '2021-10-08',
        // "EXP_LAST_FY_TOT_TO": 500,
        // "EXP_LAST_FY_LC_TO": 500,
        // "EXP_LAST_FY_DP_DA_OA_TO": 500,
        // "EXP_NEXT_FY_TOT_TO": 500,
        // "EXP_NEXT_FY_LC_TO": 500,
        // "EXP_NEXT_FY_DP_DA_OA_TO": 500,
        // "BYR_CNT_UP_TO_1M": 500,
        // "BYR_CNT_1M_TO_5M": 500,
        // "BYR_CNT_OVER_5M": 500,
        // "LAST_BYR_CNT_UP_TO_1M": 500,
        // "LAST_BYR_CNT_1M_TO_5M": 500,
        // "LAST_BYR_CNT_OVER_5M": 500,
        "LAST_2_YR_BAD_DEBT": 50000,
        "OVER_30_DAY_OD_AMT": 500,

        "IM_PCT": 80,
        // "REF_BY_LIST": 'Advertisement: MTR',
        // "BIZ_NATURE": 'E',
        // "MAJ_MKT_1": 'USA',
        // "MAJ_MKT_2": 'HKG',
        // "MAJ_MKT_3": 'CHN',
        "IND_CODE": '451204',
        "RVW_EXP_DATE": '2021-11-08',

        "CUS_NAME": 'Abc Ltd',
        "SETUP_DATE": '2010-01-01',
        "LEGAL_TYPE": 'PROP',
        "BR_EXP_DATE": '2022-01-01',
        "OFF_ADDR_1": 'Address 1',
        "OFF_ADDR_2": 'Address 2',
        "OFF_ADDR_3": 'Address 3',
        "OFF_ADDR_4": 'Hong Kong',
        "OFF_ADDR_DIST": 'Kennedy Town',
        "COR_ADDR_1": 'Address 1',
        "COR_ADDR_2": 'Address 2',
        "COR_ADDR_3": 'Address 3',
        "COR_ADDR_4": 'Hong Kong',
        "COR_ADDR_DIST": 'Kennedy Town',

        "LANG_TYPE": 'E',
        "CONT_PERSON_NAME": 'Arindam Mondal',
        "CONT_PERSON_TITLE": 'CEO',
        "CONT_PERSON_EMAIL": 'arindam@chikpea.com',
        "CONT_PERSON_MOBILE": '03218211046',
        "RENEWAL": "AUTO",
        "APP_REASON": "Credit Control",
        "CONT_PERSON_ID": "0010l00001M1JWqAAN",
        "BYR_CNT_OVER_5M": 1,
        "LAST_BYR_CNT_OVER_5M": 1

    }//{"rtn_code":"1","rtn_msgs":null,"meta_data":{"cus_no":"372526"}}
    proposalAPIDataFull = {
        "PCY_TYPE": null,
        "RECV_DATE": null,
        "BR_NO": null,
        "STS": null,
        "ISS_DATE": null,
        "EXP_LAST_FY_TOT_TO": null,
        "EXP_LAST_FY_LC_TO": null,
        "EXP_LAST_FY_DP_DA_OA_TO": null,
        "EXP_NEXT_FY_TOT_TO": null,
        "EXP_NEXT_FY_LC_TO": null,
        "EXP_NEXT_FY_DP_DA_OA_TO": null,
        "BYR_CNT_UP_TO_1M": null,
        "BYR_CNT_1M_TO_5M": null,
        "BYR_CNT_OVER_5M": null,
        "LAST_BYR_CNT_UP_TO_1M": null,
        "LAST_BYR_CNT_1M_TO_5M": null,
        "LAST_BYR_CNT_OVER_5M": null,
        "LAST_2_YR_BAD_DEBT": null,
        "OVER_30_DAY_OD_AMT": null,
        "DOM_LAST_FY_TOT_TO": null,
        "DOM_LAST_FY_LC_TO": null,
        "DOM_LAST_FY_DP_DA_OA_TO": null,
        "DOM_NEXT_FY_TOT_TO": null,
        "DOM_NEXT_FY_LC_TO": null,
        "DOM_NEXT_FY_DP_DA_OA_TO": null,
        "IM_PCT": null,
        "REF_BY_LIST": null,
        "BIZ_NATURE": null,
        "BIZ_NATURE_OTH_DESC": null,
        "SUBM_MEANS": null,
        "MAJ_MKT_1": null,
        "MAJ_MKT_2": null,
        "MAJ_MKT_3": null,
        "IND_CODE": '451438',
        "GOODS_DESC": null,
        "GOODS_PCT": null,
        "RVW_EXP_DATE": null,
        "PRM_RATE": [
            {
                "CTRY_GDE": null,
                "DP_PM_RATE": null,
                "DA_UPTO_30_PM_RATE": null,
                "DA_UPTO_60_PM_RATE": null,
                "DA_UPTO_90_PM_RATE": null,
                "DA_UPTO_120_PM_RATE": null,
                "DA_UPTO_150_PM_RATE": null,
                "DA_UPTO_180_PM_RATE": null,
                "DA_UPTO_210_PM_RATE": null,
                "DA_UPTO_240_PM_RATE": null,
                "DA_UPTO_270_PM_RATE": null,
                "DA_UPTO_300_PM_RATE": null,
                "DA_UPTO_330_PM_RATE": null,
                "DA_UPTO_360_PM_RATE": null,
                "PRE_SHP_PM_RATE": null
            }
        ],
        "SP_RATE": [
            {
                "SP_BYR_CTRY": null,
                "SP_BYR_CODE": null,
                "SP_EFF_DATE": null,
                "SP_DP_PM_RATE": null,
                "SP_DA_UPTO_30_PM_RATE": null,
                "SP_DA_UPTO_60_PM_RATE": null,
                "SP_DA_UPTO_90_PM_RATE": null,
                "SP_DA_UPTO_120_PM_RATE": null,
                "SP_DA_UPTO_150_PM_RATE": null,
                "SP_DA_UPTO_180_PM_RATE": null,
                "SP_DA_UPTO_210_PM_RATE": null,
                "SP_DA_UPTO_240_PM_RATE": null,
                "SP_DA_UPTO_270_PM_RATE": null,
                "SP_DA_UPTO_300_PM_RATE": null,
                "SP_DA_UPTO_330_PM_RATE": null,
                "SP_DA_UPTO_360_PM_RATE": null,
                "SP_PRE_SHP_RM_RATE": null
            }
        ],
        "COMMENCE_DATE": null,
        "REVIEW_DATE": null,
        "ML": null,
        "FACE_VALUE": null,
        "PRM_LOADING": null,
        "PCY_DEPOSIT": null,
        "PCY_FEE": null,
        "UW_IM_PCT": null,
        "PCY_ISS_DATE": null,
        "PORT_OF_LDG": [
            {
                "SEQ_NO": null,
                "CTRY_CODE": null,
                "PCT_SHARE": null
            }
        ],
        "DEST_CTRY": [
            {
                "SEQ_NO": null,
                "CTRY_CODE": null,
                "PCT_SHARE": null
            }
        ],
        "ORG_CTRY": [
            {
                "SEQ_NO": null,
                "CTRY_CODE": null,
                "PCT_SHARE": null
            }
        ],
        "CUS_NAME": null,
        "SETUP_DATE": null,
        "LEGAL_TYPE": null,
        "BR_EXP_DATE": null,
        "OFF_ADDR_1": null,
        "OFF_ADDR_2": null,
        "OFF_ADDR_3": null,
        "OFF_ADDR_4": null,
        "OFF_ADDR_DIST": null,
        "COR_ADDR_1": null,
        "COR_ADDR_2": null,
        "COR_ADDR_3": null,
        "COR_ADDR_4": null,
        "COR_ADDR_DIST": null,
        "CUS_NAME_HK": null,
        "OFF_ADDR_1_HK": null,
        "OFF_ADDR_2_HK": null,
        "OFF_ADDR_3_HK": null,
        "OFF_ADDR_4_HK": null,
        "OFF_ADDR_DIST_HK": null,
        "COR_ADDR_1_HK": null,
        "COR_ADDR_2_HK": null,
        "COR_ADDR_3_HK": null,
        "COR_ADDR_4_HK": null,
        "COR_ADDR_DIST_HK": null,
        "COM_TEL_NO": null,
        "LANG_TYPE": null,
        "CONT_PERSON_NAME": null,
        "CONT_PERSON_TITLE": null,
        "CONT_PERSON_EMAIL": null,
        "CONT_PERSON_MOBILE": null,
        "CONT_PERSON_SUBC": null,
        "AUTH_PERSON": [
            {
                "AUTH_TYPE": null,
                "AUTH_NAME": null
            }
        ]
    }
    getPolicyCode(policyName) {
        if (policyName == 'SBP') {
            return '51';
        }
        else if (policyName == 'SUP') {
            return '56';
        }
        else if (policyName == 'OMBP') {
            return '70';
        }
    }
    connectedCallback() {
        this.prepareProposal()
        checkDupliateEmail({ usrId: this.usrId }).then(data => {
            console.log('checkDupliateEmail::', JSON.stringify(data));
        }).catch(error => {
            console.error('checkDupliateEmail:: ', JSON.stringify(error));
        })
    }
    updateAccVerification() {

        EmailVerifySuccessful({ usrId: this.usrId }).then(data => {
            console.log('EmailVerifySuccessful::', JSON.stringify(data));
        }).catch(error => {
            console.error('EmailVerifySuccessful:: ', JSON.stringify(error));
        })
    }
    prepareProposal() {
        let proposalAPIData1 = {
            "ACCOUNT_ID": '0010l00001M1JWqAAN',
            "PROPOSAL_ID": 'a0B0l00000AAgojEAD',
            "PCY_TYPE": this.getPolicyCode('SBP'),//HC
            "RECV_DATE": '2021-10-08',
            "BR_NO": this.proposal.BR_Number__c,
            "STS": 'O',
            "ISS_DATE": '2021-10-08',
            "EXP_LAST_FY_TOT_TO": 500,
            "EXP_LAST_FY_LC_TO": 500,
            "EXP_LAST_FY_DP_DA_OA_TO": 500,
            "EXP_NEXT_FY_TOT_TO": 500,
            "EXP_NEXT_FY_LC_TO": 500,
            "EXP_NEXT_FY_DP_DA_OA_TO": 500,
            "BYR_CNT_UP_TO_1M": 500,
            "BYR_CNT_1M_TO_5M": 500,
            "BYR_CNT_OVER_5M": 500,
            "LAST_BYR_CNT_UP_TO_1M": 500,
            "LAST_BYR_CNT_1M_TO_5M": 500,
            "LAST_BYR_CNT_OVER_5M": 500,
            "LAST_2_YR_BAD_DEBT": 500,
            "OVER_30_DAY_OD_AMT": 500,

            "IM_PCT": 80,
            "REF_BY_LIST": 'Advertisement: MTR',
            "BIZ_NATURE": 'E',
            "MAJ_MKT_1": 'USA',
            "MAJ_MKT_2": 'HKG',
            "MAJ_MKT_3": 'CHN',
            "IND_CODE": '451438',
            "RVW_EXP_DATE": '2021-11-08',

            "CUS_NAME": 'Abc Ltd',
            "SETUP_DATE": '2010-01-01',
            "LEGAL_TYPE": 'PROP',
            "BR_EXP_DATE": '2022-01-01',
            "OFF_ADDR_1": 'Address 1',
            "OFF_ADDR_2": 'Address 2',
            "OFF_ADDR_3": 'Address 3',
            "OFF_ADDR_4": 'Hong Kong',
            "OFF_ADDR_DIST": 'Kennedy Town',
            "COR_ADDR_1": 'Address 1',
            "COR_ADDR_2": 'Address 2',
            "COR_ADDR_3": 'Address 3',
            "COR_ADDR_4": 'Hong Kong',
            "COR_ADDR_DIST": 'Kennedy Town',

            "LANG_TYPE": 'E',
            "CONT_PERSON_NAME": 'Arindam Mondal',
            "CONT_PERSON_TITLE": 'CEO',
            "CONT_PERSON_EMAIL": 'arindam@chikpea.com',
            "CONT_PERSON_MOBILE": '03218211046',
        }
    }
}
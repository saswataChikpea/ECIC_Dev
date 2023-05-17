import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile'
import { refreshApex } from '@salesforce/apex';
import checkOtherPHCompAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkOtherPHCompAura'
import getIndustryList from '@salesforce/apex/GetCustomMetaData.getIndustryList';
import getLegalTypeList from '@salesforce/apex/GetCustomMetaData.getLegalTypeList';

import getDistrictTerritoryList from '@salesforce/apex/GetCustomMetaData.getDistrictTerritoryList';
import getKnowAboutEcicList from '@salesforce/apex/GetCustomMetaData.getKnowAboutEcicList';
import UsrId from '@salesforce/user/Id'
import BRExist from '@salesforce/apex/OnboardingCheckValidation.BRExist'
import promoCodeExist from '@salesforce/apex/OnboardingCheckValidation.promoCodeExist'

import Section_A_Business_Detail from '@salesforce/label/c.Section_A_Business_Detail'
import Company_Name from '@salesforce/label/c.Company_Name'
import Type_of_business_entity from '@salesforce/label/c.Type_of_business_entity'
import Holding_bank_account_in_Hong_Kong from '@salesforce/label/c.Holding_bank_account_in_Hong_Kong'
import Yes from '@salesforce/label/c.Yes'
import No from '@salesforce/label/c.No'
import Goods_Services from '@salesforce/label/c.Goods_Services'
import Language_Of_Correspondence from '@salesforce/label/c.Language_Of_Correspondence'
import Sales_turnover_for_the_last_12_months from '@salesforce/label/c.Sales_turnover_for_the_last_12_months'
import Sales_turnover_for_the_next_12_months from '@salesforce/label/c.Sales_turnover_for_the_next_12_months'
import Number_of_insurable_buyers from '@salesforce/label/c.Number_of_insurable_buyers'
import Largest_credit_limit_required from '@salesforce/label/c.Largest_credit_limit_required'
import Bad_debt_in_the_last_24_months from '@salesforce/label/c.Bad_debt_in_the_last_24_months'
import Amount_currently_overdue_for_more_than_30_days from '@salesforce/label/c.Amount_currently_overdue_for_more_than_30_days'
import Commencement_Date from '@salesforce/label/c.Commencement_Date'
import Policy_renewal from '@salesforce/label/c.Policy_renewal'
import Payment_Option from '@salesforce/label/c.Payment_Option'
import Add_Country_Market_of_Shipment from '@salesforce/label/c.Add_Country_Market_of_Shipment'
import Add_Destination_Country_Market from '@salesforce/label/c.Add_Destination_Country_Market'
import Add_Country_Market_of_Origin from '@salesforce/label/c.Add_Country_Market_of_Origin'
import Section_B_Company_Detail from '@salesforce/label/c.Section_B_Company_Detail'
import Business_registration_certificate_number_first_8_digits from '@salesforce/label/c.Business_registration_certificate_number_first_8_digits'
import Business_registration_certificate_expiry_date from '@salesforce/label/c.Business_registration_certificate_expiry_date'
import Upload_file from '@salesforce/label/c.Upload_file'
import Date_of_incorporation from '@salesforce/label/c.Date_of_incorporation'
import Registered_address_English from '@salesforce/label/c.Registered_address_English'
import Territory_English from '@salesforce/label/c.Territory_English';
import District_English from '@salesforce/label/c.District_English';
import Same_as_registered_address_English from '@salesforce/label/c.Same_as_registered_address_English';
import Correspondence_address_English from '@salesforce/label/c.Correspondence_address_English';
import Reason_of_application from '@salesforce/label/c.Reason_of_application';
import Section_C_Director_shareholder_sole_proprietor_partner from '@salesforce/label/c.Section_C_Director_shareholder_sole_proprietor_partner';
import Section_D_Self_Selected_Policy_Terms from '@salesforce/label/c.Section_D_Self_Selected_Policy_Terms';
import Percentage_of_Indemnity from '@salesforce/label/c.Percentage_of_Indemnity';
import Non_qualifying_loss_amount from '@salesforce/label/c.Non_qualifying_loss_amount';
import Section_D_Potential_Buyers from '@salesforce/label/c.Section_D_Potential_Buyers';
import Add_Buyer_Details from '@salesforce/label/c.Add_Buyer_Details';
import Maximum_Liability from '@salesforce/label/c.Maximum_Liability';
import Section_E_Contact_Details from '@salesforce/label/c.Section_E_Contact_Details';
import Contact_person_First_name from '@salesforce/label/c.Contact_person_First_name';
import Contact_person_Last_name from '@salesforce/label/c.Contact_person_Last_name';
import Job_title from '@salesforce/label/c.Job_title';
import Email_Address from '@salesforce/label/c.Email_Address';
import Company_phone_number from '@salesforce/label/c.Company_phone_number';
import Mobile_Phone_Number from '@salesforce/label/c.Mobile_Phone_Number';
import Enable_SMS_notifications from '@salesforce/label/c.Enable_SMS_notifications';
import How_did_you_know_HKECIC from '@salesforce/label/c.How_did_you_know_HKECIC';
import Reference_code from '@salesforce/label/c.Reference_code';
import Exclusion_of_risk from '@salesforce/label/c.Exclusion_of_risk';

import Automatic from '@salesforce/label/c.Automatic';
import Manual from '@salesforce/label/c.Manual';
import English from '@salesforce/label/c.English';
import Chinese from '@salesforce/label/c.Chinese';
import Protection from '@salesforce/label/c.Protection';
import Credit_Control from '@salesforce/label/c.Credit_Control';
import Financing from '@salesforce/label/c.Financing';
import Expansion_of_Business from '@salesforce/label/c.Expansion_of_Business';
import Other_please_specify from '@salesforce/label/c.Other_please_specify';
import Director from '@salesforce/label/c.Director';
import Shareholder from '@salesforce/label/c.Shareholder';
import Sole_Proprietor from '@salesforce/label/c.Sole_Proprietor';
import Please_add_country_market_and_percentage_to_add_up_to_100 from '@salesforce/label/c.Please_add_country_market_and_percentage_to_add_up_to_100';
import Number_No from '@salesforce/label/c.Number_No';
import Country_Market_of_Shipment from '@salesforce/label/c.Country_Market_of_Shipment';
import of_country_market_of_shipment from '@salesforce/label/c.of_country_market_of_shipment';
import Type from '@salesforce/label/c.Type';
import Name from '@salesforce/label/c.Name';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Buyer_Address from '@salesforce/label/c.Buyer_Address';
import Buyer_Country from '@salesforce/label/c.Buyer_Country';




const FIELDS = ['Account.Name'];
const MAX_FILE_SIZE = 1024 * 1024 * 5; //5mb  
const MAX_FILE_SIZE_NAME = '5mb';
const fileAcceptedFormat = " .png, .jpg, .pdf"
const acceptedFormats = ['png', 'jpg', 'pdf'];

export default class OnboardingFillInProposal extends LightningElement {

    @track label =
        {
            Section_A_Business_Detail, Company_Name, Type_of_business_entity, Holding_bank_account_in_Hong_Kong, Yes, No, Goods_Services,
            Language_Of_Correspondence, Sales_turnover_for_the_last_12_months, Sales_turnover_for_the_next_12_months,
            Number_of_insurable_buyers, Largest_credit_limit_required, Bad_debt_in_the_last_24_months, Amount_currently_overdue_for_more_than_30_days, Commencement_Date,
            Policy_renewal, Payment_Option, Add_Country_Market_of_Shipment, Add_Destination_Country_Market, Buyer_Country,
            Add_Country_Market_of_Origin, Section_B_Company_Detail, Business_registration_certificate_number_first_8_digits, Business_registration_certificate_expiry_date, Upload_file,
            Date_of_incorporation, Registered_address_English, Territory_English, District_English, Reason_of_application, Section_C_Director_shareholder_sole_proprietor_partner,
            Section_D_Self_Selected_Policy_Terms, Percentage_of_Indemnity, Non_qualifying_loss_amount, Exclusion_of_risk, Section_D_Potential_Buyers, Add_Buyer_Details, Maximum_Liability,
            Section_E_Contact_Details, Contact_person_First_name, Contact_person_Last_name, Job_title, Email_Address, Company_phone_number, Mobile_Phone_Number,
            Enable_SMS_notifications, How_did_you_know_HKECIC, Reference_code, Manual, Automatic, English, Chinese, Buyer_Address,
            Protection, Credit_Control, Financing, Expansion_of_Business, Other_please_specify, Director, Shareholder,
            Sole_Proprietor, Same_as_registered_address_English, Correspondence_address_English, Number_No, Type, Name, Buyer_Name,
            Please_add_country_market_and_percentage_to_add_up_to_100, Country_Market_of_Shipment, of_country_market_of_shipment


        }

    @api proposal = {}
    @api products
    @api brFile
    @api selectedproduct = ""
    // @api selectedproduct = "a090w000005Um1HAAS"
    @api selectedProductName //= "SBP"
    @api isReviseQuote
    @api quote = {}
    @track questionList = []
    @track questionMap = {}
    @track editableFileds = []

    @track company_name = ""
    @track pastTurnOver = ""
    @track nextTurnOver = ""
    @track insurableBuyers = ""
    showApplicationReasonInput = false
    @track completeSelectedProduct = {}

    @api
    usrId = UsrId
    myRecordId;
    isLoaded = true
    // @track goodsServiceOptions = []
    // @track districtTerritory = {}

    @track registeredAddress = {
        "readOnly": false,
        "address_line_1": "",
        "address_line_2": "",
        "address_line_3": "",
        "terriitory": "",
        "district": ""
    }
    @track correspondenceAddress = {
        "readOnly": false,
        "address_line_1": "",
        "address_line_2": "",
        "address_line_3": "",
        "terriitory": "",
        "district": ""
    }
    get isDisabledClass() {
        return this.isReviseQuote ? "disabled" : ""
    }


    loadFirstTime = true
    renderedCallback() {
        if (this.loadFirstTime) {
            const scrollOptions = {
                left: 0,
                top: 0,
                behavior: 'smooth'
            }
            window.scrollTo(scrollOptions);
            this.loadFirstTime = false
        }
    }

    connectedCallback() {
        this.isLoaded = true
        // this.callgetProduct()
        console.log('proposal=' + JSON.stringify(this.proposal), 'selected_product' + this.selectedproduct)
        console.log('products=' + JSON.stringify(this.products))
        console.log('selectedProductName=' + this.selectedProductName)
        console.log('isReviseQuote=' + this.isReviseQuote)
        console.log('quote=' + this.quote)

        console.log('brFile=' + JSON.stringify(this.brFile))

        if (this.proposal) this.proposal = { ...this.proposal }
        this.brFile = this.brFile ? { ...this.brFile } : { file: "", fileName: "" }
        if (this.proposal && this.selectedproduct) {
            this.products.forEach((rec, index) => {
                if (rec.Id === this.selectedproduct)
                    this.completeSelectedProduct = { ...rec }
            })
        }
        // this.isReviseQuote = true
        if (this.isReviseQuote)
            this.editableFileds = this.getEditableFileds()//amend quote purpose
        if (this.selectedProductName) {
            this.loadFromProposal()
        }

    }
    get goodsServiceOptions() {
        return this.productList.length && this.productList
            .filter(el => (el.PRD_PCY_TYPE__c == this.proposal.Policy_Type__c))
            .map(el => ({ label: el.PRD_DESC__c, value: el.PRD_CODE__c, code: el.PRD_CODE__c }))
            .sort((a, b) => a.label.localeCompare(b.label))
        console.log("goodsServiceOptions:::::", JSON.stringify(temp));
        // return temp
    }
    @track productList = []
    @wire(getIndustryList, {})
    callgetProduct({ error, data }) {
        if (data) {
            // console.log("ProductList:" + JSON.stringify(data));
            this.productList = data
        }
        else {
            console.log('error::', JSON.stringify(error));
        }
    }
    @track companyLegalTypeOptions = []
    @wire(getLegalTypeList, {})
    callgetLegalTypeList({ error, data }) {
        if (data) {
            console.log("getLegalTypeList:" + JSON.stringify(data));
            this.companyLegalTypeOptions = data.length && data
                .map(el => ({ label: el.LegalList_Code_Desc__c, value: el.LegalList_Code__c, code: el.LegalList_Code__c }))
            // .sort((a, b) => a.label.localeCompare(b.label))
        }
        else {
            console.log('error::', JSON.stringify(error));
        }
    }

    @wire(getDistrictTerritoryList, {})
    callgetDistrictTerritoryList({ data, error }) {
        if (data) {
            // console.log("territory result::", JSON.stringify(data));
            // this.countryOptions = data.map((country) => ({ label: country.Full_Country_Name__c, value: country.Full_Country_Name__c, code: country.Country_Code__c }));
            // // this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            // this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
            // console.log("Country options:: ", JSON.stringify(this.countryOptions));

            // this.districtTerritory = data.reduce((acc, a) => {
            //     let temp = { ...acc }
            //     if (temp[a.District_Territory__c]) {
            //         temp[a.District_Territory__c].push(a.Sub_District__c)
            //     } else {
            //         temp[a.District_Territory__c] = [a.Sub_District__c]
            //     }
            //     return temp
            // }, {})
            // console.log("districtTerritory::", JSON.stringify(this.districtTerritory));

            // let options = Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el })).sort((a, b) => a.value.localeCompare(b.value));
            // // if (this.questionMap.Registered_Territory__c)
            // this.questionMap.Registered_Territory__c.options = options
            // // if (this.questionMap.Correspondence_Territory__c)
            // this.questionMap.Correspondence_Territory__c.options = options


        }
        else if (error) {
            console.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        }
    }

    @track knowAboutEcicOptions = []
    @wire(getKnowAboutEcicList, {})
    callgetKnowAboutEcicList({ data, error }) {
        if (data) {
            // Know_About_Hkecic__c
            // console.log("getKnowAboutEcicList result::", JSON.stringify(data));
            this.knowAboutEcicOptions = data.map((el) => ({ label: el.Refer_Code_Desc__c, value: el.Refer_Code__c, code_group: el.Refer_Code_Group__c }));
            // // this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            // this.knowAboutEcicOptions = this.knowAboutEcicOptions.sort((a, b) => a.value.localeCompare(b.value));
            // console.log("knowAboutEcicOptions:: ", JSON.stringify(this.knowAboutEcicOptions));
            if (this.questionMap.Know_About_Hkecic__c)
                this.questionMap.Know_About_Hkecic__c.options = this.knowAboutEcicOptions
        }
        else if (error) {
            console.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        }
    }


    getEditableFileds() {
        if (this.selectedProductName === 'SUP') {
            return ['Policy_Commence_Date__c', 'Maximum_Liability__c']
        }
        return ['Policy_Commence_Date__c',]

    }
    loadFromProposal() {
        ///recomending Automatic Renewal by default
        if (!this.proposal.Auto_Renewal__c) {
            this.proposal.Auto_Renewal__c = "Automatic Renewal"
        }
        ///set language by default
        if (!this.proposal.Language_of_Correspondence__c) {
            this.proposal.Language_of_Correspondence__c = "English"
        }
        //setting default policy commence date
        if (!this.isReviseQuote) {
            this.proposal.Policy_Commence_Date__c = this.policyCommencementDate
        }
        //setting default maximum liability
        if (!this.proposal.Maximum_Liability__c) {
            this.proposal.Maximum_Liability__c = 500000
        }


        if (this.selectedProductName === 'OMBP') {
            this.questionList = [
                this.sectionAQuestions,
                this.sectionBQuestions,
                this.sectionCQuestions,
                this.sectionDQuestionsOMBP,
                this.sectionEQuestions,
            ]
        } else if (this.selectedProductName === 'SBP') {
            this.questionList = [
                this.sectionAQuestionsSBP,
                this.sectionBQuestions,
                this.sectionCQuestions,
                this.sectionDQuestionsSBP,
                this.sectionEQuestions,
            ]
        } else if (this.selectedProductName === 'SUP') {
            this.questionList = [
                this.sectionAQuestionsSUP,
                this.sectionBQuestions,
                this.sectionCQuestions,
                this.sectionDQuestionsSUP,
                this.sectionEQuestions,
            ]
        }
        let sequence = 1
        this.questionList.forEach((section, i) => {
            if (section.questions) {
                section.questions.forEach((question) => {
                    question.Display_Sequence = sequence
                    question.sectionIndex = i
                    sequence += 1
                    if (this.isReviseQuote) {
                        question.readOnly = this.editableFileds.includes(question.Name) ? false : true
                        question.labelClass = this.editableFileds.includes(question.Name) ? "slds-col slds-size_1-of-1 slds-large-size_1-of-2 bold" : "slds-col slds-size_1-of-1 slds-large-size_1-of-2 bold disabled"
                        if (question.Name == 'Policy_Commence_Date__c') {
                            question.isPickList = true
                            question.isText = false
                            question.options = this.getCommenceDateOptions()
                        }
                    } else {
                        question.labelClass = "slds-col slds-size_1-of-1 slds-large-size_1-of-2 bold"
                    }
                    if (question.Name in this.proposal) {
                        if (question.isRadio) {
                            question.options = question.options.map(el => {
                                el.isChecked = el.value + '' == this.proposal[question.Name] + '' ? true : false
                                return el
                            })
                        } else if (question.validationType == 'Number') {
                            question.formattedValue = Number(this.proposal[question.Name]).toLocaleString('en-US', { maximumFractionDigits: 2 })
                        }
                        question.Value = String(this.proposal[question.Name])
                    }
                    this.questionMap[question.Name] = question
                }
                )
            }
        })




        if (this.proposal.Benificiary_Owners__c) {
            this.benificiary_owners = JSON.parse(this.proposal.Benificiary_Owners__c)
        }
        if (this.proposal.Buyer_List__c) {
            this.buyers = JSON.parse(this.proposal.Buyer_List__c)
        }

        if ('Exclusions__c' in this.proposal) {
            this.exclusionOptions = JSON.parse(this.proposal.Exclusions__c)  // console.log("exclusion:::", JSON.stringify(this.exclusionOptions))
        }
        // if ('Company_Address_Registered__c' in this.proposal) {
        //     const temp = JSON.parse(this.proposal.Company_Address_Registered__c)
        //     Object.keys(this.registeredAddress).forEach(key => this.registeredAddress[key] = temp[key])
        // }
        // if ('Company_Address_Correspondence__c' in this.proposal) {
        //     const temp1 = JSON.parse(this.proposal.Company_Address_Registered__c)
        //     Object.keys(this.correspondenceAddress).forEach(key => this.correspondenceAddress[key] = temp1[key])
        // }

        if (this.proposal.Application_Reason__c && this.proposal.Application_Reason__c.includes('Other')) {
            this.showApplicationReasonInput = true
            this.questionMap.Application_Reason__c.Value = 'Other'
            this.questionMap.Application_Reason__c.AdditionalValue = this.proposal.Application_Reason__c.replace('Other, ', '')
        }



        if ('Maximum_Liability__c' in this.proposal) {
            if (this.questionMap.Maximum_Liability__c) {
                this.questionMap.Maximum_Liability__c.formattedValue = Number(this.proposal.Maximum_Liability__c) ? Number(this.proposal.Maximum_Liability__c).toLocaleString('en-US', { maximumFractionDigits: 2 }) : "0"
            }
        }

        if ('Country_Market_Of_Shipment__c' in this.proposal) {
            this.countryMarket_Shipment = JSON.parse(this.proposal.Country_Market_Of_Shipment__c)
            this.countrymarketfor = 'Country_Market_Of_Shipment__c'
            this.refreshPercentage()
            this.handleAvailableCountry()
        }
        if ('Destination_Country_Market__c' in this.proposal) {
            this.countryMarket_Destination = JSON.parse(this.proposal.Destination_Country_Market__c)
            this.countrymarketfor = 'Destination_Country_Market__c'
            this.refreshPercentage()
            this.handleAvailableCountry()
        }
        if ('Country_Market_Of_Origin__c' in this.proposal) {
            this.countryMarket_Origin = JSON.parse(this.proposal.Country_Market_Of_Origin__c)
            this.countrymarketfor = 'Country_Market_Of_Origin__c'
            this.refreshPercentage()
            this.handleAvailableCountry()
        }



        this.registeredAddress.address_line_1 = this.proposal.Registered_Address_Line_1__c || ""
        this.registeredAddress.address_line_2 = this.proposal.Registered_Address_Line_2__c || ""
        this.registeredAddress.address_line_3 = this.proposal.Registered_Address_Line_3__c || ""

        this.correspondenceAddress.address_line_1 = this.proposal.Correspondence_Address_Line_1__c || ""
        this.correspondenceAddress.address_line_2 = this.proposal.Correspondence_Address_Line_2__c || ""
        this.correspondenceAddress.address_line_3 = this.proposal.Correspondence_Address_Line_3__c || ""

        if (this.districtTerritory) {
            try {
                let options = Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el }))//.sort((a, b) => a.value.localeCompare(b.value));
                if (this.questionMap.Registered_Territory__c)
                    this.questionMap.Registered_Territory__c.options = options
                if (this.questionMap.Correspondence_Territory__c)
                    this.questionMap.Correspondence_Territory__c.options = options

                if (this.proposal.Registered_Territory__c) {
                    // this.questionMap['Registered_District__c'].options = this.districtTerritory[this.proposal.Registered_Territory__c].map((el) => ({ label: el, value: el }))//.sort((a, b) => a.localeCompare(b));
                    this.registeredDistrictOptions = this.districtTerritory[this.proposal.Registered_Territory__c].map((el) => ({ label: el, value: el }))

                }
                if (this.proposal.Correspondence_Territory__c) {
                    this.questionMap.Correspondence_District__c.options = this.districtTerritory[this.proposal.Correspondence_Territory__c].map((el) => ({ label: el, value: el }))//.sort((a, b) => a.localeCompare(b));
                }
            } catch (error) {
                console.error(error);
            }
        }
        if (this.proposal.Registered_Correspondence_Same__c) {
            this.handleSameAddress(this.proposal.Registered_Correspondence_Same__c)
        }
        if (this.knowAboutEcicOptions.length)
            this.questionMap.Know_About_Hkecic__c.options = this.knowAboutEcicOptions
    }
    get maximumLiabilityOptions() {
        if (Object.keys(this.completeSelectedProduct).length) {
            return {
                Max: this.completeSelectedProduct.Maximum_Liability__c,
                Min: this.completeSelectedProduct.Minimum_Maximum_Liability__c,
                Step: this.completeSelectedProduct.Maximum_Liability_Interval__c
            }
        }
    }
    getCommenceDateOptions = () => {
        const proposalCreatedDate = new Date(this.proposal.CreatedDate)
        const quoteCreatedDate = new Date(this.quote.CreatedDate)
        const policyDate = new Date(this.proposal.Policy_Commence_Date_old)
        const policyDate15th = new Date(policyDate.getFullYear(), policyDate.getMonth(), 14)
        const today = new Date()
        let a = []
        if (quoteCreatedDate > policyDate15th) {
            a = [
                new Date(today.getFullYear(), today.getMonth() + 1, 1),
                new Date(today.getFullYear(), today.getMonth() + 2, 1)
            ]
        } else {
            a = [
                new Date(policyDate.getFullYear(), policyDate.getMonth() + 1, 1),
                new Date(policyDate.getFullYear(), policyDate.getMonth() + 2, 1)
            ]
            if (new Date(quoteCreatedDate.getFullYear(), quoteCreatedDate.getMonth(), 1) > proposalCreatedDate) {
                a = [...a,
                new Date(quoteCreatedDate.getFullYear(), quoteCreatedDate.getMonth(), 1)
                ]
            }
        }
        console.log("a::::::::::", a);
        return a.map(el => {
            // return {
            //     label: el.getFullYear() + '-' + String(el.getMonth()).padStart(2, '0') + '-' + String(el.getDate() + 1).padStart(2, '0'),
            //     value: el.getFullYear() + '-' + String(el.getMonth()).padStart(2, '0') + '-' + String(el.getDate() + 1).padStart(2, '0')
            // }
            return {
                label: el.toLocaleDateString('se'),//.slice(0, 10).replace(/-/g, "-"),
                value: el.toLocaleDateString('se')//toISOString().slice(0, 10).replace(/-/g, "-")
            }
        })
    }
    numberWithCommas = (x) => {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    // handleMultiSelect(event) {
    //     console.log("Multiselect:::", event.target.name);
    //     console.log("Multiselect:::", JSON.stringify(event.detail.payload.values.join(";")));

    // }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert("No. of files uploaded : " + uploadedFiles.length);
    }

    // proposal = { Company_Name__c: "company name" }
    expandHandler(event) {
        console.log(event.currentTarget.id)
        let id = event.currentTarget.id + ""
        id = id.split("-")[0]
        this.questionList.forEach((section) => {
            section.isSectionOpen = id === section.sectionId ? !section.isSectionOpen : section.isSectionOpen
            section.iconName = id === section.sectionId && section.isSectionOpen ? "utility:up" : "utility:down"
        })

    }

    @track exclusionOptions = [
        { dataId: "Country_Risks", label: 'Country Risks', value: "5", isChecked: false },
        { dataId: "Repudiation_Risks", label: 'Repudiation Risks', value: "10", isChecked: false },
    ]

    get benificiaryOptions() {
        return [{ label: this.label.Director, value: "Director" }, { label: this.label.Shareholder, value: "Shareholder" }, { label: this.label.Sole_Proprietor, value: "Sole Proprietor" }]
    }
    @track benificiary_owners = [
        {
            'name': '',
            'type': 'Director',
            'key': 0,
            'editable': true
        }
    ]
    removeRow(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        console.log(JSON.stringify(selectedRow));
        console.log(JSON.stringify(selectedRow.dataset));
        console.log('Removed key=', key);

        if (this.benificiary_owners.length > 1) {
            this.benificiary_owners.splice(key, 1)
            this.benificiary_owners = this.benificiary_owners.map((el, i) => ({ ...el, key: i }))
        } else if (this.benificiary_owners.length == 1) {
            this.benificiary_owners = [{ "name": "", "type": "Director", "key": 0, "editable": true }]
        }
        console.log("benif::", JSON.stringify(this.benificiary_owners));

    }
    handleBenName(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('handlebenname key', key);
        // console.log(JSON.stringify(this.benificiary_owners[2]));
        this.benificiary_owners[key].name = e.target.value;
    }
    handleBenType(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('handlebentype key', key);
        // console.log(JSON.stringify(this.benificiary_owners[2]));
        this.benificiary_owners[key].type = e.target.value;
    }
    @track show_save_btn = true;
    addRow() {
        const lastElement = this.benificiary_owners[this.benificiary_owners.length - 1]
        if (!lastElement.name || !lastElement.type) {
            this.showToast("Please select type and name before adding a new row")
            return
        }
        var key = this.benificiary_owners.length;
        if (key >= 10) {
            this.showToast("Can select maximum 10 persons.")
            return
        }
        this.benificiary_owners = this.benificiary_owners.map(el => {
            el.disabled = true
            return el
        })
        this.benificiary_owners.push({
            'name': '',
            'type': '',
            'key': key,
            'editable': true
        });
        this.show_save_btn = true;
    }
    handleSave() {
        console.log('handleSave=' + JSON.stringify(this.benificiary_owners));
        for (var i = 0; i < this.benificiary_owners.length; i++) {
            this.benificiary_owners[i].editable = false;
        }
        this.show_save_btn = false;
    }
    ///add buyer section
    @track buyers = [{
        'name': '',
        'address': '',
        'country': '',
        'key': 0,
        'editable': true
    }]
    removebuyerRow(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        console.log(JSON.stringify(selectedRow));
        console.log(JSON.stringify(selectedRow.dataset));
        console.log('Removed key=', key);
        if (this.buyers.length > 1) {
            this.buyers.splice(key, 1);
            this.buyers = this.buyers.map((el, i) => ({ ...el, key: i }))
            // this.index--;
            // this.isLoaded = false;
        } else if (this.buyers.length == 1) {
            this.buyers = [{
                'name': '',
                'address': '',
                'country': '',
                'key': 0,
                'editable': true
            }];
            // this.index = 0;
            // this.isLoaded = false;
        }
    }
    handleBuyerName(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('handlebenname key', key);
        // console.log(JSON.stringify(this.buyers[2]));
        this.buyers[key].name = e.target.value;
    }
    handleBuyerAddress(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('handlebenname key', key);
        // console.log(JSON.stringify(this.buyers[2]));
        this.buyers[key].address = e.target.value;
    }
    handleBuyerCountry(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('handlebenname key', key);
        // console.log(JSON.stringify(this.buyers[2]));
        this.buyers[key].country = e.target.value;
    }

    get addMoreBuyer() {
        return this.buyers.length < 5
    }

    @track show_buyer_save_btn = true;
    addBuyerRow() {
        const lastElement = this.buyers[this.buyers.length - 1]
        if (!lastElement.name || !lastElement.address || !lastElement.country) {
            this.showToast("Please select name, address and country before adding a new row")
            return
        }
        var key = this.buyers.length;

        this.buyers.push({
            'name': '',
            'address': '',
            'country': '',
            'key': key,
            'editable': true
        });
        this.show_buyer_save_btn = true;

    }
    handleBuyerSave() {
        console.log('handleSave=' + JSON.stringify(this.buyers));
        for (var i = 0; i < this.buyers.length; i++) {
            this.buyers[i].editable = false;
        }
        this.show_buyer_save_btn = false;
    }

    /////country change
    @track countryMarket_Shipment = [{ "no": 1, "country": "", "percentage": "", "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    @track countryMarket_Destination = [{ "no": 1, "country": "", "percentage": "", "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    @track countryMarket_Origin = [{ "no": 1, "country": "", "percentage": "", "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    countrymarketfor

    get currentCountryMarket() {
        if (this.countrymarketfor == "Country_Market_Of_Shipment__c") {
            return this.countryMarket_Shipment
        } else if (this.countrymarketfor == "Destination_Country_Market__c") {
            return this.countryMarket_Destination
        } else if (this.countrymarketfor == 'Country_Market_Of_Origin__c') {
            return this.countryMarket_Origin
        }
    }
    set currentCountryMarket(val) {
        if (this.countrymarketfor == "Country_Market_Of_Shipment__c") {
            this.countryMarket_Shipment = val
        } else if (this.countrymarketfor == "Destination_Country_Market__c") {
            this.countryMarket_Destination = val
        } else if (this.countrymarketfor == 'Country_Market_Of_Origin__c') {
            this.countryMarket_Origin = val
        }
    }

    handleCountryPercentageChange(e) {
        var key = e.currentTarget.dataset.id;
        let value = e.target.value

        this.countrymarketfor = e.currentTarget.dataset.countrymarketfor
        // console.log(' percentage change:::', countrymarketfor, key, value);
        let total_percentage = 0
        this.currentCountryMarket[key].percentage = value
        if (!this.isPercentage(value)) {
            this.showToast("Please enter proper percentage value")
            this.currentCountryMarket[key].percentage = 0
        } else {
            value = Number(value)
            this.currentCountryMarket[key].percentage = value
            total_percentage = this.currentCountryMarket.reduce((a, b) => ({ percentage: Number(a.percentage) + Number(b.percentage) })).percentage
            console.log("total percentage:", total_percentage)
            if (total_percentage > 100) {
                this.showToast("total percentage can not exceed 100")
                this.currentCountryMarket[key].percentage = 0
            }
        }
        this.refreshPercentage()
    }

    refreshPercentage = () => {
        // debugger
        try {
            const total_percentage = this.currentCountryMarket.reduce((a, b) => ({ percentage: Number(a.percentage) + Number(b.percentage) })).percentage
            this.questionMap[this.countrymarketfor].total_percentage = total_percentage
            this.questionMap[this.countrymarketfor].showAddButton = total_percentage < 100 ? true : false
            this.questionMap[this.countrymarketfor].percentageStyle = total_percentage <= 100 ? `width :${total_percentage}%` : `width :100%`
        } catch (error) {
            console.log(error)
        }
    }
    handleCountryMarketChange(e) {
        this.countrymarketfor = e.currentTarget.dataset.countrymarketfor
        const value = e.target.value
        var key = e.currentTarget.dataset.id;
        console.log('handleCountryMarketChange key', key);

        this.currentCountryMarket[key].country = value
        this.handleAvailableCountry()

    }
    addCountryMarket(e) {
        this.countrymarketfor = e.currentTarget.dataset.countrymarketfor
        let total_percentage = 0
        const lastElement = this.currentCountryMarket[this.currentCountryMarket.length - 1]
        total_percentage = this.currentCountryMarket.reduce((a, b) => ({ percentage: Number(a.percentage) + Number(b.percentage) })).percentage
        var key = this.currentCountryMarket.length;
        if (!lastElement.country || !lastElement.percentage) {
            this.showToast("Please select country and add percentage before adding a new row")
            return
        }
        else if (total_percentage >= 100) {
            this.showToast("Already selected 100%")
            return
        } else if (key >= 5) {
            this.showToast("Can select maximum 5 countries")
            return
        }
        this.currentCountryMarket.push({
            "no": key + 1,
            "country": '',
            "percentage": "",
            "key": key,
            "editable": true
        })
        this.handleAvailableCountry()
    }
    removeCountryMarketRow(event) {
        var key = event.currentTarget.dataset.id;
        this.countrymarketfor = event.currentTarget.dataset.countrymarketfor

        if (this.currentCountryMarket.length > 1) {
            this.currentCountryMarket.splice(key, 1)
        } else if (this.currentCountryMarket.length == 1) {
            this.currentCountryMarket = [{ "no": 1, "country": "", "percentage": "", "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
        }
        this.refreshPercentage()
        this.handleAvailableCountry()
    }
    handleAvailableCountry = () => {
        let temp_country = []
        temp_country = this.currentCountryMarket.reduce((prev, curr) => (prev.push(curr.country), prev), [])
        console.log("temp_country", JSON.stringify(temp_country))
        this.currentCountryMarket = this.currentCountryMarket.filter((row, i) => {
            row.availableCountry = this.countryOptions.filter((el) => temp_country[i] == el.value || !temp_country.includes(el.value))
            row.key = i
            row.no = i + 1
            return row
        });

    }
    ////country change end/////


    handleQChange(event) {

        const targetName = event.target.name
        const targetValue = event.target.value
        try {
            console.log('event.detail=' + JSON.stringify(event.detail))
        } catch (e) {
        }
        try {
            console.log('event.target=' + JSON.stringify(event.target))
        } catch (e) {
        }

        console.log('Current type of the input: ' + targetName)
        console.log('Current value of the input: ' + targetValue)
        var company_name = 'Company'
        //is_existing_ph
        if (targetValue && targetName) {
            // if (targetName === 'BR_Number__c' && (!this.isNum(targetValue) || targetValue.length !== 8)) {
            //     const message = " Br number should be of 8 numeric digits"
            //     alert(message)
            // }
            // debugger
            if (targetName === 'Maximum_Liability__c') {
                this.questionMap[targetName].formattedValue = Number(targetValue).toLocaleString('en-US', { maximumFractionDigits: 2 })
            } else if (targetName == 'Registered_Territory__c') {
                this.registeredDistrictOptions = this.districtTerritory[targetValue].map((el) => ({ label: el, value: el }))

                if (this.proposal.Registered_Correspondence_Same__c + '' == 'true') {
                    this.correspondenceDistrictOptions = this.districtTerritory[targetValue].map((el) => ({ label: el, value: el }))
                    this.proposal.Correspondence_Territory__c = targetValue
                    this.questionMap.Correspondence_Territory__c.Value = targetValue
                }
            } else if (targetName == 'Correspondence_Territory__c') {
                this.correspondenceDistrictOptions = this.districtTerritory[targetValue].map((el) => ({ label: el, value: el }))
            } else if (targetName == 'Registered_District__c' && this.proposal.Registered_Correspondence_Same__c + '' == 'true') {
                this.proposal.Correspondence_District__c = targetValue
                this.questionMap.Correspondence_District__c.Value = targetValue
            }
            console.log(targetName + ":::", targetValue)
            if (this.validateSingleInput(targetName, targetValue)) {

                this.proposal[targetName] = targetValue
                this.questionMap[targetName].Value = targetValue
            }
        }
        else if (event.detail && !event.detail.value) {//c-custom-multi-select-picklist
            const targetValue = event.detail.join(";")
            console.log('Current value of the input: ' + targetValue)
            this.proposal[targetName] = targetValue
            this.questionMap[targetName].Value = targetValue
        }
        else if (event.detail.value) {
            const targetValue = event.detail.value
            console.log('Current value of the input: ' + targetValue)
            this.proposal[targetName] = targetValue
            this.questionMap[targetName].Value = targetValue
        } else if (event.target.checked === true) {
            const targetValue = event.target.checked
            console.log('Current value of the input: ' + targetValue)
            this.proposal[targetName] = targetValue
            this.questionMap[targetName].Value = targetValue
        }
        console.log('proposal=' + JSON.stringify(this.proposal))
    }
    handleCurrencyChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        console.log(targetName + ' :: ', targetValue);
        this.proposal[targetName] = targetValue
        this.questionMap[targetName].Value = targetValue
        this.validateSingleInput(targetName, targetValue)
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
    verifyBRNumberAPI() {
        console.log("calling API2");
        const br = this.proposal.BR_Number__c
        let pc = this.getPolicyCode(this.selectedProductName)
        console.log("calling API2", pc, br);
        // checkPolicyDetailsAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.3  To check whether company is an existing PH for respective policy type
        //     console.log("checkPolicyDetailsAura::", data);
        // }).catch(error => {
        //     console.log("checkPolicyDetailsAura::error", error);
        // })
        this.isLoaded = false
        checkOtherPHCompAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.4 To check whether company is an existing PH in other policy type and policyholder termination has not been
            console.log("checkOtherPHCompAura 6.4::", data);
            const res = JSON.parse(data).meta_data
            this.isLoaded = true
            if (res.result == 'N') {
                // checkHoldOfflinePlcyAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.7 To check whether company is holding an O/S offline proposal or quotation regardless of the policy type
                //     console.log("checkHoldOfflinePlcyAura 6.7::", data);
                //     const res2 = JSON.parse(data)['meta_data']
                //     if (res2['result'] == 'N') {
                this.gotoConfirmation()
                //         console.log('Ready to go to confirmation::');
                //     } else {
                //         this.showToast('This BR number is already used by another active policy')
                //     }
                // }).catch(error => {
                //     console.log("checkHoldOfflinePlcyAura::error", error);
                //     this.showToast('Something went wrong. Please try again later.')
                // })
            } else {
                this.showToast('This BR number is already used by another active policy')
            }

        }).catch(error => {
            this.isLoaded = true
            console.log("checkOtherPHCompAura::error", error);
            this.showToast('Something went wrong. Please try again later.')
        })
        // checkProblemPHCompAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.5 To check whether company is classified as problem policyholder regardless of the PH status
        //     console.log("checkProblemPHCompAura::", data);
        // }).catch(error => {
        //     console.log("checkProblemPHCompAura::error", error);
        // })
        // checkHoldOfflinePlcyAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.7 To check whether company is holding an O/S offline proposal or quotation regardless of the policy type
        //     console.log("checkHoldOfflinePlcyAura 6.7::", data);
        // }).catch(error => {
        //     console.log("checkHoldOfflinePlcyAura::error", error);
        // })
    }
    // get showApplicationReasonInput() {
    //     console.log("blabla:", this.proposal.Application_Reason__c);
    //     return this.proposal.Application_Reason__c && this.proposal.Application_Reason__c == 'Other' ? true : false
    // }
    handleApplicationReason(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        const dataId = event.currentTarget.getAttribute('data-id')
        console.log(targetName + ":::", targetValue, dataId)
        if (dataId == 'additionalInput') {
            this.proposal[targetName] = 'Other, ' + targetValue
        } else {
            this.showApplicationReasonInput = targetValue.includes("Other") ? true : false
            this.proposal[targetName] = targetValue
            this.questionMap[targetName].AdditionalValue = ''
        }
        console.log('proposal=' + this.proposal.Application_Reason__c)
    }
    handleQRadioChange(event) {
        console.log('event.detail=' + JSON.stringify(event.detail))
        const targetName = event.detail.name
        const targetValue = event.detail.selectedValue
        this.questionMap[targetName].Value = targetValue
        this.proposal[targetName] = targetValue
        if (targetName === 'Registered_Correspondence_Same__c') {
            this.handleSameAddress(targetValue)
        }
        console.log('proposal=' + JSON.stringify(this.proposal))

    }
    handleCheckboxChange(event) {
        const targetValue = event.target.checked
        const targetName = event.target.name
        this.proposal[targetName] = targetValue
        this.questionMap[targetName].isChecked = targetValue
        if (targetName === 'Registered_Correspondence_Same__c') {
            this.handleSameAddress(targetValue)
        }
        // console.log("corres", JSON.stringify(this.correspondenceAddress))

        console.log('proposal=' + JSON.stringify(this.proposal))
    }
    handleSameAddress(targetValue) {
        try {

            if (targetValue + '' == 'true') {
                Object.keys(this.registeredAddress).forEach(key => this.correspondenceAddress[key] = this.registeredAddress[key])
                console.log(this.questionMap.Correspondence_Territory__c.Value, this.questionMap.Registered_Territory__c.Value)
                if (this.proposal.Correspondence_Territory__c)//to handle bland reg address line1 and checking same checkbox
                    this.validateSingleInput('Company_Address_Correspondence__c')//to clear the previous error if any
                this.questionMap.Correspondence_Territory__c.readOnly = true
                this.questionMap.Correspondence_District__c.readOnly = true
                this.questionMap.Company_Address_Correspondence__c.readOnly = true
                // this.correspondenceAddress.readOnly = true
                this.questionMap.Registered_Correspondence_Same__c.isChecked = true
                this.questionMap.Correspondence_Territory__c.Value = this.proposal.Registered_Territory__c
                this.questionMap.Correspondence_District__c.Value = this.proposal.Registered_District__c

                this.proposal.Correspondence_Territory__c = this.proposal.Registered_Territory__c
                this.proposal.Correspondence_District__c = this.proposal.Registered_District__c

                this.correspondenceDistrictOptions = this.districtTerritory[this.proposal.Correspondence_Territory__c].map((el) => ({ label: el, value: el }))

            } else {
                this.questionMap.Correspondence_Territory__c.readOnly = false
                this.questionMap.Correspondence_District__c.readOnly = false
                // this.correspondenceAddress.readOnly = false
                this.questionMap.Company_Address_Correspondence__c.readOnly = false
                this.questionMap.Registered_Correspondence_Same__c.isChecked = false
            }
        } catch (e) {
            console.log(e);
        }

    }
    handleAddressChange(event) {
        const targetValue = event.target.value
        const addressLine = event.currentTarget.getAttribute('data-address_line')
        const targetName = event.target.name
        console.log(targetName + ":::", targetValue, addressLine)
        if (targetName === 'Company_Address_Registered__c') {
            this.registeredAddress[addressLine] = targetValue
            // if (this.proposal.Registered_Correspondence_Same__c) {
            if (this.proposal.Registered_Correspondence_Same__c + '' == 'true') {
                this.correspondenceAddress[addressLine] = targetValue

            }
        } else if (targetName === 'Company_Address_Correspondence__c') {
            this.correspondenceAddress[addressLine] = targetValue
        }


    }

    @api recordId;
    account;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            // this.dispatchEvent(
            //     new ShowToastEvent({
            //         title: 'Error loading contact',
            //         message,
            //         variant: 'error',
            //     }),
            // );
        } else if (data) {
            this.contact = data;
        }
    }
    isNum = (val) => {
        return /^\d+$/.test(val);
    }
    isCurrency = val => {
        // var regex = /^\d+(?:\.\d{0,2})$/;
        if (['0', '0.0', '0.00'].includes(String(val))) {
            return true
        }
        var regex = /^[1-9]\d*(((,\d{3}){1})?(\.\d{0,2})?)$/;
        console.log("is currency:", regex.test(val))
        return regex.test(val)
    }
    isPercentage(val) {
        return this.isNum(val) && val <= 100 && val > 0
    }
    checkErrorDate(inputValue, validationType) {
        const today = new Date().setHours(0, 0, 0, 0)
        if (validationType == 'FutureDate') {
            return new Date(inputValue).setHours(0, 0, 0, 0) >= today ? "" : "Please enter a valid future date"
        } else if (validationType == 'PastDate') {
            return new Date(inputValue).setHours(0, 0, 0, 0) <= today ? "" : "Please enter a past date only"
        }
        return ""
    }
    getInputField(sectionIndex, dataId) {
        // let inputField=null
        try {
            if (this.questionList[sectionIndex].isSectionOpen) {
                return this.template.querySelector(`[data-id='${dataId}']`);
            }

            this.questionList[sectionIndex].isSectionOpen = true
            this.questionList[sectionIndex].iconName = "utility:up"
            setTimeout(() => {
                return this.template.querySelector(`[data-id='${dataId}']`);

            }, 500);

        } catch (error) {
            console.log("could not find field:::" + error);
            return false
        }
    }
    hasInvalidCountryOrMarket(name) {
        this.countrymarketfor = name
        return this.currentCountryMarket.some(el => el.country == "" || !el.percentage)
    }
    isValidBenificiary() {
        let hasOnePerson = false
        let errMsg = ""
        for (let i in this.benificiary_owners) {
            if (this.benificiary_owners[i].name != '') {
                hasOnePerson = true
            }
            if (!this.benificiary_owners[i].name) {
                errMsg = "Please enter the name"
            }
            if (!this.benificiary_owners[i].type) {
                errMsg = "Please enter the type"
            }
        }
        if (!hasOnePerson) {
            return "Please enter at least one person"
        }
        return errMsg
    }
    validateSingleInput(name, value) {
        const dataId = name
        try {
            let inputField = null
            // if (inputField) {
            //checking if required
            const question = this.questionMap[name]
            const inputValue = value || this.proposal[name]//inputField.value
            const sectionIndex = question.sectionIndex
            // this.questionList[question.sectionIndex].isSectionOpen = true
            // // isSectionOpen = true
            // this.questionList[question.sectionIndex].iconName = "utility:up"
            // let inputField = this.template.querySelector(`[data-id='${dataId}']`);

            // debugger
            if (question.isRequired) {
                if (question.validationType) {
                    if (question.validationType === 'Number') {
                        if (!this.isNum(inputValue)) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity("Please enter a numeric value");
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                            } else {
                                this.questionList[sectionIndex].isSectionOpen = true
                                this.questionList[sectionIndex].iconName = "utility:up"
                                setTimeout(() => {
                                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                    inputField.setCustomValidity("Please enter a numeric value");
                                    inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                    inputField.reportValidity();
                                }, 500);
                            }
                            return false
                        }
                    } else if (question.validationType === 'Future_Turnover') {
                        this.proposal[name] = inputValue
                        this.questionMap[name].Value = inputValue

                        if (!inputValue || inputValue == 'HKD 50,000,001 and above' || (this.selectedProductName === 'OMBP' && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(inputValue))) {
                            let err = "This field is required"
                            // console.log(this.selectedProductName, "sfdsf::", inputValue);
                            // debugger
                            if (this.selectedProductName === 'OMBP' && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(inputValue)) {
                                err = "Annual sales turnover above HKD 30 million is not allowed for OMBP. Please contact the SME team for other policy types."
                            } else if (inputValue == 'HKD 50,000,001 and above') {
                                err = `Annual sales turnover above HKD 50 million is not allowed for $productName. Please contact the SME team for other policy types.`.replace('$productName', this.selectedProductName)
                            }
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity(err);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                            } else {
                                this.questionList[sectionIndex].isSectionOpen = true
                                this.questionList[sectionIndex].iconName = "utility:up"
                                setTimeout(() => {
                                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                    inputField.setCustomValidity(err);
                                    inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                    inputField.reportValidity();
                                }, 500);
                            }
                            return false
                        }
                    } else if (question.validationType === 'Past_Turnover') {
                        this.proposal[name] = inputValue
                        this.questionMap[name].Value = inputValue

                        if (!inputValue || inputValue == 'HKD 50,000,001 and above' || (this.selectedProductName === 'OMBP' && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(inputValue))) {
                            let err = "This field is required"
                            // console.log(this.selectedProductName, "sfdsf::", inputValue);
                            // debugger
                            if (this.selectedProductName === 'OMBP' && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(inputValue)) {
                                err = "Annual sales turnover above HKD 30 million is not allowed for OMBP. Please contact the SME team for other policy types."
                            } else if (inputValue == 'HKD 50,000,001 and above') {
                                // err = "Past sales turnover above HKD 50 million is not allowed. Please contact the SME team for other policy types."
                                err = `Annual sales turnover above HKD 50 million is not allowed for $productName. Please contact the SME team for other policy types.`.replace('$productName', this.selectedProductName)

                            }
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity(err);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                            } else {
                                this.questionList[sectionIndex].isSectionOpen = true
                                this.questionList[sectionIndex].iconName = "utility:up"
                                setTimeout(() => {
                                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                    inputField.setCustomValidity(err);
                                    inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                    inputField.reportValidity();
                                }, 500);
                            }
                            return false
                        }
                    }
                    else if (['PastDate', 'FutureDate'].includes(question.validationType)) {

                        let checkErrorDate = this.checkErrorDate(inputValue, question.validationType)
                        if (checkErrorDate) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity(checkErrorDate);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                            } else {
                                this.questionList[sectionIndex].isSectionOpen = true
                                this.questionList[sectionIndex].iconName = "utility:up"
                                setTimeout(() => {
                                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                    inputField.setCustomValidity(checkErrorDate);
                                    inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                    inputField.reportValidity();
                                }, 500);
                            }
                            return false
                        }
                    } else if (question.validationType === 'Country_Market') {
                        // debugger
                        if (question.total_percentage !== 100 || this.hasInvalidCountryOrMarket(question.Name)) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                question.errMsg = "Please provide all the fields and complete 100% country market"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }
                            this.questionList[sectionIndex].isSectionOpen = true
                            this.questionList[sectionIndex].iconName = "utility:up"
                            setTimeout(() => {
                                question.errMsg = "Please provide all the fields and complete 100% country market"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }, 500);

                            return false
                        }
                    } else if (question.validationType === 'Benificiary_Owners') {
                        // debugger
                        const errMsg = this.isValidBenificiary()
                        if (errMsg) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                question.errMsg = errMsg
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }
                            this.questionList[sectionIndex].isSectionOpen = true
                            this.questionList[sectionIndex].iconName = "utility:up"
                            setTimeout(() => {
                                question.errMsg = errMsg
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }, 500);

                            return false
                        }
                    }

                    // else if (question.validationType === 'Percent') {
                    //     if (!this.isPercentage(inputValue)) {
                    //         // isSectionOpen = true
                    //         // inputField = this.template.querySelector(`[data-id='${dataId}']`);
                    //         if (inputField) {
                    //             inputField.setCustomValidity("Please enter proper percentage value");
                    //             inputField.reportValidity();
                    //         }
                    //         return false
                    //     }
                    // } 
                    else if (question.validationType === 'BRNumber') {
                        if (!inputValue || !this.isNum(inputValue) || String(inputValue).length !== 8) {
                            // debugger
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity("Please enter the first 8 digits of the BR number.");
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                            } else {
                                this.questionList[sectionIndex].isSectionOpen = true
                                this.questionList[sectionIndex].iconName = "utility:up"
                                setTimeout(() => {
                                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                    inputField.setCustomValidity("Please enter the first 8 digits of the BR number.");
                                    inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                    inputField.reportValidity();
                                }, 500);
                            }

                            return false
                        }
                    }
                    else if (question.validationType === 'Radio') {
                        if (!(inputValue + '' == 'true' || inputValue + '' == 'false')) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                question.errMsg = "This field is required"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }
                            this.questionList[sectionIndex].isSectionOpen = true
                            this.questionList[sectionIndex].iconName = "utility:up"
                            setTimeout(() => {
                                question.errMsg = "This field is required"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }, 500);

                            return false
                        }
                    }
                    else if (question.validationType === 'Currency') {
                        if (!this.isCurrency(inputValue)) {
                            if (this.questionList[sectionIndex].isSectionOpen) {
                                question.errMsg = "Invalid value"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }
                            this.questionList[sectionIndex].isSectionOpen = true
                            this.questionList[sectionIndex].iconName = "utility:up"
                            setTimeout(() => {
                                question.errMsg = "Invalid value"
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                return false
                            }, 500);

                            return false
                        }
                    }
                    else if (question.validationType === 'Address') {
                        if (!question.address.address_line_1) {

                            if (this.questionList[sectionIndex].isSectionOpen) {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity("This field is required");
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                                return false
                            }
                            this.questionList[sectionIndex].isSectionOpen = true
                            this.questionList[sectionIndex].iconName = "utility:up"
                            setTimeout(() => {
                                inputField = this.template.querySelector(`[data-id='${dataId}']`);
                                inputField.setCustomValidity("This field is required");
                                inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                                inputField.reportValidity();
                                return false
                            }, 500);

                            return false
                        }
                    }
                    if (this.questionList[question.sectionIndex].isSectionOpen) {
                        if (question.isRadio || ['Benificiary_Owners', "Country_Market", 'Currency'].includes(question.validationType)) {
                            question.errMsg = ""
                            return true
                        }
                        inputField = this.template.querySelector(`[data-id='${dataId}']`);
                        inputField.setCustomValidity(""); // clear previous value
                        inputField.reportValidity();
                    }
                    return true
                }
                // debugger
                if (!inputValue) {

                    if (this.questionList[sectionIndex].isSectionOpen) {
                        // if (question.isRadio) {
                        //     question.errMsg = "This field is required"
                        //     inputField = this.template.querySelector(`[data-id='${dataId}']`);
                        //     inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                        //     inputField.reportValidity();
                        //     return false
                        // }
                        inputField = this.template.querySelector(`[data-id='${dataId}']`);
                        inputField.setCustomValidity("This field is required");
                        inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                        inputField.reportValidity();
                    } else {
                        this.questionList[sectionIndex].isSectionOpen = true
                        this.questionList[sectionIndex].iconName = "utility:up"
                        setTimeout(() => {
                            // if (question.isRadio) {
                            //     question.errMsg = "This field is required"
                            //     inputField = this.template.querySelector(`[data-id='${dataId}']`);
                            //     inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                            //     inputField.reportValidity();
                            //     return false
                            // }
                            inputField = this.template.querySelector(`[data-id='${dataId}']`);
                            inputField.setCustomValidity("This field is required");
                            inputField.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
                            inputField.reportValidity();
                        }, 500);
                    }
                    return false
                }
                if (this.questionList[question.sectionIndex].isSectionOpen) {
                    // if (question.isRadio) {
                    //     question.errMsg = ""
                    //     return true
                    // }
                    inputField = this.template.querySelector(`[data-id='${dataId}']`);
                    inputField.setCustomValidity(""); // clear previous value
                    inputField.reportValidity();
                }

                // inputField.reportValidity();
                return true
            }


            // }
            return true
        } catch (error) {
            console.log("error=>", error)
            return false
        }
    }
    validateAllInputs() {
        let allInputsCorrect = true
        // this.questionList[0].isSectionOpen = true
        for (var key of Object.keys(this.questionMap)) {
            allInputsCorrect = this.validateSingleInput(key)
            console.log(key + " -> ", allInputsCorrect)
            if (!allInputsCorrect)
                break
        }
        return allInputsCorrect
    }
    setAdditionalDataIntoProposal() {
        if (this.benificiary_owners) {
            this.benificiary_owners.forEach(el => {
                let name = el.name.split(" ")
                el.LastName = name[name.length - 1].trim()
                el.FirstName = el.name.replace(name[name.length - 1], "").trim()
            })
            this.proposal.Benificiary_Owners__c = JSON.stringify(this.benificiary_owners)
        }
        if (this.buyers) {
            this.proposal.Buyer_List__c = JSON.stringify(this.buyers)
        }
        // this.proposal['Company_Address_Registered__c'] = JSON.stringify(this.registeredAddress)
        this.proposal.Registered_Address_Line_1__c = this.registeredAddress.address_line_1
        this.proposal.Registered_Address_Line_2__c = this.registeredAddress.address_line_2
        this.proposal.Registered_Address_Line_3__c = this.registeredAddress.address_line_3
        // this.proposal['Company_Address_Correspondence__c'] = JSON.stringify(this.correspondenceAddress)
        this.proposal.Correspondence_Address_Line_1__c = this.correspondenceAddress.address_line_1
        this.proposal.Correspondence_Address_Line_2__c = this.correspondenceAddress.address_line_2
        this.proposal.Correspondence_Address_Line_3__c = this.correspondenceAddress.address_line_3

        this.proposal.Country_Market_Of_Shipment__c = JSON.stringify(this.countryMarket_Shipment.map(({ availableCountry, ...rest }) => rest))
        this.proposal.Destination_Country_Market__c = JSON.stringify(this.countryMarket_Destination.map(({ availableCountry, ...rest }) => rest))
        this.proposal.Country_Market_Of_Origin__c = JSON.stringify(this.countryMarket_Origin.map(({ availableCountry, ...rest }) => rest))
        this.proposal.Receive_Date__c = this.today

        if (this.selectedProductName == "SBP") {
            this.exclusionOptions.forEach(el => {
                this.proposal[el.dataId + '__c'] = el.isChecked ? true : false
            })
        }

        const tempList = this.companyLegalTypeOptions.filter(el => el.value == this.proposal.Company_Legal_Type__c)
        if (tempList.length) {
            this.proposal.Company_Legal_Type_Label__c = tempList[0].label
        }
        const tempList1 = this.goodsServiceOptions.filter(el => el.value == this.proposal.Goods_And_Service__c)
        if (tempList1.length) {
            this.proposal.Goods_And_Service_Label__c = tempList1[0].label
        }


    }

    showOnboardingProposalConfirmation() {
        this.setAdditionalDataIntoProposal()
        if (!this.validateAllInputs()) {
            console.log("all inputs are not provided");
            return
        }
        if (this.selectedProductName == 'OMBP') {
            if (this.proposal.Policy_Commence_Date__c) {
                delete this.proposal.Policy_Commence_Date__c
            }
        }
        console.log("calling Br verification API");
        if (this.proposal.Promotion_Code__c) {
            promoCodeExist({ promoCode: this.proposal.Promotion_Code__c }).then(res => {
                console.log("promo code exists::", res);
                if (!res) {
                    this.showToast("Invalid Promotion Code")

                }
            }).catch(error => {
                console.error(error);
            })
        }
        BRExist({ brNumber: this.proposal.BR_Number__c }).then(res => {
            console.log("Br Already exists")
            if (res) {
                this.showToast("This BR number is already used")
            } else {
                if (this.usrId) {
                    this.verifyBRNumberAPI()
                } else {
                    this.gotoConfirmation()
                }
            }
        }).catch(error => {
            console.error(error);
        })


    }
    gotoConfirmation() {
        console.log(' ====> showOnboardingProposalConfirmation', JSON.stringify(this.proposal))
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingProposalConfirmation', proposal: this.proposal, brFile: this.brFile }
        });
        this.dispatchEvent(event1)

    }
    showOnboardingDP() {
        this.setAdditionalDataIntoProposal()
        console.log(' ====> showOnboardingDP')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingDP', proposal: this.proposal }
        });
        this.dispatchEvent(event1)
    }


    openfileUpload(event) {
        try {
            const file = event.target.files[0]
            console.log(file.size)
            if (file.size > MAX_FILE_SIZE) {
                this.showToast("File Size Can not exceed " + MAX_FILE_SIZE_NAME);
                // this.brFile.fileName
                return
            }
            const tempName = file.name.split('.')
            if (!acceptedFormats.includes(tempName[tempName.length - 1])) {
                this.showToast(`Plase upload ${acceptedFormats.join(', ')} file only`);
                return
            }
            var reader = new FileReader()
            reader.onload = () => {
                this.proposal.BR_Document__c = file.name
                this.questionMap.BR_Document__c.Value = file.name
                var base64 = reader.result.split(',')[1]
                this.brFile = {
                    'file': encodeURIComponent(base64),
                    'filename': file.name
                }
                console.log(JSON.stringify(this.brFile))
                try {
                    let inputField = this.template.querySelector(`[data-id='BR_Document__c']`);
                    inputField.setCustomValidity(""); // clear previous value
                    inputField.reportValidity();
                } catch (error) {
                    console.error("Br file validation error");
                }
                // this.fileData = {
                //     'filename': file.name,
                //     'base64': base64,

                // }
            }
            reader.readAsDataURL(file)
        } catch (error) {
            console.error(error);
        }
    }

    handleClick() {
        const { base64, filename, recordId } = this.fileData
        uploadFile({ base64, filename, recordId }).then(result => {
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
            this.showToast(title)
        })
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

    get today() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    get policyCommencementDate() {
        var now = new Date();
        if (now.getMonth() == 11) {
            var current = new Date(now.getFullYear() + 1, 0, 1);
        } else {
            var current = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        }

        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }

    //hard code territory
    registeredTerritory = ""
    correspondenceTerritory = ""
    // @track districtTerritory = {}
    @track districtTerritory = { "Hong Kong": ["Kennedy Town", "Shek Tong Tsui", "Sai Ying Pun", "Sheung Wan", "Central", "Admiralty", "Mid-levels", "Peak", "Wan Chai", "Causeway Bay", "Happy Valley", "Tai Hang", "So Kon Po", "Jardine's Lookout", "Tin Hau", "Braemar Hill", "North Point", "Quarry Bay", "Sai Wan Ho", "Shau Kei Wan", "Chai Wan", "Siu Sai Wan", "Pok Fu Lam", "Aberdeen", "Ap Lei Chau", "Wong Chuk Hang", "Shouson Hill", "Repulse Bay", "Chung Hom Kok", "Stanley", "Tai Tam", "Shek O"], "Kowloon": ["Tsim Sha Tsui", "Yau Ma Tei", "West Kowloon Reclamation", "King's Park", "Mong Kok", "Tai Kok Tsui", "Mei Foo", "Lai Chi Kok", "Cheung Sha Wan", "Sham Shui Po", "Shek Kip Mei", "Yau Yat Tsuen,Tai Wo Ping", "Stonecutters Island", "Hung Hom", "To Kwa Wan", "Ma Tau Kok", "Ma Tau Wai", "Kai Tak", "Kowloon City", "Ho Man Tin", "Kowloon Tong", "Beacon Hill", "San Po Kong", "Wong Tai Sin", "Tung Tau", "Wang Tau Hom", "Lok Fu", "Diamond Hill", "Tsz Wan Shan", "Ngau Chi Wan", "Ping Shek", "Kowloon Bay", "Ngau Tau Kok", "Jordan Valley", "Kwun Tong", "Sau Mau Ping", "Lam Tin", "Yau Tong", "Lei Yue Mun"], "New Territories": ["Kwai Chung", "Tsing Yi", "Tsuen Wan", "Lei Muk Shue", "Ting Kau", "Sham Tseng", "Tsing Lung Tau", "Ma Wan", "Sunny Bay", "Tai Lam Chung", "So Kwun Wat", "Tuen Mun", "Lam Tei", "Hung Shui Kiu", "Ha Tsuen", "Lau Fau Shan", "Tin Shui Wai", "Yuen Long", "San Tin", "Lok Ma Chau", "Kam Tin", "Shek Kong", "Pat Heung", "Fanling", "Luen Wo Hui", "Sheung Shui", "Shek Wu Hui", "Sha Tau Kok", "Luk Keng", "Wu Kau Tang", "Tai Po Market", "Tai Po", "Tai Po Kau", "Tai Mei Tuk", "Shuen Wan", "Cheung Muk Tau", "Kei Ling Ha", "Tai Wai", "Sha Tin", "Fo Tan", "Ma Liu Shui", "Wu Kai Sha", "Ma On Shan", "Clear Water Bay", "Sai Kung", "Tai Mong Tsai", "Tseung Kwan O", "Hang Hau", "Tiu Keng Leng", "Ma Yau Tong", "Cheung Chau", "Peng Chau", "Lantau Island(including Tung Chung)", "Lamma Island"] }
    get territoryOptions() {
        return Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el }))
    }
    @track registeredDistrictOptions = []
    @track correspondenceDistrictOptions = []


    get titleOptions() {
        return [
            { label: 'CEO', value: 'CEO' },
            { label: 'MD', value: 'MD' }
        ]
    }
    // get knowAboutEcicOptions() {
    //     return [
    //         { label: 'Facebook', value: 'Facebook' },
    //         { label: 'Google Search', value: 'Google Search' },
    //         { label: 'MTR Advertisement', value: 'MTR Advertisement' },
    //         { label: 'Referral', value: 'Referral' },
    //     ]
    // }
    get turnOverOptions() {
        return [
            { label: 'HKD 1-10,000,000', value: 'HKD 1-10,000,000' },
            { label: 'HKD 10,000,001 – 20,000,000', value: 'HKD 10,000,001 – 20,000,000' },
            { label: 'HKD 20,000,001 – 30,000,000', value: 'HKD 20,000,001 – 30,000,000' },
            { label: 'HKD 30,000,001 – 40,000,000', value: 'HKD 30,000,001 – 40,000,000' },
            { label: 'HKD 40,000,001 – 50,000,000', value: 'HKD 40,000,001 – 50,000,000' },
            { label: 'HKD 50,000,001 and above', value: 'HKD 50,000,001 and above' }
        ];
    }

    get automicRenewalOptions() {
        return [
            { label: this.label.Automatic, value: 'Automatic Renewal' },
            { label: this.label.Manual, value: 'Manual Renewal' }
        ]
    }

    get languageOptions() {
        return [
            { label: this.label.English, value: 'English' },
            { label: this.label.Chinese, value: 'Chinese' }
        ]
    }
    get countryOptions() {
        return [
            { label: "Australia", value: "Australia" },
            { label: "Austria", value: "Austria" },
            { label: "Belgium", value: "Belgium" },
            { label: "Bermuda", value: "Bermuda" },
            { label: "Brunei Darussalam", value: "Brunei Darussalam" },
            { label: "Canada", value: "Canada" },
            { label: "Chile", value: "Chile" },
            { label: "China", value: "China" },
            { label: "Czechia", value: "Czechia" },
            { label: "Denmark", value: "Denmark" },
            { label: "Finland", value: "Finland" },
            { label: "France", value: "France" },
            { label: "Gabon", value: "Gabon" },
            { label: "Germany", value: "Germany" },
            { label: "Holy See", value: "Holy See" },
            { label: "Ireland", value: "Ireland" },
            { label: "Italy", value: "Italy" },
            { label: "Japan", value: "Japan" },
            { label: "Korea, Republic of ", value: "Korea, Republic of " },
            { label: "Kuwait", value: "Kuwait" },
            { label: "Liechtensteni", value: "Liechtensteni" },
            { label: "Luxembourg", value: "Luxembourg" },
            { label: "Macao", value: "Macao" },
            { label: "Monaco", value: "Monaco" },
            { label: "Netherlands", value: "Netherlands" },
            { label: "New Zealand", value: "New Zealand" },
            { label: "Norway", value: "Norway" },
            { label: "Oman", value: "Oman" },
            { label: "Portugal", value: "Portugal" },
            { label: "Qatar", value: "Qatar" },
            { label: "San Marino", value: "San Marino" },
            { label: "Saudi Arabia", value: "Saudi Arabia" },
            { label: "Singapore", value: "Singapore" },
            { label: "Spain", value: "Spain" },
            { label: "Sweden", value: "Sweden" },
            { label: "Switzerland", value: "Switzerland" },
            { label: "Taiwan", value: "Taiwan" },
            { label: "United Arab Emirates", value: "United Arab Emirates" },
            { label: "United Kindom", value: "United Kindom" },
            { label: "United States of America", value: "United States of America" },
            { label: "Aland Island", value: "Aland Island" },
            { label: "American Samoa", value: "American Samoa" },
            { label: "Andorra", value: "Andorra" },
            { label: "Anguilla", value: "Anguilla" },
            { label: "Aruba", value: "Aruba" },
            { label: "Bahamas", value: "Bahamas" },
            { label: "Bonaire, Sint Eustatius and Saba", value: "Bonaire, Sint Eustatius and Saba" },
            { label: "Botswana", value: "Botswana" },
            { label: "Bouvet Island", value: "Bouvet Island" },
            { label: "Brazil", value: "Brazil" },
            { label: "British Indian Ocean Territory", value: "British Indian Ocean Territory" },
            { label: "Cayman Islands", value: "Cayman Islands" },
            { label: "Christmas Island", value: "Christmas Island" },
            { label: "Cocos (Keeling) Islands", value: "Cocos (Keeling) Islands" },
            { label: "Colombia", value: "Colombia" },
            { label: "Cook Islands", value: "Cook Islands" },
            { label: "Curacao", value: "Curacao" },
            { label: "Cuyprus", value: "Cuyprus" },
            { label: "Estonia", value: "Estonia" },
            { label: "Eswatini", value: "Eswatini" },
            { label: "Falkland Island (Malvinas)", value: "Falkland Island (Malvinas)" },
            { label: "Faroe", value: "Faroe" },
            { label: "French Guiana", value: "French Guiana" },
            { label: "French Polynesia", value: "French Polynesia" },
            { label: "French Southern Territories", value: "French Southern Territories" },
            { label: "Gibraltar", value: "Gibraltar" },
            { label: "Greenland", value: "Greenland" },
            { label: "Guadeloupe", value: "Guadeloupe" },
            { label: "Guam", value: "Guam" },
            { label: "Guernsey", value: "Guernsey" },
            { label: "Heard Island and McDonald Islands", value: "Heard Island and McDonald Islands" },
            { label: "Hungary", value: "Hungary" },
            { label: "Iceland", value: "Iceland" },
            { label: "India", value: "India" },
            { label: "Indonesia", value: "Indonesia" },
            { label: "Isle of Man", value: "Isle of Man" },
            { label: "Israel", value: "Israel" },
            { label: "Jersey", value: "Jersey" },
            { label: "Latvia", value: "Latvia" },
            { label: "Lithuania", value: "Lithuania" },
            { label: "Malaysia", value: "Malaysia" },
            { label: "Malta", value: "Malta" },
            { label: "Martinique", value: "Martinique" },
            { label: "Mauritius", value: "Mauritius" },
            { label: "Mayotee", value: "Mayotee" },
            { label: "Mexico", value: "Mexico" },
            { label: "Montserrat", value: "Montserrat" },
            { label: "Morocco", value: "Morocco" },
            { label: "Namibia", value: "Namibia" },
            { label: "New Caledonia", value: "New Caledonia" },
            { label: "Niue", value: "Niue" },
            { label: "Norflol Island", value: "Norflol Island" },
            { label: "Northern Mariana Islands", value: "Northern Mariana Islands" },
            { label: "Panama", value: "Panama" },
            { label: "Peru", value: "Peru" },
            { label: "Philippines", value: "Philippines" },
            { label: "Pitcairn", value: "Pitcairn" },
            { label: "Poland", value: "Poland" },
            { label: "Puerto Rico", value: "Puerto Rico" },
            { label: "Reunion", value: "Reunion" },
            { label: "Romania", value: "Romania" },
            { label: "Russian Federation", value: "Russian Federation" },
            { label: "Saint Barthelemy", value: "Saint Barthelemy" },
            { label: "Saint Helena, Ascension and Tristan Da Cunha", value: "Saint Helena, Ascension and Tristan Da Cunha" },
            { label: "Saint Pierre and Miquelon", value: "Saint Pierre and Miquelon" },
            { label: "Sint Maarten (Dutch Part)", value: "Sint Maarten (Dutch Part)" },
            { label: "Slovakia", value: "Slovakia" },
            { label: "Slovenia", value: "Slovenia" },
            { label: "South Africa", value: "South Africa" },
            { label: "South Georgia and the South Sandwich Islands", value: "South Georgia and the South Sandwich Islands" },
            { label: "Svalbard and Jan Mayen", value: "Svalbard and Jan Mayen" },
            { label: "Thailand", value: "Thailand" },
            { label: "Tokelau", value: "Tokelau" },
            { label: "Trinidad and Tobago", value: "Trinidad and Tobago" },
            { label: "Turks and Caicas Islands", value: "Turks and Caicas Islands" },
            { label: "Uruguay", value: "Uruguay" },
            { label: "Virgin Islands, British", value: "Virgin Islands, British" },
            { label: "Virgin Islands, U.S.", value: "Virgin Islands, U.S." },
            { label: "Wallis and Futuna", value: "Wallis and Futuna" },
            { label: "Algeria", value: "Algeria" },
            { label: "Angola", value: "Angola" },
            { label: "Argentina", value: "Argentina" },
            { label: "Azerbaijan", value: "Azerbaijan" },
            { label: "Bahrain", value: "Bahrain" },
            { label: "Bangladesh", value: "Bangladesh" },
            { label: "Barbodas", value: "Barbodas" },
            { label: "Benin", value: "Benin" },
            { label: "Bhutan", value: "Bhutan" },
            { label: "Bolivia (Plurinational State of)", value: "Bolivia (Plurinational State of)" },
            { label: "Bulgaria", value: "Bulgaria" },
            { label: "Burkina Faso", value: "Burkina Faso" },
            { label: "Cabo Verde", value: "Cabo Verde" },
            { label: "Cameroon", value: "Cameroon" },
            { label: "Comoros", value: "Comoros" },
            { label: "Costa Rica", value: "Costa Rica" },
            { label: "Croatia", value: "Croatia" },
            { label: "Djibouti", value: "Djibouti" },
            { label: "Dominica", value: "Dominica" },
            { label: "Dominican Republic", value: "Dominican Republic" },
            { label: "Ecuador", value: "Ecuador" },
            { label: "Egypt", value: "Egypt" },
            { label: "El Salvador", value: "El Salvador" },
            { label: "Equatorial Guinea", value: "Equatorial Guinea" },
            { label: "Ethiopia", value: "Ethiopia" },
            { label: "Fiji", value: "Fiji" },
            { label: "Ghana", value: "Ghana" },
            { label: "Greece", value: "Greece" },
            { label: "Guatemala", value: "Guatemala" },
            { label: "Honduras", value: "Honduras" },
            { label: "Iran, Islamic Republic of", value: "Iran, Islamic Republic of" },
            { label: "Jamaica", value: "Jamaica" },
            { label: "Jordan", value: "Jordan" },
            { label: "Kazakhstan", value: "Kazakhstan" },
            { label: "Kenya", value: "Kenya" },
            { label: "Lao People's Democratic Repubic", value: "Lao People's Democratic Repubic" },
            { label: "Lesotho", value: "Lesotho" },
            { label: "Maldives", value: "Maldives" },
            { label: "Mali", value: "Mali" },
            { label: "Manogolia", value: "Manogolia" },
            { label: "Myanmar", value: "Myanmar" },
            { label: "Nepal", value: "Nepal" },
            { label: "Niger", value: "Niger" },
            { label: "Nigeria", value: "Nigeria" },
            { label: "Pakistan", value: "Pakistan" },
            { label: "Papua New Guinea", value: "Papua New Guinea" },
            { label: "Paraguay", value: "Paraguay" },
            { label: "Saint Lucia", value: "Saint Lucia" },
            { label: "Saint Vincent and the Grenadines", value: "Saint Vincent and the Grenadines" },
            { label: "Samoa", value: "Samoa" },
            { label: "Sao Tome and Principe", value: "Sao Tome and Principe" },
            { label: "Serbia", value: "Serbia" },
            { label: "Senegal", value: "Senegal" },
            { label: "Seychelles", value: "Seychelles" },
            { label: "Solomon Islands", value: "Solomon Islands" },
            { label: "Srilanka", value: "Srilanka" },
            { label: "Suriname", value: "Suriname" },
            { label: "Togo", value: "Togo" },
            { label: "Tonga", value: "Tonga" },
            { label: "Tunisia", value: "Tunisia" },
            { label: "Turkey", value: "Turkey" },
            { label: "Vanuatu", value: "Vanuatu" },
            { label: "Vietnam", value: "Vietnam" },

        ].sort((a, b) => a.value.localeCompare(b.value))
    }
    get applicationReasonOptions() {
        return [
            { label: this.label.Protection, value: 'Protection' },
            { label: this.label.Credit_Control, value: 'Credit Control' },
            { label: this.label.Financing, value: 'Financing' },
            { label: this.label.Expansion_of_Business, value: 'Expansion of business' },
            { label: this.label.Other_please_specify, value: 'Other' },
        ]
    }
    get indemnityRatioOptionsOMBP() {
        return [
            { label: '90%', value: "0" }]
    }
    get indemnityRatioOptionsSBP() {
        return [
            { label: '60%', value: "30" },
            { label: '70%', value: "20" },
            { label: '80%', value: "10" },
            { label: '90%', value: "0" }]
    }
    get indemnityRatioOptionsSUP() {
        return [
            { label: '50%', value: "30" },
            { label: '60%', value: "20" },
            { label: '70%', value: "10" },
            { label: '80%', value: "0" }]
    }

    get NQLOptionsSBP() {
        return [
            { label: 'HKD 0', value: "0" },
            { label: 'HKD 50,000', value: "5" },
            { label: 'HKD 100,000', value: "10" }
        ]
    }

    get NQLOptionsSUP() {
        return [
            { label: 'HKD 0', value: "0" },
            { label: 'HKD 50,000', value: "5" },
            { label: 'HKD 100,000', value: "10" }
        ]

    }
    get paymentOptions() {
        return [
            { label: 'One-Off', value: "One-Off" },
            { label: 'Quarterly', value: "Quarterly" },
        ]
    }

    @track sectionAQuestions = {
        "sectionLabel": this.label.Section_A_Business_Detail,
        "sectionId": "sectionA",
        "iconName": "utility:up",
        "isSectionOpen": true,
        "questions": [
            {
                "Display_Sequence": 1,
                "Question": this.label.Company_Name,
                "Name": "Company_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": true,
                "isRequired": true

            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Type_of_business_entity,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 3,
                "Question": this.label.Holding_bank_account_in_Hong_Kong,
                "Name": "Bank_Account__c",
                "Value": "",
                "options": [
                    {
                        "label": this.label.Yes,
                        "value": true,
                        "isChecked": false
                    },
                    {
                        "label": this.label.No,
                        "value": false,
                        "isChecked": false

                    }
                ],
                "isRadio": true,
                "validationType": "Radio",
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                "isGoodsAndService": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 7,
                "Question": this.label.Language_Of_Correspondence,
                "Name": "Language_of_Correspondence__c",
                "Value": "",
                "options": this.languageOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 8,
                "Question": this.label.Sales_turnover_for_the_last_12_months,
                "Name": "Past_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Past_Turnover"
            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Future_Turnover"


            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "validationType": "Number",
                "isRequired": true
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Largest_credit_limit_required,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "validationType": "Currency",
                "isRequired": true
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            }
        ]
    }
    @track sectionAQuestionsSBP = {
        "sectionLabel": this.label.Section_A_Business_Detail,
        "sectionId": "sectionA",
        "iconName": "utility:up",
        "isSectionOpen": true,
        "questions": [
            {
                "Display_Sequence": 1,
                "Question": this.label.Company_Name,
                "Name": "Company_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": true,
                "isRequired": true

            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Type_of_business_entity,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 3,
                "Question": this.label.Holding_bank_account_in_Hong_Kong,
                "Name": "Bank_Account__c",
                "Value": "",
                "options": [
                    {
                        "label": this.label.Yes,
                        "value": true,
                        "isChecked": false
                    },
                    {
                        "label": this.label.No,
                        "value": false,
                        "isChecked": false

                    }
                ],
                "isRadio": true,
                "validationType": "Radio",
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Commencement_Date,
                "Name": "Policy_Commence_Date__c",
                "Value": this.policyCommencementDate,
                "isText": true,
                "readOnly": true,
                "isRequired": true

            },
            {
                "Display_Sequence": 5,
                "Question": this.label.Policy_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                "isGoodsAndService": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 7,
                "Question": this.label.Language_Of_Correspondence,
                "Name": "Language_of_Correspondence__c",
                "Value": "",
                "options": this.languageOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 8,
                "Question": this.label.Sales_turnover_for_the_last_12_months,
                "Name": "Past_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Past_Turnover"

            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Future_Turnover"


            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "validationType": "Number",
                "isRequired": true
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Largest_credit_limit_required,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "validationType": "Currency",
                "isRequired": true
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            }
        ]
    }
    @track sectionAQuestionsSUP = {
        "sectionLabel": this.label.Section_A_Business_Detail,
        "sectionId": "sectionA",
        "iconName": "utility:up",
        "isSectionOpen": true,
        "questions": [
            {
                "Display_Sequence": 1,
                "Question": this.label.Company_Name,
                "Name": "Company_Name__c",
                "Question_old": "Company name",
                "Value": "",
                "isText": true,
                "readOnly": true,
                "isRequired": true
            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Type_of_business_entity,
                "Name": "Company_Legal_Type__c",
                "Question_old": "Company legal type",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 3,
                "Question": this.label.Holding_bank_account_in_Hong_Kong,
                "Name": "Bank_Account__c",
                "Question_old": "Bank account",
                "Value": "",
                "options": [
                    {
                        "label": this.label.Yes,
                        "value": true,
                        "isChecked": false
                    },
                    {
                        "label": this.label.No,
                        "value": false,
                        "isChecked": false

                    }
                ],
                "isRadio": true,
                "validationType": "Radio",
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Commencement_Date,
                "Name": "Policy_Commence_Date__c",
                "Value": this.policyCommencementDate,
                "isText": true,
                "readOnly": true,
                "isRequired": true
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Payment_Option,
                "Name": "Payment_Option__c",
                "Value": "",
                "options": this.paymentOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 5,
                "Question": this.label.Policy_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                "isGoodsAndService": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 7,
                "Question": this.label.Language_Of_Correspondence,
                "Name": "Language_of_Correspondence__c",
                "Value": "",
                "options": this.languageOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 8,
                "Question": this.label.Sales_turnover_for_the_last_12_months,
                "Name": "Past_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Past_Turnover"
            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Future_Turnover"
            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "validationType": "Number",
                "isRequired": true
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Largest_credit_limit_required,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "validationType": "Currency",
                "isRequired": true
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Country_Market_of_Shipment,
                "Name": "Country_Market_Of_Shipment__c",
                "Value": "",
                "percentageStyle": "width : 0%",
                "showAddButton": true,
                "total_percentage": 0,
                "validationType": "Country_Market",
                "isRequired": true,
                "isCountryMarketOfShipment": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Destination_Country_Market,
                "Name": "Destination_Country_Market__c",
                "Value": "",
                "percentageStyle": "width : 0%",
                "showAddButton": true,
                "total_percentage": 0,
                "validationType": "Country_Market",
                "isRequired": true,
                "isDestinationCountryMarket": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Country_Market_of_Origin,
                "Name": "Country_Market_Of_Origin__c",
                "Value": "",
                "percentageStyle": "width : 0%",
                "total_percentage": 0,
                "validationType": "Country_Market",
                "isRequired": true,
                "isCountryMarketOfOrigin": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 42,
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            },
            {
                "Display_Sequence": 43,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Currency",
            }
        ]
    }
    @track sectionBQuestions = {
        "sectionLabel": this.label.Section_B_Company_Detail,
        "sectionId": "sectionB",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 14,
                "Question": this.label.Business_registration_certificate_number_first_8_digits,
                "Name": "BR_Number__c",
                "Question_old": "BR number (first 8 digits)",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "BRNumber",
            },
            {
                "Display_Sequence": 15,
                "Question": this.label.Business_registration_certificate_expiry_date,
                "Name": "BR_Expiry_Date__c",
                "Value": "",
                "isDate": true,
                "readOnly": false,
                "isRequired": true,
                'minDate': this.today,
                "validationType": "FutureDate",
            },
            {
                "Display_Sequence": 16,
                "Question": this.label.Upload_file,
                "Name": "BR_Document__c",
                "Question_old": "Upload BR",
                "Value": "",
                "isUpload": true,
                "readOnly": false,
                "isRequired": true,
                // "validationType": "File",
            },
            {
                "Display_Sequence": 17,
                "Question": this.label.Date_of_incorporation,
                "Name": "Corporate_Incorporation_Date__c",
                'maxDate': this.today,
                "Value": "",
                "isDate": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "PastDate",
            },
            {
                "Display_Sequence": 18,
                "Question": this.label.Registered_address_English,
                "Name": "Company_Address_Registered__c",
                "Value": "",
                "address": this.registeredAddress,
                "isAddress": true,
                "validationType": "Address",
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 19,
                "Question": this.label.Territory_English,
                "Name": "Registered_Territory__c",
                "Value": "",
                "options": this.territoryOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 20,
                "Question": this.label.District_English,
                "Name": "Registered_District__c",
                "Value": "",
                "options": this.registeredDistrictOptions,
                "isRegisteredDistrict": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 21,
                "Question": this.label.Same_as_registered_address_English,
                "Name": "Registered_Correspondence_Same__c",
                "Value": "",
                "options": [
                    {
                        "label": this.label.Yes,
                        "value": true,
                        "isChecked": false
                    },
                    {
                        "label": this.label.No,
                        "value": false,
                        "isChecked": false

                    }
                ],
                "isRadio": true,
                "validationType": "Radio",
                "isChecked": false,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 22,
                "Question": this.label.Correspondence_address_English,
                "Name": "Company_Address_Correspondence__c",
                "Value": "",
                "address": this.correspondenceAddress,
                "isAddress": true,
                "validationType": "Address",
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 23,
                "Question": this.label.Territory_English,
                "Name": "Correspondence_Territory__c",
                "Value": "",
                "options": this.territoryOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 24,
                "Question": this.label.District_English,
                "Name": "Correspondence_District__c",
                "Value": "",
                "options": this.correspondenceDistrictOptions,
                "isCorrespondenceDistrict": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 25,
                "Question": this.label.Reason_of_application,
                "Name": "Application_Reason__c",
                "Value": "",
                "options": this.applicationReasonOptions,
                "isApplicationReason": true,
                "readOnly": false,
                "isRequired": true
            }
        ]
    }
    @track sectionCQuestions = {
        "sectionLabel": this.label.Section_C_Director_shareholder_sole_proprietor_partner,
        "sectionId": "sectionC",
        "iconName": "utility:down",
        "isSectionOpen": false,
        // "isSectionC": true,
        "questions": [
            {
                "Display_Sequence": 26,
                // "Question": "Benificiary Owners",
                "Name": "Benificiary_Owners__c",
                "Value": "",
                "isBenificiaryOwners": true,
                "readOnly": false,
                "isRequired": true,
                "validationType": "Benificiary_Owners"
            }
        ]
    }
    @track sectionDQuestionsOMBP = {
        "sectionLabel": this.label.Section_D_Self_Selected_Policy_Terms,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 26,
                "Question": this.label.Percentage_of_Indemnity,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsOMBP,
                "isPickList": true,
                "readOnly": true
            }
        ]
    }
    @track sectionDQuestionsSBP = {
        "sectionLabel": this.label.Section_D_Self_Selected_Policy_Terms,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 26,
                "Question": this.label.Percentage_of_Indemnity,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsSBP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 27,
                "Question": this.label.Non_qualifying_loss_amount,
                "Name": "NQL__c",
                "Value": "",
                "options": this.NQLOptionsSBP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 28,
                "Question": this.label.Exclusion_of_risk,
                "Name": "Exclusions__c",
                "Value": "",
                "isExclusion": true,
                "readOnly": true
            }
        ]
    }
    @track sectionDQuestionsSUP = {
        "sectionLabel": this.label.Section_D_Potential_Buyers,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 56,
                "Question": this.label.Percentage_of_Indemnity,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsSUP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 57,
                "Question": this.label.Non_qualifying_loss_amount,
                "Name": "NQL__c",
                "Value": "",
                "options": this.NQLOptionsSUP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Buyer_Details,
                "Name": "Add_Buyer__c",
                "Value": "",
                "isAddBuyer": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 60,
                "Question": this.label.Maximum_Liability,
                "Name": "Maximum_Liability__c",
                "Value": "500000",
                "formattedValue": "500,000",
                "isMaximumLiability": true,
                "Max": "3000000",
                "Min": "500000",
                "Step": "500000",
                "readOnly": false
            }
        ]
    }
    @track sectionEQuestions = {
        "sectionLabel": this.label.Section_E_Contact_Details,
        "sectionId": "sectionE",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 29,
                "Question": this.label.Contact_person_First_name,
                "Name": "First_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 29,
                "Question": this.label.Contact_person_Last_name,
                "Name": "Last_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 30,
                "Question": this.label.Job_title,
                "Name": "Title__c",
                "Value": "",
                "options": this.titleOptions,
                "isText": true,
                "readOnly": false,
                "isRequired": true

            },
            {
                "Display_Sequence": 31,
                "Question": this.label.Email_Address,
                "Name": "Company_Email__c",
                "Value": "",
                "isText": true,
                "readOnly": true,
                "isRequired": true
            },
            {
                "Display_Sequence": 32,
                "Question": this.label.Company_phone_number,
                "Name": "Company_Telephone_Number__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 32,
                "Question": this.label.Mobile_Phone_Number,
                "Name": "Mobile_Number__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Question": this.label.Enable_SMS_notifications,
                "Name": "Enable_SMS_Notification__c",
                "Value": "",
                "options": [
                    {
                        "label": this.label.Yes,
                        "value": true,
                        "isChecked": false
                    },
                    {
                        "label": this.label.No,
                        "value": false,
                        "isChecked": false

                    }
                ],
                "isRadio": true,
                "validationType": "Radio",
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 33,
                "Question": this.label.How_did_you_know_HKECIC,
                "Name": "Know_About_Hkecic__c",
                "Value": "",
                "options": this.knowAboutEcicOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 34,
                "Question": this.label.Reference_code,
                "Name": "Promotion_Code__c",
                "Value": "",
                "isText": true,
                "readOnly": false
            }

        ]
    }
}
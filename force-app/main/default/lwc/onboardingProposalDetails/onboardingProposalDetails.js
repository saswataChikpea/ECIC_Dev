import { LightningElement, track, wire } from 'lwc';
import getIndustryList from '@salesforce/apex/GetCustomMetaData.getIndustryList';
import getLegalTypeList from '@salesforce/apex/GetCustomMetaData.getLegalTypeList';
import getKnowAboutEcicList from '@salesforce/apex/GetCustomMetaData.getKnowAboutEcicList';
import getCompleteProposal from '@salesforce/apex/OnboardingCreateSiteUser.getCompleteProposal';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getProducts from '@salesforce/apex/OnBoarding.getProducts'


import Section_A_Business_Detail from '@salesforce/label/c.Section_A_Business_Detail';
import Company_Name from '@salesforce/label/c.Company_Name';
import Company_legal_type from '@salesforce/label/c.Company_legal_type';
import Bank_account from '@salesforce/label/c.Bank_account';
import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';
import Goods_and_services_industry from '@salesforce/label/c.Goods_and_services_industry';
import Language_Of_Correspondence from '@salesforce/label/c.Language_Of_Correspondence';
import Sales_turnover_for_the_last_12_months from '@salesforce/label/c.Sales_turnover_for_the_last_12_months';
import Sales_turnover_for_the_next_12_months from '@salesforce/label/c.Sales_turnover_for_the_next_12_months';
import Number_of_insurable_buyers from '@salesforce/label/c.Number_of_insurable_buyers';
import Average_amount_of_credit_limit from '@salesforce/label/c.Average_amount_of_credit_limit';
import Bad_debt_amount from '@salesforce/label/c.Bad_debt_amount';
import Overdue_amount from '@salesforce/label/c.Overdue_amount';
import Policy_commencement_date from '@salesforce/label/c.Policy_commencement_date';
import Automatic_renewal_or_manual_renewal from '@salesforce/label/c.Automatic_renewal_or_manual_renewal';
import Payment_Option from '@salesforce/label/c.Payment_Option';
import Add_Country_Market_of_Shipment from '@salesforce/label/c.Add_Country_Market_of_Shipment';
import Add_Destination_Country_Market from '@salesforce/label/c.Add_Destination_Country_Market';
import Add_Country_Market_of_Origin from '@salesforce/label/c.Add_Country_Market_of_Origin';
import Section_B_Company_Profile from '@salesforce/label/c.Section_B_Company_Profile';
import BR_number_first_8_digits from '@salesforce/label/c.BR_number_first_8_digits';
import BR_expiry_date from '@salesforce/label/c.BR_expiry_date';
import Upload_BR from '@salesforce/label/c.Upload_BR';
import Corporate_incorporation_date from '@salesforce/label/c.Corporate_incorporation_date';
import Company_address_registered from '@salesforce/label/c.Company_address_registered';
import Company_address_registered_Territory from '@salesforce/label/c.Company_address_registered_Territory';
import Company_address_registered_District from '@salesforce/label/c.Company_address_registered_District';
import Company_address_correspondence_same_as_company_address_registered from '@salesforce/label/c.Company_address_correspondence_same_as_company_address_registered';
import Company_address_correspondence from '@salesforce/label/c.Company_address_correspondence';
import Company_address_correspondence_Territory from '@salesforce/label/c.Company_address_correspondence_Territory';
import Company_address_correspondence_District from '@salesforce/label/c.Company_address_correspondence_District';
import Reason_of_application from '@salesforce/label/c.Reason_of_application';
import Section_C_Director_shareholder_sole_proprietor_partner from '@salesforce/label/c.Section_C_Director_shareholder_sole_proprietor_partner';
import Section_D_Extra_Information from '@salesforce/label/c.Section_D_Extra_Information';
import Indemnity_Ratio from '@salesforce/label/c.Indemnity_Ratio';
import NQL from '@salesforce/label/c.NQL';
import Section_D_Potential_Buyers from '@salesforce/label/c.Section_D_Potential_Buyers';
import Add_Buyer_Details from '@salesforce/label/c.Add_Buyer_Details';
import Maximum_Liability from '@salesforce/label/c.Maximum_Liability';
import Section_E_Contact_Details from '@salesforce/label/c.Section_E_Contact_Details';
import First_Name from '@salesforce/label/c.First_Name';
import Last_Name from '@salesforce/label/c.Last_Name';
import Title from '@salesforce/label/c.Title';
import Email_Address from '@salesforce/label/c.Email_Address';
import Company_Telephone_Number from '@salesforce/label/c.Company_Telephone_Number';
import Mobile_number from '@salesforce/label/c.Email_Address';
import Enable_SMS_notifications from '@salesforce/label/c.Enable_SMS_notifications';
import How_did_you_know_about_the_HKECIC from '@salesforce/label/c.How_did_you_know_about_the_HKECIC';
import Promotion_code from '@salesforce/label/c.Promotion_code';

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


export default class OnboardingProposalDetails extends LightningElement {
    @track label = {
        Section_A_Business_Detail, Company_Name, Company_legal_type, Bank_account, Yes, No, Goods_and_services_industry,
        Language_Of_Correspondence, Sales_turnover_for_the_last_12_months, Sales_turnover_for_the_next_12_months,
        Number_of_insurable_buyers, Average_amount_of_credit_limit, Bad_debt_amount, Overdue_amount, Policy_commencement_date,
        Automatic_renewal_or_manual_renewal, Payment_Option, Add_Country_Market_of_Shipment, Add_Destination_Country_Market,
        Add_Country_Market_of_Origin, Section_B_Company_Profile, BR_number_first_8_digits, BR_expiry_date, Upload_BR,
        Corporate_incorporation_date, Company_address_registered, Company_address_registered_Territory, Company_address_registered_District,
        Company_address_correspondence_same_as_company_address_registered, Company_address_correspondence, Company_address_correspondence_Territory,
        Company_address_correspondence_District, Reason_of_application, Section_C_Director_shareholder_sole_proprietor_partner,
        Section_D_Extra_Information, Indemnity_Ratio, NQL, Section_D_Potential_Buyers, Add_Buyer_Details, Maximum_Liability,
        Section_E_Contact_Details, First_Name, Last_Name, Title, Email_Address, Company_Telephone_Number, Mobile_number,
        Enable_SMS_notifications, How_did_you_know_about_the_HKECIC, Promotion_code, Manual, Automatic, English, Chinese,
        Protection, Credit_Control, Financing, Expansion_of_Business, Other_please_specify, Director, Shareholder,
        Sole_Proprietor
    }

    proposalId
    selectedProductName
    @track propsoal
    @track products
    @track questionMap = {}
    @track registeredAddress = {}
    @track correspondenceAddress = {}
    @track questionList = []

    connectedCallback() {
        this.getProducts()
    }
    getProducts() {
        console.log('getProducts called.');
        getProducts({}).then(data => {
            console.log('getProducts success :' + JSON.stringify(data));
            this.products = data
            this.loadData()
        })
    }



    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        //    if (currentPageReference) {
        //       this.urlStateParameters = currentPageReference.state;
        //       this.setParametersBasedOnUrl();
        //    }
        console.log("currentPageReference::", JSON.stringify(currentPageReference));
        this.proposalId = currentPageReference.state.id
        if (this.proposalId) {
            this.handlegetCompleteProposal()
        } else {
            this.showToast("Invalid Proposal Id")
            // this.navDashboard()
        }

    }
    handlegetCompleteProposal() {
        getCompleteProposal({ id: this.proposalId }).then(data => {
            console.log("getCompleteProposal::", data);
            this.proposal = data
            this.loadData()
        }).catch(error => {
            console.log('getCompleteProposal error::', error);
        })

    }
    loadData() {
        if (this.proposal && this.products) {
            this.selectedProductName = this.products.filter(el => (el.Id == this.proposal.Product__c))[0].Name
            console.log("selected product name::", this.selectedProductName);
            this.loadFromProposal()
        }
    }
    loadFromProposal() {

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
        this.questionList.forEach((section) => {
            if (section.questions) {
                section.questions.forEach((question) => {
                    question.Display_Sequence = sequence
                    question.readOnly = true
                    sequence += 1
                    if (question.Name in this.proposal) {
                        if (question.isRadio) {
                            question.options = question.options.map(el => {
                                el.isChecked = el.value + '' == this.proposal[question.Name] + '' ? true : false
                                return el
                            })

                        } else if (question.validationType == 'Number') {
                            question.Value = Number(this.proposal[question.Name]).toLocaleString('en-US', { maximumFractionDigits: 2 })
                        } else {
                            question.Value = String(this.proposal[question.Name])
                        }

                    }
                    this.questionMap[question.Name] = question
                }
                )
            }
        })
        if (this.proposal['Benificiary_Owners__c']) {
            this.benificiary_owners = JSON.parse(this.proposal.Benificiary_Owners__c)
        }
        if (this.proposal['Buyer_List__c']) {
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
        if ('Maximum_Liability__c' in this.proposal) {
            // this.questionMap['Maximum_Liability__c'].formattedValue = Number(this.proposal.Maximum_Liability__c).toLocaleString('en-US', { maximumFractionDigits: 2 })
            if (this.questionMap['Maximum_Liability__c']) {
                this.questionMap['Maximum_Liability__c'].formattedValue = Number(this.proposal.Maximum_Liability__c) ? Number(this.proposal.Maximum_Liability__c).toLocaleString('en-US', { maximumFractionDigits: 2 }) : "0"
            }

        }
        if ('Country_Market_Of_Shipment__c' in this.proposal) {
            this.countryMarket_Shipment = JSON.parse(this.proposal.Country_Market_Of_Shipment__c)
        }
        if ('Destination_Country_Market__c' in this.proposal) {
            this.countryMarket_Destination = JSON.parse(this.proposal.Destination_Country_Market__c)
        }
        if ('Country_Market_Of_Origin__c' in this.proposal) {
            this.countryMarket_Origin = JSON.parse(this.proposal.Country_Market_Of_Origin__c)
        }
        this.registeredAddress.address_line_1 = this.proposal['Registered_Address_Line_1__c'] || ""
        this.registeredAddress.address_line_2 = this.proposal['Registered_Address_Line_2__c'] || ""
        this.registeredAddress.address_line_3 = this.proposal['Registered_Address_Line_3__c'] || ""

        this.correspondenceAddress.address_line_1 = this.proposal['Correspondence_Address_Line_1__c'] || ""
        this.correspondenceAddress.address_line_2 = this.proposal['Correspondence_Address_Line_2__c'] || ""
        this.correspondenceAddress.address_line_3 = this.proposal['Correspondence_Address_Line_3__c'] || ""
    }


    navDashboard() {
        console.log('navDashboard')
        // if (this.usrId) {
        //     console.log('redirecting to dashboard')
        window.location.href = '/ECReach/s/dashboard'
        // } else {
        //     window.location.href = '/ECReach/s/login'
        // }
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

    districtTerritory = { "Hong Kong": ["Kennedy Town", "Shek Tong Tsui", "Sai Ying Pun", "Sheung Wan", "Central", "Admiralty", "Mid-levels", "Peak", "Wan Chai", "Causeway Bay", "Happy Valley", "Tai Hang", "So Kon Po", "Jardine's Lookout", "Tin Hau", "Braemar Hill", "North Point", "Quarry Bay", "Sai Wan Ho", "Shau Kei Wan", "Chai Wan", "Siu Sai Wan", "Pok Fu Lam", "Aberdeen", "Ap Lei Chau", "Wong Chuk Hang", "Shouson Hill", "Repulse Bay", "Chung Hom Kok", "Stanley", "Tai Tam", "Shek O"], "Kowloon": ["Tsim Sha Tsui", "Yau Ma Tei", "West Kowloon Reclamation", "King's Park", "Mong Kok", "Tai Kok Tsui", "Mei Foo", "Lai Chi Kok", "Cheung Sha Wan", "Sham Shui Po", "Shek Kip Mei", "Yau Yat Tsuen,Tai Wo Ping", "Stonecutters Island", "Hung Hom", "To Kwa Wan", "Ma Tau Kok", "Ma Tau Wai", "Kai Tak", "Kowloon City", "Ho Man Tin", "Kowloon Tong", "Beacon Hill", "San Po Kong", "Wong Tai Sin", "Tung Tau", "Wang Tau Hom", "Lok Fu", "Diamond Hill", "Tsz Wan Shan", "Ngau Chi Wan", "Ping Shek", "Kowloon Bay", "Ngau Tau Kok", "Jordan Valley", "Kwun Tong", "Sau Mau Ping", "Lam Tin", "Yau Tong", "Lei Yue Mun"], "New Territories": ["Kwai Chung", "Tsing Yi", "Tsuen Wan", "Lei Muk Shue", "Ting Kau", "Sham Tseng", "Tsing Lung Tau", "Ma Wan", "Sunny Bay", "Tai Lam Chung", "So Kwun Wat", "Tuen Mun", "Lam Tei", "Hung Shui Kiu", "Ha Tsuen", "Lau Fau Shan", "Tin Shui Wai", "Yuen Long", "San Tin", "Lok Ma Chau", "Kam Tin", "Shek Kong", "Pat Heung", "Fanling", "Luen Wo Hui", "Sheung Shui", "Shek Wu Hui", "Sha Tau Kok", "Luk Keng", "Wu Kau Tang", "Tai Po Market", "Tai Po", "Tai Po Kau", "Tai Mei Tuk", "Shuen Wan", "Cheung Muk Tau", "Kei Ling Ha", "Tai Wai", "Sha Tin", "Fo Tan", "Ma Liu Shui", "Wu Kai Sha", "Ma On Shan", "Clear Water Bay", "Sai Kung", "Tai Mong Tsai", "Tseung Kwan O", "Hang Hau", "Tiu Keng Leng", "Ma Yau Tong", "Cheung Chau", "Peng Chau", "Lantau Island(including Tung Chung)", "Lamma Island"] }
    territoryOptions = Object.keys(this.districtTerritory).map((el) => ({ label: el, value: el }))
    @track districtOptions = []
    a = Object.keys(this.districtTerritory).forEach((el) => {
        this.districtOptions.push(...this.districtTerritory[el].map((el) => ({ label: el, value: el })))
    })

    get titleOptions() {
        return [
            { label: 'CEO', value: 'CEO' },
            { label: 'MD', value: 'MD' }
        ]
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
            // if (this.questionMap['Know_About_Hkecic__c'])
            //     this.questionMap['Know_About_Hkecic__c'].options = this.knowAboutEcicOptions
        }
        else if (error) {
            console.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        }
    }
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
    get automicRenewalOptions() {
        return [
            { label: this.label.Automatic, value: 'Automatic Renewal' },
            { label: this.label.Manual, value: 'Manual Renewal' }
        ]
    }
    get goodsServiceOptions() {
        return this.productList.length && this.productList
            .filter(el => (el.PRD_PCY_TYPE__c == this.proposal.Policy_Type__c))
            .map(el => ({ label: el.PRD_DESC__c, value: el.PRD_CODE__c, code: el.PRD_CODE__c }))
            .sort((a, b) => a.label.localeCompare(b.label))
        // console.log("goodsServiceOptions:::::", JSON.stringify(temp));
        // return temp
    }
    @track productList = []
    @wire(getIndustryList, {})
    callgetProduct({ error, data }) {
        if (data) {
            console.log("ProductList:" + JSON.stringify(data));
            this.productList = data
        }
        else {
            console.log('error::', JSON.stringify(error));
        }
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
            { label: "Manoco", value: "Manoco" },
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

        ]
    }
    get applicationReasonOptions() {
        return [
            { label: this.label.Protection, value: 'Protection' },
            { label: this.label.Credit_Control, value: 'Credit Control' },
            { label: this.label.Financing, value: 'Financing' },
            { label: this.label.Expansion_of_Business, value: 'Expansion of business' },
            { label: this.label.Other_please_specify, value: 'Other (please specify)' },
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
    sectionAQuestions = {
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
                "options": [],
                "isText": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Company_legal_type,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 3,
                "Question": this.label.Bank_account,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_and_services_industry,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                isGoodsAndService: true,
                "readOnly": false
            },
            {
                "Display_Sequence": 7,
                "Question": this.label.Language_Of_Correspondence,
                "Name": "Language_of_Correspondence__c",
                "Value": "",
                "options": this.languageOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 8,
                "Question": this.label.Sales_turnover_for_the_last_12_months,
                "Name": "Past_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "options": [],
                "isText": true,
                "validationType": "Number",
                "readOnly": false
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Average_amount_of_credit_limit,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "options": [],
                "isCurrency": true,
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_amount,
                "Name": "Bad_Debt_Amount__c",
                "Question_old": "Bad debt amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Overdue_amount,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            }
        ]
    }
    sectionAQuestionsSBP = {
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
                "options": [],
                "isText": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Company_legal_type,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 3,
                "Question": this.label.Bank_account,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Policy_commencement_date,
                "Name": "Policy_Commence_Date__c",
                "Value": this.policyCommencementDate,
                "options": [],
                "isText": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 5,
                "Question": this.label.Automatic_renewal_or_manual_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_and_services_industry,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                isGoodsAndService: true,
                "readOnly": false
            },
            {
                "Display_Sequence": 7,
                "Question": this.label.Language_Of_Correspondence,
                "Name": "Language_of_Correspondence__c",
                "Value": "",
                "options": this.languageOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 8,
                "Question": this.label.Sales_turnover_for_the_last_12_months,
                "Name": "Past_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "options": [],
                "isText": true,
                "validationType": "Number",
                "readOnly": false
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Average_amount_of_credit_limit,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "options": [],
                "isCurrency": true,
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_amount,
                "Name": "Bad_Debt_Amount__c",
                "Question_old": "Bad debt amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Overdue_amount,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            }
        ]
    }
    sectionAQuestionsSUP = {
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
                "options": [],
                "isText": true,
                "readOnly": true,
                "isRequired": true
            },
            {
                "Display_Sequence": 2,
                "Question": this.label.Company_legal_type,
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
                "Question": this.label.Bank_account,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Policy_commencement_date,
                "Name": "Policy_Commence_Date__c",
                "Value": this.policyCommencementDate,
                "options": [],
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
                "Question": this.label.Automatic_renewal_or_manual_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                isText: true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_and_services_industry,
                "Name": "Goods_And_Service__c",
                "Value": "",
                "options": this.goodsServiceOptions,
                isGoodsAndService: true,
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
                "isRequired": true
            },
            {
                "Display_Sequence": 9,
                "Question": this.label.Sales_turnover_for_the_next_12_months,
                "Name": "Future_Turnover__c",
                "Value": "",
                "options": this.turnOverOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 10,
                "Question": this.label.Number_of_insurable_buyers,
                "Name": "Insurable_Buyers__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false,
                "validationType": "Number",
                "isRequired": true
            },
            {
                "Display_Sequence": 11,
                "Question": this.label.Average_amount_of_credit_limit,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false,
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Country_Market_of_Shipment,
                "Name": "Country_Market_Of_Shipment__c",
                "Value": "",
                "options": [],
                "percentageStyle": "width : 0%",
                "showAddButton": true,
                "total_percentage": 0,
                "isCountryMarketOfShipment": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Destination_Country_Market,
                "Name": "Destination_Country_Market__c",
                "Value": "",
                "options": [],
                "percentageStyle": "width : 0%",
                "showAddButton": true,
                "total_percentage": 0,
                "isDestinationCountryMarket": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 59,
                "Question": this.label.Add_Country_Market_of_Origin,
                "Name": "Country_Market_Of_Origin__c",
                "Value": "",
                "options": [],
                "percentageStyle": "width : 0%",
                "total_percentage": 0,
                "isCountryMarketOfOrigin": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 42,
                "Question": this.label.Bad_debt_amount,
                "Name": "Bad_Debt_Amount__c",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
            },
            {
                "Display_Sequence": 43,
                "Question": this.label.Overdue_amount,
                "Name": "Overdue_Amount__c",
                "Question_old": "Overdue amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
            }
        ]
    }
    sectionBQuestions = {
        "sectionLabel": this.label.Section_B_Company_Profile,
        "sectionId": "sectionB",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 14,
                "Question": this.label.BR_number_first_8_digits,
                "Name": "BR_Number__c",
                "Question_old": "BR number (first 8 digits)",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 15,
                "Question": this.label.BR_expiry_date,
                "Name": "BR_Expiry_Date__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 16,
                "Question": this.label.Upload_BR,
                "Name": "BR_Document__c",
                "Question_old": "Upload BR",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 17,
                "Question": this.label.Corporate_incorporation_date,
                "Name": "Corporate_Incorporation_Date__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 18,
                "Question": this.label.Company_address_registered,
                "Name": "Company_Address_Registered__c",
                "Value": "",
                "address": this.registeredAddress,
                "isAddress": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 19,
                "Question": this.label.Company_address_registered_Territory,
                "Name": "Registered_Territory__c",
                "Value": "",
                "options": this.territoryOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 20,
                "Question": this.label.Company_address_registered_District,
                "Name": "Registered_District__c",
                "Value": "",
                "options": this.districtOptions,
                "isPickList": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 21,
                "Question": this.label.Company_address_correspondence_same_as_company_address_registered,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 22,
                "Question": this.label.Company_address_correspondence,
                "Name": "Company_Address_Correspondence__c",
                "Value": "",
                "address": this.correspondenceAddress,
                "isAddress": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 23,
                "Question": this.label.Company_address_correspondence_Territory,
                "Name": "Correspondence_Territory__c",
                "Value": "",
                "options": this.territoryOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 24,
                "Question": this.label.Company_address_correspondence_District,
                "Name": "Correspondence_District__c",
                "Value": "",
                "options": this.districtOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 25,
                "Question": this.label.Reason_of_application,
                "Name": "Application_Reason__c",
                "Value": "",
                "options": this.applicationReasonOptions,
                isText: true,
                "readOnly": false
            }
        ]
    }
    sectionCQuestions = {
        "sectionLabel": this.label.Section_C_Director_shareholder_sole_proprietor_partner,
        "sectionId": "sectionC",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "isSectionC": true,
        "readOnly": true
    }
    sectionDQuestionsOMBP = {
        "sectionLabel": this.label.Section_D_Extra_Information,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 26,
                "Question": this.label.Indemnity_Ratio,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsOMBP,
                "isPickList": true,
                "readOnly": true
            }
        ]
    }
    sectionDQuestionsSBP = {
        "sectionLabel": this.label.Section_D_Extra_Information,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 26,
                "Question": this.label.Indemnity_Ratio,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsSBP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 27,
                "Question": this.label.NQL,
                "Name": "NQL__c",
                "Value": "",
                "options": this.NQLOptionsSBP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 28,
                "Question": this.label.Exclusions_proposal,
                "Name": "Exclusions__c",
                "Value": "",
                "options": [],
                "isExclusion": true,
                "readOnly": true
            }
        ]
    }
    sectionDQuestionsSUP = {
        "sectionLabel": this.label.Section_D_Potential_Buyers,
        "sectionId": "sectionD",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 56,
                "Question": this.label.Indemnity_Ratio,
                "Name": "Indemnity_Percentage__c",
                "Value": "",
                "options": this.indemnityRatioOptionsSUP,
                "isPickList": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 57,
                "Question": this.label.NQL,
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
                "options": [],
                "isAddBuyer": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 60,
                "Question": this.label.Maximum_Liability,
                "Name": "Maximum_Liability__c",
                "Value": "500000",
                "isSlider": true,
                "Max": "3000000",
                "Min": "500000",
                "Step": "500000",
                "options": [],
                "readOnly": false
            }
        ]
    }
    sectionEQuestions = {
        "sectionLabel": this.label.Section_E_Contact_Details,
        "sectionId": "sectionE",
        "iconName": "utility:down",
        "isSectionOpen": false,
        "questions": [
            {
                "Display_Sequence": 29,
                "Question": this.label.First_Name,
                "Name": "First_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 29,
                "Question": this.label.Last_Name,
                "Name": "Last_Name__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 30,
                "Question": this.label.Title,
                "Name": "Title__c",
                "Value": "",
                "options": this.titleOptions,
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 31,
                "Question": this.label.Email_Address,
                "Name": "Company_Email__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 32,
                "Question": this.label.Company_Telephone_Number,
                "Name": "Company_Telephone_Number__c",
                "Value": "",
                "isText": true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 32,
                "Question": this.label.Mobile_number,
                "Name": "Mobile_Number__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
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
                "Question": this.label.How_did_you_know_about_the_HKECIC,
                "Name": "Know_About_Hkecic__c",
                "Value": "",
                "options": this.knowAboutEcicOptions,
                // "isPickList": true,
                isText: true,
                "readOnly": false
            },
            {
                "Display_Sequence": 34,
                "Question": this.label.Promotion_code,
                "Name": "Promotion_Code__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            }

        ]
    }
}
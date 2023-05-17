import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile'
import reviseQuotation from '@salesforce/apex/OnboardingCreateSiteUser.reviseQuotation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getProduct from '@salesforce/apex/GetCustomMetaData.getProduct';
import ammendQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.ammendQuoteAura'
import getIndustryList from '@salesforce/apex/GetCustomMetaData.getIndustryList';
import getLegalTypeList from '@salesforce/apex/GetCustomMetaData.getLegalTypeList';
import getKnowAboutEcicList from '@salesforce/apex/GetCustomMetaData.getKnowAboutEcicList';

import Section_A_Business_Detail from '@salesforce/label/c.Section_A_Business_Detail';
import Company_Name from '@salesforce/label/c.Company_Name';
import Type_of_business_entity from '@salesforce/label/c.Type_of_business_entity';
import Holding_bank_account_in_Hong_Kong from '@salesforce/label/c.Holding_bank_account_in_Hong_Kong';
import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';
import Goods_Services from '@salesforce/label/c.Goods_Services';
import Language_Of_Correspondence from '@salesforce/label/c.Language_Of_Correspondence';
import Sales_turnover_for_the_last_12_months from '@salesforce/label/c.Sales_turnover_for_the_last_12_months';
import Sales_turnover_for_the_next_12_months from '@salesforce/label/c.Sales_turnover_for_the_next_12_months';
import Number_of_insurable_buyers from '@salesforce/label/c.Number_of_insurable_buyers';
import Largest_credit_limit_required from '@salesforce/label/c.Largest_credit_limit_required';
import Bad_debt_in_the_last_24_months from '@salesforce/label/c.Bad_debt_in_the_last_24_months';
import Amount_currently_overdue_for_more_than_30_days from '@salesforce/label/c.Amount_currently_overdue_for_more_than_30_days';
import Commencement_Date from '@salesforce/label/c.Commencement_Date';
import Policy_renewal from '@salesforce/label/c.Policy_renewal';
import Payment_Option from '@salesforce/label/c.Payment_Option';
import Add_Country_Market_of_Shipment from '@salesforce/label/c.Add_Country_Market_of_Shipment';
import Add_Destination_Country_Market from '@salesforce/label/c.Add_Destination_Country_Market';
import Add_Country_Market_of_Origin from '@salesforce/label/c.Add_Country_Market_of_Origin';
import Section_B_Company_Detail from '@salesforce/label/c.Section_B_Company_Detail';
import Business_registration_certificate_number_first_8_digits from '@salesforce/label/c.Business_registration_certificate_number_first_8_digits';
import Business_registration_certificate_expiry_date from '@salesforce/label/c.Business_registration_certificate_expiry_date';
import Upload_file from '@salesforce/label/c.Upload_file';
import Date_of_incorporation from '@salesforce/label/c.Date_of_incorporation';
import Registered_address_English from '@salesforce/label/c.Registered_address_English';
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
import Mobile_Phone_Number from '@salesforce/label/c.Email_Address';
import Enable_SMS_notifications from '@salesforce/label/c.Enable_SMS_notifications';
import How_did_you_know_HKECIC from '@salesforce/label/c.How_did_you_know_HKECIC';
import Reference_code from '@salesforce/label/c.Reference_code';

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
import Exclusion_of_risk from '@salesforce/label/c.Exclusion_of_risk';
import Please_confirm_all_the_details_provided_to_create_a_proposal from '@salesforce/label/c.Please_confirm_all_the_details_provided_to_create_a_proposal';
import Country_Market_of_Shipment from '@salesforce/label/c.Country_Market_of_Shipment';
import of_country_market_of_shipment from '@salesforce/label/c.of_country_market_of_shipment';
import Number_No from '@salesforce/label/c.Number_No';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Buyer_Address from '@salesforce/label/c.Buyer_Address';
import Buyer_Country from '@salesforce/label/c.Buyer_Country';
import Save from '@salesforce/label/c.Save';
import Type from '@salesforce/label/c.Type';
import Name from '@salesforce/label/c.Name';
import Back from '@salesforce/label/c.Back';
import Revise_Quotation from '@salesforce/label/c.Revise_Quotation';
import Confirm from '@salesforce/label/c.Confirm';


const FIELDS = ['Account.Name'];

export default class OnboardingProposalConfirmation extends LightningElement {

    @track label = {
        Section_A_Business_Detail, Company_Name, Type_of_business_entity, Holding_bank_account_in_Hong_Kong, Yes, No, Goods_Services,
        Language_Of_Correspondence, Sales_turnover_for_the_last_12_months, Sales_turnover_for_the_next_12_months,
        Number_of_insurable_buyers, Largest_credit_limit_required, Bad_debt_in_the_last_24_months, Amount_currently_overdue_for_more_than_30_days, Commencement_Date,
        Policy_renewal, Payment_Option, Add_Country_Market_of_Shipment, Add_Destination_Country_Market,Revise_Quotation,
        Add_Country_Market_of_Origin, Section_B_Company_Detail, Business_registration_certificate_number_first_8_digits, Business_registration_certificate_expiry_date, Upload_file,
        Date_of_incorporation, Registered_address_English, Territory_English, District_English,Type,Name,Back,Confirm,
        Same_as_registered_address_English, Correspondence_address_English,Country_Market_of_Shipment,of_country_market_of_shipment,
        Reason_of_application, Section_C_Director_shareholder_sole_proprietor_partner,Number_No,Buyer_Name,Buyer_Address,Buyer_Country,
        Section_D_Self_Selected_Policy_Terms, Percentage_of_Indemnity, Non_qualifying_loss_amount, Section_D_Potential_Buyers, Add_Buyer_Details, Maximum_Liability,
        Section_E_Contact_Details, Contact_person_First_name, Contact_person_Last_name, Job_title, Email_Address, Company_phone_number, Mobile_Phone_Number,
        Enable_SMS_notifications, How_did_you_know_HKECIC, Reference_code, Manual, Automatic, English, Chinese,Save,
        Protection, Credit_Control, Financing, Expansion_of_Business, Other_please_specify, Director, Shareholder,
        Sole_Proprietor,Exclusion_of_risk,Please_confirm_all_the_details_provided_to_create_a_proposal




    }

    @api proposal = {}
    @api products
    @api selectedproduct = ""
    // @api selectedproduct = "a090w000005Um1GAAS"
    selectedProductName = ""
    @track questionList = []
    @track questionMap = {}
    @api quote = {}

    @api isReviseQuote
    @track company_name = ""
    @track pastTurnOver = ""
    @track nextTurnOver = ""
    @track insurableBuyers = ""
    @api
    myRecordId;

    //country market
    @track countryMarket_Shipment = [{ "no": 1, "country": "", "percentage": 0, "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    @track countryMarket_Destination = [{ "no": 1, "country": "", "percentage": 0, "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    @track countryMarket_Origin = [{ "no": 1, "country": "", "percentage": 0, "key": 0, "editable": true, availableCountry: [...this.countryOptions] }]
    countrymarketfor


    @track registeredAddress = {
        "readOnly": true,
        "address_line_1": "",
        "address_line_2": "",
        "address_line_3": "",
        "terriitory": "",
        "district": ""
    }
    @track correspondenceAddress = {
        "readOnly": true,
        "address_line_1": "",
        "address_line_2": "",
        "address_line_3": "",
        "terriitory": "",
        "district": ""
    }

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    // products = [{ "Id": "a090w000005Um1HAAS", "Name": "OMBP", "Premium_Rate__c": 0.8, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mI4d&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Online Micro Business Policy", "Display_Sequence__c": 1 }, { "Id": "a090w000005Um1IAAS", "Name": "SBP", "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mL4V&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Small Business Policy", "Display_Sequence__c": 2 }, { "Id": "a090w000005Um1GAAS", "Name": "SUP", "Premium_Rate__c": 103, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mL4W&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Self Underwritten Policy", "Display_Sequence__c": 3 }]
    // proposal = { "Company_Name__c": "Arindam", "Past_Turnover__c": "HKD 40,000,001 – 50,000,000", "Company_Legal_Type__c": "Partnership", "Indemnity_Percentage__c": 20 }
    // proposal = { "Bank_Account__c": "false", "BR_Document__c": "something.png", "Registered_Correspondence_Same__c": false, "Bad_Debt_Amount__c": "43534545", "Sales_Amount_Range__c": "45894579845", "BR_Expiry_Date__c": "2021-06-30", "Corporate_Incorporation_Date__c": "2021-06-30", "Maximum_Liability__c": "1000000", "Company_Name__c": "test", "Company_Email__c": "test@gmail.com", "Past_Turnover__c": "HKD 30,000,001 – 40,000,000", "Future_Turnover__c": "HKD 30,000,001 – 40,000,000", "Self_Approving_CL__c": "Yes", "Indemnity_Percentage__c": "20", "NQL__c": "5", "Benificiary_Owners__c": "[{\"name\":\"dsdfjlkjlk\",\"type\":\"Beneficial owner\",\"key\":0,\"editable\":true,\"LastName\":\"dsdfjlkjlk\",\"FirstName\":\"\"},{\"name\":\"arindam\",\"type\":\"Director\",\"key\":1,\"editable\":true,\"LastName\":\"arindam\",\"FirstName\":\"\"},{\"name\":\"bla bla bla\",\"type\":\"Authorized person\",\"key\":2,\"editable\":true,\"LastName\":\"bla\",\"FirstName\":\"bla bla\"}]", "Buyer_List__c": "[{\"name\":\"ari\",\"address\":\"tst\",\"country\":\"India\",\"key\":0,\"editable\":false}]" }
    // proposal = { "Company_Address_Registered__c": "{\"readOnly\":true,\"address_line_1\":\"fsdljflksdjflk\",\"address_line_2\":\"fdskfkl\",\"address_line_3\":\"fdfldsjflk\",\"terriitory\":\"\",\"district\":\"\"}", "Correspondence_Territory__c": "KOWLOON", "Registered_District__c": "Eastern", "Benificiary_Owners__c": "[{\"name\":\"\",\"type\":\"\",\"key\":0,\"editable\":true,\"LastName\":\"\",\"FirstName\":\"\"}]", "Buyer_List__c": "[{\"name\":\"\",\"address\":\"\",\"key\":0,\"editable\":true}]", "Country_Market_Of_Shipment__c": "[{\"no\":1,\"country\":\"Algeria\",\"percentage\":56,\"key\":0,\"editable\":true},{\"no\":2,\"country\":\"American Samoa\",\"percentage\":44,\"key\":1,\"editable\":true}]", "Destination_Country_Market__c": "[{\"no\":1,\"country\":\"Aland Island\",\"percentage\":55,\"key\":0,\"editable\":true},{\"no\":2,\"country\":\"American Samoa\",\"percentage\":45,\"key\":1,\"editable\":true}]", "Country_Market_Of_Origin__c": "[{\"no\":1,\"country\":\"Aland Island\",\"percentage\":67,\"key\":0,\"editable\":true},{\"no\":2,\"country\":\"Algeria\",\"percentage\":33,\"key\":1,\"editable\":true}]" }
    connectedCallback() {
        console.log('proposal=' + JSON.stringify(this.proposal), 'selected_product' + this.selectedproduct)
        // console.log('products=' + JSON.stringify(this.products))
        // this.callgetProduct()
        // if (this.proposal) {
        //     this.company_name = this.proposal.Company_Name__c
        //     // this.account_fields[0].Value = this.proposal.Company_Name__c
        //     // this.userDetail["Account_Name"] = this.proposal.Company_Name__c
        //     this.pastTurnOver = this.proposal.Past_Turnover__c ? this.proposal.Past_Turnover__c : ""
        //     this.nextTurnOver = this.proposal.Future_Turnover__c ? this.proposal.Future_Turnover__c : ""
        //     this.insurableBuyers = this.proposal.Insurable_Buyers__c ? this.proposal.Insurable_Buyers__c : ""
        // }
        if (this.proposal)
            this.proposal = { ...this.proposal }
        if (this.proposal && this.selectedproduct) {
            this.products.forEach((rec, index) => {
                if (rec.Id === this.selectedproduct)
                    this.selectedProductName = rec.Name
            })
            this.loadFromProposal()

        }
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

    @track exclusionOptions = []
    get benificiaryOptions() {
        return [{ label: this.label.Director, value: "Director" }, { label: this.label.Shareholder, value: "Shareholder" }, { label: this.label.Sole_Proprietor, value: "Sole-proprietor" }, { label: "Partner", value: "Partner" }]
    }
    @track benificiary_owners = [

    ]

    @track show_save_btn = false;
    addRow() {
        var key = this.benificiary_owners.length;
        this.benificiary_owners.push({
            'name': '',
            'address': '',
            'country': '',
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
    @track buyers = []

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
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.contact = data;
        }
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

    showOnboardingTermsAndConditions() {
        console.log(' ====> showOnboardingTermsAndConditions')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingTermsAndConditions', proposal: this.proposal }
        });
        this.dispatchEvent(event1)
    }
    showPrevious() {
        console.log(' ====> showOnboardingFillInProposal')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingFillInProposal', proposal: this.proposal }
        });
        this.dispatchEvent(event1)
    }


    @api fileRecordId;
    fileData
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.fileRecordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }

    handleClick() {
        const { base64, filename, recordId } = this.fileData
        uploadFile({ base64, filename, recordId }).then(result => {
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
            this.toast(title)
        })
    }

    callReviseQuotation() {

        //alert('callCreateProposal')
        console.log("reviseQuotation: " + JSON.stringify(this.proposal))
        reviseQuotation({ proposal: this.proposal, quoteId: this.quote.Id }).then(data => {
            console.log(' ====> created quote id =', data)
            console.log("create quote success: " + JSON.stringify(data))
            // this.proposal['Proposal_Id'] = data
            // this.showToast("")
            this.callReviseQuotationAPI(data)
            // todo amend quotation with quote.Id
            // this.showToast("Quotation is revised", 'Success', 'success')
            // setTimeout(() => {
            //     //your code to be executed after 1 second
            //     this.navDashboard()
            // }, 2000);

        }).catch(error => {
            this.showToast("Something went wrong while revising Quotation. Please try again")
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
    callReviseQuotationAPI(res) {
        let data = {
            ACCOUNT_ID: this.proposal.Account__c,
            PROPOSAL_ID: res.prop.Id,
            QUOTATION_ID: res.quote.Id,
            CUS_NO: this.proposal.CUS_NO__c,
            PCY_TYPE: this.proposal.Policy_Type__c,
            STS: 'RV',
            // COMMENCE_DATE: 
            IM_PCT: Number(this.proposal.Indemnity_Percentage__c),
            PRM_LOADING: this.proposal.Premium_Loading__c || 0,
        }
        console.log('Callling revise quotation aura:: ', JSON.stringify(data));

        ammendQuoteAura({ jsonObject: data }).then(d => {
            let data = JSON.parse(d)
            console.log("ammendQuoteAura success::", data);
            if (data.rtn_code == '1') {
                this.showToast("Quotation revised successfully.", 'Success', 'success')
                this.navDashboard()
            } else {
                this.showToast("Something went wrong. Please try again")

            }
        }).catch(error => {
            console.error('ammendQuoteAura error::', error);
            this.showToast("Something went wrong while revising Quotation. Please try again")
        })
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

    toast(title) {
        const toastEvent = new ShowToastEvent({
            title,
            variant: "success"
        })
        this.dispatchEvent(toastEvent)
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
            if (this.questionMap['Know_About_Hkecic__c'])
                this.questionMap['Know_About_Hkecic__c'].options = this.knowAboutEcicOptions
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
                "Question": this.label.Type_of_business_entity,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false
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
                "readOnly": false
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
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
                "Question": this.label.Largest_credit_limit_required,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "options": [],
                "isCurrency": true,
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Question_old": "Bad debt amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
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
                "Question": this.label.Type_of_business_entity,
                "Name": "Company_Legal_Type__c",
                "Value": "",
                "options": this.companyLegalTypeOptions,
                "isLegalType": true,
                "readOnly": false
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
                "readOnly": false
            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Commencement_Date,
                "Name": "Policy_Commence_Date__c",
                "Value": this.policyCommencementDate,
                "options": [],
                "isText": true,
                "readOnly": true
            },
            {
                "Display_Sequence": 5,
                "Question": this.label.Policy_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
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
                "Question": this.label.Largest_credit_limit_required,
                "Name": "Sales_Amount_Range__c",
                "Question_old": "Average amount of credit limit",
                "Value": "",
                "options": [],
                "isCurrency": true,
            },
            {
                "Display_Sequence": 12,
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Question_old": "Bad debt amount",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 13,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 4,
                "Question": this.label.Commencement_Date,
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
                "Question": this.label.Policy_renewal,
                "Name": "Auto_Renewal__c",
                "Value": "",
                "options": this.automicRenewalOptions,
                isText: true,
                "readOnly": false,
                "isRequired": true
            },
            {
                "Display_Sequence": 6,
                "Question": this.label.Goods_Services,
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
                "Question": this.label.Largest_credit_limit_required,
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
                "Question": this.label.Bad_debt_in_the_last_24_months,
                "Name": "Bad_Debt_Amount__c",
                "Value": "",
                "options": [],
                "isCurrency": true,
                "readOnly": false,
                "isRequired": true,
            },
            {
                "Display_Sequence": 43,
                "Question": this.label.Amount_currently_overdue_for_more_than_30_days,
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
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 15,
                "Question": this.label.Business_registration_certificate_expiry_date,
                "Name": "BR_Expiry_Date__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 16,
                "Question": this.label.Upload_file,
                "Name": "BR_Document__c",
                "Question_old": "Upload BR",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 17,
                "Question": this.label.Date_of_incorporation,
                "Name": "Corporate_Incorporation_Date__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 18,
                "Question": this.label.Registered_address_English,
                "Name": "Company_Address_Registered__c",
                "Value": "",
                "address": this.registeredAddress,
                "isAddress": true,
                "readOnly": false
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
                "options": this.districtOptions,
                "isPickList": true,
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
                "readOnly": false
            },
            {
                "Display_Sequence": 22,
                "Question": this.label.Correspondence_address_English,
                "Name": "Company_Address_Correspondence__c",
                "Value": "",
                "address": this.correspondenceAddress,
                "isAddress": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 23,
                "Question": this.label.Territory_English,
                "Name": "Correspondence_Territory__c",
                "Value": "",
                "options": this.territoryOptions,
                "isPickList": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 24,
                "Question": this.label.District_English,
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
        "sectionLabel": this.label.	Section_D_Self_Selected_Policy_Terms,
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
    sectionDQuestionsSBP = {
        "sectionLabel": this.label.	Section_D_Self_Selected_Policy_Terms,
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
                "Question": this.label.How_did_you_know_HKECIC,
                "Name": "Know_About_Hkecic__c",
                "Value": "",
                "options": this.knowAboutEcicOptions,
                "isKnowAboutEcic": true,
                "readOnly": false
            },
            {
                "Display_Sequence": 34,
                "Question": this.label.Reference_code,
                "Name": "Promotion_Code__c",
                "Value": "",
                "options": [],
                "isText": true,
                "readOnly": false
            }

        ]
    }
}
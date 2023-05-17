import { LightningElement, track, wire } from 'lwc';
import getQuotation from '@salesforce/apex/OnboardingCreateSiteUser.getQuotation'
import createPolicy from '@salesforce/apex/QuotationManager.createPolicy'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getPublishedContentIds from '@salesforce/apex/QuotationManager.getPublishedContentIds';
import current_user from '@salesforce/user/Id';
// import checkProblemPHCompAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkProblemPHCompAura'
// import checkOtherPHCompAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkOtherPHCompAura'//6.4
// import checkHoldOSOnlinePlcyAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkHoldOSOnlinePlcyAura'//6.6
// import checkTermOthPcyPHAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkTermOthPcyPHAura'//6.8
// import checkPolicyDetailsAura from '@salesforce/apex/ECIC_API_PolicyMgmt.checkPolicyDetailsAura'
// import applyQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyQuoteAura'
// import applyPolicyRecordAura from '@salesforce/apex/ECIC_API_PolicyMgmt.applyPolicyRecordAura'
// import ammendQuoteAura from '@salesforce/apex/ECIC_API_PolicyMgmt.ammendQuoteAura'
import getSchdule2CountryList from '@salesforce/apex/GetCustomMetaData.getSchdule2CountryList';
import getClause70CountryList from '@salesforce/apex/GetCustomMetaData.getClause70CountryList';
import getOMBPClauseCountryList from '@salesforce/apex/GetCustomMetaData.getOMBPClauseCountryList';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';



export default class OnboardingQuoteDetail extends NavigationMixin(LightningElement) {
    @track quotation = {}
    @track proposal = {}
    @track account = {}
    isLoaded
    productId
    @track user_id = current_user;
    showCheckboxError = false
    showCheckboxChecked = false
    checkboxNotSelectedErrorMsg = "Please accept the condition to continue."
    productName = ""
    quoteId
    accountId
    quoteStatus
    productTitle

    isRevisionCompulsary
    revisionMessage = 'Commencement Date not be met. Please revice the commencement date to upcoming month.'
    show_welcome_modal

    /// copied from policy t&c 
    coverButtonIcon = "utility:down";
    isCoverSectionexpanded = false;

    contractsButtonIcon = "utility:down";
    isContractsSectionexpanded = false;

    premiumButtonIcon = "utility:down";
    isPremiumSectionexpanded = false;

    creditLimitIcon = "utility:down";
    creditLimitExpanded = false;

    decAndPremIcon = "utility:down";
    decAndPremExpanded = false;

    lossMinimisationIcon = "utility:down";
    lossMinimisationExpanded = false;

    exclusionsIcon = "utility:down";
    exclusionsExpanded = false;

    claimAndRecIcon = "utility:down";
    claimAndRecExpanded = false;

    genConditionIcon = "utility:down";
    genConditionExpanded = false;

    decAndPremIcon = "utility:down";
    decAndPremExpanded = false;

    miscellaneousIcon = "utility:down";
    miscellaneousExpanded = false;

    confidentialityIcon = "utility:down";
    confidentialityExpanded = false;

    defnitionsIcon = "utility:down";
    defnitionsExpanded = false;
    expandHandler(event) {
        console.log('expandHandler : ' + event.currentTarget.id);
        let id = event.currentTarget.id + "";
        id = id.split("-")[0];
        if (id === "sectionCover") {
            this.isCoverSectionexpanded = !this.isCoverSectionexpanded;
            this.coverButtonIcon = this.isCoverSectionexpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionContractsAndRelatedConditions") {
            this.isContractsSectionexpanded = !this.isContractsSectionexpanded;
            this.contractsButtonIcon = this.isContractsSectionexpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionPremium") {
            this.isPremiumSectionexpanded = !this.isPremiumSectionexpanded;
            this.premiumButtonIcon = this.isPremiumSectionexpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionCreditLimit") {
            this.creditLimitExpanded = !this.creditLimitExpanded;
            this.creditLimitIcon = this.creditLimitExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionDecAndPrem") {
            this.decAndPremExpanded = !this.decAndPremExpanded;
            this.decAndPremIcon = this.decAndPremExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionLossMinimisation") {
            this.lossMinimisationExpanded = !this.lossMinimisationExpanded;
            this.lossMinimisationIcon = this.lossMinimisationExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionExclusions") {
            this.exclusionsExpanded = !this.exclusionsExpanded;
            this.exclusionsIcon = this.exclusionsExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionClaimAndRec") {
            this.claimAndRecExpanded = !this.claimAndRecExpanded;
            this.claimAndRecIcon = this.claimAndRecExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionGenCondition") {
            this.genConditionExpanded = !this.genConditionExpanded;
            this.genConditionIcon = this.genConditionExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionMiscellaneous") {
            this.miscellaneousExpanded = !this.miscellaneousExpanded;
            this.miscellaneousIcon = this.miscellaneousExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionConfidentiality") {
            this.confidentialityExpanded = !this.confidentialityExpanded;
            this.confidentialityIcon = this.confidentialityExpanded ? "utility:up" : "utility:down";

        } else if (id === "sectionDefnitions") {
            this.defnitionsExpanded = !this.defnitionsExpanded;
            this.defnitionsIcon = this.defnitionsExpanded ? "utility:up" : "utility:down";

        }

    }

    expandCover(event) {
        console.log('expandCover event : ' + event + ' isCoverSectionexpanded : ' + this.isCoverSectionexpanded);
        if (!this.isCoverSectionexpanded) {
            this.isCoverSectionexpanded = true;
            this.coverButtonIcon = 'utility:down';
        } else {
            this.isCoverSectionexpanded = false;
            this.coverButtonIcon = 'utility:up';
        }
    }
    expandContracts(event) {
        console.log("expandContracts event : " + event + ' isContractsSectionexpanded : ' + this.isContractsSectionexpanded);
        if (!this.isContractsSectionexpanded) {
            this.isContractsSectionexpanded = true;
            this.contractsButtonIcon = 'utility:down';
        } else {
            this.isContractsSectionexpanded = false;
            this.contractsButtonIcon = 'utility:up';
        }
    }
    expandPremium(event) {
        console.log("expandPremium event : " + event + ' isPremiumSectionexpanded : ' + this.isPremiumSectionexpanded);
        if (!this.isPremiumSectionexpanded) {
            this.isPremiumSectionexpanded = true;
            this.premiumButtonIcon = 'utility:down';
        } else {
            this.isPremiumSectionexpanded = false;
            this.premiumButtonIcon = 'utility:up';
        }

    }
    ///
    get isOMBP() {
        return this.productName == "OMBP" ? true : false
    }
    get isSBP() {
        return this.productName == "SBP" ? true : false
    }
    get isSUP() {
        return this.productName == "SUP" ? true : false
    }
    get isSBPOrSUP() {
        return ["SBP", "SUP"].includes(this.productName) ? true : false
    }
    get showAcceptQuote() {
        return this.quoteStatus == 'pfa' && !this.isRevisionCompulsary ? true : false
    }
    get showReviceQuote() {
        return this.quoteStatus == 'pfa' && this.isSBPOrSUP ? true : false
    }

    connectedCallback() {
        this.quoteId = this.getUrlParamValue(window.location.href, 'id');
        this.quoteStatus = this.getUrlParamValue(window.location.href, 'st');
        console.log("connectedCallback:: quoteId=", this.quoteId);
        if (!this.quoteId) {
            this.showToast("Quotation not found")
            // this.showPrevious()
        }
        this.getPublishedContent()
    }


    // baseUrl = 'https://kennychun--dev2--c.visualforce.com/apex/'
    baseUrl = 'https://kennychun--ecicuat2--c.visualforce.com/apex/'
    schdule1Url = ''
    schdule2Url = ''
    schdule3Url = ''
    schdule4Url = ''
    setupDownloadLinks() {
        this.schdule1Url = this.baseUrl + 'QuotationScheduleOne' + `?qId=${this.quotation.Id}` + '&renderAs=pdf'
        if (["SBP", "SUP"].includes(this.productName)) {
            this.schdule2Url = this.baseUrl + 'QuotationScheduleTwo' + `?qId=${this.quotation.Id}` + '&renderAs=pdf'
            this.schdule3Url = this.baseUrl + 'QuotationScheduleThree' + `?qId=${this.quotation.Id}` + '&renderAs=pdf'
        }
        if (this.productName == 'SUP') {
            this.schdule4Url = this.baseUrl + 'QuotationScheduleFour' + `?qId=${this.quotation.Id}` + '&renderAs=pdf'
        }
        console.log('this.schdule1Url::', this.schdule1Url);
    }
    downloadPDF() {
        console.log("downlaod pdf::");
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.schdule1Url
            }
        }, false);
        this.schdule2Url && this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.schdule2Url
            }
        }, false);
        this.schdule3Url && this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.schdule3Url
            }
        }, false);
        this.schdule4Url && this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.schdule4Url
            }
        }, false);
    }
    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }
    reviceQuotation() {
        console.log("reviceQuotation::",);
        // const redUrl = '/ECReach/s/onboarding' + '?createNewProposal=true'
        const redUrl = '/ECReach/s/onboarding' + '?id=' + this.quotation.Id + '&rq=true'
        console.log("redirecting to :", redUrl);
        window.location.href = redUrl
    }

    get indemnityRatioOptions() {
        switch (this.productName) {
            case "SBP":
                return [
                    { label: '60%', value: "30" },
                    { label: '70%', value: "20" },
                    { label: '80%', value: "10" },
                    { label: '90%', value: "0" }]
            case "OMBP":
                return [
                    { label: '90%', value: "0" }]
            default:
                return [
                    { label: '50%', value: "30" },
                    { label: '60%', value: "20" },
                    { label: '70%', value: "10" },
                    { label: '80%', value: "0" }]
        }
    }
    get commencementDate() {
        return this.proposal.Policy_Commence_Date__c ? this.proposal.Policy_Commence_Date__c : "N/A"
    }

    formatDate(d) {
        var mm = d.getMonth() + 1; // getMonth() is zero-based
        var dd = d.getDate();

        return [d.getFullYear(),
        (mm > 9 ? '' : '0') + mm,
        (dd > 9 ? '' : '0') + dd
        ].join('-');
    }
    get policyPeriod() {
        let d = new Date(this.commencementDate)
        let end = new Date(d.getFullYear() + 1, d.getMonth(), d.getDate() - 1)
        return this.formatDate(d) + ' - ' + this.formatDate(end)
    }
    get percentageOfIndmenity() {
        if (this.proposal.Indemnity_Ratio__c) {
            return this.proposal.Indemnity_Ratio__c + '%'
        }
        return ""

    }
    get NQL() {
        return this.proposal.NQL_Amount__c ? Number(this.proposal.NQL_Amount__c).toLocaleString('en-US', { maximumFractionDigits: 2 }) : 0
    }
    get maximumLiabilty() {
        if (this.isSUP) {
            return 'HKD ' + Number(this.proposal.Maximum_Liability__c).toLocaleString('en-US', { maximumFractionDigits: 2 })
        } else if (this.isSBP) {
            return 'HKD 500,000'
        }
        return "HKD 3,000,000"

        // return this.proposal.Maximum_Liability__c && this.isSUP ? 'HKD ' + this.proposal.Maximum_Liability__c : "HKD 3,000,000"
    }
    get rebate_rate() {
        return 5
    }
    get issueDate() {
        return this.proposal.CreatedDate ? String(this.proposal.CreatedDate).split('T')[0] : this.proposal.Policy_Commence_Date__c
    }
    get effectiveDate() {
        return this.proposal.Policy_Commence_Date__c || ''
    }
    @wire(getQuotation, { Id: '$quoteId' })
    handleQuotationList({ error, data }) {
        this.isLoaded = true
        if (data) {
            // commenting as there is no content
            // this.show_welcome_modal = data.Completed_Tutorial__c ? false : true;

            this.accountId = data.Account__r.Id
            this.account = data.Account__r
            this.quotation = data
            this.proposal = data.Proposal__r
            this.productName = data.Product__r.Name
            this.productId = data.Product__c
            this.productTitle = data.Product__r.Full_Name__c
            console.log('####getQuotation data=' + JSON.stringify(data))
            console.log('####getQuotation proposal=' + JSON.stringify(this.proposal))
            this.getPublishedContent()
            // this.prepareQuoteAPI()
            this.setupDownloadLinks()
            this.checkIfNeedToRevice()
        }
        if (error) {
            console.error('####getQuotation error=' + JSON.stringify(error))
            this.showToast("Quotation not found")
            // this.showPrevious()

        }
    }

    checkIfNeedToRevice() {
        if (["SBP", "SUP"].includes(this.productName)) {
            const issueDate = new Date(this.quotation.Issue_Date__c)
            const commDate = new Date(this.proposal.Policy_Commence_Date__c)
            if (issueDate.getMonth() == commDate.getMonth() && issueDate.getDay() >= 15 && this.quoteStatus == 'pfa') {
                this.isRevisionCompulsary = true
            }
        }
    }
    closewelcomemodal() {
        this.show_welcome_modal = false;
    }
    get exclusionLabel() {

        if (this.proposal.Country_Risks__c && this.proposal.Repudiation_Risks__c) {
            return 'Country Risks and Repudiation Risks'
        } else if (this.proposal.Country_Risks__c) {
            return 'Country Risks'
        } else if (this.proposal.Repudiation_Risks__c) {
            return 'Repudiation Risks'

        }
    }

    @track leftCountryList = []
    @track rightCountryList = []
    @wire(getSchdule2CountryList, {})
    handlegetSchdule2CountryList({ error, data }) {
        if (data) {
            const temp = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c,
                    group: el.CTRY_GRADE__c,
                    condition: el.Special_Condition__c
                }
            })

            let half = Math.ceil(temp.length / 2)
            this.leftCountryList = temp.slice(0, half);
            this.rightCountryList = temp.slice(half);
            console.log('schdule2CountryList::', temp.length, this.leftCountryList, this.rightCountryList);
        } else if (error) {
            console.error('####handlegetSchdule2CountryList error=' + JSON.stringify(error))
        }
    }
    @track clause70CountryList = []
    @wire(getClause70CountryList, {})
    handlegetClause70CountryList({ error, data }) {
        if (data) {
            this.clause70CountryList = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c
                }
            })
            console.log('clause70CountryList::', JSON.stringify(this.clause70CountryList));
        } else if (error) {
            console.error('####handlegetClause70CountryList error=' + JSON.stringify(error))
        }
    }
    @track OMBPclauseCountryList = []
    @wire(getOMBPClauseCountryList, {})
    handlegetOMBPClauseCountryList({ error, data }) {
        if (data) {
            this.OMBPclauseCountryList = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c
                }
            })
            console.log('OMBPclauseCountryList::', JSON.stringify(this.OMBPclauseCountryList));
        } else if (error) {
            console.error('####handlegetOMBPClauseCountryList error=' + JSON.stringify(error))
        }
    }


    get combinedName() {
        return this.proposal.First_Name__c + ' ' + this.proposal.Last_Name__c
    }
    get policyProductName() {
        return this.productName
    }

    getPublishedContent() {
        console.log('getPublishedContent called.' + this.policyProductName + ' this.productId::' + this.productId);
        getPublishedContentIds({
            productId: this.productId
        }).then(data => {
            console.log('getPublishedContent success :' + JSON.stringify(data));
            try {

                this.counter = this.counter + 1;
                console.log('Counter : ' + this.counter);
                for (let t in data) {
                    console.log('counter--' + this.counter + ' t--->' + t);
                    //console.log('title--'+data[t].title+' t--->'+data[t].contentNodes.body.value);

                    if (data[t].title.toUpperCase() === this.policyProductName + ' POLICY TERM HEADER'.toUpperCase()) {

                        this.policyTermHeaderContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.policyTermHeaderContent);
                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' THE COVER'.toUpperCase()) {

                        this.cover = data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.cover);
                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' CONTRACTS COVERED AND RELATED CONDITIONS'.toUpperCase()) {
                        this.contractsCoveredAndRelatedConditions = data[t].contentNodes.body.value.replaceAll('&gt;', ">").replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.contractsCoveredAndRelatedConditions);
                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' CREDIT LIMIT'.toUpperCase()) {
                        this.creditLimit = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.creditLimit);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' DECLARATIONS AND PREMIUM'.toUpperCase()) {
                        this.decAndPrem = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.decAndPrem);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' LOSS MINIMISATION'.toUpperCase()) {
                        this.lossMinimisationContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.lossMinimisationContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' EXCLUSIONS'.toUpperCase()) {
                        this.exclusionsContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.exclusionsContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' CLAIMS AND RECOVERIES'.toUpperCase()) {
                        this.claimAndRecContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.claimAndRecContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' GENERAL CONDITIONS'.toUpperCase()) {
                        this.genConditionContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.genConditionContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' MISCELLANEOUS'.toUpperCase()) {
                        this.miscellaneousContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.miscellaneousContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' CONFIDENTIALITY'.toUpperCase()) {
                        this.confidentialityContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.confidentialityContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' DEFINITIONS'.toUpperCase()) {
                        this.defnitionsContent = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.defnitionsContent);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' PREMIUM'.toUpperCase()) {
                        this.premium = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', "'");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.premium);

                    } else if (data[t].title.toUpperCase() === this.policyProductName + ' POLICY SCHEULE 1 REMARKS'.toUpperCase()) {
                        this.policySchedule1Remarks = data[t].contentNodes.body.value.replaceAll('&gt;', '>').replaceAll('&lt;', "<").replaceAll('&amp;nbsp;', " ").replaceAll('&quot;', " \" ");
                        console.log('Caps --' + data[t].title.toUpperCase() + '--' + this.policySchedule1Remarks);

                    }
                    this.isCoverSectionexpanded = !this.isCoverSectionexpanded;
                    this.coverButtonIcon = this.isCoverSectionexpanded ? "utility:up" : "utility:down";
                }
            } catch (error) {
                console.log('Error 1 : ' + error.toString() + ' ' + JSON.stringify(error));
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Exception Occurred while Loading Terms & Conditions',
                //         message: error.toString() + ' ' + JSON.stringify(error.toString()),
                //         mode: 'sticky',
                //         variant: 'warning'
                //     })
                // );
            }

        }).catch(error => {
            console.log('Error 2 : ' + error.toString() + ' ' + JSON.stringify(error));
            // this.dispatchEvent(
            //     new ShowToastEvent({
            //         title: 'Exception Occurred while Loading Terms & Conditions.',
            //         message: error.toString(),
            //         mode: 'sticky',
            //         variant: 'error'
            //     })
            // );
        });
    }



    acceptQuote() {
        if (!this.showCheckboxChecked) {
            this.showCheckboxError = true
            return
        }
        console.log("accept quote");
        // this.verifyBRNumberAPI() after ecic
        this.callCreatePolicy()



    }
    POLICY_ID
    callCreatePolicy() {
        // this.isLoaded = false
        createPolicy({ quoteId: this.quoteId }).then(data => {
            // this.isLoaded = true
            console.log("createPolicy salesforce successful::", data);
            // this.showToast("Quotation Accepted Successfully", "Success", 'success')
            // this.showPrevious()
            this.POLICY_ID = data.policy.Id;
            // if (data.quotations.length) {
            //     this.voidPreviousQuotation(data.quotations)
            // }
            // this.preparePolicyAPI()//after ecic
            this.showToast("Policy created successfully", 'Success', 'success')
            setTimeout(() => {
                this.showPrevious()
            }, 3000);
        }).catch(error => {
            this.isLoaded = true
            console.error("createPolicy salesforce error", error);
            this.showToast('Something went wrong. Please try again later.')
        });
    }
    voidPreviousQuotation(res) {
        // let data = res.map(el => {
        //     return {
        //         ACCOUNT_ID: this.accountId,
        //         PROPOSAL_ID: el.Proposal__r.Id,
        //         QUOTATION_ID: el.Id,
        //         CUS_NO: el.Proposal__r.CUS_NO__c,
        //         PCY_TYPE: el.Proposal__r.Policy_Type__c,
        //         STS: 'RJ'
        //     }
        // })
        try {


            let el = res[res.length - 1]
            let data = {
                ACCOUNT_ID: this.accountId,
                PROPOSAL_ID: el.Proposal__r.Id,
                QUOTATION_ID: el.Id,
                CUS_NO: el.Proposal__r.CUS_NO__c,
                PCY_TYPE: el.Proposal__r.Policy_Type__c,
                STS: 'RJ'
            }
            console.log('Callling ammend quotation aura:: ', JSON.stringify(data));

            ammendQuoteAura({ jsonObject: data }).then(d => {
                console.log("ammendQuoteAura success::", d);
                let data = JSON.parse(d)
                console.log("ammendQuoteAura success::", data);
                if (data.rtn_code == '1') {
                    // this.showToast("Quotation revised successfully.", 'Success', 'success')
                    // this.navDashboard()
                    console.log("voided previous quotations");
                } else {
                    // this.showToast("Something went wrong. Please try again")

                }
            }).catch(error => {
                console.error('ammendQuoteAura error::', error);
                // this.showToast("Something went wrong while revising Quotation. Please try again")
            })
        } catch (error) {
            console.error('ammendQuoteAura error::', error);
        }
    }

    preparePolicyAPI() {
        let data = {
            ACCOUNT_ID: this.accountId,
            QUOTATION_ID: this.quotation.Id,
            PROPOSAL_ID: this.proposal.Master_Proposal__c ? this.proposal.Master_Proposal__c : this.proposal.Id,
            POLICY_ID: this.POLICY_ID,///
            REQ_TYPE: 'N',
            CUS_NO: this.proposal.CUS_NO__c,
            PCY_TYPE: this.proposal.Policy_Type__c,
            COMMERCE_DATE: this.proposal.Policy_Commence_Date__c || this.today,
            // EFF_DATE: this.proposal.Policy_Commence_Date__c || this.today,//this.getEffDate(this.proposal.Policy_Commence_Date__c),
            EFF_DATE: this.proposal.Policy_Commence_Date__c || this.today,
            EXP_DATE: this.getExpiaryDate(this.proposal.Policy_Commence_Date__c || this.today),
            // STS: 'N'
        }
        console.log("Call policy API::", JSON.stringify(data));
        // return

        applyPolicyRecordAura({ jsonObject: data }).then(res => {
            this.isLoaded = true
            let data = JSON.parse(res)
            console.log("applyPolicyRecordAura success::", data);
            let temp = {}
            if (data.rtn_code && data.rtn_code == '1') {
                this.showToast("Policy created successfully", 'Success', 'success')
                setTimeout(() => {
                    this.showPrevious()
                }, 3000);
            } else {
                // this.showToast("Something went wrong. Ple")
                this.showToast('Something went wrong while accepting quotation. Please try again later.')
            }
            // {"rtn_code":"1","rtn_msgs":null,"meta_data":null}

        }).catch(error => {
            this.isLoaded = true
            // this.showToast("Something went wrong creating proposal. Please try again")
            this.showToast('Something went wrong while accepting quotation. Please try again later.')
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
    getEffDate(d) {
        var current = new Date(d);
        current.setDate(current.getDate() - 1);
        const dt = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return dt
    }
    getExpiaryDate(d) {
        var current = new Date(d);
        current.setFullYear(current.getFullYear() + 1);
        const dt = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return dt
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

    verificationCompletionCount = 0
    verifyBRNumberAPI() {
        this.verificationCompletionCount = 0
        const br = this.proposal.BR_Number__c
        let pc = this.getPolicyCode(this.productName)
        console.log("calling Verifications APIs", pc, br);
        // checkPolicyDetailsAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.3  To check whether company is an existing PH for respective policy type
        //     console.log("checkPolicyDetailsAura::", data);
        // }).catch(error => {
        //     console.log("checkPolicyDetailsAura::error", error);
        // })
        this.isLoaded = false

        checkOtherPHCompAura({ BR_NO: br }).then(data => {//6.4 To check whether company is an existing PH in other policy type and policyholder termination has not been
            console.log("checkOtherPHCompAura 6.4::", data);
            const res = JSON.parse(data).meta_data
            if (res.result == 'N') {
                this.verificationCompletionCount += 1
                this.followUpcreateVerification()
            } else {
                this.showToast('This BR number is already used by another active policy')
            }
        }).catch(error => {
            this.isLoaded = true
            console.log("checkOtherPHCompAura::error", error);
            this.showToast('Something went wrong. Please try again later.')
        })
        checkTermOthPcyPHAura({ BR_NO: br }).then(data => {//6.8 To check if the prospect has any offline proposal / quotation
            console.log("checkTermOthPcyPHAura 6.8::", data);
            const res2 = JSON.parse(data).meta_data
            if (res2.has_oth_pcy == 'N') {
                this.verificationCompletionCount += 1
                this.followUpcreateVerification()
            } else {
                this.showToast('This BR number is already used by another active policy')
            }
        }).catch(error => {
            this.isLoaded = true
            console.log("checkTermOthPcyPHAura::error", error);
            this.showToast('Something went wrong. Please try again later.')
        })
        checkHoldOSOnlinePlcyAura({ PCY_TYPE: pc, BR_NO: br }).then(data => {//6.6 
            console.log("checkHoldOSOnlinePlcyAura 6.6::", data);
            const res2 = JSON.parse(data).meta_data
            if (res2.result == 'N') {
                this.verificationCompletionCount += 1
                this.followUpcreateVerification()
            } else {
                this.showToast('This BR number is already used by another active policy')
            }
            // this.verificationCompletionCount += 1
            // this.followUpcreateVerification()
        }).catch(error => {
            this.isLoaded = true
            console.log("checkHoldOSOnlinePlcyAura 6.6::error", error);
            this.showToast('This BR number is already used by another active policy')
        })
    }

    followUpcreateVerification() {
        this.isLoaded = true
        console.log("verificationCompletionCount:", this.verificationCompletionCount);
        if (this.verificationCompletionCount != 3) {//3
            return
        }
        console.log(' calling CreatePolicy::');
        // this.prepareQuoteAPI()
        this.callCreatePolicy()

    }
    get today() {
        const current = new Date();
        const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }

    // V: Void R: Rejected A: Accept O: Outstanding
    showPrevious() {
        console.log("showdashboard");
        const redUrl = './dashboard'
        console.log("redirecting to :", redUrl);
        window.location.href = redUrl
    }
    handleCheckboxChange(event) {
        console.log(event.currentTarget.name, event.currentTarget.checked)
        // if (event.currentTarget.checked) {
        this.showCheckboxError = event.currentTarget.checked ? false : true
        this.showCheckboxChecked = event.currentTarget.checked ? true : false
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
}
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp'// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { api, LightningElement, track, wire } from 'lwc';
import getProducts from '@salesforce/apex/OnBoarding.getProducts';
import getDynamicPrice from '@salesforce/apex/OnBoarding.getDynamicPrice';
import getDiscounts from '@salesforce/apex/OnBoarding.getDiscounts';
import DYNAMIC_PRICE from '@salesforce/schema/Dynamic_Price__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import Indemnity_Ratio__c from '@salesforce/schema/Dynamic_Price__c.Indemnity_Ratio__c';
import Non_Qualify_Loss__c from '@salesforce/schema/Dynamic_Price__c.Non_Qualify_Loss__c';
import Exclusion__c from '@salesforce/schema/Dynamic_Price__c.Exclusion__c';
import getProposalList from '@salesforce/apex/OnboardingCreateSiteUser.getProposalList'

import Recommended_Product from '@salesforce/label/c.Recommended_Product';
import Choose_a_Product from '@salesforce/label/c.Choose_a_Product';
import Applying_for from '@salesforce/label/c.Applying_for';
import Final_Premium_Rate_on from '@salesforce/label/c.Final_Premium_Rate_on';
import Final_Premium_Rates_on_DE from '@salesforce/label/c.Final_Premium_Rates_on_DE';
import Country from '@salesforce/label/c.Country';
import Grade_A from '@salesforce/label/c.Grade_A';
import Grade_B_C from '@salesforce/label/c.Grade_B_C';
import DP from '@salesforce/label/c.DP';
import DA_OA_0_30 from '@salesforce/label/c.DA_OA_0_30';
import DA_OA_31_60 from '@salesforce/label/c.DA_OA_31_60';
import DA_OA_61_90 from '@salesforce/label/c.DA_OA_61_90';
import DA_OA_91_120 from '@salesforce/label/c.DA_OA_91_120';
import Indemnity_Ratio from '@salesforce/label/c.Indemnity_Ratio';
import First_Loss_non_qualify_loss_for_each_claim from '@salesforce/label/c.First_Loss_non_qualify_loss_for_each_claim';
import Exclusion_PI from '@salesforce/label/c.Exclusion_PI';
import Back from '@salesforce/label/c.Back';
import Next from '@salesforce/label/c.Next';
import Repudiation_Risks from '@salesforce/label/c.Repudiation_Risks';
import Country_Risks from '@salesforce/label/c.Country_Risks';

export default class OnboardingDP extends LightningElement {
    // @api selectedproduct = "a070l00000Aj0x6AAB"

    @track label = {
        Recommended_Product, Choose_a_Product, Applying_for, Final_Premium_Rate_on, Final_Premium_Rates_on_DE,
        Country, Grade_A, Grade_B_C, DP, DA_OA_0_30, DA_OA_31_60, DA_OA_61_90, DA_OA_91_120, Indemnity_Ratio,
        First_Loss_non_qualify_loss_for_each_claim, Exclusion_PI, Back, Next, Repudiation_Risks, Country_Risks
    }
    @api language
    @api usrId
    @api selectedproduct = ""
    @api productSearchError
    @api retUrl = 'showOnboardingPI'
    @api products
    @track showProducts = []
    @api proposal
    @api isMultipleProposal
    @api isReviseQuote
    @track isProductSBP = false
    @track isProductOMBP = false
    @track isLoaded
    @track recommendedProduct = {}
    @track showTabTwo = true

    @track cl_approved_amount = 100000
    @track premium_rate
    @track discount = 0
    @track premium = 0// = 'this.clL_approved_amount * this.premium_rate * this.discount'		


    @track productMap = {}
    //sandbox
    // products = [{ "Id": "a070l00000Aj0x6AAB", "Name": "OMBP", "Premium_Rate__c": 0.8, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mI4d&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Online Micro Business Policy", "Display_Sequence__c": 1 }, { "Id": "a070l00000Aj0x7AAB", "Name": "SBP", "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mL4V&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Small Business Policy", "Display_Sequence__c": 2 }, { "Id": "a070l00000Aj0x5AAB", "Name": "SUP", "Premium_Rate__c": 103, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet.ImageServer?id=0150l000000mL4W&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "Self Underwritten Policy", "Display_Sequence__c": 3 }]

    // proposal = { "Exclusions__c": "[{\"dataId\":\"Country_Risks\",\"label\":\"Country Risks\",\"value\":\"5\",\"isChecked\":true},{\"dataId\":\"Repudiation_Risks\",\"label\":\"Repudiation Risks\",\"value\":\"5\",\"isChecked\":false}]" }
    connectedCallback() {
        console.log("connectedCallback: isMultipleProposal" + JSON.stringify(this.isMultipleProposal))
        console.log("connected callback: isReviseQuote", this.isReviseQuote)
        console.log("connected callback: selectedproduct", this.selectedproduct)
        console.log("connectedCallback: Products" + JSON.stringify(this.products))
        console.log("connectedCallback: proposal" + JSON.stringify(this.proposal))
        console.log("connectedCallback: language" + this.language);
        console.log("connectedCallback: productSearchError" + JSON.stringify(this.productSearchError))

        this.proposal = this.proposal === undefined ? {} : { ...this.proposal }
        if (this.isMultipleProposal) {
            this.selectedproduct = null
            this.selectedProductName = null
            this.productSearchError = true
        }
        this.proposal['Product__c'] = this.selectedproduct
        this.handleProposalList()
    }
    get showProductDetails() {
        return this.selectedproductId ? true : false
    }
    get shouldShowRecommendedProduct() {
        return !this.isReviseQuote
    }
    getbaseLoading(ib) {
        if (0 <= ib && ib <= 5000000)
            return 40
        else if (5000001 <= ib && ib <= 20000000)
            return 35
        else if (20000001 <= ib && ib <= 30000000)
            return 25
        else if (30000001 <= ib && ib <= 50000000)
            return 20
        else return 0
    }
    loadFromProposal() {
        console.log("##3");
        if (this.proposal && 'Insurable_Turnover__c' in this.proposal) {
            this.baseLoading = this.getbaseLoading(Number(this.proposal.Insurable_Turnover__c))
            console.log("Insurable buyer::", Number(this.proposal.Insurable_Turnover__c), "Loading::" + this.baseLoading);
        }
        // if ('Indemnity_Percentage__c' in this.proposal) {
        this.indemnityRatio = this.proposal && this.proposal['Indemnity_Percentage__c'] || '0'
        // }
        // if ('NQL__c' in this.proposal) {
        this.nQL = this.proposal && this.proposal['NQL__c'] || '0'
        // }
        if (this.proposal && 'Exclusions__c' in this.proposal) {
            this.exclusionOptions = JSON.parse(this.proposal['Exclusions__c'])// this should be a list 
            this.exclusionOptions.forEach(el => {
                if (el.isChecked)
                    this.exclusion += Number(el.value)

            });
            // this.exclusion = this.proposal['Exclusions__c']
        }
        this.setProductDetails()
    }

    @track set = new Set();

    // @wire(getProposalList, { usrId: '$usrId' })
    handleProposalList() {
        getProposalList({ usrId: this.usrId }).then(data => {

            console.log('####getproposal data=' + JSON.stringify(data))


            if (data) {
                data.filter(el => (el.Product__r)).map(el => {
                    this.set.add(el.Product__r.Id)
                })
                console.log("this.set:::", this.set.size, this.set);
                //console.log('####getproposal list data=' + JSON.stringify(this.proposalData))


            }
            if (this.products)
                this.prepareProduct()

            this.loadFromProposal()
        }).catch(error => {
            console.error('####getproposal list error=' + JSON.stringify(error))
            if (this.products)
                this.prepareProduct()

            this.loadFromProposal()
        })
    }
    handleQChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        console.log(targetName + ":::", targetValue)
        var company_name = 'Company'
        //is_existing_ph
        if (targetValue && targetName) {
            if (targetName === 'Indemnity_Percentage__c') {
                this.indemnityRatio = event.target.value;
            } else if (targetName === 'NQL__c') {
                this.nQL = event.target.value;
            }
            // else if (targetName === 'Exclusions__c') {


            //     this.exclusion = event.target.value;
            // }
            this.proposal[targetName] = targetValue
        }
        this.setProductDetails()
        console.log('proposal=' + JSON.stringify(this.proposal))
    }
    handleCheckboxChange(event) {
        // debugger
        const targetValue = event.target.checked
        const targetName = event.target.name
        if (targetName === 'Exclusions__c') {
            const dataId = event.currentTarget.dataset.id
            this.exclusionOptions.forEach(el => {
                if (dataId == el.dataId) {
                    el.isChecked = targetValue ? true : false
                    this.exclusion = targetValue ? this.exclusion + Number(el.value) : this.exclusion - Number(el.value)
                }
            });
            this.proposal[targetName] = JSON.stringify(this.exclusionOptions)
        }
        // console.log("corres", JSON.stringify(this.correspondenceAddress))
        this.setProductDetails()
        console.log('proposal=' + JSON.stringify(this.proposal))
    }





    calculatePremium() {
        console.log("calculatePremium: " + this.cl_approved_amount + " " + this.premium_rate + " " + this.discount)
        if (this.cl_approved_amount && this.premium_rate && this.discount)
            this.premium = this.cl_approved_amount * this.premium_rate * this.discount
    }
    options = [
        { label: '10000', value: '10,000' },
        { label: '30000', value: '30,000' },
        { label: '50000', value: '50,000' }
    ]
    get finalLoading() {
        return this.baseLoading - this.nQL - this.indemnityRatio - this.exclusion
    }
    get sbpPriceRate() {
        const finalLoading = this.baseLoading - this.nQL - this.indemnityRatio - this.exclusion
        console.log(this.baseLoading + "::" + this.indemnityRatio + "::" + this.nQL + "::" + this.exclusion);
        const temp = this.SBPPriceBook[finalLoading + '']
        // console.log("finalLoading::", finalLoading, JSON.stringify(temp));
        return {
            DP_A: temp ? this.toFixedIfNecessary(temp["GRADE_A"]["DP__c"]) : 0,
            DA_OA_0_30_A: temp ? this.toFixedIfNecessary(temp["GRADE_A"]["DA_OA_0_30__c"]) : 0,
            DA_OA_31_60_A: temp ? this.toFixedIfNecessary(temp["GRADE_A"]["DA_OA_31_60__c"]) : 0,
            DA_OA_61_90_A: temp ? this.toFixedIfNecessary(temp["GRADE_A"]["DA_OA_61_90__c"]) : 0,
            DA_OA_91_180_A: temp ? this.toFixedIfNecessary(temp["GRADE_A"]["DA_OA_91_180__c"]) : 0,
            DP_NonA: temp ? this.toFixedIfNecessary(temp["GRADE_BC"]["DP__c"]) : 0,
            DA_OA_0_30_NonA: temp ? this.toFixedIfNecessary(temp["GRADE_BC"]["DA_OA_0_30__c"]) : 0,
            DA_OA_31_60_NonA: temp ? this.toFixedIfNecessary(temp["GRADE_BC"]["DA_OA_31_60__c"]) : 0,
            DA_OA_61_90_NonA: temp ? this.toFixedIfNecessary(temp["GRADE_BC"]["DA_OA_61_90__c"]) : 0,
            DA_OA_91_180_NonA: temp ? this.toFixedIfNecessary(temp["GRADE_BC"]["DA_OA_91_180__c"]) : 0
        }
    }
    @track baseSBPPriceRate = {
        Pre_Shipment: 0,
        DP: 0,
        OA1_60: 0,
        OA61_120: 0,
    }
    get imageFieldAccToLang() {
        if (this.language == 'zh_CN') {
            return 'Image_Url_CN__c'
        } else if (this.language == 'zh_TW') {
            return 'Image_Url_HK__c'
        } else if (this.language == 'zh_HK') {
            return 'Image_Url_HK__c'
        } else {
            return 'Image_Url__c'
        }
    }
    get productNameFieldAccToLang() {
        if (this.language == 'zh_CN') {
            return 'Name_CN__c'
        } else if (this.language == 'zh_TW') {
            return 'Name_HK__c'
        } else if (this.language == 'zh_HK') {
            return 'Name_HK__c'
        } else {
            return 'Name'
        }
    }
    get showSelectedProductName() {
        if (this.language == 'zh_CN') {
            return this.productMap[this.selectedproduct]['Name_CN__c']
        } else if (this.language == 'zh_TW') {
            return this.productMap[this.selectedproduct]['Name_HK__c']
        } else if (this.language == 'zh_HK') {
            return this.productMap[this.selectedproduct]['Name_HK__c']
        } else {
            return this.productMap[this.selectedproduct]['Name']
        }
    }
    get recommendedProductUrl() {
        return this.recommendedProduct[this.imageFieldAccToLang]
    }


    prepareProduct() {
        const tempProducts = []
        console.log("##1");
        this.products.forEach((rec, index) => {

            if (rec.Id === this.selectedproduct) {
                this.recommendedProduct = rec
                this.recommendedProductName = rec[this.productNameFieldAccToLang]
                this.selectedProductName = rec.Name
            }

            const plan = { ...rec }
            plan.Image_Url__c = rec[this.imageFieldAccToLang]
            plan.checked = false
            this.productMap[plan.Id] = plan
            plan.cardClassName = this.selectedproduct == plan.Id ? "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card1_selected" : "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card1"
            if (this.set.has(rec.Id)) {
                console.log("Already applied for::", rec.Name);
            } else {
                console.log("##2");
                tempProducts.push(plan)
            }
        })
        this.isLoaded = true
        this.showProducts = tempProducts
        if (this.selectedproduct) {
            this.selectedproductId = this.selectedproduct
            const sel_prod = this.productMap[this.selectedproduct]
            this.productMap[this.selectedproduct].checked = true
            this.premium_rate = sel_prod.Premium_Rate__c

            this.shouldShowExtrafieldsClass = sel_prod.Name === "OMBP" ? "disabled" : ""
            this.selectedProductName = sel_prod.Name
            if (sel_prod.Name == "OMBP") {
                this.isProductOMBP = true
                this.showNQLClass = "display_none"
                this.showExclutionsClass = "display_none"
            }
            this.isProductSBP = this.selectedProductName == "SBP" ? true : false
        }
    }


    handleSubmitClick() {
        console.log(' ====> handleOnboardingDP')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingCreateAccount', source: 'showOnboardingDP' }
        });
        this.dispatchEvent(event1)
    }

    handleFirstLossChange(event) {
        console.log(event.detail.seletedValue)
    }
    // @track primiumOnLabel = "Credit Limit"

    @track dynamicPrice
    @track SBPPriceBook = {}
    baseLoading = 0
    @track basePremiumRate = 0
    @track premiumFormula = "(Formula: CL Approved * Discount * Premium Rate)"
    @track selectedproductId
    @track premiumValue = 0

    @track indemnityRatioPicklist = {}
    @track indemnityRatio = 0
    @track nQLPicklist = {}
    @track nQL = 0
    @track exclusion = 0
    @track countryClass = "exclusion"
    @track repudiationClass = "exclusion"
    @track shouldShowExtrafieldsClass = ""
    @track premium_rate_on
    @track finalPremiumRate = 0
    @track selectedProductName = ""
    @track exclusionPicklist = {}
    recommendedProductName = ""

    @track showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
    @track showExclutionsClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"

    get indemnityRatioOptions() {
        if (this.productMap[this.selectedproduct]) {
            const params = this.productMap[this.selectedproduct].Dynamic_Pricing_Parameters__r
            const options = params.filter(el => el.Option_Type__c == "Indemnity_Ratio")
            console.log("indemnityOptions:::", options);

            return options && options.map(el => {
                return { label: el.Option_Label__c, value: String(el.Premium_Reduction__c), labelValue: el.Option_Label_Value__c }
            })
        }
        //     switch (this.selectedProductName) {
        //         case "SBP":
        //             return [
        //                 { label: '60%', value: "30" },
        //                 { label: '70%', value: "20" },
        //                 { label: '80%', value: "10" },
        //                 { label: '90%', value: "0" }]
        //         case "OMBP":
        //             return [
        //                 { label: '90%', value: "0" }]
        //         default:
        //             return [
        //                 { label: '50%', value: "30" },
        //                 { label: '60%', value: "20" },
        //                 { label: '70%', value: "10" },
        //                 { label: '80%', value: "0" }]
        //     }
    }
    get NQLOptions() {
        // return this.selectedProductName == "SBP" ?
        //     [
        //         { label: 'HKD 0', value: "0" },
        //         { label: 'HKD 50,000', value: "5" },
        //         { label: 'HKD 100,000', value: "10" }
        //     ] :
        // return [
        //     { label: 'HKD 0', value: "0" },
        //     { label: 'HKD 50,000', value: "5" },
        //     { label: 'HKD 100,000', value: "10" }
        // ]
        if (this.productMap[this.selectedproduct]) {
            const params = this.productMap[this.selectedproduct].Dynamic_Pricing_Parameters__r
            const options = params.filter(el => el.Option_Type__c == "NQL")
            console.log("nqlOptions:::", options);

            return options && options.map(el => {
                return { label: el.Option_Label__c, value: String(el.Premium_Reduction__c), labelValue: el.Option_Label_Value__c }
            })
        }

    }
    // get exclusionOptions() {
    //     if (this.productMap[this.selectedproduct]) {
    //         const params = this.productMap[this.selectedproduct].Dynamic_Pricing_Parameters__r
    //         const options = params.filter(el => el.Option_Type__c == "Exclusion_Risks")
    //         console.log("Exclusion_RisksOptions:::", options);

    //         return options && options.map(el => {
    //             return { label: el.Option_Label__c, value: String(el.Premium_Reduction__c), labelValue: el.Option_Label_Value__c, isChecked: false }
    //         })
    //     }
    // }
    @track exclusionOptions = [
        { dataId: "Country_Risks", label: this.label.Country_Risks, value: "5", isChecked: false },
        { dataId: "Repudiation_Risks", label: this.label.Repudiation_Risks, value: "10", isChecked: false },
    ]



    @wire(getDynamicPrice, { source: 'onboardingDP' })
    getDynamicPrice({ error, data }) {
        console.log('getDynamicPrice=' + JSON.stringify(data, null, '\t') + JSON.stringify(error, null, '\t'), this.selectedProductName)

        if (data) {
            this.dynamicPrice = {}
            let SBPId = ""
            let SBPPriceList = []
            data.forEach((rec, index) => {
                if (rec.Premium_Rate_On__c == 'DE') {
                    SBPId = rec.Product__c
                    SBPPriceList.push(rec)
                }
                this.dynamicPrice[rec.Product__c] = rec
            })
            //format pricebook for SBP
            // console.log("fsdjkfh::", JSON.stringify(SBPPriceList));
            SBPPriceList.forEach(el => {
                if (!this.SBPPriceBook[el.Loading__c]) {
                    this.SBPPriceBook[el.Loading__c] = {}
                }
                this.SBPPriceBook[el.Loading__c][el.Country_Grade__c] = el
            });
            this.dynamicPrice[SBPId] = {
                Id: SBPId,
                Premium_Rate_On__c: "DE"
            }

            if (this.selectedproduct) {
                this.selectedproductId = this.selectedproduct
                this.setProductDetails()
            }
            console.log('getDynamicPrice=' + JSON.stringify(this.dynamicPrice, null, '\t'))
            //console.log('questions='+JSON.stringify(this.questions, null, '\t'))
        } else if (error) {
            console.error(error)
            this.error = 'Unable load Dynamic Price';
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
    @wire(getDiscounts, { source: 'onboardingDP' })
    getDiscounts({ error, data }) {
        console.log('getDiscounts=' + JSON.stringify(data, null, '\t') + JSON.stringify(error, null, '\t'))

        if (data) {
            // this.discount = []

            data.forEach((rec, index) => {
                // this.discount.push = rec
            })
            if (this.selectedproduct) {
                // const sel_prod = this.productMap[this.selectedproduct]
                // sel_prod.checked = true
                // this.premium_rate = sel_prod.Premium_Rate__c
                // this.calculatePremium()
            }
            console.log('getDiscounts=' + JSON.stringify(data, null, '\t'))
            //console.log('questions='+JSON.stringify(this.questions, null, '\t'))
        } else if (error) {
            console.error(error)
            this.error = 'Unable load Dynamic Price';
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
    handleProductSelect(event) {
        if (this.isReviseQuote) {
            return
        }
        console.log(event.currentTarget.id)
        let id = event.currentTarget.id + ""
        id = id.split("-")[0]
        console.log(event.target.id, event.currentTarget.id)
        console.log("dp:", JSON.stringify(this.dynamicPrice))
        // this.primiumOnLabel = this.dynamicPrice[id] ? this.dynamicPrice[id].Premium_Rate_On__c : ""
        // this.premiumValue = this.getPremiumValue(id)
        // this.shouldShowExtrafieldsClass = this.productMap[id].Name === "OMBP" ? "disabled" : ""
        console.log("premiumValue==>", this.premiumValue, this.dynamicPrice[id].Premium_Rate_On__c)
        this.selectedproduct = id
        this.selectedproductId = id
        this.proposal['Product__c'] = id
        this.setProductDetails()
        // console.log("shouldShowExtrafieldsClass", this.shouldShowExtrafieldsClass)
    }

    //console.log("setProductDetails=>" + productId)
    setProductDetails() {
        // this.selectedproductId = productId
        const productId = this.selectedproductId
        if (!this.dynamicPrice) return
        const dp = this.dynamicPrice[productId]

        if (!dp) return
        this.premium_rate_on = dp.Premium_Rate_On__c

        let tempProducts = []
        let tempproductMap = {}
        this.showProducts.forEach((rec, index) => {
            const plan = { ...rec }
            plan.checked = (plan.Id === productId) ? true : false
            tempProducts.push(plan)
            tempproductMap[plan.Id] = plan
            plan.cardClassName = this.selectedproductId == plan.Id ? "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card1_selected" : "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card1"
            if (this.selectedproductId === plan.Id) this.selectedProductName = rec.Name
        })
        this.isProductSBP = this.selectedProductName == "SBP" ? true : false
        this.isProductOMBP = this.selectedProductName == "OMBP" ? true : false
        this.indemnityRatio = this.selectedProductName == "OMBP" ? "0" : this.indemnityRatio
        console.log("selected Product:::::=>", this.selectedProductName);
        // if (this.isProductSBP)
        //     Object.keys(this.baseSBPPriceRate).forEach(key => this.baseSBPPriceRate[key] = dp[key + "__c"])


        // debugger
        // console.log("dynamicPrice=>" + JSON.stringify(dp))
        console.log("isproductombp=>" + this.isProductOMBP)
        try {
            //let temp = this.premiumValue
            if (dp.Premium_Rate_On__c === 'Maximum Liability') {
                this.basePremiumRate = dp.Base_Rate_Per_Anum__c //SUP
                this.premiumFormula = "(Formula: ML * Premium Rate * (1-Indemnity ratio% - NQL%)"
                //500000 * 1.20/100 * (1 - 10/100 - 7.5/100)
                this.premium = this.premiumValue * (this.basePremiumRate / 100) * (1 - this.indemnityRatio / 100 - this.nQL / 100)
                this.finalPremiumRate = this.toFixedIfNecessary(this.basePremiumRate * (1 - this.indemnityRatio / 100 - this.nQL / 100))

                this.showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
                this.showExclutionsClass = "display_none"

            } else if (dp.Premium_Rate_On__c === 'Credit Limit') {
                this.basePremiumRate = dp.Base_Rate_Per_Quarter__c//OMBP
                this.premiumFormula = "(Formula: CL Approved * Premium Rate * Discount)"
                this.premium = this.premiumValue * (this.basePremiumRate / 100) * 0.8
                this.finalPremiumRate = this.toFixedIfNecessary(this.basePremiumRate * (1 - this.discount / 100))

                this.showNQLClass = "display_none"
                this.showExclutionsClass = "display_none"
                this.isProductOMBP = true
            } else {
                // this.sbpPriceRate = {
                //     Pre_Shipment: this.toFixedIfNecessary(this.baseSBPPriceRate.Pre_Shipment * (1 - this.indemnityRatio / 100 - this.nQL / 100 - this.exclusion / 100)),
                //     DP: this.toFixedIfNecessary(this.baseSBPPriceRate.DP * (1 - this.indemnityRatio / 100 - this.nQL / 100 - this.exclusion / 100)),
                //     OA1_60: this.toFixedIfNecessary(this.baseSBPPriceRate.OA1_60 * (1 - this.indemnityRatio / 100 - this.nQL / 100 - this.exclusion / 100)),
                //     OA61_120: this.toFixedIfNecessary(this.baseSBPPriceRate.OA61_120 * (1 - this.indemnityRatio / 100 - this.nQL / 100 - this.exclusion / 100)),
                // }
                // this.basePremiumRate = 0
                // this.premiumFormula = "Formula: NA"
                this.showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
                this.showExclutionsClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
            }
            //let temp = this.premiumValue
            // if (temp) {
            //     let finalPremium = temp - temp * this.basePremiumRate / 100
            //     finalPremium = finalPremium - temp * this.discount
            //     finalPremium = finalPremium - temp * this.indemnityRatio / 100
            //     finalPremium = finalPremium - temp * this.nQL / 100
            //     this.premium = finalPremium
            //     console.log("finalPremium", this.basePremiumRate, this.discount, this.premium)
            // }

            this.showProducts = tempProducts
            this.productMap = tempproductMap
        } catch (e) {
            console.error(e)
        }
    }
    toFixedIfNecessary(value, dp = 2) {
        // return +parseFloat(value).toFixed(dp);
        return (Math.round(value * 100) / 100).toFixed(2);
    }

    handleFormInputChange(event) {
        console.log("premium==>", event.target.name, event.target.value)
        if (event.target.name === "premiumValue") {
            this.premiumValue = event.target.value
            this.setProductDetails()
        }
    }

    @wire(getObjectInfo, { objectApiName: DYNAMIC_PRICE })
    objectInfo;


    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Indemnity_Ratio__c })
    // handleGetindemnityRatio({ data, error }) {
    //     if (data) {
    //         // this.wire2Done = true
    //         // this.hideLoadSpinner()
    //         // this.CountryPicklistValues = data
    //         this.indemnityRatioPicklist = data.values
    //         console.log('indemnityRatioPicklist => ' + JSON.stringify(this.indemnityRatioPicklist))
    //     }
    //     if (error) {
    //         console.log('Error => ' + error)
    //     }
    // }
    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Non_Qualify_Loss__c })
    // handleGetnQL({ data, error }) {
    //     if (data) {
    //         // this.wire2Done = true
    //         // this.hideLoadSpinner()
    //         // this.CountryPicklistValues = data
    //         this.nQLPicklist = data.values
    //         console.log('nQLPicklist => ' + JSON.stringify(this.nQLPicklist))
    //     }
    //     if (error) {
    //         console.log('Error => ' + error)
    //     }
    // }
    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Exclusion__c })
    // handleGetnQL({ data, error }) {
    //     if (data) {
    //         // this.wire2Done = true
    //         // this.hideLoadSpinner()
    //         // this.CountryPicklistValues = data
    //         this.exclusionPicklist = data.values
    //         console.log('Exclusion picklist=> ' + JSON.stringify(this.exclusionPicklist))
    //     }
    //     if (error) {
    //         console.log('Error => ' + error)
    //     }
    // }
    get policyType() {
        switch (this.selectedProductName) {
            case "SBP":
                return '51';
            case "OMBP":
                return '70';
            case "SUP":
                return '56';
        }
    }
    removeExcesParams() {
        console.log("selectedProductName:::", this.selectedProductName);
        if (this.selectedProductName == "SBP") {

            delete this.proposal.Base_Rate_Per_Quarter__c
            delete this.proposal.Base_Rate_Per_Anum__c
        }
        else if (this.selectedProductName == "OMBP") {
            delete this.proposal.Base_Rate_Per_Anum__c
            delete this.proposal.DA_OA_0_30__c
            delete this.proposal.DA_OA_31_60__c
            delete this.proposal.DA_OA_61_90__c
            delete this.proposal.DA_OA_91_180__c
            delete this.proposal.DP_NonA__c
            delete this.proposal.DA_OA_0_30_NonA__c
            delete this.proposal.DA_OA_31_60_NonA__c
            delete this.proposal.DA_OA_61_90_NonA__c
            delete this.proposal.DA_OA_91_180_NonA__c
        } else if (this.selectedProductName == "SUP") {
            delete this.proposal.Base_Rate_Per_Quarter__c
            delete this.proposal.DA_OA_0_30__c
            delete this.proposal.DA_OA_31_60__c
            delete this.proposal.DA_OA_61_90__c
            delete this.proposal.DA_OA_91_180__c
            delete this.proposal.DP_NonA__c
            delete this.proposal.DA_OA_0_30_NonA__c
            delete this.proposal.DA_OA_31_60_NonA__c
            delete this.proposal.DA_OA_61_90_NonA__c
            delete this.proposal.DA_OA_91_180_NonA__c
        }
    }


    showPrevious() {
        console.log(' ====> showPrevious')
        if (this.isMultipleProposal || this.isReviseQuote) {
            this.gotoDashboard()
        } else {
            const event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: { pageId: this.retUrl ? this.retUrl : "showOnboardingPI", source: 'showOnboardingDP', proposal: this.proposal }
            });
            this.dispatchEvent(event1)

        }
    }
    showOnboardingFillInProposal() {
        this.proposal['Indemnity_Percentage__c'] = this.indemnityRatio
        // this.proposal['Indemnity_Percentage__c']=this.indemnityRatioOptions.filter(el=>el.value==String(this.indemnityRatio)).label
        this.proposal['Policy_Type__c'] = this.policyType
        if (this.selectedProductName == 'OMBP') {
            this.proposal['Base_Rate_Per_Quarter__c'] = this.basePremiumRate
            this.proposal['Final_Premium_Rate__c'] = this.finalPremiumRate
        } else if (this.selectedProductName == 'SUP') {
            this.proposal['Base_Rate_Per_Anum__c'] = this.basePremiumRate
            this.proposal['Final_Premium_Rate__c'] = this.finalPremiumRate
            this.proposal['NQL__c'] = this.nQL || '0'
        } else if (this.selectedProductName == "SBP") {
            this.proposal['NQL__c'] = this.nQL || '0'
            this.proposal['Base_Loading__c'] = this.baseLoading
            this.proposal['Premium_Loading__c'] = this.finalLoading

            this.proposal['DP__c'] = this.sbpPriceRate.DP_A
            this.proposal['DA_OA_0_30__c'] = this.sbpPriceRate.DA_OA_0_30_A
            this.proposal['DA_OA_31_60__c'] = this.sbpPriceRate.DA_OA_31_60_A
            this.proposal['DA_OA_61_90__c'] = this.sbpPriceRate.DA_OA_61_90_A
            this.proposal['DA_OA_91_180__c'] = this.sbpPriceRate.DA_OA_91_180_A
            this.proposal['DP_NonA__c'] = this.sbpPriceRate.DP_NonA
            this.proposal['DA_OA_0_30_NonA__c'] = this.sbpPriceRate.DA_OA_0_30_NonA
            this.proposal['DA_OA_31_60_NonA__c'] = this.sbpPriceRate.DA_OA_31_60_NonA
            this.proposal['DA_OA_61_90_NonA__c'] = this.sbpPriceRate.DA_OA_61_90_NonA
            this.proposal['DA_OA_91_180_NonA__c'] = this.sbpPriceRate.DA_OA_91_180_NonA

        }


        const iPercentList = this.indemnityRatioOptions.filter(el => el.value == String(this.indemnityRatio))
        if (iPercentList.length) {
            this.proposal['Indemnity_Ratio__c'] = iPercentList[0].label.replace('%', '')
        }
        const nqlList = this.NQLOptions.filter(el => el.value == String(this.nQL))
        if (nqlList.length) {
            this.proposal['NQL_Amount__c'] = nqlList[0].label.replace('HKD', '').replace(',', '').trim()
        }
        console.log(' ====> showOnboardingFillInProposal')
        console.log("selected Product:::::", this.selectedProductName);
        console.log("before removing::", JSON.stringify(this.proposal));
        this.removeExcesParams()
        console.log("after removing::", JSON.stringify(this.proposal));
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingFillInProposal', selected_product: this.selectedproductId, proposal: this.proposal, selectedProductName: this.selectedProductName }
        });
        this.dispatchEvent(event1)
    }
    gotoDashboard() {
        console.log("showdashboard");
        const redUrl = '/ECReach/s/dashboard'
        console.log("redirecting to :", redUrl);
        window.location.href = redUrl
    }
}
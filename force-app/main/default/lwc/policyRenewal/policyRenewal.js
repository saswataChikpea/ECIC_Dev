import SystemModstamp from '@salesforce/schema/Account.SystemModstamp'// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { api, LightningElement, track, wire } from 'lwc';
import getDynamicPrice from '@salesforce/apex/OnBoarding.getDynamicPrice';
import getDiscounts from '@salesforce/apex/OnBoarding.getDiscounts';
import DYNAMIC_PRICE from '@salesforce/schema/Dynamic_Price__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import Indemnity_Ratio__c from '@salesforce/schema/Dynamic_Price__c.Indemnity_Ratio__c';
import Non_Qualify_Loss__c from '@salesforce/schema/Dynamic_Price__c.Non_Qualify_Loss__c';
import getAllSchedule from '@salesforce/apex/PolicyManagement.getAllSchedule';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';

import current_user from '@salesforce/user/Id';

import saveDynamicPrice from '@salesforce/apex/PolicyManagement.saveDynamicPrice'
import Exclusion__c from '@salesforce/schema/Dynamic_Price__c.Exclusion__c';

import PRODUCT_OBJECT from '@salesforce/schema/Plan__c';
import PRODUCT_TYPE from '@salesforce/schema/Plan__c.Product_Type__c';
import PRODUCT_INDEMENITY from '@salesforce/schema/Plan__c.Indemenity__c';



export default class PolicyRenewal extends LightningElement{

    @track userId = current_user;
    @api selectedproduct
    @track products

    @track showTabTwo = true

    @track cl_approved_amount = 100000
    @track premium_rate
    @track discount = 0
    @track premium = 0// = 'this.clL_approved_amount * this.premium_rate * this.discount'		
    @track dynamicPrice
    @track premiumRate = 0
    @track premiumFormula = "(Formula: CL Approved * Discount * Premium Rate)"
    @api selectedProductId;
    @api policySfdcId;
    @track premiumValue = 0

    @track indemnityRatioPicklist = {}
    @track indemnityRatio;
    @track nQLPicklist = {}
    @track nQL = 0
    @track actualNqlValue=-0;
    @track exclusion = 0

    @track premium_rate_on
    @track showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3";
    @track showExclutionsClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3";
    @track chkBoxisNill = false;
    @track chkBoxisTenK = false;
    @track chkBoxisThirtyK = false;
    @track chkBoxisFiftyK = false;
    @track non_qualify_loss = [];
    @track actualIdemnityRatio=-0;
    product_map = {}
    @api isProductOmbp = false;
    @api isProductSbp = false;
    @api isProductSup = false;
    @track isNqlCheckedZero = false;
    @track isNqlCheckedTen = false;
    @track isNqlCheckedThrity = false;
    @track isNqlCheckedFifty = false;

    @track policyScheduleId;
    @track policyId;

    /*@track sbpPriceRate = {
        Pre_Shipment: 0,
        DP: 0,
        OA1_60: 0,
        OA61_120: 0,
    }*/
    @track baseSBPPriceRate = {
        Pre_Shipment: 0,
        DP: 0,
        OA1_60: 0,
        OA61_120: 0,
    }
    //Newly Added
    baseLoading = 0
    @track SBPPriceBook = {}
    @track selectedProductName;
    @track mapIndemnityValue;

    @wire(getObjectInfo, { objectApiName: PRODUCT_OBJECT })
    objectInfo;

    @track productType;
    @track indemenityValueAccToProduct;

    @wire(getPicklistValues, { 
        recordTypeId: '012000000000000AAA', 
        fieldApiName: PRODUCT_TYPE
    })
    ProductTypePicklistValues({ data, error }) {
        console.log('ProductTypePicklistValues : ',data);
        if (data){
            this.productType = data.values;
        } 
        if (error){
            console.error('Error :',error);
        } 
    }

    @wire(getPicklistValues, { 
        recordTypeId: '012000000000000AAA', 
        fieldApiName: PRODUCT_INDEMENITY
    })
    IndemenityPicklistValues({ data, error }) {
        console.log('IndemenityPicklistValues : '+JSON.stringify(data));
        if (data){
            this.indemenityValueAccToProduct = data.values;
            
        } 
        if (error){
            console.error('Error :',error);
        } 
    }

    connectedCallback() {
        console.log('userId:'+this.userId+' selectedProductId=' + this.selectedProductId+' policySfdcId:'+this.policySfdcId)
        //this.calculatePremium()
        //this.getDynamicPrice()
        this.premiumRate = 0.7;
        console.log('isProductOmbp :'+this.isProductOmbp+'\n isProductSbp:'+this.isProductSbp+'\n isProductSup : '+this.isProductSup );
        //this.handleProductSelect();
        if(this.isProductOmbp){
            this.selectedProductName = 'OMBP';
            this.showNQLClass = "display_none"
            this.showExclutionsClass = "display_none"
        }else if(this.isProductSup){
            this.selectedProductName = 'SUP';
        }else if(this.isProductSbp){
            this.selectedProductName = 'SBP';
        }

        console.log('showNQLClass : '+this.showNQLClass+'\n showExclutionsClass :'+this.showExclutionsClass)
        //this.getDynamicPrice();
        this.getAllSchedule();

        console.log('Connected ===>> ',this.indemenityValueAccToProduct);
        for(let ind in this.indemenityValueAccToProduct){
            console.log('===>>ind : ',ind,' value :',this.indemenityValueAccToProduct[ind]);
        }

    }
    get indemnityRatioOptions() {
        switch (this.selectedProductName) {
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
    get NQLOptions() {
        return this.selectedProductName == "SBP" ?
            [
                { label: 'HKD 0', value: "0" },
                { label: 'HKD 50,000', value: "5" },
                { label: 'HKD 100,000', value: "10" }
            ] :
            [
                { label: 'HKD 0', value: "0" },
                { label: 'HKD 50,000', value: "5" },
                { label: 'HKD 100,000', value: "10" }
            ]

    }
    @track exclusionOptions = [
        { dataId: "Country_Risks", label: 'Country Risks', value: "5", isChecked: false },
        { dataId: "Repudiation_Risks", label: 'Repudiation Risks', value: "10", isChecked: false },
    ]
    options = [
        { label: '10000', value: '10,000' },
        { label: '30000', value: '30,000' },
        { label: '50000', value: '50,000' }
    ]
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
    getAllSchedule(){
        console.log('Pol renewal getAllSchedule called.');
        getAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getAllSchedule success :'+JSON.stringify(data));
            try {
                //this.allSchedule = data;
                for(let sch in data){
                    this.policyId = data[sch].Policy__c;
                    if(data[sch].Type__c === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        this.policyScheduleId = data[sch].Id;
                        this.premium_rate_on=data[sch].Premium_Rate_On__c;

                        if(this.isProductOmbp){
                            this.basePremiumRate = data[sch].Base_Rate_Per_Quarter__c;
                            this.finalPremiumRate = this.basePremiumRate;
                        }else if(this.isProductSup){
                            this.basePremiumRate = data[sch].Base_Rate_Per_Anum__c;
                            this.finalPremiumRate = this.basePremiumRate;
                        }else if(this.isProductSbp){
                            if(data[sch].Percentage_of_Indemnity__c==90){
                                this.indemnityRatio=0;
                            }else if(data[sch].Percentage_of_Indemnity__c==80){
                                this.indemnityRatio=-10;
                            }else if(data[sch].Percentage_of_Indemnity__c==70){
                                this.indemnityRatio=-20;
                            }else if(data[sch].Percentage_of_Indemnity__c==60){
                                this.indemnityRatio=-30;
                            }

                            
                            this.baseLoading = data[sch].Base_Loading__c;
                            this.baseSBPPriceRate = {
                                Pre_Shipment:data[sch].Pre_Shipment__c,
                                DP:data[sch].DP__c,
                                OA1_60:data[sch].OA1_60__c,
                                OA61_120:data[sch].OA61_120__c,
                            }
                        }
                        //this.indemnityRatio = data[sch].Percentage_of_Indemnity__c;

                        
                    }
                }
                this.handleParameterChange();
                console.log('this.premium_rate_on ::'+this.premium_rate_on+' baseSBPPriceRate : '+JSON.stringify(this.baseSBPPriceRate));

            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while loading dynamic price.',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading dynamic price.',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    /*getDynamicPrice(){
        getDynamicPrice({}).then(data => {
            console.log(' getDynamicPrice success :'+JSON.stringify(data));
            try {
                this.dynamicPrice = data;
                for(let dynPrice in this.dynamicPrice){
                    if(this.dynamicPrice[dynPrice].Product__c ===  this.selectedProductId){
                        this.premium_rate_on=this.dynamicPrice[dynPrice].Premium_Rate_On__c;
                        if(this.isProductOmbp){
                            this.basePremiumRate = this.dynamicPrice[dynPrice].Base_Rate_Per_Quarter__c;
                            this.finalPremiumRate = this.basePremiumRate;
                        }else if(this.isProductSup){
                            this.basePremiumRate = this.dynamicPrice[dynPrice].Base_Rate_Per_Anum__c;
                            this.finalPremiumRate = this.basePremiumRate;
                        }else if(this.isProductSbp){
                            this.baseSBPPriceRate = {
                                Pre_Shipment:this.dynamicPrice[dynPrice].Pre_Shipment__c,
                                DP:this.dynamicPrice[dynPrice].DP__c,
                                OA1_60:this.dynamicPrice[dynPrice].OA1_60__c,
                                OA61_120:this.dynamicPrice[dynPrice].OA61_120__c,
                            }
                        }
                    }
                }
                this.handleParameterChange();
                console.log('this.premium_rate_on ::'+this.premium_rate_on+' baseSBPPriceRate : '+JSON.stringify(this.baseSBPPriceRate));
           } catch (error) {
               console.error(error.toString());
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while loading Dynamic Price',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading Dynamic Price',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }*/
    handleParameterChange(){
        console.log('handleParameterChange : ');
        try {
            console.log('this.premium_rate_on : '+this.premium_rate_on);
            if (this.premium_rate_on === 'Maximum Liability') {
                //this.basePremiumRate = dp.Base_Rate_Per_Anum__c //SUP
                this.premiumFormula = "(Formula: ML * Premium Rate * (1-Indemnity ratio% - NQL%)"
                //500000 * 1.20/100 * (1 - 10/100 - 7.5/100)
                this.premium = this.premiumValue * (this.basePremiumRate / 100) * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100)
                this.finalPremiumRate = this.toFixedIfNecessary(this.basePremiumRate * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100))

                this.showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
                this.showExclutionsClass = "display_none"
                console.log('ML finalPremiumRate : '+this.finalPremiumRate);
            } else if (this.premium_rate_on === 'Credit Limit') {
                this.basePremiumRate = dp.Base_Rate_Per_Quarter__c//OMBP
                this.premiumFormula = "(Formula: CL Approved * Premium Rate * Discount)"
                this.premium = this.premiumValue * (this.basePremiumRate / 100) * 0.8
                this.finalPremiumRate = this.toFixedIfNecessary(this.basePremiumRate * (1 - this.discount / 100))

                this.showNQLClass = "display_none"
                this.showExclutionsClass = "display_none"
                this.isProductOmbp = true
                console.log('CL finalPremiumRate : '+this.finalPremiumRate);
            } else if(this.premium_rate_on === 'DE') {
                /*this.sbpPriceRate = {
                    Pre_Shipment: this.toFixedIfNecessary(this.baseSBPPriceRate.Pre_Shipment * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100 - this.exclusion / 100), 5),
                    DP: this.toFixedIfNecessary(this.baseSBPPriceRate.DP * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100 - this.exclusion / 100)),
                    OA1_60: this.toFixedIfNecessary(this.baseSBPPriceRate.OA1_60 * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100 - this.exclusion / 100)),
                    OA61_120: this.toFixedIfNecessary(this.baseSBPPriceRate.OA61_120 * (1 - this.actualIdemnityRatio / 100 - this.actualNqlValue / 100 - this.exclusion / 100)),
                }*/
                console.log('sbpPriceRate :: '+JSON.stringify(this.sbpPriceRate));
                this.showNQLClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
                this.showExclutionsClass = "slds-col slds-size_1-of-1 slds-medium-size_1-of-3"
            }

        } catch (e) {
            console.error(e);
        }
    }
    toFixedIfNecessary(value, dp = 4) {
        return +parseFloat(value).toFixed(dp);
    }

    onDragMethod(event){
        console.log('onDragMethod called '+event.target.value);
        console.log('before indemnityRatio  : '+this.indemnityRatio);
        this.indemnityRatio = event.target.value;
        console.log('after indemnityRatio  : '+this.indemnityRatio);
        //Do the calculation on Dragger change
        if(this.isProductSbp){
            if((event.target.value === '60') || 
               (event.target.value === '70') || 
               (event.target.value === '80') || 
               (event.target.value === '90') ){

                if(event.target.value === '60'){
                    this.actualIdemnityRatio = 30;
                }else if(event.target.value === '70'){
                    this.actualIdemnityRatio = 20;
                }else if(event.target.value === '80'){
                    this.actualIdemnityRatio = 10;
                }else if(event.target.value === '90'){
                    this.actualIdemnityRatio = 0;
                }
                this.handleParameterChange();
            }
        }
        if(this.isProductSup){
            if((event.target.value === '50') || 
               (event.target.value === '60') || 
               (event.target.value === '70') || 
               (event.target.value === '80') ){

                if(event.target.value === '50'){
                    this.actualIdemnityRatio = 30;
                }else if(event.target.value === '60'){
                    this.actualIdemnityRatio = 20;
                }else if(event.target.value === '70'){
                    this.actualIdemnityRatio = 10;
                }else if(event.target.value === '80'){
                    this.actualIdemnityRatio = 0;
                }
                this.handleParameterChange();
            }
        }
        console.log('end of method indemnityRatio  : '+this.indemnityRatio);
    }
    
    
    handelNQL(event){
        console.log('handelNQL tar name : '+event.target.name);
        console.log('handelNQL tar checked : '+event.target.checked);
        var radio_name = event.target.name;
        if(radio_name === 'radio-0'){
            this.nQL=0;
            this.actualNqlValue=0;
            this.isNqlCheckedZero = true;
            this.isNqlCheckedTen = false;
            this.isNqlCheckedThrity = false;
            this.isNqlCheckedFifty = false;
        }else if(radio_name === 'radio-10'){
            this.nQL=10000;
            this.actualNqlValue=5;
            this.isNqlCheckedZero = false;
            this.isNqlCheckedTen = true;
            this.isNqlCheckedThrity = false;
            this.isNqlCheckedFifty = false;
        }else if(radio_name === 'radio-30'){
            this.nQL=30000;
            this.actualNqlValue=7.5;
            this.isNqlCheckedZero = false;
            this.isNqlCheckedTen = false;
            this.isNqlCheckedThrity = true;
            this.isNqlCheckedFifty = false;
        }else if(radio_name === 'radio-50'){
            this.nQL=50000;
            this.actualNqlValue=10;
            this.isNqlCheckedZero = false;
            this.isNqlCheckedTen = false;
            this.isNqlCheckedThrity = false;
            this.isNqlCheckedFifty = true;
        }
        this.handleParameterChange();
        console.log('nqlValue  : '+this.nQL);
    }

    @track isCountryRisk;
    @track isRepudiationRisk;		
    handleExclusion(event){
        console.log('handleExclusion tar : '+JSON.stringify(event.target));
        console.log('handleExclusion detail : '+JSON.stringify(event.detail));
        console.log('handleExclusion targ : '+event.target.label);
        console.log('handleExclusion targ : '+event.target.value);
        this.exclusion = event.detail.checked ? this.exclusion + Number(event.target.value) : this.exclusion - Number(event.target.value);
        if(event.detail.checked){
            if(event.target.label === 'Country Risks'){
                this.isCountryRisk = true;
            }else if(event.target.label === 'Repudiation Risks'){
                this.isRepudiationRisk = true;
            }
        }else{
            if(event.target.label === 'Country Risks'){
                this.isCountryRisk = false;
            }else if(event.target.label === 'Repudiation Risks'){
                this.isRepudiationRisk = false;
            }
        }
        console.log('isCountryRisk :'+this.isCountryRisk+' isRepudiationRisk :'+this.isRepudiationRiskisRepudiationRisk);
        this.handleParameterChange();

    }
    goToSchedule(event){

    }
    saveDynmaicPrice(event){
        console.log('saveDynmaicPrice premium_rate_on :'+this.premium_rate_on+' \n basePremiumRate:'+this.basePremiumRate);
        console.log('policyScheduleId :'+this.policyScheduleId+'baseSBPPriceRate : '+JSON.stringify(this.baseSBPPriceRate));
        console.log('isProductOmbp :'+this.isProductOmbp+' isProductSup :'+this.isProductSup+' isProductSbp : '+this.isProductSbp);
        console.log('sbpPriceRate======>>'+JSON.stringify(this.sbpPriceRate));
        console.log('sbpPriceRate======>>'+this.sbpPriceRate.DP);
        if(this.isProductOmbp){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Policy with OMBP Product.',
                    message: 'Not Allowed for OMBP.',
                    mode : 'sticky',
                    variant: 'warning'
                })
            );
            return;
        }
        saveDynamicPrice({
            policyId : this.policyId,
            isProductSup : this.isProductSup,
            isProductSbp : this.isProductSbp,
            premiumRateOn : this.premium_rate_on,
            basePremiumRate : this.basePremiumRate,
            preShipment : this.baseSBPPriceRate.Pre_Shipment,
            indemnityRatio : this.indemnityRatio,
            nQL : this.nQL,
            isCountryRisk : this.isCountryRisk,
            isRepudiationRisk : this.isRepudiationRisk,
            DP : this.sbpPriceRate.DP_A,
            DA_OA_0_30 : this.sbpPriceRate.DA_OA_0_30_A,
            DA_OA_31_60 : this.sbpPriceRate.DA_OA_31_60_A,
            DA_OA_61_90 : this.sbpPriceRate.DA_OA_61_90_A,
            DA_OA_91_120 : this.sbpPriceRate.DA_OA_91_180_A,
            DP_NonA : this.sbpPriceRate.DP_NonA,
            DA_OA_0_30_NonA : this.sbpPriceRate.DA_OA_0_30_NonA,
            DA_OA_31_60_NonA : this.sbpPriceRate.DA_OA_31_60_NonA,
            DA_OA_61_90_NonA : this.sbpPriceRate.DA_OA_61_90_NonA,
            DA_OA_91_120_NonA : this.sbpPriceRate.DA_OA_61_90_NonA

            }).then(data => {
            console.log('saveDynamicPrice success :'+JSON.stringify(data));
            
            try {
                if(data){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Save successfully for new policy.',
                            message: 'This new dynamice pricing will be used in new policy.',
                            mode : 'sticky',
                            variant: 'success'
                        })
                    );
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Failed to save.',
                            message: '',
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }
                
            } catch (error) {
                console.error(error.toString()+'  '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while saving Dynamic Pricing.',
                        message: error.toString()+'  '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'waarning'
                    })
                );
            }
            
        }).catch(error => {
            console.error(error.toString()+'  '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while saving Dynamic Pricing.',
                    message: error.toString()+'  '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }

    //Changes in Dynamic Pricing
    get sbpPriceRate() {
        console.log('Get sbpPriceRate baseLoading :'+this.baseLoading+' nQL :'+this.nQL+' indemnityRatio:'+this.indemnityRatio+' exclusion:'+this.exclusion);
        const finalLoading = this.baseLoading - this.nQL - this.indemnityRatio - this.exclusion;
        //console.log('SBPPriceBook===>>>'+JSON.stringify(this.SBPPriceBook));
        console.log('sbpPriceRate called===>>>');
        const temp = this.SBPPriceBook[finalLoading + ''];
        console.log("finalLoading::", finalLoading, JSON.stringify(temp));
        return {
            DP_A: temp ? temp["GRADE_A"]["DP__c"] : 0,
            DA_OA_0_30_A: temp ? temp["GRADE_A"]["DA_OA_0_30__c"] : 0,
            DA_OA_31_60_A: temp ? temp["GRADE_A"]["DA_OA_31_60__c"] : 0,
            DA_OA_61_90_A: temp ? temp["GRADE_A"]["DA_OA_61_90__c"] : 0,
            DA_OA_91_180_A: temp ? temp["GRADE_A"]["DA_OA_91_180__c"] : 0,
            DP_NonA: temp ? temp["GRADE_BC"]["DP__c"] : 0,
            DA_OA_0_30_NonA: temp ? temp["GRADE_BC"]["DA_OA_0_30__c"] : 0,
            DA_OA_31_60_NonA: temp ? temp["GRADE_BC"]["DA_OA_31_60__c"] : 0,
            DA_OA_61_90_NonA: temp ? temp["GRADE_BC"]["DA_OA_61_90__c"] : 0,
            DA_OA_91_180_NonA: temp ? temp["GRADE_BC"]["DA_OA_91_180__c"] : 0
        }
    }
    
    // get sbpPriceRate(){
    //     console.log('sbpPriceRate called.');
    //     getWrapperAllSchedule({
    //         usrId : this.userId
    //     }).then(data => {
    //         console.log('sbpPriceRate success :'+JSON.stringify(data));
    //         try {
    //             for(let sch in data){
    //                 if(data[sch].scheduleType === 'Schedule 2'){
    //                     console.log('Schedule 2*********************');
    //                     return {
    //                         DP_A:data[sch].DP,
    //                         DA_OA_0_30_A:data[sch].DA_OA_0_30,
    //                         DA_OA_31_60_A:data[sch].DA_OA_31_60,
    //                         DA_OA_61_90_A:data[sch].DA_OA_61_90,
    //                         DA_OA_91_180_A:data[sch].DA_OA_91_120,
    
    //                         DP_NonA:data[sch].DP_NonA,
    //                         DA_OA_0_30_NonA:data[sch].DA_OA_0_30_NonA,
    //                         DA_OA_31_60_NonA:data[sch].DA_OA_31_60_NonA,
    //                         DA_OA_61_90_NonA:data[sch].DA_OA_61_90_NonA,
    //                         DA_OA_91_180_NonA:data[sch].DA_OA_91_120_NonA
    //                     }
    //                 }
    //             }
    //         } catch (error) {
    //            console.error(error.toString+'=='+JSON.stringify(error));
    //             this.dispatchEvent(
    //                 new ShowToastEvent({
    //                     title: 'Exception Occurred while fetching Policy Schedule',
    //                     message: error.toString(),
    //                     mode : 'sticky',
    //                     variant: 'warning'
    //                 })
    //             );
    //         }
            
    //     }).catch(error => {
            
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Exception Occurred while fetching Schedule',
    //                 message: error.toString(),
    //                 mode : 'sticky',
    //                 variant: 'error'
    //             })
    //         );
    //     });
    // }

    @wire(getObjectInfo, { objectApiName: DYNAMIC_PRICE })
    objectInfo;


    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Indemnity_Ratio__c })
    handleGetindemnityRatio({ data, error }) {
        if (data) {
            // this.wire2Done = true
            // this.hideLoadSpinner()
            // this.CountryPicklistValues = data
            this.indemnityRatioPicklist = data.values
            console.log('indemnityRatioPicklist => ' + JSON.stringify(this.indemnityRatioPicklist))
        }
        if (error) {
            console.log('Error => ' + error)
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Non_Qualify_Loss__c })
    handleGetnQL({ data, error }) {
        if (data) {
            // this.wire2Done = true
            // this.hideLoadSpinner()
            // this.CountryPicklistValues = data
            this.nQLPicklist = data.values
            console.log('nQLPicklist => ' + JSON.stringify(this.nQLPicklist))
        }
        if (error) {
            console.log('Error => ' + error)
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Exclusion__c })
    handleGetnQL({ data, error }) {
        if (data) {
            // this.wire2Done = true
            // this.hideLoadSpinner()
            // this.CountryPicklistValues = data
            this.exclusionPicklist = data.values
            console.log('Exclusion picklist=> ' + JSON.stringify(this.exclusionPicklist))
        }
        if (error) {
            console.log('Error => ' + error)
        }
    }

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
            console.log("Whole Dynamic Pricing Table :::", JSON.stringify(this.SBPPriceBook));
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

    handleQChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        console.log(targetName + ":::", targetValue)
        var company_name = 'Company'
        //is_existing_ph
        if (targetValue && targetName) {
            if (targetName === 'Indemnity_Ratio__c') {
                this.indemnityRatio = event.target.value;
            } else if (targetName === 'NQL__c') {
                this.nQL = event.target.value;
            }
            // else if (targetName === 'Exclusions__c') {


            //     this.exclusion = event.target.value;
            // }
            //this.proposal[targetName] = targetValue
        }
        this.handleParameterChange()
        //console.log('proposal=' + JSON.stringify(this.proposal))
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
            //this.proposal[targetName] = JSON.stringify(this.exclusionOptions)
        }
        // console.log("corres", JSON.stringify(this.correspondenceAddress))
        this.handleParameterChange()
    }
}
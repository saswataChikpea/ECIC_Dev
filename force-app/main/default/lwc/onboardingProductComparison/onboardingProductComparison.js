import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProducts from '@salesforce/apex/OnBoarding.getProducts';
import getProductFeatures from '@salesforce/apex/OnBoarding.getProductFeatures';


export default class OnboardingProductComparison extends LightningElement {
    @track error = false
    @track showLoadingSpinner = false
    @track products = []
    @track product_features = []
    /*@track products = [
        {
            "Id": "1",
            "Name": "Online Micro-Business Policy (OMBP)",
            "image": "http://www.hkecic.com/materials/category/policies_photo_20181002142740228.jpg",
            "Feature": [
                    {"Eligibility": "Company sales turnover below $20mn"},
                    {"Cover": "Post-shipment"}
                ]
        },
        {
            "Id": "2",
            "Name": "Small Business Policy (SBP)",
            "image": "http://www.hkecic.com/materials/category/policies_photo_20181002142740228.jpg",
            
            "Feature": [
                {"Eligibility": "Company sales turnover below $50mn"},
                {"Cover": "Post-shipment"}
            ]
        },
        {
            "Id": "3",
            "Name": "Self Underwritten Policy (SUP)",
            "image": "http://www.hkecic.com/materials/category/policies_photo_20181002142740228.jpg",
            "Feature": [
                {"Eligibility": "Company sales turnover below $50mn"},
                {"Cover": "Post-shipment (With pre-shipment option)"}
            ]
        }
    ]*/
    @track product_features1 = [
        { "id": "1", "value": ["", "HKD", "HKD", "HKD"] },
        { "id": "2", "value": ["1. Eligibility", "Company sales turnover below $20mn", "Company sales turnover below $50mn", "Company sales turnover below $50mn"] },
        { "id": "3", "value": ["2. Cover", "Post-shipment", "Post-shipment", "Post-shipment (With pre-shipment option)"] },
        { "id": "4", "value": ["3. Risk Insurable", "Insolvency,default", "Insolvency,default,repudiation,country", "Insolvency,default"] },
        { "id": "5", "value": ["4. Buyer Cover", "Singal Invoice", "Selective buyer", "Whole insurable turnover"] },
        { "id": "6", "value": ["5. Max. Buyer Limit", "$500,000", "$5000,000", "$5000,000"] },
        { "id": "7", "value": ["6. Buyer Limit", "Access by ECIC", "Access by ECIC", "Self Assessment"] },
        { "id": "8", "value": ["7. Premium Discount", "Charge on buyer limit", "Charge on insurable shipment", "Charge on Max. Liability"] },
        { "id": "9", "value": ["8. Max Liability", "$2,500,000", "$5,000,000", "$1,000,000"] },
        { "id": "10", "value": ["9. Premium Discount", "*", "*", "20%"] },
        { "id": "11", "value": ["10. Buyer Checking Quota", "20", "30", "10"] },
        { "id": "12", "value": ["11. Indemnity", "90%", "60-90%(Self-chosen)", "50-80%(Self-chosen)"] },

    ]

    @track ombpButtonLabel;
    @track sbpButtonLabel;
    @track supButtonLabel;
    @track btnRow = 'btnRow';
    @track productFeaturesMap;
    @track productOmbpId;
    @track productSbpId;
    @track productSupId;

    connectedCallback() {
        this.btnRow = 'btnRow';
        this.productFeaturesMap;
        this.getProducts();
        this.getProductFeatures();
    }
    ombpClick(event) {
        try {
            this.ombpButtonLabel = event.target.label;
            console.log('online micro-bussiness policy id : ' + this.productOmbpId);
            const event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    pageId: 'showOnboardingDP',
                    productId: this.productOmbpId
                }
            });
            this.dispatchEvent(event1);
        } catch (error) {
            console.log('Error in ombpClick : ' + error.toString());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.toString(),
                    message: '',
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        }
    }
    sbpClick(event) {
        try {
            this.sbpButtonLabel = event.target.label;
            console.log('small bussiness policy id : ' + this.productSbpId);
            const event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    pageId: 'showOnboardingDP',
                    productId: this.productSbpId
                }
            });
            this.dispatchEvent(event1);
        } catch (error) {
            console.log('Error in sbpClick : ' + error.toString());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.toString(),
                    message: '',
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        }
    }
    supClick(event) {
        try {
            this.supButtonLabel = event.target.label;
            console.log('self underwritten policy id : ' + this.productSupId);
            const event1 = new CustomEvent('handlepagechange', {
                // detail contains only primitives
                detail: {
                    pageId: 'showOnboardingDP',
                    productId: this.productSupId
                }
            });
            this.dispatchEvent(event1);
        } catch (error) {
            console.log('Error in supClick : ' + error.toString());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.toString(),
                    message: '',
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        }
    }
    getProducts() {
        console.log('getProducts called.');
        getProducts({}).then(data => {
            console.log('getProducts success :' + JSON.stringify(data));
            try {
                this.products = data;
                console.log('this.products ::' + JSON.stringify(this.products));
                for (let p in data) {
                    console.log('Seq---->' + data[p].Display_Sequence__c);
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
            console.error('Error Occurred : ' + error);
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
    getProductFeatures() {
        console.log('getProducts called.');
        getProductFeatures({}).then(data => {
            console.log('getProductFeatures success :' + JSON.stringify(data));
            try {
                let masterProductFeatureList = [];
                let ombpMap = {}; let sbpMap = {}; let supMap = {};
                for (let pf in data) {
                    console.log(data[pf].Plan__r.Name + '--' + data[pf].Parent_Feature__c + '--' + data[pf].Display_Sequence__c);

                    if (data[pf].Plan__r.Name === 'OMBP') {
                        ombpMap[data[pf].Parent_Feature__c] = data[pf].Criteria_Label__c;
                        /*ombpMap.push({
                            value: data[pf].Criteria_Label__c,
                            key: data[pf].Parent_Feature__c
                        });*/
                    }
                    if (data[pf].Plan__r.Name === 'SBP') {
                        sbpMap[data[pf].Parent_Feature__c] = data[pf].Criteria_Label__c;
                        /*sbpMap.push({
                            value: data[pf].Criteria_Label__c,
                            key: data[pf].Parent_Feature__c
                        });*/
                    }
                    if (data[pf].Plan__r.Name === 'SUP') {
                        supMap[data[pf].Parent_Feature__c] = data[pf].Criteria_Label__c;
                        /*supMap.push({
                            value: data[pf].Criteria_Label__c,
                            key: data[pf].Parent_Feature__c
                        });*/
                    }
                }
                console.log('ombpMap : ' + JSON.stringify(ombpMap));
                console.log('sbpMap : ' + JSON.stringify(sbpMap));
                console.log('supMap : ' + JSON.stringify(supMap));
                var capturedFeatured = [];
                for (let pf in data) {
                    let value = [];
                    let Id = parseInt(pf) + 1;
                    console.log('2nd Loop ID : ' + Id + ' ' + data[pf].Parent_Feature__c);
                    if (!capturedFeatured.includes(data[pf].Parent_Feature__c)) {
                        console.log('Showing Features ' + JSON.stringify(data[pf].Parent_Feature__c));
                        capturedFeatured.push(data[pf].Parent_Feature__c);
                        if (data[pf].Display_Sequence__c)
                            value.push(data[pf].Display_Sequence__c + '. ' + data[pf].Parent_Feature__c);
                        else
                            value.push(' ');
                        value.push(ombpMap[data[pf].Parent_Feature__c]);
                        value.push(sbpMap[data[pf].Parent_Feature__c]);
                        value.push(supMap[data[pf].Parent_Feature__c]);
                        let pFeature = {};
                        pFeature.Id = Id;
                        pFeature.value = value;
                        masterProductFeatureList.push(pFeature);
                    }
                }
                console.log('capturedFeatured  : ' + JSON.stringify(capturedFeatured));
                console.log('pFeature ' + JSON.stringify(masterProductFeatureList));
                this.product_features = masterProductFeatureList;
            } catch (error) {
                console.log('error.toString() :' + error.toString());
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


    /*
    getProducts1(){
        console.log('getProducts called.');
        getProducts({
            
        }).then(data => {
            console.log('getProducts success :'+JSON.stringify(data));
            try {
                if(data.isSuccess){
                    this.products = data.product;
                    //let productFeaturesMap = new productFeaturesMap();
                    for(let p in data.product){
                        console.log(data.product[p].Id+'**XXXXX***'+data.product[p].feature);
                        this.productFeaturesMap
                    }
                    console.log('productFeaturesMap  :: '+JSON.stringify(this.productFeaturesMap));
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Product not Found.',
                            message: data.errMsg,
                            mode : 'sticky',
                            variant: 'warning'
                        })
                    );
                }
            } catch (error) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Occurred.',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
        }).catch(error => {
            console.error('Cannot fetch Product : '+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }*/
    handleFreeQuote(event) {
        console.log('handleFreeQuote ====> ')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingPI' }
        });
        this.dispatchEvent(event1)
    }
    showOnboardingHome(event) {
        console.log('showOnboardingHome ====> ')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingHome' }
        });
        this.dispatchEvent(event1)
    }
}
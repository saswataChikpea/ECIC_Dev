import { LightningElement,api, track, wire } from 'lwc';
import initMethod from '@salesforce/apex/FetchCmsContent.initMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPublishedContentIds from '@salesforce/apex/ContentManagementSystem.getPublishedContentIds';
import current_user from '@salesforce/user/Id';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL'



export default class PolicyCmsContentTermAndCondition extends LightningElement {
    //@wire(initMethod ) results;
    @track results;
    @track counter;
    @track policyTermHeaderContent;
    @track cover;
    @track contractsCoveredAndRelatedConditions;
    @track premium;
    @track policySchedule1Remarks;
    @api productTitle;
    @api policyProductName;
    @api isPolicyTermHeader;
    @api isCover;
    @api isContracts;
    @api isPremium;
    @api isPolSch1Remarks;
    @api policyNumber;

    @track coverButtonIcon;
    @track isCoverSectionexpanded;
    @track contractsButtonIcon;
    @track isContractsSectionexpanded;
    @track premiumButtonIcon;
    @track isPremiumSectionexpanded;

    @track creditLimitIcon;
    @track creditLimitExpanded;
    @track creditLimit;

    @track decAndPremIcon;
    @track decAndPremExpanded;
    @track decAndPrem;

    @track lossMinimisationIcon;
    @track lossMinimisationExpanded;
    @track lossMinimisationContent;

    @track exclusionsIcon;
    @track exclusionsExpanded;
    @track exclusionsContent;

    @track claimAndRecIcon;
    @track claimAndRecExpanded;
    @track claimAndRecContent;

    @track genConditionIcon;
    @track genConditionExpanded;
    @track genConditionContent;

    @track miscellaneousIcon;
    @track miscellaneousExpanded;
    @track miscellaneousContent;

    @track confidentialityIcon;
    @track confidentialityExpanded;
    @track confidentialityContent;

    @track defnitionsIcon;
    @track defnitionsExpanded;
    @track defnitionsContent;

    @track isLoading=true;
    @track isProductOMBP=false;
    @track isProductSBP=false;
    @track isProductSUP=false;
    @track user_id = current_user;
    @track domainBaseURL;
    connectedCallback(){
        this.isLoading=true;
        this.counter = 0;
        console.log('connectedCallback ');
        //this.productTitle = ''+this.productTitle;
        console.log('productTitle :'+this.productTitle+' policyProductName : '+this.policyProductName+' isCover : '+this.isCover+' isContracts : '+this.isContracts+' isPremium :'+this.isPremium);
        
        this.coverButtonIcon="utility:up";
        this.isCoverSectionexpanded = false;

        this.contractsButtonIcon="utility:up";
        this.isContractsSectionexpanded = false;

        this.premiumButtonIcon="utility:up";
        this.isPremiumSectionexpanded = false;

        this.creditLimitIcon="utility:up";
        this.creditLimitExpanded = false;

        this.decAndPremIcon="utility:up";
        this.decAndPremExpanded = false;

        this.lossMinimisationIcon="utility:up";
        this.lossMinimisationExpanded = false;

        this.exclusionsIcon="utility:up";
        this.exclusionsExpanded = false;

        this.claimAndRecIcon="utility:up";
        this.claimAndRecExpanded = false;

        this.genConditionIcon="utility:up";
        this.genConditionExpanded = false;

        this.decAndPremIcon="utility:up";
        this.decAndPremExpanded = false;

        this.miscellaneousIcon="utility:up";
        this.miscellaneousExpanded = false;

        this.confidentialityIcon="utility:up";
        this.confidentialityExpanded = false;

        this.defnitionsIcon="utility:up";
        this.defnitionsExpanded = false;
        //this.loadAllTheTermsAndConditions();

        if(this.policyProductName === 'OMBP'){
            this.isProductOMBP = true;
        }else if(this.policyProductName === 'SBP'){
            this.isProductSBP = true;
        }else if(this.policyProductName === 'SUP'){
            this.isProductSUP = true;
        }
        //this.user_id = '00555000008dm6EAAQ';
        this.getPublishedContent();
        this.getDomainBaseURLJS();
    }
    getDomainBaseURLJS(){
        getDomainBaseURL({}).then(data => {
            console.log('getDomainBaseURL success :'+JSON.stringify(data));
            this.domainBaseURL = data;

        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
     /* my custom function, will use it later */
     /*get jsonData() { 
         this.isLoading = true;
         this.counter = this.counter +1;
         console.log('Counter : '+this.counter+' ');
         console.log('results : '+JSON.stringify(this.results));
         for(let t in this.results.data){
             console.log('counter--'+this.counter+' t--->'+t)
            //console.log('items title :'+t+': '+this.results.data[t].title);
            //console.log('items  body::'+t+': '+this.results.data[t].contentNodes.body.value);
            
            if(this.results.data[t].title === this.policyProductName+' Policy Term Header'){
                this.policyTermHeaderContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                //this.policyTermHeaderContent = '     &nbsp;Policy No :'+this.policyNumber+'\n'+this.policyTermHeaderContent;
            }else if(this.results.data[t].title === this.policyProductName+' Cover'){
                console.log('cover : '+this.results.data[t].contentNodes.body.value);
                this.cover = this.results.data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'" );
            }else if(this.results.data[t].title === this.policyProductName+' Contracts Covered And Related Conditions'){
                                                                             
                this.contractsCoveredAndRelatedConditions = this.results.data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Credit Limit'){
                this.creditLimit = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Declarations And Premium'){
                this.decAndPrem = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Loss Minimisation'){
                this.lossMinimisationContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Exclusions'){
                this.exclusionsContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Claims And Recoveries'){
                this.claimAndRecContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' General Conditions'){
                this.genConditionContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Miscellaneous'){
                this.miscellaneousContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Confidentiality'){
                this.confidentialityContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Definitions'){
                this.defnitionsContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }
            else if(this.results.data[t].title === this.policyProductName+' Premium'){
                this.premium = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
            }else if(this.results.data[t].title === this.policyProductName+' Policy Schedule 1 Remarks'){
                this.policySchedule1Remarks = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;'," \" ");
            }
         }
         console.log(Date.now()+'Before isLoading : '+this.isLoading);
         this.isLoading = !this.isLoading;
         console.log('After '+this.isLoading);
         return this.results;
    }*/

    getPublishedContent(){
        console.log('getPublishedContent called.'+this.policyProductName+' user_id::'+this.user_id);
        getPublishedContentIds({
            user_id : this.user_id
        }).then(data => {
            console.log('getPublishedContent success :'+JSON.stringify(data));
            try {

                this.counter = this.counter +1;
                console.log('Counter : '+this.counter);
                for(let t in data){
                    console.log('counter--'+this.counter+' t--->'+t);
                    //console.log('title--'+data[t].title+' t--->'+data[t].contentNodes.body.value);
                    
                    if(data[t].title.toUpperCase() === this.policyProductName+' POLICY TERM HEADER'.toUpperCase()){
                        
                        this.policyTermHeaderContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.policyTermHeaderContent);
                    }else if(data[t].title.toUpperCase() === this.policyProductName+' THE COVER'.toUpperCase()){
                        
                        this.cover = data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'" );
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.cover);
                    }else if(data[t].title.toUpperCase() === this.policyProductName+' CONTRACTS COVERED AND RELATED CONDITIONS'.toUpperCase()){
                        this.contractsCoveredAndRelatedConditions = data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.contractsCoveredAndRelatedConditions);
                    }else if(data[t].title.toUpperCase() === this.policyProductName+' CREDIT LIMIT'.toUpperCase()){
                        this.creditLimit = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.creditLimit);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' DECLARATIONS AND PREMIUM'.toUpperCase()){
                        this.decAndPrem = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.decAndPrem);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' LOSS MINIMISATION'.toUpperCase()){
                        this.lossMinimisationContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.lossMinimisationContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' EXCLUSIONS'.toUpperCase()){
                        this.exclusionsContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.exclusionsContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' CLAIMS AND RECOVERIES'.toUpperCase()){
                        this.claimAndRecContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.claimAndRecContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' GENERAL CONDITIONS'.toUpperCase()){
                        this.genConditionContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.genConditionContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' MISCELLANEOUS'.toUpperCase()){
                        this.miscellaneousContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.miscellaneousContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' CONFIDENTIALITY'.toUpperCase()){
                        this.confidentialityContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.confidentialityContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' DEFINITIONS'.toUpperCase()){
                        this.defnitionsContent = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.defnitionsContent);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' PREMIUM'.toUpperCase()){
                        this.premium = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;',"'");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.premium);

                    }else if(data[t].title.toUpperCase() === this.policyProductName+' POLICY SCHEULE 1 REMARKS'.toUpperCase()){
                        this.policySchedule1Remarks = data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ").replaceAll('&quot;'," \" ");
                        console.log('Caps --'+data[t].title.toUpperCase()+'--'+this.policySchedule1Remarks);

                    }
                }
             } catch (error) {
               console.log('Error 1 : '+error.toString()+' '+JSON.stringify(error.toString()));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while Loading Terms & Conditions',
                        message: error.toString()+' '+JSON.stringify(error.toString()),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.log('Error 2 : '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while Loading Terms & Conditions',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }

    expandHandler(event) {
        console.log('expandHandler : '+event.currentTarget.id);
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
           
        }else if (id === "sectionDecAndPrem") {
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
        console.log('expandCover event : '+event+' isCoverSectionexpanded : '+this.isCoverSectionexpanded);
        if(!this.isCoverSectionexpanded){
            this.isCoverSectionexpanded = true;
            this.coverButtonIcon = 'utility:down';
        }else{
            this.isCoverSectionexpanded = false;
            this.coverButtonIcon = 'utility:up';
        }
    }
    expandContracts(event) {
        console.log("expandContracts event : "+event+' isContractsSectionexpanded : '+this.isContractsSectionexpanded);
        if(!this.isContractsSectionexpanded){
            this.isContractsSectionexpanded = true;
            this.contractsButtonIcon = 'utility:down';
        }else{
            this.isContractsSectionexpanded = false;
            this.contractsButtonIcon = 'utility:up';
        }
    }
    expandPremium(event) {
        console.log("expandPremium event : "+event+' isPremiumSectionexpanded : '+this.isPremiumSectionexpanded);
        if(!this.isPremiumSectionexpanded){
            this.isPremiumSectionexpanded = true;
            this.premiumButtonIcon = 'utility:down';
        }else{
            this.isPremiumSectionexpanded = false;
            this.premiumButtonIcon = 'utility:up';
        }
       
    }
    downloadPdf(event) {
        console.log("downloadPdf Current Policy ID" + this.currentPolicyID);
       
        const vfPageURL='https://'+this.domainBaseURL+'/ECReach/apex/PolicyCMSDocument?policyTermHeaderContent='+this.policyTermHeaderContent;

        
        
        console.log('vfPageURL...'+vfPageURL);
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
            url: vfPageURL
        }
        }, false); //if you set true this will opens the new url in same window

    }
    
}
import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import current_user from '@salesforce/user/Id';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL'
import getWrapperPolicyHolderData from '@salesforce/apex/PolicyManagement.getWrapperPolicyHolderData';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';

export default class PolicyDocument extends NavigationMixin(LightningElement)  {
    @track accountID;
    @track companyName;
    @track currentPolicy;
    @track policyNumber;
    @track isCoverSectionexpanded;
    @track coverButtonIcon; 
    @track contractsButtonIcon;
    @track isContractsSectionexpanded;
    @track premiumButtonIcon;
    @track isPremiumSectionexpanded;
    @track userId = current_user;
    @track currentPolicyID;
    @track currentPolicyName;
    //community_Id = community_Id;
    /*@track isCover;
    @track isContracts;
    @track isPremium;*/
    @track isLoadCMS=false;

    @track error;
    @track logged_in_user;
    @track domainBaseURL;
    @track isPolicyDocumentSigned;
    @track policyDocLink;

     @wire(getRecord, {
         recordId: current_user,
         fields: [USERNAME_FIELD]
     }) wireuser({
         error,
         data
     }) {
         if (error) {
            this.error = error ; 
            //this.name='alice.zzzz@ignatica.io';
         } else if (data) {
             console.log('data.fields : '+JSON.stringify(data.fields));
             this.logged_in_user = data.fields.Username.value;
         }
     }

    connectedCallback(){
        //console.log('userId : '+userId+' community_Id :'+community_Id);
        //this.userId = '00555000008dm6EAAQ';
        console.log('userId :: '+this.userId);
        
        //this.companyName = 'ABC Company';
        //this.currentPolicy = 'OMBP';
        //this.policyNumber = '2323344556';
        this.coverButtonIcon="utility:up";
        this.isCoverSectionexpanded = false;

        this.contractsButtonIcon="utility:up";
        this.isContractsSectionexpanded = false;

        this.premiumButtonIcon="utility:up";
        this.isPremiumSectionexpanded = false;
        this.getPolicyHolderData();
        this.getDomainBaseURLJS();
        this.getModifiedPolicyHolderData();
        this.getModifiedAllSchedule();
    }
    getPolicyHolderData(){
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :'+JSON.stringify(data));
            try {
                this.companyName = data.Name;
                this.currentPolicyID = data.Current_Policy__c;
                this.currentPolicy = data.Current_Policy__r.Product__r.Name;
                this.policyNumber = data.Current_Policy__r.Name;
                this.currentPolicyName = data.Current_Policy__r.Product__r.Full_Name__c;
                this.isLoadCMS = true;
                this.policyDocLink = data.Cover_PDF_Link;
             } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getDomainBaseURLJS(){
        getDomainBaseURL({}).then(data => {
            console.log('getDomainBaseURL success :'+JSON.stringify(data));
            this.domainBaseURL = data;

        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    expandHandler(event) {
        console.log('expandHandler : '+event.currentTarget.id);
        let id = event.currentTarget.id + "";
        id = id.split("-")[0];
        if (id === "sectionCover") {
            this.isCoverSectionexpanded = !this.isCoverSectionexpanded;
            this.coverButtonIcon = this.isCoverSectionexpanded ? "utility:up" : "utility:down";
            /*if(this.isCoverSectionexpanded){
                this.isCover = true;
                this.isContracts = false;
                this.isPremium = false;
            }*/
        } else if (id === "sectionContractsAndRelatedConditions") {
            this.isContractsSectionexpanded = !this.isContractsSectionexpanded;
            this.contractsButtonIcon = this.isContractsSectionexpanded ? "utility:up" : "utility:down";
            /*if(this.isContractsSectionexpanded){
                this.isCover = false;
                this.isContracts = true;
                this.isPremium = false;
            }*/
        } else if (id === "sectionPremium") {
            this.isPremiumSectionexpanded = !this.isPremiumSectionexpanded;
            this.premiumButtonIcon = this.isPremiumSectionexpanded ? "utility:up" : "utility:down";
            /*if(this.isPremiumSectionexpanded){
                this.isCover = false;
                this.isContracts = false;
                this.isPremium = true;
            }*/
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
    
    downloadPdf(event){
        console.log('downloadPdf called isPolicyDocumentSigned :=>'+this.isPolicyDocumentSigned+' policyDocLink==>>>'+this.policyDocLink);
        if(this.isPolicyDocumentSigned){
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                    attributes: {
                    url: this.policyDocLink
                }
                }, false); //if you set true this will opens the new url in same window
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Policy Document not available yet.',
                    message: 'Policy Docuemtn not signed yet.',
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        }
        
    }

    downloadPdfOld(event) {
        console.log("downloadPdf Current Policy ID" + this.currentPolicyID);
        const vfPageURL='https://'+this.domainBaseURL+'/ECReach/apex/PolicyCMSDocument?policyID='+this.currentPolicyID;
        console.log('vfPageURL...'+vfPageURL);
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
            url: vfPageURL
        }
        }, false); //if you set true this will opens the new url in same window

    }
    getModifiedPolicyHolderData(){
        console.log('getWrapperPolicyHolderData called.');
        getWrapperPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperPolicyHolderData success :'+JSON.stringify(data));
            try {
                // this.companyName = data.Name;
                // this.currentPolicyID = data.Current_Policy__c;
                // this.currentPolicy = data.Current_Policy__r.Product__r.Name;
                // this.policyNumber = data.Current_Policy__r.Name;
                // this.currentPolicyName = data.Current_Policy__r.Product__r.Full_Name__c;
                // this.isLoadCMS = true;
                this.policyDocLink = data.Document_Link;
            } catch (error) {
               console.error(error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString()+' '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
        }).catch(error => {
            console.error(error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data.',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }

    getModifiedAllSchedule(){
        console.log('getAllSchedule called.');
        getWrapperAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperAllSchedule success :'+JSON.stringify(data));
            try {
                this.allSchedule = data;
                for(let sch in data){
                    
                    if(data[sch].scheduleType === 'Policy Document'){
                        console.log('Schedule 1*********************x');
                        this.isPolicyDocumentSigned = data[sch].isScheduleSigned;
                    }
                }
                console.log('this.issueDate :'+this.isPolicyDocumentSigned+' this.effectiveDate:'+this.effectiveDate);
            } catch (error) {
               console.error(error.toString+'=='+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Policy Schedule',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Schedule',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
}
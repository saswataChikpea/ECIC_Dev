import { LightningElement,api, track, wire } from 'lwc';
import initMethod from '@salesforce/apex/FetchCmsContent.initMethod';
 
export default class CmsContentTermAndConditionCover extends LightningElement {
    @wire(initMethod ) results;
    
    @track counter;
    @track policyTermHeaderContent;
    @track cover;
    @track contractsCoveredAndRelatedConditions;
    @track premium;
    @track policySchedule1Remarks;
    @api policyProductName;
    @api isPolicyTermHeader;
    @api isCover;
    @api isContracts;
    @api isPremium;
    @api isPolSch1Remarks;
    connectedCallback(){
        this.counter = 0;
        console.log('connectedCallback ');
        console.log('policyProductName : '+this.policyProductName+' isCover : '+this.isCover+' isContracts : '+this.isContracts+' isPremium :'+this.isPremium);
    }
     /* my custom function, will use it later */
     get jsonData() { 
         this.counter = this.counter +1;
         console.log('this.counter : '+this.counter);
         console.log('results : '+JSON.stringify(this.results));
         console.log('results ***: '+this.results);
         for(let t in this.results.data){
            //console.log('items title :'+t+': '+this.results.data[t].title);
            //console.log('items  body::'+t+': '+this.results.data[t].contentNodes.body.value);
            
            if(this.results.data[t].title === this.policyProductName+' Cover'){
                console.log('cover : '+this.results.data[t].contentNodes.body.value);
                this.cover = this.results.data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ");
            }else if(this.results.data[t].title === this.policyProductName+' Contracts covered and related conditions'){
                this.contractsCoveredAndRelatedConditions = this.results.data[t].contentNodes.body.value.replaceAll('&gt;',">").replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ");
            }else if(this.results.data[t].title === this.policyProductName+' Premium'){
                this.premium = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ");
            }else if(this.results.data[t].title === this.policyProductName+' Policy Term Header'){
                this.policyTermHeaderContent = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ");
            }else if(this.results.data[t].title === this.policyProductName+' Policy Schedule 1 Remarks'){
                this.policySchedule1Remarks = this.results.data[t].contentNodes.body.value.replaceAll('&gt;','>').replaceAll('&lt;',"<").replaceAll('&amp;nbsp;'," ");
            }
         }
         console.log(Date.now()+' cover : '+this.cover+' contracts :'+this.contractsCoveredAndRelatedConditions+' pre : '+this.premium);
        return this.results;
    }
}
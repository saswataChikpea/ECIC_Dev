import { LightningElement ,  track , wire, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import current_user from '@salesforce/user/Id';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';


import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
export default class PolicyScheduleFour extends NavigationMixin(LightningElement) {

    @track userId = current_user;
    @track pageTitle;
    @api isSbp;
    @api isSup;
    @api productName;
    @api mapDataPassToSchedule;
    @api policyCommDate;//this is the effective date
    @track isLoading = true;
    @track issueDate;
    @track policyNumber;
    @track effectiveDate;
    connectedCallback(){
        //this.isLoading = true;

        //this.userId = '0051100000BarVxAAJ';
        console.log('mapDataPassToSchedule  : '+JSON.stringify(this.mapDataPassToSchedule));

        console.log('isSbp : '+this.isSbp+' isSup : '+this.isSup+' productName: '+this.productName+' policyCommDate:'+this.policyCommDate);
        if(this.isSup){
            this.pageTitle = this.productName + '- SCHEDULE IV';
        }
        /*for(let sch in this.mapDataPassToSchedule){
            console.log('key :'+this.mapDataPassToSchedule[sch].key+' value :'+this.mapDataPassToSchedule[sch].value);
        
            if(this.mapDataPassToSchedule[sch].key  === 'policyNumber'){
                this.policyNumber = this.mapDataPassToSchedule[sch].value;
            }
            if(this.mapDataPassToSchedule[sch].key  === 'issueDate'){
                this.issueDate = this.mapDataPassToSchedule[sch].value;
            }
            if(this.mapDataPassToSchedule[sch].key  === 'effectiveDate'){
                this.effectiveDate = this.mapDataPassToSchedule[sch].value;
            }
        }*/
        this.getAllSchedule();
        this.isLoading = false;
    }
    getAllSchedule(){
        console.log('getAllSchedule called.');
        getWrapperAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperAllSchedule success :'+JSON.stringify(data));
            try {
                for(let sch in data){
                    this.policyNumber=data[sch].policyNumber;
                    
                    if(data[sch].scheduleType === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                       
                    }else if(data[sch].scheduleType === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                        
                    }else if(data[sch].scheduleType === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                        
                    }else if(data[sch].scheduleType === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                        this.issueDate = data[sch].scheduleIssueDate;
                        this.effectiveDate = data[sch].scheduleEffectiveDate;
                    }
                }
                console.log('this.issueDate :'+this.issueDate+' this.effectiveDate:'+this.effectiveDate);
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
import { LightningElement ,  track , wire, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import current_user from '@salesforce/user/Id';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';



import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
export default class PolicyScheduleTwo extends NavigationMixin(LightningElement) {

    @track userId = current_user;
    @track pageTitle;
    @api isSbp;
    @api isSup;
    @api isOmbp;
    @api productName;
    @api policyCommDate;//this is the effective date
    @api mapDataPassToSchedule;
    @track isLoading = true;
    @track countryList=[];
    @track leftCountryList=[];
    @track rightCountryList=[];
    @track rebate_rate = 5;
    @track policyNumber;
    @track issueDate;
    @track effectiveDate;
    connectedCallback(){
        console.log('userId :: '+this.userId);

        console.log('isSbp : '+this.isSbp+' isSup : '+this.isSup+' productName: '+this.productName);
        console.log('mapDataPassToSchedule  : '+JSON.stringify(this.mapDataPassToSchedule));

        if(this.isSbp){
            this.pageTitle = this.productName + '- SCHEDULE III';
        }else if(this.isSup){
            this.pageTitle = this.productName + '- SCHEDULE III';
        }
        
        this.countryList = [
            { "COUNTRY_MARKET": "Aland Islands","CODE": "ALA","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Algeria","CODE": "DZA","GROUP": "C","SPECIAL_CONDITIONS": '1 (9 months), 2'},
            { "COUNTRY_MARKET": "American Samoa","CODE": "ASM","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Andorra","CODE": "AND","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Angola","CODE": "AGO","GROUP": "C","SPECIAL_CONDITIONS": '2'}
          ];
        this.handleCountryList();
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
    handleCountryList(){
        try {
            console.log('Size of the country list : '+this.countryList.length);
            if(this.countryList.length>0 && this.countryList.length>1){
                var name='COUNTRY_MARKET';
                var fullLength=this.countryList.length;
                console.log('fullLength : '+fullLength);
                var remainder = fullLength%2;
                console.log('remainder : '+remainder);

                var quotient = (fullLength-remainder)/2;
                console.log('quotient : '+quotient);
                for(let cnList in this.countryList){
                    console.log('cnList :'+cnList);
                    if(cnList < quotient){
                        //console.log('left list :'+countryList[cnList]);
                        this.leftCountryList.push(this.countryList[cnList]);
                    }else{
                        //console.log('right list :'+countryList[cnList]);
                        this.rightCountryList.push(this.countryList[cnList]);
                    }
                }
            }
            console.log('leftCountryList : '+JSON.stringify(this.leftCountryList));
            console.log('rightCountryList : '+JSON.stringify(this.rightCountryList));
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred While Fetching Country List',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'warning'
                })
            );
        }
        
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
                        this.issueDate = data[sch].scheduleIssueDate;
                        this.effectiveDate = data[sch].scheduleEffectiveDate;
                    }else if(data[sch].scheduleType === 'Schedule 4'){
                        console.log('Schedule 4*********************');
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
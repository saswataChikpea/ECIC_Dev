import { LightningElement, wire } from 'lwc'
import UsrId from '@salesforce/user/Id'
import getVerificationStatus from '@salesforce/apex/OnboardingCreateSiteUser.getVerificationStatus'

export default class PublicHome extends LightningElement {
    usrId = UsrId
    connectedCallback() {
        this.callverificationStatus()
    }
    callverificationStatus() {
        getVerificationStatus({ usrId: this.usrId }).then(data => {
            let pageToShow = ""
            console.log("onboarding container verificationStatusCallback data= " + JSON.stringify(data, null, '\t'))
            console.log("PublicHome verificationStatusCallback data= " + JSON.stringify(data, null, '\t'))
            //this.accountId = data.Id
            if (!data.EMAIL__c) {
                console.log('navOnboarding1')
                this.navOnboarding()
            }
        }).catch(error => {
            // console.error("Unable to read proposal data" + JSON.stringify(error, null, '\t'))
            // console.error('Error: 04 Unable to load data : ' + error);
            // console.error('Error: 04 Unable to load data : ' + JSON.stringify(error));
            // this.error = 'Error: 04 Unable to load data'
            // if (error.body) {
            //     if (Array.isArray(error.body)) {
            //         this.exceptionDetail = error.body.map(e => e.message).join(', ')
            //     } else if (typeof error.body.message === 'string') {
            //         this.exceptionDetail = error.body.message
            //     }
            // } else {
            //     this.exceptionDetail = error
            // }
            if (this.usrId) {
                console.log('navOnboarding2')
                this.navOnboarding()
            }
        })

    }
    navDashboard() {
        console.log('navDashboard')
        if (this.usrId) {
            console.log('redirecting to dashboard')
            window.location.href = './dashboard'
        } else {
            window.location.href = './login'
        }
    }
    navOnboarding() {
        console.log('navOnboarding')
        console.log('redirecting to onboarding')
        window.location.href = './onboarding'
    }
}
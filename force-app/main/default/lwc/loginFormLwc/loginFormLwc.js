import { LightningElement, track } from 'lwc';
import doLogin from '@salesforce/apex/LightningLoginFormController.login'
import { NavigationMixin } from 'lightning/navigation';
export default class LoginFormLwc extends NavigationMixin(LightningElement) {
    username;
    password;
    @track errorCheck;
    @track errorMessage;
    @track testUrl

    connectedCallback() {

        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0");
        document.getElementsByTagName('head')[0].appendChild(meta);
    }

    handleUserNameChange(event) {
        this.username = event.target.value;
        console.log('handleUserNameChange: username', this.username);
        const emailRegx = /@\w+.\w+/
        if (!this.username.match(emailRegx))
            this.username = this.username + '@ec-reach.com.hk';

        console.log('handleLogin username: ', this.username);
    }

    handlePasswordChange(event) {

        this.password = event.target.value;
    }

    handleLogin(event) {

        if (this.username && this.password) {

            event.preventDefault();
            //var test = '/ECReach/secur/frontdoor.jsp?allp=1&apv=1&cshc=D000004ZoHjD000000DlLT&refURL=https%3A%2F%2Fecicuat2-ecreach.cs72.force.com%2FECReach%2Fsecur%2Ffrontdoor.jsp&retURL=%2FECReach%2Fapex%2FCommunitiesLanding&sid=00D5D000000DlLT%21AQ8AQOBWxppbIeflF0OHpuB2f8wu4atnI.xVekIt1zfr7BJO6AW1noHS_LP.rwMK1CnKfIZV4h9HWUL8SoafIGkwPOuJPWNp&untethered='
            doLogin({ username: this.username, password: this.password })
                .then((result) => {
                    console.log('login success' + result);
                    console.log('' + result);
                    //this.navigateToWebPage(result)
                    //window.location.href = result;
                })
                .catch((error) => {
                    console.log('error', error);
                    this.error = error;
                    this.errorCheck = true;
                    this.errorMessage = error.body.message;
                });

        }

    }
    navigateToWebPage(result) {
        // Navigate to a URL
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__webPage',
        //     attributes: {
        //         url: result
        //     }
        // },
        //     true // Replaces the current page in your browser history with the URL
        // );
        const result1 = result.substring(result.indexOf('/secur/'), result.length)
        this.testUrl = result1
        console.log('navigateToWebPage=' + result1)
        this.pageReference = {
            type: 'standard__webPage',
            attributes: {
                url: result1
            }
        }
        //this[NavigationMixin.Navigate](this.pageReference)
    }
}
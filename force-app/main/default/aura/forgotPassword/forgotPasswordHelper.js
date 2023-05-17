({
    qsToEventMap: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleForgotPassword: function (component, event, helpler) {
        console.log('handleForgotPassword..');
        var username = component.find("username").get("v.value");
        if(!username.match('@\w+.\w+'))
            username = username + '@ec-reach.com.hk';
            
        var checkEmailUrl = component.get("v.checkEmailUrl");
        var action = component.get("c.forgotPassword");
        action.setParams({username:username, checkEmailUrl:checkEmailUrl});
        action.setCallback(this, function(a) {
            var rtnValue = a.getReturnValue();
            if (rtnValue != null) {
               component.set("v.errorMessage",rtnValue);
               component.set("v.showError",true);
            }
       });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helpler) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})
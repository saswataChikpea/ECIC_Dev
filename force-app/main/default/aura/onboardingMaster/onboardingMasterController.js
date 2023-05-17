({
	doInit : function(component, event, helper) {
		var pageReference = component.get("v.pageReference")
		console.log('in master aura='+JSON.stringify(pageReference))
		var plan_id = pageReference.state.c__plan_id
		if(plan_id){
			component.set("v.planId", plan_id)
		}else{
			plan_id = pageReference.attributes.detail.recordId
		}
		component.set("v.recordId", plan_id)
		console.log('#1 in master plan_id='+plan_id)
	}
})
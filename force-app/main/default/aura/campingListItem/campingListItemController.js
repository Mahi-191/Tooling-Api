({
	packItem : function(component, event, helper) {
		let val = component.get("v.item.Packed__c")
        let btn = event.getSource();
        if(!val){
            component.set("v.item.Packed__c",true);
        }
        else{
            component.set("v.disabled",true);
        }
	}
})
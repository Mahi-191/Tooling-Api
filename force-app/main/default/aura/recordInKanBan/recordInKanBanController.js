({
    init : function(component, event, helper) {
        var result = component.get("v.record")[component.get("v.field")];
        component.set("v.result",result);            
    }
})
({
    init: function(component, event, helper) {
        helper.getObjects(component, event, helper);
     },

     fieldsget : function(component, event, helper) {
        helper.getFields(component,event, helper);
    },
    displayrecord : function(component, event, helper){
        helper.getRecords(component,event,helper);
    },
    // on reset button clear selected values 
    reset: function(component, event){
        component.set("v.selectedValue",null);
        var cmpEvent = component.getEvent("PassObjAndFields");
        cmpEvent.setParams({"obj":null, "fields" :null});
        cmpEvent.fire();
    },
    disableProcess: function(component, event){
        if(component.get("v.selectedList").length>0){
            component.set("v.isFieldSelected",true);
        }
        else{
            component.set("v.isFieldSelected",false);
        }
    }
    
})
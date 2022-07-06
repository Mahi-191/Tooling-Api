({
    // call apex method and get objects(api_name and label) and set in aura option attribute
    getObjects : function(component, event, helper) {
        component.set("v.spinner", true);
        var action = component.get("c.fetchObjects");
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {      
            var allValues = response.getReturnValue();
            var lst = [];
            //set values according to comboBox
            for(var key in allValues){
                lst.push({label:allValues[key], value:key}); 
            }
            
            var byName = lst.slice(0); 
            byName.sort(function(a,b) {
                var x = a.label.toLowerCase();
                var y = b.label.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            component.set("v.options", byName);
            component.set("v.spinner", false);
            }
            else{
                console.log("response not recived from apex");
            }
        });
        $A.enqueueAction(action);        
    },

    //on object select call apex method and get fields of selected records and set in aura fieldlist Attribute
    getFields : function(component, event, helper) {
        component.set("v.spinner", true);
        component.set("v.isFieldSelected",false);
        component.set("v.selectedList", null); //clear selected fields list 
        var cmpEvent = component.getEvent("PassObjAndFields");
        cmpEvent.setParams({"obj":null, "fields" :null});
        cmpEvent.fire();
        var action = component.get("c.fetchFields");
        action.setParams({ sobj : component.get("v.selectedValue")});
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {      
                var allValues = response.getReturnValue();
                var lst = [];
                //set values according to duleListBox
                for(var key in allValues){
                    lst.push({label: allValues[key], value : key}); 
                }

                var byName = lst.slice(0);
                byName.sort(function(a,b) {
                    var x = a.label.toLowerCase();
                    var y = b.label.toLowerCase();
                    return x < y ? -1 : x > y ? 1 : 0;
                });
                component.set("v.fieldList", byName);
                component.set("v.spinner", false);
            }
            else{
                console.log("response not recived from apex");
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    // when process button clicked fire event and send selected object and selected fields to parent component
    getRecords : function(component, event, helper){
        component.set("v.spinner", true);
        var cmpEvent = component.getEvent("PassObjAndFields");
        cmpEvent.setParams({"obj":component.get("v.selectedValue"), "fields" : component.get("v.selectedList")});
        cmpEvent.fire();
        component.set("v.spinner", false);
    }

})
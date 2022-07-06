({
    // call apex method and get objects(api_name and label) and set in aura option attribute
    getObjects : function(component, event, helper) {
        component.set("v.spinner", true);
        var action = component.get("c.fetchobjects");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {        
                var allValues = response.getReturnValue();
                var lst = [];
                //set values according to button menu item
                for(var key in allValues){
                    lst.push({label:allValues[key], value:key}); 
                }
                var byName = lst.slice(0);
                byName.sort(function(a,b) {
                    var x = a.label;
                    var y = b.label;
                    return x < y ? -1 : x > y ? 1 : 0;
                });
                component.set("v.objectList", byName);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);        
    },

    // call apex method and get picklist fields available on selected object 
    getpicklistFields : function(component, event){
        component.set("v.spinner", true);
        component.set("v.selectedObject",event.detail.menuItem.get("v.value"));
        component.set("v.selectedPicklist", null);
        component.set("v.showKanBan",false);
        var action = component.get("c.fetchpicklist");
        action.setParams({ sobj : component.get("v.selectedObject")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {        
                var picklist = response.getReturnValue();
                var lst = [];
                //set values according to duleListBox
                for(var key in picklist){
                    lst.push({label: picklist[key], value : key}); 
                }
                component.set("v.picklists", lst);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    //call apex method to get records in map key as selected picklist value and list of related records 
    getRecords : function(component, event){
        component.set("v.spinner", true);
        var action = component.get("c.getRecords");
        //giving parameters selected object, selected picklist Field, and fields to show on card
        action.setParams({sobj : component.get("v.selectedObject"), field :  component.get("v.selectedPicklist"), selectedFields: component.get("v.selectedList")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var values = response.getReturnValue();
                var mapKeys = [];
                for(var key in values){
                    mapKeys.push({key: key, value: values[key]});
                }
                component.set("v.recordsMap", mapKeys);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
       
    },
    
    //method to get all fields of selected object
    getFields : function(component, event, helper) {
        component.set("v.spinner", true);
        component.set("v.selectedPicklist",event.detail.menuItem.get("v.value"));
        component.set("v.showKanBan",false);
        var action = component.get("c.fetchFields");
        action.setParams({ sobj : component.get("v.selectedObject")});
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {       
                var allValues = response.getReturnValue();
                var lst = [];
                for(var key in allValues){
                    lst.push({label: allValues[key], value : key}); 
                }
                var byName = lst.slice(0);
                byName.sort(function(a,b) {
                    var x = a.label;
                    var y = b.label;
                    return x < y ? -1 : x > y ? 1 : 0;
                });
                component.set("v.fieldList", byName);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    }
    
})
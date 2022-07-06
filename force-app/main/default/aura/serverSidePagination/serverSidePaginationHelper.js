({
    //initial action get calumn data 
    getvalues : function(component, event) {
        component.set("v.spinner", true);
        component.set("v.initialLoad", true);
        component.set("v.obj", event.getParam("obj"));
        component.set("v.fields", event.getParam("fields"));
        var act = component.get("c.columnValue");
        act.setParams({obj:event.getParam("obj"),fields:event.getParam("fields")});
        act.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.mycolumns", response.getReturnValue());
                component.set("v.spinner", false);
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(act);
        this.comanEntryPoint(component,event);
    },
    // get records first time from database 
    comanEntryPoint: function(component, event){
        component.set("v.spinner", true);
        var totalpages;
        var action = component.get("c.fetchRecords");
        action.setParams({sobj : component.get("v.obj"), fields : component.get("v.fields"), pageSize : component.get("v.pageSize")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.records", response.getReturnValue());
                component.set('v.selectedRecords',component.get("v.temSelectList"));
                totalpages = Math.ceil(component.get("v.records.totalRecords")/component.get("v.pageSize"));
                if(totalpages!=0){
                    component.set("v.pageNumber",1);
                    component.set("v.hasRecords",true);
                    this.disableButton(component,totalpages);
                }
                else{
                    component.set("v.pageNumber",0);
                    component.set("v.hasRecords",false);
                    component.set("v.hasNext", true);
                }
                component.set("v.totalPages",totalpages);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    //sort records on data table 
    sort: function(component,event){
        component.set("v.spinner", true);
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set('v.sortedBy', fieldName);
        component.set('v.sortDirection', sortDirection);
        var data = component.get("v.records.records");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse));
        component.set('v.records.records', data);
        component.set("v.spinner", false);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
            reverse = !reverse ? 1 : -1;
            return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    //get records from database according to action performed on component 
    getRecords: function(component,event){
        component.set("v.spinner", true);
        component.set("v.hasPageChanged", true);
        var totalpages = Math.ceil(component.get("v.records.totalRecords")/component.get("v.pageSize"));
        component.set("v.totalPages",totalpages);
        var action = component.get("c.recordsNextTime");
        var btn = event.getSource().get("v.title");
        action.setParams({sobj : component.get("v.obj"), fields: component.get("v.fields"), pageSize : component.get("v.pageSize"), totalRec:component.get("v.records.totalRecords"), lstid: component.get("v.records.last"), fstid: component.get("v.records.first"), button: btn});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.records", response.getReturnValue());
                component.set('v.selectedRecords',component.get("v.temSelectList"));
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
        if(btn == "next"){
            component.set("v.pageNumber", component.get("v.pageNumber")+1);
            component.set("v.hasPrevious", true);
        }
        else if(btn == "previous"){
            component.set("v.pageNumber", component.get("v.pageNumber")-1);
        }
        else if(btn == "first"){
            component.set("v.pageNumber",1);
        }
        else{
            component.set("v.pageNumber",totalpages);
            component.set("v.hasNext", true);
        }
        this.disableButton(component,totalpages);
    },

    // to disable navigation buttons 
    disableButton: function(component, totalpages){
        if(component.get("v.pageNumber") == 1){
            component.set("v.hasPrevious", true);
            if(component.get("v.pageNumber") != totalpages){
                component.set("v.hasNext", false);
            }
            else{
                component.set("v.hasNext", true);
            }  
        }
        else if(component.get("v.pageNumber") == totalpages){
            component.set("v.hasNext", true);
            if(component.get("v.pageNumber") != 1)
                component.set("v.hasPrevious", false);
        }
        else{
            component.set("v.hasPrevious", false);
            component.set("v.hasNext", false);
        }
    },
    // to maintain state of chackbox
    checkboxState: function(component, event){
        if(!component.get("v.hasPageChanged") || component.get("v.initialLoad")){
            component.set("v.initialLoad", false);
            var selectedData = event.getParam('selectedRows');
            var AllSelectedlst = new Set(component.get("v.selectedRecords"));
            var selectedids = new Set();
            var nidsOnPage = new Set();
            var recordsOnPage = component.get("v.records.records");
            for(var i=0;i<selectedData.length;i++){
                selectedids.add(selectedData[i].Id);
                AllSelectedlst.add(selectedData[i].Id);
            }
            for (var rec of Object.values(recordsOnPage)) {
                if(!selectedids.has(rec.Id)){ 
                    nidsOnPage.add(rec.Id);
                }
            }
            for(var i  of nidsOnPage){
                if(AllSelectedlst.has(i)){
                    AllSelectedlst.delete(i);
                }
            }
            var temp = Array.from(AllSelectedlst);
            component.set('v.temSelectList',temp);
        }
        else{
            component.set("v.hasPageChanged", false);
        }
       
    }
})
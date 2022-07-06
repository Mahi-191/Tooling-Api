({  //initial method ---call helper methods that gets objects
    init: function(component, event, helper) {
        helper.getObjects(component, event, helper);
     },
     //call helper method to get picklist fields 
     getPicklists : function(component, event, helper){
         helper.getpicklistFields(component, event, helper);
     },

     getValues : function(component, event, helper){
         helper.getRecords(component,event);
         component.set("v.showKanBan",true);
         component.set("v.showModel",false);
     },
     
     fieldsget : function(component, event, helper) {
        helper.getFields(component,event, helper);
        component.set("v.showModel",true);
    },

    openModel: function(component,event,helper){
        component.set("v.showModel",true);
    },

    closeModel: function(component,event,helper){
        component.set("v.showModel",false);
    },

    /*------------------------------ Drag and Drop ----------*/
    
    allowdrop : function(component, event, helper) {
        event.preventDefault();
    },
    
    drag : function(component, event, helper) {
        event.dataTransfer.setData("text",event.target.id);
    },
    //on drop update record by calling apex method and apend child to div
    drop : function(component, event, helper) {
        component.set("v.spinner", true);
        var pickval = event.target.getAttribute('data-id');
        event.preventDefault();
        if(event.target.tagName != 'div' && event.target.tagName != 'DIV'){
            event.target = targetDiv.parentElement;
        }
        else{
        var data = event.dataTransfer.getData("text");
        var action = component.get("c.updaterecord");
        console.log("data id, record id "+ pickval + data);
        action.setParams({field : component.get("v.selectedPicklist"), recId : data, fieldVal: pickval });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
                console.log('result recived'+result);
                if(result){
                    var targetDiv = event.target;
                    targetDiv.appendChild(document.getElementById(data));
                    helper.getRecords(component,event);
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
        }
    }
})
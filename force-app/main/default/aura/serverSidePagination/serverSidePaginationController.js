({
    getattribute: function(component, event, helper) {
       helper.getvalues(component, event);
     },

    handleSort: function(component, event, helper) {
      helper.sort(component, event);
    },

    handleSelect: function(component, event, helper){
      helper.checkboxState(component,event);
    },

    sizeChange:function(component,event,helper){
      helper.comanEntryPoint(component,event);
    },

    handleNavigation: function(component, event, helper){
      helper.getRecords(component,event);
    }, 
})
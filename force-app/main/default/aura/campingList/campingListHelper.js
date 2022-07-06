({
	
    validateFields : function (component,field) {
        
        var nameField = field;
        console.log('yes:'+nameField);
        var expname = nameField.get("v.value"); 
        if ($A.util.isEmpty(expname)){
           component.set("v.er",true);
           nameField.set("v.errors", [{message:"this field can't be blank."}]);
        }
        else {
            nameField.set("v.errors", null);
        }
    },
    
    createItem : function (component,Item){         
        var action = component.get("c.saveItem");
        action.setParams({"item":Item});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var campings = component.get("v.items");
                campings.push(response.getReturnValue());
                component.set("v.items", campings);
            }
        });
       $A.enqueueAction(action);        
    }
})
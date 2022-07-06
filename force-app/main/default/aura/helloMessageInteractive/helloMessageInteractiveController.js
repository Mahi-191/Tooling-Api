({
	handleClick : function(component, event, helper) {
		let clickedBtn = event.getSource();
        let btnLabel = clickedBtn.get("v.label");
        component.set("v.message",btnLabel);
	},
    handleClick2 : function(component, event, helper){
        component.set("v.message",event.getSource().get("v.label"));
    }
})
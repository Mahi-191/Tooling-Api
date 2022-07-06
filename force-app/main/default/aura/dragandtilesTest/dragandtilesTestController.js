({
    allowdrop : function(component, event, helper) {
        event.preventDefault();
    },
    drag : function(component, event, helper) {
        console.log("hello");
        event.dataTransfer.setData("text",event.target.id);
    },
    drop : function(component, event, helper) {
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        var tar = event.target;
        // while(tar.tagName != 'div' && tar.tagName != 'DIV') {
        //     tar = tar.parentElement;
        // }
        tar.appendChild(document.getElementById(data));
    }
})
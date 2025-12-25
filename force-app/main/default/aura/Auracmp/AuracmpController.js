({
    toggle : function(component, event, helper) {
        var current = component.get("v.showMessage");
        component.set("v.showMessage", !current);
    }
})
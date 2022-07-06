trigger EmployeeSequence on Employee__c (before insert,before update, before delete, after undelete) {
	if(Employee_Setting__mdt.getInstance('Run_All_Triggers')?.Value__c == true){
        TriggerHandler handler = new EmployeeTriggerHandler();
        if(trigger.isbefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
        }
    }
}
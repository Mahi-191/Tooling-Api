public class EmployeeTriggerHandler implements TriggerHandler{
    public EmployeeTriggerHelper helper;
    public void beforeInsert(list<Employee__c> newList){
        helper.insertTask(newList);
    }
}
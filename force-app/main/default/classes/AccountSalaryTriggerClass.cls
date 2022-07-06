public class AccountSalaryTriggerClass {
    public static void updateGrossSalary(List<Account> accList){
        for(Account a : accList){
            if(a.Salary__c != null){
                a.Gross_Salary__C = a.Salary__c + (a.Salary__c * 0.10);
            }
        }
    }
}
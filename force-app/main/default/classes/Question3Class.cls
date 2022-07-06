public class Question3Class {
   public List<Merchandise__c> m {get;set;}
    public Question3Class(){
        m = [Select id, name,Job_Description__c, Price__c, Total_Inventory__c from Merchandise__c];
    }
}
public class Question10Class {
public List<Merchandise__c> merc;
    public List<Merchandise__c> getRecordList(){
        merc = [SELECT Name, Job_Description__c, price__c, Total_Inventory__c FROM Merchandise__c];
        Return merc;
    }
    
    
  //  public class WraperClass{
       // List<
        
  //  }
    
}
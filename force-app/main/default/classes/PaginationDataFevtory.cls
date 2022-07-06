@isTest
public class PaginationDataFevtory {
        public static List<Merchandise__c> createBulkRecords(Integer records) {
        List<Merchandise__c> lst = new List<Merchandise__c>();
        for(Integer i = 1 ; i <= records ; i++) {
            lst.add(new Merchandise__c(Name = 'Merchandise Test '+i));
        }
        insert lst;
        return lst;
    }
}
public class RemoteActionClass {
    public RemoteActionClass(ApexPages.StandardController controller) 
    {}
    public static boolean getData(String merchandiseName,String merchandiseDescription,Decimal merchandisePrice, Integer merchandiseinventory )
    {
        Merchandise__c myItem=new Merchandise__c(Name=merchandiseName, Job_Description__c=merchandiseDescription,Price__c=merchandisePrice, Total_Inventory__c=merchandiseinventory );
        insert myItem;
        return true;
    }
}
public class classtest {
    @AuraEnabled(cacheable = true)
    public static List<contact> getcontact(){
        List<contact> conList = [SELECT name, id FROM contact LIMIT 10];
        return conList;
    }
}
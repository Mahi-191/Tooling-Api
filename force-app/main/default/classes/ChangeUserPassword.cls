public with sharing class ChangeUserPassword {
   
    @AuraEnabled
    public static string changePassword(string jsonData){
        Map<String, String> data = (Map<String,String>) JSON.deserialize(jsonData, Map<String,String>.class);
        PageReference refrence =  Site.changePassword(data.get('newPassword'), data.get('cnfPassword'), data.get('oldPassword'));
        system.debug(refrence);
        return string.valueOf(refrence);
    }
}
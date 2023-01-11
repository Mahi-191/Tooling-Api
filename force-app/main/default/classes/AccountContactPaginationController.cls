/*-------------------------------------------------------------------------------
Apex Class Name     : AccountContactPaginationController
Created Date        : 22 July 2022
Description         : handel requirements of pagination Assignment
Author              : Mahendra Sharma
---------------------------------------------------------------------------------*/

public with sharing class AccountContactPaginationController {

    //Return Fields Api Name and Label Available in field set 
    @AuraEnabled
    public static Map<String,String> getFields(){
        List<FieldSetMember> fieldset = SObjectType.Account.FieldSets.Pagination.getFields();
        Map<String, String> fields = new map<String,String>();
        //List<Columns> fields = new List<Columns>();
        for(FieldSetMember fld : fieldset){
            fields.put(fld.getFieldPath(), fld.getLabel());
        }
        return fields;
    }

    // method to fetch Account Records 
    @AuraEnabled
    public static List<Account> getAccountRecords(){
        String query = 'SELECT ';
        for(String apiName : getFields().keySet()) {
            query += apiName + ', ';
        }
        query = query.removeEnd(', ');
        query += ' FROM Account';
        System.debug('the Query is   '+ query);
        return Database.query(query);
    }

    //method to fatch Contact of a perticular account
    @AuraEnabled
    public static List<Contact> getContactRecords(String actId){
        System.debug(actId);
        return null;
    }


}
@isTest
public with sharing class KanbanTest {
    @TestSetup
    static void makeData(){
       list<Account> actList = new List<Account>();
       for(integer i = 1; i <= 20; i++){
            if(i<=10){
                actList.add(new Account(name = 'test '+i, type = 'Prospect'));
            }
            else{
                actList.add(new Account(name = 'test '+i,type = 'Other'));
            }
       }
       Insert actList;
    }
    
    @isTest static void fetchobjectTest(){
        Map<String,String> objects = kanbanController.fetchObjects();
        System.assertEquals(true, objects.containsKey('Account'));
    } 

    @isTest static void fetchFieldsTest(){
        Map<string,string> fields = kanbanController.fetchFields('Account');
        System.assertEquals(true, fields.containsKey('Name'));
    }

    @isTest static void fetchPicklistTest(){
        Map<String,String> picklistFields = kanbanController.fetchpicklist('Account');
        System.assertEquals(true, picklistFields.containsKey('Type'));
    }

    @isTest static void getPickListValuesTest(){
        List<String> selectedFields = new  List<String>{'Name','Type','Id'};
        Map<String,List<SObject>> values = kanbanController.getPicklistValues('Account', 'Type', selectedFields);
        system.assertEquals(true, values.containsKey('Other'));
        System.assertEquals(10, values.get('Prospect').size());
    }

    @isTest static void getPickListValuesSecondTest(){
        List<String> selectedFields = new  List<String>{'Name','phone','Id'};
        Map<String,List<SObject>> values = kanbanController.getPicklistValues('Account', 'Type', selectedFields);
        system.assertEquals(true, values.containsKey('Other'));
        System.assertEquals(10, values.get('Prospect').size());
    }

    @isTest static void updateRecordTest(){
        list<sobject> records =[Select name, type, id From Account];
        string recId = records[0].id;
        Boolean Result = kanbanController.updaterecord('Type', recId, 'Installation Partner');
        List<Account> act = [select name, type from Account Where id =:recId];
        System.assertEquals('Installation Partner', act[0].type);
    }
}
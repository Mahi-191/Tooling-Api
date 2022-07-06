@isTest 
public class ServerSidePaginationTest {

    @TestSetup
    static void makeData(){
       list<Account> actList = new List<Account>();
       for(integer i = 1; i <= 25; i++){
           actList.add(new Account(name = 'test '+i));
       }
       Insert actList;
    }

    @isTest static void fetchobjectTest(){
        Map<String,String> objects = ServerSidePaginationController.fetchObjects();
        System.assertEquals(true, objects.containsKey('Account'));
    } 

    @isTest static void fetchFieldsTest(){
        Map<string,string> fields = ServerSidePaginationController.fetchFields('Account');
        System.assertEquals(true, fields.containsKey('Name'));
    }

    @isTest static void fetchRecordsFirstTest(){
        list<string> fields = new List<String>{'name','id'};
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.fetchRecords('Account', fields, 10);
        System.assertEquals(25, obj.totalRecords);
    }

    @isTest static void getCloumnTest(){
        list<string> fields = new List<String>{'name','id'};
        List<ServerSidePaginationController.ColumnAttributes> Attribute = ServerSidePaginationController.columnValue('Account', fields);
        System.assertEquals('Account Name', Attribute[0].label);
        System.assertEquals('Name', Attribute[0].fieldName);
    }

    @isTest static void recordsNextbuttonTest(){
        list<string> fields = new List<String>{'name','id'};
        List<Account> actList =[Select name, id From Account];
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.recordsNextTime('Account', fields, 10, 25, actList[9].id, actList[0].id, 'next');
        System.assertEquals(actList[10].id, obj.records[0].Id);
    }

    @isTest static void recordsPreviousbuttonTest(){
        list<string> fields = new List<String>{'name','id'};
        List<Account> actList =[Select name, id From Account];
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.recordsNextTime('Account', fields, 10, 25, actList[19].id, actList[10].id, 'previous');
        System.assertEquals(actList[0].id, obj.records[0].Id);
    }

    @isTest static void recordsFirstbuttonTest(){
        list<string> fields = new List<String>{'name','id'};
        List<Account> actList =[Select name, id From Account];
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.recordsNextTime('Account', fields, 10, 25, actList[19].id, actList[10].id, 'first');
        System.assertEquals(actList[0].id, obj.records[0].Id);
    }

    @isTest static void recordsLastbuttonTest(){
        list<string> fields = new List<String>{'name','id'};
        List<Account> actList =[Select name, id From Account];
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.recordsNextTime('Account', fields, 10, 25, actList[19].id, actList[10].id, 'last');
        System.assertEquals(actList[20].id, obj.records[0].Id);
        System.assertEquals(5,obj.records.size());
    }

    @isTest static void recordsLastbuttonTest2(){   //when records size = total size
        list<string> fields = new List<String>{'name','id'};
        List<Account> actList =[Select name, id From Account];
        ServerSidePaginationController.RecordWrapper obj = ServerSidePaginationController.recordsNextTime('Account', fields, 5, 25, actList[9].id, actList[0].id, 'last');
        System.assertEquals(actList[20].id, obj.records[0].Id);
        System.assertEquals(5,obj.records.size());
    }
    
}
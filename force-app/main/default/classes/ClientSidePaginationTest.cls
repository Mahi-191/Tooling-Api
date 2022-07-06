@isTest
public with sharing class ClientSidePaginationTest {
   
    @TestSetup
    static void makeData(){
       list<Account> actList = new List<Account>();
       for(integer i = 1; i <= 25; i++){
           actList.add(new Account(name = 'test '+i));
       }
       Insert actList;
    }

    @isTest static void totalRecordsTest(){
        Integer recordsCount = ClientSidePagination.totalRecords('Account');
        System.assertEquals(25,recordsCount);
    }

    @isTest static void columnValueTest(){
        List<string> fields = new List<string>{'Name','Id'};
        List<ClientSidePagination.ColunmWrapper> columns = ClientSidePagination.columnValue('Account', fields);
        System.assertEquals(columns[0].fieldLabel,'Account Name');
    }
     
    @isTest static void fetchDatatest(){
        List<string> fields = new List<string>{'Name','Id'};
        List<Sobject> objList = ClientSidePagination.fetchRecords('Account', fields);
        System.assertEquals(25, objList.size());
    }

}
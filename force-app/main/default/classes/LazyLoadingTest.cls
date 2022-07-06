@isTest public with sharing class LazyLoadingTest {

    //make Test Data 
    @TestSetup
    static void makeData(){
       list<Contact> conList = new List<Contact>();
       for(integer i = 1; i <= 41; i++){
           conList.add(new Contact(LastName = 'test '+i));
       }
       Insert conList;
    }
    //test all cases of lazy loading 
    @isTest public Static void showFieldDynamicallyTest(){
        string query = 'LastName,Id';
        LazyLoadingController.DynamicWrapper data = LazyLoadingController.showFieldDynamically('Contact', query, '0');
        System.assertEquals(41,data.totalRecords);
        LazyLoadingController.DynamicWrapper data2 = LazyLoadingController.showFieldDynamically('Contact', query, data.lastId);
        System.assertEquals(2,data2.fieldsMap.size());
        LazyLoadingController.DynamicWrapper data3 = LazyLoadingController.showFieldDynamically('Contact', query, data2.lastId);
        System.assertEquals(1,data3.recordList.size());
    }
}
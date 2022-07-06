@isTest
public class PaginationComponentControllerTestClass {
    @testSetup
    public static void testData(){
        List<Merchandise__c> mercRecords = PaginationDataFevtory.createBulkRecords(20);
    }

    @isTest static void firstActionTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'Account';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'Account Id','Account Name'};
        pcc.firstAction();
        test.startTest();
        List<SObject> testlist = [Select id,name From Account];
        test.stopTest();
        System.assertEquals('Select id,name From Account', pcc.query,'is query same as expected');
        System.assertEquals(testlist.size(), pcc.noOfRecords, 'number of records same or diffreent');
       
    }

    @isTest static void shortingTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'Account';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'Account Id','Account Name'};
        pcc.firstAction();
        pcc.sortField = 'name';
        pcc.sortQuery();
        System.assertEquals('Select id,name From Account ORDER BY name ASC NULLS LAST', pcc.finalQuery, 'both querys same or not');
        pcc.sortField = 'id';
        pcc.sortQuery();
        pcc.sortQuery();
        System.assertEquals( ' ASC',pcc.sortOrder);
    }
    @isTest static void refreshPageMethodTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'Merchandise__c';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'Record ID','Merchandise Name'};
        pcc.firstAction();
        pcc.refreshPage();
        System.assertEquals(true,pcc.noOfRecords>1); 
    }
    
    @isTest static void refreshPageExceptionTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'Merchandise__c';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'Record ID','Merchandise Name'};
        pcc.firstAction();
        pcc.finalQuery = 'Select name from case';
        pcc.refreshPage();
        System.assertEquals(true,pcc.noOfRecords>1); 
    }
    
    @istest static void charFilterTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'Merchandise__c';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'Record ID','Merchandise Name'};
        pcc.firstAction();
        pcc.refreshPage();
        pcc.filterchar = 'A';
        pcc.charFilter();
        System.assertNotEquals(pcc.query, pcc.finalQuery);
        pcc.filterchar = 'All';
        pcc.charFilter();
        System.assertEquals(pcc.query, pcc.finalQuery);
        pcc.filterchar = 'Other';
        pcc.charFilter();
        System.assertNotEquals(pcc.query, pcc.finalQuery);
    }
    @istest static void charFilterElsePartTest(){
        PaginationComponentController pcc = new PaginationComponentController();
        pcc.obj = 'case';
        pcc.fieldList = new string[]{'id','Status' };
        pcc.fieldLable = new string[]{'Case ID','Status'};
        pcc.firstAction();
        pcc.refreshPage();
        pcc.filterchar = 'A';
        pcc.charFilter();
		system.assertEquals('Select id,Status From case Where name Like \'A%\'', pcc.finalQuery);
    }
    
     
   @istest public static void nextButtonTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.next();
       System.assertEquals(2, pcc.pageNumber);
    }
    
    @istest public static void previousButtonTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.pagenumber = 3;
       pcc.customPageNumber();
       pcc.previous();
       System.assertEquals(2, pcc.pageNumber);
    }
    
    @istest public static void firstButtonTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.next();
       pcc.first();
       System.assertEquals(1, pcc.pageNumber);
    }
    
    @istest public static void lastButtonTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.last();
       System.assertEquals(4,pcc.pageNumber);
    }
    
    @isTest public static void customPageNumberTest(){
         PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.pagenumber = 98;
       pcc.customPageNumber();
       System.assertEquals(4, pcc.pagenumber);
       pcc.pagenumber = -2;
       pcc.customPageNumber();
       System.assertEquals(1, pcc.pagenumber);
    }
    
    @isTest public static void singleRecordDeleteTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.recordToDelete = pcc.wrapRecordList[0].wrapObject.id;
       pcc.deleteSingleRecord();
       System.assertEquals(19,pcc.noOfRecords);
       pcc.deleteSingleRecord();
    }
    
    @isTest public static void deleteSelectedRecordsTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       pcc.deleteSelectedRecords();
        for(integer i = 0; i<5;i++){
                pcc.wrapRecordList[i].checked = true;
        }
       pcc.deleteSelectedRecords();
       System.assertEquals(15,pcc.noOfRecords);     
    }
    
    @isTest public Static void deleteSelectedExceptionTest(){
         PaginationComponentController pcc = new PaginationComponentController();
      pcc.obj = 'user';
        pcc.fieldList = new string[]{'id','name' };
        pcc.fieldLable = new string[]{'user Id','user Name'};
        pcc.firstAction();	
      pcc.wrapRecordList[0].checked = true;
       pcc.deleteSelectedRecords();
       System.assertEquals(27,pcc.noOfRecords);     
    }
 
    
    @isTest public static void downloadCsvTest(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       for(integer i = 0; i<5;i++){
        	pcc.wrapRecordList[i].checked = true;
       }  
       pcc.downloadCSV();
    }
    
    @isTest public static void downloadCsvWithNullInField(){
       PaginationComponentController pcc = new PaginationComponentController();
       pcc.obj = 'Merchandise__c';
       pcc.fieldList = new string[]{'id','name','price__c'};
       pcc.fieldLable = new string[]{'Merchandise Id','Merchandise Name','Price'};
       pcc.firstAction();
       for(integer i = 0; i<5;i++){
        	pcc.wrapRecordList[i].checked = true;
       }  
       pcc.downloadCSV();
       System.assertEquals(0,pcc.selectedRecordsMap.size());
    }
    
    @isTest public Static void checkedMapAddToWrapList(){
      PaginationComponentController pcc = new PaginationComponentController();
      pcc.obj = 'Merchandise__c';
       pcc.fieldList = new List<string>();
       pcc.fieldLable = new List<string>();
       pcc.fieldList.add('name');
       pcc.fieldLable.add('Merchandise Name');	
       pcc.firstAction();
       test.startTest();
         list<SObject> mercRecords = [Select name from Merchandise__c];
       test.stopTest();
       pcc.wrapRecordList[2].checked = true;
       pcc.selectedRecordsMap.put(mercRecords[0].id,mercRecords[0]);
       pcc.basicCode();
       pcc.deleteSelectedRecords();
       System.assertEquals(19,pcc.noOfRecords);

    }
    
}
@isTest
public with sharing class BoxIntegrationTest {
    @TestSetup
    static void makeData(){
        //create test data 
        Integration_Access__c user = new Integration_Access__c(name = userInfo.getUserId(), Record_Type__c = 'Box.com', Access_Token__c = 'testCLASSaccessTOKEN',Refresh_token__c = 'testCLASSrefreshTOKEN', Expire_In__c = system.now());
        insert user;
    }


    //test method that get tokens after auth code recived
    @isTest static void getTokensTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        BoxIntegrationController.getTokens('TestAuthCode1234');
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10',user.Access_Token__c);
    }

    //test auth url recived from controller
    @isTest static void authurlTest(){
        // Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        string url = BoxIntegrationController.redirectAuthURI();
        //System.assertEquals();
    }

    //test regenerat access token method
    @isTest Static void reGenerateTkoenTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        BoxIntegrationController.reGenerateTkoen();
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10',user.Access_Token__c);
    }

    // test recive data from drive 
    @isTest static void fetchDataTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        BoxWrapper.allData data = BoxIntegrationController.fetchData('0');
        System.assertEquals('bmninja.jpg',data.item_collection.entries[0].name);
    }

    //test download url for a file
    @isTest static void getDownloadUrlTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        String downloadUrl = BoxIntegrationController.downloadFiles('FileId12345');
        System.assertEquals('https://public.boxcloud.com/d/1/TestCode',downloadUrl);
    }

    //test delete file request method
    @isTest static void deleteFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        String code = BoxIntegrationController.deleteFiles('file','FIELDTESTID12345');
        System.assertEquals('204',code);
    }

    // test delete folder method
    @isTest static void deleteFileTest2(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        String code = BoxIntegrationController.deleteFiles('folder','FolderID12345');
        System.assertEquals('204',code);
    }

    //test create folder response
    @isTest static void createFolderTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        BoxWrapper.entries folder = BoxIntegrationController.createFolder('New Folder','TestParentID');
        System.assertEquals('New Folder',folder.name);
    }

    //test upload file method and response
    @isTest static void UploadFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        Blob data = Blob.valueOf('blobfileTestDataFile==');
        BoxWrapper.item_collection file = BoxIntegrationController.uploadFile(data,'ParentId','ABC.PNG');
        System.assertEquals('ABC.jpg',file.entries[0].name);
    }

     //test upload file method and response when blon file has single = at end
     @isTest static void UploadFileTest2(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        Test.stopTest();
        Blob data = Blob.valueOf('blobfileTestDataFile=');
        BoxWrapper.item_collection file = BoxIntegrationController.uploadFile(data,'ParentId','ABC.PNG');
        System.assertEquals('ABC.jpg',file.entries[0].name);
    }

    //test token expired or not 
    @isTest static void tokenExpiryTest(){
        Boolean isExpired = BoxIntegrationController.isExpired();
        System.assertEquals(true,isExpired);
    }

    //get user test when user already created 
    @isTest static void getUserTest(){
        Integration_Access__c user = BoxIntegrationController.getUser();
        System.assertEquals('testCLASSaccessTOKEN',user.Access_Token__c);
    }

    //when user not available(first time)
    @isTest static void getUserTest1(){
        Integration_Access__c user = [SELECT Id FROM Integration_Access__c];
        Test.startTest();
            DELETE user;
        Test.stopTest();
        System.assertEquals(null,BoxIntegrationController.getUser());
    }
}
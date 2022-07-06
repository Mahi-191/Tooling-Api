@isTest public with sharing class DropBoxIntegrationTest {
    @TestSetup
    static void makeData(){
        //create test data 
        Integration_Access__c user = new Integration_Access__c(name = userInfo.getUserId(), Record_Type__c = 'DropBox', Access_Token__c = 'testCLASSaccessTOKEN',Refresh_token__c = 'testCLASSrefreshTOKEN', Expire_In__c = system.now());
        insert user;
    }
    
    //test method that get tokens after auth code recived
    @isTest static void getTokensTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
            Integration_Access__c deluser = [SELECT Id FROM Integration_Access__c];
            DELETE deluser;
        Test.stopTest();
       
        DropBoxIntegration.getTokens('TestAuthCode1234');
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10',user.Access_Token__c);
    }

    //test auth url recived from controller
    @isTest static void authCodeRequestTest(){
        // Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        string url = DropBoxIntegration.authCodeRequest();
        //System.assertEquals();
    }

    //test regenerat access token method
    @isTest Static void reGenerateTokenTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        DropBoxIntegration.regenerateAccessToken();
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10',user.Access_Token__c);
    }

    // test recive data from drive 
    @isTest static void fetchDataTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        DropBoxWrapper data = DropBoxIntegration.getData('0');
        System.assertEquals('first',data.entries[0].name);
    }

    //test download url for a file
    @isTest static void downloadDataTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        String downloadUrl = DropBoxIntegration.downloadData('/First/bmlogo.png');
        System.assertEquals('https://testDownloadLink',downloadUrl);
    }

    //test delete file request method
    @isTest static void deleteFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        String response = DropBoxIntegration.deleteItem('/First/bmlogo.png');
        System.assertEquals('{"metadata": {".tag": "folder", "name": "New Folder", "path_lower": "/first/hah", "path_display": "/first/hah", "id": "id:101kgoIPWkIAAAAAAAAATw"}}',response);
    }

    //test create folder response
    @isTest static void createFolderTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        DropBoxWrapper.entries folder = DropBoxIntegration.createNewFolder('New Folder','/First/New Folder');
        System.assertEquals('New Folder',folder.name);
    }

    //test upload file method and response
    @isTest static void uploadFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DropBoxMock());
        Test.stopTest();
        String fileBody = 'fileStringBodyTest';
        DropBoxWrapper.entries file = DropBoxIntegration.uploadFile('/First/second','test.png',fileBody);
        System.assertEquals('ABC.jpg',file.name);
    }

    

    //test token expired or not 
    @isTest static void tokenExpiryTest(){
        Boolean isExpired = DropBoxIntegration.isExpired();
        System.assertEquals(true,isExpired);
    }

    //get user test when user already created 
    @isTest static void isUserExistTest(){
        Boolean userExist = DropBoxIntegration.isUserExist();
        System.assertEquals(true,userExist);
    }

    //when user not available(first time)
    @isTest static void isUserExistTest2(){
        Integration_Access__c user = [SELECT Id FROM Integration_Access__c];
        Test.startTest();
            DELETE user;
        Test.stopTest();
        System.assertEquals(false,DropBoxIntegration.isUserExist());
    }
}
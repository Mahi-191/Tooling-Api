@isTest
public with sharing class IntegrationControllerTest {

    @TestSetup
    static void makeData(){
        //create test data 
        Integration_Access__c user = new Integration_Access__c(name = userInfo.getUserId(), Record_Type__c = 'Google Drive', Access_Token__c = 'testCLASSaccessTOKEN',Refresh_token__c = 'testCLASSrefreshTOKEN', Expire_In__c = system.now());
        insert user;
    }


    //test method that get tokens after auth code recived
    @isTest static void getTokensTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        IntegrationController.auth_Step_2('TESTauthCODEabcdefghijklmnopqrstuvwxyz');
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10',user.Access_Token__c);
    }

    //test auth url recived from controller
    @isTest static void authurlTest(){
        // Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        string url = IntegrationController.authStep1();
        //System.assertEquals();
    }

    //test regenerat access token method
    @isTest Static void reGenerateTkoenTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        IntegrationController.reGenerateTkoen();
        Integration_Access__c user = [select name, Access_Token__c, Expire_In__c, Refresh_token__c from Integration_Access__c where Name =: userInfo.getUserId()];
        System.assertEquals('A1B2C3D4E5F6G7H8I9J10k11',user.Access_Token__c);
    }

    // test recive data from drive 
    @isTest static void fetchDataTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        list<GoogleDriveIntegrationWrapper.Files> data = IntegrationController.fetchData('https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false');
        System.assertEquals('bmnija.jpg',data[0].name);
    }

    //test download url for a file
    @isTest static void getDownloadUrlTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        String downloadUrl = IntegrationController.download('FIELDTESTID12345');
        System.assertEquals('https://drive.google.com/uc?id=ABCD&export=download',downloadUrl);
    }

    //test delete file request method
    @isTest static void deleteFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        String code = IntegrationController.deleteFiles('FIELDTESTID12345');
        System.assertEquals('204',code);
    }

    //test create folder response
    @isTest static void createFolderTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        GoogleDriveIntegrationWrapper.Files folder = IntegrationController.createFolder('New folder','TESTPARENTID');
        System.assertEquals('application/vnd.google-apps.folder',folder.mimeType);
    }

    //test upload file method and response
    @isTest static void UploadFileTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GoogleDriveMock());
        Test.stopTest();
        string boundery = 'testboundery';
        string body = '--testboundery/r/n'+'testbody/r/n'+'--testboundery--';
        GoogleDriveIntegrationWrapper.Files file = IntegrationController.uploadFile(body,boundery);
        System.assertEquals('ABC.png',file.name);
    }

    //test token expired or not 
    @isTest static void tokenExpiryTest(){
        Boolean isExpired = IntegrationController.isExpired();
        System.assertEquals(true,isExpired);
    }

    //get user test when user already created 
    @isTest static void getUserTest(){
        Integration_Access__c user = IntegrationController.getUser();
        System.assertEquals('testCLASSaccessTOKEN',user.Access_Token__c);
    }

    //when user not available(first time)
    @isTest static void getUserTest1(){
        Integration_Access__c user = [SELECT name from Integration_Access__c];
        Test.startTest();
            DELETE user;
        Test.stopTest();
        System.assertEquals(null,IntegrationController.getUser());
    }
}
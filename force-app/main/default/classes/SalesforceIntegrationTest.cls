@isTest 
public with sharing class SalesforceIntegrationTest {
    @TestSetup
        static void makeData(){
            //insert Account
            Account acc = new Account();
            acc.Name ='myName';
            insert acc;

            //Insert Contact related to contact
            Contact con = new Contact();
            con.AccountId= acc.Id;
            con.Email='mahi@bmninja.com';
            con.lastname = 'test';
            insert con;

            //Inserted user with contact id and community user profile
            User user = new User();
            user.Username ='mahi@bmninja.com';
            user.LastName = 'Sharma';
            user.Email = 'mahi@bmninja.com';
            user.alias = 'testAl';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.ProfileId = [select id from Profile where Name='Intigration Community User'].Id;
            user.LanguageLocaleKey = 'en_US';
            user.ContactId=con.Id;
            insert user;

        //uploded a test file 
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
            insert contentVersion; 
          
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
  
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = con.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            cdl.visibility = 'AllUsers';
            insert cdl;
    }
    
    // fetch data from local org test
    @isTest static void getLocalDataTest(){
        User u = [Select id from User Where Username = 'mahi@bmninja.com'];
        system.runAs(u){
            List<SalesforceIntegrationController.FileData> result = SalesforceIntegrationController.getLocalData();
            System.assertEquals(1, result.size());
        }
        List<SalesforceIntegrationController.FileData> result = SalesforceIntegrationController.getLocalData();
            System.assertEquals(null, result);
    }

    //upload file to community org Test
    @isTest static void localUploadTest(){
            SalesforceIntegrationController.FileData result = SalesforceIntegrationController.localUpload('base64 file demo data', 'logo.png');
            System.assertEquals('logo.png', result.fileName);
    }

    //Upload file to API org Test
    @isTest static void uploadDataOnApiOrgTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SalesforceIntegrationMock());
        Test.stopTest();
        String response = SalesforceIntegrationController.uploadDataOnApiOrg('demo base64 body ', 'testFile.png');
        System.assertEquals('"testFile.png"',response);
    }
}
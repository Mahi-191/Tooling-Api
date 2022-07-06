@isTest
public class ContactStatusUpdateTest {
	// test Setup insert list came from data factory
    @TestSetup
     static void makeData(){
        List<Contact> conList = ContactDataFactory.craeteContactRecords(50);
        Test.startTest();
            insert conList;
        Test.stopTest();
     }
     // run and test contact status batch class
     @isTest static void checkBatch(){
        List<contact> conList =[SELECT id FROM Contact];
        Datetime yesterday = Datetime.now().addDays(-1);
        for(contact con: conList){
            Test.setCreatedDate(con.Id, yesterday);
        }
        Test.startTest();
            update conlist;
            database.executebatch(new ContactStatusUpdate());
        Test.stopTest();
        List<Contact> cons =[SELECT id, Status__c FROM Contact];
        System.assertEquals('Ready for Approval', cons[1].Status__c);
     }

     // run Scheduler and check size of jobs
     @isTest static void checkScheduler(){
        List<contact> conList =[SELECT id FROM Contact];
        Datetime yesterday = Datetime.now().addDays(-1);
        for(contact con: conList){
            Test.setCreatedDate(con.Id, yesterday);
        }
        Test.startTest();
            update conlist;
            ContactStatusUpdatescheduler scheduler = new ContactStatusUpdatescheduler();
            String sch = '0 0 0 * * ? ';
            system.schedule('Check Status', sch, scheduler);
        Test.stopTest();  
        List<AsyncApexJob> jobs = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];     
        System.assertEquals(1,jobs.size()); 
     }
}
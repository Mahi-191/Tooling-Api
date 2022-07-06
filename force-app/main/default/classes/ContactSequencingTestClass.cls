@isTest
public class ContactSequencingTestClass {
    @TestSetup
     static void makeData(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,null);
     }

    //100 contact of a account with null as sequence number
    @isTest Static void checkInsertForNullSNO(){
       List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact];
       system.assertEquals(1, testList[0].Sequence_Number__c);
       system.assertEquals(100, testList[99].Sequence_Number__c);
    }
    //100 contact of a account with 1 as sequence number
    @isTest Static void checkInsertForOneAsSNO(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,1);
       List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
       system.assertEquals(100, testList[0].Sequence_Number__c);
       system.assertEquals(1, testList[99].Sequence_Number__c);
    }
    //100 contact of a account with less then 1 Sequence Number
    @isTest Static void checkInsertForLessThenOneAsSNO(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,0);
       List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
       system.assertEquals(100, testList[0].Sequence_Number__c);
       system.assertEquals(1, testList[99].Sequence_Number__c);
    }
     //100 contact of a account with  out of Range Sequence Number
     @isTest Static void checkInsertWhenSeqOutOfRange(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,1000);
       List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
       system.assertEquals(1, testList[0].Sequence_Number__c);
       system.assertEquals(100, testList[99].Sequence_Number__c);
    }

    //10 contact of a account then insert 2 more contact records with in range sequence no
    @isTest Static void checkInsertWhenExistingRecordsAvailable(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        list<Contact> newConlist = new list<Contact>();
        newConlist.add(New Contact(LastName='demo1', Sequence_Number__c = 5, AccountId =conlist[0].AccountId ));
        newConlist.add(New Contact(LastName='demo2', Sequence_Number__c = 3, AccountId = conlist[0].AccountId));
        test.startTest();
            Insert newConlist;
            List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY LastName ASC];
        test.stopTest();
        system.assertEquals(3, testList[11].Sequence_Number__c);
    } 

    // 100-100 records for two different Accounts by one list with sequence number null
    @isTest Static Void checkInsertForTwoAccounts(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForTwoAccounts(100,null);
        test.startTest();
            List<contact> firstAct = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
            List<contact> secondAct = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[1].AccountId];
        test.stopTest();
        System.assertEquals(1,firstAct[0].Sequence_Number__c);
        System.assertEquals(100,secondAct[99].Sequence_Number__c);
    }
    
    
    // Delete Record Test -- Total Records 100 deleting 50 records from last
    @isTest Static Void deleteRecordFromLast(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,null);
        test.startTest();
            List<contact> delList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId AND Sequence_Number__c>50];
            Delete delList;
            List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
        test.stopTest();
        System.assertEquals(50,testList.size());
        System.assertEquals(50,testList[49].Sequence_Number__c);
    } 
    //Delete Record Test -- total Records 100 deleting 50 from Start
    @isTest Static Void deleteRecordFromFirst(){
        test.startTest();
            List<contact> delList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where Sequence_Number__c<=50];
            Delete delList;
            List<contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact];
        test.stopTest();
        System.assertEquals(50,testList.size());
        System.assertEquals('Demo contact51',testList[0].LastName);
    } 

    //undelete Records of a account
     @isTest Static void unDeleteRecordTest(){
        test.startTest();
            List<contact> delList = [SELECT LastName, Sequence_Number__c FROM Contact Where Sequence_Number__c<=50];
            Delete delList;
            Integer counter = [Select count() FROM Contact];
            System.assertEquals(50,counter);
            checkRecursive.firstCheck = false;
            List<contact> unDelList = [SELECT id FROM Contact Where IsDeleted = TRUE ALL ROWS];
            undelete unDelList;
            counter = [Select count() FROM Contact];
        test.stopTest();
        System.assertEquals(100,counter);
    }

    //update one record sequence number to 1 when old is 9 CASE(oldSeq>NewSeq)
    @isTest Static void updateARecordtestCase1(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        conlist[8].Sequence_Number__c = 1;
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist[8];
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact9', testList[0].LastName);

    }

    //update one record sequence number to 7 when old is 2 CASE(oldSeq<NewSeq)
    @isTest Static void updateARecordtestCase2(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        conlist[1].Sequence_Number__c = 7;
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist[1];
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact2', testList[6].LastName);
    }

    //update one record sequence number to null when old is 5 CASE(NewSeq==Null|| newSeq>Range)
    @isTest Static void updateARecordtestCase3(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        conlist[4].Sequence_Number__c = null;
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist[4];
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact5', testList[9].LastName);
    }

    //update one record sequence number to -5 when old is 5 CASE(NewSeq<1)
    @isTest Static void updateARecordtestCase4(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        conlist[4].Sequence_Number__c = -5;
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist[4];
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact5', testList[0].LastName);
    }

    //update in bulk all sequences = 1
    @isTest Static void updateBulkRecordtestCase1(){
        List<Contact> availableRecords = [SELECT LastName, Sequence_Number__c FROM Contact ORDER BY Sequence_Number__c ASC];
        for(Integer i = 0; i<100;i++){
            availableRecords[i].Sequence_Number__c = 1;
        }
        checkRecursive.firstCheck = false;
        test.startTest();
            Update availableRecords;
            List<Contact> testList = [SELECT LastName, Sequence_Number__c FROM Contact ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact100', testList[0].LastName);
    }

     //update in bulk all sequences = 1000
     @isTest Static void updateBulkRecordtestCase2(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,null);
        for(Integer i = 0; i<100;i++){
            conlist[i].Sequence_Number__c = 1000;
        }
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist;
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact100', testList[99].LastName);
    }

    //update in bulk all sequences = -1
    @isTest Static void updateBulkRecordtestCase3(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(100,null);
        for(Integer i = 0; i<100;i++){
            conlist[i].Sequence_Number__c = -1;
        }
        checkRecursive.firstCheck = false;
        test.startTest();
            Update conlist;
            List<Contact> testList = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId ORDER BY Sequence_Number__c ASC];
        test.stopTest();
        System.assertEquals('Demo contact100', testList[0].LastName);
    }


    //Re-Parenting for a single contact assigning another account as parent
    @isTest Static void reParentintSingleRecordCase1(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        Account act = new Account(Name = 'TestAccount');
        insert act;
        conlist[4].AccountId = act.Id;
        checkRecursive.firstCheck = false;
        test.startTest();
            update conlist[4];
            Integer counter = [Select count() FROM Contact Where AccountId =:conlist[0].AccountId];
        test.stopTest();
        System.assertEquals(9, counter);
    }

    //Re-Parenting for a single contact assigning null as parent
    @isTest Static void reParentintSingleRecordCase2(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        conlist[4].AccountId = null;
        checkRecursive.firstCheck = false;
        test.startTest();
            update conlist[4];
            Integer counter = [Select count() FROM Contact Where AccountId =:conlist[0].AccountId];
        test.stopTest();
        System.assertEquals(9, counter);
    }

    //Assigning a Account as parent to a record Which not have Parent
    @isTest Static void reParentingBulkRecordsCase1(){
        List<Contact> conlist = ContactSequencingDatafactory.craeteContactRecordsForOneAccount(10,null);
        contact con = new Contact(LastName='Reparent Test');
        Insert con;
        con.AccountId = conlist[0].AccountId;
        checkRecursive.firstCheck = false;
        test.startTest();
            update con;
            Integer counter = [Select count() FROM Contact Where AccountId =:conlist[0].AccountId];
        test.stopTest();
        System.assertEquals(11, counter);
    }

    //bulk Reparenting of accounts
    @isTest Static void reParentingBulkRecordsCase2(){
        List<contact> conList = ContactSequencingDatafactory.craeteContactRecordsForTwoAccounts(50,null);
        test.startTest();
            List<contact> firstAct = [SELECT LastName, Sequence_Number__c, AccountId FROM Contact Where AccountId =:conlist[0].AccountId];
        test.stopTest();
        List<Contact> updateList = new List<Contact>();
        for(Integer i = 0;i<25;i++){
            firstAct[i].AccountId = conlist[1].AccountId;
            Contact con = firstAct[i];
            updateList.add(con);
        }
        checkRecursive.firstCheck = false;
        update updateList;
        Integer counter = [Select count() FROM Contact Where AccountId =:conlist[1].AccountId];
        System.assertEquals(75,counter);
    }

}
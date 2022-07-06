@isTest
public class ContactSequencingDatafactory {
 
   	public static List<contact> craeteContactRecordsForOneAccount(Integer num, Integer seqNo){
        Account act = New Account(Name = 'ContactTestAccount');
        insert act;
        list<Contact> conList = new List<Contact>();
        for(integer i = 1; i <= num; i++){
           conlist.add(new Contact(LastName = 'Demo contact'+i, Sequence_Number__c = seqNo, AccountId = act.Id ));
        }
        insert conlist; 
        return conList;
    }

    public static List<contact> craeteContactRecordsForTwoAccounts(Integer num, Integer seqNo){
        Account act = New Account(Name = 'Account 1');
        insert act;
        Account acct = New Account(Name = 'Account 2');
        insert acct;
        list<Contact> conList = new List<Contact>();
        for(integer i = 1; i <= num; i++){
            conlist.add(new Contact(LastName = 'Demo contact'+i, Sequence_Number__c = seqNo, AccountId = act.Id ));
            conlist.add(new Contact(LastName = 'Demo contact'+i, Sequence_Number__c = seqNo, AccountId = acct.Id ));
        }
        insert conlist; 
        return conList;
    }
}
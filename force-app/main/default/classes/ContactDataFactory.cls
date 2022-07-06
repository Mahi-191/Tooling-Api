@isTest
public class ContactDataFactory {
	public static List<contact> craeteContactRecords(Integer num){
        list<Contact> conList = new List<Contact>();
        for(integer i = 1; i <= num; i++){
           conList.add(new Contact(LastName = 'Demo contact'+i));
        } 
        return conList;
    }
}
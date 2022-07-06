public class InsertAccount {
    public static void addAccount(){
        list<Account> accList = new list<account>();
        for(integer i =1;i<=150;i++){
            Account account = new Account(Name = 'Test Account');
            accList.add(account);
        }
        insert accList;
    }
}
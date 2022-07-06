public class opportunitytriggerClass {
    public static void checkStatus(list<Opportunity> OppList){
        List<Account> accList = new List<Account>();
        for(Opportunity op : OppList){
            if(op.StageName == 'Closed Won'){
                if(op.AccountId == null){
           		    Account acc = new Account();
                    acc.name = op.Name + ' Account';
                    acc.opp__c = op.Name;
                    accList.add(acc);
        		}
            }
        }
    	insert accList;
    }
}
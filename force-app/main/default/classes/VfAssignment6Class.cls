public class VfAssignment6Class {
    public Account acc{get;set;}
    public VfAssignment6Class(){
        string actId = ApexPages.CurrentPage().getparameters().get('id');
    	List<Account> act = [SELECT id, Name, Rating, Industry FROM Account Where id =:actId];
        if(act.size() > 0){
       		acc = act[0];
        }
        else{
            acc = new Account();
        }
    }
}
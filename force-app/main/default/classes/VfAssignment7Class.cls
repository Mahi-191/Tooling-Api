public class VfAssignment7Class{

    public PageReference Cancel() {
        return null;
    }

    public Account acc{get;set;}
    public VfAssignment7Class(){
        string actId = ApexPages.CurrentPage().getparameters().get('id');
    	List<Account> act = [SELECT id, Name, Rating, Industry FROM Account Where id =:actId];
        if(act.size() > 0){
       		acc = act[0];
        }
        else{
            acc = new Account();
        }
    }
    public Pagereference Save(){
        upsert acc;
        PageReference pageRef = new PageReference('/');
        pageRef.setRedirect(true);
        return pageRef;

    }

        public Pagereference QuickSave(){
        upsert acc;
        return null;
    }
    
    
}
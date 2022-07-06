public class VfAssignment8Class {

    List<Account> acc = [SELECT id, Name, Rating, Industry FROM Account];
    
    Public List<Account> getact(){
        Return acc;
    }
    public Pagereference Save(){
        update acc;
        PageReference pageRef = new PageReference('/');
        pageRef.setRedirect(true);
        return pageRef;
    }
        public Pagereference QuickSave(){
        update acc;
        return null;
    }
}
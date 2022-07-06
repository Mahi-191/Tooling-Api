public class VfAssignment9Class {
    public String filter{get;set;}
    List<Account> acc = [SELECT id, Name, Rating, Industry FROM Account order by name];
    Public List<Account> getact(){
        Return acc;
    }
    
    public List<SelectOption> getItems() {
    	List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('3','All Accounts'));
        options.add(new SelectOption('1','New This Week'));
        options.add(new SelectOption('2','New Last Week'));
        options.add(new SelectOption('4','My Accounts'));
        options.add(new SelectOption('5','Recently Viewed Accounts'));
        return options;
        }

     public void setAccfilter() {
         if(filter == '1'){
			acc = [SELECT id, Name, Rating, Industry FROM Account  WHERE CreatedDate = THIS_WEEK];
		}
        else if(filter == '2'){
         	acc = [SELECT id, Name, Rating, Industry FROM Account where CreatedDate = LAST_WEEK];   
        }
        else if(filter == '3'){
        	 acc = [SELECT id, Name, Rating, Industry FROM Account order by name];   
        }
        else if(filter == '4'){
         	 acc = [SELECT id, Name, Rating, Industry FROM Account  WHERE OwnerId= :UserInfo.getUserID() Order by Name];  
        }
        else if(filter == '5'){
         	 acc = [SELECT id, Name, Rating, Industry FROM Account ORDER BY LastViewedDate DESC];  
        }
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
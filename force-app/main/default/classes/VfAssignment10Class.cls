public class VfAssignment10Class {

    public String filter {get;set;}
    String pageSize='10';  
    private integer counter=0;  
    public integer list_Size{get;set;}  
    public List<Account> acc {get;set;}
    public List<SelectOption> options{get;set;}
    public integer total_size{get;set;}
    List<Account> countList = [Select id from account];
    public VfAssignment10Class(){
        list_Size = 10;
        acc = new List<Account>();
        acc = [SELECT id, Name, Rating, Industry FROM Account order by name];
        total_size = countList.size();
        options = new List<SelectOption>();
        options.add(new SelectOption('3','All Accounts'));
        options.add(new SelectOption('1','New This Week'));
        options.add(new SelectOption('2','New Last Week'));
        options.add(new SelectOption('4','My Accounts'));
        options.add(new SelectOption('5','Recently Viewed Accounts'));
    }
    public void setAcfilter(){
        counter = 0;
        
        setAccfilter();
    }
   public void setAccfilter() {
         if(filter == '1'){
			acc = [SELECT id, Name, Rating, Industry FROM Account  WHERE CreatedDate = THIS_WEEK offset :counter];
             countList = [Select id from account WHERE CreatedDate = THIS_WEEK];
		}
        else if(filter == '2'){
         	acc = [SELECT id, Name, Rating, Industry FROM Account where CreatedDate = LAST_WEEK offset :counter];
            countList = [Select id from account WHERE CreatedDate = LAST_WEEK];
        }
        else if(filter == '3'){
        	 acc = [SELECT id, Name, Rating, Industry FROM Account order by name offset :counter];
            countList = [Select id from account];
        }
        else if(filter == '4'){
         	 acc = [SELECT id, Name, Rating, Industry FROM Account  WHERE OwnerId= :UserInfo.getUserID() Order by Name offset :counter];
            countList = [Select id from account WHERE OwnerId= :UserInfo.getUserID()];
            
        }
        else if(filter == '5'){
         	 acc = [SELECT id, Name, Rating, Industry FROM Account ORDER BY LastViewedDate DESC offset :counter]; 
            countList = [Select id from account ORDER BY LastViewedDate DESC];
        }
       total_size = countList.size();
     }
    
    public String getpageSize(){
        return PageSize;
    }
    public void setpageSize(string pageSize) {
        if(pageSize == '5'){
            list_Size = 5;
            setAccfilter();
        }
        else if(pageSize == '10'){
           list_Size = 10;
            setAccfilter();
        }
        else if(pageSize == '15'){
            List_Size = 15;
            setAccfilter();
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
    
    
       public PageReference First() {  
        counter=0;
           setAccfilter();
        return null;
    }

    public PageReference Previous() { 
         counter = counter - list_size;
         setAccfilter();
         return null;
    }
    
    public PageReference Next() {  
        counter = counter + list_size;
        setAccfilter();
        return null; 
    }

    public PageReference Last() {      
        counter = total_size - math.mod(total_size, list_size);
        setAccfilter();
        return null;
    }
    
   public Boolean getDisabledPrevious() {           
        if(counter>0)
             return false;
         else 
             return true;   
    }
    public Boolean getDisabledNext() {            
        if (counter + list_size < total_size) 
            return false; 
        else 
            return true;
    }
    public Integer getPageNumber() {        
        return counter/list_size + 1;
   	}
}
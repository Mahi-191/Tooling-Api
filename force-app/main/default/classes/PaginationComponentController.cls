public class PaginationComponentController {
    public Integer size{get;set;}  
    public Integer noOfRecords{get;set;}
    public Integer pagenumber{get;set;}
    public list<SelectOption> pageSizeList{get;set;}
    public string obj{get;set;}
    public list<String> fieldList{get;set;}
    public list<String> fieldLable{get;set;}
    public list<WrapFields> fields{get;set;}
    public list<WrapperClass> wrapRecordList{get;set;}
    public Map<Id,sObject> selectedRecordsMap{get;set;}
    public List<String> alphabet{get;set;}
    public string filterchar{get;set;}
    public string query;
    public string finalQuery;
    public Apexpages.StandardSetController setConn{get;set;}
    public Boolean hasPrevious{get;set;}
    public Boolean hasNext{get;set;}
    public String sortField{get;set;}
    public String sortOrder{get;set;} 
    public boolean checked{get;set;}
    public String recordToDelete{get;set;}
    public string stringCSV{get;set;}
    string tempQuery;
    string tempfild;
    public integer selectedcount{get;set;}
    
    public PaginationComponentController(){   
        size = 5;
        pagenumber = 0;
        noOfRecords = 0;
        selectedcount = 0;
        filterchar = 'All';
        sortField = 'none';
        tempfild = 'none';
        sortOrder = ' ASC';
        checked = false;
        stringCSV = '';
   		pageSizeList = new List<SelectOption>();
        pageSizeList.add(new SelectOption('5','5'));
        pageSizeList.add(new SelectOption('10','10'));
        pageSizeList.add(new SelectOption('20','20'));
        pageSizeList.add(new SelectOption('50','50'));
        pageSizeList.add(new SelectOption('100','100'));
        selectedRecordsMap = new Map<Id,sObject>();
        alphabet = new string[]{'All','Other','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
    }

    // only called when process button clicked 
    public void firstAction(){
        makefildwrapperlist();
        selectedRecordsMap.clear();
        wrapRecordList = new list<WrapperClass>();
        query = String.join(FieldList,',');
        query = query.removeEnd(',');
        query = 'Select ' +  query + ' From ' + Obj ;
        finalQuery = query;
        tempQuery = query;
        setConn = new Apexpages.StandardSetController(Database.getQueryLocator(query));
        setConn.setPageSize(size);  
        noOfRecords = setConn.getResultSize();
        basicCode();
    }

    //method to run standard Set controller
    public void refreshPage() {
        try{
            setConn = new Apexpages.StandardSetController(Database.getQueryLocator(finalQuery));
        }
        catch( Exception ex ){
            setConn = new Apexpages.StandardSetController(Database.getQueryLocator(query));
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Somthing went wrong can not perform this operation' ));
        }
        setConn.setPageSize(size);  
        noOfRecords = setConn.getResultSize();
        basicCode(); 
    }

    // list of api name and lable of selected fields bind in a wraper class
    void makefildwrapperlist(){
        fields = new List<WrapFields>();
        for(integer i = 0; i<FieldList.size(); i++){
            fields.add(new WrapFields(FieldList[i],fieldLable[i]));
        }
    }
    
    // filter and store records according to selected charactor
    public void charFilter(){
            if(filterchar == 'All'){
            finalQuery = query;
            }
            else if(filterchar != 'Other'){
                finalQuery = query + ' Where name Like \'' + filterchar +'%\'';
            }
            else{
                finalQuery = query +  ' WHERE name'  + ' <= \'a\'' + ' OR name' + ' <=\'0\'' ;
            }
        tempQuery = finalQuery;
        sortOrder = ' ASC';
        sortField = 'none';
        refreshPage();
        
    }

    // method to sort table according to given field
    public void sortQuery(){
        if(tempfild != sortField){
            sortOrder = ' ASC';
        }
        if(sortField != 'none'){
            
            finalQuery = tempQuery + ' ORDER BY ' + sortField + sortOrder + ' NULLS LAST';
            if(sortOrder == ' ASC'){
                sortOrder = ' DESC';
            }
            else{
                sortOrder = ' ASC';
            }
        tempfild = sortField;
        }

        refreshPage();
    }

    /*-------- Next, Previous, Last, First methods for buttons -------*/
    public void next(){
        setConn.next();
        basicCode();
    }

    public void previous(){
        setConn.previous();
        basicCode();
    }

    public void last(){
        setConn.last();
        basicCode();
    }   

    public void first(){
        setConn.first();
        basicCode();
    } 

    // method to set pagenumber from inputText
    public void customPageNumber(){
        if(pagenumber<1){
            first();
        }
        else if(pagenumber>(noOfRecords/size)){
            last();
        }
        else{
            setconn.setPageNumber(pagenumber);
            basicCode();
        }
    }
	
    // code we want to use in many methods 
   public void basicCode(){
        updateMap();
       
        wrapRecordList = new list<WrapperClass>();
        for(SObject r : setConn.getRecords()){ 
            if(selectedRecordsMap.containsKey(r.Id)){   
                wrapRecordList.add(New wrapperclass(true,r));
            }
            else{
                wrapRecordList.add(New wrapperclass(false,r));
            } 
        }
        pagenumber = (noOfRecords!=0) ? setConn.getPageNumber() : 0;
        hasNext = setConn.getHasNext();
        hasPrevious = setConn.getHasPrevious();
        setConn.setPageNumber(pagenumber);
        selectedcount = selectedRecordsMap.size();
    } 

    // update map of selected records 
    public void updateMap(){
        if(wrapRecordList != null){
        for(WrapperClass a : wrapRecordList){
            if(a.checked == true){
                selectedRecordsMap.put(a.wrapObject.Id,a.wrapObject);
            }
            if(a.checked == false){
                selectedRecordsMap.remove(a.wrapObject.id);
            }
        }
      }
      selectedcount = selectedRecordsMap.size();
    }

    // method to delete a single record by ID
    public void deleteSingleRecord(){ 
        try {
            Database.Delete(recordToDelete);
            refreshPage();
        }
        catch( Exception ex ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'There was a problem deleting the record: ' + ex.getMessage() ));
        }  
    }
    
    //Delete selected records by checkbox it delets records placed in map of selected records 
    public void deleteSelectedRecords(){
        updateMap();
        try{
            if(selectedRecordsMap.size()>0){
                Integer tempSize =  selectedRecordsMap.size();
                String msg = tempSize + ' record deleted!!';
                delete selectedRecordsMap.values();
                selectedRecordsMap.clear();
                wrapRecordList.clear();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,msg));
                refreshPage();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please Select any Record'));   
            }
        }
        catch( Exception exc ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'There was a problem deleting the record: ' + exc.getMessage() ));
        }  
    }

    //make a CSV string of Selected records 
    public void downloadCSV(){
        updateMap();
        List<id> ids = new List<id>();
        for(id i:selectedRecordsMap.keySet()){
            ids.add(i);
        }
        stringCSV = String.join(fieldLable,',');
        stringCSV = stringCSV.removeEnd(',');
        stringCSV = stringCSV + '\\n';

        String queryStr = query + ' WHERE id IN :ids';
        sObject[] data = Database.query(queryStr);
        String temp = '';
        for(Integer i=0;i<data.size();i++){
            for(String fld: FieldList){
                temp = String.valueOf((data[i].get(fld)));
                if(temp!=null){
                    stringCSV += temp;
                }
                else{
                    stringCSV += ' ';
                }
               
                stringCSV += ',';
            }
            stringCSV = stringCSV.removeEnd(',');
            stringCSV +='\\n'; 
      }
      selectedRecordsMap.clear();
      wrapRecordList.clear();
      refreshPage();
    }
    
    //wrapper class to store api name and lable of fields
    public class WrapFields{
        public string api{get;set;}
        public string lable{get;set;}

        public WrapFields(string api, string lable){
            this.api = api;
            this.lable = lable;
        }
    }

    //wrapper class to store checkbox value and record 
    public class WrapperClass{
        public Boolean checked{get;set;}
        public sobject wrapObject{get;set;}

        public WrapperClass(Boolean checked,sobject wrapObject){
            this.checked = checked;
            this.wrapObject = wrapObject;
        }
    }
}
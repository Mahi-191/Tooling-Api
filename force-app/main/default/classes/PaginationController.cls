public class PaginationController {
    public List<string> selectedFields{get;set;}
    public List<string> removeFields{get;set;}
    public String sObj {get;set;}
    public String sObjLable {get;set;}
    public List<selectOption> sObjectList{get;set;}
    public List<SelectOption> objFields{get;set;}
    public List<SelectOption> selectedFieldsOptions{get;set;}
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    map<String,Schema.SObjectField> fieldsMap;
    public Boolean show{get;set;}
    public Boolean addDisable{get;set;}
    public Boolean removeDisable{get;set;}
    public Boolean paginationBlock{get;set;}
    public list<string> fieldsApiName{get;set;}
    public list<string> fieldsLableName{get;set;}
    String customLable = system.label.Pagination;
    public PaginationController(){
        fetchObjects();
        show = false;
        paginationBlock = false;
    }
    
    //store all custom andstanderd object names in SelectOption List
        public void fetchObjects(){
            sObjectList = new List<SelectOption>();
            sObjectList.add(new SelectOption(' ','--none--'));
            for(Schema.SObjectType objTyp : gd.Values()){
                Schema.DescribeSObjectResult filterObj = objTyp.getDescribe();
                if(filterObj.isCustom() || customLable.contains(filterObj.getLabel())){
                    sObjectList.add(new SelectOption(filterObj.getName(),filterObj.getLabel()));
                }
            }
            sObjectList.sort();  
        }
    
    // fetch all fileds of selected sobject from page 
        public void fetchFields(){
            ObjFields = new List<SelectOption>();
            SelectedFieldsoptions = new list<SelectOption>();
            if(sobj != ' '){
                show = true;
                removeFields = new List<string>();
                SObjectType sobjType = gd.get(sobj);
                sObjLable =sObjType.getDescribe().getLabel();
                fieldsMap = sObjType.getDescribe().fields.getMap();
                for(string fieldName : fieldsMap.keySet()){
                    Schema.DescribeFieldResult filterFilds = fieldsMap.get(fieldName).getDescribe();
                    if(filterFilds.isSortable() && filterFilds.isAccessible() && filterFilds.isFilterable() && filterFilds.isUpdateable()){
                        ObjFields.add(new SelectOption(fieldName,filterFilds.getLabel()));
                   }
                }
            }
            else {
                show = false;
            }
            ObjFields.sort();
            addDisable = objFields.isEmpty();
            removeDisable = selectedFieldsOptions.isEmpty();
            paginationBlock = false;
        }
        
    // create a list of selectoptions of selected fields from page  
        public void add(){
            for(string apiName : selectedFields){
               string lable = fieldsMap.get(apiName).getDescribe().getLabel();
               SelectedFieldsoptions.add(new SelectOption(apiName,lable));
            }
            removeFieldsFromList();
            SelectedFieldsoptions.sort();
            addDisable = objFields.isEmpty();
            removeDisable = selectedFieldsOptions.isEmpty();
        }
        
    // method to remove selected fields from all fields list
        void removeFieldsFromList(){
            for(integer i = 0; i<objFields.size();i++){
                for(string b : selectedFields){
                    if(objFields[i].getValue() == b){
                        objFields.remove(i);
                    }
                }
            }
        }
        
    // method to remove selected fields from list and add them in all field list
        public void removeButton(){
            for(integer i = 0; i < selectedFieldsOptions.size();i++){
                for(string b : removeFields){
                    if(selectedFieldsOptions[i].getValue() == b){
                        selectedFieldsOptions.remove(i);
                    }
                }
            }
            selectedFieldsOptions.sort();
            for(string apiName : removeFields){
                string lable = fieldsMap.get(apiName).getDescribe().getLabel();
                objFields.add(new SelectOption(apiName,lable));
            }
            objFields.sort();
            addDisable = objFields.isEmpty();
            removeDisable = selectedFieldsOptions.isEmpty();
        }
    
    //reset the page to initial stage
        public void reset(){
            sobj = ' ';
            show = false;
            paginationBlock = false;
        }

    //process button
        public void process(){
            fieldsApiName = new list<string>();
            fieldsLableName = new list<string>();
            for(SelectOption key : SelectedFieldsoptions){
                fieldsApiName.add(key.getValue());
                fieldsLableName.add(key.getLabel());
            } 
            paginationBlock = True;
        }      
}
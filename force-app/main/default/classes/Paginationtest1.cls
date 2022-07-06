public class Paginationtest1 {
    public List<string> selectedFields{get;set;}
    public List<string> removeFields{get;set;}
    public String sObj {get;set;}
    public List<selectOption> sObjectList{get;set;}
    public List<SelectOption> objFields{get;set;}
    public List<SelectOption> selectedFieldsOptions{get;set;}
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    map<String,Schema.SObjectField> fieldsMap;
    public Boolean show{get;set;}

    public Paginationtest1(){
        fetchObjects();
        show = false;
    }

    //store all custom an 13 standerd object names in SelectOption List
    void fetchObjects(){
        sObjectList = new List<SelectOption>();
        sObjectList.add(new SelectOption(' ','--none--'));
        sObjectList.add(new SelectOption('Account','Account'));
        sObjectList.add(new SelectOption('Asset','Asset'));
        sObjectList.add(new SelectOption('Campaign','Campaign'));
        sObjectList.add(new SelectOption('Case','Case'));
        sObjectList.add(new SelectOption('Contact','Contact'));
        sObjectList.add(new SelectOption('Contract','Contract'));
        sObjectList.add(new SelectOption('Idea','Idea'));
        sObjectList.add(new SelectOption('Lead','Lead'));
        sObjectList.add(new SelectOption('Opportunity','Opportunity'));
        sObjectList.add(new SelectOption('Order','Order'));
        sObjectList.add(new SelectOption('Product2','Product2'));
        sObjectList.add(new SelectOption('Solution','Solution'));
        sObjectList.add(new SelectOption('User','User'));
        for(Schema.SObjectType objTyp : gd.Values()){
            String apiName = objTyp.getDescribe().getName();
            string lable = gd.get(apiName).getDescribe().getLabel();
            if(objTyp.getDescribe().isCustom()){
                sObjectList.add(new SelectOption(ApiName,lable));
            }
        }
    }

    // fetch all fileds of selected sobject from page 
    public void fetchFields(){
        ObjFields = new List<SelectOption>();
        SelectedFieldsoptions = new list<SelectOption>();
        if(sobj != ' '){
            show = true;
            removeFields = new List<string>();
            SObjectType sobjType = gd.get(sobj);
		    fieldsMap = sObjType.getDescribe().fields.getMap();
        	for(string fieldName : fieldsMap.keySet()){
                string lable = fieldsMap.get(fieldName).getDescribe().getLabel();
                ObjFields.add(new SelectOption(fieldName,lable));
            }
            ObjFields.sort();
        }
        else {
            show = false;
        }
    }
    
    // create a list of selectoptions of selected fields from page  
    public void add(){
       	for(string apiName : selectedFields){
               string lable = fieldsMap.get(apiName).getDescribe().getLabel();
       		SelectedFieldsoptions.add(new SelectOption(apiName,lable));
       	}
        removeFieldsFromList();
        SelectedFieldsoptions.sort();
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
        for(string restore : removeFields){
            objFields.add(new SelectOption(restore,restore));
        }
        objFields.sort();
    }

    //reset the page to initial stage
    public void reset(){
        sobj = ' ';
        show = false;
    }

    //disable remove button;
    public Boolean getremoveDisable(){
        return selectedFieldsOptions.isEmpty();
    
    }

    //dsable add button
    public Boolean getaddDisable(){
        return objFields.isEmpty();
    }
    public Boolean grtabc(){
        system.debug('get called from action');
        return true;
    }
}
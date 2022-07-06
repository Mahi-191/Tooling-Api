public with sharing class ServerSidePaginationController {
    public static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    public static String lastid ='0';
    public static String firstid ='0';
    public static String baseQuery;
    public static Integer totalRecords;
    
    //fetch objects from org and return api name and label in map
    @AuraEnabled(cacheable = true)
    public static map<string,string> fetchObjects(){
        map<string,string> objects = new map<string,string>();
        String customLable = system.label.Pagination;
        for(SObjectType objTyp : gd.Values()){
            Schema.DescribeSObjectResult filterObj = objTyp.getDescribe();
            if(filterObj.isCustom() || customLable.contains(filterObj.getLabel())){
                objects.put(filterObj.getName(),filterObj.getLabel());
            }
        }   
        return objects;
    }

    // take object and return fields 
    @AuraEnabled(cacheable = true)
    public Static Map<String,String> fetchFields(string sobj){
        map<string,string> objFields = new map<string,string>();
        if(sobj != 'NA'){
            SObjectType sobjType = gd.get(sobj);
            map<String,Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
            for(string fieldName : fieldsMap.keySet()){
                Schema.DescribeFieldResult filterFilds = fieldsMap.get(fieldName).getDescribe();
                if(filterFilds.isSortable() && filterFilds.isAccessible() && filterFilds.isFilterable() && filterFilds.isUpdateable()){
                    objFields.put(filterFilds.getName(),filterFilds.getLabel());
               }
            }
        }
        return objFields;
    }

    //take object and selected fields then made query and get records from database and return Wraped data 
    @AuraEnabled
    public static RecordWrapper fetchRecords(string sobj, List<String> fields, Integer pageSize){
        String countQuery = 'SELECT count() from ' + sobj; 
        totalRecords = Database.countQuery(countQuery);
        baseQuery = String.join(fields,',');
        baseQuery = baseQuery.removeEnd(',');
        baseQuery = 'Select ' +  baseQuery + ' From ' + sobj + ' Order by id LIMIT ' + pageSize ;
        sobject[] recList = Database.query(baseQuery);
        lastid = recList[recList.size()-1].id;
        firstid =recList[0].id;
        RecordWrapper result = new RecordWrapper(totalRecords,recList,lastid,firstid);
        return result;
    }

    // run on any navigation buttons return records according button and PageSize 
    @AuraEnabled
    public static RecordWrapper recordsNextTime(string sobj, List<String> fields, Integer pageSize, integer totalRec, string lstid, string fstid, string button){ 
        baseQuery = String.join(fields,',');
        baseQuery = baseQuery.removeEnd(',');
        baseQuery = 'Select ' +  baseQuery + ' From ' + sobj;
        string finalQuery;
        if(button == 'next'){
            finalQuery = baseQuery +' Where id >\''+ lstid +'\' Order by id asc LIMIT ' + pageSize; 
        }
        else if(button == 'previous'){
            finalQuery = baseQuery +' Where id <\''+ fstid +'\' Order by id desc LIMIT ' + pageSize;
        }
        else if(button == 'last'){
            integer temp = pageSize;
            pageSize = math.mod(totalRec,pageSize);
            if(pageSize ==0){
                pageSize = temp;
            }
            finalQuery = baseQuery +' Order by id desc LIMIT ' + pageSize;
        }
        else{
            finalQuery = baseQuery + ' Order by id LIMIT ' + pageSize ;
        }
        List<sobject> recList = new List<sobject>();

        //to retrive data in descending and reverse order of data
        if(button == 'previous'|| button == 'last'){
            List<sobject> tempForReverse = Database.query(finalQuery);
            for(Integer i = tempForReverse.size()-1; i>=0;i--){
                recList.add(tempForReverse[i]);
            }
        }
        else{
            recList = Database.query(finalQuery);
        }
        lastid = recList[recList.size()-1].id;
        firstId = reclist[0].id;
        RecordWrapper result = new RecordWrapper(totalRec,recList,lastid,firstId);
        return result;
    }

    //return list of wrapper for column attribute of data table 
    @AuraEnabled
    public static List<ColumnAttributes> columnValue(String obj, list<string> fields){
        System.debug(' object is'+ obj + 'fields are '+ fields);
        List<ColumnAttributes> result = new List<ColumnAttributes>();
        SObjectType sobjType = gd.get(obj);
        map<String,Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        for(string fld:fields){
            Schema.DescribeFieldResult filterFilds = fieldsMap.get(fld).getDescribe();
            result.add(new ColumnAttributes(filterFilds.getLabel(),filterFilds.getName(),string.valueOf(filterFilds.getType())));
        }
        system.debug('list of columns ' + result);
        return result;
    }

    // provide stracture for column attribute of data table 
    public class ColumnAttributes{
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String type;
        @AuraEnabled public Boolean sortable;
        public ColumnAttributes(String label,String fieldName,String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            sortable = true;
        }
    }
    
    // make Structure for basic detail to maintain table 
    public class RecordWrapper{
        @AuraEnabled public Integer totalRecords;
        @AuraEnabled public List<SObject> records;
        @AuraEnabled public String last;
        @AuraEnabled public String first;
        public RecordWrapper(Integer totalRecords, List<SObject> records, string last, string first){
            this.totalRecords = totalRecords;
            this.records = records;
            this.last = last;
            this.first =first;
        }
    }
}
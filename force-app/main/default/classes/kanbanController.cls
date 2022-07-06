public with sharing class kanbanController{
    public static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

    //method to return org's objects map of api name and label name  
    @AuraEnabled
    public static map<string,string> fetchobjects(){
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

    // mathod to return fields map of api name and label name of a object
    @AuraEnabled
    public Static Map<String,String> fetchFields(string sobj){
        map<string,string> objFields = new map<string,string>();
        SObjectType sobjType = gd.get(sobj);
        map<String,Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        for(string fieldName : fieldsMap.keySet()){
            Schema.DescribeFieldResult filterFilds = fieldsMap.get(fieldName).getDescribe();
            if(filterFilds.isSortable() && filterFilds.isAccessible() && filterFilds.isFilterable() && filterFilds.isUpdateable()){
                objFields.put(filterFilds.getName(),filterFilds.getLabel());
            }
        }
        System.debug('map of fields is---'+objFields);
        return objFields;
    }
    // mathod to return pickList fields available on a object
    @AuraEnabled
    public Static Map<String,String> fetchpicklist(string sobj){
        map<string,string> objFields = new map<string,string>();
        SObjectType sobjType = gd.get(sobj);
        map<String,Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        for(string fieldName : fieldsMap.keySet()){
            Schema.DescribeFieldResult filterFilds = fieldsMap.get(fieldName).getDescribe();
            system.debug('test of picklist--------'+string.valueOf(filterFilds.getType()));
            if(string.valueOf(filterFilds.getType()) =='PICKLIST' ){
                objFields.put(filterFilds.getName(),filterFilds.getLabel());
           }
        }
        system.debug(objFields);
        return objFields;
    }

    // method to return map of picklist values as key and list of related records 
    @AuraEnabled
    public static Map<String,List<SObject>> getRecords(String sobj, String field, List<string> selectedFields){
        Map<String,List<SObject>> result = new Map<String,List<SObject>>();
        List<String> types = new List<String>{sobj};
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for(Schema.PicklistEntry entry : res.fields.getMap().get(field).getDescribe().getPicklistValues()) {
                if(entry.isActive()) {
                    result.put(entry.getValue(),new List<SObject>());
                }
            }
        }
        String query = String.join(selectedFields,',');
        if(selectedFields.contains(field)){
            query = 'SELECT '+ query + ' FROM ' + sobj +' WHERE ' + field +' != null';
        }
        else{
            query = 'SELECT '+ query +','+ field + ' FROM ' + sobj +' WHERE ' + field +' != null';
        }
        System.debug('Query is    -  '+ query);
        List<SObject> records = Database.query(query);
        for(SObject obj: records){
            result.get(String.valueOf(obj.get(field))).add(obj);
        }
        System.debug('map is ----'+result);
        return result;
    }

    // method to update records picklist value
    @AuraEnabled
    public static Boolean updaterecord(String field, Id recId, String fieldVal){
        SObject sObjectRecord = recId.getSObjectType().newSObject(recId);
        sObjectRecord.put(field, fieldVal);
        update sObjectRecord;
        return true; 
    }
}
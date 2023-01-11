public with sharing class ClientSidePagination {

    //Total Records Size
    @AuraEnabled(cacheable = true)
    public static Integer totalRecords(String objName) 
    { 
        String query = 'SELECT Count() from '+objName;
        Integer totalRec = Database.countQuery(query);
        return totalRec;
    }  
    
    //Wrapper For Columns Show
    @AuraEnabled(cacheable = true)
    public static List<ColunmWrapper> columnValue(String objName, List<String> fieldList){
        List<ColunmWrapper> wrapList = new List<ColunmWrapper>();
        if(objName != null){
            Map<String, Schema.SObjectField> sObjectfields = Schema.getGlobalDescribe().get(objName).getDescribe().SObjectType.getDescribe().fields.getMap();
            for(Schema.SObjectField field : sObjectfields.values())            {                 
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                    
                if(fieldResult.isAccessible() && fieldResult.isCreateable() && fieldResult.isSortable() ){   
                    if(fieldList.contains(field.getDescribe().getName())){
                        ColunmWrapper myWrap = new ColunmWrapper();    
                        myWrap.fieldLabel = field.getDescribe().getLabel();  
                        myWrap.fieldApi = field.getDescribe().getName(); 
                        myWrap.type = String.valueOf(field.getDescribe().getType()); 
                        myWrap.sortable = true;
                        wrapList.add(myWrap); 
                        
                    }
                }
            }
        }            
        return wrapList;
    }
    
    // return list of records of given object 
    @AuraEnabled(cacheable = true)
    public static List<sObject> fetchRecords(String objName, List<String> fieldList) {
        string query = String.join(fieldList,',');
        query = query.removeEnd(',');
        String queryRec = 'SELECT '+query+' FROM '+objName+' ORDER BY Id';
        List<sObject> sObjectList = Database.query(queryRec);
        return sObjectList;
    }

    @AuraEnabled
    public static Boolean deleteRecord(String recId){ 
        Database.Delete(recId);
        return true;
    }
    
    //Colum Variable Store
    public class ColunmWrapper{
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldApi;
        @AuraEnabled public String type;
        @AuraEnabled public boolean sortable;
    }
}
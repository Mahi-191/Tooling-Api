public with sharing class LazyLoadingController {

   //fetch colum and records list
   @AuraEnabled
   public static DynamicWrapper showFieldDynamically(String objName, String query, String lastId) 
   {        
       DynamicWrapper finalData = new DynamicWrapper();
       finalData.fieldsMap = new Map<string,string>();
       List<String> fieldList = query.split(',');
       if(!objName.equals(''))
       {
           Map<String, Schema.SObjectField> sObjectfields = Schema.getGlobalDescribe().get(objName).getDescribe().SObjectType.getDescribe().fields.getMap();
           for(Schema.SObjectField field : sObjectfields.values())            
           {      
               Schema.DescribeFieldResult fieldResult = field.getDescribe();                    
               if(fieldResult.isAccessible() && fieldResult.isCreateable() && fieldResult.isSortable() )                
               {   
                   if(fieldList.contains(field.getDescribe().getName()))
                   {
                        finalData.fieldsMap.put(field.getDescribe().getName(),field.getDescribe().getLabel());
                   }
               }
           }
           if(fieldList.contains('Id')){
            finalData.fieldsMap.put('Id','Id');
           }
       }  
        System.debug(finalData.fieldsMap);
       string queryString = 'SELECT '+query+' FROM ' + objName;
        if(lastId =='0'){
            queryString += ' Order by Id asc LIMIT 20'; 
        }
        else{
            queryString += ' Where id >\''+ lastId +'\' Order by Id asc LIMIT 20'; 
        }
       System.debug(queryString);
       finalData.recordList =  Database.query(queryString);
       System.debug(finalData.recordList);
       finalData.totalRecords = Database.countQuery('SELECT Count() from '+objName); 
       finalData.lastId = finalData.recordList[finalData.recordList.size()-1].Id;
        System.debug(finalData.lastId);
       System.debug('Final data '+finalData);
       return finalData;
   }
   
   public class DynamicWrapper
   {
       @AuraEnabled public Map<string,string> fieldsMap;
       @AuraEnabled public List<sObject> recordList;
       @AuraEnabled public Integer totalRecords;  
       @AuraEnabled public String lastId;
    }   
}
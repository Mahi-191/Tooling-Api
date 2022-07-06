public with sharing class MultiSelectComboboxController {
    @AuraEnabled
    public static List<SObject> getData(string Sobj, String searchkey){
        string query;
        System.debug(sobj+'object  '+searchkey+'serach key');
        if(searchkey == null){
            query ='SELECT Id, Name FROM '+ Sobj +' LIMIT 50';
        }
        else{
            query = 'SELECT Id, Name FROM '+ Sobj + ' Where Name LIKE \'' + searchkey + '%\' LIMIT 50';
        }
        System.debug(query);
        try{
            System.debug(database.query(query));
            return database.query(query);
        }
        catch (Exception e){
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}
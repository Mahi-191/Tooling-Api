public with sharing class getCaseRecords {
    @AuraEnabled
    public static List<Case> getCases(){
        return [SELECT id, CaseNumber FROM Case];
    }
}
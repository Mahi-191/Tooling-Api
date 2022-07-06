public with sharing class ToolingApiWrapper {
	@AuraEnabled public list<cls_sobjects> sobjects;
	class cls_sobjects {
		@AuraEnabled public String label;	
		@AuraEnabled public String labelPlural;
		@AuraEnabled public String name;	
		@AuraEnabled public boolean queryable;
    }
    @AuraEnabled public cls_records[] records;
	class cls_records {
		@AuraEnabled public cls_attributes attributes;
		@AuraEnabled public String Id;	
		@AuraEnabled public String Name;	
	}
	class cls_attributes {
		@AuraEnabled public String type;	
		@AuraEnabled public String url;	
	}

}

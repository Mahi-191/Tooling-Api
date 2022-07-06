public with sharing class BoxWrapper {
    public class tokens{
		@AuraEnabled public String refresh_token;
		@AuraEnabled public String issued_token_type;
		@AuraEnabled public Integer expires_in;
		@AuraEnabled public String token_type;
		@AuraEnabled public String access_token;
    }
    public class allData {
        @AuraEnabled public item_collection item_collection;
    }
    public class item_collection {
        @AuraEnabled public list<entries> entries;
        //@AuraEnabled public Integer total_count;
    }
    public class entries{
        @AuraEnabled public String etag;
        @AuraEnabled public String sequence_id;
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String type;
    }
}
trigger associatOP on Opportunity (after update, after insert) {
    opportunitytriggerClass.checkStatus(trigger.new);
}
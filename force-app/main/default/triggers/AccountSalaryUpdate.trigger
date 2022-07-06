trigger AccountSalaryUpdate on Account (before insert, before update) {
    AccountSalaryTriggerClass.updateGrossSalary(Trigger.new);
}
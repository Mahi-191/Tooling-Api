public class ContactStatusUpdatescheduler implements schedulable {
  //execute method of Scheduler which executes Batch  
	public void execute(SchedulableContext sc){
    ContactStatusUpdate csu = new ContactStatusUpdate(); 
      database.executebatch(csu);
    } 
}
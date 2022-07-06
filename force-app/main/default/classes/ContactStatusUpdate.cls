public class ContactStatusUpdate implements Database.Batchable<SObject>, Database.StateFul {
    public List<Contact> contacts = new List<Contact>(); //to store records for CSV
  
    // Start Method of batch returns contact records of yesterday where status field is not Ready for Approval
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Status__c, CreatedDate, Birthdate, Temp__c, Description FROM Contact WHERE CreatedDate = YESTERDAY AND Status__c != \'Ready for Approval\'');
        //return Database.getQueryLocator('SELECT Status__c, CreatedDate, Birthdate, Temp__c, Description FROM Contact');
    }

    //Execute Method get list of records from start and Update there Status to ready for Approval
    Public void execute(Database.BatchableContext bc, List<Contact> conList){

        for(Contact con: conList){
            con.Status__c = 'Ready for Approval';
            contacts.add(con);
        }
		update conList;
    }

    //Finish method 
    public void finish(Database.BatchableContext bc){
    
        if(contacts.size()>0){    
            // Make a CSV String of processed Records with 4 Fields    
            List<String> fields = new List<String>{'CreatedDate','Birthdate','Temp__c','Description'};
            string stringCSV = '"Created Date","Birthdate","Checked","Description" \n';
            String temp = '';
            for(contact con : contacts){
                for(string fld : fields){
                    temp = String.valueOf(con.get(fld));
                    if(temp!=null){
                        stringCSV = stringCSV +'"'+ temp +'"';
                    }
                    else{
                        stringCSV += '" "';
                    }
                    stringCSV += ',';
                }
                stringCSV = stringCSV.removeEnd(',');
                stringCSV +='\n';
            }

            // Created a Attachment for Mail with CSV String 
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            Blob csvBlob = blob.valueOf(stringCSV);
            csvAttachment.setFileName('UpdatedContacts.csv');
            csvAttachment.setBody(csvBlob);
            csvAttachment.setContentType('text/csv');
            
            // Creat And Send mail
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'mahendra@briskminds.com'});
            mail.setSubject('Contact Status Update Batch Process completed');
            mail.setPlainTextBody('contact records inserted last day are ready for approval please finde the attachment');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
    
            messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail} );
        }
    }
}
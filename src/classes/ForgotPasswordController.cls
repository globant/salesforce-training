global class ForgotPasswordController {

    public ForgotPasswordController() {
    }
    
    public String email{get; set;}
    
    private User__c findUserByEmail(String userEmail){
      list<User__c>  userList = [SELECT Id, User__c.Email__c, User__c.Password__c FROM User__c WHERE User__c.Email__c = :userEmail.trim()  LIMIT 1]; 
        if(userList != null && userList.size() > 0 ){
           return userList[0];
        } else {
			return null;            
        }

    }
    
    public PageReference sendEmail() {
       User__c user =  findUserByEmail(email);
        if(user  != null){
            doSendEmail(user);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please go to your email box account!');
            ApexPages.addMessage(msg);
            return null;
        } else {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The email does not exist!');
            ApexPages.addMessage(msg);   
            return null;
        }
         
         return null;
     }
    
    public void doSendEmail(User__c user) {
           try {

              Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
              OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ignacio.gonzalez@globant.com'];
              message.setToAddresses(new String[] {
                 user.Email__c
              });

              message.setOrgWideEmailAddressId(owea.get(0).Id);
              message.setEmailPriority('High');
              message.setSubject('Hi this is your password');
              // We can also just use an id for an implicit to address
              message.setPlainTextBody('This is your password ' + user.Password__c);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
           } catch (Exception ce) {
              ce.getMessage();
           }
}
}
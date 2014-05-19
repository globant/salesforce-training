public with sharing class CompleteSurveyController {

        public CustomUser__c customUser {get; set;}
        public Survey__c survey {get; set;}
        public String code {get; set;}
        public String country {get; set;}
        public List<Question> questionListAux {get; set;}
        public SurveyAnswer__c surveyAnswer {get; set;}
        
        public CompleteSurveyController(){
                
                code = ApexPages.currentPage().getParameters().get('code');
        
                List<SurveyAnswer__c> result = [SELECT Id, 
                                                CustomUser__r.Id, 
                                                Survey__r.Id, 
                                                Completed__c,
                                                DateCompleted__c,
                                                Discount__c 
                                                FROM SurveyAnswer__c WHERE Code__c =: code];
                if (result.size() > 0){
                        //Get surveyAnswer
                        surveyAnswer = result.get(0);
                        
                        //Get customUser
                        List<CustomUser__c> usersList = [select Id, First_Name__c, Last_Name__c from CustomUser__c WHERE Id =: surveyAnswer.CustomUser__r.Id];
                        if (usersList.size() > 0){
                                customUser = usersList.get(0);
                        }
                        
                        //Get survey
                        List<Survey__c> surveyList = [SELECT Id, Title__c, Description__c, 
                                                                Discount__c, Shop__r.Id, Shop__r.Name
                                                               FROM Survey__c WHERE Id =: surveyAnswer.Survey__r.Id];
                        if (surveyList.size() > 0){
                                survey = surveyList.get(0);
                                List<Question__c> questionList = [SELECT Id, Text__c, Type__c
                                                      FROM Question__c WHERE Survey__r.Id =: survey.Id ORDER BY Name];
                                
                                questionListAux = new List<Question>();
                                Integer i = 0;
                                for (i = 0; i< questionList.size(); i++){
                                    Question__c q = questionList.get(i);
                                    Question qAux = new Question(q.Id, q.Text__c, q.Type__c, survey.Id);
                                    questionListAux.add(qAux);
                                }
                                
                        }
                }
                
        }
        
        class Question{
            public Id questionId {get; set;}
            public String text {get; set;}
            public String type {get; set;}
            public List<SelectOption> optionList {get; set;}
            public String answer {get; set;}
            private String surveyId {get; set;}
            public String [] answers {get; set;}
            public Question(Id qId, String qText, String qType, String sId){
                questionId = qId;
                text = qText;
                type = qType;
                optionList = new List<SelectOption>();
                answer = '';
                surveyId = sId;
                answers = new String[]{};
                loadOptionList();
            }
            
            public List<SelectOption> loadOptionList()
            {
                List<Option__c> auxList = [SELECT Id, Question__r.Id, Survey__c, Text__c FROM Option__c WHERE Survey__c =: surveyId];
                if (auxList.Size() >0)
                {
                    for(Option__c c:auxList)
                    {
                        if (c.Question__r.Id == questionId && c.Text__c != null && c.Id != null)
                            optionList.add(new SelectOption(c.Id, c.Text__c));
                    }
                }
               
                return optionList;
            }
        }
        
        public PageReference save(){
        
            surveyAnswer.Completed__c = true;
            surveyAnswer.DateCompleted__c = Date.TODAY();
            upsert surveyAnswer;
            
            for (Question q: questionListAux){
                
                if (q.Type == 'Text'){
                    CreateTextAnswer(q.questionId, surveyAnswer.Id, q.answer);
                }else{
                    if (q.Type == 'Radio'){
                        CreateRadioAnswer(q.questionId, surveyAnswer.Id, q.answer);
                    }else if(q.Type == 'Checkbox'){
                        CreateCheckAnswer(q.questionId, surveyAnswer.Id, q.answers);
                    }
                }
             }
            
            Pagereference completedsurvey = Page.CompletedSurvey;
            completedsurvey.getParameters().put('code',code);
            completedsurvey.setRedirect(true);
            return completedsurvey; 
        }
        
        private void CreateTextAnswer(Id qId, Id sId, String text){
            Answer__c newAnswer = new Answer__c();
            newAnswer.Option__c = null;
            newAnswer.Question__c = qId;
            newAnswer.SurveyAnswer__c = sId;
            newAnswer.Text__c = text;
            insert newAnswer;
        }
        private void CreateRadioAnswer(Id qId, Id sId, String answer){
            Answer__c newAnswer = new Answer__c();
            System.debug('answer '+answer);
            List<Option__c> auxList = [SELECT Id from Option__c WHERE Id=:answer];
            newAnswer.Option__c = auxList.get(0).Id;
            newAnswer.Question__c = qId;
            newAnswer.SurveyAnswer__c = sId;
            insert newAnswer;
        }
        private void CreateCheckAnswer(Id qId, Id sId, String[] answers){
            for (String answer:answers){
                Answer__c newAnswer = new Answer__c();
                List<Option__c> auxList = [SELECT Id from Option__c WHERE Id=:answer];
                newAnswer.Option__c = auxList.get(0).Id;
                newAnswer.Question__c = qId;
                newAnswer.SurveyAnswer__c = sId;
                insert newAnswer;
            }
        }

}
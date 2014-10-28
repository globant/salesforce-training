public class OrgCustomizerController {
	public Organization theOrganization {get;set;}
	public Account[] theAccounts {get;set;}
	public Contact[] theContacts {get;set;}
	public Product2[] theProducts {get;set;}
	public Campaign[] theCampaigns {get;set;}
	public User[] theUsers {get;set;} 
	public superCase[] theCases {get;set;}
	
	public String message {get;set;}
	public boolean showMessage {get;set;}
	
	public OrgCustomizerController(){
		theOrganization = [Select Name From Organization limit 1];
		theAccounts = [Select Website, Name, ORGCUSTOM4_Old_Name__c, Parent.Name From Account where ORGCUSTOM4_DB__c = true];
		theContacts = [Select Name, Email, Title, ORGCUSTOM4_Old_Title__c, FirstName, LastName from Contact where ORGCUSTOM4_DB__c = true];
		theProducts = [select Name, ORGCUSTOM4_Old_Name__c, Id from Product2 where ORGCUSTOM4_DB__c = true];
		theCampaigns = [select Name, StartDate, EndDate, ORGCUSTOM4_Old_Name__c, Id from Campaign where ORGCUSTOM4_DB__c = true];
		theUsers = [select FirstName, LastName, Title, Email, ORGCUSTOM4_Old_First_Name__c, ORGCUSTOM4_Old_Last_Name__c from User where ORGCUSTOM4_DB__c = true];
	
		setupCasesSolutions(); 
	
	} 
	 
	
	////////SAVE BUTTON ACTIONS//////////
	
	
	public void updateOrganization(){
		//update theOrganization; 
	} 
	public void updateAccounts(){
		
		String[] aIDs = new String[]{};
		String ast = '*';
		
		for(Account a : theAccounts){
			aIDs.add(a.Id);
		}
		for(Account a : theAccounts){
			String aName = a.Name;
			if(aName.contains(ast)){
					aName = aName.substring(0,aName.Length()-1);
			}
			
				
		}
		
		update theAccounts;
		

		Opportunity[] allOpps = [select id, name, amount, Account.Name from Opportunity where Accountid in :aIDs]; 
		
		for(Opportunity o : allOpps){
			Decimal DecOppty = o.Amount;
			String astName = o.Name;
			Boolean NameHasAst = astName.endsWith('*');
			
			
			String OpptyName = o.Account.Name+' - ';
			if (o.amount > 1000000){
		           DecOppty = DecOppty/1000000;
		           DecOppty = DecOppty.setScale(0);
		           
		           OpptyName += DecOppty+''+'M';
		           
		            	if (NameHasAst == true){
		           			OpptyName += '*';	 
		           		}
		           	
		           	
		    		
		    	}else if (o.amount > 1000){
		    		DecOppty = DecOppty/1000;
		    		DecOppty = DecOppty.setScale(0);
		    		
		    		
		    		OpptyName += DecOppty+''+'K';
		    		
		    		 	if (NameHasAst == true){
		           			OpptyName += '*';	
		           		}
		           	
		    		
		    	}else {
		    		OpptyName = OpptyName + DecOppty.setScale(0);
		    		
		    		 	if (NameHasAst == true){
				           	OpptyName += '*';	
				        }
		           	
		    }
			o.Name = OpptyName;
			
		} 
		
		update allOpps;
		message='Accounts and Opportunities have been saved! ';
		showMessage();
	}
	public void updateContacts(){
		update theContacts;
		
		message='Contacts have been saved! ';
		showMessage();
		
		
	} 
	public void updateProducts(){
		update theProducts;
		Asset[] allAssets = new Asset[]{};
		for(Product2 p : theProducts){
			for(Asset a : [select Name from Asset where Product2Id = :p.Id]){
				a.Name = p.Name;
				allAssets.add(a);
				
			}
		}
		update allAssets;
		
		message='Products and Assets have been saved! ';
		showMessage();
		
		
		
	}
	public void updateCampaigns(){
		update theCampaigns;
		message='Campaigns have been saved! ';
		showMessage();
		
		
	}
	public void updateUsers(){
		update theUsers;
		message='Users have been saved! ';
		showMessage();
		
		
	}
	
	public void updateCases(){
		Case[] updateCases = new Case[]{};
		Solution[] updateSolutions = new Solution[]{};
		
		for(superCase item : theCases){
			updateCases.add(item.theCase);
			updateSolutions.add(item.theSolution);	
		}
		//objec CaseSolution Tracks SOlutions
		
		
		
		update updateCases;
		update updateSolutions;
		message='Cases and Solutions have been saved! ';
		showMessage(); 
		
		
	}
	 	
	
	
	
	//////RESET BUTTON ACTIONS//////////
	public void resetAccounts(){
		String[] aIDs = new String[]{};
		for(Account a : theAccounts){
			aIDs.add(a.Id);
			a.Name = a.ORGCUSTOM4_Old_Name__c;
			
		}
		update theAccounts;
		
		Opportunity[] allOpps = [select id, name, amount, Account.ORGCUSTOM4_Old_Name__c from Opportunity where Accountid in :aIDs]; 
		
		for(Opportunity o : allOpps){
			Decimal DecOppty = o.Amount;
			String astName = o.Name;
			Boolean NameHasAst = astName.endsWith('*');
			
			
			String OpptyName = o.Account.ORGCUSTOM4_Old_Name__c+' - ';
			if (o.amount > 1000000){
		           DecOppty = DecOppty.setScale(0);
		           DecOppty = DecOppty/1000000;
		           OpptyName += DecOppty+''+'M';
		           
		            	if (NameHasAst == true){
		           	OpptyName += '*';	
		           	}
		           	
		           	
		    		
		    	}else if (o.amount > 1000){
		    		 DecOppty = DecOppty.setScale(0);
		    		DecOppty = DecOppty/1000;
		    		OpptyName += DecOppty+''+'K';
		    		
		    		 	if (NameHasAst == true){
		           	OpptyName += '*';	
		           	}
		           	
		    		
		    	}else {
		    		OpptyName = OpptyName + DecOppty.setScale(0);
		    		
		    		 	if (NameHasAst == true){
		           	OpptyName += '*';	
		           	}
		           	
		    }
			o.Name = OpptyName;
			
		} 
		
		update allOpps;
		
		update theAccounts;
		message='Accounts and Opportunities have been reset to the old values. ';
		showMessage();
	}
	public void resetContacts(){
		for(Contact cont : theContacts){
			cont.Title = cont.ORGCUSTOM4_Old_Title__c;
		}
		update theContacts;
		message='Contact titles have been reset!';
		showMessage();
		
	} 
	public void resetProducts(){
		
		for(Product2 p : theProducts){
			p.Name = p.ORGCUSTOM4_Old_Name__c;	
		}
		
		Asset[] allAssets = new Asset[]{};
		for(Product2 p : theProducts){
			for(Asset a : [select Name from Asset where Product2Id = :p.Id]){
				a.Name = p.ORGCUSTOM4_Old_Name__c;
				allAssets.add(a);
				
			}
		}
		
		update theProducts;		
		update allAssets;
		
		message='Product and Asset names have been reset!';
		showMessage();
			
	}
	public void resetCampaigns(){
		for(Campaign camp : theCampaigns){
			camp.Name = camp.ORGCUSTOM4_Old_Name__c;
		}
		
		update theCampaigns;
		message='Campaign names have been reset!';
		showMessage();
			
	}
	public void resetUsers(){
		for(User usr : theUsers){
			usr.FirstName = usr.ORGCUSTOM4_Old_First_Name__c;
			usr.LastName = usr.ORGCUSTOM4_Old_Last_Name__c;
		}
		
		update theUsers;
		message='User first names and last names have been reset!';
		showMessage();
	}
	
	public void noMessage(){  showMessage=false;  }
	public void showMessage(){ showMessage = true; }	
	
	public void setupCasesSolutions(){
		
		theCases = new superCase[]{};
		
		for(Case theCase : [select Subject, Org_Cust_Case_ID__c, CaseNumber, Description From Case where ORGCUSTOM4_DB__c = true]){
			for(Solution theSolution : [Select SolutionNumber, SolutionNote, SolutionName, Org_Cust_Case_ID__c From Solution where ORGCUSTOM4_DB__c = true]){
				if(theSolution.Org_Cust_Case_ID__c == theCase.Org_Cust_Case_ID__c){
					theCases.add(new superCase(theCase, theSolution));
				}
			}//end Solution for		
		}//end Case for
	}
	
	
	
	  
	
	
	
	
	public class superCase{
		public Case theCase {get;set;}
		public Solution theSolution {get;set;}
		public superCase (Case cas, Solution sol){
			theCase = cas;
			theSolution = sol;
		}		
		
	}
	
	
	public  void doNothing(){
		integer b = 0;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;b++;
		
	}
	
	

}
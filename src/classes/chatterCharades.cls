public with sharing class chatterCharades {

    public string parentURL{get;set;}
    public string parentID{get;set;}
    public string poster{get;set;}
    public string target{get;set;}
    public boolean validObj{get;set;}
    public string body{get;set;}
    public string tabPicked{get;set;}
    public string tabPicked2{get;set;}
    public string linkURL{get;set;}
    public string linkTitle{get;set;}
    public string filename{get;set;}
    public blob file{get;set;}
    public string objName{get;set;}
    public string op{get;set;}
    public Schema.SObjectType obj{get;set;}
    public string cposter{get;set;}
    public string commentbody{get;set;}
    
    public chatterCharades(){
        commentbody= '';
        cposter = '';
        filename= null;
        file = null;
        op = ApexPages.currentPage().getParameters().get('op');
                
        tabPicked2='link';
        parentURL = ApexPages.currentPage().getparameters().get('p');
        parentID = ApexPages.currentPage().getParameters().get('p');
        if(parentID == null) parentID = 'x';
        parentID = parentID.substring(parentID.lastIndexOf('/')+1);
        
        poster = ''; 
        target=parentID;
        
        body = '';
        string prefix;
        if(parentID.length()<3) prefix=parentid;
        else prefix = parentID.substring(0,3);
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<string> objNames = gd.keySet();
        Map<string,Schema.SObjectType> chatterObjs = new Map<string, Schema.SObjectType>();
        
        for(string n : objNames)
        {
            if(n.endsWith('feed') && n != 'newsFeed' && n != 'userProfileFeed')
            {
                if(n.endsWith('__feed'))
                {
                    if(gd.get(n.substring(0,n.length()-4)+'c') != null)
                        chatterObjs.put(gd.get(n.substring(0,n.length()-4) + 'c').getDescribe().getKeyPrefix(), gd.get(n.substring(0,n.length()-4)+'c'));
                    else
                        chatterObjs.put(gd.get(n.substring(0,n.length()-4) + 'ka').getDescribe().getKeyPrefix(), gd.get(n.substring(0,n.length()-4)+'ka'));
                }
                else
                    chatterObjs.put(gd.get(n.substring(0,n.length()-4)).getDescribe().getKeyPrefix(), gd.get(n.substring(0,n.length()-4)));
                    
            }
        }
        if(chatterObjs.get(prefix) == null)
        {       
            validObj = false; 
            objName = 'Disabled'; 
        }
        else
        {
            validObj = true;
            objName = chatterObjs.get(prefix).getDescribe().getLabel();
            obj = chatterObjs.get(prefix);
        }
        if(validObj)
            tabPicked='obj';
        else
            tabPicked='user';
        
    }
    
      
    public List<SelectOption> getuserList(){
        List<User>uList;
        try{
        ulist = database.query('select id, name from User where isPortalEnabled = false and usertype != \'Guest\' and isActive = true order by name asc');
        }
        catch(exception e)
        {
        ulist = database.query('select id, name from User where isActive = true and usertype != \'Guest\' order by name asc');  
        }
        List<SelectOption> retList = new List<SelectOption>();
        for(User u : ulist)
        {
            retlist.add(new selectOption(u.id, u.name));
        }
        return retlist;
    }
    
    public List<SelectOption> getGroupList(){
        List<CollaborationGroup> glist = [select id, name from CollaborationGroup order by name asc];
        List<SelectOption> retList = new List<SelectOption>();
        for(CollaborationGroup u : glist)
        {
            retlist.add(new selectOption(u.id, u.name));
        }
        return retlist;
    }
    
    
    public pageReference submitPost(){
        FeedPost fp = new FeedPost();
        fp.createdByID = poster;
        if(tabPicked == 'obj')
            fp.parentID = parentID;
        else
            fp.parentID = target;
        fp.body = body;
        
                
        insert fp;
        
        return new pageReference(parentURL);
    }
    
    public pageReference complexPost(){
        FeedPost fp = new FeedPost();
        fp.createdByID = poster;
        if(tabPicked == 'obj')
            fp.parentID = parentID;
        else
            fp.parentID = target;
        fp.body = body;
        
        if(tabPicked2 == 'link' && linkurl != null && linktitle != null)
        {
            fp.linkurl = linkurl;
            fp.title = linktitle;
            insert fp;
        }
        else if(tabPicked2 == 'content' && filename!= null && file != null)
        {
            fp.ContentFileName = filename;
            fp.ContentData = file;
            insert fp;
        }
        return new pageReference(parentURL);
    }
    
   
    
    
    public static testmethod void doTests(){
        ApexPages.currentPage().getParameters().put('p', '/home/home.jsp');
        ChatterCharades cc = new ChatterCharades();
        
        ApexPages.currentPage().getParameters().put('p', '/' + [select id from Account limit 1].id);
        cc = new ChatterCharades();
        cc.getGroupList();
        
        cc.getuserList();

        List<User> uList;
         try{
        ulist = database.query('select id, name from User where isPortalEnabled = false and usertype != \'Guest\' and isActive = true order by name asc');
        }
        catch(exception e)
        {
        ulist = database.query('select id, name from User where isActive = true and usertype != \'Guest\' order by name asc');  
        }
        
        cc.poster = uList[0].id;
        cc.body = 'body';
        cc.tabPicked = 'user';
        cc.submitPost();
        cc.tabPicked2 = 'link';
        cc.linkurl = 'www.googlz.com';
        cc.linktitle='googlez';
        cc.complexPost();

    }
    
    
    
}
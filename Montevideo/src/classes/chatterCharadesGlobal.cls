global class chatterCharadesGlobal {
  webservice static list<string> getGoodUsers(){
    List<User> ulist;
    try{
      ulist = database.query('select id, name from User where isPortalEnabled = false and usertype != \'Guest\' and isActive = true order by name asc');
    }
    catch(exception e)
    {
    ulist = database.query('select id, name from User where isActive = true and usertype != \'Guest\' order by name asc');  
    }
    
    list<string> retlist = new list<string>();
    
    for(User u : uList)
    {
      retlist.add(u.id + '-' + u.name);
    }
    return retlist;
  }
  webservice static void postComment(string poster, string op, string body){
    FeedComment fc = new FeedComment();
    fc.createdByID = poster;
    fc.feeditemid = op;
    fc.commentbody = body;
    insert fc;
  }
}
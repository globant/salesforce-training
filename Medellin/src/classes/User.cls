Public class User{

    private static User__c Usuario;
    private static SessionData__c Sesion;

    public static String DNIc {get{
                            if (Usuario != null)
                                 {return String.valueOf(Usuario.DNI__c);}
                            else {return null;}
                           }
                     }

    public User(String UserEmail){
        Usuario = [select id,name,DNI__c,Email__c from User__c where Email__c=:UserEmail];
    }

    public static Boolean DropSession(ID SessionID)
    {

        Boolean result = False;

        if(SessionID != null)
        {
            if (SessionData__c.getAll().containsKey(SessionID))
            {
                Sesion = SessionData__c.getInstance(SessionID);
                Database.delete(Sesion);
                result = true;
            }
        }      

        return result;
    }

    public static ID getSession(String UserEmail){

        ID SessionID;

        if(UserEmail.length() > 0)
        {
            Usuario = [select id,name,DNI__c,Email__c from User__c where Email__c=:UserEmail];

            if(Usuario != null)
            {
                Sesion = new SessionData__c();
                Sesion.Name         = Usuario.Email__c;
                Sesion.UserDNI__c   = Usuario.DNI__c;
                Sesion.UserEmail__c = Usuario.Email__c;
                Database.SaveResult DBresult = Database.insert(Sesion);

                Sesion.Name         = Sesion.id;

                DBresult = Database.update(Sesion);
                SessionID = DBresult.getID();
            }
        }

        return SessionID;
    }


    public static String getSession(ID SessionID){

        String result;

        if(SessionID != null)
        {

            if (SessionData__c.getAll().containsKey(SessionID))
            {
                Sesion = SessionData__c.getInstance(SessionID);
                result = String.valueOf(Sesion.UserDNI__c);

                Usuario = [select id,name,DNI__c,Email__c from User__c where Email__c=:Sesion.UserEmail__c];
            }
        }

        return result;
    }
}
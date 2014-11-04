Public class User{

    private static User__c Usuario;
    private static SessionData__c Sesion;


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
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'E-Mail ' + UserEmail + ' is not Registered.');
                ApexPages.addMessage(msg);
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
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Session not Found.');
                ApexPages.addMessage(msg);
            }
        }

        return result;
    }

    public static User__c getUserObject(ID SessionID){

        if(SessionID != null)
        {

            if (SessionData__c.getAll().containsKey(SessionID))
            {
                Sesion = SessionData__c.getInstance(SessionID);

                Usuario = [select id,name,DNI__c,Email__c from User__c where Email__c=:Sesion.UserEmail__c];

                if(Usuario != null)
                {
                    return Usuario;
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'User with E-Mail ' + Sesion.UserEmail__c + ' Doesn\'t Exists.');
                    ApexPages.addMessage(msg);
                }
            }
        }

        return null;
    }

    public static String getDni(PageReference page){
        Cookie cookie = page.getCookies().get('session');
        if (cookie != null) {
             return User.getSession(Id.valueOf(cookie.getValue()));
        }
        return null;
    }
}
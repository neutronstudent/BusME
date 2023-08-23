
//define user object
namespace BusMEAPI
{
    public class User
    {

        public int ID;
        //user type enumerator 
        public static enum UserType
        {
            User = 0,
            Admin = 1,
        }


        //define user varaibles
        public String? name;
        public String  username = "";
        public String? email;
        public String? phone;

        //type of user
        public UserType userType;


        //define generic user constructor
        public User(int ID, String username, String? name, String? email, String? phone)
        {
            this.ID = ID;
            this.username = username;
            this.name = name;
            this.email = email;
            this.phone = phone;
        }
    }
}

//define user object
namespace BusMEAPI
{
    public class User
    {

        public int Id;
        //user type enumerator 
        public enum UserType
        {
            User = 0,
            Admin = 1,
        }


        //define user varaibles
        public String Name;
        public String Username;
        public String Email;
        public String Phone;

        //type of user
        public UserType Type;


        //define generic user constructor
        public User(int ID, String username, String name, String email, String phone, int Type)
        {
            this.Id = ID;
            this.Username = username;
            this.Name = name;
            this.Email = email;
            this.Phone = phone;
            this.Type = (UserType)Type;
        }

        public User(int ID, String username, String name, String email, String phone, UserType Type)
        {
            this.Id = ID;
            this.Username = username;
            this.Name = name;
            this.Email = email;
            this.Phone = phone;
            this.Type = Type;
        }
    }
}

using System.Text.Json;
using System.Text.Json.Serialization;

//define user object
namespace BusMEAPI
{
    public class User
    {

        public int Id { get; set; }
        //user type enumerator 
        public enum UserType
        {
            None,
            User,
            Admin,
        }


        //define user varaibles
        public String Name { get; set; }
        public String Username { get; set; }
        public String Email { get; set; }
        public String Phone { get; set; }

        //type of user
        public UserType Type { get; set; }


        //define generic user constructor
        public User(int ID, String username, String name, String email, String phone, UserType Type)
        {
            this.Id = ID;
            this.Username = username;
            this.Name = name;
            this.Email = email;
            this.Phone = phone;
            this.Type = (UserType)Type;
        }

        public User()
        {
            this.Id = 0;
            this.Username = "";
            this.Name = "";
            this.Email = "";
            this.Phone = "";
            this.Type = UserType.None;
        }


    }
}
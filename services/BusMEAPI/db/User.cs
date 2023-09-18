
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


        public String Username { get; set; }
        public UserDetails Details {get; set;}
        public UserSettings? Settings {get; set;}
        //type of user
        public UserType? Type { get; set; } = 0;


        //Password and salt sequences
        [JsonIgnore]
        public String Hash {get; set;} = "";
        
        [JsonIgnore]
        public String Salt {get; set;} = "";
    }
    
    public class UserSettings
    {
        int Id {get; set;}
        int? notf_type {get; set;}
        public int RouteId {get; set;}
    }


    public class UserDetails
    {
        int id {get; set;}
                //define user varaibles
        public String Name { get; set; }
        public String Email { get; set; }
        public String Phone { get; set; }
    }
}
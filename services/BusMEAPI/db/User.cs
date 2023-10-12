
using System.ComponentModel.DataAnnotations;
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

        //public int DetailsId {get; set;}
        //public int DetailsId {get; set;}
        public UserDetail Details {get; set;}


        //public int SettingsId {get; set;}
        
        //public int SettingsId {get; set;}
        public UserSettings? Settings {get; set;}
        //type of user
        public UserType? Type { get; set; } = 0;


        //Password and salt sequences
        [JsonIgnore]
        public String Hash {get; set;} = "";
        
        [JsonIgnore]
        public String Salt {get; set;} = "";

        public DateTime? Expiry {get; set;} = DateTime.UtcNow.AddYears(1);

    }
    
    public class UserSettings
    {
        [JsonIgnore]
        public int? Id {get; set;}

        public int? notf_type {get; set;}
        public int? RouteId {get; set;}

        public bool? VibrationNotifications {get; set;}
        public bool? AudioNotifications {get; set;}
    }

    
    public class UserDetail
    {
        [JsonIgnore]
        public int? Id {get; set;}

                //define user varaibles
        public String Name { get; set; }
        public String Email { get; set; }
        public String Phone { get; set; }
    }
}
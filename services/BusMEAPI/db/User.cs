
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

        //routeid with no instant connection referenace
        public int RouteId {get; set;}

    }
}
using Dapper;
using Npgsql;

namespace BusMEAPI
{
    public class PgInterface : DbInterface
    {

        //private user class for query responses, can be translated into users
        private class UserQueryRes
        {
            public int Id;
            public string Username;
            public string PName;
            public int UserType;
            public string Email;
            public string Phone;

            public UserQueryRes(int Id, string Username, string PName, int UserType, string Email, string Phone)
            {
                this.Id = Id;
                this.Username = Username;
                this.PName = PName;
                this.UserType = UserType;
                this.Email = Email;
                this.Phone = Phone;
            }

            public User GetUserObject()
            {
                return new User(Id, Username, PName, Email, Phone, UserType);
            }
        }

        private NpgsqlConnection _connection;

        //takes in a connection and opens it with the Npgsql server
        public PgInterface(string conString)
        {
            this._connection = new NpgsqlConnection(conString);

        }

        //opens a connection
        public void Open()
        {
            _connection.Open();
        }

        public override async Task<int> DeleteUser(int id)
        {
            //await on query and delete user using asyncronius methods 
            var parameters = new {TargetId = id};
            String sql = "DELETE FROM users WHERE Id = @TargetId";
            
            //response 
            return await _connection.ExecuteAsync(sql, parameters);

        }

        public override async Task<int> DeleteUser(string username)
        {
            //await on query and delete user using asyncronius methods 
            var parameters = new {TargerUser = username};
            String sql = "DELETE FROM users WHERE username = @TargerUser";
            
            //response 
            return await _connection.ExecuteAsync(sql, parameters);
        }

        async public override Task<User> GetUser(int id)
        {
            //create new object with parameter infomation
            var parameters = new {TargetId = id};
            //define sql query
            string sql = "SELECT * FROM users WHERE Id=@TargetId";
            
            //execute async (non blocking query )
            return (await _connection.QueryAsync<UserQueryRes>(sql, parameters)).First().GetUserObject();
        }

        //same as above but with username
        async public override Task<User> GetUser(string username)
        {
            var parameters = new {TargetUsername = username};
            string sql = "SELECT * FROM users WHERE Id=@TargetUsername";
            

            return (await _connection.QueryAsync<UserQueryRes>(sql, parameters)).First().GetUserObject();
        }

        async public override Task<int> InsertUser(User user)
        {
            //paramaters is a user object
            var parameters = user;
            //insert user object field 
            string sql = "INSERT INTO users (Username, PName, UserType, Email, Phone) VALUES (@Username, @Name, @Type, @Email, @Phone)";
            

            return await _connection.ExecuteAsync(sql, parameters);
        }

        //attempt to mach IDs 
        async public override Task<int> UpdateUser(User user)
        {
            //load parameters as user
            var parameters = user;
            //sql parameter string accesses user vars
            string sql = "UPDATE users SET Username=@Username, PName=@Name, UserType=@Type, Email=@Email, Phone=@Phone) WHERE Id=@Id";
            
            //return sql status code
            return await _connection.ExecuteAsync(sql, parameters);
        }

        //closes a connection
        public void Close()
        {
            _connection.Close();
        }
    }
}
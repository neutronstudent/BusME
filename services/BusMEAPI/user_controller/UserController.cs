namespace BusMEAPI
{
    public abstract class BaseUserService
    {
        //create target user 
        public abstract Task<int> CreateUser(User user, string password);
        
        //update target user
        public abstract Task<int> UpdateUser(User updatedUser);

        public abstract Task<User?> GetUser(int id);

        public abstract Task<User?> GetUser(string username); 
        
        public abstract Task<int> DeleteUser(int id);

        public abstract Task<List<User>> SearchUser(string username_part);

    }
}
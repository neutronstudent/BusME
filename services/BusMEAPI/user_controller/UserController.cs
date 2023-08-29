namespace BusMEAPI
{
    public abstract class UserController
    {
        //create target user 
        public abstract Task<int> CreateUser(User user);
        
        //update target user
        public abstract Task<int> UpdateUser(User updatedUser);

        public abstract Task<User?> GetUser(int id);

        public abstract Task<User?> GetUser(string username); 
        
        public abstract Task<int> DeleteUser(int id);

    }
}
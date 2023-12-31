namespace BusMEAPI
{
    public abstract class BaseUserService
    {
        //create target user 
        public abstract Task<int> CreateUser(User user, string password);
        
        //update target user
        public abstract Task<int> UpdateUser(int id, User updatedUser);
        public abstract Task<int> UpdateUserSettings(int id, UserSettings userSettings);
        public abstract Task<int> UpdateUserDetails (int id, UserDetail userDetails);

        public abstract Task<User?> GetUser(int id);

        public abstract Task<User?> GetUser(string username); 
        
        public abstract Task<int> DeleteUser(int id);

        public abstract Task<List<User>> SearchUser(string username_part, int page);

    }

}
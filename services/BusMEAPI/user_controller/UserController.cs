namespace BusMEAPI
{
    public abstract class UserController
    {
        //create target user 
        public abstract int CreateUser(User user);
        
        //update target user
        public abstract int UpdateUser(User updatedUser);

        public abstract User GetUser(int id);

        public abstract User GetUser(string username); 
        
        public abstract int DeleteUser(int id);

    }
}
namespace BusMEAPI
{
    public abstract class UserController
    {
        //create target user 
        public abstract int CreateUser(User user);
        
        //update target user
        public abstract int UpdateUser(User user);
    }
}
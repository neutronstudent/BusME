

namespace BusMEAPI
{
    public abstract class DbInterface
    {
        public DbInterface()
        {}
        public abstract Task<User> GetUser(int id);

        public abstract Task<User> GetUser(string username);

        public abstract Task<int> InsertUser(User user);

        public abstract Task<int> DeleteUser(int id);

        public abstract Task<int> UpdateUser(User user);
    }
}
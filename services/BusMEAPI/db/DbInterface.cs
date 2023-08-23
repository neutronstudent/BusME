namespace BusMEAPI
{
    public abstract class DbInterface
    {
        public abstract User GetUser(int id);

        public abstract User GetUser(string username);

        public abstract int InsertUser(User user);

        public abstract int DeleteUser(int id);

        public abstract int DeleteUser(string username);
    }
}
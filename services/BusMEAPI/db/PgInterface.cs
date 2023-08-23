namespace BusMEAPI
{
    public class PgInterface : DbInterface
    {
        public PgInterface(string connectionString)
        {
            
        }

        public override int DeleteUser(int id)
        {
            throw new NotImplementedException();
        }

        public override int DeleteUser(string username)
        {
            throw new NotImplementedException();
        }

        public override User GetUser(int id)
        {
            throw new NotImplementedException();
        }

        public override User GetUser(string username)
        {
            throw new NotImplementedException();
        }

        public override int InsertUser(User user)
        {
            throw new NotImplementedException();
        }
    }
}
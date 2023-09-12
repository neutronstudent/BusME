public class BusStop
{
    public int Id { get; set;}

    public int BusTripId {get; set;}
    public List<BusTrip> BusTrip {get; set;} = new List<BusTrip>();


    public float Lat {get; set;}
    public float Long {get; set;}

    public int StopCode {get; set;}
    public string ApiId;
    public int StopName {get; set;}
    public int SupportsWheelchair {get; set;}

    public int Order {get; set;}

}
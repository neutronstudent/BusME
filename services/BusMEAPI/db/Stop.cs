public class BusStop
{
    public int Id { get; set;}

    public int BusTripId {get; set;}
    public BusTrip BusTrip {get; set;} = null!;


    public float Lat {get; set;}
    public float Long {get; set;}

    public int StopCode {get; set;}
    public int StopName {get; set;}
    public int SupportsWheelchair {get; set;}

    public int Order {get; set;}

}
public class BusTrip
{
    public int Id { get; set;}

    public int BusRouteId {get; set;}
    public BusRoute BusRoute {get; set;} = null!;

    public ICollection<BusStop> Stops { get; } = new List<BusStop>();

    public int TripHeadSign {get; set;}
    public string AtTripId {get; set;}
    public string Service {get; set;}
    
    public int Direction {get; set;}
    public int Order {get; set;}

}
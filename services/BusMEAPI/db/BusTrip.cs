public class BusTrip
{
    public int Id { get; set;}

    public int BusRouteId {get; set;}
    public BusRoute BusRoute {get; set;} = null!;

    public ICollection<BusStop> Stops { get; } = new List<BusStop>();

    public string? TripHeadSign {get; set;}
    public string ApiTripID {get; set;}
    public string? Service {get; set;}
    
    public int? Direction {get; set;}
    public int? Order {get; set;}

    public float? Lat {get; set;}
    public float? Long {get; set;}

     

}
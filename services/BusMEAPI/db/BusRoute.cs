public class BusRoute
{
    public int Id {get; set;}
    
    public string RouteId {get; set;}
    public string RouteShortName {get; set;}
    public string RouteLongName {get; set;}

    public ICollection<BusTrip> Trips { get; } = new List<BusTrip>();

}
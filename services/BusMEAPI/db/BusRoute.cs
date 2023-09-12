using System.Text.Json.Serialization;

public class BusRoute
{
    public int Id {get; set;}
    
    public string RouteId {get; set;}
    public string? RouteShortName {get; set;}
    public string? RouteLongName {get; set;}

    public DateTime LastUpdated {get; set;}

    [JsonIgnore]
    public ICollection<BusTrip> Trips { get; } = new List<BusTrip>();

}
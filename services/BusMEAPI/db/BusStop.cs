using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations.Schema;

public class BusStop
{
    public int Id { get; set;}

    public int BusTripId {get; set;}
    
    [JsonIgnore]
    public List<BusTrip> BusTrip {get; set;} = new List<BusTrip>();


    public float? Lat {get; set;}
    public float? Long {get; set;}

    public string? StopCode {get; set;}

    
    public string? ApiId {get; set;}
    public string? StopName {get; set;}
    public int? SupportsWheelchair {get; set;}

    public int? Order {get; set;}
    
}
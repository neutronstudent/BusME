using System.Text.Json.Serialization;

public class BusTrip
{
    public int Id { get; set;}

    public int BusRouteId {get; set;}
    public BusRoute BusRoute {get; set;}

    [JsonIgnore]
    public ICollection<BusStop> Stops { get; } = new List<BusStop>();

    public string? TripHeadSign {get; set;}
    public string ApiTripID {get; set;}
    
    public int? Direction {get; set;}

    public float? Lat {get; set;}
    public float? Long {get; set;}

    public DateTime StartTime {get; set;}

     

}

/*
            public string trip_id {get; set;}
            public string route_id {get; set;}
            public string direction_id {get; set;}
            public string start_time {get; set;}
            public string start_date {get; set;}
            public int schedule_relationship {get; set;}
*/
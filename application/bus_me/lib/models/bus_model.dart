
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class BusModel
{
  static final BusModel _instance = BusModel._internal();

  factory BusModel() {
    return _instance;
  }

  BusModel._internal() {
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      if (kDebugMode)
      {
        return true;
      }
      return false;
    };
  }

  final AuthModel _auth = BusMEAuth();
  final HttpClient _client = HttpClient(/*context: SecurityContext.defaultContext*/);

  //returns a list of every route
  //Get list of all routes
  Future<List<BusRoute>> getRoutes() async {
    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/routes/');

    try {
      HttpClientRequest request = await _client.getUrl(route);

      request.headers.add("Authorization", "Bearer ${_auth.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
      {
        return [];
    }

    if(req.statusCode != 200)
    {
      return [];
    }

    List<BusRoute> routes = [];
    //decode json to map
    List<dynamic> json = jsonDecode(await req.transform(utf8.decoder).join());

    //add routes to array
    for (int i = 0; i < json.length; i ++)
    {
      routes.add(BusRoute(json[i]['id'], json[i]['routeLongName'], json[i]['routeShortName'], []));
    }

    return routes;
  }


  //Returns the route associated with a route id
  //For retrieving a route that is tied to a users account
  Future<BusRoute?> getRoute(int routeId) async {

    //error checking
    if (routeId < 0) {
      return null;
    }

    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri uriRoute = Uri.https(API_ROUTE,"/api/routes/${routeId}");

    try {
      HttpClientRequest request = await _client.getUrl(uriRoute);

      request.headers.add("Authorization", "Bearer ${_auth.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return null;
    }

    if(req.statusCode != 200)
    {
      return null;
    }

    BusRoute? route = BusRoute(0, "", "", []);


    try {
      //decode json to map
      Map<String, dynamic> json = jsonDecode(
          await req.transform(utf8.decoder).join());

      route.code = json['code'] ?? "";
      route.id = json['id'];
      route.name = json['name'] ?? "";

      //load all trips registered to route
      if (json['trips'] != null)
      {
      for (int i = 0; i < json['trips'].length; i++) {
        route.trips.add(Trip(
            json['trips'][i]['id'],
            json['trips'][i]['name'],
            false,
            json['trips'][i]['lat'],
            json['trips'][i]['long'],
            json['trips'][i]['startTime']
        )
        );
      }
      }

    }
    on Exception catch (e)
    {
      return null;
    }

    return route;
  }


  //Returns a list of routes associated with a route id
  //Get all trips associated with a routeID
  Future<List<Trip>> getTrips(int routeId) async {

    //error checking
    if (routeId < 0) {
      return [];
    }

    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri uriRoute = Uri.https(API_ROUTE,"/api/routes/${routeId}/trips");

    try {
      HttpClientRequest request = await _client.getUrl(uriRoute);

      request.headers.add("Authorization", "Bearer ${_auth.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return [];
    }

    if(req.statusCode != 200)
    {
      return [];
    }

    List<Trip> trips = [];

    try {
      //decode json to map
      List<dynamic> json = jsonDecode(
          await req.transform(utf8.decoder).join());



      //load all trips registered to route
      for (int i = 0; i < json.length; i++)
      {
        trips.add(Trip(
            json[i]['id'],
            json[i]['busRoute']["routeShortName"] ?? "",
            false,
            json[i]['lat'] ?? 0.0,
            json[i]['long'] ?? 0.0,
            json[i]['startTime']
        )
        );
      }

    }
    on Exception catch (e)
    {
      return [];
    }

    return trips;
  }

  //returns a trip
  //Get information about trip id
  Future<Trip?> getTrip(int id) async {

    //error checking
    if (id < 0) {
      return null;
    }

    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri uriRoute = Uri.https(API_ROUTE,"/api/trips/${id}");

    try {
      HttpClientRequest request = await _client.getUrl(uriRoute);

      request.headers.add("Authorization", "Bearer ${_auth.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return null;
    }

    if(req.statusCode != 200)
    {
      return null;
    }



    try {
      //decode json to map
      Map<String, dynamic> json = jsonDecode(
          await req.transform(utf8.decoder).join());
      
        Trip trip = Trip(
          json['id'],
          json['busRoute']["routeShortName"],
          false,
          json['lat'],
          json['long'],
          json['startTime']

       );

        return trip;
    }
    on Exception catch (e)
    {
      return null;
    }
  }

  //returns a list of stops associated with a trip
  //get all stop associated with a trip
  Future<List<Stop>> getStops(int tripId) async {

    //error checking
    if (tripId < 0) {
      return [];
    }

    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri uriRoute = Uri.https(API_ROUTE,"/api/trips/${tripId}/stops");

    try {
      HttpClientRequest request = await _client.getUrl(uriRoute);

      request.headers.add("Authorization", "Bearer ${_auth.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return [];
    }

    if(req.statusCode != 200)
    {
      return [];
    }

    List<Stop> stops = [];

    try {
      //decode json to map
      List<dynamic> json = jsonDecode(
          await req.transform(utf8.decoder).join());



      //load all trips registered to route
      for (int i = 0; i < json.length; i++)
      {
        stops.add(Stop(
            json[i]['id'],
            json[i]['lat'],
            json[i]['long'],
            json[i]['stopName']
        )
        );
      }

    }
    on Exception catch (e)
    {
      return [];
    }

    return stops;
  }



}


//datastructure classes

class Trip
{
  Trip(this.id, this.name, this.wheelchairSupport, this.lat, this.long, this.startTime);
  int id = 0;
  String name = "";
  bool wheelchairSupport = false;
  double lat = 0.0 as double;
  double long = 0.0 as double;
  String startTime = "";

}

class Stop
{
  Stop(this.id, this.lat, this.long, this.name);
  int id = 0;
  double lat = 0.0 as double;
  double long = 0.0 as double;
  String name = "";
}

class BusRoute
{
  BusRoute(this.id, this.name, this.code, this.trips);

  int id = 0;
  String name = "";
  String code = "";
  List<Trip> trips = [];
}


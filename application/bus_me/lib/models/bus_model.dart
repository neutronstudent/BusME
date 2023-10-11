
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class BusModel
{

  BusModel()
  {
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

  Future<List<Route>> GetRoutes() async {
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

    List<Route> routes = [];
    //decode json to map
    List<dynamic> json = jsonDecode(await req.transform(utf8.decoder).join());

    //add routes to array
    for (int i = 0; i < json.length; i ++)
    {
      routes.add(Route(json[i]['id'], json[i]['name'], json[i]['code'], []));
    }

    return routes;
  }

  Future<Route?> GetRoute(int routeId) async {

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

    Route? route = Route(0, "", "", []);


    try {
      //decode json to map
      Map<String, dynamic> json = jsonDecode(
          await req.transform(utf8.decoder).join());

      route.code = json['code'];
      route.id = json['id'];
      route.name = json['name'];

      //load all trips registered to route
      for (int i = 0; i < json['trips'].length; i++)
      {
        route.trips.add(Trip(
            json['trips'][i]['id'],
            json['trips'][i]['name'],
            false,
            json['trips'][i]['lat'],
            json['trips'][i]['long']
          )
        );
      }

    }
    on Exception catch (e)
    {
      return null;
    }

    return route;
  }

  Future<List<Trip>> GetTrips(int routeId) async {

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
            json[i]['name'],
            false,
            json[i]['lat'],
            json[i]['long']
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

  Future<Trip?> GetTrip(int id) async {

    //error checking
    if (id < 0) {
      return null;
    }

    //get routes from api
    _client.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri uriRoute = Uri.https(API_ROUTE,"/api/routes/trips/${id}");

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
          json['name'],
          false,
          json['lat'],
          json['long']
       );

        return trip;
    }
    on Exception catch (e)
    {
      return null;
    }
  }

  Future<List<Stop>> GetStops(int tripId) async {
    throw Exception("Not Implimented");
  }



}


//datastructure classes

class Trip
{
  Trip(this.id, this.name, this.wheelchairSupport, this.lat, this.long);
  int id = 0;
  String name = "";
  bool wheelchairSupport = false;
  Float lat = 0 as Float;
  Float long = 0 as Float;
}

class Stop
{
  Stop(this.id, this.lat, this.long, this.name);
  int id = 0;
  Float lat = 0 as Float;
  Float long = 0 as Float;
  String name = "";
}

class Route
{
  Route(this.id, this.name, this.code, this.trips);

  int id = 0;
  String name = "";
  String code = "";
  List<Trip> trips = [];
}


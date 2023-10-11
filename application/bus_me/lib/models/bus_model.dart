
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
    throw Exception("Not Implimented");
  }

  Future<List<Trip>> GetTrips(int routeId) async {
    throw Exception("Not Implimented");
  }

  Future<Trip?> GetTrip(int id) async {
    throw Exception("Not Implimented");
    return null;
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


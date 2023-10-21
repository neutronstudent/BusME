import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/foundation.dart';
import 'package:bus_me/models/api_constants.dart';
import 'package:bus_me/models/bus_model.dart';

class CustomMapController {
  final BusModel _busModel = BusModel();
  // Define methods to interact with the BusModel and handle API calls.

  Future<List<Route>> getRoutes() async {
    try {
      return await _busModel.getRoutes();
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return [];
    }
  }

  Future<Route?> getRoute(int routeId) async {
    try {
      return await _busModel.getRoute(routeId);
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return null;
    }
  }

  Future<List<Trip>> getTrips(int routeId) async {
    try {
      return await _busModel.getTrips(routeId);
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return [];
    }
  }

  Future<Trip?> getTrip(int id) async {
    try {
      return await _busModel.getTrip(id);
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return null;
    }
  }

  Future<List<Stop>> getStops(int tripId) async {
    try {
      return await _busModel.getStops(tripId);
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return [];
    }
  }
}

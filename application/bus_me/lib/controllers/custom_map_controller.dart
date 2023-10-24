import 'dart:async';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/bus_model.dart';
import 'package:flutter/material.dart';
import 'package:bus_me/models/api_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../views/settings_page.dart';
import '../views/mapView.dart';

class BusController {
  static final BusController _instance = BusController._internal();
  final BusModel _busModel = BusModel();
  final UserModel _userModel = BusMEUserModel();
  final MapView _mapView = MapView();

  factory BusController() {
    return _instance;
  }

  BusController._internal();

  // Define methods to interact with the BusModel and handle API calls.

  Future<List<BusRoute>> getRoutes() async {
    try {
      return await _busModel.getRoutes();
    } catch (e) {
      // Handle exceptions, e.g., connection errors
      return [];
    }
  }

  Future<BusRoute?> getRoute(int routeId) async {
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

  void checkRouteAndShowSnackBar(BuildContext context) {
    final user = _userModel.getUser();
    if (user == null || user.settings?.route == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No route selected. Please select a route from the settings page!',
              style: TextStyle(
                  fontFamily: 'Helvetica-bold',
                  fontSize: 25.0,
                  color: Colors.white),
            ),
            backgroundColor: Colors.blue, // Using a hex color code
            action: SnackBarAction(
              label: 'Go to Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              textColor: Colors.white,
            ),
            duration: Duration(seconds: 60),
          ),
        );
      });
    }
  }

  void selectTrip(BuildContext context, {Function(int)? callback}) async {
    int? routeId = _userModel.getUser()?.settings?.route;

    if (routeId != null) {
      List<Trip> trips = await _busModel.getTrips(routeId);
      _showTripsDialog(context, trips, callback);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Route Selected'),
            content: Text('Please select a route from the settings page.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showTripsDialog(
      BuildContext context, List<Trip> trips, Function(int)? callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Trip'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(trips[index].name),
                  onTap: () {
                    if (callback != null) {
                      callback(trips[index].id);
                    }
                    Navigator.of(context).pop(); //close the dialog
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

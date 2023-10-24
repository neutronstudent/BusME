import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'settings_page.dart';
import '../controllers/custom_map_controller.dart';
import '../models/bus_model.dart';
import '../models/tracking_model.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final BusController _busController = BusController();
  final BusModel _busModel = BusModel();
  final TrackingModel _trackingModel = TrackingModel();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  //custom icons not working
  /*
  //Icons for bus and bus stops, User current location uses default
  late BitmapDescriptor _busStopIcon;
  late BitmapDescriptor _busIcon;
   */

  String _tripName = "No trip selected";

  //Timers for updating bus and user locations
  Timer? _trackingTimer;
  Timer? _locationTimer;


  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-36.8485, 174.7633); // Auckland

  LatLng? _currentLocation; // store current location
  Set<Marker> _markers = {}; // Set to store map markers

  @override
  void initState() {
    super.initState();
    _busController.checkRouteAndShowSnackBar(context);
    _getUserLocation();

    //Custom icons not working
    /*
    _loadBusStopIcon();
    _loadBusIcon();
     */
    _startLocationUpdates();
  }


  // Method to get user location
  _getUserLocation() async {
    // Get location data
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      _currentLocation =
          LatLng(userLocation.latitude!, userLocation.longitude!);

      // Update the state in a way that the map updates its UI
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        );
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          key: _scaffoldMessengerKey,
          appBar: AppBar(
            title: Text('BusME'),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? _center,
                  zoom: 11.0,
                ),
                markers: _markers,
              ),
              Positioned(
                top: 25.0,
                left: 15.0,
                right: 15.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  color: Colors.blue,
                  child: Text(
                    'Current trip: $_tripName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50.0,
                left: 15.0,
                child: ElevatedButton(
                  onPressed: () {
                    _busController.selectTrip(context, callback: (tripId) => handleTripSelection(context, tripId));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: TextStyle(fontSize: 25),
                    minimumSize: Size(200, 60),
                  ),
                  child: Text('Select Trip'),
                ),
              ),
            ],
          ),
        ));
  }

  void handleTripSelection(BuildContext context, int tripId) async {

    final fetchedStops = await _busModel.getStops(tripId);

    //update the trip name and set the trip
    _trackingModel.setTripId(tripId);
    print(tripId);
    print(_trackingModel.getTripId());
    Trip? trip = await _busModel.getTrip(_trackingModel.getTripId());
    print(trip);

    setState(() {

      _tripName = trip!.name;

      for (var stop in fetchedStops) {


        _markers.add(
          Marker(
            markerId: MarkerId('stop_${stop.id}'),
            position: LatLng(stop.lat as double, stop.long as double),
            infoWindow: InfoWindow(title: '${stop.name}', snippet: 'Stop ID: ${stop.id}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      }
      _startBusTracking();
    });
  }

  //Custom Icons not working
  /*
  Future<void> _loadBusStopIcon() async {
    _busStopIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/bus_stop_icon.png',
    );
  }

  Future<void> _loadBusIcon() async {
    _busIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/bus_icon.png',
    );
  }

   */

  void _startBusTracking() {
    _trackingTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      // Get bus location
      LatLng? busLocation = await _trackingModel.getBusLocation();
      if (busLocation != null) {
        // Update bus marker on the map
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('Bus Location'),
              position: busLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'Bus Location'),
            ),
          );
        });

        //check if any notifications need to be pushed to the user
        _trackingModel.updateNotifs(context);
      }
    });
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await _getUserLocation(); // this method updates the user location on the map
    });
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _locationTimer?.cancel();
    super.dispose();
  }

}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-36.8485, 174.7633); // Auckland

  LatLng? _currentLocation; // Variable to store current location
  Set<Marker> _markers = {}; // Set to store map markers

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Get user location when widget is initialized
  }

  // Method to get user location
  _getUserLocation() async {
    // Get location data
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);

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

      // You might want to move the camera to the user's location here
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation ?? _center, // prioritize current location
          zoom: 11.0,
        ),
        markers: _markers, // Include the markers here
      ),
    );
  }

}

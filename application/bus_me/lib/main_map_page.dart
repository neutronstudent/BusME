import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:bus_app/locations.dart' as locations;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bus_me/views/settings_page.dart';

import 'models/user_model.dart';

class MapPage extends StatefulWidget {

  UserModel user;
  MapPage({super.key, required this.user});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final Map<String, Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerCurrentIcon = BitmapDescriptor.defaultMarker;
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //final response = await rootBundle.loadString('/json/stops.json');
    //   final data = await json.decode(response);
    final googleOffices = await rootBundle.loadString('/json/stops.json');
    final data = await json.decode(googleOffices);
    final inspect = data['data'];

    setState(() {
      _markers.clear();

      for (final stops in inspect) {
        final marker = Marker(
          markerId: MarkerId(stops['id']),
          position: LatLng(
              stops['attributes']['stop_lat'], stops['attributes']['stop_lon']),
          infoWindow: InfoWindow(
            title: stops['attributes']['stop_name'],
          ),
          icon: markerIcon,
        );
        _markers[stops['id']] = marker;
      }
    });
  }

  @override
  void initState() {
    addCustomIcon();
    getCurrenttLocation();
    super.initState();
  }

  getCurrenttLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location lat: ${position.latitude}');
    debugPrint('location lan: ${position.longitude}');
    setState(() {
      var currentLocation = [position.latitude, position.longitude];
    });
  }

  addCustomIcon() async {
    var iconNormal = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(40, 40)),
        "assets/images/destination_map_marker.png");

    setState(() {
      markerIcon = iconNormal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurpleAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bus me Route'),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(widget.user),
                  ),
                );
              },
            ),
          ],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-36.914060, 174.882880),
            zoom: 13,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

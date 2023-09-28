import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:bus_app/locations.dart' as locations;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerCurrentIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();

  LatLng currentLocation = LatLng(-36.848461, 174.763336);
  LatLng schoolLocation = LatLng(-36.881351, 174.916656);

  Marker currentLocationMarker = Marker(
    markerId: MarkerId('current_location'),
    position: LatLng(-36.848461, 174.763336),
    infoWindow: InfoWindow(title: 'Current Location'),
    icon: BitmapDescriptor.defaultMarker,
  );
  Future<void> _onMapCreated(GoogleMapController controller) async {
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
    super.initState();
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = LatLng(newLocation.latitude!, newLocation.longitude!);

        mapController?.animateCamera(
          CameraUpdate.newLatLng(currentLocation),
        );
        currentLocationMarker = Marker(
          markerId: MarkerId('current_location'),
          position: currentLocation,
          infoWindow: InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarker,
        );
        _markers['current_location'] = currentLocationMarker;
      });
    });
  }

  addCustomIcon() async {
    var iconNormal = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(40, 40)),
        "assets/images/destination_map_marker.png");

    setState(() {
      markerIcon = iconNormal;
      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:bus_app/locations.dart' as locations;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

//We belive children on the bus and we are tracking bus
//So if the child is on the bus we will show the child is moving with bus

class MapParentPage extends StatefulWidget {
  const MapParentPage({super.key});

  @override
  State<MapParentPage> createState() => _MapParentPage();
}

class _MapParentPage extends State<MapParentPage> {
  FlutterTts ftts = FlutterTts();
  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerCurrentIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();

  LatLng currentLocation = LatLng(-36.846187, 174.769395); //Starting Point

  Marker currentLocationMarker = Marker(
    markerId: MarkerId('current_location'),
    position: LatLng(-36.846187, 174.769395),
    infoWindow: InfoWindow(title: 'Current Location'),
    icon: BitmapDescriptor.defaultMarker,
  );
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await DefaultAssetBundle.of(context)
        .loadString('assets/json/stops.json');
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
    super.initState();
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = LatLng(newLocation.latitude!, newLocation.longitude!);

        if (newLocation.latitude == -36.8912895 &&
            newLocation.longitude == 174.9188354) {
          print("current location");
        } else {
          print("Not current location");
        }
        print(newLocation.latitude);
        print(newLocation.longitude);
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
          title: const Text('Bus me Route Parent view'),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(
                -36.914060, 174.882880), //Udys Road, Pakuranga, Auckland 2010
            zoom: 13,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

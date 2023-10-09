import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:bus_app/locations.dart' as locations;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:io';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  FlutterTts ftts = FlutterTts();
  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerCurrentIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();

  //Student get off locatio
  var busStopLocationLat = -36.846187;
  var busStopLocationLon = 174.76939;

  LatLng currentLocation = LatLng(-36.846187, 174.769395); //Starting Point

  Marker currentLocationMarker = Marker(
    markerId: MarkerId('current_location'),
    position: LatLng(-36.846187, 174.769395),
    infoWindow: InfoWindow(title: 'Current Location'),
    icon: BitmapDescriptor.defaultMarker,
  );

  List _items = [];
  readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/stops.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["data"];
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    //final googleOffices = await rootBundle.loadString('/json/stops.json');
    setState(() {
      _markers.clear();

      for (final stops in _items) {
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

  getUserStartLocation() async {
    LocationData _currentPosition;
    Location location = Location();

    try {
      _currentPosition = await location.getLocation();

      print("${_currentPosition.latitude} : ${_currentPosition.longitude}");
      currentLocation =
          LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
      var currentStartLocationMarker = Marker(
        markerId: MarkerId('current_start_location'),
        position: currentLocation,
        infoWindow: InfoWindow(title: 'Current Start Location'),
        icon: BitmapDescriptor.defaultMarker,
      );
      _markers['current_start_location'] = currentStartLocationMarker;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
        print(error);
      }
    }
  }

  //This trigger when user moves its capture user location
  getCurrentLocation() async {
    location.onLocationChanged.listen((LocationData newLocation) {
      //Check if user is at current location is his bus stop to get out
      //Check this bus stop is before bus stop to get out

      setState(() {
        currentLocation = LatLng(newLocation.latitude!, newLocation.longitude!);

        //If user is on bus stop (We assume user inside the bus and its move as usual)
        for (final stops in _items) {
          //Notifiy user every bus stop
          if ((stops['attributes']['stop_lat'] == newLocation.latitude!) &&
              (stops['attributes']['stop_lon'] == newLocation.longitude!)) {
            pushVoiceNotification(
                'EveryBusStop', stops['attributes']['stop_name']);
          }

          //if this is users get off stand
          if ((stops['attributes']['stop_lat'] == busStopLocationLat!) &&
              (stops['attributes']['stop_lon'] == busStopLocationLon!)) {
            pushVoiceNotification(
                'ThisIsYourBusStop', stops['attributes']['stop_name']);
          }

          //Check next bus stop is your bus stop
        }

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

  //push voice notification
  pushVoiceNotification(stage, location) async {
    //Every bus stop
    //Next is your bus stop
    //If this is your bus stop
    switch (stage) {
      case 'EveryBusStop':
        {
          currentLocationVoice(location);
        }
        break;

      case 'NextIsYourBusStop':
        {
          currentLocationVoice(location + " Next Is Your Bus Stop.");
        }
        break;
      case 'ThisIsYourBusStop':
        {
          currentLocationVoice(location + "This Is Your Bus Stop.");
        }
        break;
    }
  }

  @override
  void initState() {
    getUserStartLocation();
    getCurrentLocation();
    readJson();

    super.initState();
  }

  currentLocationVoice(text) async {
    //your custom configuration
    await ftts.setLanguage("en-US");
    await ftts.setSpeechRate(0.5); //speed of speech
    await ftts.setVolume(1.0); //volume of speech
    await ftts.setPitch(1); //pitc of sound

    //play text to sp
    var result = await ftts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    //print(_markers['current_start_location']);

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
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: true,
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
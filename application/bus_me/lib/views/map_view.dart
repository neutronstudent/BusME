
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'settings_page.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          appBar: AppBar(
            title: Text('Map View'),
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
          body: FlutterMap(
            options: MapOptions(
              center: LatLng(51.5, -0.09), //Will be overwritten by current location
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              CurrentLocationLayer(followOnLocationUpdate: FollowOnLocationUpdate.always,
                turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(
                    child: Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: const Size(40, 40),
                  markerDirection: MarkerDirection.heading,
                ),),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(51.5, -0.09),
                    builder: (ctx) => Icon(Icons.pin_drop),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}




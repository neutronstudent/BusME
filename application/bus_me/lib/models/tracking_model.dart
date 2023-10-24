
import 'dart:math';

import 'package:bus_me/models/bus_model.dart';
import 'package:bus_me/models/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingModel
{
  TrackingModel();

  final Location _location = Location();
  int curTrip = -1;
  //thank you https://stackoverflow.com/questions/54138750/total-distance-calculation-from-latlng-list

  //returns the distance between 2 points on a map
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  bool _notif = false;

  //checks if the bus is close to the persons location
  Future<bool> checkIfBusClose() async
  {
    LatLng? _loc = await getPos();

    // thank you https://stackoverflow.com/questions/54138750/total-distance-calculation-from-latlng-list

    LatLng? busLoc = await getBusLocation();

    if (busLoc == null)
    {
      return false;
    }

    //if closer that .2 km return alert
    return calculateDistance(busLoc.latitude, busLoc.longitude, _loc?.latitude, _loc?.longitude) < .4;
  }

  //gets the current location of the bus
  Future<LatLng?> getBusLocation() async
  {
    Trip? trip = await BusModel().getTrip(curTrip);

    if (trip == null)
      {
        return null;
      }

    return LatLng(trip.lat as double, trip.long as double);
  }

  //tells the notification model to push a notification if the bus is close
  Future<void> updateNotifs(BuildContext? context) async
  {
    if (await checkIfBusClose() &&  !_notif)
    {
      _notif = true;
      await NotificationModel().sendNotification("Bus is approaching", context);
    }
  }

  //returns a list of bus stops associated with a trip
  Future<List<Stop>> getTripStops() async
  {
    return BusModel().getStops(curTrip);
  }

  //get current position of user
  Future<LatLng?> getPos() async
  {
    LocationData _loc = await _location.getLocation();


    if (_loc.latitude == null || _loc.longitude == null)
    {
      return null;
    }
    else {
      return LatLng(_loc.latitude!, _loc.longitude!);
    }
  }

  //sets notif to false
  void resetNotifs()
  {
    _notif = false;
  }

  //Set the current trip
  void setTripId(int tripId)
  {
    _notif = false;
    curTrip = tripId;
  }

  //return the current trip
  int getTripId()
  {
    return curTrip;
  }

}
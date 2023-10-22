import 'dart:ffi';

import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/bus_model.dart';
import 'package:test/test.dart';

//test user infomation
String testUsername = "test";
String testPassword = "password";

void main() {
  //bus model unit tests
  BusMEAuth().loginUser(testUsername, testPassword);

  BusModel model = new BusModel();
  group('Bus Model', () {
      test("list of routes info should be returned", () async {
        List<Route> routes = await model.getRoutes();
        expect(routes.length, greaterThanOrEqualTo(1));
      });
      test("spefiic route should be returned", () async {
        Route? route = await model.getRoute(1);
        expect(route, isNotNull);
      });
      test("invalid route should be null", () async {
        Route? route = await model.getRoute(-1);
        expect(route, isNull);
      });

      test("Non existant route  route should be null", () async {
        Route? route = await model.getRoute(9223372036854775807);
        expect(route, isNull);
      });

      test("route trips should be returned", () async {
        List<Trip> trips = await model.getTrips(1);
        expect(trips.length, greaterThanOrEqualTo(1));
      });        //assuming valid route, using test route in database

      test("route trips should be empty if invalid ", () async {
        List<Trip> trips = await model.getTrips(-1);
        expect(trips.length, 0);
      });
      //assuming valid route, using test route in database

      test("spefiic trip should be returned", () async {
        Trip? trip = await model.getTrip(1);
        expect(trip, isNotNull);
      });

      test("invalid trip should be null", () async {
        Trip? trip = await model.getTrip(-1);
        expect(trip, isNull);
      });

      test("Non existant trip  should be null", () async {
        Trip? trip = await model.getTrip(9223372036854775807);
        expect(trip, isNull);
      });

    }
  );
}
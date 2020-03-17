import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:taxi_availability/json/Response.dart';

class LocationMapManager {
  final int _delay = 5;
  TaxiAvailability taxi;

  LocationMapManager(this.taxi);

  Stream<Set<Marker>> get taxiMarkers async* {
    while (true) {
      await Future.delayed(Duration(seconds: _delay));
      CabDetails details = await taxi.markers(DateTime.now());
      print(details.cabInfo);
      CabCoordinates coordinates = details?.cabCoordinates;
      print(coordinates);
      List<List<int>> latlong = coordinates?.coordinates;
      print(latlong);
      yield _markersFromList(latlong);
    }
  }

  Set<Marker> _markersFromList(List<List<int>> latlong) {
    print("making markers");
    Random generator = Random();
    Set<Marker> _markers = Set();
    _markers.add(Marker(
      markerId: MarkerId("hello"),
      position: LatLng(
        1 + generator.nextDouble(),
        103 + generator.nextDouble(),
      ),
      infoWindow: InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
      onTap: () {
        print("marker tapped");
      },
    ));
    return _markers;
  }
}

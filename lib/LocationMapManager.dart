import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';

Set<Marker> markersFromList(List<List<double>> latlong) {
  Set<Marker> _markers = Set();
  int length = latlong.length;
  for (int i = 0; i < length; i++) {
    _markers.add(
      Marker(
        markerId: MarkerId("Marker$i"),
        position: LatLng(
          latlong[i][1],
          latlong[i][0],
        ),
        // icon: _taxiMovingIcon,
        // infoWindow:
        //     InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
        // onTap: () {
        //   print("marker tapped");
        // },
      ),
    );
  }
  return _markers;
}

class LocationMapManager {
  final int _delay = 60;
  TaxiAvailability taxi;
  BitmapDescriptor _taxiMovingIcon;
  BitmapDescriptor _taxiStoppedIcon;

  LocationMapManager(this.taxi);

  Stream<Set<Marker>> get taxiMarkers async* {
    while (true) {
      List<List<double>> latlong = await taxi.markers(DateTime.now());
      // Set<Marker> toYield = await compute(markersFromList, latlong);
      Set<Marker> _markers = Set();
      int length = latlong.length;
      for (int i = 0; i < length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId("Marker$i"),
            position: LatLng(
              latlong[i][1],
              latlong[i][0],
            ),
            icon: _taxiMovingIcon,
            // infoWindow:
            //     InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
            // onTap: () {
            //   print("marker tapped");
            // },
          ),
        );
      }
      yield _markers;
      await Future.delayed(Duration(seconds: _delay));
    }
  }

  void init() async {
    _taxiMovingIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'asset/images/taxi_moving_icon.png');
    _taxiStoppedIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/taxi_stopped_icon.png');
  }
}

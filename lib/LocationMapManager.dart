import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';

Set<Marker> markersFromList(List<List<double>> latlong) {
  Set<Marker> _markers = Set();
  // for (List<double> coordinate in latlong) {
  // print("longitudinal: " + coordinate[0].toString());
  // print("Latitudinal: " + coordinate[1].toString());
  var coordinate = latlong;
  for (int i = 0; i < 10; i++) {
    _markers.add(
      Marker(
        markerId: MarkerId("hello"),
        position: LatLng(
          coordinate[i][0],
          coordinate[i][1],
        ),
        infoWindow:
            InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
        onTap: () {
          print("marker tapped");
        },
      ),
    );
  }
  print(_markers);
  return _markers;
}

class LocationMapManager {
  final int _delay = 15;
  TaxiAvailability taxi;

  LocationMapManager(this.taxi);

  Stream<Set<Marker>> get taxiMarkers async* {
    while (true) {
      await Future.delayed(Duration(seconds: _delay));
      List<List<double>> latlong = await taxi.markers(DateTime.now());
      // Set<Marker> toYield = await compute(markersFromList, latlong);
      Set<Marker> _markers = Set();
      int length = latlong.length;
      for (int i = 0; i < length; i++) {
        // for (List<double> coordinate in latlong) {
        print("adding marker");
        _markers.add(
          Marker(
            markerId: MarkerId("Marker$i"),
            position: LatLng(
              latlong[i][1],
              latlong[i][0],
            ),
            // infoWindow:
            //     InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
            // onTap: () {
            //   print("marker tapped");
            // },
          ),
        );
        yield _markers;
      }
    }
  }
}

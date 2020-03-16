import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:taxi_availability/json/Response.dart';

class LocationMapManager {
  final int _delay = 10;
  TaxiAvailability taxi;

  LocationMapManager(this.taxi);

  Stream<Set<Marker>> get taxiMarkers async* {
    while (true) {
      print("Stream called");
      Future.delayed(Duration(seconds: _delay));

      CabDetails details = await taxi.markers(DateTime.now());
      CabCoordinates coordinates = details?.cabCoordinates;
      List<List<int>> latlong = coordinates?.coordinates;
      yield _markersFromList(latlong);
    }
  }

  Set<Marker> _markersFromList(List<List<int>> latlong) {
    print("making markers");
    Set<Marker> _markers = Set();
    _markers.add(Marker(
      markerId: MarkerId("hello"),
      position: LatLng(
        1.3521,
        103.8198,
      ),
      infoWindow: InfoWindow(title: "InfoWindow", snippet: 'This is a snipper'),
      onTap: () {
        print("marker tapped");
      },
    ));
    return _markers;
  }
}

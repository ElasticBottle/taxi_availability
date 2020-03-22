import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_availability/LocationMapManager.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:taxi_availability/StreamObserver.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController mapController;
  LocationMapManager manager;
  final LatLng _initialPosition = const LatLng(1.3521, 103.8198);
  final double _initialZoom = 10.0;
  double _currentZoom = 12.0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // May be called as often as every frame, so just track the last zoom value.
  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;
    manager.setCameraZoom(_currentZoom);
  }

  void _onCameraIdle() {}

  void initState() {
    super.initState();
    manager = LocationMapManager(
        Provider.of<TaxiAvailability>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamObserver<Map<MarkerId, Marker>>(
          stream: manager.markers,
          onSuccess: (BuildContext context, Map<MarkerId, Marker> data) {
            print(data);
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: _initialZoom,
              ),
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set.of(data.values),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: RaisedButton(
            onPressed: () {
              print("clicked");
              manager.animateToUser(mapController, _currentZoom);
            },
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

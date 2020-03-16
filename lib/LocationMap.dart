import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_availability/LocationMapManager.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController mapController;
  LocationMapManager manager;
  final LatLng _initialPosition = const LatLng(1.3521, 103.8198);
  final double _initialZoom = 10.0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void initState() {
    manager = LocationMapManager(
        Provider.of<TaxiAvailability>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<Marker>>(
      stream: manager.taxiMarkers,
      builder: (context, snapshot) {
        print("streaming");
        Set<Marker> _markers = snapshot.data;
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: _initialZoom,
          ),
          compassEnabled: true,
          markers: _markers,
        );
      },
    );
  }
}

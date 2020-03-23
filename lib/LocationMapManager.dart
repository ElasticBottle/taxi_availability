import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:fluster/fluster.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as images;
import 'package:location/location.dart';
import 'package:taxi_availability/MapMarker.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';

/*
 * Created by Alfonso Cejudo, Thursday, July 25th 2019.
 */

class LocationMapManager {
  static const maxZoom = 18;
  static const thumbnailWidth = 80;
  final int _delay = 30;

  // Current pool of available media that can be displayed on the map.
  final Map<String, MapMarker> _mediaPool;
  TaxiAvailability taxi;
  Location location;
  LocationData currentLocation;

  /// Markers currently displayed on the map.
  final _markerController = StreamController<Map<MarkerId, Marker>>.broadcast();

  /// Camera zoom level after end of user gestures / movement.
  final _cameraZoomController = StreamController<double>.broadcast();

  /// Outputs.
  Stream<Map<MarkerId, Marker>> get markers => _markerController.stream;
  Stream<double> get cameraZoom => _cameraZoomController.stream;

  /// Inputs.
  Function(Map<MarkerId, Marker>) get addMarkers => _markerController.sink.add;
  Function(double) get setCameraZoom => _cameraZoomController.sink.add;

  /// Internal listener.
  StreamSubscription _cameraZoomSubscription;

  /// Keep track of the current Google Maps zoom level.
  var _currentZoom = 12; // As per _initialCameraPosition in main.dart

  /// Fluster
  Fluster<MapMarker> _fluster;

  LocationMapManager(this.taxi)
      : _mediaPool = LinkedHashMap<String, MapMarker>() {
    _buildMediaPool();

    _cameraZoomSubscription = cameraZoom.listen((zoom) {
      if (_currentZoom != zoom.toInt()) {
        _currentZoom = zoom.toInt();

        _displayMarkers(_mediaPool);
      }
    });
    // create an instance of Location
    location = new Location();
    _requestUserLocationPermission();

    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
      _displayMarkers(_mediaPool);
    });
  }

  /// Request the user for permission to access phone's location services
  void _requestUserLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
  }

  /// Moves camera position to user's current location if there is one.
  void animateToUser(GoogleMapController mapController, double currentZoom) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 16.0,
    )));
  }

  dispose() {
    _cameraZoomSubscription.cancel();

    _markerController.close();
    _cameraZoomController.close();
  }

  /// Initiates and rebuilds the fluster instance every _delay seconds base on the new data points
  _buildMediaPool() async {
    while (true) {
      List<List<double>> response;
      try {
        response = await taxi.markers(DateTime.now());
      } catch (e) {}
      Map<String, MapMarker> convertedResponse =
          _toMapStringMapMarker(response);
      _mediaPool.clear();
      _mediaPool.addAll(convertedResponse);

      _fluster = Fluster<MapMarker>(
          minZoom: 0,
          maxZoom: maxZoom,
          radius: thumbnailWidth ~/ 2,
          extent: 512,
          nodeSize: 32,
          points: _mediaPool.values.toList(),
          createCluster:
              (BaseCluster cluster, double longitude, double latitude) =>
                  MapMarker(
                      locationName: null,
                      latitude: latitude,
                      longitude: longitude,
                      isCluster: true,
                      clusterId: cluster.id,
                      pointsSize: cluster.pointsSize,
                      markerId: cluster.id.toString(),
                      childMarkerId: cluster.childMarkerId));

      _displayMarkers(_mediaPool);
      await Future.delayed(Duration(seconds: _delay));
    }
  }

  /// Converts the response from the api call to Map<String, MapMarker> needed for fluster instance
  _toMapStringMapMarker(List<List<double>> response) {
    Map<String, MapMarker> _markers = Map<String, MapMarker>();
    int length = response.length;
    for (int i = 0; i < length; i++) {
      _markers.addAll({
        "Marker$i": MapMarker(
            locationName: 'Available Taxi',
            markerId: "Marker$i",
            latitude: response[i][1],
            longitude: response[i][0],
            thumbnailSrc: 'taxi_moving_icon.png')
      });
    }
    return _markers;
  }

  /// displayes the approapriate marker base one whether a not the point is clustered
  _displayMarkers(Map pool) async {
    if (_fluster == null) {
      return;
    }

    // Get the clusters at the current zoom level.
    List<MapMarker> clusters =
        _fluster.clusters([-180, -85, 180, 85], _currentZoom);

    // Finalize the markers to display on the map.
    Map<MarkerId, Marker> markers = Map();

    for (MapMarker feature in clusters) {
      BitmapDescriptor bitmapDescriptor;

      if (feature.isCluster) {
        bitmapDescriptor = await _createClusterBitmapDescriptor(feature);
      } else {
        bitmapDescriptor =
            await _createImageBitmapDescriptor(feature.thumbnailSrc);
      }

      var marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          infoWindow: InfoWindow(title: feature.locationName),
          icon: bitmapDescriptor);

      markers.putIfAbsent(MarkerId(feature.markerId), () => marker);
    }
    currentLocation = await location.getLocation();
    // Publish markers to subscribers.
    addMarkers(markers);
  }

  /// create Icon for Marker based on a cluster
  Future<BitmapDescriptor> _createClusterBitmapDescriptor(
      MapMarker feature) async {
    MapMarker childMarker = _mediaPool[feature.childMarkerId];

    var child = await _createImage(
        childMarker.thumbnailSrc, thumbnailWidth, thumbnailWidth);

    if (child == null) {
      return null;
    }

    images.brightness(child, -90);
    images.drawString(
      child,
      images.arial_48,
      0,
      15,
      '${feature.pointsSize}',
    );

    var resized =
        images.copyResize(child, width: thumbnailWidth, height: thumbnailWidth);

    var png = images.encodePng(resized);

    return BitmapDescriptor.fromBytes(png);
  }

  /// Create icon for Marker based on an individual point
  Future<BitmapDescriptor> _createImageBitmapDescriptor(
      String thumbnailSrc) async {
    var resized =
        await _createImage(thumbnailSrc, thumbnailWidth, thumbnailWidth);

    if (resized == null) {
      return null;
    }

    var png = images.encodePng(resized);

    return BitmapDescriptor.fromBytes(png);
  }

  /// Loads an image of given width and height from imageFile location
  Future<images.Image> _createImage(
      String imageFile, int width, int height) async {
    ByteData imageData;
    try {
      imageData = await rootBundle.load('asset/images/$imageFile');
    } catch (e) {
      print('caught $e');
      return null;
    }

    if (imageData == null) {
      return null;
    }

    List<int> bytes = Uint8List.view(imageData.buffer);
    var image = images.decodeImage(bytes);

    return images.copyResize(image, width: width, height: height);
  }
}

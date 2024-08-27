import 'package:farmer_app/screens/customer_home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final String userType;
  final String selectedLocation; // New property to accept the location

  MapPage({required this.userType, required this.selectedLocation});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  List<LatLng> _predefinedPoints = [];

  @override
  void initState() {
    super.initState();
    _fetchPredefinedPoints();
  }

  Future<void> _fetchPredefinedPoints() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/viewmapfarmer?location=${widget.selectedLocation}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _predefinedPoints = data.map((point) => LatLng(point['latitude'], point['longitude'])).toList();
          _zoomToFitPoints();
        });
      } else {
        throw Exception('Failed to load predefined points');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _zoomToFitPoints() {
    if (_predefinedPoints.isEmpty) return;

    LatLngBounds bounds = _createBounds(_predefinedPoints);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _createBounds(List<LatLng> points) {
    double southWestLat = points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double southWestLng = points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double northEastLat = points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double northEastLng = points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Page')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (_predefinedPoints.isNotEmpty) {
                  _zoomToFitPoints();
                }
              },
              initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 2.0), // Default position if no points loaded
              markers: _createMarkers(),
              onTap: (LatLng location) {
                setState(() {
                  _userLocation = location;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_userLocation != null)
                  Text('Location: (${_userLocation!.latitude}, ${_userLocation!.longitude})'),
                ElevatedButton(
                  onPressed: _userLocation == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home_Consumer(
                                userLocation: _userLocation!, // User's selected location on the map
                                MapLocation: widget.selectedLocation,// Empty list as data will be fetched in Home_Consumer
                              ),
                            ),
                          );
                        },
                  child: Text('Check Out available farms'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    final markers = <Marker>{};

    for (var point in _predefinedPoints) {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: 'Predefined Point'),
      ));
    }

    if (_userLocation != null) {
      markers.add(Marker(
        markerId: MarkerId('user_location'),
        position: _userLocation!,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    return markers;
  }
}
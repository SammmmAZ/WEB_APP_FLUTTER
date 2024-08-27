import 'dart:convert';
import 'dart:typed_data';
import 'package:farmer_app/screens/customer_view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';

class Home_Consumer extends StatefulWidget {
  final gmaps.LatLng userLocation; // User-selected location from the map
  final String MapLocation;

  Home_Consumer({required this.userLocation, required this.MapLocation});

  @override
  State<Home_Consumer> createState() => _Home_ConsumerState();
}

class _Home_ConsumerState extends State<Home_Consumer> {
  List<Map<String, dynamic>> farmersData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkMapLocation();
  }

  void _checkMapLocation() {
    print("MapLocation passed: ${widget.MapLocation}");
    _fetchFarmersData();
  }

  Future<void> _fetchFarmersData() async {
    String url =
        'http://localhost:8080/farmer?location_text=${widget.MapLocation}';
    print("Fetching farmers data from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("API call successful. Data received.");
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          farmersData = _processFarmersData(data);
          isLoading = false;
        });
      } else {
        print(
            "Failed to load farmers data. Status code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error during API call: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _processFarmersData(List<dynamic> data) {
    return data.map((farmer) {
      // Calculate the distance from the user's location
      double latitude = farmer['latitude'] is String
          ? double.parse(farmer['latitude'])
          : farmer['latitude'];
      double longitude = farmer['longitude'] is String
          ? double.parse(farmer['longitude'])
          : farmer['longitude'];

      double distance = _calculateDistance(
        gmaps.LatLng(latitude, longitude),
        widget.userLocation,
      );

      return {
        'name': farmer['name'],
        'rating': farmer['rating'].toString(),
        'distance': distance.toStringAsFixed(1), // Convert to km and format
        'profile_image': farmer['profile_image'] != null
            ? base64Decode(farmer['profile_image'])
            : null,
      };
    }).toList();
  }

  double _calculateDistance(gmaps.LatLng farmerLocation, gmaps.LatLng userLocation) {
    return Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          farmerLocation.latitude,
          farmerLocation.longitude,
        ) /
        1000; // Convert to kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmers List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: farmersData.length,
              itemBuilder: (context, index) {
                final farmer = farmersData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerViewProductPage(),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (farmer['profile_image'] != null)
                            ClipOval(
                              child: Image.memory(
                                farmer['profile_image']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            ClipOval(
                              child: Icon(Icons.person, size: 100),
                            ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmer['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('Rating: ${farmer['rating']}'),
                              Text('Distance: ${farmer['distance']} km'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

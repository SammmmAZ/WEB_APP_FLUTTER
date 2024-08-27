import 'dart:convert';
import 'package:flutter/material.dart';
import "../widgets/app_header.dart";
import '../widgets/app_footer.dart';
import 'package:farmer_app/screens/customer_view_farmer_page.dart';  // Import the MapPage class
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerChooseLocationPage extends StatefulWidget {
  @override
  _CustomerChooseLocationPageState createState() => _CustomerChooseLocationPageState();
}

class _CustomerChooseLocationPageState extends State<CustomerChooseLocationPage> {
  List<Map<String, dynamic>> _farmers = [];

  Future<void> _fetchFarmers(String location) async {
    final response = await fetchFarmersFromApi(location); // Replace with your API call function
    setState(() {
      _farmers = response;
    });
  }

  Future<List<Map<String, dynamic>>> fetchFarmersFromApi(String location) async {
  // Replace with your API endpoint
  final url = 'http://localhost:8080/viewmapfarmer?location=$location';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Parse the JSON data
    final List<dynamic> data = json.decode(response.body);
    return data.map((e) => e as Map<String, dynamic>).toList();
  } else if (response.statusCode == 400) {
    // Handle invalid location error
    throw Exception('Invalid location');
  } else {
    throw Exception('Failed to load farmers');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                locationContainer('MACHANG', 'assets/images/machang_image.png'),
                locationContainer('CAMERON HIGHLANDS', 'assets/images/cameron_highlands_image.png'),
                locationContainer('BESUT', 'assets/images/besut_image.png'),
              ],
            ),
          ),
          CustomFooter(),
        ],
      ),
    );
  }

  Widget locationContainer(String location, String imagePath) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    // Optionally, fetch farmers data for the selected location
                    await _fetchFarmers(location);

                    // Navigate to the MapPage after location selection
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage(
                        userType: 'Customer', selectedLocation: location)
                        , ),);},
                        child: Text('Select Location'),),],),),],),);}}

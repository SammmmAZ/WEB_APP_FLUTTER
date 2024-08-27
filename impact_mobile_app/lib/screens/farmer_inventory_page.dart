import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<InventoryItem>> _inventoryItems;
  List<InventoryItem> _filteredItems = [];
  String _selectedSortOption = 'Name';

  @override
  void initState() {
    super.initState();
    _inventoryItems = fetchInventoryData();
  }

  Future<List<InventoryItem>> fetchInventoryData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/inventory'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<InventoryItem> items = jsonResponse.map((item) => InventoryItem.fromJson(item)).toList();
      setState(() {
        _filteredItems = items;
      });
      return items;
    } else {
      throw Exception('Failed to load inventory');
    }
  }

  void _filterItems(String query) {
    final results = _filteredItems.where((item) =>
        item.goodsName.toLowerCase().contains(query.toLowerCase())).toList();

    setState(() {
      _filteredItems = results;
      _sortItems(); // Apply sorting after filtering
    });
  }

  void _sortItems() {
    switch (_selectedSortOption) {
      case 'Price':
        _filteredItems.sort((a, b) => a.goodsPrice.compareTo(b.goodsPrice));
        break;
      case 'Type':
        _filteredItems.sort((a, b) => a.goodsType.compareTo(b.goodsType));
        break;
      case 'Quantity':
        _filteredItems.sort((a, b) => a.goodsQuantity.compareTo(b.goodsQuantity));
        break;
      default:
        _filteredItems.sort((a, b) => a.goodsName.compareTo(b.goodsName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyClicks.com', textAlign: TextAlign.center),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.png'), // Path to your background image
            fit: BoxFit.cover, // Cover the entire container
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _filterItems,
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedSortOption,
                    items: <String>['Name', 'Price', 'Type', 'Quantity']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSortOption = newValue!;
                        _sortItems(); // Apply sorting when the selection changes
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<InventoryItem>>(
                future: _inventoryItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No inventory data found.'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Display items in a grid of 4 columns
                        childAspectRatio: 3 / 4, // Adjust aspect ratio as needed
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        InventoryItem item = _filteredItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 5, 68, 145).withOpacity(0.9), // Grey color with opacity
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: item.goodsImage != null
                                    ? Image.memory(
                                        base64Decode(item.goodsImage!),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      )
                                    : Icon(Icons.image, size: 100),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.goodsName, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text('Quantity: ${item.goodsQuantity}'),
                              Text('Price: \$${item.goodsPrice}'),
                              Text('Type: ${item.goodsType}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryItem {
  final String goodsName;
  final String? goodsImage;
  final String goodsQuantity;
  final String goodsPrice;
  final String goodsType;

  InventoryItem({
    required this.goodsName,
    this.goodsImage,
    required this.goodsQuantity,
    required this.goodsPrice,
    required this.goodsType,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      goodsName: json['goods_name'],
      goodsImage: json['goods_image'],
      goodsQuantity: json['goods_quantity'].toString(),
      goodsPrice: json['goods_price'].toString(),
      goodsType: json['goods_type'],
    );
  }
}

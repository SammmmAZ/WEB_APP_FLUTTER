import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'farmer_manage_order_page.dart'; // Import the new page

class Order {
  final String id;  // Assuming there's an ID field for orders
  final String goodsName;
  final int goodsQuantity;
  final double goodsPrice;
  final String orderDate;

  Order({
    required this.id,
    required this.goodsName,
    required this.goodsQuantity,
    required this.goodsPrice,
    required this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      goodsName: json['goods_name'],
      goodsQuantity: json['goods_quantity'],
      goodsPrice: json['goods_price'],
      orderDate: json['order_date'],
    );
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> _orders;
  List<Order> _filteredOrders = [];
  String _searchQuery = '';
  String _sortCriteria = 'Date';

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('http://localhost:8080/orders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Order.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  void initState() {
    super.initState();
    _orders = fetchOrders();
    _orders.then((orders) {
      setState(() {
        _filteredOrders = orders;
      });
    });
  }

  void _filterOrders(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredOrders = _filteredOrders.where((order) {
        return order.goodsName.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _sortOrders(String criteria) {
    setState(() {
      _sortCriteria = criteria;
      if (criteria == 'Date') {
        _filteredOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      } else if (criteria == 'Name') {
        _filteredOrders.sort((a, b) => a.goodsName.compareTo(b.goodsName));
      } else if (criteria == 'Quantity') {
        _filteredOrders.sort((a, b) => a.goodsQuantity.compareTo(b.goodsQuantity));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterOrders,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _sortCriteria,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _sortOrders(newValue);
                }
              },
              items: <String>['Date', 'Name', 'Quantity']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _orders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No orders found.'));
                } else {
                  return Container(
                    color: Colors.grey[200], // Background color for the entire list
                    child: ListView.builder(
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        Order order = _filteredOrders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FarmerManageOrderPage(
                                  orderId: order.id,
                                  itemName: order.goodsName,
                                  orderDate: order.orderDate,
                                  itemQuantity: order.goodsQuantity,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.0), // Margin around each item
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color for each item
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26, // Shadow color
                                  blurRadius: 4.0, // Shadow blur radius
                                  offset: Offset(0, 2), // Shadow offset
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(order.goodsName),
                              subtitle: Text('Quantity: ${order.goodsQuantity}\nPrice: \$${order.goodsPrice}\nDate: ${order.orderDate}'),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

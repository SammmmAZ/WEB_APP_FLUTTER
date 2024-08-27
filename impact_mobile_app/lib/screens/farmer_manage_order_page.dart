import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FarmerManageOrderPage extends StatefulWidget {
  final String orderId;
  final String itemName;
  final String orderDate;
  final int itemQuantity;

  FarmerManageOrderPage({
    required this.orderId,
    required this.itemName,
    required this.orderDate,
    required this.itemQuantity,
  });

  @override
  _FarmerManageOrderPageState createState() => _FarmerManageOrderPageState();
}

class _FarmerManageOrderPageState extends State<FarmerManageOrderPage> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _completeOrder() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.delete(
      Uri.parse('http://localhost:8080/deleteorder/${widget.orderId}'),
    );

    setState(() {
      _isLoading = false;
      _isSuccess = response.statusCode == 200;
    });

    if (_isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order completed successfully!')),
      );
      Navigator.of(context).pop(); // Go back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete the order.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    Text('Item Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.itemName),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Order Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.orderDate),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Item Quantity:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.itemQuantity.toString()),
                  ],
                ),
              ],
            ),
            Spacer(),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _completeOrder,
                      child: Text('Complete Order'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

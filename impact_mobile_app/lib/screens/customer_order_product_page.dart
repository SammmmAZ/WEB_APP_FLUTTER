import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl package

class CustomerOrderProductPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String? productImage;

  CustomerOrderProductPage({
    required this.productName,
    required this.productPrice,
    this.productImage,
  });

  @override
  _CustomerOrderProductPageState createState() =>
      _CustomerOrderProductPageState();
}

class _CustomerOrderProductPageState extends State<CustomerOrderProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a date for the order.')));
        return;
      }

      final String quantity = _quantityController.text;
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(_selectedDate!); // Format date

      final response = await http.post(
        Uri.parse('http://localhost:8080/insertorders'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'goodsName': widget.productName,    // Corrected field name
          'goodsPrice': widget.productPrice,  // Corrected field name
          'goodsQuantity': quantity,          // Corrected field name
          'orderDate': formattedDate,        // Send formatted date as 'yyyy-MM-dd'
        }),
      );

      if (response.statusCode == 201) {
        // Handle successful order submission
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order placed successfully!')));
      } else {
        // Handle error during order submission
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.productImage != null)
                Center(
                  child: Image.memory(
                    base64Decode(widget.productImage!),
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 16),
              Text('Product Name: ${widget.productName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Product Price: \$${widget.productPrice}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Enter Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Please enter a valid number greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate == null
                    ? 'Select Order Date'
                    : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  child: Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

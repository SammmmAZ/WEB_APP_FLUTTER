import 'package:farmer_app/screens/farmer_inventory_page.dart';
import 'package:farmer_app/screens/farmer_order_page.dart';
import 'package:flutter/material.dart';
import '../widgets/my_app_widgets.dart'; // Import the widget file

// import the reusable header
import '../widgets/app_header.dart';

// import the reusable footer
import '../widgets/app_footer.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  Color _InventoryContainerColor = const Color.fromARGB(255, 4, 59, 6);
  Color _InventoryTextColor = Colors.white;

  Color _OrderContainerColor = const Color.fromARGB(255, 4, 59, 6);
  Color _OrderTextColor = Colors.white;

  void _onInventoryHoverEnter() {
    setState(() {
      _InventoryContainerColor = Colors.white;
      _InventoryTextColor = Colors.green;
    });
  }

  void _onInventoryHoverExit() {
    setState(() {
      _InventoryContainerColor = Color.fromARGB(255, 4, 59, 6);
      _InventoryTextColor = Colors.white;
    });
  }

  void _onOrderHoverEnter() {
    setState(() {
      _OrderContainerColor = Colors.white;
      _OrderTextColor = Colors.green;
    });
  }

  void _onOrderHoverExit() {
    setState(() {
      _OrderContainerColor = Color.fromARGB(255, 4, 59, 6);
      _OrderTextColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Using the reusable CustomAppBar
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/app_background.png'), // Path to your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Farmer Button
                    Container(
                      height: 200,
                      width: 200,
                      color: _InventoryContainerColor,
                      child: MouseRegion(
                        onEnter: (_) => _onInventoryHoverEnter(),
                        onExit: (_) => _onInventoryHoverExit(),
                        child: MyAppButton(
                          imageUrl: 'assets/images/checklist.png',
                          buttonText: 'Check Inventory',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InventoryPage()),
                            );
                          },
                          containerColor: _InventoryContainerColor,
                          textColor: _InventoryTextColor,
                          onHoverEnter: _onInventoryHoverEnter,
                          onHoverExit: _onInventoryHoverExit,
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Add spacing between buttons
                    // Consumer Button
                    Container(
                      height: 200,
                      width: 200,
                      color: _OrderContainerColor,
                      child: MouseRegion(
                        onEnter: (_) => _onOrderHoverEnter(),
                        onExit: (_) => _onOrderHoverExit(),
                        child: MyAppButton(
                          imageUrl: 'assets/images/order.png',
                          buttonText: 'Check Orders',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrdersPage()),
                            );
                          },
                          containerColor: _OrderContainerColor,
                          textColor: _OrderTextColor,
                          onHoverEnter: _onOrderHoverEnter,
                          onHoverExit: _onOrderHoverExit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomFooter(), // Adding the reusable CustomFooter at the bottom
        ],
      ),
    );
  }
}

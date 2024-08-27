import 'package:farmer_app/screens/farmer_login_page.dart';
import 'package:flutter/material.dart';
import '../widgets/my_app_widgets.dart'; // Import the widget file
import 'package:farmer_app/screens/customer_login_page.dart';

// import the reusable header
import '../widgets/app_header.dart';

// import the reusable footer
import '../widgets/app_footer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _farmerContainerColor = const Color.fromARGB(255, 4, 59, 6);
  Color _farmerTextColor = Colors.white;

  Color _consumerContainerColor = const Color.fromARGB(255, 4, 59, 6);
  Color _consumerTextColor = Colors.white;

  void _onFarmerHoverEnter() {
    setState(() {
      _farmerContainerColor = Colors.white;
      _farmerTextColor = Colors.green;
    });
  }

  void _onFarmerHoverExit() {
    setState(() {
      _farmerContainerColor = Color.fromARGB(255, 4, 59, 6);
      _farmerTextColor = Colors.white;
    });
  }

  void _onConsumerHoverEnter() {
    setState(() {
      _consumerContainerColor = Colors.white;
      _consumerTextColor = Colors.green;
    });
  }

  void _onConsumerHoverExit() {
    setState(() {
      _consumerContainerColor = Color.fromARGB(255, 4, 59, 6);
      _consumerTextColor = Colors.white;
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
                      color: _farmerContainerColor,
                      child: MouseRegion(
                        onEnter: (_) => _onFarmerHoverEnter(),
                        onExit: (_) => _onFarmerHoverExit(),
                        child: MyAppButton(
                          imageUrl: 'assets/images/farmer_icon.png',
                          buttonText: 'Farmer',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FarmerLoginPage()),
                            );
                          },
                          containerColor: _farmerContainerColor,
                          textColor: _farmerTextColor,
                          onHoverEnter: _onFarmerHoverEnter,
                          onHoverExit: _onFarmerHoverExit,
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Add spacing between buttons
                    // Consumer Button
                    Container(
                      height: 200,
                      width: 200,
                      color: _consumerContainerColor,
                      child: MouseRegion(
                        onEnter: (_) => _onConsumerHoverEnter(),
                        onExit: (_) => _onConsumerHoverExit(),
                        child: MyAppButton(
                          imageUrl: 'assets/images/customer_icon.png',
                          buttonText: 'Consumer',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerLoginPage()),
                            );
                          },
                          containerColor: _consumerContainerColor,
                          textColor: _consumerTextColor,
                          onHoverEnter: _onConsumerHoverEnter,
                          onHoverExit: _onConsumerHoverExit,
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

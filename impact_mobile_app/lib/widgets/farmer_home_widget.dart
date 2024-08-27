// lib/widgets/farmer_home_widget.dart
import 'package:flutter/material.dart';

class FarmerHomeWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const FarmerHomeWidget({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green, // Default color
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 50), // Ensure the image is in the assets folder
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}

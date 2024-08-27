import 'package:flutter/material.dart';

class MyAppButton extends StatelessWidget {
  final String imageUrl;
  final String buttonText;
  final VoidCallback onPressed;
  final Color containerColor;
  final Color textColor;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  const MyAppButton({
    required this.imageUrl,
    required this.buttonText,
    required this.onPressed,
    required this.containerColor,
    required this.textColor,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: Container(
        margin: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // Container with rounded edges and circular image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(350), // Rounded edges
                color: Colors.grey.shade200, // Background color for the container
              ),
              child: ClipOval(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: containerColor,
                foregroundColor: textColor,
              ),
              child: Text(buttonText, style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
    );
  }
}

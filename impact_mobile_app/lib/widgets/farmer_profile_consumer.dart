import 'package:flutter/material.dart';

class FarmerProfile_Consumer extends StatelessWidget {
  final String pfpPath;
  final String farmerName;
  final String rating;
  final String distance;
  final VoidCallback onTap;

  const FarmerProfile_Consumer({
    Key? key,
    required this.pfpPath,
    required this.farmerName,
    required this.rating,
    required this.distance,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  pfpPath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Rating: $rating"),
                  Text("$distance km away"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

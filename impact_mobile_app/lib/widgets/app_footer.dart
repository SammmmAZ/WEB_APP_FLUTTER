import 'package:flutter/material.dart';

// REUSABLE WIDGET COMPONENT FOR THE APP FOOTER
// FOOTER REMAINS CONSTANT
// INSERT ICONS
// INSERT COPYRIGHT INFORMATION, PRODUCTION INFORMATION HERE

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // footer is formatted as a container
    // with a row and 3 columns

    return Container(
      padding: EdgeInsets.all(16.0),
      // footer and header will share the same background color
      color: const Color.fromARGB(255, 196, 126, 46), // Background color for the footer
      // child of the container formatted into rows
      child: Row(
        // read up later on what the 2 lines below does
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        // expands the child element into their own column
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // first element
                Row(
                  children: [
                    Icon(Icons.copyright),
                    SizedBox(width: 8.0),
                    Text('© 2024 EasyClicks'),
                  ],
                ),
                // second element
                Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 8.0),
                    Text('All Rights Reserved'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.build),
                    SizedBox(width: 8.0),
                    Text('Built with Flutter & Node.Js'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.code),
                    SizedBox(width: 8.0),
                    Text('Version 1.5.1'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8.0),
                    Text('Developed by Aura, Leanne, Yusuf'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 8.0),
                    Text('Contact: 22115257@imail.sunway.edu.my'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

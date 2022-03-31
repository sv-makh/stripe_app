import 'package:flutter/material.dart';

Widget myCard(BuildContext context,
    String image, String name, String date, String honey, String manufacturer, String value) {

  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.network(image),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              Text(date),
              Text("$honey $manufacturer - $value"),
            ],
          ),
        ],
      ),
    ),
  );
}
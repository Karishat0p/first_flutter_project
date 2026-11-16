import 'package:flutter/material.dart';
import 'package:first_flutter_project/domain/models/card.dart';

class DetailsPage extends StatelessWidget {
  final CardData data;

  const DetailsPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.amber),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.network(data.imageUrl ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 16.0),
            child: Text(
              data.text,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              data.descriptionText,
              style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


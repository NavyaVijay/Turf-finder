import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Map turf;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.turf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(turf['TurfName']),
      ),
    );
  }
}
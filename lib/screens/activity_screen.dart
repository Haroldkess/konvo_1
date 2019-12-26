import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Konvo',
          style: TextStyle(
            color: Colors.yellow,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Activity',
          style: TextStyle(color: Colors.yellow),
        ),
      ),
    );
  }
}

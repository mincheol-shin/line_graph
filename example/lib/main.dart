import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:line_graph/line_graph.dart';

void main() {
  runApp(MaterialApp(home: LineGraphExample()));
}

class LineGraphExample extends StatefulWidget {
  @override
  _LineGraphExampleState createState() => _LineGraphExampleState();
}

class _LineGraphExampleState extends State<LineGraphExample> {
  double _weight = 50.0;

  List<double> _data = [10, 20, 10, 40, 50];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Line Graph Example"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: 150.0,
              alignment: Alignment.center,
              color: Colors.grey[200],
              child: Text(
                "$_weight kg",
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
              ),
            ),
            LineGraphWidget(
              data: _data,
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:line_graph/line_graph.dart';

void main() {
  runApp(MaterialApp(home: LineGraphExample()));
}

class LineGraphExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Line Graph Example"),
          centerTitle: true,
        ),
        body: Container());
  }
}

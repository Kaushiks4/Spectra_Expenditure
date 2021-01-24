import 'package:flutter/material.dart';
import 'package:spectra/screens/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Loading());
  }
}

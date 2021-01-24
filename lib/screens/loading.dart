import 'package:flutter/material.dart';
import 'package:spectra/screens/loginPage.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    });
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/spectraLoading.jpg"),
          width: 200,
          height: 200,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

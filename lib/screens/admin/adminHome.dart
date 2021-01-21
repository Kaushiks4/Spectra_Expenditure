import 'package:flutter/material.dart';
import 'package:spectra/screens/admin/changeAdmin.dart';
import 'package:spectra/screens/admin/payment.dart';
import 'package:spectra/screens/client/clients.dart';
import 'package:spectra/screens/project/headAndSubhead.dart';
import 'package:spectra/screens/project/projects.dart';
import 'package:spectra/screens/project/reports.dart';
import 'package:spectra/screens/user/employees.dart';

class AdminHome extends StatefulWidget {
  final String name;
  AdminHome(this.name);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spectra Associates',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SingleChildScrollView(
              child: DrawerHeader(
                child: Text(
                  'Welcome ' + widget.name,
                  style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Projects',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewProjects(widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Clients',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewClients(widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Employees',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewEmployees(widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Reports',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Reports(widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Add Heads and Subheads',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HeadAndSubhead(widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Payments',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Payment('', widget.name)));
              },
            ),
            ListTile(
              title: Text(
                'Change login credentials',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ChangeAdmin(widget.name)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

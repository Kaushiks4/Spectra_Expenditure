import 'package:flutter/material.dart';
import 'package:spectra/screens/admin/payment.dart';
import 'package:spectra/screens/project/createProject.dart';
import 'package:spectra/screens/project/editProjects.dart';
import 'package:spectra/screens/user/expenses.dart';
import 'package:spectra/screens/user/income.dart';

class LoginHome extends StatefulWidget {
  final String name;
  final List<String> permissions;
  LoginHome(this.name, this.permissions);

  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  @override
  Widget build(BuildContext context) {
    print(widget.permissions);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spectra Associates',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Logout',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))
        ],
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
            (widget.permissions
                        .indexWhere((element) => element == "Add Projects") !=
                    -1)
                ? ListTile(
                    title: Text(
                      'Field Project',
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
                              builder: (context) =>
                                  new CreateProject(widget.name, 'Field')));
                    },
                  )
                : Container(),
            (widget.permissions
                        .indexWhere((element) => element == "Add Projects") !=
                    -1)
                ? ListTile(
                    title: Text(
                      'Office Project',
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
                              builder: (context) =>
                                  new CreateProject(widget.name, 'Office')));
                    },
                  )
                : Container(),
            (widget.permissions.indexWhere(
                        (element) => element == "Add Expenditure") !=
                    -1)
                ? ListTile(
                    title: Text(
                      'Expenditure',
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
                              builder: (context) => new Expenses(widget.name)));
                    },
                  )
                : Container(),
            (widget.permissions
                        .indexWhere((element) => element == "Add Income") !=
                    -1)
                ? ListTile(
                    title: Text(
                      'Income',
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
                              builder: (context) => new Income(widget.name)));
                    },
                  )
                : Container(),
            (widget.permissions
                        .indexWhere((element) => element == "Edit Projects") !=
                    -1)
                ? ListTile(
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
                              builder: (context) =>
                                  new EditProjects(widget.name)));
                    },
                  )
                : Container(),
            (widget.permissions.indexWhere(
                        (element) => element == "Add/Manage Payments") !=
                    -1)
                ? ListTile(
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
                              builder: (context) =>
                                  new Payment('', widget.name)));
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

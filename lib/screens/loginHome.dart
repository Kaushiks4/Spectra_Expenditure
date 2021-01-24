import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spectra',
          style: TextStyle(
            fontSize: 20.0,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Spectra Associates',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            (widget.permissions
                        .indexWhere((element) => element == "Add Projects") !=
                    -1)
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new CreateProject(widget.name)));
                        },
                        child: Text(
                          'New Project',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            (widget.permissions.indexWhere(
                        (element) => element == "Add Expenditure") !=
                    -1)
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new Expenses(widget.name)));
                        },
                        child: Text(
                          'Expenditure',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            (widget.permissions
                        .indexWhere((element) => element == "Add Income") !=
                    -1)
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new Income(widget.name)));
                        },
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            (widget.permissions
                        .indexWhere((element) => element == "Edit Projects") !=
                    -1)
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new EditProjects(widget.name)));
                        },
                        child: Text(
                          'Projects',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spectra/models/employee.dart';
import 'package:spectra/screens/user/addEmployee.dart';
import 'package:spectra/screens/user/editEmployee.dart';

class ViewEmployees extends StatefulWidget {
  final String name;
  ViewEmployees(this.name);
  @override
  _ViewEmployeesState createState() => _ViewEmployeesState();
}

class _ViewEmployeesState extends State<ViewEmployees> {
  bool loading = true;
  List<Employee> employees;

  @override
  void initState() {
    super.initState();
    employees = new List();
    loadData();
  }

  Future loadData() async {
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("Users").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> items = data.value;
      if (items != null) {
        for (var key in items.keys) {
          employees.add(
              Employee(name: key, password: items[key]['password'].toString()));
        }
        employees.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 3,
            ))
          : dataBody(pr),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AddEmployee(widget.name))),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget dataBody(ProgressDialog pr) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            'Employees',
            style: TextStyle(fontSize: 25),
          )),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 15,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
                ),
              ],
              rows: employees
                  .map((employee) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              employee.name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              employee.password,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataCell(IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new EditEmployee(
                                        employee.name, widget.name))),
                          )),
                          DataCell(IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('Delete ' +
                                                employee.name +
                                                '?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            child: Text('Yes'),
                                            onPressed: () async {
                                              pr.style(
                                                message: 'Deleting..',
                                                borderRadius: 10.0,
                                                backgroundColor: Colors.white,
                                                progressWidget:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5.0,
                                                ),
                                                elevation: 10.0,
                                                insetAnimCurve:
                                                    Curves.easeInOut,
                                              );
                                              final rmRef = FirebaseDatabase
                                                  .instance
                                                  .reference()
                                                  .child("Spectra");
                                              await rmRef
                                                  .child("Users")
                                                  .child(employee.name)
                                                  .remove();
                                              pr.hide();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new ViewEmployees(
                                                              widget.name)));
                                            }),
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      );
}

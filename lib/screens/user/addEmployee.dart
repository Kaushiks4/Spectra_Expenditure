import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:spectra/screens/user/employees.dart';

class AddEmployee extends StatefulWidget {
  final String name;
  AddEmployee(this.name);
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  String name, password;
  List<String> privelages = [
    "Add Projects",
    "Add Expenditure",
    "Edit Projects",
    "Add Income",
  ];
  List<String> permissions;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    permissions = new List();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'Add new Employee',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 5, 50, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              name = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Employee Name',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              password = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.multiple(
                            items: privelages.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Permissions..",
                            searchHint: "Privelages",
                            onChanged: (value) {
                              permissions.clear();
                              for (var k in value) {
                                if (mounted) {
                                  setState(() {
                                    permissions.add(privelages.elementAt(k));
                                  });
                                }
                              }
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        permissions.length > 0
                            ? Center(
                                child: Text(
                                  permissions.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate() &&
                          permissions.length != 0) {
                        pr.style(
                          message: 'Creating...',
                          borderRadius: 10.0,
                          backgroundColor: Colors.white,
                          progressWidget: CircularProgressIndicator(
                            strokeWidth: 5.0,
                          ),
                          elevation: 10.0,
                          insetAnimCurve: Curves.easeInOut,
                        );
                        await pr.show();
                        await create();
                        pr.hide();
                        Fluttertoast.showToast(
                            msg: "Created " + name + " Successfully!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new ViewEmployees(widget.name)));
                      } else {
                        if (permissions.length == 0) {
                          Fluttertoast.showToast(
                              msg: "Provide permissions",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future create() async {
    Map<dynamic, dynamic> per = new Map();
    for (var k in permissions) {
      per[k] = k;
    }
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("Users").child(name).set({
      'name': name,
      'password': password,
      'permissions': per,
    });
  }
}

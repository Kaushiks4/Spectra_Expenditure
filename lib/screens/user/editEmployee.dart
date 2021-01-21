import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:spectra/screens/user/employees.dart';

class EditEmployee extends StatefulWidget {
  final String name, id;
  EditEmployee(this.name, this.id);
  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  List<String> permissions;
  bool loading = true;
  List<String> privelages = [
    "Add Projects",
    "Add Expenditure",
    "Add Income",
    "Edit Projects",
    "Add/Manage Payments"
  ];
  String name, newName, password;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    permissions = new List();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef
        .child("Users")
        .child(widget.name)
        .once()
        .then((DataSnapshot data) {
      Map<dynamic, dynamic> items = data.value;
      if (items != null) {
        name = items["name"].toString();
        newName = name;
        password = items["password"].toString();
        for (var k in items["permissions"].keys) {
          permissions.add(k);
        }
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
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
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              setState(() {
                                newName = val.trim();
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: name,
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
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text(
                          'Password: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              setState(() {
                                password = val.trim();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: password,
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
                        ),
                      ],
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
                    SizedBox(height: 20.0),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm?'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Name : ' + newName,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Password : ' + password,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Permissions : ' +
                                            permissions.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Update'),
                                    onPressed: () async {
                                      pr.style(
                                        message: 'Updating..',
                                        borderRadius: 10.0,
                                        backgroundColor: Colors.white,
                                        progressWidget:
                                            CircularProgressIndicator(
                                          strokeWidth: 5.0,
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                      );
                                      await pr.show();
                                      Map<dynamic, dynamic> per = new Map();
                                      for (var k in permissions) {
                                        per[k] = k;
                                      }
                                      final bgRef = FirebaseDatabase.instance
                                          .reference()
                                          .child("Spectra");
                                      if (newName != name) {
                                        await bgRef
                                            .child("Users")
                                            .child(name)
                                            .remove();
                                      }
                                      await bgRef
                                          .child("Users")
                                          .child(newName)
                                          .set({
                                        'name': newName,
                                        'password': password,
                                        'permissions': per,
                                      });
                                      pr.hide();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new ViewEmployees(
                                                      widget.id)));
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Update',
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
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}

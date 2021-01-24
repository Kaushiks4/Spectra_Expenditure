import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:spectra/models/encryption.dart';

class CreateProject extends StatefulWidget {
  final String name;
  CreateProject(this.name);
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  bool loading = true;
  String pid, pName, clientName, timeStamp, details, fee, type, dept, location;
  DateFormat _dateFormat = new DateFormat('dd-MM-yyyy-hh:mm');
  List<String> clients;
  List<String> types = [
        "Road",
        "Tank",
        "Irrigation",
        "Layout",
        "Building",
        "Others"
      ],
      depts = ["MI", "PRED", "PWD", "Hemavathi", "Tuda", "NH", "Others"],
      loc = ["Field", "Office"];
  final _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> database;

  @override
  void initState() {
    super.initState();
    clients = new List();
    loadData();
  }

  Future loadData() async {
    database = new Map();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    await bgRef
        .child("Projects")
        .limitToLast(1)
        .once()
        .then((DataSnapshot data) {
      Map<dynamic, dynamic> projects = data.value;
      if (projects != null) {
        int id = 0;
        for (var key in projects.keys) {
          id = int.parse(key.split("%")[1]);
          break;
        }
        id += 1;
        setState(() {
          pid = 'P#' + id.toString();
        });
      } else {
        setState(() {
          pid = 'P#1';
        });
      }
    });
    if (database["Clients"] != null) {
      for (var key in database["Clients"].keys) {
        clients.add(database["Clients"][key]['clientName']);
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
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
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Center(
                          child: Text(
                            'Create Project',
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        Text(
                          'Project ID: ' + pid,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Project location: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: loc.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Search type",
                            searchHint: "Type..",
                            onChanged: (value) {
                              location = value;
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Type of Project: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: types.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Search type",
                            searchHint: "Type..",
                            onChanged: (value) {
                              type = value;
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Choose Client: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: clients.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Search Client",
                            searchHint: "Client",
                            onChanged: (value) {
                              clientName = value;
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Department: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: depts.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Search department",
                            searchHint: "Department..",
                            onChanged: (value) {
                              dept = value;
                            },
                            dialogBox: true,
                            isExpanded: true,
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
                                    validator: (val) =>
                                        val.isEmpty ? 'Required' : null,
                                    onChanged: (val) {
                                      setState(() {
                                        pName = val.trim();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Project Name',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 6.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey[400]),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Required' : null,
                                    onChanged: (val) {
                                      setState(() {
                                        details = val.trim();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Project Details',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 6.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey[400]),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              )),
                        ),
                        SizedBox(height: 20.0),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                pr.style(
                                  message: 'Updating..',
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
                                pid = Encrypt.decodeString(pid);
                                Fluttertoast.showToast(
                                    msg: "Created " + pid + " Successfully!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[800],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.of(context).pop();
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
                  )),
            ),
    );
  }

  Future create() async {
    var d = DateTime.now();
    timeStamp = _dateFormat.format(d);
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    pid = Encrypt.encodeString(pid);
    await bgRef.child("Projects").child(pid).set({
      'pName': pName,
      'type': type,
      'dept': dept,
      'clientName': clientName,
      'timeStamp': timeStamp,
      'details': details,
      'fee': 0,
      'pid': pid,
      'payBalance': 0,
      'location': location,
    });
  }
}

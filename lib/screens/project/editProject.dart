import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/screens/project/editProjects.dart';

class EditProject extends StatefulWidget {
  final String name, id;
  final Map<dynamic, dynamic> database;
  EditProject(this.id, this.name, this.database);
  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  bool loading = true;
  String clientName, dept, details, fee, pName, type, balance, location;
  List<String> types = [
        "Road",
        "Tank",
        "Irrigation",
        "Layout",
        "Building",
        "Others"
      ],
      depts = ["MI", "PRED", "PWD", "Hemavathi", "Tuda", "NH", "Others"],
      locs = ["Field", "Office"];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    String id = Encrypt.encodeString(widget.id);
    if (widget.database["Projects"][id] != null) {
      clientName = widget.database["Projects"][id]['clientName'];
      type = widget.database["Projects"][id]["type"];
      dept = widget.database["Projects"][id]['dept'];
      details = widget.database["Projects"][id]['details'];
      fee = widget.database["Projects"][id]['fee'].toString();
      pName = widget.database["Projects"][id]['pName'];
      balance = widget.database["Projects"][id]["payBalance"].toString();
      location = widget.database["Projects"][id]["location"].toString();
    }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'ID: ' + widget.id,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Project Name: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              setState(() {
                                pName = val.trim();
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: pName,
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
                          'Details: ',
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
                                details = val.trim();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: details,
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
                    Row(
                      children: [
                        Text(
                          'Fee: ',
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
                                fee = val.trim();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: fee,
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
                    Text(
                      'Location: ' + location,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                      child: SearchableDropdown.single(
                        items: locs.map((exNum) {
                          return (DropdownMenuItem(
                              child: Text(exNum), value: exNum));
                        }).toList(),
                        hint: "Search Location",
                        searchHint: "Location..",
                        onChanged: (value) {
                          setState(() {
                            location = value;
                          });
                        },
                        dialogBox: true,
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Department: ' + dept,
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
                          setState(() {
                            dept = value;
                          });
                        },
                        dialogBox: true,
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Type: ' + type,
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
                          setState(() {
                            type = value;
                          });
                        },
                        dialogBox: true,
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name : ' + pName,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Details : ' + details,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Department : ' + dept,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Type : ' + type,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Fee : ' + fee,
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
                                      final bgRef = FirebaseDatabase.instance
                                          .reference()
                                          .child("Spectra");
                                      int bal = int.parse(fee) -
                                          int.parse(balance).abs();
                                      String id =
                                          Encrypt.encodeString(widget.id);
                                      await bgRef
                                          .child("Projects")
                                          .child(id)
                                          .update({
                                        'pName': pName,
                                        'details': details,
                                        'fee': int.parse(fee),
                                        'payBalance': bal,
                                        'type': type,
                                        'dept': dept,
                                        'location': location
                                      });
                                      pr.hide();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new EditProjects(
                                                      widget.name)));
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

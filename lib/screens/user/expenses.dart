import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/models/project.dart';
import 'package:spectra/screens/loginHome.dart';

class Expenses extends StatefulWidget {
  final String name;
  Expenses(this.name);
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool loading = true, hloading = true;
  String date,
      remarks,
      amount,
      receipt,
      accountName,
      projectId,
      filename,
      imurl,
      head,
      subHead;
  DateFormat _dateFormat = DateFormat('dd-MM-yyyy-hh:mm');
  final _formKey = GlobalKey<FormState>();
  List<Project> projects;
  List<String> heads, sheads;
  File file;
  Map<dynamic, dynamic> database;

  @override
  void initState() {
    super.initState();
    database = new Map();
    loadData();
  }

  Future loadSheads() async {
    sheads = new List();
    if (database["SHeads"][head] != null) {
      for (var sub in database["SHeads"][head].keys) {
        sheads.add(sub);
      }
    } else {
      sheads = [''];
      setState(() {
        hloading = false;
      });
    }
    if (mounted) {
      setState(() {
        hloading = false;
      });
    }
  }

  Future loadData() async {
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    projects = new List();
    if (database["Projects"] != null) {
      for (var k in database["Projects"].keys) {
        for (var pid in database["Projects"][k].keys) {
          projects.add(Project.select(
              pName: database["Projects"][k][pid]['details'],
              pid: Encrypt.decodeString(pid)));
        }
      }
    }
    heads = new List();
    if (database["Heads"] != null) {
      for (var head in database["Heads"].keys) {
        heads.add(head);
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  List<DropdownMenuItem<String>> buildName(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (Project listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.pName),
          value: listItem.pid,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildHead(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
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
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Expenses',
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Choose Project: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: projects.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum.pName), value: exNum.pid));
                            }).toList(),
                            hint: "Type Name",
                            searchHint: "Name",
                            onChanged: (value) {
                              projectId = value;
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        Text(
                          'Choose Head: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                          child: SearchableDropdown.single(
                            items: heads.map((exNum) {
                              return (DropdownMenuItem(
                                  child: Text(exNum), value: exNum));
                            }).toList(),
                            hint: "Type Name",
                            searchHint: "Name",
                            onChanged: (value) async {
                              setState(() {
                                hloading = true;
                                head = value;
                              });
                              await loadSheads();
                            },
                            dialogBox: true,
                            isExpanded: true,
                          ),
                        ),
                        Text(
                          'Choose Sub Head: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        hloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 10.0, 40, 0),
                                child: SearchableDropdown.single(
                                  items: sheads.map((exNum) {
                                    return (DropdownMenuItem(
                                        child: Text(exNum), value: exNum));
                                  }).toList(),
                                  hint: "Subhead..",
                                  searchHint: "Subhead",
                                  onChanged: (value) {
                                    subHead = value;
                                  },
                                  dialogBox: true,
                                  isExpanded: true,
                                ),
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
                                        remarks = val.trim();
                                      });
                                    },
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Remarks',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 6.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        val.isEmpty ? 'Required' : null,
                                    onChanged: (val) {
                                      setState(() {
                                        amount = val.trim();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Amount',
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
                                ],
                              )),
                        ),
                        SizedBox(height: 20.0),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                pr.style(
                                  message: 'Opening..',
                                  borderRadius: 10.0,
                                  backgroundColor: Colors.white,
                                  progressWidget: CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                  ),
                                  elevation: 10.0,
                                  insetAnimCurve: Curves.easeInOut,
                                );
                                await pr.show();
                                await filePicker(context);
                                Future.delayed(Duration(seconds: 2), () {
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: "File Uploaded Successfully!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[800],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                              }
                            },
                            child: Text(
                              'Upload Reciept',
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
                        SizedBox(height: 10),
                        (imurl != null)
                            ? Center(
                                child: CachedNetworkImage(
                                  imageUrl: imurl,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              )
                            : Container(),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  imurl != null) {
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
                                update();
                                Future.delayed(Duration(seconds: 2), () {
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: "Updated Successfully!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[800],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.of(context).pop();
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Receipt not uploaded!!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[800],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text(
                              'Submit',
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

  Future update() async {
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    projectId = Encrypt.encodeString(projectId);
    await bgRef.child("Expenses").child(projectId).update({
      date: {
        'pid': Encrypt.decodeString(projectId),
        'remarks': remarks,
        'amount': amount,
        'reciept': imurl,
        'timeStamp': date,
        'name': widget.name,
        'head': head,
        'shead': subHead,
      }
    });
  }

  Future filePicker(BuildContext context) async {
    DateTime d = new DateTime.now();
    if (mounted) {
      setState(() {
        date = _dateFormat.format(d);
      });
    }
    try {
      file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
      setState(() {
        filename =
            projectId + date + '.' + file.path.split('/').last.split('.').last;
      });
      await _uploadFile();
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Connection Error!!'),
              content: Text('Unsupported file format' + e.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> _uploadFile() async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    var url = (await downloadUrl.ref.getDownloadURL());
    if (mounted) {
      setState(() {
        imurl = url;
      });
    }
  }
}

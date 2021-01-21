import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/models/project.dart';
import 'package:spectra/screens/admin/photoview.dart';

class OpenProject extends StatefulWidget {
  final String pid, name;
  OpenProject(this.pid, this.name);
  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends State<OpenProject> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool loading = true, expense = false, income = false;
  Map<dynamic, dynamic> project, database;
  String type;
  List<Project> expenses;
  List<Project> incomes;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    project = new Map();
    expenses = new List();
    incomes = new List();
    loadData();
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {}
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future loadData() async {
    database = new Map();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    String id = Encrypt.encodeString(widget.pid);
    type = (id[0] == 'P') ? 'Field' : 'Office';
    project = database["Projects"][type][id];
    project['pid'] = Encrypt.decodeString(project['pid'].toString());
    project['clientName'] =
        database["Clients"][project['clientName']]['clientName'];
    if (database["Expenses"][id] != null) {
      for (var key in database["Expenses"][id].keys) {
        expenses.add(Project.expense(
            date: key,
            head: database["Expenses"][id][key]['head'],
            subhead: (database["Expenses"][id][key]['shead'] != null)
                ? database["Expenses"][id][key]['shead']
                : ' ',
            remarks: database["Expenses"][id][key]['remarks'],
            amount: database["Expenses"][id][key]['amount'],
            name: database["Expenses"][id][key]['name'],
            reciept: database["Expenses"][id][key]['reciept']));
      }
      if (expenses != null) {
        expenses = sorting(expenses);
      }
    }
    if (database["Income"][id] != null) {
      for (var key in database["Income"][id].keys) {
        incomes.add(Project.income(
            date: key,
            remarks: database["Income"][id][key]['remarks'],
            amount: database["Income"][id][key]['amount'].toString(),
            name: database["Income"][id][key]['recievedBy'],
            reciept: database["Income"][id][key]['reciept'],
            balance: database["Income"][id][key]['balance'].toString()));
      }
      if (incomes != null) {
        incomes = sorting(incomes);
      }
    }
    setState(() {
      loading = false;
    });
  }

  sorting(List<dynamic> items) {
    items.sort((a, b) {
      var d = a.date.split("-");
      var d1 = new DateTime(
          int.parse(d[2]),
          int.parse(d[1]),
          int.parse(d[0]),
          int.parse(d[3].split(":")[0]),
          int.parse(d[3].split(":")[1]),
          (d[3].split(":").length > 2) ? int.parse(d[3].split(":")[2]) : 0);
      var c = b.date.split("-");
      var d2 = new DateTime(
          int.parse(c[2]),
          int.parse(c[1]),
          int.parse(c[0]),
          int.parse(c[3].split(":")[0]),
          int.parse(c[3].split(":")[1]),
          (c[3].split(":").length > 2) ? int.parse(c[3].split(":")[2]) : 0);
      if (d1.isBefore(d2)) {
        return 0;
      } else {
        return 1;
      }
    });
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
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      project['pName'].toString(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      'id: ' + project["pid"].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      'Details: ' + project["details"].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      'Fee: ' + project["fee"].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      'Balance: ' + project["balance"].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      'Client Name: ' + project["clientName"].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              expense = !expense;
                              income = false;
                            });
                          }
                        },
                        child: Text(
                          'Expenses',
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
                      SizedBox(
                        width: 50,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              income = !income;
                              expense = false;
                            });
                          }
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
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  (expense || income)
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 0, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                expense ? 'Expenses' : 'Income',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FlatButton(
                                onPressed: () async {
                                  pr.style(
                                    message: 'Downloading..',
                                    borderRadius: 10.0,
                                    backgroundColor: Colors.white,
                                    progressWidget: CircularProgressIndicator(
                                      strokeWidth: 5.0,
                                    ),
                                    elevation: 10.0,
                                    insetAnimCurve: Curves.easeInOut,
                                  );
                                  await pr.show();
                                  expense
                                      ? await downloadExpense()
                                      : await downloadIncome();
                                  pr.hide();
                                },
                                child: Text(
                                  'Download (Excel)',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        )
                      : Container(),
                  dataBody(context),
                ],
              ),
            ),
    );
  }

  downloadExpense() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add(["Project id", widget.pid]);
    rows.add(
        ["Date", "Name", "Head", "Sub Head", "Amount", "Remarks", "Receipt"]);
    for (int i = 0; i < expenses.length; i++) {
      List<dynamic> row = List();
      row.add(expenses[i].date);
      row.add(expenses[i].name);
      row.add(expenses[i].head);
      row.add(expenses[i].subhead);
      row.add(expenses[i].amount);
      row.add(expenses[i].remarks);
      row.add(expenses[i].reciept);
      rows.add(row);
    }
    rows.add([]);
    try {
      Directory dir = await getExternalStorageDirectory();
      String filename = widget.pid + " expenses.xlsx";
      final savePath = join(dir.path, filename);
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      for (int i = 0; i < rows.length; i++) {
        sheetObject.appendRow(rows[i]);
      }
      excel.encode().then((onValue) {
        File(join(savePath))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
      Map<String, dynamic> result = {
        'isSuccess': true,
        'filePath': savePath,
        'error': null
      };
      await _requestPermissions();
      await _showNotification(result);
    } on PlatformException {}
  }

  downloadIncome() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add(["Project id", widget.pid]);
    rows.add(
        ["Date", "Name", "Head", "Sub Head", "Amount", "Remarks", "Receipt"]);
    for (int i = 0; i < expenses.length; i++) {
      List<dynamic> row = List();
      row.add(incomes[i].date);
      row.add(incomes[i].name);
      row.add(incomes[i].amount);
      row.add(incomes[i].remarks);
      row.add(incomes[i].reciept);
      rows.add(row);
    }
    rows.add([]);
    try {
      Directory dir = await getExternalStorageDirectory();
      String filename = widget.pid + " income.xlsx";
      final savePath = join(dir.path, filename);
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      for (int i = 0; i < rows.length; i++) {
        sheetObject.appendRow(rows[i]);
      }
      excel.encode().then((onValue) {
        File(join(savePath))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
      Map<String, dynamic> result = {
        'isSuccess': true,
        'filePath': savePath,
        'error': null
      };
      await _requestPermissions();
      await _showNotification(result);
    } on PlatformException {}
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  Widget dataBody(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: (expense || income)
          ? Stack(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
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
                          'Amount',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Reciept',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: expense
                        ? expenses
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
                                        employee.amount,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(Icons.download_rounded),
                                        onPressed: () => Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => new Photo(
                                                    employee.reciept,
                                                    employee.name,
                                                    'jpg'))),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList()
                        : incomes
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
                                        employee.amount,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(Icons.download_rounded),
                                        onPressed: () => Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => new Photo(
                                                    employee.reciept,
                                                    employee.name,
                                                    'jpg'))),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                  ),
                ),
              ],
            )
          : Container());
}

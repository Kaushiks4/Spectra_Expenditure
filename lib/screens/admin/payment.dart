import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/models/project.dart';

class Payment extends StatefulWidget {
  final String pid, name;
  Payment(this.pid, this.name);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool loading = true, sload = false;
  String id, type, amount;
  int payB;
  List<Project> payments;
  List<Project> filteredProjects;
  final TextEditingController _controller = new TextEditingController();
  String searchText = '';
  DateFormat _dateFormat = DateFormat('dd-MM-yyyy-hh:mm');
  Map<dynamic, dynamic> database;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    payments = new List();
    database = new Map();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    if (widget.pid.isEmpty) {
      if (database["Projects"] != null) {
        for (var type in database["Projects"].keys) {
          for (var pid in database["Projects"][type].keys) {
            String id = Encrypt.decodeString(pid);
            payments.add(Project.adminPayment(
                pid: id,
                fee: database["Projects"][type][pid]['fee'].toString(),
                amount:
                    database["Projects"][type][pid]['payBalance'].toString()));
          }
          filteredProjects = payments;
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
    } else {
      id = Encrypt.encodeString(widget.pid);
      payB = 0;
      if (database["Payments"][id] != null) {
        for (var key in database["Payments"][id].keys) {
          payments.add(Project.userPayment(
              date: key,
              name: database["Payments"][id][key]['name'],
              amount: database["Payments"][id][key]['amount']));
          payB += int.parse(database["Payments"][id][key]['amount'].toString());
        }
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        payments = sorting(payments);
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    }
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

  Future<void> onSearch() async {
    if (mounted) {
      setState(() {
        sload = true;
        filteredProjects = [];
      });
    }
    for (var key in payments) {
      if (key.pid.toLowerCase().contains(searchText.toLowerCase()) ||
          key.fee.contains(searchText.toLowerCase()) ||
          key.amount.contains(searchText.toLowerCase())) {
        filteredProjects.add(key);
      }
    }
    if (mounted) {
      setState(() {
        sload = false;
      });
    }
  }

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
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : (widget.pid.isEmpty)
              ? adminBody()
              : userBody(),
    );
  }

  Widget userBody() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (val) => val.isEmpty ? 'Required' : null,
                  onChanged: (val) {
                    setState(() {
                      amount = val.trim();
                    });
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Amount',
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
              SizedBox(
                width: 20,
              ),
              FlatButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm?'),
                        content: Text('Add ' +
                            widget.name +
                            ' payment of Rs ' +
                            amount +
                            '?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              final bgRef = FirebaseDatabase.instance
                                  .reference()
                                  .child("Spectra");
                              String id = Encrypt.encodeString(widget.pid);
                              await bgRef
                                  .child("Payments")
                                  .child(id)
                                  .child(_dateFormat.format(DateTime.now()))
                                  .set({
                                'name': widget.name,
                                'amount': amount,
                                'timeStamp': _dateFormat.format(DateTime.now()),
                              });
                              loadData();
                              String type = (id.split("%")[0] == 'P')
                                  ? 'Field'
                                  : 'Office';
                              await bgRef
                                  .child("Projects")
                                  .child(type)
                                  .child(id)
                                  .once()
                                  .then((DataSnapshot data) {
                                Map<dynamic, dynamic> items = data.value;
                                if (items != null) {
                                  payB =
                                      int.parse(items['payBalance'].toString());
                                }
                              });
                              await bgRef
                                  .child("Projects")
                                  .child(type)
                                  .child(id)
                                  .update(
                                      {'payBalance': payB - int.parse(amount)});
                              Navigator.of(context).pop();
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
                  'Add Payment',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 15,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              ],
              rows: payments
                  .map((project) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              project.date,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              project.name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              project.amount,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total ' + payB.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ]),
      );

  Widget adminBody() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: new TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search..',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.only(left: 15.0, bottom: 1.0, top: 1.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                _controller.addListener(() {
                  if (_controller.text.isNotEmpty || _controller != null) {
                    setState(() {
                      searchText = _controller.text;
                    });
                    onSearch();
                  } else {
                    filteredProjects = payments;
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 15,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'PID',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Fee',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: filteredProjects
                  .map((project) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              project.pid,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new Payment(project.pid, widget.name))),
                          ),
                          DataCell(
                            Text(
                              project.fee,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new Payment(project.pid, widget.name))),
                          ),
                          DataCell(
                            Text(
                              project.amount,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new Payment(project.pid, widget.name))),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      );
}

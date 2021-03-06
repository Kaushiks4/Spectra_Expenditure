import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spectra/models/client.dart';
import 'package:spectra/screens/client/createClient.dart';
import 'package:spectra/screens/client/editClient.dart';
import 'package:spectra/screens/client/openClient.dart';

class ViewClients extends StatefulWidget {
  final String name;
  ViewClients(this.name);
  @override
  _ViewClientsState createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> {
  bool loading = true, sload = true;
  List<Client> clients;
  List<Client> filtered;
  final TextEditingController _controller = new TextEditingController();
  String searchText = '';
  Map<dynamic, dynamic> database;

  @override
  void initState() {
    super.initState();
    clients = new List();
    filtered = new List();
    loadData();
  }

  Future loadData() async {
    database = new Map();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    if (database["Clients"] != null) {
      for (var key in database["Clients"].keys) {
        clients.add(Client(
            name: database["Clients"][key]['clientName'],
            address: database["Clients"][key]['address'],
            phone: database["Clients"][key]['phone']));
      }
      filtered = clients;
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onSearch() async {
    setState(() {
      sload = true;
      filtered = [];
    });
    for (var key in clients) {
      if (key.name.toLowerCase().contains(searchText.toLowerCase()) ||
          key.phone.toLowerCase().contains(searchText.toLowerCase()) ||
          key.address.toLowerCase().contains(searchText.toLowerCase())) {
        filtered.add(key);
      }
    }
    setState(() {
      sload = false;
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
          : SingleChildScrollView(
              child: Column(
                children: [
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
                        contentPadding: const EdgeInsets.only(
                            left: 15.0, bottom: 1.0, top: 1.0),
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
                          if (_controller.text.isNotEmpty ||
                              _controller != null) {
                            setState(() {
                              searchText = _controller.text;
                            });
                            onSearch();
                          } else {
                            filtered = clients;
                          }
                        });
                      },
                    ),
                  ),
                  dataBody(pr)
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new CreateClient(widget.name))),
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 15,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Client Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: filtered
                  .map((client) => DataRow(
                        cells: [
                          DataCell(
                              Text(
                                client.name,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenClient(
                                          database,
                                          client.name,
                                          widget.name)))),
                          DataCell(
                              Text(
                                client.phone,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenClient(
                                          database,
                                          client.name,
                                          widget.name)))),
                          DataCell(Icon(Icons.edit),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new EditClient(
                                          widget.name, client.name)))),
                          DataCell(
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ), onTap: () {
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Delete ' + client.name + '?'),
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
                                              insetAnimCurve: Curves.easeInOut,
                                            );
                                            final rmRef = FirebaseDatabase
                                                .instance
                                                .reference()
                                                .child("Spectra");
                                            await rmRef
                                                .child("Clients")
                                                .child(client.name)
                                                .remove();
                                            pr.hide();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new ViewClients(
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
                          }),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      );
}

import 'package:flutter/material.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/models/project.dart';
import 'package:spectra/screens/project/openProject.dart';

class OpenClient extends StatefulWidget {
  final Map<dynamic, dynamic> database;
  final String phone, name;
  OpenClient(this.database, this.phone, this.name);
  @override
  _OpenClientState createState() => _OpenClientState();
}

class _OpenClientState extends State<OpenClient> {
  bool loading = true;
  List<Project> projects;
  @override
  void initState() {
    super.initState();
    projects = new List();
    loadData();
  }

  Future loadData() async {
    if (widget.database["Projects"] != null) {
      for (var k in widget.database["Projects"].keys) {
        for (var pid in widget.database["Projects"][k].keys) {
          String id = Encrypt.decodeString(pid);
          String type = (id.split("#")[0] == 'P') ? 'Field' : 'Office';
          if (widget.database["Projects"][type][pid]['clientName'].toString() ==
              widget.phone) {
            projects.add(Project.view(
                pid: id,
                pName: widget.database["Projects"][type][pid]['pName'],
                fee: widget.database["Projects"][type][pid]['fee'].toString(),
                balance: widget.database["Projects"][type][pid]['balance']
                    .toString()));
          }
        }
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
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
          : dataBody(),
    );
  }

  Widget dataBody() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            widget.name,
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
                    'PID',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
                ),
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
                    'Balance',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: projects
                  .map((employee) => DataRow(
                        cells: [
                          DataCell(
                              Text(
                                employee.pid,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenProject(
                                          employee.pid, widget.name)))),
                          DataCell(
                              Text(
                                employee.pName,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenProject(
                                          employee.pid, widget.name)))),
                          DataCell(
                              Text(
                                employee.fee,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenProject(
                                          employee.pid, widget.name)))),
                          DataCell(
                              Text(
                                employee.balance,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new OpenProject(
                                          employee.pid, widget.name)))),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      );
}

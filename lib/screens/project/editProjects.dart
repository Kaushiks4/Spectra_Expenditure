import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spectra/models/encryption.dart';
import 'package:spectra/models/project.dart';
import 'package:spectra/screens/project/editProject.dart';

class EditProjects extends StatefulWidget {
  final String name;
  EditProjects(this.name);
  @override
  _EditProjectsState createState() => _EditProjectsState();
}

class _EditProjectsState extends State<EditProjects> {
  bool loading = true, sload = false;
  List<Project> projects;
  List<Project> filteredProjects;
  final TextEditingController _controller = new TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    projects = new List();
    filteredProjects = new List();
    loadData();
  }

  Future loadData() async {
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("Projects").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> items = data.value;
      if (items != null) {
        for (var key in items.keys) {
          for (var k in items[key].keys) {
            String id = Encrypt.decodeString(items[key][k]['pid'].toString());
            projects.add(Project.view(
                pid: id,
                pName: (items[key][k]['pName'] != null)
                    ? items[key][k]['pName']
                    : '',
                fee: items[key][k]['fee'].toString(),
                balance: items[key][k]['balance'].toString()));
            filteredProjects.add(Project.view(
                pid: id,
                pName: (items[key][k]['pName'] != null)
                    ? items[key][k]['pName']
                    : '',
                fee: items[key][k]['fee'].toString(),
                balance: items[key][k]['balance'].toString()));
          }
        }
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

  Future<void> onSearch() async {
    setState(() {
      sload = true;
      filteredProjects = [];
    });
    for (var key in projects) {
      if (key.pid.toLowerCase().contains(searchText.toLowerCase()) ||
          key.pName.toLowerCase().contains(searchText.toLowerCase()) ||
          key.fee.toLowerCase().contains(searchText.toLowerCase())) {
        filteredProjects.add(key);
      }
    }
    setState(() {
      sload = false;
    });
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
                            filteredProjects = projects;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                  dataBody()
                ],
              ),
            ),
    );
  }

  Widget dataBody() => SingleChildScrollView(
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
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Fee',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  numeric: false,
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
                                      builder: (context) => new EditProject(
                                          project.pid, widget.name)))),
                          DataCell(
                              Text(
                                project.pName,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new EditProject(
                                          project.pid, widget.name)))),
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
                                    builder: (context) => new EditProject(
                                        project.pid, widget.name))),
                          ),
                          DataCell(
                            Text(
                              project.balance,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new EditProject(
                                        project.pid, widget.name))),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      );
}

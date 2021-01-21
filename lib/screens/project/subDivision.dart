import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SubDivision extends StatefulWidget {
  final String name;
  SubDivision(this.name);
  @override
  _SubDivisionState createState() => _SubDivisionState();
}

class _SubDivisionState extends State<SubDivision> {
  bool loading = true, hloading = true;
  String head = '', shead;
  List<String> sheads, heads;
  Map<dynamic, dynamic> database;

  Future getSheads() async {
    sheads = new List();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("SHeads").child(head).once().then((DataSnapshot data) {
      Map<dynamic, dynamic> items = data.value;
      sheads.clear();
      if (database["SHeads"][head] != null) {
        for (var key in items.keys) {
          sheads.add(key);
        }
      }
    });
    if (mounted) {
      setState(() {
        hloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHeads();
  }

  Future getHeads() async {
    heads = new List();
    database = new Map();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    heads.clear();
    if (database["Heads"] != null) {
      for (var key in database["Heads"].keys) {
        heads.add(key);
      }
    }
    if (mounted) {
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Sub Heads',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
            child: SearchableDropdown.single(
              items: heads.map((exNum) {
                return (DropdownMenuItem(child: Text(exNum), value: exNum));
              }).toList(),
              hint: "Search head",
              searchHint: "Head",
              onChanged: (value) async {
                setState(() {
                  head = value;
                  hloading = true;
                });
                await getSheads();
              },
              dialogBox: true,
              isExpanded: true,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 10, 40, 0),
            child: TextFormField(
              validator: (val) => val.isEmpty ? 'Required' : null,
              onChanged: (val) {
                setState(() {
                  shead = val.trim();
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Subhead under ' + head + ' Name',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              onPressed: () async {
                if (shead != null && shead.isEmpty) {
                  final bgRef =
                      FirebaseDatabase.instance.reference().child("Spectra");
                  await bgRef
                      .child("SHeads")
                      .child(head)
                      .update({shead: shead});
                  if (mounted) {
                    setState(() {
                      hloading = true;
                    });
                  }
                  await getSheads();
                } else {
                  Fluttertoast.showToast(
                      msg: "Enter subhead!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[200],
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
              },
              child: Text(
                'Add',
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
          hloading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                )
              : new Expanded(child: createListView()),
        ],
      ),
    );
  }

  Widget createListView() {
    return new ListView.builder(
      itemCount: sheads.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            ListTile(
              title: new Text(sheads[index]),
            ),
          ],
        );
      },
    );
  }
}

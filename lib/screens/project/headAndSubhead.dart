import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spectra/screens/project/subDivision.dart';

class HeadAndSubhead extends StatefulWidget {
  final String name;
  HeadAndSubhead(this.name);
  @override
  _HeadAndSubheadState createState() => _HeadAndSubheadState();
}

class _HeadAndSubheadState extends State<HeadAndSubhead> {
  bool loading = true;
  String head;
  List<String> heads;

  Future getHeads() async {
    heads = new List();
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("Heads").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> items = data.value;
      heads.clear();
      if (items != null) {
        for (var key in items.keys) {
          heads.add(key);
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
  void initState() {
    super.initState();
    getHeads();
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
            'Head',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 10, 40, 0),
            child: TextFormField(
              validator: (val) => val.isEmpty ? 'Required' : null,
              onChanged: (val) {
                setState(() {
                  head = val.trim();
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Head Name',
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
                final bgRef =
                    FirebaseDatabase.instance.reference().child("Spectra");
                await bgRef.child("Heads").update({head: head});
                if (mounted) {
                  setState(() {
                    loading = true;
                  });
                }
                await getHeads();
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
          loading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                )
              : new Expanded(child: createListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SubDivision(widget.name)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget createListView() {
    return new ListView.builder(
      itemCount: heads.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            ListTile(
              title: new Text(heads[index]),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Delete ' + heads[index] + '?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  final rmRef = FirebaseDatabase.instance
                                      .reference()
                                      .child("Spectra");
                                  await rmRef
                                      .child("Heads")
                                      .child(heads[index])
                                      .remove();
                                  await rmRef
                                      .child("SHeads")
                                      .child(heads[index])
                                      .remove();
                                  Navigator.of(context).pop();
                                  await getHeads();
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
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

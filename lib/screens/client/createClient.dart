import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spectra/screens/client/clients.dart';

class CreateClient extends StatefulWidget {
  final String name;
  CreateClient(this.name);
  @override
  _CreateClientState createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  String clientName, phone, address;
  final _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Add new Client',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                                  clientName = val.trim();
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Client Name',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (val) => val.isEmpty
                                  ? 'Required'
                                  : (val.length != 10)
                                      ? 'Invalid Contact No'
                                      : null,
                              onChanged: (val) {
                                setState(() {
                                  phone = val.trim();
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
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
                                  address = val.trim();
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Address',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
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
                          Fluttertoast.showToast(
                              msg: "Created " + clientName + " Successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new ViewClients(widget.name)));
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
    final bgRef = FirebaseDatabase.instance.reference().child("Spectra");
    await bgRef.child("Clients").child(phone).set({
      'clientName': clientName,
      'phone': phone,
      'address': address,
    });
  }
}

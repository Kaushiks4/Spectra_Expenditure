import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spectra/screens/admin/adminHome.dart';

class ChangeAdmin extends StatefulWidget {
  final String name;
  ChangeAdmin(this.name);
  @override
  _ChangeAdminState createState() => _ChangeAdminState();
}

class _ChangeAdminState extends State<ChangeAdmin> {
  String name = '', password = '', error = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Spectra Associates',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Edit Credentials',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                  ),
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
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              name = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Admin Name',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
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
                          obscureText: true,
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              password = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
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
                          obscureText: true,
                          validator: (val) => val.isEmpty
                              ? 'Required'
                              : (val == password)
                                  ? null
                                  : 'Passwords don\'t match!',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confirm Password',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
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
                        message: 'Updating...',
                        borderRadius: 10.0,
                        backgroundColor: Colors.white,
                        progressWidget: CircularProgressIndicator(
                          strokeWidth: 5.0,
                        ),
                        elevation: 10.0,
                        insetAnimCurve: Curves.easeInOut,
                      );
                      await pr.show();
                      await login(pr);
                      Fluttertoast.showToast(
                          msg: "Updated to " + name + " successfully!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0);
                      pr.hide();
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AdminHome(
                                  (name.isEmpty) ? widget.name : name)));
                    }
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
        ));
  }

  Future login(ProgressDialog pr) async {
    final loginRef = FirebaseDatabase.instance.reference().child('Spectra');
    await loginRef.child("Admins").set({
      name: {'password': password}
    });
  }
}

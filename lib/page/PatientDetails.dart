import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/page/NavPage.dart';

class PatientDetails extends StatefulWidget {
  PatientDetails({Key key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  var fileUrl = "no file uploaded";
  File file;
  var fileNameText = "No File Choosed";

  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  TextEditingController data3 = new TextEditingController();
  TextEditingController data4 = new TextEditingController();
  uploadReport() async {
    print("sad1" + fileUrl);
    final _firebaseStorage = FirebaseStorage.instance;

    if (file != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child(
              'patients/${FirebaseAuth.instance.currentUser.uid}/${Path.basename(file.path)}')
          .putFile(file);
      fileUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        uploadData();
      });
    } else {
      setState(() {
        uploadData();
      });
      print('No Image file Received');
    }
  }

  void uploadData() async {
    final user = FirebaseAuth.instance.currentUser;
    List<String> friendList = [];

    print("in upload data");
    Map<String, dynamic> data = {
      "field1": data1,
      "field2": data2,
      "field3": data3,
      "field4": data4
    };
    await FirebaseFirestore.instance
        .collection("patientinfo")
        .doc(user.uid)
        .set({
      'age': data1.text,
      'address': data2.text,
      'contact': data3.text,
      'medical_history': data4.text,
      'report_url': fileUrl,
      'name': user.displayName,
      'email': user.email
    });
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'nickname': user.displayName,
      'photoUrl': user.photoURL,
      'userId': user.uid,
      'email': user.email,
      'friends': friendList,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null,
      'online': null
    });
  }

  Future<void> chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      print(file.path);
      setState(() {
        fileNameText = Path.basename(file.path);
      });
    } else {
      // User canceled the picker

    }
  }

  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "Enter Your Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 3,
                controller: data1,
                decoration: const InputDecoration(
                  counterText: "",
                  icon: Icon(Icons.person, color: Colors.indigo),
                  // hintText: 'What do people call you?',
                  labelText: 'Age *',
                ),
                // onSaved: (String? value) {
                //   // This optional block of code can be used to run
                //   // code when the user saves the form.
                // },
                validator: (value) {
                  return (value.isEmpty ? "Please Enter Age" : null);
                },
              ),
              TextFormField(
                minLines: 1,
                maxLines: 3,
                controller: data2,
                decoration: const InputDecoration(
                  icon: Icon(Icons.home, color: Colors.indigo),
                  // hintText: 'What do people call you?',
                  labelText: 'Address *',
                ),
                // onSaved: (String? value) {
                //   // This optional block of code can be used to run
                //   // code when the user saves the form.
                // },
                validator: (value) {
                  return (value.isEmpty ? "Please Enter Address" : null);
                },
                //               validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please enter some text';
                //   }
                //   return null;
                // },
                // validator: (text) {
                //     if (!(text.length > 5) && text.isNotEmpty) {
                //       return "Enter valid name of more then 5 characters!";
                //     }
                //     return null;
                //   },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: data3,
                decoration: const InputDecoration(
                  counterText: "",

                  icon: Icon(Icons.phone, color: Colors.indigo),
                  // hintText: 'What do people call you?',
                  labelText: 'Contact Number *',
                ),
                // onSaved: (String? value) {
                //   // This optional block of code can be used to run
                //   // code when the user saves the form.
                // },
                validator: (value) {
                  return (value.isEmpty ? "Please Enter Contact Number" : null);
                },
              ),
              TextFormField(
                minLines: 1,
                maxLines: 5,
                controller: data4,
                decoration: const InputDecoration(
                  icon: Icon(Icons.local_hospital, color: Colors.indigo),
                  hintText: 'Write N/A if no Medical History',
                  labelText: 'Medical History ',
                ),
                // onSaved: (String? value) {
                //   // This optional block of code can be used to run
                //   // code when the user saves the form.
                // },
                // validator: (value) {
                //   return (value.isEmpty ? "Please Enter Medical History" : null);
                // },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(" Upload Medical Report",
                      style: TextStyle(fontSize: 18), textAlign: TextAlign.end)
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      chooseFile();
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.lightBlue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        //padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: file != null
                                  ? Container(
                                      padding: EdgeInsets.all(10),
                                      child: Image(
                                        width: 100,
                                        height: 100,
                                        // decoration: BoxDecoration(color: Colors. red),
                                        image: AssetImage(
                                            'assets/images/pdfFile.png'),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(10),
                                      child: Image(
                                        width: 100,
                                        height: 100,
                                        image: AssetImage(
                                            'assets/images/pdfAdd.png'),
                                      ),
                                    ),
                            ),
                            Text(fileNameText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await uploadReport();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) {
                                return NavPage();
                              },
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

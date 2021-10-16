import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/page/NavPage.dart';

class DoctorDetails extends StatefulWidget {
  DoctorDetails({Key key}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  final _formKey = GlobalKey<FormState>();

  var fileUrl;
  File file;
  var fileNameText = "No File Choosed";

  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  TextEditingController data3 = new TextEditingController();
  TextEditingController data4 = new TextEditingController();
  TextEditingController data5 = new TextEditingController();
  uploadReport() async {
    final _firebaseStorage = FirebaseStorage.instance;

    if (file != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child(
              'doctors/${FirebaseAuth.instance.currentUser.uid}/${Path.basename(file.path)}')
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
    // print("in upload data");
    List<String> friendList = [];
    await FirebaseFirestore.instance
        .collection("doctorinfo")
        .doc(user.uid)
        .set({
      'speciality': data1.text,
      'hospital_name': data2.text,
      'contact': data3.text,
      'experience': data4.text,
      'degree_url': fileUrl,
      'name': user.displayName,
      'email': user.email,
      'degree': data5.text
    });
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'nickname': user.displayName,
      'photoUrl': user.photoURL,
      'userId': user.uid,
      'email': user.email,
      'friends': friendList,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Padding(
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
                  controller: data1,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.indigo),
                    hintText: 'eg.Dermatologist',
                    labelText: 'Speciality Field  *',
                  ),
                  validator: (value) {
                    return (value.isEmpty
                        ? "Please Enter Speciality Field "
                        : null);
                  },
                ),
                TextFormField(
                  controller: data2,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.home, color: Colors.indigo),
                    labelText: 'Hospital Name *',
                  ),
                  validator: (value) {
                    return (value.isEmpty
                        ? "Please Enter Hospital Name"
                        : null);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: data3,
                  decoration: const InputDecoration(
                    counterText: "",
                    icon: Icon(Icons.phone, color: Colors.indigo),
                    labelText: 'Contact *',
                  ),
                  validator: (value) {
                    return (value.isEmpty
                        ? "Please Enter contact number"
                        : null);
                  },
                ),
                TextFormField(
                  controller: data4,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.local_hospital, color: Colors.indigo),
                    hintText: 'in years',
                    labelText: 'Experience *',
                  ),
                  validator: (value) {
                    return (value.isEmpty ? "Please Enter Experience" : null);
                  },
                ),
                TextFormField(
                  controller: data5,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.book_sharp,
                      color: Colors.indigo,
                    ),
                    labelText: 'Degree *',
                  ),
                  validator: (value) {
                    return (value.isEmpty ? "Please Enter Degree" : null);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(" Upload Medical Degree Certificate",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.end)
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
                    constraints:
                        BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await uploadReport();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => NavPage(),
                            //   ),
                            // );
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
      ),
    );
  }
}

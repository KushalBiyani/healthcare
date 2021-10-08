import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/page/sign_up_page.dart';
import 'package:my_app/provider/google_sign_in.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController mobileNo = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController medicalHistory = new TextEditingController();
  TextEditingController experience = new TextEditingController();
  TextEditingController hospitalName = new TextEditingController();
  TextEditingController degree = new TextEditingController();
  TextEditingController speciality = new TextEditingController();

  String userPhotoURL = "";
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  // final user = FirebaseAuth.instance.currentUser;
  // print(user.uid);
  bool existencePatient;
  Future<void> fetchDataPatient() async {
    try {
      await FirebaseFirestore.instance
          .collection('patientinfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        existencePatient = value.exists;
        if (existencePatient) {
          name.text = value.data()['name'];
          age.text = value.data()['age'];
          mobileNo.text = value.data()['contact'];
          address.text = value.data()['address'];
          medicalHistory.text = value.data()['medical_history'];
          userPhotoURL = FirebaseAuth.instance.currentUser.photoURL;
          email.text = FirebaseAuth.instance.currentUser.email;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  bool existenceDoctor;
  Future<void> fetchDataDoctor() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctorinfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        existenceDoctor = value.exists;
        if (existenceDoctor) {
          name.text = value.data()['name'];
          experience.text = value.data()['experience'];
          mobileNo.text = value.data()['contact'];
          degree.text = value.data()['degree'];
          speciality.text = value.data()['speciality'];
          hospitalName.text = value.data()['hospital_name'];
          userPhotoURL = FirebaseAuth.instance.currentUser.photoURL;
          email.text = FirebaseAuth.instance.currentUser.email;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      // title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Information Updated Successfully"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('close'),
        ),
      ],
    );
  }

  Widget showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel",style: TextStyle(fontSize: 20),),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget deleteButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      child: Text("Delete"),
      onPressed: () {
        if (existencePatient == true) {
          FirebaseFirestore.instance
              .collection('patientinfo')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .delete();
        } else {
          FirebaseFirestore.instance
              .collection('doctorinfo')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .delete();
        }
        FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .delete();
        Navigator.of(context, rootNavigator: true).pop();
        signOutGoogle();
        signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return SignUpWidget();
            },
          ),
          (Route<dynamic> route) => false,
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: Text("Are you sure want to delete account ?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDataPatient();
    fetchDataDoctor();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // name.text = "Viresh";

    // print(name.text);
    // print(email.text);
    // print(age.text);
    // print(mobileNo.text);
    // print(address.text);
    // print(medicalHistory.text);

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Container(
              //   height: 250.0,
              //   color: Colors.white,
              //   child: Column(
              //     children: <Widget>[
              //       Padding(
              //         padding: EdgeInsets.only(top: 20.0),
              //         child: Stack(fit: StackFit.loose, children: <Widget>[
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: <Widget>[
              //               Container(
              //                   width: 140.0,
              //                   height: 140.0,
              //                   decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     image: DecorationImage(
              //                       image:
              //                           ExactAssetImage('assets/images/as.png'),
              //                       // NetworkImage(userPhotoURL),

              //                       fit: BoxFit.cover,
              //                     ),
              //                   )),
              //             ],
              //           ),
              //           Padding(
              //               padding: EdgeInsets.only(top: 90.0, right: 100.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: <Widget>[
              //                   GestureDetector(
              //                     child: CircleAvatar(
              //                       backgroundColor: Colors.indigo,
              //                       radius: 25.0,
              //                       child: Icon(
              //                         Icons.camera_alt,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                     onTap: () => Text("Pressed"),
              //                   )
              //                 ],
              //               )),
              //         ]),
              //       )
              //     ],
              //   ),
              // ),
              Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: name,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
                                    // Text("VIRESH"),
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email ID',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Email ID"),
                                  enabled: false,
                                ),
                              ),
                            ],
                          )),
                      existencePatient == true
                          ? Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Age',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: age,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Your Age"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ))
                            ])
                          : Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Experience',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: experience,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Enter Your Experience"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ))
                            ]),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Mobile No',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: mobileNo,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      existencePatient == true
                          ? Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Address',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: address,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Address"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ))
                            ])
                          : Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Hospital Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: hospitalName,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Hospital Name"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ))
                            ]),
                      existencePatient == true
                          ? Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Medical History',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: medicalHistory,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Enter Medical History"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ))
                            ])
                          : Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Degree',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: degree,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Degree"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Speciality',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: speciality,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Speciality"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                            ]),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Container(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red[700]),
                          child: Text("Delete Account",style: TextStyle(fontSize: 20),),
                          // textColor: Colors.white,
                          // color: Colors.red,
                          onPressed: () {
                            setState(() {
                              showAlertDialog(context);
                            });
                          },
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(20.0)),
                        )),
                      ),
                      // flex: 2,

                      !_status ? _getActionButtons() : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Save",style: TextStyle(fontSize: 20),),
                // textColor: Colors.white,
                // color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                    existencePatient == true
                        ? FirebaseFirestore.instance
                            .collection('patientinfo')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .update({
                            "name": name.text,
                            // 'email' : email.text,
                            'age': age.text,
                            'contact': mobileNo.text,
                            'address': address.text,
                            'medical_history': medicalHistory.text
                          })
                        : FirebaseFirestore.instance
                            .collection('doctorinfo')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .update({
                            "name": name.text,
                            // 'email' : email.text,
                            'degree': degree.text,
                            'contact': mobileNo.text,
                            'experience': experience.text,
                            'hospital_name': hospitalName.text,
                            'speciality': speciality.text
                          });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    );
                  });
                },
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Cancel",style: TextStyle(fontSize: 20),),
                // textColor: Colors.white,
                // color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.indigo,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}

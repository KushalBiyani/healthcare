import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/page/NavPage.dart';
import 'package:my_app/page/UserType.dart';
import 'package:my_app/provider/google_sign_in.dart';
import 'package:my_app/provider/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: OutlineButton.icon(
          label: Text(
            'Sign In With Google',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.black,
          borderSide: BorderSide(color: Colors.black),
          textColor: Colors.black,
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          onPressed: () async {
            await signInWithGoogle().then((result) async {
              if (result != null) {
                await fetchData();
                FirebaseFirestore.instance
                    .collection('patientinfo')
                    .doc(result)
                    .get()
                    .then(
                      (value) => value.exists == true
                          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) {
                  return NavPage();
                },
              ),
              (Route<dynamic> route) => false,
            )
                          : FirebaseFirestore.instance
                              .collection('doctorinfo')
                              .doc(result)
                              .get()
                              .then(
                                (value) => value.exists == true
                                    ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) {
                  return NavPage();
                },
              ),
              (Route<dynamic> route) => false,
            )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserType(),
                                        ),
                                      ),
                              ),
                    );
              }
            });
          },
        ),
      );
}

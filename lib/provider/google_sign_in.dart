import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    imageUrl = user.photoURL;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    return '${user.uid}';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> signOut() async {
  return _auth.signOut();
}

Future<String> login(email, pw, BuildContext context) async {
  try {
    UserCredential authResult =
        await _auth.signInWithEmailAndPassword(email: email, password: pw);
    final User user = authResult.user;
    if (user != null) {
      return '$user';
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Login Failed'),
              content: Text('Please check the entered details again'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
  return null;
}

Future<String> register(String email, String pw, BuildContext context) async {
  try {
    UserCredential authResult =
        await _auth.createUserWithEmailAndPassword(email: email, password: pw);
    final User user = authResult.user;
    if (user != null) {
      return '$user';
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Registration Failed'),
              content: Text('User already exists'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
  return null;
}

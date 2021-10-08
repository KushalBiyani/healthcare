import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/page/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/page/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider/google_sign_in.dart';

class MenuScreen extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int) callback;
  final int current;

  MenuScreen(
    this.mainMenu, {
    Key key,
    this.callback,
    this.current,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final widthBox = SizedBox(
    width: 16.0,
  );

String name , email ;
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
         name = value.data()['name'];
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
         name = value.data()['name'];
        }
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    fetchDataPatient();
    fetchDataDoctor();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        // print(existence);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // String name = user.displayName;
    email = user.email;
    final TextStyle androidStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = kIsWeb
        ? androidStyle
        : Platform.isAndroid
            ? androidStyle
            : iosStyle;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Colors.indigo,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24.0, left: 24.0, right: 24.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.photoURL),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 13.0, left: 24.0, right: 24.0),
                child: Text(
                  tr("$name"),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24.0, left: 24.0, right: 24.0),
                child: Text(
                  tr("$email"),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Selector<MenuProvider, int>(
                selector: (_, provider) => provider.currentPage,
                builder: (_, index, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widget.mainMenu
                        .map((item) => MenuItemWidget(
                              key: Key(item.index.toString()),
                              item: item,
                              callback: widget.callback,
                              widthBox: widthBox,
                              style: style,
                              selected: index == item.index,
                            ))
                        .toList()
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tr("logout"),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: () {
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
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final Widget widthBox;
  final TextStyle style;
  final Function callback;
  final bool selected;

  final white = Colors.white;

  const MenuItemWidget({
    Key key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => callback(item.index),
      color: selected ? Color(0x44000000) : null,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            color: white,
            size: 24,
          ),
          widthBox,
          Expanded(
            child: Text(
              item.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final int index;

  const MenuItem(this.title, this.icon, this.index);
}

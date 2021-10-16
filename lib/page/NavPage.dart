import 'package:my_app/page/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MenuProvider(),
        child: HomeScreen(),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Stories extends StatefulWidget {
  Stories({Key key}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _StoriesState extends State<Stories> {
  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctorinfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Future<void> _launched;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('doctorinfo')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('We got an Error ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    default:
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot blogContent =
                                  snapshot.data.docs[index];
                              return Container(
                                  child: Column(children: [
                                Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 20, 10),
                                    child: Text(
                                      'Dr. ' + blogContent.data()['name'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                                  child: Row(
                                    // row for content
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Degree : ",
                                      )),
                                      Expanded(
                                          child: Text(
                                        blogContent.data()['degree'],
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                                  child: Row(
                                    // row for content
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Experience :",
                                      )),
                                      Expanded(
                                          child: Text(
                                        blogContent.data()['experience'],
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                                  child: Row(
                                    // row for content
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Mobile No :",
                                      )),
                                      Expanded(
                                          child: Text(
                                        blogContent.data()['contact'],
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 10),
                                  child: Row(
                                    // row for content
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Specialist :",
                                      )),
                                      Expanded(
                                          child: Text(
                                        blogContent.data()['speciality'],
                                      ))
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo // background
                                      // onPrimary: Colors.white, // foreground
                                      ),
                                  onPressed: () => setState(() {
                                    String a = blogContent.data()['contact'];
                                    // print("number $a");
                                    _launched = _makePhoneCall('tel: $a');
                                  }),
                                  child: const Text(
                                    'Make phone call',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Divider(height: 15, thickness: 1),
                              ]));
                            },
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

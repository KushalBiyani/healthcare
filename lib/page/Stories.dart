import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';

class Stories extends StatefulWidget {
  Stories({Key key}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

// for 3- dot options in a post
enum Options { report }

// Like button code
Future<bool> onLikeButtonTapped(bool isLiked) async {
  /// send your request here
  // final bool success= await sendRequest();

  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

  return !isLiked;
}

class _StoriesState extends State<Stories> {
  TextEditingController blogText = new TextEditingController();
  bool isDoctor = false;

  // bool shouldDisplay = true;
  String _selection = "";

  String dataToShare = 'Sample text to share';

  void _shareContent(content) {
    Share.share(content);
  }

  void uploadData() {
    final user = FirebaseAuth.instance.currentUser;
    String name = user.displayName;
    String photoURL = user.photoURL;
    String uid = user.uid;
    // print("in upload data");
    // Map<String, dynamic> data = {
    //   "field1": blogText,
    // };
    FirebaseFirestore.instance.collection("blogs").add({
      'mainText': blogText.text,
      'likes': 0,
      'reports': 0,
      'photoURL': photoURL,
      'username': name,
      'uid': uid,
      'createdAt': Timestamp.now()
    });
    // print("done");
  }

  bool existence;
  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctorinfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        // print(value);
        existence = value.exists;
        print(existence);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Blog Posted Successfully"),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
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

  @override
  void initState() {
    super.initState();

    fetchData();
    // setState(() {});
    // print(existence);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          // blogText.clear();
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // fetchData()
              // Text(existence.toString()),
              existence == true
                  ? Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Write Your Blog")),
                        // Text(a),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Theme(
                              data: ThemeData(
                                primaryColor: Colors.indigo,
                                primaryColorDark: Colors.indigoAccent,
                              ),
                              child: TextFormField(
                                controller: blogText,
                                keyboardType: TextInputType.multiline,
                                minLines:
                                    1, //Normal textInputField will be displayed
                                maxLines:
                                    10, // when user presses enter it will adapt to it
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.indigo)),
                                  hintText: 'Write Here ...',
                                  labelText: 'Blog ',
                                ),

                                validator: (value) {
                                  return (value.isEmpty
                                      ? "Please Enter Some text "
                                      : null);
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                setState(() {
                                  // flag = false;

                                  uploadData();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                  blogText.clear();
                                });
                              },
                              child: Text('Post')),
                        ),
                        Divider(height: 5, thickness: 2),
                      ],
                    )
                  : Container(),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blogs')
                      .orderBy('createdAt', descending: true)
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
                                // int timeInMillis =
                                //     (blogContent.data()['createdAt'].seconds) * 1000;
                                // var date = DateTime.fromMillisecondsSinceEpoch(
                                //     timeInMillis);
                                // var formattedDate =
                                //     DateFormat.yMMMd().format(date);

                                DateTime timestamp = blogContent.data()['createdAt'].toDate();
                                var formattedDateTime = DateFormat.yMMMd().add_jm().format(timestamp);

                                return Container(
                                    //    margin: EdgeInsets.only(top: 30, left: 20.0, right: 20.0),
                                    // padding: const EdgeInsets.all(10.0),

                                    child: Column(children: [
                                  
                                  // Text(existence.toString()),
                                  // Text(formattedDateTime),
                                  Row(
                                      // row for photo ,username , 3-dots
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(blogContent
                                                  .data()['photoURL']),
                                              // "https://drop.ndtv.com/homepage/images/icons/logo-on-dark-bg.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              // color: Colors.red,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 20, 20, 10),
                                                child: Text(blogContent
                                                    .data()['username']),
                                                // 'User Name') // ,style: TextStyle(fontSize: 22))
                                                // '${entries[index]}' )
                                              ),
                                            ),
                                            Container(
                                                // color: Colors.red,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                                  child: Text(formattedDateTime),
                                                ),
                                                )
                                          ],
                                        ),
                                        Container(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child: PopupMenuButton<Options>(
                                                  onSelected: (Options result) {
                                                    setState(() {
                                                      _selection = "report";
                                                    });
                                                  },
                                                  itemBuilder: (BuildContext
                                                          context) =>
                                                      <PopupMenuEntry<Options>>[
                                                    const PopupMenuItem<
                                                        Options>(
                                                      value: Options.report,
                                                      child: Text(
                                                          'Report this Post'),
                                                    ),
                                                  ],
                                                ))),
                                      ]),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 30, 10),
                                      child: Row(
                                        // row for content
                                        children: [
                                          Expanded(
                                              child: Text(
                                            blogContent.data()['mainText'],
                                            // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque dictum sollicitudin. Quisque ullamcorper at ex ornare maximus. Nam risus sapien, sollicitudin non nisl vel, ultricies finibus felis. Donec pharetra ligula nec sem molestie, vel venenatis libero volutpat. Quisque a ex ultrices, faucibus nulla id, sodales sem. Fusce molestie placerat vulputate. Duis ultrices nec purus et fermentum. Curabitur scelerisque odio sit amet augue bibendum scelerisque",
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      // Like Button
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              80, 10, 30, 10),
                                          child: LikeButton(
                                            size: 30,
                                            circleColor: CircleColor(
                                                start: Color(0xff00ddff),
                                                end: Color(0xff0099cc)),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:
                                                  Color(0xff33b5e5),
                                              dotSecondaryColor:
                                                  Color(0xff0099cc),
                                            ),
                                            likeBuilder: (bool isLiked) {
                                              return Icon(
                                                Icons.favorite,
                                                color: isLiked
                                                    ? Colors.deepPurpleAccent
                                                    : Colors.grey,
                                                size: 30,
                                              );
                                            },
                                            // likeCount: 999,
                                            countBuilder: (int count,
                                                bool isLiked, String text) {
                                              var color = isLiked
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.grey;
                                              Widget result;
                                              if (count == 0) {
                                                result = Text(
                                                  "love",
                                                  style:
                                                      TextStyle(color: color),
                                                );
                                              } else
                                                result = Text(
                                                  text,
                                                  style:
                                                      TextStyle(color: color),
                                                );
                                              return result;
                                            },
                                            onTap: onLikeButtonTapped,
                                          )),

                                      // share button
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 20, 20),
                                        child: Center(
                                          child: Column(children: [
                                            // Text(_content),
                                            SizedBox(height: 15),

                                            ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .indigo, // background
                                                  onPrimary: Colors
                                                      .white, // foreground
                                                ),
                                                // onPressed: _shareContent,
                                                onPressed: () {
                                                  setState(() {
                                                    dataToShare = blogContent
                                                                .data()[
                                                            'mainText'] +
                                                        "\n" +
                                                        "-written By " +
                                                        blogContent
                                                            .data()['username'];
                                                    _shareContent(dataToShare);
                                                  });
                                                },
                                                icon: Icon(Icons.share),
                                                label: Text('Share')),
                                            // Divider(height: 5, thickness: 2),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: 3, thickness: 1),
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
      ),
    );
  }
}

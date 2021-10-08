import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/page/HospitalDetails.dart';

class HospitalInfo extends StatefulWidget {
  HospitalInfo({Key key}) : super(key: key);

  @override
  _HospitalInfoState createState() => _HospitalInfoState();
}

class _HospitalInfoState extends State<HospitalInfo> {
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  TextEditingController textEditingController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String msg = '';
  var count = 0;
  String lattitude,longitude,number,address,name ;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Container(
                  width: 330,
                  height: 55,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: EdgeInsets.fromLTRB(10, 15, 0, 15),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        searchString = val.toUpperCase();
                        // print('$val');
                        // searchString = val;
                      });
                    },
                    controller: textEditingController,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(246, 245, 243, 1.0),
                            width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(246, 245, 243, 1.0),
                            width: 0.0),
                      ),
                      hintText: "Search products, sales and more",
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ]),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString == null || searchString.trim() == '')
                      ? FirebaseFirestore.instance
                          .collection('hospitals1')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('hospitals1')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('We got an Error ${snapshot.error}');
                    }

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.indigo),
                    ),
                        );

                      case ConnectionState.none:
                        return Text('oops no data');

                      case ConnectionState.done:
                        return Text('We are Done');

                      default:
                        return Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot hospitalslist =
                                  snapshot.data.docs[index];
                              String a = hospitalslist.data()['hospital_name'];
                              a = a.toUpperCase();
                              // print(a);

                              if (a.startsWith(searchString) ||
                                  searchString.trim() == '') {
                                return GestureDetector(
                                  
                                  onTap: () {
                                    setState(() {
                                      name =
                                          hospitalslist.data()['hospital_name'];
                                          lattitude =
                                          hospitalslist.data()['lattitude'];
                                          longitude =
                                          hospitalslist.data()['longitude'];
                                          number = hospitalslist.data()['phone'];
                                          address = hospitalslist.data()['address'];
                                          // DocumentSnapshot variable = FirebaseFirestore.instance.doc("$name").get();
                                      print("name:$lattitude");
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HospitalDetails(name,double.parse(lattitude),double.parse(longitude),number,address),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 110,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[400],
                                            ),
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://mk0ehealtheletsj3t14.kinstacdn.com/wp-content/uploads/2009/07/best-hospital-in-south-india.jpg"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 20, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    hospitalslist.data()[
                                                        'hospital_name'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 15, 0, 30),
                                                  child: Text(hospitalslist
                                                      .data()['locality']),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
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

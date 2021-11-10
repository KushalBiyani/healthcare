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
  String latitude, longitude, number, address, name;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
            },
            child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                height: height * 0.08,
                margin:
                    EdgeInsets.fromLTRB(10, height * 0.02, 0, height * 0.02),
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toUpperCase();
                    });
                  },
                  controller: textEditingController,
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
          ),
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Expanded(
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
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.indigo),
                        ),
                      );

                    case ConnectionState.none:
                      return Text('oops no data');

                    case ConnectionState.done:
                      return Text('We are Done');

                    default:
                      return Container(
                        height: height * 0.67,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot hospitalslist =
                                snapshot.data.docs[index];
                            String a = hospitalslist.data()['hospital_name'];
                            a = a.toUpperCase();

                            if (a.startsWith(searchString) ||
                                searchString.trim() == '') {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    name =
                                        hospitalslist.data()['hospital_name'];
                                    latitude = hospitalslist.data()['latitude'];
                                    longitude =
                                        hospitalslist.data()['longitude'];
                                    number = hospitalslist.data()['phone'];
                                    address = hospitalslist.data()['address'];
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HospitalDetails(
                                            name,
                                            double.parse(latitude),
                                            double.parse(longitude),
                                            number,
                                            address)),
                                  );
                                },
                                child:
                                    HospitalCard(hospitalslist: hospitalslist),
                              );
                            } else {
                              return Container(
                                height: 0,
                              );
                            }
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  const HospitalCard({
    Key key,
    @required this.hospitalslist,
  }) : super(key: key);

  final DocumentSnapshot hospitalslist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400],
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[400],
              ),
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(hospitalslist.data()['img']),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      hospitalslist.data()['hospital_name'],
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Text(hospitalslist.data()['locality']),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

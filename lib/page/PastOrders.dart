import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:my_app/page/HospitalDetails.dart';
import 'package:my_app/page/NavPage.dart';
import 'package:my_app/page/Payment.dart';

// import 'package:flutter_counter/flutter_counter.dart';
var rng = new Random();

class PastOrders extends StatefulWidget {
  String id, price;

  PastOrders(this.id, this.price, {Key key}) : super(key: key);

  // PastOrders({Key key}) : super(key: key);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  void goToMedicinePage() {
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => NavPage(),
      ),
    );
  }

  // num _counter = 0;
  // num _defaultValue = 1;
  //
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  TextEditingController textEditingController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String msg = '';
  var count = 0;
  String mobileNo, address, name;

  void makePayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(),
      ),
    );
  }

  int tot;
  var aaa;

  Future<void> fetchInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('pastOrder')
          .doc(widget.id)
          .collection('info')
          .doc("details")
          .get()
          .then((value) {
        name = value.data()['name'];
        address = value.data()['address'];
        mobileNo = value.data()['number'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    // findTotalPrice();
    fetchInfo();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Order Details"
        ),),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cart')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('pastOrder')
                    .doc(widget.id)
                    .collection('medicine')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('We got an Error ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: Text('Loading'),
                      );

                    case ConnectionState.none:
                      return Text('oops no data');

                    case ConnectionState.done:
                      return Text('We are Done');

                    default:
                      return Container(
                        child: Column(children: [
                       
                          Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: Container(

                              width: 350,
                              decoration: BoxDecoration(

                                border: Border.all(
                                  color: Colors.grey[400],
                                  // width: 50,
                                ),
                                // color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            "Order Date                     " +
                                                widget.id)),
                                    SizedBox(height: 5),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            "Order Id                          " +
                                                rng.nextInt(1000).toString() +
                                                "-" +
                                                rng
                                                    .nextInt(1000000)
                                                    .toString() +
                                                "-" +
                                                rng.nextInt(1000).toString())),
                                    SizedBox(height: 5),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            "Order total                      " +
                                                "₹ " +
                                                widget.price)),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 5),
                            child: Align(alignment: Alignment.topLeft,child: Text("Shipments",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot currentOrdersList =
                                  snapshot.data.docs[index];
                              String a = currentOrdersList.data()['name'];
                              a = a.toUpperCase();
                              // print(a);

                              if (a.startsWith(searchString) ||
                                  searchString.trim() == '') {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[400],
                                                  ),
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                              "assets/images/honitus.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Padding(
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
                                                        currentOrdersList
                                                            .data()['name'],
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 15, 0, 30),
                                                      child: Text("₹" +
                                                          (currentOrdersList
                                                                          .data()[
                                                                      'price'] *
                                                                  currentOrdersList
                                                                          .data()[
                                                                      'quantity'])
                                                              .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                            child: Align(alignment: Alignment.topLeft,child: Text("Shipping Address",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                          ),
                           Container(
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[400],
                                // width: 50,
                              ),
                              // color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                children: [
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          name)),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(address
                                          )),
                                          Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(mobileNo
                                          )),
                                  SizedBox(height: 5),
                                  
                                ],
                              ),
                            ),
                          ),
                          
                         
                        ]),
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

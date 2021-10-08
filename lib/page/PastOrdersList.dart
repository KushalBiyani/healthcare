import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:my_app/page/HospitalDetails.dart';
import 'package:my_app/page/NavPage.dart';
import 'package:my_app/page/PastOrders.dart';
import 'package:my_app/page/Payment.dart';
import 'package:my_app/page/medicine.dart';
import 'package:my_app/page/page_structure.dart';

// import 'package:flutter_counter/flutter_counter.dart';
String name = "";

class PastOrdersList extends StatefulWidget {
  PastOrdersList({Key key}) : super(key: key);

  @override
  _PastOrdersListState createState() => _PastOrdersListState();
}

class _PastOrdersListState extends State<PastOrdersList> {
  void goToMedicinePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavPage(),
      ),
    );
  }

  // num _counter = 0;
  // num _defaultValue = 1;
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  String searchString = '';
  String msg = '';
  var count = 0;
  // var totalPrice = 1;
  // dynamic removeFromCart(currentOrdersId) {
  //   print("current");
  //   print(currentOrdersId);

  //   FirebaseFirestore.instance
  //       .collection("cart")
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .collection("currentOrder")
  //       .doc(currentOrdersId)
  //       .delete();
  // }

  // void makePayment() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Payment(),
  //     ),
  //   );
  // }

  // void findTotalPrice(){
  //   setState(() {
  //   totalPrice = totalPrice + 1;

  //   });
  // }

  // int tot ;
  // var aaa;
  // CollectionReference _collectionRef = FirebaseFirestore.instance
  //     .collection('cart')
  //     .doc(FirebaseAuth.instance.currentUser.uid)
  //     .collection("currentOrder");
  // Future<void> findTotalPrice() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();

  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  //   // print(allData);
  //   tot = 0;
  //   allData.forEach(
  //       (element) => tot = tot + element['price'] * element['quantity']);
  //   print("this is "+tot.toString());
  //   aaa=DateTime.now();
  //   print("after calling func"+aaa.toString());
  //   // setState(() {

  //   // });
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   // findTotalPrice();

  //   Future.delayed(const Duration(milliseconds: 1000), () {
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Your Orders"
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
                    .collection('pastOrder').orderBy('id', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('We got an Error ${snapshot.error}');
                  }
                  print(snapshot.data.size);

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
                      return Padding(
                        padding: const EdgeInsets.only(top:10),
                        child: Container(
                          child: Column(children: [
                           
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot currentList =
                                    snapshot.data.docs[index];

                                print(snapshot.data);
                                return GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   name = currentList.id;
                                    //   print(
                                    // "/////////////////////////////////////////////////////");
                                    //   print(currentList.id);
                                    //   print("  price form db "+currentList.data()['price'].toString());

                                    //   // DocumentSnapshot variable = FirebaseFirestore.instance.doc("$name").get();
                                    //   // print("name:$lattitude");
                                    // });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PastOrders(
                                            currentList.id,
                                            currentList
                                                .data()['totalPrice']
                                                .toString()),
                                      ),
                                    );
                                  },
                                  child: Padding(
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
                                                          currentList.id,
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
                                                            currentList
                                                                .data()[
                                                                    'totalPrice']
                                                                .toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // ElevatedButton(
                            //     onPressed: goToMedicinePage,
                            //     child: Text("Go To Home"))
                          ]),
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

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:my_app/page/HospitalDetails.dart';
import 'package:my_app/page/MedicineDetails.dart';
import 'package:my_app/page/Payment.dart';

import 'MedicineDetails.dart';

// import 'package:flutter_counter/flutter_counter.dart';
class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  // MedicineDetails.check();
  num _counter = 0;
  num _defaultValue = 1;
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  TextEditingController textEditingController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String msg = '';
  var count = 0;
  String lattitude, longitude, number, address, name;
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

  void makePayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(),
      ),
    );
  }

  // void findTotalPrice(){
  //   setState(() {
  //   totalPrice = totalPrice + 1;

  //   });
  // }

  int tot ;
  var aaa;
  CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("currentOrder");
  Future<void> findTotalPrice() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // print(allData);
    tot = 0;
    allData.forEach(
        (element) => tot = tot + element['price'] * element['quantity']);
    print("this is "+tot.toString());
    aaa=DateTime.now();
    print("after calling func"+aaa.toString());
    // setState(() {
        
    // });
  }


  

  @override
  void initState() {
    super.initState();

    findTotalPrice();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Cart"
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
                    .collection('currentOrder')
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
                        child: Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: Column(children: [
                            ListView.builder(
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
                                                                .toString()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 5, 0),
                                            child: Column(children: [
                                              Counter(
                                                  initialValue: currentOrdersList
                                                      .data()['quantity'],
                                                  minValue: 1,
                                                  maxValue: currentOrdersList
                                                      .data()['stock'],
                                                  step: 1,
                                                  decimalPlaces: 0,
                                                  onChanged: (value) {
                                                      tot = tot + currentOrdersList
                                                      .data()['price']*value;
                                                       tot = tot - currentOrdersList
                                                      .data()['price']*currentOrdersList.data()['quantity'];
                                                      
                                                    setState(() {
                                                      var quantity, stock;
                                                      FirebaseFirestore.instance
                                                          .collection('cart')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .collection(
                                                              'currentOrder')
                                                          .doc(currentOrdersList
                                                              .id)
                                                          .get()
                                                          .then((value) {
                                                        quantity = value
                                                            .data()['quantity'];
                                                        print(quantity);
                                                      });
                                                      // totalPrice = totalPrice + currentOrdersList
                                                      // .data()['quantity']*currentOrdersList
                                                      // .data()['price'];
                                                      FirebaseFirestore.instance
                                                          .collection('cart')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .collection(
                                                              'currentOrder')
                                                          .doc(currentOrdersList
                                                              .id)
                                                          .update({
                                                        "quantity": value,
                                                        // 'email' : email.text,
                                                      });
                                                      // abhishek bhingle
                                                      // _counter = value;
                                                      
                                                    //    aaa=DateTime.now();
                                                    //       print("before calling func"+aaa.toString());
                                                    //   findTotalPrice();
                                                      
                                                    // print("this is viru"+tot.toString()); 
                                                       
                                                    
                                                    // Timer(Duration(seconds: 0),
                                                    //     () {
                                                    //       print("this is abhi");
                                                    //       aaa=DateTime.now();
                                                    //       print("before calling func"+aaa.toString());
                                                    //   findTotalPrice();
                                                      
                                                    // print("this is viru"+tot.toString());
                                                    // });
                                                    // findTotalPrice();
                                                    });

                                                    // Timer.periodic(
                                                    //     Duration(seconds: 10),
                                                    //     (timer) {
                                                    //   findTotalPrice();
                                                    // });
                                                  }),
                                              ElevatedButton(
                                                
                                                  onPressed: () {
                                                    setState(() {
                                                      
                                                    tot = tot - currentOrdersList
                                                      .data()['price']*currentOrdersList.data()['quantity'];
                                                    });
                                                    print("happpy"+tot.toString());
                                                    FirebaseFirestore.instance
                                                        .collection("cart")
                                                        .doc(FirebaseAuth.instance
                                                            .currentUser.uid)
                                                        .collection(
                                                            "currentOrder")
                                                        .doc(currentOrdersList.id)
                                                        .delete();
                                                  },
                                                  child: Text("Delete"))
                                            ]),
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
                              
                            // Text(tot.toString()),
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
      bottomNavigationBar: Container(
        height: 45.0,
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
          Text("Total Price "+"₹" + tot.toString(),style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ElevatedButton(onPressed: makePayment, child: Text("Proceed to Buy",style: TextStyle(fontSize: 18),)),
        ]),
      ),
    );
  }
}

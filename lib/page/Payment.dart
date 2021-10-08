import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/page/NavPage.dart';
import 'package:my_app/page/PastOrders.dart';
import 'package:my_app/page/PastOrdersList.dart';
import 'package:my_app/page/menu_page.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController number = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("currentOrder");
  int tot = 0;
  Future<void> findTotalPrice() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    allData.forEach(
        (element) => tot = tot + element['price'] * element['quantity']);
    print(tot);
    setState(() {});
  }

  Future<void> findAllMedicine() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("currentOrder")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    // final allData1 = querySnapshot.docs.map((doc) => doc.id);

    allData.forEach((element) {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('pastOrder')
          .doc(timestamp)
          .collection('medicine')
          .doc()
          .set(element);

      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('pastOrder')
          .doc(timestamp)
          .set({"totalPrice": tot, "id": timestamp});
    });
    // setState(() {});
  }

  Future<void> changeStock() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("currentOrder")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    // final allData1 = querySnapshot.docs.map((doc) => doc.id);
    allData.forEach((element) {
      print("==============================================================");
      print(element['stock']);

      // 'email' : email.text,
    });

    allData.forEach((element) => FirebaseFirestore.instance
            .collection("medicine")
            .doc(element['medicineId'])
            .update({
          "stock": element['stock'] - element['quantity'],

          // 'email' : email.text,
        }));
    // setState(() {});
  }

  Future<int> deleteCurrentOrder() async{
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('currentOrder')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    return 1;
  }

  Future<int> uploadDataInfo() async{

    print("in upload data");
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('pastOrder')
        .doc(timestamp)
        .collection('info')
        .doc("details")
        .set({
      'name': name.text,
      'address': address.text,
      'number': number.text,
      // "totalPrice" : tot
    });
    return 1 ;
  }

  Future<void> fetchDataMedicine() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('currentOrder')
          .get()
          .then((value) {
        print(
            "##########################################################################");
      });
    } catch (e) {
      print(e);
    }
  }

  Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    // debugShowCheckedModeBanner: false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipment Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.indigo,
                    ),
                    hintText: '',
                    labelText: 'Name  *',
                  ),
                  // onSaved: (String? value) {
                  //   // This optional block of code can be used to run
                  //   // code when the user saves the form.
                  // },
                  validator: (value) {
                    return (value.isEmpty ? "Please Enter Name " : null);
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  minLines: 1, //Normal textInputField will be displayed
                  maxLines: 5,
                  controller: address,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.home,
                      color: Colors.indigo,
                    ),
                    hintText: '',
                    labelText: 'Shipping Address  *',
                  ),
                  // onSaved: (String? value) {
                  //   // This optional block of code can be used to run
                  //   // code when the user saves the form.
                  // },
                  validator: (value) {
                    return (value.isEmpty ? "Please Enter Address " : null);
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: number,
                  decoration: const InputDecoration(
                    counterText: "",
                    icon: Icon(
                      Icons.phone,
                      color: Colors.indigo,
                    ),
                    hintText: '',
                    labelText: 'Phone Number  *',
                  ),
                  // onSaved: (String? value) {
                  //   // This optional block of code can be used to run
                  //   // code when the user saves the form.
                  // },
                  validator: (value) {
                    return (value.isEmpty ? "Please Enter Number " : null);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Total Amount ", style: TextStyle(fontSize: 20)),
                  Text(
                    "₹" + tot.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            openCheckout();
                          }
                        },
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                )
              ]),
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    findTotalPrice();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  // var timestamp = DateTime.now();
  // DateTime timestamp = blogContent.data()['createdAt'].toDate();
  var timestamp = DateFormat.yMMMd().add_jm().format(DateTime.now());
  void openCheckout() async {
    // changeStock();
    // fetchDataMedicine();
    // uploadDataInfo();
    // findAllMedicine();
    // deleteCurrentOrder();
    var options = {
      'key': 'rzp_test_qvDUGFHH8QzOtY',
      'amount': tot * 100,
      'name': 'HealthCare Corp.',
      // 'description': 'Fine T-Shirt',
      'prefill': {'contact': '9865324578', 'email': user.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    Fluttertoast.showToast(msg: "SUCCESS : " + response.paymentId);
    // uploadDataInfo();
    // uploadDataMedicines();
    await changeStock();
    await uploadDataInfo();
    await findAllMedicine();
    await deleteCurrentOrder();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => NavPage(),
    //   ),
    // );
     Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          return NavPage();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }
}

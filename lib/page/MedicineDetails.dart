import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/page/Cart.dart';

class MedicineDetails extends StatefulWidget {
  String id;

  MedicineDetails(this.id, {Key key}) : super(key: key);

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  bool isMedicinePresent;
  Future<void> check() async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("currentOrder")
        .doc(widget.id)
        .get()
        .then((value) {
      isMedicinePresent = value.exists;
      isAddedColor = value.exists;
      isAddedText = value.exists;
    });
  }

  bool isAddedColor = false;
  bool isAddedText = false;

  String name, description, url;
  int price, stock;
  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('medicine')
          .doc(widget.id)
          .get()
          .then((value) {
        name = value.data()['name'];
        price = value.data()['price'];
        description = value.data()['description'];
        stock = value.data()['stock'];
        url = value.data()['img'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    check();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  void addToCart() {
    print(widget.id);
    setState(() => isAddedColor = !isAddedColor);
    setState(() => isAddedText = !isAddedText);
    if (isAddedText == true) {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("currentOrder")
          .doc(widget.id)
          .set({
        'name': name,
        'price': price,
        'quantity': 1,
        'stock': stock,
        'medicineId': widget.id,
        'url': url,
      });
    } else {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("currentOrder")
          .doc(widget.id)
          .delete();
    }
  }

  void viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cart(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Detail"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Row(
                    children: [
                      Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/images/capsule.png"),
                      ),
                      Text(
                        "$name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("₹ $price",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: stock > 1
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  isAddedColor ? Colors.green : Colors.indigo),
                          child: isAddedText
                              ? Text("Remove From Cart")
                              : Text("Add to Cart"),
                          onPressed: addToCart,
                        )
                      : Text("Out of Stock",
                          style: TextStyle(fontSize: 15, color: Colors.red))),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ]),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[200],
                      width: 5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$description",
                      style: TextStyle(fontSize: 18),
                    ),
                  ))
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.indigo,
        child: ElevatedButton(
            onPressed: viewCart,
            child: Text("View Cart", style: TextStyle(fontSize: 20))),
      ),
    );
  }
}

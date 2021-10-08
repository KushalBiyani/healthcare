import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/page/Cart.dart';

final List<String> imgList = [
  'https://res.cloudinary.com/du8msdgbj/image/upload/l_watermark_346,w_480,h_480/a_ignore,w_480,h_480,c_fit,q_auto,f_auto/v1600089604/cropped/pn7apngctvrtweencwi1.jpg',
  'https://res.cloudinary.com/du8msdgbj/image/upload/l_watermark_346,w_480,h_480/a_ignore,w_480,h_480,c_fit,q_auto,f_auto/v1600089615/cropped/y1jvnzpcbt82bakcfw2f.jpg',
  'https://res.cloudinary.com/du8msdgbj/image/upload/l_watermark_346,w_690,h_700/a_ignore,w_690,h_700,c_pad,q_auto,f_auto/v1537457265/ko6rsu9xwrdb7hrmmszr.jpg',
  'https://www.practostatic.com/practopedia-v2-images/res-750/a0d397a1196c2c92ef1ffa24db024e28b11657bc1.jpg',
  
];

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
    // return isMedicinePresent;
  }

  int _current = 0;
  bool isAddedColor = false;
  bool isAddedText = false;
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  String name, description;
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
        'medicineId': widget.id
      });
    } else {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("currentOrder")
          .doc(widget.id)
          .delete();
    }

    // FirebaseFirestore.instance
    //     .collection("doctorinfo")
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .set({
    //   'speciality': data1.text,
    //   'hospital_name': data2.text,
    //   'contact': data3.text,
    //   'experience': data4.text,
    //   'degree_url': fileUrl,
    //   'name':name,
    //   'email':email,
    //   'degree':data5.text
    // });
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
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
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
                  ),Text(
                    "$name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                        ],
                      )),
                  
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 5,
                        ),
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("₹ $price",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: stock >1 ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: isAddedColor ? Colors.green : Colors.indigo),
                  // color: isAddedColor ? Colors.blue: Colors.red,
                  // textColor: Colors.white,
                  child: isAddedText
                      ? Text("Remove From Cart")
                      : Text("Add to Cart"),
                  onPressed: addToCart,
                ):Text("Out of Stock",style: TextStyle(fontSize: 15,color: Colors.red))
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )
              ]),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 5,
                    ),
                    // color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("$description"),
                  ))
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        color: Colors.indigo,
        child: ElevatedButton(onPressed: viewCart, child: Text("View Cart")),
      ),
    );
  }
}

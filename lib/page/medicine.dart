import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:my_app/page/Cart.dart';
import 'package:my_app/page/PastOrdersList.dart';

// import 'package:cached_network_image/cached_network_image.dart';

import 'MedicineDetails.dart';

final List<String> imgList = [
  'https://cms-contents.pharmeasy.in/banner/5927bf4933c-882949a523b-Softovac--category-banner.jpg',
  'https://cms-contents.pharmeasy.in/banner/27adc200d7e-Accuchek-CB.jpg',
  'https://cms-contents.pharmeasy.in/banner/89ab34cc536-Digital-Brufen_CB.jpg',
  'https://www.desunhospital.com/backend/en/uploads/images/senior-discount.jpg',
  'https://www.sbicard.com/sbi-card-en/assets/media/images/personal/offers/categories/lifestyle/apollo-hospitals/d-apollo.jpg',
  'https://d168jcr2cillca.cloudfront.net/uploadimages/coupons/14346-Medicover_Hospitals_Health_Checkups_Coupon_1.png'
];

String name = "";
int _current = 0;
TextEditingController textEditingController = TextEditingController();
String searchString = '';

class Medicine extends StatefulWidget {
  Medicine({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine>
    with SingleTickerProviderStateMixin {
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 210,
                      ),
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
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget medicineList = new StreamBuilder<QuerySnapshot>(
        stream: (searchString == null || searchString.trim() == '')
            ? FirebaseFirestore.instance.collection('medicine').snapshots()
            : FirebaseFirestore.instance.collection('medicine').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text(
                'Error in receiving trip photos: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Not connected to the Stream or null');

            case ConnectionState.waiting:
              return new Text('Awaiting for interaction');

            case ConnectionState.active:
              print("Stream has started but not finished");

              var totalPhotosCount = 0;
              List<DocumentSnapshot> medicineList;

              if (snapshot.hasData) {
                medicineList = [];
                if (searchString.length > 0) {
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    if (snapshot.data.docs[i]
                        .data()['name']
                        .toString()
                        .toUpperCase()
                        .startsWith(searchString)) {
                      medicineList.add(snapshot.data.docs[i]);
                    }
                  }
                } else {
                  medicineList = snapshot.data.docs;
                }
                totalPhotosCount = medicineList.length;

                if (totalPhotosCount > 0) {
                  return new GridView.builder(
                      itemCount: totalPhotosCount,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                setState(() {
                                  name = medicineList[index].id;
                                  print("name:$name");
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicineDetails(name),
                                  ),
                                );
                              },
                              child: Container(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(children: [
                                        Image(
                                          width: 150,
                                          height: 120,
                                          image: NetworkImage(
                                              medicineList[index]
                                                  .data()['img']),
                                        ),
                                        Text(
                                          medicineList[index].data()['name'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "₹" +
                                                (medicineList[index]
                                                        .data()['price'])
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                      color: Colors.deepPurple[50],
                                    ),
                                  ])),
                            ),
                          ),
                        );
                      });
                }
              }

              return new Center(
                  child: Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  ),
                  new Text(
                    "No trip photos found.",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ));

            case ConnectionState.done:
              return new Text('Streaming is done');
          }

          return Container(
            child: new Text("No trip photos found."),
          );
        });

    return Scaffold(
        body: GestureDetector(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.purple[900],
                  height: 230,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "In the Spotlight",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: MediaQuery.of(context).size.height * .2,
                      child: CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.5,
                            onPageChanged: (index, reason) {
                              _current = index;
                            }),
                      ),
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    //here
                    FocusScope.of(context).unfocus();
                    new TextEditingController().clear();
                  },
                  child: Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 55,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            searchString = val.toUpperCase();
                          });
                        },
                        controller: textEditingController,
                        textAlign: TextAlign.center,
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
                          hintText: "Search Products",
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: medicineList,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          backGroundColor: Colors.deepPurpleAccent,
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Your Orders",
              iconColor: Colors.white,
              bubbleColor: Colors.indigo,
              icon: Icons.calendar_today,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PastOrdersList(),
                  ),
                );
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Cart",
              iconColor: Colors.white,
              bubbleColor: Colors.indigo,
              icon: Icons.shopping_cart,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ),
                );
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: _animationController.isCompleted
              ? _animationController.reverse
              : _animationController.forward,

          // Floating Action button Icon color
          iconColor: Colors.blue,

          // Flaoting Action button Icon
          animatedIconData: AnimatedIcons.add_event,
        ));
  }
}

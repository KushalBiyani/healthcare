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
];

String name = "";
int _current = 0;
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(

//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

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
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 500.0,
                        height: 175,
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
    // Trip photo widget template
    Widget medicineList = new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
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
                medicineList = snapshot.data.docs;
                // print(medicineList);
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

                                  // DocumentSnapshot variable = FirebaseFirestore.instance.doc("$name").get();
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
                                    // ClipRect(
                                    //   child: Align(
                                    //       alignment: Alignment.topCenter,
                                    //       heightFactor: 0.7,
                                    //       child: new CachedNetworkImage(
                                    //         placeholder: (context, url) =>
                                    //         new CircularProgressIndicator(),
                                    //         imageUrl:
                                    //         medicineList[index].data['url'],
                                    //       )),
                                    // ),

                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(children: [
                                        Image(
                                          width: 150,
                                          height: 120,
                                          image: AssetImage(
                                              "assets/images/honitus.png"),
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
                    style: Theme.of(context).textTheme.title,
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
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   // title: Text(widget.title),
        // ),
        body: GestureDetector(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    color: Colors.purple[900],
                    height: 250,
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top:5),
                            child: Text(
                              "In the Spotlight",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB( 10,0,0,5),
                            child: Text(
                                "Explore deals, offers, health updates and more",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )),
                      Container(
                height: MediaQuery.of(context).size.height*.2,

                        child: CarouselSlider(
                          items: imageSliders,
                          options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                _current = index;
                                // setState(() {
                                // });
                              }),
                        ),
                      ),
                    ]),
                  ),
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

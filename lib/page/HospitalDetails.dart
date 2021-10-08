import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1538108149393-fbbd81895907?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aG9zcGl0YWx8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQViQ9yxtk_JUmyTZuQCDpqxGQT1PlEY7_2Ow&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-EBK3r8ZEa7ZT7l3cI3Ak-aDgvbBB9OU6Qg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNHbB5ZSRtpd7l6v4CkaEbdR8d0K0eC1cfmA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgZ7v9m64HP1ZVMmO0NcWJztE471s06N8pdA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFxjNw8rqyRPpLU3_uTeDz5_ChbHOKWyM39g&usqp=CAU'
];

class HospitalDetails extends StatefulWidget {
  String usernameController,
      number,
      address; //if you have multiple values add here
  double lattitude, longitude;
  HospitalDetails(this.usernameController, this.lattitude, this.longitude,
      this.number, this.address,
      {Key key})
      : super(key: key); //add also..example this.abc,this...

//    final String text;
//   HospitalDetails({Key key, @required this.text}) : super(key: key);
// String p(){
//   print(text);
//   return text;
// }
  // print(this.text);
  // HospitalDetails({Key key}) : super(key: key);
  // p();
  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class _HospitalDetailsState extends State<HospitalDetails> {
  Future<void> _launched;
  int _current = 0;

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

  // _makingPhoneCall() async {
  //   const url = 'tel:123456789';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: Text(widget.usernameController,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
          ),
           RatingBar.builder(
   initialRating: 4.5,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 5,
   itemSize: 20.0,
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
     print(rating);
   },
),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 37),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,

                    children: [Icon(Icons.access_time,color: Colors.indigo)]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("  OPEN TODAY  ",style:TextStyle(fontSize: 15,color: Colors.indigo,backgroundColor: Colors.indigo.withOpacity(0.4))),
                    SizedBox(height: 5),
                    Text("08:00 AM - 10:00 PM ",style: TextStyle(fontSize: 15),),
                    SizedBox(height: 5),
                    Text("ALL TIMINGS",style: TextStyle(fontSize: 15,color: Colors.indigo)),
                  ],
                ),
              )
            ]),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 130),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,

                    children: [Icon(Icons.location_on,color: Colors.indigo,)]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Address:",style:TextStyle(fontSize: 15)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0,10),
                      child: Container(width:300,child: Text(widget.address,maxLines: 2,style:TextStyle(fontSize: 15))),
                    ),
                    // Row(
                    //                     children: [Expanded(
                    //       child: Text(widget.address,
                    //           maxLines: 1, overflow: TextOverflow.ellipsis))],
                    // ),
                    // Image(

                    //   width:300,
                    //   height: 120,
                    // image:AssetImage("assets/images/map.png")
                    // )
                    GestureDetector(
                      onTap: () {
                        MapUtils.openMap(widget.lattitude, widget.longitude);
                      }, // handle your image tap here
                      child: Image.asset(
                        'assets/images/map.jpg',
                        fit: BoxFit.cover, // this is the solution for border
                        width: 300,
                        height: 120,
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
          Divider(),
          // RaisedButton(
          //   onPressed: _makePhoneCall(widget.number),
          //   child: Text('Call'),
          //   textColor: Colors.black,
          //   padding: const EdgeInsets.all(5.0),
          // ),
           ElevatedButton(
             style: ElevatedButton.styleFrom(
    primary: Colors.indigo // background
    // onPrimary: Colors.white, // foreground
  ),
                onPressed: () => setState(() {
                  String a = widget.number;
                  // print("number $a");
                  _launched = _makePhoneCall('tel: $a');
                }),
                child: const Text('Make phone call',style: TextStyle(fontSize:18),),
              ),
        ]),
      ),
    );
  }
}

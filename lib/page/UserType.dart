import 'package:flutter/material.dart';
import 'package:my_app/page/DoctorDetails.dart';
import 'package:my_app/page/PatientDetails.dart';

class UserType extends StatelessWidget {
  const UserType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Who are you ?",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height:10),

               Card(
            color: Colors.lightGreen[50], 
                 
        child: InkWell(
          // splashColor: Colors.red,
          onTap: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetails(),
                      ),
                    );
          },
        
          child: Image(image: AssetImage("assets/images/doctorIcon.png"),width: 300,height: 175,),
        ),),
              SizedBox(height:10),

        Card(
            color: Colors.lightBlue[50], 
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetails(),
                      ),
                    );
          },
        
          child: const SizedBox(
            
            width: 300,
            height: 175,
            child: Image(image: AssetImage("assets/images/patientIcon.png"))
          ),
        ),),
              // ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.indigo, // background
              //       onPrimary: Colors.white, // foreground
              //     ),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => DoctorDetails(),
              //         ),
              //       );
              //     },
              //     child: Text("Doctor")),
              // ElevatedButton(
                
              //   style: ElevatedButton.styleFrom(
              //       primary: Colors.indigo, // background
              //       onPrimary: Colors.white, // foreground
              //     ),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => PatientDetails(),
              //         ),
              //       );
              //     },
              //     child: Text("Patient"))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travellerapp/HomePages/Traveller/TravellerPage.dart';
import 'package:travellerapp/HomePages/VehicleOwnerSection/vehicleOwnerHomepage.dart';

class Options extends StatefulWidget{

  final DocumentSnapshot userData;

  const Options({Key key, this.userData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new OptionState();
  }

}

class OptionState extends State<Options>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 100.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("TRAVELLER",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 35.0
                      ),),

                    SizedBox(height: 5.0,),

                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width-100.0,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height*(1/3.5),
              child: Container(
                margin: EdgeInsets.only(left: 20.0,right: 20.0),
                child: Column(
                  children: <Widget>[

                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width-100.0,
                        decoration: BoxDecoration(
                            color: Color(0xffB95D20),
//                        boxShadow: [
//                          BoxShadow(
//                            color: Colors.black.withOpacity(0.4),
//                            blurRadius: 3.0,
//                            offset: Offset(
//                              0,3
//                            )
//                          )
//                        ],
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            "ENTER AS TRAVELLER",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.5
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (BuildContext context)=>new TravellerPage(
                            userProfile: widget.userData,
                          ))
                        );
                      },
                    ),

                    SizedBox(height: 15.0,),

                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width-100.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
//                        boxShadow: [
//                          BoxShadow(
//                            color: Colors.black.withOpacity(0.4),
//                            blurRadius: 3.0,
//                            offset: Offset(
//                              0,3
//                            )
//                          )
//                        ],
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            "ENTER AS VEHICLE OWNER",
                            style: TextStyle(
                                color: Color(0xffB95D20),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.5
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context)=>new vehicleOwnerHomepage(
                                userInfo: widget.userData,
                              )
                          )
                        );
                      },
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
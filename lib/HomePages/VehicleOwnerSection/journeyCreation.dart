import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:travellerapp/HomePages/VehicleOwnerSection/vehicleOwnerHomepage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travellerapp/Registration/VehicleOwner.dart';


class journeyCreation extends StatefulWidget{

  final DocumentSnapshot userProfile;

  const journeyCreation({Key key, this.userProfile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new journeyCreationState();
  }

}

class journeyCreationState extends State<journeyCreation>{

  final snackBar = SnackBar(content: Text('Oops! Looks like you missed a field'));

  final TextEditingController destination = new TextEditingController();
  int clickedSearchField = 0;

  int choseTime = 0;
  var depTime = "DEPARTURE TIME";
  DateTime theTime;

  int seat = 0;
  int radioSelected = -1;
  int friendly = -1;
  int kind = -1;
  int partyTime = -1;
  int adventurous = -1;

  int checkFriendly = 0;
  int checkKind = 0;
  int checkPartyTime = 0;
  int checkAdventurous = 0;

  int uploading = 0;

  void postingTheJourney() async{
    setState(() {
      uploading = 1;
    });
    Map<String,int> values = {
      'Friendly':friendly,
      'Kind':kind,
      'PartyType':partyTime,
      'Adventurous':adventurous
    };

    double dist = await findDistance(destination.text.toString().trim());
//    DateTime dt = new DateTime(new Duration(hours: ));
     Timestamp newTime = Timestamp.fromDate(theTime);
     Firestore.instance.collection('Journey')
        .document().setData({
        'Attributes':widget.userProfile['Attributes'],
        'DepartureTime':newTime,
        'Destination':destination.text.toString(),
        'Distance':dist,
        'Others':[],
        'Seats': seat,
        'Status':'Accepting',
        'DriverRegNo':widget.userProfile['RegistrationNo'],
        'TravellersAttributes':values,
        'VehicleOwnerPic':'${widget.userProfile['Profile_pic']}',
        'VehicleOwnerName':'${widget.userProfile['Name']}'
    }).whenComplete((){
       setState(() {
         uploading = 0;
       });
     }).then((value){
       Navigator.of(context).pop();
       Navigator.of(context).pushReplacement(
         new MaterialPageRoute(builder: (BuildContext context)=>new vehicleOwnerHomepage(
           userInfo: widget.userProfile,
         ))
       );
     }).catchError((error){
       setState(() {
         uploading = 0;
       });
     });
  }

  Future<double> findDistance(String dest) async{
    //Get the current latitude and longitude
    print("I am in the method");
    LocationData myLocation;
    String error;
    Location location = new Location();
    myLocation = await location.getLocation();
    var currentLocation = myLocation;
    print("The location : ${myLocation}");

    //Get the location of the entered destination
    List<Placemark> locations = await Geolocator().placemarkFromAddress("${dest}");

    double calc = calDistance(myLocation.latitude, locations[0].position.latitude, myLocation.longitude, locations[0].position.longitude);
    return calc;
//    print("Coordinates of destination : ${loc[0].postalCode}");

  }

  double calDistance(lat1,lat2,lon1,lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2-lat1)*p)/2 + c(lat1 * p)*c(lat2 * p) * (1-c((lon2-lon1)*p))/2;
    return 12742*asin(sqrt(a));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title:Container(
          margin: EdgeInsets.only(left:20.0,right: 10.0,top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("CREATE A JOURNEY",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0
                ),),

              Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width-150.0,
                color: Colors.white,
              )
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Builder(
        builder: (context){
          return Container(
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.cover
                )
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
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
                  child: GestureDetector(
                    child: TextField(
                      controller: destination,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.place,color: Colors.white.withOpacity(0.6)),
                          hintText: "ENTER DESTINATION",
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5
                          )
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.5
                      ),
                    ),
                    onTap: (){
                      if(clickedSearchField==0){
                        setState(() {
                          clickedSearchField=1;
                        });
                      }else{
                        setState(() {
                          clickedSearchField=0;
                        });
                      }
                    },
                  ),
                ),

                (clickedSearchField==0)?SizedBox(height: 5.0,):
                Container(
                    width: MediaQuery.of(context).size.width-100.0,
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('Destinations').snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                        return new Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                            return ListTile(
                              title: Text(document.documentID.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal
                                ),),
                            );
                          }).toList(),
                        );
                      },
                    )
                ),



                SizedBox(height: 10.0,),

                GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(5.0),
                      height: 60.0,
                      width: MediaQuery.of(context).size.width-100.0,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
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
                      child: ListTile(
                        leading: Icon(Icons.access_time,color: Colors.white.withOpacity(0.6),),
                        title: Text(depTime,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5
                          ),),
                        trailing: Icon(Icons.arrow_drop_down,color: Colors.white.withOpacity(0.6),),
                      )
                  ),
                  onTap: (){
                    if(choseTime==0){
                      setState(() {
                        choseTime=1;
                      });
                    }else{
                      setState(() {
                        choseTime=0;
                      });
                    }
                  },
                ),

                (choseTime==0)?SizedBox(height: 10.0,):
                Container(
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode:CupertinoDatePickerMode.time,
                    backgroundColor: Colors.transparent,
                    onDateTimeChanged: (changedValue){
                      setState(() {
                        depTime = "${changedValue.hour} : ${changedValue.minute} ${changedValue.timeZoneName}";
                        theTime = changedValue;
                      });
                    },
//                    onTimerDurationChanged: (data){
//                      setState(() {
//                        depTime = data.toString();
//                        theTime = data;
//                      });
//                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'PREFERENCE OF TRAVELLER',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 1.5
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading: (checkFriendly==0)?Icon(Icons.check_box_outline_blank,color: Colors.white,)
                                  :Icon(Icons.check_box,color: Colors.white,),
                              title: Text('FRIENDLY',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          if(checkFriendly==0){
                            setState(() {
                              checkFriendly = 1;
                            });
                          }else{
                            setState(() {
                              checkFriendly = 0;
                            });
                          }

                          if(friendly==-1){
                            setState(() {
                              friendly=1;
                            });
                          }else if(friendly==0){
                            setState(() {
                              friendly=1;
                            });
                          }else if(friendly==1) {
                            setState(() {
                              friendly = -1;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 3.0,),

                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading: (checkKind==0)?Icon(Icons.check_box_outline_blank,color: Colors.white,)
                                  :Icon(Icons.check_box,color: Colors.white,),
                              title: Text('KIND',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          if(checkKind==0){
                            setState(() {
                              checkKind = 1;
                            });
                          }else{
                            setState(() {
                              checkKind = 0;
                            });
                          }

                          if(kind==-1){
                            setState(() {
                              kind=1;
                            });
                          }else if(kind==0){
                            setState(() {
                              kind=1;
                            });
                          }else if(kind==1) {
                            setState(() {
                              kind = -1;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 3.0,),

                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading: (checkPartyTime==0)?Icon(Icons.check_box_outline_blank,color: Colors.white,):
                              Icon(Icons.check_box,color: Colors.white,),
                              title: Text('PARTY TYPE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          if(checkPartyTime==0){
                            setState(() {
                              checkPartyTime = 1;
                            });
                          }else{
                            setState(() {
                              checkPartyTime = 0;
                            });
                          }

                          if(partyTime==-1){
                            setState(() {
                              partyTime=1;
                            });
                          }else if(partyTime==0){
                            setState(() {
                              partyTime=1;
                            });
                          }else if(partyTime==1) {
                            setState(() {
                              partyTime = -1;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 3.0,),

                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading: (checkAdventurous==0)?Icon(Icons.check_box_outline_blank,color: Colors.white,):
                              Icon(Icons.check_box,color: Colors.white,),
                              title: Text('ADVENTUROUS',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          if(checkAdventurous==0){
                            setState(() {
                              checkAdventurous = 1;
                            });
                          }else{
                            setState(() {
                              checkAdventurous = 0;
                            });
                          }

                          if(adventurous==-1){
                            setState(() {
                              adventurous=1;
                            });
                          }else if(adventurous==0){
                            setState(() {
                              adventurous=1;
                            });
                          }else if(adventurous==1) {
                            setState(() {
                              adventurous = -1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.0,),

                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'HOW MANY TRAVELLERS CAN YOU ACCOMPANY?',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 1.5
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10.0,right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading: (radioSelected==2||radioSelected==-1)?Icon(Icons.radio_button_unchecked,color: Colors.white,):
                              Icon(Icons.radio_button_checked,color: Colors.white,),
                              title: Text('2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          setState(() {
                            radioSelected=1;
                            seat = 2;
                          });
                        },
                      ),

                      SizedBox(height: 3.0,),

                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
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
                            child: ListTile(
                              leading:(radioSelected==-1||radioSelected==1)?Icon(Icons.radio_button_unchecked,color: Colors.white,):
                              Icon(Icons.radio_button_checked,color: Colors.white,),
                              title: Text('4',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    letterSpacing: 1.5
                                ),),
                            )
                        ),
                        onTap: (){
                          setState(() {
                            radioSelected=2;
                            seat = 4;
                          });
                        },
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 45.0,),

                (uploading==0)?GestureDetector(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      height: 55.0,
                      width: 142.0,
                      decoration: BoxDecoration(
                          color: Color(0xffB95D20),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 6,
                                offset: Offset(0,3)
                            )
                          ]
                      ),
                      child: Center(
                        child: Text("POST",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0
                          ),),
                      ),
                    ),
                  ),
                  onTap: (){

                    if(destination.text.toString().isEmpty ||
                        theTime==null || (friendly==-1&&kind==-1&&partyTime==-1&&adventurous==-1)
                        ||radioSelected==-1){
                      Scaffold.of(context).showSnackBar(snackBar);
                    }else{
                      postingTheJourney();
                    }
//                String t = destination.text.toString().trim();
//                findDistance(t);
                  },
                ):Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
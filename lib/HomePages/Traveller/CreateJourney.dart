import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'TravellerPage.dart';
//import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:travellerapp/HomePages/Traveller/SearchVehicleOwners.dart';
import 'package:geolocator/geolocator.dart';


class CreateJourney extends StatefulWidget{

  final DocumentSnapshot userProfile;

  const CreateJourney({Key key, this.userProfile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CreateJourneyState();
  }

}

class CreateJourneyState extends State<CreateJourney>{

  final TextEditingController destination = new TextEditingController();
  int clickedSearchField = 0;

  int choseTime = 0;
  var depTime = "DEPARTURE TIME";
  DateTime theTime;

  int radioSelected = -1;
  int friendly = -1;
  int kind = -1;
  int partyTime = -1;
  int adventurous = -1;

  int checkFriendly = 0;
  int checkKind = 0;
  int checkPartyTime = 0;
  int checkAdventurous = 0;

  int isFinding = 0;

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
    List<Placemark> locations = await Geolocator().placemarkFromAddress("${dest}").catchError((error){
      setState(() {
        isFinding=0;
      });
    });

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

  Map<dynamic,dynamic> details = {};
  void applyNBtoFindRelatedJourneys() async{
    setState(() {
      isFinding=1;
    });
    details={};
    double dist = await findDistance(destination.text.toString().trim());
    Timestamp newTime = Timestamp.fromDate(theTime);
//    print(widget.userProfile.data);
    double matchingTraits = 0;
    double traitsToMatch = 0;
    Firestore.instance.collection('Journey').snapshots().listen((event) {
      //Work with each and every feature
      for(int i=0;i<event.documents.length;i++){
        matchingTraits=0;
        traitsToMatch=0;
        if(event.documents[i].data['Status']=='Accepting'){
          if(newTime.compareTo(event.documents[i].data['DepartureTime'])<=0){
            traitsToMatch = traitsToMatch+1;
            matchingTraits = matchingTraits+1;
            if(dist <= event.documents[i].data['Distance']){
              traitsToMatch = traitsToMatch+1;
              double distAcc = ((dist-event.documents[i].data['Distance']).abs())/
                  (dist);
              matchingTraits = matchingTraits+distAcc;

              //Seeing if traveller has traits that vehicle owner wants
              if(event.documents[i].data['TravellersAttributes']['Friendly']!=-1){
                traitsToMatch = traitsToMatch+1;
                if(widget.userProfile['Attributes']['Friendly']>0){
                  matchingTraits = matchingTraits+1;
                }
              }
              if(event.documents[i].data['TravellersAttributes']['Kind']!=-1){
                traitsToMatch = traitsToMatch+1;
                if(widget.userProfile['Attributes']['Kind']>0){
                  matchingTraits = matchingTraits+1;
                }
              }
              if(event.documents[i].data['TravellersAttributes']['PartyType']!=-1){
                traitsToMatch = traitsToMatch+1;
                if(widget.userProfile['Attributes']['PartyType']>0){
                  matchingTraits = matchingTraits+1;
                }
              }
              if(event.documents[i].data['TravellersAttributes']['Adventurous']!=-1){
                traitsToMatch = traitsToMatch+1;
                if(widget.userProfile['Attributes']['Adventurous']>0){
                  matchingTraits = matchingTraits+1;
                }
              }

              //Seeing if vehicle owner has traits that traveller wants
              if(friendly!=-1){
                traitsToMatch = traitsToMatch+1;
                if(event.documents[i].data['Attributes']['Friendly']>0){
                  matchingTraits=matchingTraits+1;
                }
              }
              if(adventurous!=-1){
                traitsToMatch = traitsToMatch+1;
                if(event.documents[i].data['Attributes']['Adventurous']>0){
                  matchingTraits=matchingTraits+1;
                }
              }
              if(kind!=-1){
                traitsToMatch = traitsToMatch+1;
                if(event.documents[i].data['Attributes']['Kind']>0){
                  matchingTraits=matchingTraits+1;
                }
              }
              if(partyTime!=-1){
                traitsToMatch = traitsToMatch+1;
                if(event.documents[i].data['Attributes']['PartyType']>0){
                  matchingTraits=matchingTraits+1;
                }
              }
            }
          }
          double matched = 0;
          matched = (matchingTraits/traitsToMatch)*100;
          matched = double.parse((matched).toStringAsFixed(0));
          if(!(matched > 100 || matched <=0 || matched < 70)) {
          print("${event.documents[i].documentID} : ${matched}");
            setState(() {
              details['${event.documents[i].documentID}'] = matched;
            });
          }

//            print(details);
//          }
        }
//        print(details);
      }
//      print(details);
    }).onError((error){
      setState(() {
        isFinding=0;
      });
    });
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
      body: Container(
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
              ),
            ),

            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                'PREFERENCE OF VEHICLE OWNER',
                style: TextStyle(
                    color: Colors.white,
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

//            SizedBox(height: 30.0,),
//
//            Container(
//              margin: EdgeInsets.all(10.0),
//              child: Text(
//                'PREFERENCE OF PRIVACY',
//                style: TextStyle(
//                    color: Colors.white.withOpacity(0.6),
//                    fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold,
//                    fontSize: 16.0,
//                    letterSpacing: 1.5
//                ),
//              ),
//            ),
//
//            Container(
//              margin: EdgeInsets.only(left: 10.0,right: 10.0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  GestureDetector(
//                    child: Container(
//                        padding: EdgeInsets.all(5.0),
//                        height: 60.0,
//                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(
//                            color: Colors.black.withOpacity(0.4),
////                        boxShadow: [
////                          BoxShadow(
////                            color: Colors.black.withOpacity(0.4),
////                            blurRadius: 3.0,
////                            offset: Offset(
////                              0,3
////                            )
////                          )
////                        ],
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: ListTile(
//                          leading: (radioSelected==2||radioSelected==-1)?Icon(Icons.radio_button_unchecked,color: Colors.white,):
//                          Icon(Icons.radio_button_checked,color: Colors.white,),
//                          title: Text('GO ALONE',
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.normal,
//                                fontSize: 15.0,
//                                letterSpacing: 1.5
//                            ),),
//                        )
//                    ),
//                    onTap: (){
//                      setState(() {
//                        radioSelected=1;
//                      });
//                    },
//                  ),
//
//                  SizedBox(height: 3.0,),
//
//                  GestureDetector(
//                    child: Container(
//                        padding: EdgeInsets.all(5.0),
//                        height: 60.0,
//                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(
//                            color: Colors.black.withOpacity(0.4),
////                        boxShadow: [
////                          BoxShadow(
////                            color: Colors.black.withOpacity(0.4),
////                            blurRadius: 3.0,
////                            offset: Offset(
////                              0,3
////                            )
////                          )
////                        ],
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: ListTile(
//                          leading:(radioSelected==-1||radioSelected==1)?Icon(Icons.radio_button_unchecked,color: Colors.white,):
//                          Icon(Icons.radio_button_checked,color: Colors.white,),
//                          title: Text('SHARE WITH OTHERS',
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.normal,
//                                fontSize: 15.0,
//                                letterSpacing: 1.5
//                            ),),
//                        )
//                    ),
//                    onTap: (){
//                      setState(() {
//                        radioSelected=2;
//                      });
//                    },
//                  ),

//                ],
//              ),
//            ),

            SizedBox(height: 45.0,),

            (isFinding==0)?GestureDetector(
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
                    child: Text("SEARCH",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0
                      ),),
                  ),
                ),
              ),
              onTap: ()async{
//                signInUser();
//                  double dist = await findDistance(destination.text.toString().trim());
//                  Timestamp newTime = Timestamp.fromDate(theTime);
                  await applyNBtoFindRelatedJourneys();
                  setState(() {
                    isFinding=0;
                  });
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context)=>new SearchVehicleOwner(
                          currentUserProfile: widget.userProfile,
                          matchedTable: details,
                          dest: destination.text.toString().trim(),
                          depart: theTime,
//                          tAFriendly: friendly,
//                          tAAdventurous: adventurous,
//                          tAKind: kind,
//                          tAPartyType: partyTime,
//                          deptTime: newTime,
//                          destination: destination.text.toString().trim(),
//                          distance: dist,
                        )
                    )
                  );
              },
            ):Center(
                child:CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
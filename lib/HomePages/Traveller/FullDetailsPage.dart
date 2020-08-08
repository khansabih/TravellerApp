import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travellerapp/HomePages/Traveller/TravellerPage.dart';
import 'package:travellerapp/HomePages/Traveller/TravellerPage.dart';

import 'ProfilePage.dart';

class FullDetailsPage extends StatefulWidget{

  final DocumentSnapshot journeyDetails;
  final DocumentSnapshot DriverDetails;
  final DocumentSnapshot currentUserDetails;

  final String destination;
  final DateTime departTime;

  final int fromWhichPage;

  const FullDetailsPage({Key key, this.journeyDetails, this.DriverDetails, this.currentUserDetails, this.destination, this.departTime, this.fromWhichPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FullDetailsPageState();
  }

}

class FullDetailsPageState extends State<FullDetailsPage>{

  int ending = 0;

  int confirming = 0;
  final snackBar = SnackBar(content: Text('We are having trouble confirming your journey. Please try again later'));

  Widget getSortedMapValues(){
    var temp = widget.DriverDetails.data['Attributes'];
    return Text("ATTRIBUTES : [${temp}]",
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          fontSize: 15.0
      ),);
  }
  Widget getDepartureTimeValues(){
    Timestamp ti = widget.journeyDetails['DepartureTime'];
    int hr = ti.toDate().hour;
    int min = ti.toDate().minute;
    String z = ti.toDate().timeZoneName;
    return Text("DEPARTURE TIME : ${hr}:${min} ${z}",
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          fontSize: 15.0
      ),);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child:AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title:Container(
            margin: EdgeInsets.only(left:20.0,right: 10.0,top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("ABOUT THE COMPANIONS",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0
                  ),),
              ],
            ),
          ),
          centerTitle: false,
        )
      ),
      body: Builder(
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.cover
                )
            ),
            child: Stack(
              children: <Widget>[

                Positioned(
                  top: 100.0,
                  left: MediaQuery.of(context).size.width*(1/2.5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          (widget.journeyDetails['VehicleOwnerPic']!=null)?
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage: CachedNetworkImageProvider(widget.journeyDetails['VehicleOwnerPic']),
                          ):CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Colors.black.withOpacity(0.4),
                            child: Center(
                              child: Text(widget.journeyDetails['VehicleOwnerName'].substring(0,1).toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'
                                ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                    top: 200.0,
                    left: MediaQuery.of(context).size.width*(1/40),
                    child:Align(
                        alignment: Alignment.center,
                        child:Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(left:30.0,right:30.0,bottom: 15.0),
                            //                height: 270.0,
                            width: MediaQuery.of(context).size.width-80.0,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Title
                                Text("${widget.journeyDetails['VehicleOwnerName'].toString().toUpperCase()}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0,
                                      letterSpacing: 1.5
                                  ),),

                                Container(
                                  height: 1.0,
                                  width: MediaQuery.of(context).size.width-150.0,
                                  color: Colors.white,
                                ),

                                SizedBox(height: 10.0),

                                //Description
                                Text("${widget.journeyDetails['DriverRegNo']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0
                                  ),),

                                SizedBox(height: 5.0,),

                                Text("${widget.DriverDetails['Branch']} - ${widget.DriverDetails['Course']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0
                                  ),),

                                SizedBox(height: 5.0,),

                                Text("GOING TO - ${widget.journeyDetails['Destination']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0
                                  ),),

                                SizedBox(height: 5.0,),

                                Text("${widget.DriverDetails['Branch']} - ${widget.DriverDetails['Course']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0
                                  ),),

                                SizedBox(height: 5.0,),

                                getSortedMapValues(),

                                SizedBox(height: 5.0,),

                                getDepartureTimeValues()

                              ],
                            )
                        )
                    )
                ),

                Positioned(
                    top: 450,
                    child: Container(
                      margin: EdgeInsets.only(left: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("OTHERS SHARING",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
                                letterSpacing: 1.5
                            ),),

                          Container(
                            height: 1.0,
                            width: MediaQuery.of(context).size.width-150.0,
                            color: Colors.white,
                          ),

                          SizedBox(height: 10.0),

                        ],
                      ),
                    )
                ),

                (widget.journeyDetails['Others'].length!=0)?Positioned(
                  top: 450,
                  child: Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width-100,
                      margin: EdgeInsets.only(left: 35.0,right: 35.0),
                      child: ListView.builder(
                        itemCount: widget.journeyDetails['Others'].length,
                        itemBuilder: (context,index){
                          return ListTile(
                            leading: (widget.journeyDetails['Others'][index]['Profile_pic']!=null)?
                            CircleAvatar(
                              radius: 20.0,
                              backgroundImage: CachedNetworkImageProvider(widget.journeyDetails['Others'][index]['Others_Profile_pic']),
                            ):CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Text(widget.journeyDetails['Others'][index]['OthersName'].substring(0,1).toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'
                                  ),),
                              ),
                            ),
                            title: Text("${widget.journeyDetails['Others'][index]['OthersName'].toString().toUpperCase()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15.0
                              ),),
                          );
                        },
                      )
                  ),
                ):Positioned(
                    top:500,
                    child:Container(
                        margin: EdgeInsets.only(left: 35.0,right: 35.0),
                        child:Center(child: Text(
                          "SEEMS LIKE YOU ARE THE FIRST ONE HERE",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5,
                              fontSize: 13.5
                          ),
                        ),))),

                (widget.fromWhichPage==1)?Positioned(
                  bottom: 30.0,
                  left: MediaQuery.of(context).size.width*(1/8),
                  child: (confirming==0)?GestureDetector(
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
                          "CONFIRM",
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
                      setState(() {
                        confirming=1;
                      });
                      List prevList = widget.journeyDetails['Others'];
                      prevList.add({
                        'Others_Profile_pic':(widget.currentUserDetails['Profile_pic']!=null)?'${widget.currentUserDetails['Profile_pic']}':null,
                        'OthersName':'${widget.currentUserDetails['Name']}',
                        'OthersRegNo':'${widget.currentUserDetails['RegistrationNo']}',
                        'DepartureTime':widget.departTime,
                        'Destination':widget.destination
                      });
                      Firestore.instance.collection('Journey').document(widget.journeyDetails.documentID)
                          .updateData({
                        'Others':prevList,
                        'Seats':widget.journeyDetails['Seats']-1
                      }).then((doc){
                        //Check if updated seats == 0
                        Firestore.instance.collection('Journey').document(widget.journeyDetails.documentID)
                            .get().then((value){
                          if(value['Seats']==0){
                            Firestore.instance.collection('Journey').document(widget.journeyDetails.documentID)
                                .updateData({
                              'Status':'Booked'
                            });
                          }
                        }).then((value){
                          Firestore.instance.collection('Users').document(widget.currentUserDetails.documentID)
                              .collection('InTransaction').document(widget.journeyDetails.documentID).setData({
                            'journeyId':widget.journeyDetails.documentID,
                            'DepartureTime':widget.departTime,
                            'Destination':widget.destination
                          });
                        }).catchError((error){
                          setState(() {
                            confirming=0;
                          });

                          Scaffold.of(context).showSnackBar(snackBar);
                        }).then((value){
                          //Navigate to traveller homepage
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context)=>new TravellerPage(
                                    userProfile: widget.currentUserDetails,
                                  )
                              )
                          );
                          setState(() {
                            confirming=0;
                          });
                        });
                      });
//                  Navigator.of(context).push(
//                      new MaterialPageRoute(builder: (BuildContext context)=>new CreateJourney(
//                        userProfile: widget.userProfile,
//                      ))
//                  );
                    },
                  ):Center(
                      child:CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )),
                ):Positioned(
                  bottom: 30.0,
                  left: MediaQuery.of(context).size.width*(1/8),
                  child: (ending==0)?GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
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
                          "END JOURNEY",
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
                      setState(() {
                        ending=1;
                      });
                      List prevList = widget.journeyDetails['Others'];
//                      prevList.add({
//                        'Others_Profile_pic':(widget.currentUserDetails['Profile_pic']!=null)?'${widget.currentUserDetails['Profile_pic']}':null,
//                        'OthersName':'${widget.currentUserDetails['Name']}',
//                        'OthersRegNo':'${widget.currentUserDetails['RegistrationNo']}',
//                        'DepartureTime':widget.departTime,
//                        'Destination':widget.destination
//                      });
                      for(int i=0;i<prevList.length;i++){
                        if(prevList[i]['OthersRegNo']==widget.currentUserDetails['RegistrationNo']){
                          prevList.removeAt(i);
                        }
                      }
                      Firestore.instance.collection('Journey').document(widget.journeyDetails.documentID)
                          .updateData({
                        'Others':prevList,
                        'Seats':widget.journeyDetails['Seats']+1
                      }).then((value){
                          Firestore.instance.collection('Users').document(widget.currentUserDetails.documentID).
                                collection('InTransaction').document(widget.journeyDetails.documentID)
                                  .delete().then((value){
                                    setState(() {
                                      ending = 0;
                                    });
                                }).then((value){
                                    Firestore.instance.collection('Destinations').document('${widget.destination}')
                                        .get().then((value){
                                          if(value.exists){
                                            Firestore.instance.collection('Destinations').document('${widget.destination}')
                                                .updateData({
                                                  'count':value['count']+1
                                            });
                                          }else{
                                            Firestore.instance.collection('Destinations').document('${widget.destination}')
                                                .setData({
                                              'count':1,
                                              'Description':''
                                            });
                                          }
                                    });
                                  });
//                              .collection('InTransaction').where()document().setData({
//                            'journeyId':widget.journeyDetails.documentID,
//                            'DepartureTime':widget.departTime,
//                            'Destination':widget.destination
//                          });
                        }).catchError((error){
                          setState(() {
                            ending=0;
                          });
                          Scaffold.of(context).showSnackBar(snackBar);
                        }).then((value){
                          //Navigate to traveller homepage
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context)=>new ProfilePage(
                                    curr_user: widget.currentUserDetails,
                                  )
                              )
                          );
                          setState(() {
                            confirming=0;
                          });
                        });
//                  Navigator.of(context).push(
//                      new MaterialPageRoute(builder: (BuildContext context)=>new CreateJourney(
//                        userProfile: widget.userProfile,
//                      ))
//                  );
                    },
                  ):Center(
                      child:CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )),
                )

              ],
            ),
          );
        }
      )
    );
  }
}
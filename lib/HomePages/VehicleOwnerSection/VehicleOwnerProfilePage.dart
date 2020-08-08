import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travellerapp/HomePages/Traveller/CreateJourney.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travellerapp/HomePages/Traveller/FullDetailsPage.dart';
import 'package:travellerapp/Registration/JourneyDescPage.dart';
import 'package:travellerapp/Login/Login.dart';

class VehicleOwnerProfilePage extends StatefulWidget{

  final DocumentSnapshot curr_user;

  const VehicleOwnerProfilePage({Key key, this.curr_user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VehicleOwnerProfilePageState();
  }

}

class VehicleOwnerProfilePageState extends State<VehicleOwnerProfilePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: Icon(Icons.power_settings_new,color: Colors.white,),
        onPressed: (){
          FirebaseAuth.instance.signOut().then((value){
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                  builder: (BuildContext context)=>new login_page()
              )
            );
          });
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  //ProfilePicture
                  (widget.curr_user['Profile_pic']!=null)?CircleAvatar(
                    radius: 30.0,
                    backgroundImage: CachedNetworkImageProvider(widget.curr_user['Profile_pic']),
                  ):CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Text(widget.curr_user['Name'].toString().substring(0,1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat'
                        ),),
                    ),
                  ),

                  SizedBox(height: 5.0,),

                  //Name
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${widget.curr_user['Name'].toString().toUpperCase()}",
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
                        ),

                        SizedBox(height: 3.5,),
                        Text("${widget.curr_user['RegistrationNo']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0
                          ),),
                        SizedBox(height: 1.5,),
                        Text("${widget.curr_user['Branch'].toString().toUpperCase()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0
                          ),),
                        SizedBox(height:1.5),
                        Text("${widget.curr_user['Course'].toString().toUpperCase()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0
                          ),),

                        SizedBox(height: 5.0,),
                        Text("Attributes : ${widget.curr_user['Attributes']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0
                          ),),

                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 10.0,),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("BOOKED JOURNEYS",
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
                    ),

                    SizedBox(height: 10.0,),

                    Container(
                      height: 150.0,
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('Users').document(widget.curr_user.documentID)
                            .collection('InTransaction').snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasData){
                            return new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: GestureDetector(
                                      child:ListTile(
                                        leading: Icon(Icons.format_list_bulleted,color: Colors.white,size: 15,),
                                        title: Text("${document['Destination'].toString().toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15.0
                                          ),),

//                                  trailing: Text("${document['DepartureTime']}",
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.normal,
//                                        fontSize: 12.0
//                                    ),),
                                      ),
                                      onTap: (){
                                        DocumentSnapshot journeyDetail;
                                        DocumentSnapshot VehicleOwnerDetails;
                                        Firestore.instance.collection('Journey')
                                            .document('${document['journeyId']}').get()
                                            .then((value){
                                          setState(() {
                                            journeyDetail = value;
                                          });

                                          //Getting vehicle owners document snapshot
                                          Firestore.instance.collection('Users')
                                              .where('RegistrationNo',isEqualTo: value['DriverRegNo']).snapshots()
                                              .listen((event) {
                                            setState(() {
                                              VehicleOwnerDetails = event.documents[0];
                                            });
                                          });
                                        }).then((value){
                                          Timestamp t = document['DepartureTime'];
                                          var date = t.toDate();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context)=>new FullDetailsPage(
                                                    journeyDetails: journeyDetail,
                                                    DriverDetails: VehicleOwnerDetails,
                                                    currentUserDetails: widget.curr_user,
                                                    destination: document['Destination'],
                                                    departTime: date,
                                                    fromWhichPage: 2,
                                                  )
                                              )
                                          );
                                        });
                                      },
                                    )
                                );
                              }).toList(),
                            );
                          }else{
                            return Container(
                              child: Center(
                                child: Text("NO BOOKINGS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0
                                  ),),
                              ),
                            );
                          }

                        },
                      ),
                    )
                  ],
                )
            ),

            SizedBox(height: 10.0,),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("CREATED JOURNEYS",
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
                    ),

                    SizedBox(height: 10.0,),

                    Container(
                      height: 150.0,
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('Journey').where('DriverRegNo',isEqualTo: widget.curr_user['RegistrationNo']).snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasData){
                            return new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: GestureDetector(
                                      child:ListTile(
                                        leading: Icon(Icons.format_list_bulleted,color: Colors.white,size: 15,),
                                        title: Text("${document['Destination'].toString().toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15.0
                                          ),),

//                                  trailing: Text("${document['DepartureTime']}",
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.normal,
//                                        fontSize: 12.0
//                                    ),),
                                      ),
                                      onTap: (){
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context)=>new journeyDescPage(
                                                journeyDesc: document,
                                                currentUser: widget.curr_user,
                                              )
                                          )
                                        );
                                      },
                                    )
                                );
                              }).toList(),
                            );
                          }else{
                            return Container(
                              child: Center(
                                child: Text("NO JOURNEYS CREATED",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0
                                  ),),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                )
            ),

          ],
        ),
      ),
    );
  }
}
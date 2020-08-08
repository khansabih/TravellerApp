import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travellerapp/HomePages/VehicleOwnerSection/VehicleOwnerProfilePage.dart';
import 'journeyCreation.dart';

class vehicleOwnerHomepage extends StatefulWidget{
  
  final DocumentSnapshot userInfo;
  const vehicleOwnerHomepage({Key key, this.userInfo}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new vehicleOwnerHomepageState();
  }
  
}

class vehicleOwnerHomepageState extends State<vehicleOwnerHomepage>{
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
              Text("TRAVELLERS LOG",
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
        actions: <Widget>[
          GestureDetector(
            child: Container(
                margin: EdgeInsets.only(left:10.0,right: 30.0),
                child: Center(
                  child: (widget.userInfo['Profile_pic']!=null)?CircleAvatar(
                    radius: 20.0,
                    backgroundImage: CachedNetworkImageProvider(widget.userInfo['Profile_pic']),
                  ):CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Text(widget.userInfo['Name'].toString().substring(0,1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat'
                        ),),
                    ),
                  ),
                )),
            onTap: (){
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context)=>new VehicleOwnerProfilePage(
                    curr_user: widget.userInfo,
                  )
                )
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.cover
                )
            ),
            child:Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                //          margin: EdgeInsets.all(20.0),
                child: StreamBuilder(
                  stream: Firestore.instance.collection('Destinations').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 15.0),
                            //                height: 270.0,
                            width: MediaQuery.of(context).size.width-100.0,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Title
                                Text("${document.documentID.toUpperCase()}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 25.0,
                                      letterSpacing: 1.5
                                  ),),

                                Container(
                                  height: 1.0,
                                  width: MediaQuery.of(context).size.width-150.0,
                                  color: Colors.white,
                                ),

                                SizedBox(height: 10.0),

                                //Description
                                Text("${document['Description']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17.0
                                  ),),
                              ],
                            )
                        );
                      }).toList(),
                    );
                  },
                )
            ),
          ),

          Positioned(
            bottom: 30.0,
            left: MediaQuery.of(context).size.width*(1/8),
            child: GestureDetector(
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
                    "CREATE A JOURNEY",
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
                    new MaterialPageRoute(builder: (BuildContext context)=>new journeyCreation(
                      userProfile: widget.userInfo,
                    ))
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
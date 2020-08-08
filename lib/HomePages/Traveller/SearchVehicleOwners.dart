import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'dart:io';
import 'dart:math';
import 'FullDetailsPage.dart';

class SearchVehicleOwner extends StatefulWidget{

  final DocumentSnapshot currentUserProfile;
  final Map<dynamic,dynamic> matchedTable;
  final String dest;
  final DateTime depart;

  const SearchVehicleOwner({Key key, this.currentUserProfile,  this.matchedTable, this.dest, this.depart}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchVehicleOwnerState();
  }

}

class SearchVehicleOwnerState extends State<SearchVehicleOwner>{

//  Future<List> applySVMToFindRelatedJourneys() async{
//    print(widget.currentUserProfile.data);
//    double matchingTraits = 0;
//    double traitsToMatch = 0;
//    Firestore.instance.collection('Journey').snapshots().listen((event) {
//      //Work with each and every feature
//      for(int i=0;i<event.documents.length;i++){
//        matchingTraits=0;
//        traitsToMatch=0;
//        if(event.documents[i].data['Status']=='Accepting'){
//          if(widget.deptTime.compareTo(event.documents[i].data['DepartureTime'])<=0){
//            traitsToMatch = traitsToMatch+1;
//            matchingTraits = matchingTraits+1;
//            if(widget.distance <= event.documents[i].data['Distance']){
//              traitsToMatch = traitsToMatch+1;
//              double distAcc = ((widget.distance-event.documents[i].data['Distance']).abs())/
//                  (widget.distance);
//                matchingTraits = matchingTraits+distAcc;
//
//                //Seeing if traveller has traits that vehicle owner wants
//                if(event.documents[i].data['TravellersAttributes']['Friendly']!=-1){
//                  traitsToMatch = traitsToMatch+1;
//                  if(widget.currentUserProfile['Attributes']['Friendly']>0){
//                    matchingTraits = matchingTraits+1;
//                  }
//                }
//              if(event.documents[i].data['TravellersAttributes']['Kind']!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(widget.currentUserProfile['Attributes']['Kind']>0){
//                  matchingTraits = matchingTraits+1;
//                }
//              }
//              if(event.documents[i].data['TravellersAttributes']['PartyType']!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(widget.currentUserProfile['Attributes']['PartyType']>0){
//                  matchingTraits = matchingTraits+1;
//                }
//              }
//              if(event.documents[i].data['TravellersAttributes']['Adventurous']!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(widget.currentUserProfile['Attributes']['Adventurous']>0){
//                  matchingTraits = matchingTraits+1;
//                }
//              }
//
//              //Seeing if vehicle owner has traits that traveller wants
//              if(widget.tAFriendly!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(event.documents[i].data['Attributes']['Friendly']>0){
//                  matchingTraits=matchingTraits+1;
//                }
//              }
//              if(widget.tAAdventurous!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(event.documents[i].data['Attributes']['Adventurous']>0){
//                  matchingTraits=matchingTraits+1;
//                }
//              }
//              if(widget.tAKind!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(event.documents[i].data['Attributes']['Kind']>0){
//                  matchingTraits=matchingTraits+1;
//                }
//              }
//              if(widget.tAPartyType!=-1){
//                traitsToMatch = traitsToMatch+1;
//                if(event.documents[i].data['Attributes']['PartyType']>0){
//                  matchingTraits=matchingTraits+1;
//                }
//              }
//            }
//          }
//          double matched = 0;
//          matched = (matchingTraits/traitsToMatch)*100;
////          if(!(matched > 100 || matched <=0 || matched < 70)) {
////          print("${event.documents[i].documentID} : ${matched}");
//            setState(() {
//              details.add({
//                'journeyId': event.documents[i].documentID,
//                'matched': matched
//              });
//            });
//
////            print(details);
////          }
//        }
////        print(details);
//      }
////      print(details);
//    });
//  }

//  Future<List> getDetails(AsyncSnapshot<QuerySnapshot> snapshots) async{
//    List files = [];
//    snapshots.data.documents
//        .map((doc) => files.add(doc.data))
//        .toList();
//    return files;
//  }

  @override
  void initState() {
    super.initState();
    print(widget.matchedTable);
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
              Text("AVAILABLE FRIENDS",
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
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
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
                  stream: Firestore.instance.collection('Journey')
                      .where('Status',isEqualTo: 'Accepting').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return GestureDetector(
                            onTap: (){
                              DocumentSnapshot driverDetails;
                              Firestore.instance.collection('Users').where('RegistrationNo',isEqualTo: document['DriverRegNo'])
                                  .snapshots().listen((event) {
                                setState(() {
                                  driverDetails = event.documents[0];
                                });
                              });
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context)=> new FullDetailsPage(
                                          journeyDetails: document,
                                          DriverDetails: driverDetails,
                                          currentUserDetails: widget.currentUserProfile,
                                          destination: widget.dest,
                                          departTime: widget.depart,
                                          fromWhichPage: 1,
                                        )
                                    )
                                );
                            },
                            child:Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.only(bottom: 15.0),
                            //                height: 270.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: (document['VehicleOwnerPic']!=null)?
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: CachedNetworkImageProvider(document['VehicleOwnerPic']),
                                  ):CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: Text(document['VehicleOwnerName'].substring(0,1).toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'
                                      ),),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(document['VehicleOwnerName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'
                                        ),),
                                      Container(
                                        height: 1.0,
                                        width: MediaQuery.of(context).size.width-150.0,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          document['DriverRegNo'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.0
                                          ),
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Going to - ${document['Destination']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 15.0
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: (widget.matchedTable['${document.documentID}']!=null)?
                                  Container(
                                    height: 30.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                                    ),
                                    child: Center(
                                      child:Text('${widget.matchedTable['${document.documentID}']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'
                                      ),),
                                    )
                                  ):Container(
                                    height: 30.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.8),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                                    ),
                                    child: Center(
                                      child:Text('N/A',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat'
                                        ),),)
                                    ),
                                ),
                              ],
                            )
                          ));
                      }).toList(),
                    );
                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}
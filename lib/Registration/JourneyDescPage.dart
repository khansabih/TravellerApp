import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travellerapp/HomePages/Traveller/CreateJourney.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travellerapp/HomePages/VehicleOwnerSection/VehicleOwnerProfilePage.dart';

class journeyDescPage extends StatefulWidget{

  final DocumentSnapshot journeyDesc;
  final DocumentSnapshot currentUser;
  const journeyDescPage({Key key, this.journeyDesc, this.currentUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new journeyDescPageState();
  }

}

class journeyDescPageState extends State<journeyDescPage>{

  int hr,min;
  String zn;

  String carCompany,carColor,carModel,carNumber;

  int ending = 0;
  final snackBar = new SnackBar(content: Text('Oops!Looks like something went wrong'));

  void getCarInfo(){
    Firestore.instance.collection('Vehicles').document(widget.currentUser.documentID)
        .get().then((value){
          setState(() {
            carCompany = value['carCompany'];
            carColor = value['carColor'];
            carModel = value['carModel'];
            carNumber = value['carNumber'];
          });
    });
  }

  List trav = [];
  void getListOfTravellers(){
    for(int i=0;i<widget.journeyDesc['Others'].length;i++){
      setState(() {
        trav.add(widget.journeyDesc['Others'][i]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timestamp t = widget.journeyDesc['DepartureTime'];
    setState(() {
      hr = t.toDate().hour;
      min = t.toDate().minute;
      zn = t.toDate().timeZoneName;
    });
    getCarInfo();
    getListOfTravellers();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Builder(
        builder: (context){
          return Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/background.jpg'),
                        fit: BoxFit.fill
                    )
                ),
                child: ListView(
                  children: <Widget>[
                    Text("${widget.journeyDesc['Destination']}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),),

                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width-150.0,
                      color: Colors.white,
                    ),

                    SizedBox(
                      height: 15.0,
                    ),

//            timeDisplay()
                    Text("DEPARTURE TIME - ${hr}:${min} ${zn}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0
                      ),),

                    SizedBox(height: 20.0,),

                    Text("CAR INFORMATION",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                      ),),

                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width-150.0,
                      color: Colors.white,
                    ),

                    SizedBox(height: 5.0,),

                    Text("COMPANY - ${carCompany}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0
                      ),),

                    Text("MODEL - ${carModel}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0
                      ),),

                    Text("COLOR - ${carColor}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0
                      ),),

                    Text("NUMBER PLATE - ${carNumber}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0
                      ),),

                    SizedBox(height: 20.0,),

                    Text("OTHERS SHARING WITH YOU",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                      ),),

                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width-150.0,
                      color: Colors.white,
                    ),

                    SizedBox(height: 5.0,),

                    Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: widget.journeyDesc['Others'].length,
                          itemBuilder: (context,index){
                            return ListTile(
                              leading: (widget.journeyDesc['Others'][index]['Profile_pic']!=null)?CircleAvatar(
                                radius: 30.0,
                                backgroundImage: CachedNetworkImageProvider(widget.journeyDesc['Others'][index]['Others_Profile_pic']),
                              ):CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.black.withOpacity(0.4),
                                child: Center(
                                  child: Text(widget.journeyDesc['Others'][index]['OthersName'].toString().substring(0,1).toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'
                                    ),),
                                ),
                              ),
                              title: Text("${widget.journeyDesc['Others'][index]['OthersName'].toString().toUpperCase()}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17.0
                                ),),
                            );
                          }
                      ),
                    ),


                    Positioned(
                      bottom: 30.0,
                      left: MediaQuery.of(context).size.width*(1/8),
                      child: (ending==0)?GestureDetector(
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
                          //Delete from all the users that are linked
                          for(int i=0;i<widget.journeyDesc['Others'].length;i++){
                            Firestore.instance.collection('Users').where(
                              'RegistrationNo',isEqualTo: widget.journeyDesc['Others'][i]['OthersRegNo']
                            ).getDocuments().then((value){
                              DocumentSnapshot dc = value.documents[0];
                              Firestore.instance.collection('Users').document(dc.documentID)
                              .collection('InTransaction').document(widget.journeyDesc.documentID).delete();
                            });
                          }
                          Firestore.instance.collection('Journey').document(
                            widget.journeyDesc.documentID).delete().then((value){
                             setState(() {
                               ending = 0;
                             });
                             Navigator.of(context).pop();
                             Navigator.of(context).pushReplacement(
                               new MaterialPageRoute(
                                   builder: (BuildContext context)=>new VehicleOwnerProfilePage(
                                     curr_user: widget.currentUser,
                                   )
                               )
                             );
                          }).catchError((error){
                            setState(() {
                              ending = 0;
                            });
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        },
                      ):Center(
                          child:CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )),
                    )


                  ],
                ),
              ),
            ],
          );
        },
      )
    );
  }
}
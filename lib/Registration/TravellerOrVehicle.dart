import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travellerapp/Registration/VehicleOwner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:travellerapp/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravellerOrVehicle extends StatefulWidget{

  final File profileImage;
  final String name, regNo, room, mobile, password, confirmPassword, currentBranchSelected,
      currentCourseSelected, currentBlockSelected;

  const TravellerOrVehicle({Key key, this.profileImage, this.name, this.regNo, this.room, this.mobile, this.password, this.confirmPassword, this.currentBranchSelected, this.currentCourseSelected, this.currentBlockSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TravellerOrVehicleState();
  }

}

class TravellerOrVehicleState extends State<TravellerOrVehicle>{

  int progressState;
  bool uploading = false;
  String downloadURL;

  Future uploadProfilePic(String user_id) async{
    StorageReference picRef = FirebaseStorage.instance.ref().child('profileimages/${user_id}.png');

    StorageUploadTask task = picRef.putFile(widget.profileImage);
    task.events.listen((progress){
      setState(() {
        progressState = ((progress.snapshot.bytesTransferred.toDouble() / progress.snapshot.totalByteCount.toDouble())*100.0).round();
      });
    }).onError((error){
      setState(() {
        uploading=false;
      });
      Fluttertoast.showToast(
          msg: '${error}',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blue.withOpacity(0.8),
          textColor: Colors.white
      );
    });
    StorageTaskSnapshot completed = await task.onComplete;
    String url = await completed.ref.getDownloadURL();
    setState(() {
      downloadURL = url;
    });
  }

  void signUpTheTraveller() async{
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${widget.regNo.trimLeft().trimRight()}@manipal.com',
        password: widget.password.toString().trimLeft().trimRight()
    ).then((user) async {
      if (widget.profileImage == null) {
        setState(() {
          uploading = true;
        });
        //Start uploading the driving License.
        //Do registration without uploading profile pic
        Firestore.instance.collection('Users')
            .document('${user.user.uid}').setData({
          'Name': '${widget.name.toString().trim()}',
          'RegistrationNo': '${widget.regNo.toString().trim()}',
          'Branch': '${widget.currentBranchSelected}',
          'Course': '${widget.currentCourseSelected}',
          'Mobile': '${widget.mobile.toString().trim()}',
          'Block': '${widget.currentBlockSelected}',
          'isVehicleOwner': false,
          'Room': '${widget.room.toString().trim()}',
          'Profile_pic': null,
          'Attributes':{
            'Friendly':0,
            'Adventurous':0,
            'Kind':0,
            'PartyType':0
          }
        }).then((someValue) {
            setState(() {
              uploading = false;
            });

            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new login_page()
                )
            );
        }).catchError((error) {
          setState(() {
            uploading = false;
          });
          Fluttertoast.showToast(
              msg: '${error}',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.blue.withOpacity(0.8),
              textColor: Colors.white
          );
        });
      }
      else {
        await uploadProfilePic('${user.user.uid}');
        Firestore.instance.collection('Users')
            .document('${user.user.uid}').setData({
          'Name': '${widget.name.toString().trim()}',
          'RegistrationNo': '${widget.regNo.toString().trim()}',
          'Branch': '${widget.currentBranchSelected}',
          'Course': '${widget.currentCourseSelected}',
          'Mobile': '${widget.mobile.toString().trim()}',
          'Block': '${widget.currentBlockSelected}',
          'isVehicleOwner': false,
          'Room': '${widget.room.toString().trim()}',
          'Profile_pic': '${downloadURL}',
          'Attributes':{
            'Friendly':0,
            'Adventurous':0,
            'Kind':0,
            'PartyType':0
          }
        }).then((someValue) {
            setState(() {
              uploading = false;
            });

            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new login_page()
                )
            );
        }).catchError((error) {
          setState(() {
            uploading = false;
          });
          Fluttertoast.showToast(
              msg: '${error}',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.blue.withOpacity(0.8),
              textColor: Colors.white
          );
        });
      }
    });
  }

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
              child: (uploading==false)?Container(
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
                            "REGISTER AS TRAVELLER",
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
                        signUpTheTraveller();
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
                            "REGISTER AS VEHICLE OWNER",
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
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (BuildContext context)=>
                            new VehicleOwner(
                              profileImage: widget.profileImage,
                              name: widget.name,
                              regNo: widget.regNo,
                              room: widget.room,
                              mobile: widget.mobile,
                              password: widget.password,
                              confirmPassword: widget.confirmPassword,
                              currentBranchSelected: widget.currentBranchSelected,
                              currentCourseSelected: widget.currentCourseSelected,
                              currentBlockSelected: widget.currentBlockSelected,
                            ))
                        );
                      },
                    ),

                  ],
                ),
              ):Center(
                child:CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xffB95D20)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
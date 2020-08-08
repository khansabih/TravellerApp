import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travellerapp/HomePages/Options.dart';
import 'package:travellerapp/HomePages/Traveller/TravellerPage.dart';
import 'package:travellerapp/Registration/Chose.dart';
//import 'package:traveller/SignUp/sign_up_page.dart';
//import 'package:traveller/HomePage/homePageTraveller.dart';
//import 'package:traveller/HomePage/homePage.dart';

class login_page extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new login_pageState();
  }

}

class login_pageState extends State<login_page>{

  TextEditingController regNo = new TextEditingController();
  TextEditingController password = new TextEditingController();
  int visible = 0;

  int isUploading=0;

  bool isVehicleOwner=false;

  DocumentSnapshot userInfo;

  void signInUser(){
    setState(() {
      isUploading = 1;
    });
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '${regNo.text.toString().trimLeft().trimRight()}@manipal.com',
        password: '${password.text.toString()}').then((user){
      Firestore.instance.collection('Users').document('${user.user.uid}').get()
          .then((docs){
            setState(() {
              userInfo = docs;
            });
        if(docs['isVehicleOwner']==true){
          setState(() {
            isVehicleOwner = true;
          });
        }
        else if(docs['isVehicleOwner']==false){
          setState(() {
            isVehicleOwner = false;
          });
        }

      }).then((value){
        if(isVehicleOwner==true){
          setState(() {
            isUploading = 0;
          });
          Firestore.instance.collection('Users').document('${user.user.uid}').get().then((value){
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (BuildContext context)=>new Options(
                  userData: value,
                ))
            );
          }).catchError((error){
            debugPrint("Couldn't recieve the user information");
          });
        }
        else{
          setState(() {
            isUploading = 0;
          });
          Firestore.instance.collection('Users').document('${user.user.uid}').get().then((value){
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (BuildContext context)=>new TravellerPage(
                  userProfile: value,
                ))
            );
          }).catchError((error){
            debugPrint("Couldn't recieve the user information");
          });
//          Navigator.of(context).pop();
        }
      });
    }).catchError((error){
      setState(() {
        isUploading=0;
      });
      print(error);
    });
  }


  @override
  void initState() {
//    getDetails();
    super.initState();
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
                child: Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: Column(
                    children: <Widget>[

                      Container(
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
                        child: TextField(
                          controller: regNo,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.mail,color: Colors.white.withOpacity(0.6)),
                              hintText: "REGISTRATION NO",
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
                      ),

                      SizedBox(height: 15.0,),

                      Container(
                        padding: EdgeInsets.all(5.0),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width-100.0,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: TextField(
                          controller: password,
                          obscureText: (visible==0)?true:false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock,color: Colors.white.withOpacity(0.6)),
                              suffixIcon: GestureDetector(
                                child: (visible==0)?Icon(Icons.visibility_off,color: Colors.white.withOpacity(0.6))
                                    :Icon(Icons.visibility,color: Colors.white.withOpacity(0.6)),
                                onTap: (){
                                  if(visible==0){
                                    setState(() {
                                      visible = 1;
                                    });
                                  }else{
                                    setState(() {
                                      visible = 0;
                                    });
                                  }
                                },
                              ),
                              hintText: "PASSWORD",
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
                      ),

                      SizedBox(height: 20.0,),

                      (isUploading==0)?Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
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
                                child: Text("SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0
                                  ),),
                              ),
                            ),
                            onTap: (){
                              signInUser();
                            },
                          ),

                          SizedBox(width: 15.0,),

                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              height: 55.0,
                              width: 142.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Center(
                                child: Text("SIGN UP",
                                  style: TextStyle(
                                      color: Color(0xffB95D20),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0
                                  ),),
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (BuildContext context)=>new Chose())
                              );
                            },
                          ),

                        ],
                      ):Center(
                        child:CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )),
                    ],
                  ),
                ),
              )

            ],
          ),
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:travellerapp/Registration/TravellerOrVehicle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Chose extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChoseState();
  }

}

class ChoseState extends State<Chose>{

  int visible = 0;

  String passwordState = "Just to confirm";

  //For the room number of the user....
  List block = ['G1','G2','G3','G4','B1','B2','B3','B4','B5','B6','B7'];
  String currentBlockSelected="Block";

  //For block selection
  Future<bool> showBlockForSelection() async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    )
                  ]
              ),
              child: Scaffold(
                body: Container(
                  color: Colors.white.withOpacity(0.75),
                  child: ListView.builder(
                      itemCount: block.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${block[index]}'),
                            onTap: (){
                              setState(() {
                                currentBlockSelected="${block[index]}";
                                //loadStatesResponse("${countryName[index]}");
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }
                  ),
                ),
              )
          );
        }
    );
  }

  //For the users branch..
  List branch = ['B.TECH','MBA','B.TECH {LATERAL}','B.SC {HONS.}','B.A {HONS.}','B.DES',
    'B.ARCH','BPES','BA','B.COM','B.F.A','BBA + L.L.B {HONS.}','L.L.B','BALLB {HONS.}',
    'BHM','BBA','B.COM {HONS.}','BCA','M.TECH','M.SC','L.L.M','M.C.A','M.A','M.COM','M.ARCH',
    'PH.D'];

  List<String> courses = [];
  String currentBranchSelected = "Select a branch";
  String currentCourseSelected = "Select a course";

  Future loadCoursesResponse(String branchChosen) async{
    courses = new List();
    branchChosen = branchChosen.trimLeft().trimRight();
    String courseResult = await DefaultAssetBundle.of(context).loadString('jsonFile/courses.json');
    final courseResponse = json.decode(courseResult);
    for(int i=0;i<courseResponse.length;i++){
      if(courseResponse[i]['Branch'].toString().contains(branchChosen)){
        for(int j=0;j<courseResponse[i]['courses'].length;j++){
          courses.add(courseResponse[i]['courses'][j].toString());
        }
        break;
      }
    }
  }

  //To show the branch selection when prompted
  Future<bool> showBranchForSelection() async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    )
                  ]
              ),
              child: Scaffold(
                body: Container(
                  color: Colors.white.withOpacity(0.75),
                  child: ListView.builder(
                      itemCount: branch.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${branch[index]}'),
                            onTap: (){
                              setState(() {
                                currentBranchSelected="${branch[index]}";
                                //loadStatesResponse("${countryName[index]}");
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }
                  ),
                ),
              )
          );
        }
    );
  }

  //To show the course selection accordingly.
  Future<bool> showCoursesForSelection() async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    )
                  ]
              ),
              child: Scaffold(
                body: Container(
                  color: Colors.white.withOpacity(0.75),
                  child: ListView.builder(
                      itemCount: courses.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${courses[index]}'),
                            onTap: (){
                              setState(() {
                                currentCourseSelected="${courses[index]}";
                                //loadStatesResponse("${countryName[index]}");
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }
                  ),
                ),
              )
          );
        }
    );
  }


  //To the profile pic image
  File _profileImage;
  File result;
  bool uploading=false;
  int progressState=0;

  //To get the download url of the profile pic.
  String downloadURL;

  //For the user details..
  final TextEditingController name = new TextEditingController();
  final TextEditingController regNo = new TextEditingController();
  final TextEditingController course = new TextEditingController();
  final TextEditingController room = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final TextEditingController confirmPassword = new TextEditingController();


  //Now for user's profile pic..
  //1 - Display a dialogue box to let the user chose whether it wants to click in realtime
  // or it wants to upload it from the gallery
  Future<bool> PictureSelection() async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)
                )
            ),
            child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15.0)
                  ),
                  //color: Colors.white
                ),
                child: Column(
                  children: <Widget>[

                    //Prompt talking
                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text('Select how would you like to upload',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal
                          ),
                        )
                    ),

                    Padding(padding: EdgeInsets.all(10.0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        GestureDetector(
                          child: Icon(Icons.camera_alt,size: 50.0),
                          onTap: (){
                            takePicture(1);
                            Navigator.of(context).pop();
                          },
                        ),

                        Padding(padding: EdgeInsets.all(20.0)),

                        GestureDetector(
                          child: Icon(Icons.image,size: 50.0),
                          onTap: (){
                            takePicture(2);
                            Navigator.of(context).pop();
                          },
                        ),

                      ],
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  //2 - Take him/her to wherever the PictureSelection function gives you..
  Future takePicture(int n) async{
    if(n==1){
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      var _image = File(pickedFile.path);
//      result = await FlutterImageCompress.compressAndGetFile(
//        _image.absolute.path,
//
//        quality: 50,
//      );
      setState(() {
        _profileImage = _image;
      });
    }

    if(n==2){
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      var _image = File(pickedFile.path);
//      result = await FlutterImageCompress.compressAndGetFile(
//        _image.absolute.path,
//        _image.path,
//        quality: 50,
//      );
//      var result = await FlutterImageCompress.compressAndGetFile(
//        _image.absolute.path, _image.path,
//        quality: 88,
//        rotate: 180,
//      );
      setState(() {
        _profileImage = _image;
      });
    }
  }

  //To set the selected image in the place of the icon
  Widget setProfilePic(){
    return CircleAvatar(
      radius: 50.0,
      backgroundImage: FileImage(_profileImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height-100.0,
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width-50.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
//              color: Colors.white.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.2)
                  )
                ]
            ),
            child: ListView(
              children: <Widget>[

                Center(
                  child: (_profileImage==null)?GestureDetector(
                    child:Icon(Icons.account_circle, size: 80.0, color: Colors.white.withOpacity(0.75),),
                    onTap:(uploading==false)?(){
                      PictureSelection();
                    }:(){},
                  ):GestureDetector(
                    child: setProfilePic(),
                    onTap:(uploading==false)?(){
                      PictureSelection();
                    }:(){},
                  ),
                ),

                SizedBox(height: 20.0,),

                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name",
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

                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: TextField(
                    controller: regNo,
                    decoration: InputDecoration(
                        border: InputBorder.none,
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

                SizedBox(height: 20.0,),

                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    height: 60.0,
                    width: MediaQuery.of(context).size.width-100.0,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Center(
                      child: Text('${currentBranchSelected}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  onTap: () async{
                    await showBranchForSelection();
                    loadCoursesResponse('${currentBranchSelected}');
                  },
                ),

                SizedBox(height: 20.0,),

                //To select the course according to the branch
                (courses.length!=0)?GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    height: 60.0,
                    width: MediaQuery.of(context).size.width-100.0,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Center(
                      child: Text('${currentCourseSelected}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  onTap: () async{
                    await showCoursesForSelection();
                  },
                ):Container(),

                //Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(height: 20.0,),

                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    height: 60.0,
                    width: MediaQuery.of(context).size.width-100.0,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Center(
                      child: Text('${currentBlockSelected}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  onTap: () async{
                    await showBlockForSelection();
                  },
                ),

                SizedBox(height:20.0),

                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: TextField(
                    controller: mobile,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                          hintText: "MOBILE",
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

                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: TextField(
                    controller: room,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "ROOM",
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

                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: TextField(
                    controller: confirmPassword,
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
                        hintText: "CONFIRM PASSWORD",
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

                Center(
                  child: GestureDetector(
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
                        child: Text("CONTINUE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.5,
                              fontFamily: 'Montserrat'
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      if(name.text.length!=0&&
                          regNo.text.length!=0&&
                          mobile.text.length!=0&&
                          currentBranchSelected!="Select a branch" &&
                          currentCourseSelected!="Select a course"&&
                          currentBlockSelected!="Block"&&
                          room.text.length!=0&&
                          password.text.length!=0&&
                          confirmPassword.text.length!=0
                      ){
                        if(password.text.toString()==confirmPassword.text.toString()){
                          Navigator.of(context).push(
                              new MaterialPageRoute(builder: (BuildContext)=>new TravellerOrVehicle(
                                profileImage: _profileImage,
                                name: name.text.toString(),
                                regNo: regNo.text.toString(),
                                room: room.text.toString(),
                                mobile: mobile.text.toString(),
                                password: password.text.toString(),
                                confirmPassword: confirmPassword.text.toString(),
                                currentBranchSelected: currentBranchSelected,
                                currentCourseSelected: currentCourseSelected,
                                currentBlockSelected: currentBlockSelected,
                              ))
                          );
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "It seems your password and confirm password fields are not the same.",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              textColor: Colors.black
                          );
                        }
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "All fields are mandatory",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.white.withOpacity(0.7),
                            textColor: Colors.black
                        );
                      }
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
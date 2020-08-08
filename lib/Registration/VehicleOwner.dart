import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:travellerapp/Login/Login.dart';

class VehicleOwner extends StatefulWidget{
  final File profileImage;
  final String name,regNo,room,mobile,password,confirmPassword,currentBranchSelected,
      currentCourseSelected,currentBlockSelected;

  const VehicleOwner({Key key, this.profileImage, this.name, this.regNo, this.room, this.mobile, this.password, this.confirmPassword, this.currentBranchSelected, this.currentCourseSelected, this.currentBlockSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new VehicleOwnerState();
  }

}

class VehicleOwnerState extends State<VehicleOwner>{

  List<String> tags = new List();
  bool isValid = false;
  List carCodes = ["AP",
    "AR",
    "AS",
    "BR",
    "CG",
    "GA",
    "GJ",
    "HR",
    "HP",
    "JH",
    "KA",
    "KL",
    "MP",
    "MH",
    "MN",
    "ML",
    "MZ",
    "NL",
    "OD",
    "PB",
    "RJ",
    "SK",
    "TN",
    "TR",
    "UP",
    "UK/UA",
    "WB",
    "TS"];

  List carCompanies = [
    "Abarth",
    "Ashok Leyland",
    "Aston Martin",
    "Audi",
    "Bentley",
    "BMW",
    "Bugatti",
    "Dacia",
    "Datsun",
    "DC",
    "Ferrari",
    "Fiat",
    "Force",
    "Ford",
    "Honda",
    "Hyundai",
    "Isuzu",
    "Jaguar",
    "Jeep",
    "Lamborghini",
    "Land Rover",
    "Lexus",
    "Mahindra",
    "Maruti Suzuki",
    "Maserati",
    "Mercedes Benz",
    "Mini",
    "Mitsubishi",
    "Nissan",
    "Porsche",
    "Renault",
    "Rolls Royce",
    "Skoda",
    "Tata",
    "Toyota",
    "Volkswagen",
    "Volvo"
  ];

  final TextEditingController carName = new TextEditingController();
  final TextEditingController carNumber = new TextEditingController();
  final TextEditingController RTOcode = new TextEditingController();
  final TextEditingController uniqueNum = new TextEditingController();
  final TextEditingController carCompanySearch = new TextEditingController();
  final TextEditingController drivingLicenseNumber = new TextEditingController();

  String carRegistrationCode="AP";
  String carCompanySelected = "Select a company";
  String carModelSelected = "Select a model";

  List carModels = [];

  void selectModel(String selectedCompany)async{
    carModels = new List();
    selectedCompany = selectedCompany.trimLeft().trimRight();
    String carModelResult = await DefaultAssetBundle.of(context).loadString('jsonFile/carModels.json');
    final carModelResponse = json.decode(carModelResult);
    for(int i=0;i<carModelResponse.length;i++){
      if(carModelResponse[i]['brand'].toString().contains(selectedCompany)){
        for(int j=0;j<carModelResponse[i]['models'].length;j++){
          carModels.add(carModelResponse[i]['models'][j].toString());
        }
        break;
      }
    }
  }

  Future<bool> showCarCompaniesForSelection() async{
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
                      itemCount: carCompanies.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${carCompanies[index]}',style: TextStyle(fontWeight: FontWeight.bold),),
                            onTap: ()async{
                              setState((){
                                carCompanySelected="${carCompanies[index]}";
                                carModelSelected = "Select a model";
                                //loadStatesResponse("${countryName[index]}");
                              });
                              await selectModel(carCompanySelected);
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

  Future<bool> showCarModelForSelection() async{
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
                      itemCount: carModels.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${carModels[index]}',style: TextStyle(fontWeight: FontWeight.bold),),
                            onTap: (){
                              setState(() {
                                carModelSelected="${carModels[index]}";
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

  Future<bool> showCarCodesForSelection() async{
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
                      itemCount: carCodes.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: GestureDetector(
                            child: Text('${carCodes[index]}'),
                            onTap: (){
                              setState(() {
                                carRegistrationCode="${carCodes[index]}";
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

  //For chosing the color of the car
  String carColorSelected = "White";
  String currentColour = "#FFFFFF";
  List carColors = [];
  List colorName = [];
  void getCarColor() async {
    carColors = new List();
    String carColorsResult = await DefaultAssetBundle.of(context).loadString('jsonFile/colors.json');
    final carColorsResponse = json.decode(carColorsResult);
    for(int i=0;i<carColorsResponse.length;i++){
      carColors.add(carColorsResponse[i]['hexcode']);
      colorName.add(carColorsResponse[i]['display']);
    }
  }

  Future<bool> showCarColorsForSelection() async{
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
                      itemCount: carColors.length,
                      //itemExtent: 250.0,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          color: Color(
                              int.parse(carColors[index].substring(1, 7), radix: 16) + 0xFF000000
                          ),
                          child: GestureDetector(
                            child: ListTile(
                              title: Center(
                                child: Text('${colorName[index]}',
                                  style: TextStyle(
                                      color: (carColors[index]!='#FFFFFF')?Colors.white:Colors.black
                                  ),),
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                carColorSelected = colorName[index];
                                currentColour = carColors[index];
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

  //To the driver license pic image
  File _driverLicenseImage;
  File result;
  bool uploading=false;
  int progressState=0;

  //To get the download url of the profile pic.
  String downloadURL;
  //To get the download url of the driver license.
  String downloadDrivingLicenseUrl;

  Future<bool> DriverLicensePictureSelection() async{
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
      var _image = await ImagePicker.pickImage(source: ImageSource.camera);
      result = await FlutterImageCompress.compressAndGetFile(
        _image.path,
        _image.path,
        quality: 50,
      );
      setState(() {
        _driverLicenseImage = result;
      });
    }

    if(n==2){
      var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      result = await FlutterImageCompress.compressAndGetFile(
        _image.path,
        _image.path,
        quality: 50,
      );
      setState(() {
        _driverLicenseImage = result;
      });
    }
  }

  //To set the selected image in the place of the icon
  Widget setDriverLicense(){
    return Container(
      height: MediaQuery.of(context).size.height*(1/4),
      width: MediaQuery.of(context).size.width-10.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: FileImage(_driverLicenseImage),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
    );
  }

//  Finally to upload all the user details to firebase and take the user back
//  to the login page as well as tell the user to verify the verification mail

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

//  To upload the vehicle documentations and vehicle owner details
  //To upload the vehicle pictures
  Future uploadDriverLicense(String user_id) async{
    StorageReference picRef = FirebaseStorage.instance.ref().child('DrivingLicenseImages/${user_id}.png');

    StorageUploadTask task = picRef.putFile(_driverLicenseImage);
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
    String driving_url = await completed.ref.getDownloadURL();
    setState(() {
      downloadDrivingLicenseUrl = driving_url;
    });
  }

  void uploadUserDetails() async {
    debugPrint("I am in upload method");
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${widget.regNo.trimLeft().trimRight()}@manipal.com',
        password: widget.password.toString().trimLeft().trimRight()
    ).then((user) async{
      if(widget.profileImage==null){
        setState(() {
          uploading=true;
        });
        //Start uploading the driving License.
        if(_driverLicenseImage!=null){
          await uploadDriverLicense('${user.user.uid}');
          Firestore.instance.collection('Users')
              .document('${user.user.uid}').setData({
            'Name':'${widget.name.toString().trim()}',
            'RegistrationNo':'${widget.regNo.toString().trim()}',
            'Branch':'${widget.currentBranchSelected}',
            'Course':'${widget.currentCourseSelected}',
            'Mobile':'${widget.mobile.toString().trim()}',
            'Block':'${widget.currentBlockSelected}',
            'isVehicleOwner':true,
            'Room':'${widget.room.toString().trim()}',
            'Profile_pic':null,
            'Attributes':{
              'Friendly':0,
              'Adventurous':0,
              'Kind':0,
              'PartyType':0
            }
          }).then((value){
            Firestore.instance.collection('Vehicles')
                .document('${user.user.uid}').setData({
              'RegistrationNo':'${widget.regNo.toString().trim()}',
              'carModel':'${carModelSelected}',
              'carCompany':'${carCompanySelected}',
              'numberPlate':'${carRegistrationCode}${uniqueNum.text.toString()}',
              'carColor':'${carColorSelected}',
              'drivingLicense':'${downloadDrivingLicenseUrl}',
              'drivingLicenseNumber':'${drivingLicenseNumber.text.toString().trimLeft().trimRight()}'
            }).then((someValue){
              setState(() {
                uploading=false;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                      builder: (BuildContext context)=> new login_page()
                  )
              );

            });
          }).catchError((error){
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
        }
        else{
          Firestore.instance.collection('Users')
              .document('${user.user.uid}').setData({
            'Name':'${widget.name.toString().trim()}',
            'RegistrationNo':'${widget.regNo.toString().trim()}',
            'Branch':'${widget.currentBranchSelected}',
            'Course':'${widget.currentCourseSelected}',
            'Mobile':'${widget.mobile.toString().trim()}',
            'Block':'${widget.currentBlockSelected}',
            'isVehicleOwner':true,
            'Room':'${widget.room.toString().trim()}',
            'Profile_pic':null,
            'Attributes':{
              'Friendly':0,
              'Adventurous':0,
              'Kind':0,
              'PartyType':0
            }
          }).then((value){
            Firestore.instance.collection('Vehicles')
                .document('${user.user.uid}').setData({
              'carModel':'${carModelSelected}',
              'carCompany':'${carCompanySelected}',
              'numberPlate':'${carRegistrationCode}${uniqueNum.text.toString()}',
              'carColor':'${carColorSelected}',
              'drivingLicense':'${downloadDrivingLicenseUrl}',
              'drivingLicenseNumber':'${drivingLicenseNumber.text.toString().trimLeft().trimRight()}'
            }).then((someValue){
              setState(() {
                uploading=false;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                      builder: (BuildContext context)=> new login_page()
                  )
              );

            });
          }).catchError((error){
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
        }
        //Do registration without uploading profile pic
      }
      else{
        await uploadProfilePic('${user.user.uid}');
        if(_driverLicenseImage!=null){
          await uploadDriverLicense('${user.user.uid}');
          Firestore.instance.collection('Users')
              .document('${user.user.uid}').setData({
            'Name':'${widget.name.toString().trim()}',
            'RegistrationNo':'${widget.regNo.toString().trim()}',
            'Branch':'${widget.currentBranchSelected}',
            'Course':'${widget.currentCourseSelected}',
            'Mobile':'${widget.mobile.toString().trim()}',
            'Block':'${widget.currentBlockSelected}',
            'Room':'${widget.room.toString().trim()}',
            'isVehicleOwner':true,
            'Profile_pic':'${downloadURL}',
            'Attributes':{
              'Friendly':0,
              'Adventurous':0,
              'Kind':0,
              'PartyType':0
            }
          }).then((value){
            Firestore.instance.collection('Vehicles')
                .document('${user.user.uid}').setData({
              'carModel':'${carModelSelected}',
              'carCompany':'${carCompanySelected}',
              'numberPlate':'${carRegistrationCode}${uniqueNum.text.toString()}',
              'carColor':'${carColorSelected}',
              'drivingLicense':'${downloadDrivingLicenseUrl}',
              'drivingLicenseNumber':'${drivingLicenseNumber.text.toString().trimLeft().trimRight()}',
              'tags':tags
            }).then((_){
              setState(() {
                uploading=false;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                      builder: (BuildContext context)=> new login_page()
                  )
              );
            });
          }).catchError((error){
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
        }
        else{
          Firestore.instance.collection('Users')
              .document('${user.user.uid}').setData({
            'Name':'${widget.name.toString().trim()}',
            'RegistrationNo':'${widget.regNo.toString().trim()}',
            'Branch':'${widget.currentBranchSelected}',
            'Course':'${widget.currentCourseSelected}',
            'Mobile':'${widget.mobile.toString().trim()}',
            'Block':'${widget.currentBlockSelected}',
            'Room':'${widget.room.toString().trim()}',
            'isVehicleOwner':true,
            'Profile_pic':'${downloadURL}',
            'Attributes':{
              'Friendly':0,
              'Adventurous':0,
              'Kind':0,
              'PartyType':0
            }
          }).then((value){
            Firestore.instance.collection('Vehicles')
                .document('${user.user.uid}').setData({
              'carModel':'${carModelSelected}',
              'carCompany':'${carCompanySelected}',
              'numberPlate':'${carRegistrationCode}${uniqueNum.text.toString()}',
              'carColor':'${carColorSelected}',
              'drivingLicense':'${downloadDrivingLicenseUrl}',
              'drivingLicenseNumber':'${drivingLicenseNumber.text.toString().trimLeft().trimRight()}',
              'tags':tags
            }).then((_){
              setState(() {
                uploading=false;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                      builder: (BuildContext context)=> new login_page()
                  )
              );
            });
          }).catchError((error){
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
        }
      }
    }).catchError((error){
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
  }

  @override
  void initState() {
//    loadCarCodes();
    getCarColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5)
          ),
          child: ListView(
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(top:20.0,left: 10.0),
                child: Text("ABOUT THE VEHICLE",style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.normal,fontSize: 20.5,
                fontFamily: 'Montserrat'),),
              ),

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
                  child: Center(
                    child: Text("${carCompanySelected.toUpperCase()}",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize:18.5,
                        fontFamily: 'Montserrat'
                    ),
                    ),
                  ),
                ),
                onTap: (){
                  showCarCompaniesForSelection();
                },
              ),

//              SizedBox(height: 7.5,),

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
                  child: Center(
                    child: Text("${carModelSelected.toUpperCase()}",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.5,
                      fontFamily: 'Montserrat'
                    ),
                    ),
                  ),
                ),
                onTap: (){
                  showCarModelForSelection();
                },
              ),

              SizedBox(height: 10.0,),

              GestureDetector(
                child: Container(
                  height:55.0,
                  width: MediaQuery.of(context).size.width-100.0,
                  margin:EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Color(
                          int.parse(currentColour.substring(1, 7), radix: 16) + 0xFF000000
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                          color: Color(
                              int.parse(currentColour.substring(1, 7), radix: 16) + 0xFF000000
                          )
                      )
                  ),
                  child: Center(
                    child: Text("${carColorSelected.toUpperCase()}",style: TextStyle(
                        color: (currentColour!='#FFFFFF')?Colors.white:Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.5,
                      fontFamily: 'Montserrat'
                    ),
                    ),
                  ),
                ),
                onTap: (){
                  showCarColorsForSelection();
                },
              ),

              SizedBox(height: 10.0,),

              Container(
                margin: EdgeInsets.only(top:20.0,left: 10.0),
                child: Text("REGISTRY INFORMATION",style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.normal,fontSize: 20.5,
                fontFamily: 'Montserrat'),),
              ),

              GestureDetector(
                child: Container(
//                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        height:60.0,
                        width: 55.0,
                        margin:EdgeInsets.only(left: 10.0,top:10.0,bottom: 10.0,right: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.black.withOpacity(0.4)
                        ),
                        child: Center(
                          child: Text("${carRegistrationCode}",style: TextStyle(color: Colors.white),),
                        ),
                      ),

                      Container(
                        margin:EdgeInsets.only(top:10.0,bottom: 10.0),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width-90.0,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: TextField(
                          controller:uniqueNum,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "\tREST",
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat'
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Montserrat'
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async{
                  await showCarCodesForSelection();
                },
              ),

              SizedBox(height: 20.0,),

              Container(
                margin:EdgeInsets.only(left:10.0,right:10.0,top:10.0,bottom: 10.0),
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                width: MediaQuery.of(context).size.width-90.0,
                child: TextField(
                  controller:drivingLicenseNumber,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "DRIVING LICENSE NUMBER",
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat'
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    fontFamily: 'Montserrat'
                  ),
                ),
              ),

              GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height*(1/4),
                  width: MediaQuery.of(context).size.width-10.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Center(
                    child: (_driverLicenseImage==null)?Text("Click here to attach a picture of your driving liscene",
                      style: TextStyle(
                          color: Colors.white
                      ),):setDriverLicense(),
                  ),
                ),
                onTap: (){
                  DriverLicensePictureSelection();
                },
              ),

              SizedBox(height: 10.0,),

              (uploading==false)?GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  height: 55.0,
                  width: 142.0,
                  decoration: BoxDecoration(
                    color: Color(0xffB95D20),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Center(
                    child: Text("REGISTER",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0
                      ),),
                  ),
                ),
                onTap: (){
                  uploadUserDetails();
                },
              ):Center(
                  child:CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )),

//              (uploading==true)?Center(
//                child: Container(
//                  margin: EdgeInsets.all(10.0),
//                  child: Text("${progressState}",
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 17.5,
//                        fontWeight: FontWeight.w600
//                    ),),
//                ),
//              ):Container()

            ],
          ),
        ),
      ),
    );
  }

  //To validate the driving license number
  bool validateDrivingLicense(String drivingLicenseNumber){
    bool result = true;
//    drivingLicenseNumber = "r"+drivingLicenseNumber;
//    print(drivingLicenseNumber.codeUnitAt(0));
    if(drivingLicenseNumber.length==16){
      drivingLicenseNumber = drivingLicenseNumber.replaceAll(RegExp(r"[^\s\w]+"),'');
      drivingLicenseNumber = drivingLicenseNumber.replaceAll(RegExp(r"\s+\b|\b\s"), "");
//      print(drivingLicenseNumber.substring(0,2));
      int convertToNum = int.tryParse(drivingLicenseNumber.substring(2,4));
      if(isStringEquals(drivingLicenseNumber.substring(0,2), "DL")==true){
        //Check the 2-digit RTO code
        print("In the DL section");
        if(int.tryParse(drivingLicenseNumber.substring(2,4))>=00
            && int.tryParse(drivingLicenseNumber.substring(2,4))<=99){

          //Now check the year
          if(int.tryParse(drivingLicenseNumber.substring(4,8))<=2020){

            //Check the rest of the numbers
            for(int j=8;j<15;j++){
              if(int.tryParse(drivingLicenseNumber[j])<0
                  || int.tryParse(drivingLicenseNumber[j])>9){
//                print(drivingLicenseNumber[j]);
                print("Doesnt match");
                result = false;
                break;
              }
            }

          }

        }
      }
      else {
        print("In the carCodes section");
        for(int i=0;i<carCodes.length;i++){
          if(isStringEquals(drivingLicenseNumber.substring(0,2), carCodes[i].toString())==true){
            result = true;
            print(carCodes[i]);
            if(int.tryParse(drivingLicenseNumber.substring(2,4))>=00
                && int.tryParse(drivingLicenseNumber.substring(2,4))<=99){

              if(int.tryParse(drivingLicenseNumber.substring(4,8))<=2020){

                for(int j=8;j<drivingLicenseNumber.length;j++){
                  if(int.tryParse(drivingLicenseNumber[j])<0
                      || int.tryParse(drivingLicenseNumber[j])>9){
                    print("Doesnt match");
                    result = false;
                    break;
                  }
                }

              }

            }
            break;
          }
          else{
            result = false;
          }
        }
      }
    }
    else{
      result = false;
    }

    return result;
  }

  bool isStringEquals(String a, String b){
    bool result = true;
    a = a.trimLeft().trimRight();
    b = b.trimLeft().trimRight();
    print("a = ${a}");
    print("b = ${b}");
    if(a.length == b.length){
      for(int i=0;i<a.length;i++){
        if(a[i]!=b[i]){
          print('${a[i]} does not match ${b[i]}');
          result = false;
          break;
        }
      }
    }
    else{
      result = false;
    }
    return result;
  }
}
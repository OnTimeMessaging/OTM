import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ontimemessaging/rooms.dart';
// import 'package:settings_ui/pages/settings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SizeConfig.dart';
class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  File _image;

  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String status;
  String myId = '';
  String myUsername = '';

  String imageUrl = '';
  File _pickedImage;
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
 bool _isImage = false;
 bool _refresh =false;
  @override
  void initState() {
    // TODO: implement initState
    _getUserName();
    getCurrentUser();
    super.initState();
  }
  //
  // Future getImageFile() async {
  //   final result = await picker.pickImage(source: ImageSource.gallery);
  //   File croppedFile = await ImageCropper.cropImage(
  //       sourcePath: result.path,
  //       aspectRatioPresets: [
  //         CropAspectRatioPreset.square,
  //       ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.blueAccent,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         minimumAspectRatio: 1.0,
  //       ));
  //
  //   var optimisedImage = img.decodeImage(croppedFile.readAsBytesSync());
  //   var newImage = img.copyResize(optimisedImage, width: 1401);
  // //  final directory = await getTemporaryDirectory();
  //   final name = result.name;
  //   final file = File(result.path);
  //   final reference = FirebaseStorage.instance.ref(name);
  //   await reference.putFile(file);
  //   final uri = await reference.getDownloadURL();
  //   setState(() {
  //     print(result);
  //     if (result != null) {
  //       imageUrl =File(uri).toString();
  //     } else {
  //       print('No file selected');
  //     }
  //   });
  // }
bool isLoading=false;
  Future<void> _getUserName() async {
    setState(() {
      isLoading = false;
    });
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc('${user.uid}')
        .snapshots()
        .listen((userData) {
      setState(() {
        //lastName = userData.data()['lastName'];
        myUsername = userData.data()['firstName'].toString();
        imageUrl = userData.data()['imageUrl'].toString();
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  //
  //
  void _imagePick()async{
    setState(() {
     _isImage = true;
    });
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: result.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    var optimisedImage = img.decodeImage(croppedFile.readAsBytesSync());
    var newImage = img.copyResize(optimisedImage, width: 1401);
    if (result != null) {
      final file = File(result.path);
      final name = result.name;
      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        setState(() {
          imageUrl = uri;
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _isImage = false;
    });
  }
  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );
  //
  //   if (result != null) {
  //     final file = File(result.path);
  //     final name = result.name;
  //     try {
  //       final reference = FirebaseStorage.instance.ref(name);
  //       await reference.putFile(file);
  //       final uri = await reference.getDownloadURL();
  //       setState(() {
  //         imageUrl = uri;
  //       });
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void updateUser() async {
    var updateObject = Map<String, dynamic>();
    if (name != null) {
      updateObject['firstName'] = name.toString();
    }
    if (imageUrl != null) {
      updateObject['imageUrl'] = imageUrl.toString();
    }
    return users
        .doc('${user.uid}')
        .update(updateObject

    ).then((value) {
      Fluttertoast.showToast(
          msg: "Done",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        _isImage =false;
      });
    })
        .catchError((error) => print("Failed to update user: $error"));

  }

  void getCurrentUser() async {
    setState(() {
      isLoading = false;
      try {
        user = _auth.currentUser;
      } catch (e) {}
    });

  }


  Future<void> _pullRefresh() async {
    _getUserName();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ModalProgressHUD(
    inAsyncCall:isLoading ,
        child: isLoading == true ?
        Container()
        :Scaffold(
            backgroundColor: Color(0xff3B3940),
          appBar: AppBar(
            backgroundColor: Color(0xff3B3940),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Text("Profile"),

            elevation: 80,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
                _pullRefresh();
              },
            ),
            actions: [
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                print(_auth.currentUser);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                  onTap: (){
                        _imagePick();
                      },
                      child: Center(
                        child: Container(
                          decoration: imageUrl == null
                              ? BoxDecoration(
                            image: DecorationImage(
                              image: imageUrl != null
                                  ? CachedNetworkImageProvider(
                                 imageUrl)
                              // ? NetworkImage(widget.displayPicture)
                                  : AssetImage('assets/images/person.png'),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                              : BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 100,
                          width: 100,
                          child: _isImage == true
                              ? SpinKitPulse(
                            color: Colors.blue,
                          )
                              : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                        ),
                      //   Stack(
                      //       children: [GestureDetector(
                      //       onTap: (){
                      //         _imagePick();
                      //       },
                      //       child: CircleAvatar(
                      //         radius: 55,
                      //         backgroundColor: Colors.black,
                      //         child: imageUrl == null ? Icon(Icons.person) : null,
                      //         backgroundImage:
                      //         imageUrl!= null ? NetworkImage(imageUrl) : null,
                      //       ),
                      //     ),
                      // Positioned(
                      //     bottom: 0,
                      //     right: 0,
                      //     child: Container(
                      //       height: 30,
                      //       width: 40,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //        color: Colors.grey
                      //       ),
                      //       child: Icon(
                      //         Icons.camera,
                      //         color: Colors.white,
                      //       ),
                      //     )),
                      //       ],
                      //   ),
                      ),
                    ),
                    SizedBox(height: 20,),
                 //   Divider(thickness: 2,),
                    TextFormField(
                      initialValue: myUsername,
                      style: TextStyle(color: Color(0xffEAEAEA),
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.person,
                              color: Color(0xffEAEAEA),
                            ), // icon is 48px widget.
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color:Color(0xffEAEAEA) ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Color(0xffEAEAEA)),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Color(0xffEAEAEA)),
                          // ),
                          labelText: myUsername,
                          labelStyle: TextStyle(color: Color(0xffEAEAEA)),
                          hintText:
                          "Name",
                          hintStyle: TextStyle(color: Color(0xffEAEAEA))),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        }
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     border: Border.all(color:Color(0xffEAEAEA) )),
                          // height: MediaQuery
                          //     .of(context)
                          //     .size
                          //     .height / 13,
                          child: Row(children: [Icon(Icons.email,color: Color(0xffEAEAEA),), Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(" ${user.email}", style: TextStyle(
                              color: Color(0xffEAEAEA),  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          )
                          ],)
                      ),
                    ),
                 //   Divider(thickness: 2,),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: updateUser,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)
                            ),
                            height: MediaQuery.of(context).size.height/20,
                            width: MediaQuery.of(context).size.width/3,
                            child: Center(
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class RegesterPorfile extends StatefulWidget {


  @override
  _RegesterPorfileState createState() => _RegesterPorfileState();
}

class _RegesterPorfileState extends State<RegesterPorfile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String status;
  String myId = '';
  String myUsername = '';

  String imageUrl = '';
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
bool _updating = false;
  void _getdata() async {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        //lastName = userData.data()['lastName'];
        myUsername = userData.data()['firstName'];
        imageUrl = userData.data()['imageUrl'];
      });
    });
  }
  bool _isImage = false;
  bool isImageLoading = false;
  void _imagePick()async{
    setState(() {
      _isImage = true;
    });
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: result.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    var optimisedImage = img.decodeImage(croppedFile.readAsBytesSync());
    var newImage = img.copyResize(optimisedImage, width: 1401);
    if (result != null) {
      final file = File(result.path);
      final name = result.name;
      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        setState(() {
          imageUrl = uri;
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _isImage = false;
    });
  }

  void updateUser() async {
    var updateObject =Map<String, dynamic>();
    if( name != null) {
      updateObject['firstName'] = name.toString();
    }
    if(imageUrl != null) {
      updateObject['imageUrl'] = imageUrl.toString();
    }
    return users
        .doc('${user.uid}')
        .update(updateObject
      //     {
      //
      //   // 'firstName': '${name.toString()}',
      //   // 'imageUrl': '${imageUrl.toString()}',
      //   // 'lastName': '${name.toString()}'
      // }
    )
        .then((value) {print("Profile has been changed successfully");})
        .catchError((error) => print("Failed to update user: $error"));
  }
  void getCurrentUser() async {
    setState(() {
      try {
        user = (_auth.currentUser);
      } catch (e) {}
    });
  }

  TextEditingController firstNameController = TextEditingController();
  bool showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xff3B3940),
        appBar: AppBar(
            title: Text("Profile"),
            centerTitle: true,
            backgroundColor: Color(0xff3B3940),
            elevation: 80,
          leading: Text(''),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    _imagePick();
                  },
                  child: Center(
                    child: Container(
                      decoration: imageUrl == null
                          ? BoxDecoration(
                        image: DecorationImage(
                          image: imageUrl != null
                              ? CachedNetworkImageProvider(
                              imageUrl)
                          // ? NetworkImage(widget.displayPicture)
                              : AssetImage('assets/images/person.png'),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )
                          : BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 100,
                      width: 100,
                      child: _isImage == true
                          ? SpinKitPulse(
                        color: Colors.blue,
                      )
                          : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                    ),
                    //   Stack(
                    //       children: [GestureDetector(
                    //       onTap: (){
                    //         _imagePick();
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 55,
                    //         backgroundColor: Colors.black,
                    //         child: imageUrl == null ? Icon(Icons.person) : null,
                    //         backgroundImage:
                    //         imageUrl!= null ? NetworkImage(imageUrl) : null,
                    //       ),
                    //     ),
                    // Positioned(
                    //     bottom: 0,
                    //     right: 0,
                    //     child: Container(
                    //       height: 30,
                    //       width: 40,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //        color: Colors.grey
                    //       ),
                    //       child: Icon(
                    //         Icons.camera,
                    //         color: Colors.white,
                    //       ),
                    //     )),
                    //       ],
                    //   ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(child: Text("Change Profile picture",
                  style: TextStyle(color: Colors.white),)),
                SizedBox(
                  height: 30,
                ),
                Divider(color: Colors.white,),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: myUsername,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ), // icon is 48px widget.
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: myUsername,
                        labelStyle: TextStyle(color: Colors.white),
                        hintText:
                        "Name",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      }
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.white)),
                      height: MediaQuery.of(context).size.height/16,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [Icon(Icons.email,color: Colors.white,),Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(" ${user.email}",style:TextStyle(color: Colors.white,),
                          ),
                        )
                        ],),
                      )
                  ),
                ),

                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                          updateUser();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => RoomsPage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white)
                        ),
                        height: MediaQuery.of(context).size.height/28,
                        width: MediaQuery.of(context).size.width/4,
                        child: Center(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffEAEAEA),
            )),
      ),
    );
  }

}


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontimemessaging/rooms.dart';
// import 'package:settings_ui/pages/settings.dart';

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

  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String status;
  String myId = '';
  String myUsername = '';
  String lastName = '';
  String imageUrl = '';
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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
  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final file = File(result.path);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        print(uri.toString());
        setState(() {
          imageUrl = uri;
        });
      } catch (e) {
        print(e);
      }

      // final message = types.PartialImage(
      //   height: image.height.toDouble(),
      //   name: name,
      //   size: size,
      //   uri: uri,
      //   width: image.width.toDouble(),
      // );

      // FirebaseChatCore.instance.sendMessage(
      //   message,
      //   widget.room.id,
      // );
      //   _setAttachmentUploading(false);
      // } on FirebaseException catch (e) {
      //   _setAttachmentUploading(false);
      //   print(e);
      // }
    }
  }

  void updateUser() async {
    print(users.doc('${user.uid}'));
    return users
        .doc('${user.uid}')
        .update({
      'firstName': '${name.toString()}',
      'imageUrl': '${imageUrl.toString()}',
    // 'lastName': '${name.toString()}'
    })
        .then((value) {print("Profile has been changed successfully");})
        .catchError((error) => print("Failed to update user: $error"));
  }

void getCurrentUser() async {
    setState(() {
      try {
        user = ( _auth.currentUser);
        print(user);
        // print(name);
        // print(user!.uid);
        // print(user!.providerData.toString());
        // print(user!.refreshToken);
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 80,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.settings,
          //   ),
          //   onPressed: () {
          //     // Navigator.of(context).push(MaterialPageRoute(
          //     //     builder: (BuildContext context) => SettingsPage()));
          //   },
          // ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            print(myUsername);
            print(user);
            print(imageUrl);
            print(imageUrl);
            // FocusScope.of(context).unfocus();
            // print(user);
            // print(_auth.currentUser!);
            // print(myUsername);
            // print(user!.uid);
            // print(user!.providerData.toString());
            // print(user!.refreshToken);
          },
          child: ListView(
            children: [

              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _handleImageSelection();
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color:
                                Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  imageUrl == null
                                      ?"https://bethanychurch.org.uk/wp-content/uploads/2018/09/profile-icon-png-black-6.png"
                                      : imageUrl,
                                ))),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color:Colors.white,
                            ),
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.white),
                        ),
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),

                        ),

                          labelText: myUsername,
                          labelStyle: TextStyle(color: Colors.white),
                          hintText:
                          "name"),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        }
                        );

                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                 height: 60,
                 child: Padding(
                   padding: const EdgeInsets.only(right: 180),
                   child: Center(child: Text("${user.email}", style: TextStyle(color: Colors.white),)),
                 ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration:
              //     BoxDecoration(borderRadius: BorderRadius.circular(8)),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: TextField(
              //         decoration: InputDecoration(labelText: 'Status'),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OutlineButton(
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20)),
                  //   onPressed: () {},
                  //   child: Text("CANCEL",
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           letterSpacing: 2.2,
                  //           color: Colors.black)),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)
                    ),
                    child: RaisedButton(
                      onPressed: () {
                      updateUser();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => RoomsPage()));
                                        },
                      color: Colors.black,
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
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

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
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
              color: Colors.black,
            )),
      ),
    );
  }
}
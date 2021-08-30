import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ontimemessaging/Users.dart';
import 'package:ontimemessaging/db/screen.dart';
import 'package:ontimemessaging/main.dart';
import 'package:ontimemessaging/profile.dart';
import 'package:ontimemessaging/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';

import 'chat.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  int _counter = 0;
  bool _initialized = false;
  User _user;
  User user = FirebaseAuth.instance.currentUser;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String imageUrl = '';

  @override
  void initState() {
    initializeFlutterFire();
    _getdata();
    print("hi");
    print(_getdata);

  }

  void _getdata() async {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        imageUrl = userData.data()['imageUrl'];
      });
    });
  }
  String createdAt = '';
 void messageData(types.Room room) async {
   FirebaseFirestore.instance
       .collection('rooms/${room.id}/messages').doc(user.uid)
       .snapshots().listen((userData) {
         setState(() {
      createdAt = userData.data()['createdAt'];
         });
   });
   }
    //   .map(
      //     (snapshot) {
      //   return snapshot.docs.fold<List<types.Message>>(
      //     [],
      //         (previousValue, element) {
      //       final data = element.data();
      //       final author = room.users.firstWhere(
      //             (u) => u.id == data['authorId'],
      //         orElse: () => types.User(id: data['authorId'] as String),
      //       );
      //
      //       data['author'] = author.toJson();
      //       data['id'] = element.id;
      //       try {
      //         data['createdAt'] = element['createdAt']?.millisecondsSinceEpoch;
      //         data['updatedAt'] = element['updatedAt']?.millisecondsSinceEpoch;
      //       } catch (e) {
      //         // Ignore errors, null values are ok
      //       }
      //       data.removeWhere((key, value) => key == 'authorId');
      //       return [...previousValue, types.Message.fromJson(data)];
      //     },
      //   );
      // },

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.white;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
              (u) => u.id != _user.uid,
        );
        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    // final hasImage = room.imageUrl;
    final name = room.name ?? '';
    print(room.imageUrl);
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        backgroundImage:
        room.imageUrl != null ? NetworkImage(room.imageUrl) : null,
        child: room.imageUrl == null
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.black),
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton:  _user == null
            ? null
            : FloatingActionButton(
          onPressed: () {
            //   showNotifications();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UsersPage();
            }));
          },
          child: Icon(Icons.chat),
        ),

        appBar: _user == null
            ? null
            : PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.alarm),
              //   onPressed: _user == null
              //       ? null
              //       : () {
              //
              //           Navigator.of(context).push(
              //             MaterialPageRoute(
              //               fullscreenDialog: true,
              //               builder: (context) => SheduleScreen(),
              //             ),
              //           );
              //         },
              // ),


              // IconButton(
              //   icon: const Icon(Icons.account_circle),
              //   onPressed: _user == null
              //       ? null
              //       : () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         fullscreenDialog: true,
              //         builder: (context) => EditProfilePage(),
              //       ),
              //     );
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.settings),
                  onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditProfilePage();
                  }));
                  },
                // onPressed: _user == null ? null : logout,
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _user == null ? null : logout,
                // onPressed: _user == null ? null : logout,
              )
            ],
            brightness: Brightness.dark,
            // leading:   Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           fullscreenDialog: true,
            //           builder: (context) => EditProfilePage(),
            //         ),
            //       );
            //     },
            //     child: CircleAvatar(
            //       radius: 5.0,
            //       backgroundImage: NetworkImage(
            //         imageUrl == null
            //             ? "https://bethanychurch.org.uk/wp-content/uploads/2018/09/profile-icon-png-black-6.png"
            //             : imageUrl,
            //       ),
            //       backgroundColor: Colors.transparent,
            //     ),
            //   ),
            // ),
          //  centerTitle: true,
            title:  Text('OTM'),
          ),
        ),

        body: _user == null
            ? Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Welcome.png',
                height:MediaQuery.of(context).size.height/2,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>  LoginPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue
                  ),
                  height: MediaQuery.of(context).size.height/15,
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Center(child: Text("Welcome",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),)),
                ),
              )
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         fullscreenDialog: true,
              //         builder: (context) =>  LoginPage(),
              //       ),
              //     );
              //   },
              //   child: const Text('Welcome'),
              // ),
            ],
          ),
        )

            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('No rooms',style: TextStyle(color: Colors.white),),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final room = snapshot.data[index];
                  print(room.lastMessages.toString());
                  print(createdAt.toString());
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                room: room,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                           //   messageData(room),
                              _buildAvatar(room),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${room.lastMessages != null ? room.lastMessages[0] : ""}".toString(),style: TextStyle(color: Colors.white)),
                                  Text(
                                    room.name ?? 'User Name Not Available',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                                  ),
                                //  Text(widget.lastMessage,style: TextStyle(color:Colors.grey,),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
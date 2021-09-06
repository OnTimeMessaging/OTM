import 'dart:io';
import 'dart:math';

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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ontimemessaging/SignUp.dart';
import 'package:ontimemessaging/Users.dart';
import 'package:ontimemessaging/profile.dart';
import 'package:ontimemessaging/utils.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Login.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'New DB/SchedulePGE.dart';
import 'chat.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User _user;
  User user = FirebaseAuth.instance.currentUser;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String imageUrl = '';

  @override
  void initState() {
    initializeFlutterFire();
    registerNotification();
    configLocalNotification();
    super.initState();

  //  _getdata();
  }
  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? "hmrengg.com.ontimemessaging" : "hmrengg.com.ontimemessaging",
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  bool _userLoading = false;
  // void _getdata() async {
  //   User user = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .snapshots()
  //       .listen((userData) {
  //     setState(() {
  //       imageUrl = userData.data()['imagSeUrl'].toString();
  //     });
  //   });
  //   setState(() {
  //     _userLoading = false;
  //   });
  // }

  String createdAt = '';

  Future<String> TimeData(types.Room room) async {
    var time;
    await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get()
        .then((value) {
    //  print(value.docs[0].data());
      if (value.docs != null && value.docs.length > 0) {
        time = (value.docs[0].data()['updatedAt']).toDate().toString();
      } else {
        time = '';
      }
    });
    return time;
  }

  Future<String> messageData(types.Room room) async {
    var message;
    await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get()
        .then((value) {

      if (value.docs != null && value.docs.length > 0) {
        message = value.docs[0].data()['text'];
      } else {
        message = '';
      }
    });
    return message;
  }

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


  Widget _time(types.Room room) {
    return FutureBuilder(
      future: TimeData(room),
      builder:
          (BuildContext context, AsyncSnapshot<String> messageTimeSnapshot) {
        Widget MessageTime;

        if (messageTimeSnapshot.connectionState == ConnectionState.done) {
          MessageTime = Text(
            (messageTimeSnapshot.data).toString(),
            style: TextStyle(color: Colors.white),
          );
        } else {
          MessageTime = Text("");

        }
        return MessageTime;
      },
    );
  }

  Widget _resentMessage(types.Room room) {
    return FutureBuilder(
      future: messageData(room),
      builder: (BuildContext context, AsyncSnapshot<String> messageSnapshot) {
        Widget LastMess;

        if (messageSnapshot.connectionState == ConnectionState.done) {
          LastMess = Text(
            messageSnapshot.data.toString(),
            style: TextStyle(color: Color(0xffB3ACA8), fontSize: 15),
          );
        } else {
          LastMess = Text("....");

        }
        return LastMess;
      },);
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
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 25,
        backgroundImage:
            room.imageUrl != null ? NetworkImage(room.imageUrl) : null,
        child: room.imageUrl == null
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.black, fontSize: 10),
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
          backgroundColor: Color(0xff3B3940),
          floatingActionButton: _user == null
              ? null
              :FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return UsersPage();
                    }));
                  },
                  child: Icon(Icons.chat),
                ),
          appBar:_user == null
              ? null
              : AppBar(
                  brightness: Brightness.dark,
                  elevation: 1,
                  backgroundColor: Color(0xff3B3940),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showMenu(
                            context: context,
                            elevation: 10.0,
                            color: Color(0xff3B3940),
                            position: RelativeRect.fromLTRB(25.0, 85.0, 0.0, 0.0),
                            items: [ PopupMenuItem(
                              child: FlatButton(
                                height:1,
                                minWidth:10,
                                onPressed:(){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return SchedulePage();
                                      }));
                          },
                                child: Text("Schedule",
                                    style: TextStyle(
                                        color: Color(0xffEAEAEA))),
                              ),
                            ),
                              PopupMenuItem(
                                child: FlatButton(
                                  height:1,
                                  minWidth:10,
                                  onPressed:(){ Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return EditProfilePage();
                                      }));},
                                  child: Text("Profile",
                                      style: TextStyle(
                                          color: Color(0xffEAEAEA))),
                                ),
                              ),
                              PopupMenuItem(
                                    child: FlatButton(
                                      height:1,
                                      minWidth:10,
                                      onPressed:(){ _user == null ? null : logout;},
                                      child: Text("LogOut",
                                          style: TextStyle(
                                              color: Color(0xffEAEAEA))),
                                    ))
                            ],
                          );
                        },
                        icon: Icon(Icons.more_vert))
                  ],
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 20,left: 13),
                    child: Text(
                      'OTM',
                      style: TextStyle(
                          color: Color(0xffEAEAEA),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                ),
          body: _user == null
             ?_login()
              : StreamBuilder<List<types.Room>>(
                  stream: FirebaseChatCore.instance.rooms(),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          bottom: 200,
                        ),
                        child: const Text(
                          '               No chats yet \n Get started by messaging a friend',
                          style: TextStyle(color: Colors.white,fontSize: 20),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final room = snapshot.data[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {
                          //      print(room);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      room: room,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                room.name ?? 'User Name Not Available',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xffEAEAEA),
                                    fontWeight: FontWeight.w700),
                              ),
                              leading: _buildAvatar(room),
                              subtitle: _resentMessage(room),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
        ),

    );
  }
  Widget _login (){
    return  SplashScreen(
    seconds: 3,
    navigateAfterSeconds: LoginPage(),
    loadingText: Text("Get connected to friends with OTM",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),),
    title: Text("OTM",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 100),),
    // navigateAfterSeconds: new AfterSplash(),
    backgroundColor: Color(0xff3B3940),
    );
  }
}

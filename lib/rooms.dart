import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String lastName = '';
  String imageUrl = '';

  @override
  void initState() {
    initializeFlutterFire();
    _getdata();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
}

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
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

  Future<void> showNotifications() async {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doing ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
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
        child: room.imageUrl != null
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
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

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton:  _user == null
          ? null
          : FloatingActionButton(
          onPressed: () {
            showNotifications();
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
              IconButton(
                icon: const Icon(Icons.alarm),
                onPressed: _user == null
                    ? null
                    : () {
                  
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => SheduleScreen(),
                          ),
                        );
                      },
              ),

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundImage: NetworkImage(
                      imageUrl == null
                          ? "https://bethanychurch.org.uk/wp-content/uploads/2018/09/profile-icon-png-black-6.png"
                          : imageUrl,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            ],
            brightness: Brightness.dark,
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _user == null ? null : logout,
            ),
            centerTitle: true,
            title:  Text('OTM'),
          ),
        ),

        body: _user == null
            ? Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            bottom: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not authenticated'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>  LoginPage(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
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
                      child: const Text('No rooms'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final room = snapshot.data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                room: room,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              _buildAvatar(room),
                              Text(
                                room.name ?? 'User Name Not Available',style: TextStyle(color: Colors.white),

                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ),
    );
  }
}

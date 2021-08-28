// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
// class Meeting extends StatefulWidget {
//   @override
//   _MeetingState createState() => _MeetingState();
// }
//
// class _MeetingState extends State<Meeting> {
//   final serverText = TextEditingController();
//   final roomText = TextEditingController(text: "plugintestroom");
//   final subjectText = TextEditingController(text: "My Plugin Test Meeting");
//   final nameText = TextEditingController(text: "Plugin Test User");
//   final emailText = TextEditingController(text: "fake@email.com");
//   final iosAppBarRGBAColor =
//   TextEditingController(text: "#0080FF80"); //transparent blue
//   bool isAudioOnly = true;
//   bool isAudioMuted = true;
//   bool isVideoMuted = true;
//
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   final _auth = FirebaseAuth.instance;
//   String name;
//   String email;
//   String status;
//   String myId = '';
//   String myUsername = '';
//   String lastName = '';
//   String myUrlAvatar = '';
//   User user = FirebaseAuth.instance.currentUser;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   String profileImageUrl = "";
//   String imageUrl ="";
//   void _getdata() async {
//     User user = FirebaseAuth.instance.currentUser;
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .snapshots()
//         .listen((userData) {
//       setState(() {
//         lastName = userData.data()['lastName'];
//         myUsername = userData.data()['firstName'];
//         myUrlAvatar = userData.data()['imageUrl'];
//       });
//     });
//   }
//   void getCurrentUser() async {
//     setState(() {
//       try {
//         user = ( _auth.currentUser);
//         print(user);
//         // print(name);
//         // print(user!.uid);
//         // print(user!.providerData.toString());
//         // print(user!.refreshToken);
//       } catch (e) {}
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//     _getdata();
//     JitsiMeet.addListener(JitsiMeetingListener(
//         onConferenceWillJoin: _onConferenceWillJoin,
//         onConferenceJoined: _onConferenceJoined,
//         onConferenceTerminated: _onConferenceTerminated,
//         onError: _onError));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     JitsiMeet.removeAllListeners();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16.0,
//           ),
//           child: _joinMeeting(),
//           //     ? Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Container(
//           //       width: width * 0.30,
//           //      // child: meetConfig(),
//           //     ),
//           //     Container(
//           //         width: width * 0.60,
//           //         child: Padding(
//           //           padding: const EdgeInsets.all(8.0),
//           //           child: Card(
//           //               color: Colors.white54,
//           //               child: SizedBox(
//           //                 width: width * 0.60 * 0.70,
//           //                 height: width * 0.60 * 0.70,
//           //                 child: JitsiMeetConferencing(
//           //                   extraJS: [
//           //                     // extraJs setup example
//           //                     '<script>function echo(){console.log("echo!!!")};</script>',
//           //                     '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
//           //                   ],
//           //                 ),
//           //               )),
//           //         ))
//           //   ],
//           // )
//
//         ),
//       ),
//     );
//   }
//   //
//   // Widget meetConfig() {
//   //   return SingleChildScrollView(
//   //     child: Column(
//   //       children: <Widget>[
//   //         SizedBox(
//   //           height: 16.0,
//   //         ),
//   //         TextField(
//   //           controller: serverText,
//   //           decoration: InputDecoration(
//   //               border: OutlineInputBorder(),
//   //               labelText: "Server URL",
//   //               hintText: "Hint: Leave empty for meet.jitsi.si"),
//   //         ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         // TextField(
//   //         //   controller: roomText,
//   //         //   decoration: InputDecoration(
//   //         //     border: OutlineInputBorder(),
//   //         //     labelText: "Room",
//   //         //   ),
//   //         // ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         // TextField(
//   //         //   controller: subjectText,
//   //         //   decoration: InputDecoration(
//   //         //     border: OutlineInputBorder(),
//   //         //     labelText: "Subject",
//   //         //   ),
//   //         // ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         // TextField(
//   //         //   controller: nameText,
//   //         //   decoration: InputDecoration(
//   //         //     border: OutlineInputBorder(),
//   //         //     labelText: myUsername,
//   //         //   ),
//   //         // ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         // TextField(
//   //         //   controller: emailText,
//   //         //   decoration: InputDecoration(
//   //         //     border: OutlineInputBorder(),
//   //         //     labelText: "Email",
//   //         //   ),
//   //         // ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         // TextField(
//   //         //   controller: iosAppBarRGBAColor,
//   //         //   decoration: InputDecoration(
//   //         //       border: OutlineInputBorder(),
//   //         //       labelText: "AppBar Color(IOS only)",
//   //         //       hintText: "Hint: This HAS to be in HEX RGBA format"),
//   //         // ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         CheckboxListTile(
//   //           title: Text("Audio Only"),
//   //           value: isAudioOnly,
//   //           onChanged: _onAudioOnlyChanged,
//   //         ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         CheckboxListTile(
//   //           title: Text("Audio Muted"),
//   //           value: isAudioMuted,
//   //           onChanged: _onAudioMutedChanged,
//   //         ),
//   //         SizedBox(
//   //           height: 14.0,
//   //         ),
//   //         CheckboxListTile(
//   //           title: Text("Video Muted"),
//   //           value: isVideoMuted,
//   //           onChanged: _onVideoMutedChanged,
//   //         ),
//   //         Divider(
//   //           height: 48.0,
//   //           thickness: 2.0,
//   //         ),
//   //         SizedBox(
//   //           height: 64.0,
//   //           width: double.maxFinite,
//   //           child: ElevatedButton(
//   //             onPressed: () {
//   //               _joinMeeting();
//   //             },
//   //             child: Text(
//   //               "Join Meeting",
//   //               style: TextStyle(color: Colors.white),
//   //             ),
//   //             style: ButtonStyle(
//   //                 backgroundColor:
//   //                 MaterialStateColor.resolveWith((states) => Colors.blue)),
//   //           ),
//   //         ),
//   //         SizedBox(
//   //           height: 48.0,
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//   // _onAudioOnlyChanged(bool value) {
//   //   setState(() {
//   //     isAudioOnly = value;
//   //   });
//   // }
//   //
//   // _onAudioMutedChanged(bool value) {
//   //   setState(() {
//   //     isAudioMuted = value;
//   //   });
//   // }
//   //
//   // _onVideoMutedChanged(bool value) {
//   //   setState(() {
//   //     isVideoMuted = value;
//   //   });
//   // }
//
//   _joinMeeting() async {
//     String serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;
//
//     Map<FeatureFlagEnum, bool> featureFlags = {
//       FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//     };
//     if (!kIsWeb) {
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       } else if (Platform.isIOS) {
//         // Disable PIP on iOS as it looks weird
//         featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
//       }
//     }
//     // Define meetings options here
//     var options = JitsiMeetingOptions(room:myUsername)
//       ..serverURL = serverUrl
//       // ..subject = subjectText.text
//       ..userDisplayName =  myUsername
//        ..userEmail = user.email
//       ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
//       ..audioOnly = isAudioOnly
//       ..audioMuted = isAudioMuted
//       ..videoMuted = isVideoMuted
//       ..featureFlags.addAll(featureFlags)
//       ..webOptions = {
//         "roomName": myUsername,
//         "width": "100%",
//         "height": "100%",
//         "enableWelcomePage": false,
//         "chromeExtensionBanner": null,
//         "userInfo": {"displayName": myUsername}
//
//       };
//
//     debugPrint("JitsiMeetingOptions: $options");
//     await JitsiMeet.joinMeeting(
//       options,
//       listener: JitsiMeetingListener(
//           onConferenceWillJoin: (message) {
//             debugPrint("${options.room} will join with message: $message");
//           },
//           onConferenceJoined: (message) {
//             debugPrint("${options.room} joined with message: $message");
//           },
//           onConferenceTerminated: (message) {
//             debugPrint("${options.room} terminated with message: $message");
//           },
//           genericListeners: [
//             JitsiGenericListener(
//                 eventName: 'readyToClose',
//                 callback: (dynamic message) {
//                   debugPrint("readyToClose callback");
//                 }),
//           ]),
//     );
//   }
//
//   void _onConferenceWillJoin(message) {
//     debugPrint("_onConferenceWillJoin broadcasted with message: $message");
//   }
//
//   void _onConferenceJoined(message) {
//     debugPrint("_onConferenceJoined broadcasted with message: $message");
//   }
//
//   void _onConferenceTerminated(message) {
//     debugPrint("_onConferenceTerminated broadcasted with message: $message");
//   }
//
//   _onError(error) {
//     debugPrint("_onError broadcasted: $error");
//   }
// }
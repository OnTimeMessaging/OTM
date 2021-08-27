import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:ontimemessaging/Users.dart';
import 'package:ontimemessaging/db/screen.dart';
import 'package:ontimemessaging/main.dart';
import 'package:ontimemessaging/profile.dart';
import 'package:ontimemessaging/utils.dart';

import 'Login.dart';

import 'chat.dart';



class RoomsPage extends StatefulWidget {


  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
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
            print(room.imageUrl );
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20 ,
        backgroundImage: room.imageUrl != null ? NetworkImage(room.imageUrl):null,
        child:room.imageUrl != null
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UsersPage();
          }));
        },
        child: Icon(Icons.chat),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _user == null
                ? null
                : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _user == null
                ? null
                : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>  SheduleScreen(),
                ),
              );
            },
          ),
        ],
        brightness: Brightness.dark,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _user == null ? null : logout,
        ),
        title: const Text('OTM'),
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
                      builder: (context) =>
                          ChatPage(
                            room: room,
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(room),
                      Text(room.name ?? ''),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
// class CustomAnimatedBottomBar extends StatelessWidget {
//
//   CustomAnimatedBottomBar({
//     Key? key,
//     this.selectedIndex = 0,
//     this.showElevation = true,
//     this.iconSize = 24,
//     this.backgroundColor,
//     this.itemCornerRadius = 50,
//     this.containerHeight = 56,
//     this.animationDuration = const Duration(milliseconds: 270),
//     this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
//     required this.items,
//     required this.onItemSelected,
//     this.curve = Curves.linear,
//   }) : assert(items.length >= 2 && items.length <= 5),
//         super(key: key);
//
//   final int selectedIndex;
//   final double iconSize;
//   final Color? backgroundColor;
//   final bool showElevation;
//   final Duration animationDuration;
//   final List<BottomNavyBarItem> items;
//   final ValueChanged<int> onItemSelected;
//   final MainAxisAlignment mainAxisAlignment;
//   final double itemCornerRadius;
//   final double containerHeight;
//   final Curve curve;
//
//   @override
//   Widget build(BuildContext context) {
//     final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: bgColor,
//         boxShadow: [
//           if (showElevation)
//             const BoxShadow(
//               color: Colors.black12,
//               blurRadius: 2,
//             ),
//         ],
//       ),
//       child: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: containerHeight,
//           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//           child: Row(
//             mainAxisAlignment: mainAxisAlignment,
//             children: items.map((item) {
//               var index = items.indexOf(item);
//               return GestureDetector(
//                 onTap: () => onItemSelected(index),
//                 child: _ItemWidget(
//                   item: item,
//                   iconSize: iconSize,
//                   isSelected: index == selectedIndex,
//                   backgroundColor: bgColor,
//                   itemCornerRadius: itemCornerRadius,
//                   animationDuration: animationDuration,
//                   curve: curve,
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ItemWidget extends StatelessWidget {
//   final double iconSize;
//   final bool isSelected;
//   final BottomNavyBarItem item;
//   final Color backgroundColor;
//   final double itemCornerRadius;
//   final Duration animationDuration;
//   final Curve curve;
//
//   const _ItemWidget({
//     Key? key,
//     required this.item,
//     required this.isSelected,
//     required this.backgroundColor,
//     required this.animationDuration,
//     required this.itemCornerRadius,
//     required this.iconSize,
//     this.curve = Curves.linear,
//   })  : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       container: true,
//       selected: isSelected,
//       child: AnimatedContainer(
//         width: isSelected ? 130 : 50,
//         height: double.maxFinite,
//         duration: animationDuration,
//         curve: curve,
//         decoration: BoxDecoration(
//           color:
//           isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
//           borderRadius: BorderRadius.circular(itemCornerRadius),
//         ),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: NeverScrollableScrollPhysics(),
//           child: Container(
//             width: isSelected ? 130 : 50,
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 IconTheme(
//                   data: IconThemeData(
//                     size: iconSize,
//                     color: isSelected
//                         ? item.activeColor.withOpacity(1)
//                         : item.inactiveColor == null
//                         ? item.activeColor
//                         : item.inactiveColor,
//                   ),
//                   child: item.icon,
//                 ),
//                 if (isSelected)
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 4),
//                       child: DefaultTextStyle.merge(
//                         style: TextStyle(
//                           color: item.activeColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         textAlign: item.textAlign,
//                         child: item.title,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class BottomNavyBarItem {
//
//   BottomNavyBarItem({
//     required this.icon,
//     required this.title,
//     this.activeColor = Colors.blue,
//     this.textAlign,
//     this.inactiveColor,
//   });
//
//   final Widget icon;
//   final Widget title;
//   final Color activeColor;
//   final Color? inactiveColor;
//   final TextAlign? textAlign;
//
// }

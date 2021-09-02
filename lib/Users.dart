
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:ontimemessaging/utils.dart';

import 'chat.dart';

class UsersPage extends StatelessWidget {

  bool _userLoading = false;
  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl) : null,
        radius: 25,
        child: !hasImage
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
    return Scaffold(
      backgroundColor: Color(0xff3B3940),
      appBar: AppBar(
        backgroundColor: Color(0xff3B3940),
        brightness: Brightness.dark,
        title: const Text('Users'),
      ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users',style: TextStyle(color: Colors.white),),
            );
          }
          // _handlePressed(user, context);
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final user = snapshot.data[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: (){
                    _handlePressed(user, context);
                  },
                  leading:  _buildAvatar(user),
                  title: Text(getUserName(user),style: TextStyle(fontSize:20,color:Color(0xffEAEAEA),fontWeight: FontWeight.w700),)
                ),
              );
            },
          );
        },
      ),
    );
  }}
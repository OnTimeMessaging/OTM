

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ontimemessaging/db/lib/blocs/SettingsBloc.dart';
import 'package:ontimemessaging/db/lib/models/Settings.dart';
import 'package:ontimemessaging/db/lib/providers/DialogProvider.dart';
import 'package:ontimemessaging/db/lib/providers/SettingsProvider.dart';
import 'package:sms/sms.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final _settingsBloc = SettingsBloc();
  List<SimCard> _simcards;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    super.dispose();
    _settingsBloc.dispose();
  }

  void _loadSettings() async {

    _settingsBloc.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Settings>(
        initialData: null,
        stream: _settingsBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<Settings> snapshot) {
          final Settings settings = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                title: Text('Settings'),
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                actions: <Widget>[
                  // PopupMenuButton<PopUpMenuValues>(
                  //   tooltip: '',
                  //   onSelected: (PopUpMenuValues value) {
                  //     DialogProvider.showConfirmation(
                  //         context: context,
                  //         title: Icon(Icons.restore),
                  //         content: Text('Really set settings to default?'),
                  //         onYes: () => _settingsBloc.updateSettings(
                  //             SettingsProvider.getDefaultSettings()));
                  //   },
                  //   itemBuilder: (BuildContext context) =>
                  //       <PopupMenuEntry<PopUpMenuValues>>[
                  //     const PopupMenuItem<PopUpMenuValues>(
                  //       value: PopUpMenuValues.defaultSettings,
                  //       child: ListTile(
                  //           leading: Icon(Icons.restore),
                  //           title: Text('Set to default settings')),
                  //     ),
                  //   ],
                  // )
                ],
              ),
              body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: snapshot.hasData
                      ? ListView(
                          children: <Widget>[
                            _notificationSettings(settings),
                            _messageSettings(settings),

                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        )));
        });
  }

  void _updateSettings(Settings settings) {
    _settingsBloc.updateSettings(settings);
  }

  Widget _settingsGroup(String title, final List<Widget> children) {
    final List<Widget> _children = [
      Text(title, style: TextStyle(fontSize: 25.0))
    ];

    return Card(
      child: Column(children: _children..addAll(children)),
    );
  }

  Widget _messageSettings(Settings settings) {
    return _settingsGroup('Messages', [
      ListTile(
          title: Text('Max Attempts'),
          subtitle: Text(
              'The maximum number of attempts a message should try to be sent when it keeps failing.'),
          trailing: DropdownButton<int>(
            value: settings.message.maxAttempts,
            items: <int>[
              null,
              1,
              2,
              3,
              4,
              5,
            ]
                .map((int value) => DropdownMenuItem<int>(
                    value: value,
                    child:
                        Text(value == null ? 'Unlimited' : value.toString())))
                ?.toList(),
            onChanged: (int value) {
              settings.message.maxAttempts = value;
              _settingsBloc.updateSettings(settings);
            },
          ))
    ]);
  }

  Widget _notificationSettings(Settings settings) =>
      _settingsGroup('Notifications', [
        ListTile(
          title: Text('Enable Notifications'),
          subtitle: Text('App wide notifications.'),
          trailing: CupertinoSwitch(
              activeColor: Colors.blueGrey,
              value: settings.system.shouldShowNotifications,
              onChanged: (bool value) {
                settings.system.shouldShowNotifications = value;
                _updateSettings(settings);
              }),
        ),
        ListTile(
          title: Text('Success Notifications'),
          subtitle: Text('Message sending successful notifications.'),
          enabled: settings.system.shouldShowNotifications,
          trailing: CupertinoSwitch(
              activeColor: settings.system.shouldShowNotifications
                  ? Colors.blueGrey
                  : Colors.grey,
              value: settings.system.shouldShowMessageSentNotifications,
              dragStartBehavior: DragStartBehavior.start,
              onChanged: !settings.system.shouldShowNotifications
                  ? null
                  : (bool value) {
                      settings.system.shouldShowMessageSentNotifications =
                          value;
                      _updateSettings(settings);
                    }),
        ),
        ListTile(
          title: Text('Failed Notifications'),
          subtitle: Text('Message sending failed notifications.'),
          enabled: settings.system.shouldShowNotifications,
          trailing: CupertinoSwitch(
              activeColor: settings.system.shouldShowNotifications
                  ? Colors.blueGrey
                  : Colors.grey,
              value: settings.system.shouldShowMessageFailedNotifications,
              dragStartBehavior: DragStartBehavior.start,
              onChanged: !settings.system.shouldShowNotifications
                  ? null
                  : (bool value) {
                      settings.system.shouldShowMessageFailedNotifications =
                          value;
                      _updateSettings(settings);
                    }),
        ),
      ]); // end function
} // end of class

enum PopUpMenuValues {
  defaultSettings,
}

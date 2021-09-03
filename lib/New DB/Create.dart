import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ontimemessaging/New%20DB/datetime.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../SizeConfig.dart';
import 'Dialog.dart';
import 'MessageBloc.dart';
import 'MessageClass.dart';

enum MessageMode { create, edit }

class CreateOrEditSmsMessagePage extends StatefulWidget {
  final MessageMode messageMode;
  final Messageclass message;

  /// Constructs the message mode.
  /// If [messageMode] == [MessageMode.edit] then [message] should be set.
  const CreateOrEditSmsMessagePage(this.messageMode, [this.message]);

  @override
  _CreateOrEditSmsMessagePageState createState() =>
      _CreateOrEditSmsMessagePageState();
}

class _CreateOrEditSmsMessagePageState
    extends State<CreateOrEditSmsMessagePage> {

  final _messagesAdd = MessageAdd();
  DateTime _date;
  TimeOfDay _time;
final _author =TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();


  static const platform = const MethodChannel('samples.flutter.dev/battery');
  MessageDriver _driverCtrl = MessageDriver.SCHEDULE;
  SharedPreferences prefs;

  void openAccessibilitySettings() async {}

  String _dateError;
  String _timeError;
  String _messageError;
   String _authorError;

  void getLocalPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    // openAccessibilitySettings();

    getLocalPreferences();

    if (widget.messageMode == MessageMode.edit) {
      _dateCtrl.text = DateTimeFormator.formatDate(
          DateTime.fromMillisecondsSinceEpoch(widget.message.executedAt));
      _timeCtrl.text = DateTimeFormator.formatTime(TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(widget.message.executedAt)));
      _messageCtrl.text = widget.message.content;
      _author.text = widget.message.subject;
      _date = DateTime.fromMillisecondsSinceEpoch(widget.message.executedAt);
      _time = TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(widget.message.executedAt));
    } else {
      _author.text = '';
      _dateCtrl.text = '';
      _timeCtrl.text = '';
      _messageCtrl.text = '';
    }
_author.addListener(_validate);
    _messageCtrl.addListener(_validate);
    _dateCtrl.addListener(_validate);
    _timeCtrl.addListener(_validate);

    _validate();
  }


  @override
  void dispose() {
    super.dispose();
    _messagesAdd.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.messageMode == MessageMode.edit ? 'Edit' : 'Create New') +
              ' Message',
          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _author,
                maxLines: null,
                // maxLength: _settings.sms.maxSmsCount * SmsSettings.maxSmsLength,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  // errorText: _messageError,
                    labelStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5),
                    labelText: 'Message',
                    icon: Icon(Icons.person)),
              ),
              // TextFormField(
              //   controller: _dateCtrl,
              //   inputFormatters: [
              //     BlacklistingTextInputFormatter(
              //         RegExp(r".*")) // don't allow any input
              //   ],
              //   keyboardType: TextInputType.datetime,
              //   decoration: InputDecoration(
              //       labelText: 'Date',
              //       labelStyle: TextStyle(
              //           fontSize: SizeConfig.safeBlockHorizontal * 3.5),
              //       errorText: _dateError,
              //       icon: Icon(Icons.calendar_today),
              //       suffixIcon: GestureDetector(
              //         child: Icon(Icons.more_horiz),
              //         onTap: () async {
              //           final DateTime date = await showDatePicker(
              //               context: context,
              //               firstDate: DateTime.now(),
              //               lastDate:
              //                   DateTime.now().add(Duration(days: 30 * 12 * 2)),
              //               initialDate: DateTime.now());
              //           _date = date;
              //           setState(() {
              //             _dateCtrl.text = DateTimeFormator.formatDate(date);
              //           });
              //         },
              //       )),
              // ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: GestureDetector(
                  onTap: () async {
                    final DateTime date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate:
                        DateTime.now().add(Duration(days: 30 * 12 * 2)),
                        initialDate: DateTime.now());
                    _date = date;
                    setState(() {
                      _dateCtrl.text = DateTimeFormator.formatDate(date);
                    });
                    print(_dateCtrl.text);
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _dateCtrl.text != ''
                            ? Text(
                          _dateCtrl.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 4),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: SizeConfig.safeBlockHorizontal * 4,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Select Date",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                  SizeConfig.safeBlockHorizontal * 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: GestureDetector(
                  onTap: () async {
                    final TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            DateTime.now().add(Duration(minutes: 2))));
                    _time = time;
                    setState(() {
                      _timeCtrl.text = _time.format(context);
                    });
                    print(_timeCtrl.text.toString());
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _timeCtrl.text != ''
                            ? Text(
                          _timeCtrl.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 4),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: SizeConfig.safeBlockHorizontal * 4,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Select Time",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                  SizeConfig.safeBlockHorizontal * 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                  ),
                ),
              ),
              TextFormField(
                controller: _messageCtrl,
                maxLines: null,
                // maxLength: _settings.sms.maxSmsCount * SmsSettings.maxSmsLength,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  // errorText: _messageError,
                    labelStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5),
                    labelText: 'Message',
                    icon: Icon(Icons.textsms)),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.file, color: Colors.grey),
                  tooltip: 'Attachment',
                  onPressed: () {
                 //   pickAttachment();
                  },
                ),
              ])
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            widget.messageMode == MessageMode.create
                ? Icons.create
                : Icons.edit,
            color: Colors.white),
        onPressed: !_validate()
            ? null
            : () => widget.messageMode == MessageMode.edit
            ? _onEditMessage()
            : _onCreateMessage(),
        backgroundColor: _validate() ? Colors.blueGrey : Colors.grey,
      ),
    );
  }


  bool _validate() {
    bool status = true;
    _authorError = null;
    _messageError = null;
    _dateError = null;
    _timeError = null;
    if (_messageCtrl.text.trim().isEmpty) {
      status = false;
      _messageError = 'Enter a message.';
    }

    if (_dateCtrl.text.isEmpty) {
      status = false;
      _dateError = 'Select a date.';
    }

    if (_timeCtrl.text.isEmpty) {
      status = false;
      _timeError = 'Select a time.';
    }
    if (_author.text.trim().isEmpty) {
      status = false;
      _authorError = 'Wrong User.';
    }
    return status;
  }

  /// Creates a message based on the form (user input).
  Messageclass _getFinalMessage() => _driverCtrl == MessageDriver.SCHEDULE
      ? Messageclass(
      id: widget?.message?.id,
      content: _messageCtrl.text,
      subject: _author.text,
      createdAt: widget?.message?.createdAt ??
          DateTime.now().millisecondsSinceEpoch,
      attempts: widget?.message?.attempts ?? 0,
      status: widget?.message?.status ?? MessageStatus.PENDING,
      isArchived: widget?.message?.isArchived ?? false,
      executedAt: DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute)
          .millisecondsSinceEpoch)
      : Messageclass(
      id: widget?.message?.id,
      content: _messageCtrl.text,
      subject: _author.text,
      createdAt: widget?.message?.createdAt ??
          DateTime.now().millisecondsSinceEpoch,
      attempts: widget?.message?.attempts ?? 0,
      status: widget?.message?.status ?? MessageStatus.PENDING,
      isArchived: widget?.message?.isArchived ?? false,
      executedAt: DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute)
          .millisecondsSinceEpoch);

  void _onEditMessage() async {
    if (await _messagesAdd.updateMessage(_getFinalMessage())) {
      Navigator.pop(context);
    } else {
      await DialogProvider.showMessage(
          context: context,
          title: Icon(Icons.error),
          content: Text('Error updating message.'));
    }
  }

  void _onCreateMessage() async {
print(_onCreateMessage);
    // FilePickerResult result = await FilePicker.platform.pickFiles();
    if (await _messagesAdd.addMessage(_getFinalMessage())) {
      Navigator.pop(context);
    } else {
      await DialogProvider.showMessage(
          context: context,
          title: Icon(Icons.error),
          content: Text('Error creating message.'));
    }
  }
}

// class RemindersPage extends StatefulWidget {
//   @override
//   _RemindersPageState createState() => _RemindersPageState();
// }
//
// class _RemindersPageState extends State<RemindersPage> {
//   final _gmailMailId = TextEditingController();
//   final _gmailMailPassword = TextEditingController();
//   String _currentSelectedValue = 'Gmail';
//   var _currencies = ['Gmail', 'Yahoo', 'Hotmail'];
//   void _loadEmails() async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // if (prefs.containsKey('mailid')) {
//     //   _gmailMailId.text = prefs.getString('mailid');
//     //   _gmailMailPassword.text = prefs.getString('mailpassword');
//     // }
//   }
//
//   @override
//   void initState() {
//     _loadEmails();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new AlertDialog(
//       title: new Text('Add Mail ID'),
//       content: Column(
//         children: <Widget>[
//           DropdownButton<String>(
//             value: _currentSelectedValue,
//             onChanged: (String newValue) {
//               setState(() {
//                 _currentSelectedValue = newValue;
//               });
//             },
//             items: _currencies.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//           TextField(
//             controller: _gmailMailId,
//             decoration: InputDecoration(
//                 icon: Icon(Icons.account_circle),
//                 labelText: 'Email ID',
//                 labelStyle:
//                 TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3)),
//           ),
//           TextField(
//             obscureText: true,
//             controller: _gmailMailPassword,
//             decoration: InputDecoration(
//               icon: Icon(Icons.lock),
//               labelText: 'Password',
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         RaisedButton(
//             child: Text("Submit"),
//             onPressed: () async {
//               print(_gmailMailId.text);
//               print(_gmailMailPassword.text);
//               // SharedPreferences prefs = await SharedPreferences.getInstance();
//               // prefs.setString('mailid', _gmailMailId.text);
//               // prefs.setString('mailpassword', _gmailMailPassword.text);
//               setState(() {
//                 _gmailMailId.text = _gmailMailId.text;
//                 _gmailMailPassword.text = _gmailMailPassword.text;
//               });
//               // _gmailMailId.text = '';
//               // _gmailMailPassword.text = '';
//               Navigator.pop(context);
//             })
//       ],
//     );
//     throw UnimplementedError();
//   }
// }

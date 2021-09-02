// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:intl/intl.dart';
// import 'package:ontimemessaging/db/MessageProvider.dart';
//
// import 'package:ontimemessaging/db/screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Messagdata.dart';
// import 'Message.dart';
//
// class TodoScreen extends StatefulWidget {
//   final Todo todo;
//
//   const TodoScreen({Key key, this.todo});
//
//   @override
//   _TodoScreenState createState() => _TodoScreenState();
// }
//
// class _TodoScreenState extends State<TodoScreen> {
//   var _todoTitleController = TextEditingController();
//
//   var _todoDescriptionController = TextEditingController();
//   final _textController = TextEditingController();
//   var _todoDateController = TextEditingController();
//   var _todoTimeController = TextEditingController();
//   var _attachment = TextEditingController();
//
//   var _selectedValue;
//
//   File _image;
//   final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   DateTime _dateTime = DateTime.now();
//
//   final _messagesBloc = Repository();
//
//   _selectedTodoDate(BuildContext context) async {
//     var _pickedDate = await showDatePicker(
//         context: context,
//         initialDate: _dateTime,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100));
//
//     if (_pickedDate != null) {
//       setState(() {
//         _dateTime = _pickedDate;
//         _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
//       });
//     }
//   }
//
//   TimeOfDay _time = TimeOfDay.now();
//
//   _selectTime(BuildContext context) async {
//     var _pickTime = await showTimePicker(context: context, initialTime: _time);
//     if (_pickTime != null) {
//       setState(() {
//         _time = _pickTime;
//         _todoTimeController.text = _pickTime.format(context);
//       });
//     }
//   }
//
//   SharedPreferences prefs;
//
//   void getLocalPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//
//
//
//   // MessageDriver _driverCtrl = MessageDriver.Schedule;
//   //
//   // Todo _getFinalMessage() => _driverCtrl == MessageDriver.Schedule
//   //     ? Todo(
//   //         id: widget?.todo?.id,
//   //         createdAt:
//   //             widget?.todo?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
//   //         status: widget?.todo?.status ?? MessageStatus.PENDING,
//   //         executedAt: DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
//   //                 _time.hour, _time.minute)
//   //             .millisecondsSinceEpoch)
//   //     : Todo(
//   //         id: widget?.todo?.id,
//   //         message: widget?.todo?.message,
//   //        udi:widget?.todo?.udi,
//   //
//   //          createdAt:
//   //             widget?.todo?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
//   //         status: widget?.todo?.status ?? MessageStatus.PENDING,
//   //         executedAt: DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
//   //                 _time.hour, _time.minute)
//   //             .millisecondsSinceEpoch);
//
//   final picker = ImagePicker();
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }
//
//   _showSuccessSnackBar(message) {
//     var _snackBar = SnackBar(content: message);
//     _globalKey.currentState.showSnackBar(_snackBar);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _globalKey,
//       appBar: AppBar(
//         title: Text('Schedule Message'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _todoDescriptionController,
//               decoration: InputDecoration(
//                 labelText: 'User',
//               ),
//             ),
//             TextField(
//               controller: _todoTitleController,
//               decoration: InputDecoration(
//                 labelText: 'Message',
//               ),
//             ),
//             TextField(
//               controller: _todoDateController,
//               decoration: InputDecoration(
//                 labelText: 'Date',
//                 hintText: 'Pick a Date',
//                 prefixIcon: InkWell(
//                   onTap: () {
//                     _selectedTodoDate(context);
//                   },
//                   child: Icon(Icons.calendar_today),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: _todoTimeController,
//               decoration: InputDecoration(
//                 labelText: 'Time',
//                 hintText: 'Pick a Time',
//                 prefixIcon: InkWell(
//                   onTap: () {
//                     _selectTime(context);
//                   },
//                   child: Icon(Icons.alarm),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             (_image != null)
//                 ? Container(
//                     height: 100,
//                     width: double.infinity,
//                     child: Image.file(_image))
//                 : SizedBox(),
//             Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//               IconButton(
//                 icon: Icon(FontAwesomeIcons.file, color: Colors.grey),
//                 tooltip: 'Attachment',
//                 onPressed: () {
//                   getImage();
//                 },
//               ),
//               Text(
//                   '${_attachment.text == '' ? 'No attachment added' : 'Attachment added'}'),
//             ]),
//             RaisedButton(
//               onPressed: () async {
//                 var todoObject = Todo();
//                 todoObject.message = _todoTitleController.text;
//                 todoObject.udi = _todoDescriptionController.text;
//                 todoObject.isFinished = 0;
//                 todoObject.todoDate = _todoDateController.text;
//                 todoObject.time = _todoTimeController.text;
//                 var _todoService = TodoService();
//                 var result = await _todoService.saveTodo(todoObject);
//                 if (result > 0) {
//                   _showSuccessSnackBar(Text('Created'));
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => SheduleScreen()));
//                 }
//                 print(result);
//                 print(todoObject.message);
//               },
//               color: Colors.blue,
//               child: Text(
//                 'Save',
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

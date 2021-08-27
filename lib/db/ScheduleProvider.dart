//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:is_lock_screen/is_lock_screen.dart';
// import 'package:ontimemessaging/db/Messagdata.dart';
// import 'package:ontimemessaging/db/SheduleMessages.dart';
//
// import 'lib/models/Message.dart';
//
//
// ///
// class ScheduleProvider {
//   Timer _timer;
//   final StreamController<Todo> _ctrlMsg = StreamController();
//   final StreamController<Todo> _ctrlNotification = StreamController();
//   final StreamController<List<Todo>> _ctrlMsgs = StreamController();
//   StreamSubscription _subMsg;
//   StreamSubscription _subMsgNotification;
//   StreamSubscription _subMsgs;
//
//   static const platform = const MethodChannel('samples.flutter.dev/battery');
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   /// Constructs a sheduler using the given [onMessageProcessed] and [onScheduleProcessed] listeners.
//   ScheduleProvider(
//       {dynamic Function(Todo) onMessageProcessed,
//         dynamic Function(Todo) onNotificationTriggered,
//         dynamic Function(List<Todo>) onScheduleProcessed}) {
//     print('lodu');
//     print(onMessageProcessed);
//     print(onNotificationTriggered);
//     print(onScheduleProcessed);
//
//     if (onMessageProcessed != null)
//       this.onMessageProcessed = onMessageProcessed;
//     if (onScheduleProcessed != null)
//       this.onScheduleProcessed = onScheduleProcessed;
//   }
//
//   /// Starts executing the schedule periodically according to the given [duration].
//   void start(Duration duration) {
//     stop();
//     _subMsg?.resume();
//     _subMsgNotification?.resume();
//     _subMsgs?.resume();
//     _timer = Timer.periodic(duration, (Timer t) => this._processSchedule());
//   }
//
//   /// Stops executing the schedule perdiodically, and stops calling any listeners/callbacks attached.
//   /// Note that the listeners attached aren't removed, they just aren't called until start is called again.
//   void stop() {
//     _timer?.cancel();
//     _subMsg?.pause();
//     _subMsgNotification?.pause();
//     _subMsgs?.pause();
//   }
//
//   /// Sets the callback to be invoked whenever a single message has been processed.
//   set onMessageProcessed(Function(Todo) onData) {
//     assert(onData != null);
//
//     _subMsg?.cancel();
//     _subMsg = _ctrlMsg.stream.listen((Todo todo) => onData(todo));
//   }
//
//   /// Sets the callback to be invoked whenever a single message has been processed.
//   set onNotificationTriggered(Function( Todo) onData) {
//     assert(onData != null);
//
//     _subMsgNotification?.cancel();
//     _subMsgNotification =
//         _ctrlNotification.stream.listen((Todo todo) => onData(todo));
//   }
//
//   /// Sets the callback to be invoked whenever the entire schedule has been processed.
//   set onScheduleProcessed(Function(List<Todo>) onDone) {
//     assert(onDone != null);
//
//     _subMsgs?.cancel();
//     _subMsgs =
//         _ctrlMsgs.stream.listen((List<Todo> todo) => onDone(todo));
//   }
//
//   /// Frees the resources allocated with this object. Making the object un-usable.
//   void dispose() {
//     _timer.cancel();
//     _subMsg?.cancel();
//     _subMsgNotification?.cancel();
//     _subMsgs?.cancel();
//     _ctrlMsg.close();
//     _ctrlNotification.close();
//     _ctrlMsgs.close();
//   }
//
//
//   void _processSms() async {
//     var todoObject = Todo();
//   }
//
//
//   void _processSchedule() async {
//
//   }
// }

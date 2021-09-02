//
// import 'dart:async';
//
// import 'package:flutter/services.dart';
// import 'package:is_lock_screen/is_lock_screen.dart';
// import 'package:ontimemessaging/db/Messagdata.dart';
// import 'package:ontimemessaging/db/Message.dart';
//
// import 'ScheduleMessage.dart';
//
// class ScheduleProvider {
//   Timer _timer;
//   final StreamController<Todo> _ctrlMsg = StreamController();
//
//   final StreamController<List<Todo>> _ctrlMsgs = StreamController();
//   StreamSubscription _subMsg;
//
//   StreamSubscription _subMsgs;
//
//   static const platform = const MethodChannel('samples.flutter.dev/battery');
//
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
//   void start(Duration duration,table, itemId) {
//     stop();
//     _timer = Timer.periodic(duration, (Timer t) => this._processSchedule(table, itemId));
//   }
//
//   /// Stops executing the schedule perdiodically, and stops calling any listeners/callbacks attached.
//   /// Note that the listeners attached aren't removed, they just aren't called until start is called again.
//   void stop() {
//     _timer?.cancel();
//     _subMsg?.pause();
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
//
//     _subMsgs?.cancel();
//     _ctrlMsg.close();
//     _ctrlMsgs.close();
//   }
//
//
//   void _processSchedule(table, itemId) async {
//     final todo = await Repository().readDataById(table, itemId);
//     bool isLocked = await isLockScreen();
//
//     todo
//         .takeWhile((Todo todo) =>
//     (todo.status == MessageStatus.PENDING ||
//         (todo.status == MessageStatus.FAILED &&
//             DateTime.now().millisecondsSinceEpoch >= todo.isFinished)
//
//     ));
//   }
// }


class Todo {
  int id;
  String message;
  String udi;
  String todoDate;
  String time;
  String image;
  int isFinished;
  MessageStatus status;


  todoMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['message'] = message;
    mapping['udi'] = udi;
    mapping['todoDate'] = todoDate;
    mapping['time'] = time;
    mapping['isFinished'] = isFinished;
    mapping['status'] = status;
    // status = MessageStatus.values[
    // data['status'] /* assuming


    return mapping;
  }
}
enum MessageStatus { PENDING, SENT, FAILED }
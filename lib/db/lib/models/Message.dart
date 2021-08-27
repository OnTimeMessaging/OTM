/// The Message model.
/// Represents a message.
class Message {

  int id;


  String endpoint;

  String subject;


  /// When the message was created.
  int createdAt;

  /// The time the message is set for.
  int executedAt;
  MessageDriver driver = MessageDriver.Schedule;
  /// The status of the message.
  MessageStatus status;

  /// The number of times the message was attempted to be sent.
  int attempts;

  /// Whether the message was archived or not.
  bool isArchived;

  /// Default constructor.
  Message(
      {this.id,
      this.attempts,
      this.isArchived,
      this.subject,
      this.createdAt,
      this.executedAt,
        this.driver,
      this.endpoint,
      this.status});

  /// Constructs this object from a json object.
  Message.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    attempts = data['attempts'];
    isArchived = data['isArchived'] != 0;
    subject = data['subject'];
    createdAt = data['createdAt'];
    executedAt = data['executedAt'];
    driver = MessageDriver.values[
    data['driver']];
    endpoint = data['endpoint'];
    status = MessageStatus.values[
        data['status'] /* assuming data['status'] stored an int index */];
  }

  /// Gets the json representation of this object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attempts': attempts,
      'isArchived': isArchived ? 1 : 0,
      'subject': subject,
      'createdAt': createdAt,
      'executedAt': executedAt,
      'endpoint': endpoint,
      'status': status.index,
    };
  }

  /// Gets the object at specified key.
  /// This doesn't return the object reference. Instead it returns a clone.
  dynamic operator [](String key) => toJson()[key];

  /* @override
  bool operator==(Object other) {
   
  } */

  /* void operator[]=(String key, dynamic value) {
    this[key] = value;
  } */
}

/// The status of the message (mutually exclusive).

enum MessageStatus { PENDING, SENT, FAILED }

enum MessageDriver { Schedule }

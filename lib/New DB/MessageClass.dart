
class Messageclass {
  int id;
  String subject;
  int createdAt;
  int executedAt;
  MessageStatus status;
  int attempts;
  bool isArchived;
  String content;

  /// Default constructor.
  Messageclass(
      {this.id,
        this.attempts,
        this.isArchived,
        this.subject,
        this.createdAt,
        this.executedAt,
        this.content,
        this.status});

  /// Constructs this object from a json object.
  Messageclass.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    attempts = data['attempts'];
    isArchived = data['isArchived'] != 0;
    content = data['content'];
    subject = data['subject'];
    createdAt = data['createdAt'];
    executedAt = data['executedAt'];
    status = MessageStatus.values[
    data['status'] /* assuming data['status'] stored an int index */];
  }

  /// Gets the json representation of this object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attempts': attempts,
      'isArchived': isArchived ? 1 : 0,
      'content': content,
      'subject': subject,
      'createdAt': createdAt,
      'executedAt': executedAt,
      'status': status.index,
    };
  }

  /// Gets the object at specified key.
  /// This doesn't return the object reference. Instead it returns a clone.
  dynamic operator [](String key) => toJson()[key];
}

/// The status of the message (mutually exclusive).
enum MessageStatus { PENDING, SENT, FAILED }

enum MessageDriver { SCHEDULE}
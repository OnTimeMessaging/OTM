

/// Message Settings.
class MessageSettings {
  /// The maximum number of attempts a message can have
  /// (null means unlimited).
  static const int maxMessageAttempts = null;

  /// The maximum number of attempts a message can be tried to be sent if it keeps failing.
  int maxAttempts;
}


/// System Settings.
class SystemSettings{
  bool shouldShowNotifications;
  bool shouldShowMessageSentNotifications;
  bool shouldShowMessageFailedNotifications;
  bool shouldAutoCheckUpdates;
}

/// Settings as a whole.
class Settings{
  /// The current settings version number.
  static const int revision = 0x00000002;

  int version = revision;

  SystemSettings system = SystemSettings();
  MessageSettings message = MessageSettings();



  Settings();

  Settings.fromJson(Map<String, dynamic> data) {
    version = data['version'];

    message.maxAttempts = data['message_maxAttempts'];

    system.shouldAutoCheckUpdates = data['system_shouldAutoCheckUpdates'];
    system.shouldShowNotifications = data['system_shouldShowNotifications'];
    system.shouldShowMessageSentNotifications =
    data['system_shouldShowMessageSentNotifications'];
    system.shouldShowMessageFailedNotifications =
    data['system_shouldShowMessageFailedNotifications'];

    Map<String, dynamic> toJson() {
      return {
        'version': version,

        'message_maxAttempts': message.maxAttempts,

        'system_shouldAutoCheckUpdates': system.shouldAutoCheckUpdates,
        'system_shouldShowNotifications': system.shouldShowNotifications,
        'system_shouldShowMessageSentNotifications': system
            .shouldShowMessageSentNotifications,
        'system_shouldShowMessageFailedNotifications': system
            .shouldShowMessageFailedNotifications,

      };}}}
import 'dart:convert';

ProfileChatRes profileChatResFromJson(String str) =>
    ProfileChatRes.fromJson(json.decode(str));

class ProfileChatRes {
  bool? success;
  String? sessionId;
  String? reply;
  Map<String, dynamic>? profile;
  String? nextField;
  bool? completed;

  ProfileChatRes({
    this.success,
    this.sessionId,
    this.reply,
    this.profile,
    this.nextField,
    this.completed,
  });

  ProfileChatRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sessionId = json['sessionId'];
    reply = json['reply'];
    profile = json['profile'] is Map<String, dynamic>
        ? json['profile'] as Map<String, dynamic>
        : null;
    nextField = json['nextField'];
    // Some backends send `completed`/`isCompleted` once the whole
    // profile has been collected (no more `nextField`).
    completed = json['completed'] ?? json['isCompleted'] ?? (nextField == null);
  }
}


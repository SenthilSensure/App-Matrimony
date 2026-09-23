import 'package:app_matrimony/base/base_provider.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/app_messages.dart';

/// A single bubble in the chat UI.
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class ProfileChatProvider extends BaseProvider {
  final TextEditingController messageCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  final List<ChatMessage> messages = [];

  String sessionId = '';
  Map<String, dynamic> profile = {};
  String? nextField;
  bool isSending = false;
  bool isCompleted = false;
  bool _initialized = false;

  bool get canSend => messageCtrl.text.trim().isNotEmpty && !isSending;

  /// Starts (or resumes) a profile-completion chat session.
  /// [sessionId] should stay stable for a user (e.g. mobile number / user id)
  /// so the backend can resume the same conversation.
  void init(String sessionId) {
    if (_initialized) return;
    _initialized = true;
    this.sessionId = sessionId;

    messages.add(
      ChatMessage(
        text: "Hi! Let's complete your profile. Tell me a bit about "
            "yourself \u2014 name, hometown and occupation to get started.",
        isUser: false,
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessage() async {
    final String text = messageCtrl.text.trim();
    if (text.isEmpty || isSending) return;

    messages.add(ChatMessage(text: text, isUser: true));
    messageCtrl.clear();
    isSending = true;
    notifyListeners();
    _scrollToBottom();

    final input = {
      'sessionId': sessionId,
      'message': text,
    };

    final result = await authRepo.profileChat(input);

    result.fold(
      (failure) {
        messages.add(
          ChatMessage(
            text: failure.toString(),
            isUser: false,
            isError: true,
          ),
        );
      },
      (success) {
        if (success.profile != null) {
          profile = {...profile, ...success.profile!};
        }
        nextField = success.nextField;
        isCompleted = success.completed ?? false;

        messages.add(
          ChatMessage(
            text: success.reply ?? '',
            isUser: false,
          ),
        );

        if (isCompleted) {
          successToast('Profile completed successfully');
        }
      },
    );

    isSending = false;
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollCtrl.hasClients) return;
      scrollCtrl.animateTo(
        scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    messageCtrl.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }
}


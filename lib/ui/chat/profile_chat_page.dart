import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/base_page.dart';
import '../../provider/chat/profile_chat_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_style.dart';

class ProfileChatPage extends BasePage {
  static const id = 'ProfileChatPage';

  const ProfileChatPage({super.key});

  @override
  State<ProfileChatPage> createState() => _ProfileChatPageState();
}

class _ProfileChatPageState extends BaseState<ProfileChatPage> with BasicPage {
  late ProfileChatProvider _provider;
  bool _initialized = false;

  static const double _webCardWidth = 560;

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  PreferredSizeWidget? appBar() {
    return AppBar(
      title: Text('Chat',
          style: AppTextStyle.white(18, FontWeight.bold)),
    );
  }

  @override
  Widget body() {
    return Consumer<ProfileChatProvider>(builder: (context, provider, _) {
      _provider = provider;
      if (!_initialized) {
        _initialized = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.init("test-01");
        });
      }
      return kIsWeb ? _uiWeb() : _uiMobile();
    });
  }

  Widget _uiWeb() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _webCardWidth),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: _chatBody(),
        ),
      ),
    );
  }

  Widget _uiMobile() {
    return _chatBody();
  }

  Widget _chatBody() {
    return Column(
      children: [
        Expanded(child: _messageList()),
        if (_provider.isSending) _typingIndicator(),
        _inputBar(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MESSAGE LIST
  // ---------------------------------------------------------------------------
  Widget _messageList() {
    return ListView.builder(
      controller: _provider.scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: _provider.messages.length,
      itemBuilder: (context, index) => _bubble(_provider.messages[index]),
    );
  }

  Widget _bubble(ChatMessage message) {
    final bool isUser = message.isUser;
    final Color bubbleColor = message.isError
        ? AppColors.red.withValues(alpha: 0.1)
        : isUser
            ? AppColors.primaryColor
            : AppColors.lightGrey;
    final TextStyle textStyle = message.isError
        ? AppTextStyle.red(14, FontWeight.w500)
        : isUser
            ? AppTextStyle.white(14, FontWeight.normal)
            : AppTextStyle.black(14, FontWeight.normal);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 2),
            bottomRight: Radius.circular(isUser ? 2 : 14),
          ),
        ),
        child: Text(message.text, style: textStyle),
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: AppColors.primaryColor,
              ),
            ),
            wSpace(8),
            Text('Typing...', style: AppTextStyle.grey(13, FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT BAR
  // ---------------------------------------------------------------------------
  Widget _inputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _provider.messageCtrl,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  style: AppTextStyle.black(15, FontWeight.normal),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _onSend(),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: 'Type your message...',
                    hintStyle: AppTextStyle.grey(15, FontWeight.normal),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            wSpace(8),
            _sendButton(),
          ],
        ),
      ),
    );
  }

  Widget _sendButton() {
    final bool enabled = _provider.canSend;
    return GestureDetector(
      onTap: enabled ? _onSend : null,
      child: CircleAvatar(
        radius: 22,
        backgroundColor:
            enabled ? AppColors.primaryColor : AppColors.lightGrey,
        child: Icon(
          Icons.send_rounded,
          color: enabled ? AppColors.white : AppColors.grey,
          size: 20,
        ),
      ),
    );
  }

  void _onSend() {
    hideKeyboard();
    _provider.sendMessage().then((_) => setState(() {}));
  }
}


import 'package:flutter/cupertino.dart';
import '../../base/base_page.dart';

class NotificationPage extends BasePage {
  static const id = 'NotificationPage';

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends BaseState<NotificationPage> with BasicPage {

  @override
  Widget body() {
   return Center(child: Text('Notification Page'));
  }
}
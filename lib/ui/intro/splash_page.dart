import 'dart:async';
import 'package:flutter/material.dart';
import '../../base/base_page.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';
import '../../utils/storage/app_preference.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';

class SplashPage extends BasePage {
  static const id = 'SplashPage';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseState<SplashPage> with BasicPage {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(
      const Duration(seconds: AppStrings.splashDurationInSec),
      _navigateNext,
    );
  }

  void _navigateNext() {
    // 'Y' -> already logged in, go to home, otherwise login.
    // ignore: dead_code
    final String nextRoute =
        pref.loginFlag == AppSharedPref.yes ? HomePage.id : LoginPage.id;
    Navigator.of(context).pushNamedAndRemoveUntil(nextRoute, (route) => false);
  }

  @override
  Color bgColor() => AppColors.white;

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              AppStrings.imgAppIcon,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          hSpace(24),
          Text(
            AppStrings.txtAppName,
            style: AppTextStyle.primary(20, FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/api_client.dart';
import '../service/auth_repo.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_helper.dart';
import '../utils/constants/app_loader.dart';
import '../utils/constants/app_text_style.dart';
import '../utils/di/app_di.dart';
import '../utils/storage/app_preference.dart';

class BaseProvider extends ChangeNotifier {
  AppSharedPref pref = getIt<AppSharedPref>();
  ApiClient api = getIt<ApiClient>();
  AuthRepo authRepo = getIt<AuthRepo>();
  AppHelper appHelper = getIt<AppHelper>();

  // Name Salutation
  List<String> titleOptions = ['Mr.', 'Mrs.', 'Ms.', 'M/s.'];

  // Amount Formatter
  final NumberFormat amtFormat = NumberFormat.decimalPattern('en_IN');

  void showLoading() {
    showLoader();
  }

  void hideLoading() {
    hideLoader();
  }

  String detectInputType(String input) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final mobileRegex = RegExp(r"^[0-9]{10}$");

    if (emailRegex.hasMatch(input)) {
      return 'E';
    } else if (mobileRegex.hasMatch(input)) {
      return 'M';
    } else {
      // I - invalid
      return 'I';
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Converts Uint8List (e.g., image bytes) to a Base64 string.
  String uint8ListToBase64(Uint8List data) {
    return base64Encode(data);
  }

  /// Converts a Base64 string back to Uint8List.
  Uint8List base64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  void successAlertDialog(
      BuildContext context, String message, String btnText, Function() onNext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: kIsWeb ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
          ),
          margin: kIsWeb
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3)
              : const EdgeInsets.symmetric(horizontal: 40),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: AppColors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.white(16, FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    height: 1,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onNext();
                      },
                      child: Text(
                        btnText,
                        style: AppTextStyle.white(16, FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? getMonth(String month) {
    switch (month) {
      case "1":
        return "Jan";
      case "2":
        return "Feb";
      case "3":
        return "Mar";
      case "4":
        return "Apr";
      case "5":
        return "May";
      case "6":
        return "Jun";
      case "7":
        return "Jul";
      case "8":
        return "Aug";
      case "9":
        return "Sep";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      default:
        return "Dec";
    }
  }

  String maskPan(String? pan) {
    if (pan == null || pan.length < 4) return pan ?? '-';
    return '*' * (pan.length - 4) + pan.substring(pan.length - 4);
  }
}

class ImageFile {
  const ImageFile(this.compressedFile);

  final Uint8List? compressedFile;
}

class SocialUser {
  final String id;
  final String name;
  final String email;
  final String source;

  SocialUser(
      {required this.id,
        required this.name,
        required this.email,
        required this.source});
}
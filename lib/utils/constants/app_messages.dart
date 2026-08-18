import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_colors.dart';
import 'package:get/get.dart';

void appPrint(String message) {
  if (kDebugMode) {
    log("=====>  $message <=====", name: 'Logging');
  }
}

void successToast(String message) {
  if (kIsWeb) {
    // Web-compatible solution using ScaffoldMessenger
    final context = Get.context;
    if (context != null) {
      final screenWidth = MediaQuery.of(context).size.width;
      const toastWidth = 500.0; // Fixed 500px width

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: 800.milliseconds,
          content: Container(
            constraints: const BoxConstraints(
              maxWidth: toastWidth,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.green[800],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: (screenWidth - toastWidth) / 2, // Center the 500px toast
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  } else {
    // Mobile solution using Fluttertoast
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[800],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

void errorToast(String message) {
  if (kIsWeb) {
    // Web-compatible solution using ScaffoldMessenger
    final context = Get.context;
    if (context != null) {
      final screenWidth = MediaQuery.of(context).size.width;
      const toastWidth = 500.0; // Fixed 500px width
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: 800.milliseconds,
          content: Container(
            constraints: const BoxConstraints(
              maxWidth: toastWidth,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: (screenWidth - toastWidth) / 2, // Center the 500px toast
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  } else {
    // Mobile solution using Fluttertoast
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[800],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

void showAppSnackBar(
    BuildContext context,
    String message, {
      Color? color,
      String? buttonText,
      VoidCallback? onPressed,
    }) {
  if (kIsWeb) {
    // Web-compatible solution with fixed width
    final screenWidth = MediaQuery.of(context).size.width;
    const toastWidth = 500.0; // Fixed 500px width

    final snackBar = SnackBar(
      duration: 800.milliseconds,
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: toastWidth,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: color ?? AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: (screenWidth - toastWidth) / 2, // Center the 500px toast
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: buttonText != null && onPressed != null
          ? SnackBarAction(
        label: buttonText,
        onPressed: onPressed,
        textColor: AppColors.white,
      )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    // Mobile solution
    final snackBar = SnackBar(
      duration: 800.milliseconds,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: AppColors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w500),
      ),
      backgroundColor: color ?? AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      action: buttonText != null && onPressed != null
          ? SnackBarAction(
        label: buttonText,
        onPressed: onPressed,
        textColor: AppColors.white,
      )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
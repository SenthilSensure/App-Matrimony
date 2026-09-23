import 'package:app_matrimony/base/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/login/login_res.dart';
import '../../ui/otp/otp_page.dart';
import '../../utils/constants/app_messages.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/storage/app_preference.dart';

class LoginProvider extends BaseProvider {
  // CONTROLLERS
  final TextEditingController mobileCtrl = TextEditingController();

  // STATE
  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // VALIDATION
  String? validate() {
    final String mobile = mobileCtrl.text.trim();
    if (mobile.isEmpty) return AppStrings.msgEnterMobile;
    if (mobile.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      return AppStrings.msgEnterValidMobile;
    }
    return null;
  }

  // API
  Future<bool> login() async {
    final String? error = validate();
    if (error != null) {
      errorToast(error);
      return false;
    }

    Map<String, dynamic> input = {
      "mobileNumber": mobileCtrl.text.trim(),
    };

    _setLoading(true);
    showLoading();

    final result = await authRepo.login(input);

    hideLoading();
    _setLoading(false);

    return result.fold(
      (failure) {
        errorToast(failure.toString());
        return false;
      },
      (success) {
        if (success.success == false) {
          errorToast(success.message ?? AppStrings.msgLoginFailed);
          return false;
        }
        _saveSession(success);
        successToast(success.message ?? AppStrings.msgLoginSuccess);
        clear();
        Get.offAllNamed(OtpPage.id);
        return true;
      },
    );
  }

  /// Persist the session so the splash screen can auto-login next time.
  void _saveSession(LoginRes res) {
    if (res.token != null && res.token!.isNotEmpty) {
      pref.token = res.token!;
    }
    final LoginUser? user = res.data;
    if (user != null) {
      pref.addUser = CustomerData(
        name: user.name,
        email: user.email,
        phone: user.mobileNumber,
        dob: user.dob,
        gender: user.gender,
      );
    }
    pref.loginFlag = AppSharedPref.yes;
  }

  void clear() {
    mobileCtrl.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    mobileCtrl.dispose();
    super.dispose();
  }
}
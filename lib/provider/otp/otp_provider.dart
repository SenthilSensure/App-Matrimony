import 'dart:async';
import 'package:app_matrimony/base/base_provider.dart';
import 'package:app_matrimony/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/login/login_res.dart';
import '../../utils/constants/app_messages.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/storage/app_preference.dart';

class OtpProvider extends BaseProvider {
  /// Number of OTP digits.
  static const int otpLength = AppStrings.otpLength;

  /// Seconds the user has to wait before "Resend" becomes active.
  static const int resendWaitSec = AppStrings.otpResendWaitSec;

  final TextEditingController otpCtrl = TextEditingController();

  // STATE
  String mobileNumber = '';
  bool isLoading = false;
  bool hasError = false;

  int _secondsLeft = 0;
  Timer? _timer;

  int get secondsLeft => _secondsLeft;

  bool get canResend => _secondsLeft == 0;

  bool get isOtpFilled => otpCtrl.text.length == otpLength;

  /// `01:00` style countdown text.
  String get timerText {
    final int m = _secondsLeft ~/ 60;
    final int s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Masked number for display -> `+91 98****3210`
  String get maskedMobile {
    if (mobileNumber.length != 10) return mobileNumber;
    return '${AppStrings.txtMobilePrefix}'
        '${mobileNumber.substring(0, 2)}****${mobileNumber.substring(6)}';
  }

  // LIFECYCLE
  void init(String mobile) {
    mobileNumber = mobile;
    otpCtrl.clear();
    hasError = false;
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _secondsLeft = resendWaitSec;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _secondsLeft = 0;
        timer.cancel();
      } else {
        _secondsLeft--;
      }
      notifyListeners();
    });
  }

  void onOtpChanged(String value) {
    if (hasError) {
      hasError = false;
      notifyListeners();
    } else {
      // Keeps the submit button enable/disable state in sync.
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // VALIDATION
  String? validate() {
    final String otp = otpCtrl.text.trim();
    if (otp.isEmpty) return AppStrings.msgEnterOtp;
    if (otp.length != otpLength) return AppStrings.msgEnterValidOtp;
    return null;
  }

  // API
  Future<bool> verifyOtp() async {
    Get.offAllNamed(HomePage.id);
    return true;
    final String? error = validate();
    if (error != null) {
      hasError = true;
      notifyListeners();
      errorToast(error);
      return false;
    }

    Map<String, dynamic> input = {
      "mobileNumber": mobileNumber,
      "otp": otpCtrl.text.trim(),
    };

    _setLoading(true);
    showLoading();

    final result = await authRepo.verifyOtp(input);

    hideLoading();
    _setLoading(false);

    return result.fold(
      (failure) {
        hasError = true;
        notifyListeners();
        errorToast(failure.toString());
        return false;
      },
      (success) {
        if (success.success == false) {
          hasError = true;
          notifyListeners();
          errorToast(success.message ?? AppStrings.msgOtpInvalid);
          return false;
        }
        _saveSession(success);
        successToast(success.message ?? AppStrings.msgOtpVerified);
        Get.offAllNamed(HomePage.id);
        return true;
      },
    );
  }

  Future<void> resendOtp() async {
    if (!canResend || isLoading) return;

    Map<String, dynamic> input = {"mobileNumber": mobileNumber};

    _setLoading(true);
    showLoading();

    final result = await authRepo.resendOtp(input);

    hideLoading();
    _setLoading(false);

    result.fold(
      (failure) => errorToast(failure.toString()),
      (success) {
        if (success.success == false) {
          errorToast(success.message ?? AppStrings.msgOtpResendFailed);
          return;
        }
        otpCtrl.clear();
        hasError = false;
        successToast(success.message ?? AppStrings.msgOtpResent);
        startTimer();
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
    _timer?.cancel();
    otpCtrl.clear();
    mobileNumber = '';
    hasError = false;
    _secondsLeft = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpCtrl.dispose();
    super.dispose();
  }
}


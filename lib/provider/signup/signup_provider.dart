import 'package:app_matrimony/base/base_provider.dart';
import 'package:app_matrimony/ui/otp/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/app_messages.dart';
import '../../utils/constants/app_strings.dart';

class SignupProvider extends BaseProvider {
  // CONTROLLERS  (signup keeps only the minimum identity fields,
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();

  // STATE
  DateTime? dob;
  String? gender;
  bool isLoading = false;

  final List<String> genderOptions = const [
    AppStrings.txtMale,
    AppStrings.txtFemale,
    AppStrings.txtOther,
  ];

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setDob(DateTime value) {
    dob = value;
    dobCtrl.text = '${_two(value.day)}/${_two(value.month)}/${value.year}';
    ageCtrl.text = '${calculateAge(value)}';
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // HELPERS
  String _two(int value) => value.toString().padLeft(2, '0');

  int calculateAge(DateTime birthDate) {
    final DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String get _apiDob =>
      dob == null ? '' : '${dob!.year}-${_two(dob!.month)}-${_two(dob!.day)}';

  // VALIDATION
  String? validate() {
    if (nameCtrl.text.trim().isEmpty) return AppStrings.msgEnterName;
    if (gender == null || gender!.isEmpty) return AppStrings.msgSelectGender;
    if (dob == null) return AppStrings.msgSelectDob;
    if (calculateAge(dob!) < 18) return AppStrings.msgMinAge;
    if (mobileCtrl.text.trim().length != 10) {
      return AppStrings.msgEnterValidMobile;
    }
    if (emailCtrl.text.trim().isNotEmpty &&
        !isValidEmail(emailCtrl.text.trim())) {
      return AppStrings.msgEnterValidEmail;
    }
    return null;
  }

  // API
  Future<bool> signup() async {
    final String? error = validate();
    if (error != null) {
      errorToast(error);
      return false;
    }

    Map<String, dynamic> input = {
      "name": nameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "gender": gender,
      "dob": _apiDob,
      "age": calculateAge(dob!).toString(),
      "mobileNumber": mobileCtrl.text.trim(),
    };

    _setLoading(true);

    showLoading();

    final result = await authRepo.signup(input);

    hideLoading();
    _setLoading(false);

    return result.fold(
      (fail) {
        errorToast(fail);
        return false;
      },
      (suc) {
        if (suc.success == true) {
          successToast(suc.message ?? AppStrings.msgSignupSuccess);
          clear();
          Get.toNamed(OtpPage.id);
          return true;
        } else {
          errorToast(suc.message ?? '');
          return false;
        }
      },
    );
  }

  void clear() {
    nameCtrl.clear();
    emailCtrl.clear();
    mobileCtrl.clear();
    dobCtrl.clear();
    ageCtrl.clear();
    dob = null;
    gender = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    dobCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }
}

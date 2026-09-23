import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../base/base_page.dart';
import '../../provider/login/login_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_components.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';
import '../otp/otp_page.dart';
import '../signup/signup_page.dart';

class LoginPage extends BasePage {
  static const id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> with BasicPage {
  late LoginProvider _provider;

  static const double _webCardWidth = 460;

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  Widget body() {
    return Consumer<LoginProvider>(builder: (context, provider, _) {
      _provider = provider;
      return kIsWeb ? uiWeb() : uiMobile();
    });
  }

  Widget uiWeb() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _webCardWidth),
          child: Container(
            padding: const EdgeInsets.all(40),
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
            child: _form(centered: true),
          ),
        ),
      ),
    );
  }

  Widget uiMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: _form(),
    );
  }

  Widget _form({bool centered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppStrings.imgAppIcon,
              height: 88,
              width: 88,
              fit: BoxFit.cover,
            ),
          ),
        ),
        hSpace(16),
        SizedBox(
          width: double.infinity,
          child: Text(
            AppStrings.txtWelcomeBack,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: AppTextStyle.black(22, FontWeight.bold),
          ),
        ),
        hSpace(8),
        SizedBox(
          width: double.infinity,
          child: Text(
            AppStrings.txtLoginSubtitle,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: AppTextStyle.grey(14, FontWeight.normal),
          ),
        ),
        hSpace(28),
        AppTextFieldTitle(
          text: AppStrings.txtMobileNumber,
          isMandatory: true,
          textStyle: AppTextStyle.black(15, FontWeight.w600),
        ),
        hSpace(8),
        AppTextField(
          controller: _provider.mobileCtrl,
          hint: AppStrings.txtMobileNumberHint,
          prefixText: AppStrings.txtMobilePrefix,
          maxLength: 10,
          inputType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onLogin(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        hSpace(28),
        AppButton(
          title: AppStrings.txtLogin,
          enabled: !_provider.isLoading,
          onTap: _onLogin,
        ),
        hSpace(20),
        Align(
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.txtNoAccount,
                  style: AppTextStyle.grey(14, FontWeight.normal)),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(SignupPage.id),
                child: Text(AppStrings.txtSignup,
                    style: AppTextStyle.primary(14, FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onLogin() async {
    hideKeyboard();
    final bool success = await _provider.login();
    if (!success || !mounted) return;
    Get.toNamed(OtpPage.id, arguments: {
      'mobileNumber': _provider.mobileCtrl.text.trim(),
    });
  }
}
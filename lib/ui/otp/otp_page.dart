import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../base/base_page.dart';
import '../../provider/otp/otp_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_components.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';
import '../home/home_page.dart';

class OtpPage extends BasePage {
  static const id = 'OtpPage';

  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends BaseState<OtpPage> with BasicPage {
  late OtpProvider _provider;

  static const double _webCardWidth = 460;

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamic args;
       String mobile = args['mobileNumber'];
      _provider.init(mobile);
    });
  }

  @override
  Widget body() {
    return Consumer<OtpProvider>(builder: (context, provider, _) {
      _provider = provider;
      return kIsWeb ? uiWeb() : uiMobile();
    });
  }

  // WEB LAYOUT
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

  // MOBILE LAYOUT
  Widget uiMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: _form(),
    );
  }

  // SHARED DESIGN (used by both layouts)
  Widget _form({bool centered = false}) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.sms_outlined,
                color: AppColors.primaryColor, size: 30),
          ),
        ),
        hSpace(16),
        SizedBox(
          width: double.infinity,
          child: Text(
            AppStrings.txtOtpTitle,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: AppTextStyle.black(22, FontWeight.bold),
          ),
        ),
        hSpace(8),
        _mobileRow(centered: centered),
        hSpace(28),
        _otpLabelRow(),
        hSpace(10),
        Center(
          child: AppOtpField(
            controller: _provider.otpCtrl,
            length: OtpProvider.otpLength,
            hasError: _provider.hasError,
            onChanged: _provider.onOtpChanged,
            onCompleted: (_) => _onVerify(),
          ),
        ),
        hSpace(30),
        AppButton(
          title: AppStrings.txtVerify,
          enabled: !_provider.isLoading && _provider.isOtpFilled,
          onTap: _onVerify,
        ),
        hSpace(24),
        _resendRow(centered: centered),
      ],
    );
  }

  /// Masked mobile number + edit icon to go back and change it.
  Widget _mobileRow({bool centered = false}) {
    return Row(
      mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment:
          centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text.rich(
            TextSpan(
              text: '${AppStrings.txtOtpSubtitle} ',
              style: AppTextStyle.grey(14, FontWeight.normal),
              children: [
                TextSpan(
                  text: _provider.maskedMobile,
                  style: AppTextStyle.black(14, FontWeight.w700),
                ),
              ],
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        wSpace(6),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.edit_outlined,
                size: 16, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _otpLabelRow() {
    return AppTextFieldTitle(
      text: AppStrings.txtEnterOtp,
      isMandatory: true,
      textStyle: AppTextStyle.black(15, FontWeight.w600),
    );
  }

  /// "Didn't receive the code? Resend OTP" / "Resend OTP in 00:45"
  Widget _resendRow({bool centered = false}) {
    return Row(
      mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment:
          centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Text(AppStrings.txtNotReceivedOtp,
            style: AppTextStyle.grey(14, FontWeight.normal)),
        if (_provider.canResend)
          InkWell(
            onTap: _onResend,
            child: Text(
              AppStrings.txtResendOtp,
              style: AppTextStyle.primary(14, FontWeight.bold),
            ),
          )
        else
          Text(
            '${AppStrings.txtResendIn}${_provider.timerText}',
            style: AppTextStyle.black(14, FontWeight.w600),
          ),
      ],
    );
  }

  // ACTIONS
  Future<void> _onVerify() async {
    hideKeyboard();
    final bool success = await _provider.verifyOtp();
    if (!success || !mounted) return;
    Get.offAllNamed(HomePage.id);
  }

  Future<void> _onResend() async {
    hideKeyboard();
    await _provider.resendOtp();
  }
}


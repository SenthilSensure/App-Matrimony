import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../base/base_page.dart';
import '../../provider/signup/signup_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_components.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';

class SignupPage extends BasePage {
  static const id = '_SignupPage';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => __SignupPageState();
}

class __SignupPageState extends BaseState<SignupPage> with BasicPage {
  late SignupProvider _provider;

  static const double _webCardWidth = 900;

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  Widget body() {
    return Consumer<SignupProvider>(builder: (context, provider, _) {
      _provider = provider;
      return kIsWeb ? uiWeb() : uiMobile();
    });
  }

  // ---------------------------------------------------------------------------
  // WEB LAYOUT
  // ---------------------------------------------------------------------------
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(centered: true),
                hSpace(32),
                _sectionTitle(AppStrings.txtProfileDetails),
                hSpace(16),
                _nameField(),
                hSpace(18),
                _genderField(),
                hSpace(28),
                _sectionTitle(AppStrings.txtPersonalDetails),
                hSpace(16),
                _row([_dobField(), _ageField()]),
                hSpace(20),
                _row([_mobileField(), _emailField()]),
                hSpace(16),
                _note(),
                hSpace(32),
                SizedBox(width: 240, child: _submitButton()),
                hSpace(20),
                Align(alignment: Alignment.centerLeft, child: _loginRow()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT
  // ---------------------------------------------------------------------------
  Widget uiMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          hSpace(28),
          _sectionTitle(AppStrings.txtProfileDetails),
          hSpace(16),
          _nameField(),
          hSpace(18),
          _genderField(),
          hSpace(26),
          _sectionTitle(AppStrings.txtPersonalDetails),
          hSpace(16),
          _dobField(),
          hSpace(18),
          _ageField(),
          hSpace(18),
          _mobileField(),
          hSpace(18),
          _emailField(),
          hSpace(16),
          _note(),
          hSpace(32),
          _submitButton(),
          hSpace(20),
          Center(child: _loginRow()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED DESIGN COMPONENTS (used by both layouts)
  // ---------------------------------------------------------------------------
  Widget _header({bool centered = false}) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppStrings.imgAppIcon,
            height: 88,
            width: 88,
            fit: BoxFit.cover,
          ),
        ),
        hSpace(16),
        Text(
          AppStrings.txtCreateAccount,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: AppTextStyle.black(22, FontWeight.bold),
        ),
        hSpace(8),
        Text(
          AppStrings.txtSignupSubtitle,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: AppTextStyle.grey(14, FontWeight.normal),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          height: 18,
          width: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        wSpace(10),
        Text(title, style: AppTextStyle.black(17, FontWeight.bold)),
      ],
    );
  }

  Widget _field({
    required String label,
    required Widget child,
    bool isMandatory = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFieldTitle(
          text: label,
          isMandatory: isMandatory,
          textStyle: AppTextStyle.black(15, FontWeight.w600),
        ),
        hSpace(8),
        child,
      ],
    );
  }

  Widget _row(List<Widget> children) {
    final List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(Expanded(child: children[i]));
      if (i != children.length - 1) items.add(wSpace(24));
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }

  // 1. Name
  Widget _nameField() {
    return _field(
      label: AppStrings.txtName,
      child: AppTextField(
        controller: _provider.nameCtrl,
        hint: AppStrings.txtNameHint,
        maxLength: 50,
        inputType: TextInputType.name,
        autofillHints: const [AutofillHints.name],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z .]")),
        ],
      ),
    );
  }

  // Email
  Widget _emailField() {
    return _field(
      label: AppStrings.txtEmail,
      isMandatory: false,
      child: AppTextField(
        controller: _provider.emailCtrl,
        hint: AppStrings.txtEmailHint,
        inputType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
      ),
    );
  }

  // 2. Mobile number
  Widget _mobileField() {
    return _field(
      label: AppStrings.txtMobileNumber,
      child: AppTextField(
        controller: _provider.mobileCtrl,
        hint: AppStrings.txtMobileNumberHint,
        prefixText: AppStrings.txtMobilePrefix,
        maxLength: 10,
        inputType: TextInputType.phone,
        autofillHints: const [AutofillHints.telephoneNumber],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  // 3. Date of birth
  Widget _dobField() {
    return _field(
      label: AppStrings.txtDob,
      child: AppTextField(
        controller: _provider.dobCtrl,
        hint: AppStrings.txtDobHint,
        readOnly: true,
        onTap: _onPickDob,
        suffixIcon: Icon(Icons.calendar_month_outlined,
            color: AppColors.primaryColor, size: 20),
      ),
    );
  }

  // 4. Age (auto calculated from DOB)
  Widget _ageField() {
    return _field(
      label: AppStrings.txtAge,
      isMandatory: false,
      child: AppTextField(
        controller: _provider.ageCtrl,
        hint: AppStrings.txtAgeHint,
        readOnly: true,
        enabled: false,
        fillColor: AppColors.lightGrey.withValues(alpha: 0.4),
        inputType: TextInputType.number,
      ),
    );
  }

  // 5. Gender
  Widget _genderField() {
    return _field(
      label: AppStrings.txtGender,
      child: AppRadioButtonBox(
        widget: Row(
          children: _provider.genderOptions
              .map((e) => Expanded(child: _genderChip(e)))
              .toList(),
        ),
      ),
    );
  }

  Widget _genderChip(String value) {
    final bool selected = _provider.gender == value;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _provider.setGender(value),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryColor.withValues(alpha: 0.08)
                : AppColors.white,
            border: Border.all(
              color: selected ? AppColors.primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off_outlined,
                size: 18,
                color: selected ? AppColors.primaryColor : AppColors.grey,
              ),
              wSpace(8),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: selected
                      ? AppTextStyle.primary(15, FontWeight.w600)
                      : AppTextStyle.black(15, FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Small hint telling the user the profile is completed later.
  Widget _note() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.primaryColor),
          wSpace(8),
          Expanded(
            child: Text(
              AppStrings.txtSignupNote,
              style: AppTextStyle.black(13, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return AppButton(
      title: AppStrings.txtSignup,
      enabled: !_provider.isLoading,
      onTap: _onSignup,
    );
  }

  Widget _loginRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppStrings.txtAlreadyHaveAccount,
            style: AppTextStyle.grey(14, FontWeight.normal)),
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Text(AppStrings.txtLogin,
              style: AppTextStyle.primary(14, FontWeight.bold)),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  Future<void> _onPickDob() async {
    hideKeyboard();
    final DateTime? picked = await pickDateOfBirth(
      context,
      initialDate: _provider.dob ?? DateTime(2000, 1, 1),
    );
    if (picked == null) return;
    _provider.setDob(picked);
  }

  Future<void> _onSignup() async {
    hideKeyboard();
    final bool success = await _provider.signup();
    if (!success || !mounted) return;
    Navigator.of(context).maybePop();
  }
}


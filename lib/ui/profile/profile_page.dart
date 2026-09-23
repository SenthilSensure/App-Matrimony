import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../base/base_page.dart';
import '../../provider/profile/profile_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_components.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';

class ProfilePage extends BasePage {
  static const id = 'ProfilePage';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> with BasicPage {
  late ProfileProvider _provider;
  bool _initialized = false;
  int _sectionIndex = 0;

  static const double _webMaxWidth = 1100;

  final List<String> _sections = const [
    AppStrings.txtBasicInfo,
    AppStrings.txtLocationInfo,
    AppStrings.txtPhysicalInfo,
    AppStrings.txtEducationInfo,
    AppStrings.txtCareerInfo,
    AppStrings.txtFamilyInfo,
    AppStrings.txtReligionInfo,
    AppStrings.txtLifestyleInfo,
    AppStrings.txtAboutInfo,
    AppStrings.txtPhotosInfo,
    AppStrings.txtPartnerPrefInfo,
  ];

  final List<IconData> _sectionIcons = const [
    Icons.badge_outlined,
    Icons.location_on_outlined,
    Icons.accessibility_new_outlined,
    Icons.school_outlined,
    Icons.work_outline,
    Icons.family_restroom_outlined,
    Icons.temple_hindu_outlined,
    Icons.local_cafe_outlined,
    Icons.info_outline,
    Icons.photo_camera_outlined,
    Icons.favorite_border,
  ];

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  PreferredSizeWidget? appBar() {
    return AppBar(
      title: Text(AppStrings.txtProfile,
          style: AppTextStyle.white(18, FontWeight.bold)),
    );
  }

  @override
  Widget body() {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      _provider = provider;
      if (!_initialized) {
        _initialized = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.getProfileDetails();
        });
      }
      return kIsWeb ? _uiWeb() : _uiMobile();
    });
  }

  // ---------------------------------------------------------------------------
  // WEB LAYOUT — side section list + wide content + persistent save button
  // ---------------------------------------------------------------------------
  Widget _uiWeb() {
    if (_provider.isLoading) return const Center(child: CircularProgressIndicator());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 260,
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
            itemCount: _sections.length,
            itemBuilder: (context, i) => _sideNavItem(i),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _webMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle(_sections[_sectionIndex]),
                      SizedBox(width: 180, height: 44, child: _saveButton()),
                    ],
                  ),
                  hSpace(24),
                  _sectionContent(_sectionIndex, isWeb: true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sideNavItem(int index) {
    final bool selected = index == _sectionIndex;
    return InkWell(
      onTap: () => setState(() => _sectionIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: selected ? AppColors.softPink.withValues(alpha: 0.4) : null,
        child: Row(
          children: [
            Icon(_sectionIcons[index],
                size: 20,
                color: selected ? AppColors.primaryColor : AppColors.grey),
            wSpace(12),
            Expanded(
              child: Text(
                _sections[index],
                style: selected
                    ? AppTextStyle.primary(14, FontWeight.w600)
                    : AppTextStyle.black(14, FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT — horizontal chip nav + vertical scroll content
  // ---------------------------------------------------------------------------
  Widget _uiMobile() {
    if (_provider.isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Container(
          height: 56,
          color: AppColors.white,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _sections.length,
            separatorBuilder: (_, __) => wSpace(8),
            itemBuilder: (context, i) => _chipNavItem(i),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(_sections[_sectionIndex]),
                hSpace(16),
                _sectionContent(_sectionIndex, isWeb: false),
                hSpace(28),
                _saveButton(),
                hSpace(20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chipNavItem(int index) {
    final bool selected = index == _sectionIndex;
    return ChoiceChip(
      label: Text(_sections[index]),
      selected: selected,
      onSelected: (_) => setState(() => _sectionIndex = index),
      labelStyle: selected
          ? AppTextStyle.white(13, FontWeight.w600)
          : AppTextStyle.black(13, FontWeight.normal),
      selectedColor: AppColors.primaryColor,
      backgroundColor: AppColors.lightGrey,
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION ROUTER
  // ---------------------------------------------------------------------------
  Widget _sectionContent(int index, {required bool isWeb}) {
    switch (index) {
      case 0:
        return _basicInfoSection(isWeb);
      case 1:
        return _locationSection(isWeb);
      case 2:
        return _physicalSection(isWeb);
      case 3:
        return _educationSection(isWeb);
      case 4:
        return _careerSection(isWeb);
      case 5:
        return _familySection(isWeb);
      case 6:
        return _religionSection(isWeb);
      case 7:
        return _lifestyleSection(isWeb);
      case 8:
        return _aboutSection(isWeb);
      case 9:
        return _photosSection(isWeb);
      case 10:
        return _partnerPrefSection(isWeb);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // SHARED HELPERS
  // ---------------------------------------------------------------------------
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
        Text(title, style: AppTextStyle.black(18, FontWeight.bold)),
      ],
    );
  }

  Widget _field({
    required String label,
    required Widget child,
    bool isMandatory = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFieldTitle(
          text: label,
          isMandatory: isMandatory,
          textStyle: AppTextStyle.black(14, FontWeight.w600),
        ),
        hSpace(8),
        child,
      ],
    );
  }

  /// Lays fields out in a row on web (multi-column) and stacked on mobile.
  Widget _grid(List<Widget> children, {required bool isWeb, int columns = 2}) {
    if (!isWeb) {
      return Column(
        children: [
          for (final c in children) ...[c, hSpace(18)],
        ],
      );
    }
    final List<Widget> rows = [];
    for (int i = 0; i < children.length; i += columns) {
      final chunk = children.skip(i).take(columns).toList();
      final List<Widget> rowItems = [];
      for (int j = 0; j < chunk.length; j++) {
        rowItems.add(Expanded(child: chunk[j]));
        if (j != chunk.length - 1) rowItems.add(wSpace(24));
      }
      // Pad the row so the last row's items don't stretch full-width.
      if (chunk.length < columns) {
        rowItems.add(wSpace(24));
        rowItems.add(Expanded(child: Container()));
      }
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowItems));
      rows.add(hSpace(20));
    }
    return Column(children: rows);
  }

  // ---------------------------------------------------------------------------
  // 1. BASIC INFORMATION
  // ---------------------------------------------------------------------------
  Widget _basicInfoSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtProfileCreatedFor,
        child: AppDropdown<String>(
          value: _provider.profileCreatedFor,
          items: _provider.profileCreatedForOptions,
          onChanged: _provider.setProfileCreatedFor,
        ),
      ),
      _field(
        label: AppStrings.txtName,
        child: AppTextField(
          controller: _provider.nameCtrl,
          hint: AppStrings.txtNameHint,
        ),
      ),
      _field(
        label: AppStrings.txtGender,
        child: AppDropdown<String>(
          value: _provider.gender,
          items: _provider.genderOptions,
          onChanged: _provider.setGender,
        ),
      ),
      _field(
        label: AppStrings.txtDob,
        child: AppTextField(
          controller: _provider.dobCtrl,
          hint: AppStrings.txtDobHint,
          readOnly: true,
          onTap: _onPickDob,
          suffixIcon: Icon(Icons.calendar_month_outlined,
              color: AppColors.primaryColor, size: 20),
        ),
      ),
      _field(
        label: AppStrings.txtMaritalStatus,
        child: AppDropdown<String>(
          value: _provider.maritalStatus,
          items: _provider.maritalStatusOptions,
          onChanged: _provider.setMaritalStatus,
        ),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 2. LOCATION
  // ---------------------------------------------------------------------------
  Widget _locationSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtCity,
        child: AppTextField(controller: _provider.cityCtrl, hint: AppStrings.txtCity),
      ),
      _field(
        label: AppStrings.txtState,
        child: AppTextField(controller: _provider.stateCtrl, hint: AppStrings.txtState),
      ),
      _field(
        label: AppStrings.txtCountry,
        child: AppTextField(controller: _provider.countryCtrl, hint: AppStrings.txtCountry),
      ),
      _field(
        label: AppStrings.txtPincode,
        child: AppTextField(
          controller: _provider.pincodeCtrl,
          hint: AppStrings.txtPincode,
          inputType: TextInputType.number,
          maxLength: 6,
        ),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 3. PHYSICAL INFORMATION
  // ---------------------------------------------------------------------------
  Widget _physicalSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtHeight,
        child: AppTextField(
          controller: _provider.heightCtrl,
          hint: '175',
          inputType: TextInputType.number,
        ),
      ),
      _field(
        label: AppStrings.txtWeight,
        child: AppTextField(
          controller: _provider.weightCtrl,
          hint: '70',
          inputType: TextInputType.number,
        ),
      ),
      _field(
        label: AppStrings.txtBodyType,
        child: AppDropdown<String>(
          value: _provider.bodyType,
          items: _provider.bodyTypeOptions,
          onChanged: _provider.setBodyType,
        ),
      ),
      _field(
        label: AppStrings.txtComplexion,
        child: AppDropdown<String>(
          value: _provider.complexion,
          items: _provider.complexionOptions,
          onChanged: _provider.setComplexion,
        ),
      ),
      _field(
        label: AppStrings.txtPhysicalStatus,
        child: AppDropdown<String>(
          value: _provider.physicalStatus,
          items: _provider.physicalStatusOptions,
          onChanged: _provider.setPhysicalStatus,
        ),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 4. EDUCATION
  // ---------------------------------------------------------------------------
  Widget _educationSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtEducation,
        child: AppTextField(controller: _provider.educationCtrl, hint: 'e.g. B.Tech, MBA'),
      ),
      _field(
        label: AppStrings.txtEducationDetails,
        child: AppTextField(
            controller: _provider.educationDetailsCtrl, hint: 'e.g. Computer Science'),
      ),
      _field(
        label: AppStrings.txtCollege,
        child: AppTextField(controller: _provider.collegeCtrl, hint: AppStrings.txtCollege),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 5. CAREER
  // ---------------------------------------------------------------------------
  Widget _careerSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtOccupation,
        child: AppTextField(controller: _provider.occupationCtrl, hint: AppStrings.txtOccupation),
      ),
      _field(
        label: AppStrings.txtJobTitle,
        child: AppTextField(controller: _provider.jobTitleCtrl, hint: AppStrings.txtJobTitle),
      ),
      _field(
        label: AppStrings.txtCompany,
        child: AppTextField(controller: _provider.companyCtrl, hint: AppStrings.txtCompany),
      ),
      _field(
        label: AppStrings.txtWorkLocation,
        child: AppTextField(
            controller: _provider.workLocationCtrl, hint: AppStrings.txtWorkLocation),
      ),
      _field(
        label: AppStrings.txtAnnualIncome,
        child: AppTextField(
          controller: _provider.annualIncomeCtrl,
          hint: 'e.g. 800000',
          inputType: TextInputType.number,
        ),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 6. FAMILY
  // ---------------------------------------------------------------------------
  Widget _familySection(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _grid([
          _field(
            label: AppStrings.txtFatherName,
            child: AppTextField(controller: _provider.fatherNameCtrl, hint: AppStrings.txtFatherName),
          ),
          _field(
            label: AppStrings.txtFatherOccupation,
            child: AppTextField(
                controller: _provider.fatherOccupationCtrl, hint: AppStrings.txtFatherOccupation),
          ),
          _field(
            label: AppStrings.txtMotherName,
            child: AppTextField(controller: _provider.motherNameCtrl, hint: AppStrings.txtMotherName),
          ),
          _field(
            label: AppStrings.txtMotherOccupation,
            child: AppTextField(
                controller: _provider.motherOccupationCtrl, hint: AppStrings.txtMotherOccupation),
          ),
          _field(
            label: AppStrings.txtFamilyType,
            child: AppDropdown<String>(
              value: _provider.familyType,
              items: _provider.familyTypeOptions,
              onChanged: _provider.setFamilyType,
            ),
          ),
          _field(
            label: AppStrings.txtFamilyStatus,
            child: AppDropdown<String>(
              value: _provider.familyStatus,
              items: _provider.familyStatusOptions,
              onChanged: _provider.setFamilyStatus,
            ),
          ),
          _field(
            label: AppStrings.txtFamilyValues,
            child: AppDropdown<String>(
              value: _provider.familyValues,
              items: _provider.familyValuesOptions,
              onChanged: _provider.setFamilyValues,
            ),
          ),
        ], isWeb: isWeb),
        hSpace(24),
        _siblingsEditor(),
      ],
    );
  }

  Widget _siblingsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextFieldTitle(
              text: AppStrings.txtSiblings,
              textStyle: AppTextStyle.black(14, FontWeight.w600),
            ),
            TextButton.icon(
              onPressed: _provider.addSibling,
              icon: Icon(Icons.add, size: 18, color: AppColors.primaryColor),
              label: Text(AppStrings.txtAddSibling,
                  style: AppTextStyle.primary(13, FontWeight.w600)),
            ),
          ],
        ),
        for (int i = 0; i < _provider.siblings.length; i++) _siblingRow(i),
      ],
    );
  }

  Widget _siblingRow(int index) {
    final sibling = _provider.siblings[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppDropdown<String>(
              value: sibling.relationship,
              items: _provider.siblingRelationshipOptions,
              hint: 'Relationship',
              onChanged: (v) => _provider.updateSibling(index, relationship: v),
            ),
          ),
          wSpace(12),
          Expanded(
            child: AppDropdown<String>(
              value: sibling.maritalStatus,
              items: _provider.siblingMaritalStatusOptions,
              hint: 'Marital Status',
              onChanged: (v) => _provider.updateSibling(index, maritalStatus: v),
            ),
          ),
          wSpace(8),
          IconButton(
            onPressed: () => _provider.removeSibling(index),
            icon: const Icon(Icons.delete_outline, color: AppColors.red),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 7. RELIGION / COMMUNITY
  // ---------------------------------------------------------------------------
  Widget _religionSection(bool isWeb) {
    return _grid([
      _field(
        label: AppStrings.txtReligion,
        child: AppTextField(controller: _provider.religionCtrl, hint: AppStrings.txtReligion),
      ),
      _field(
        label: AppStrings.txtCommunity,
        child: AppTextField(controller: _provider.communityCtrl, hint: AppStrings.txtCommunity),
      ),
      _field(
        label: AppStrings.txtSubCommunity,
        child: AppTextField(
            controller: _provider.subCommunityCtrl, hint: AppStrings.txtSubCommunity),
      ),
      _field(
        label: AppStrings.txtMotherTongue,
        child: AppTextField(
            controller: _provider.motherTongueCtrl, hint: AppStrings.txtMotherTongue),
      ),
    ], isWeb: isWeb);
  }

  // ---------------------------------------------------------------------------
  // 8. LIFESTYLE
  // ---------------------------------------------------------------------------
  Widget _lifestyleSection(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _grid([
          _field(
            label: AppStrings.txtDiet,
            child: AppDropdown<String>(
              value: _provider.diet,
              items: _provider.dietOptions,
              onChanged: _provider.setDiet,
            ),
          ),
          _field(
            label: AppStrings.txtSmoking,
            child: AppDropdown<String>(
              value: _provider.smoking,
              items: _provider.habitOptions,
              onChanged: _provider.setSmoking,
            ),
          ),
          _field(
            label: AppStrings.txtDrinking,
            child: AppDropdown<String>(
              value: _provider.drinking,
              items: _provider.habitOptions,
              onChanged: _provider.setDrinking,
            ),
          ),
        ], isWeb: isWeb),
        hSpace(20),
        _field(
          label: AppStrings.txtHobbies,
          child: AppTagInput(
            values: _provider.hobbies,
            onChanged: _provider.setHobbies,
            hint: 'e.g. Reading, Traveling',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtInterests,
          child: AppTagInput(
            values: _provider.interests,
            onChanged: _provider.setInterests,
            hint: 'e.g. Music, Cooking',
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 9. ABOUT
  // ---------------------------------------------------------------------------
  Widget _aboutSection(bool isWeb) {
    return _field(
      label: AppStrings.txtAboutMe,
      child: AppTextField(
        controller: _provider.aboutCtrl,
        hint: AppStrings.txtAboutMeHint,
        maxLines: 6,
        maxLength: 500,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 10. PHOTOS
  // ---------------------------------------------------------------------------
  Widget _photosSection(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFieldTitle(
          text: AppStrings.txtProfilePhoto,
          textStyle: AppTextStyle.black(14, FontWeight.w600),
        ),
        hSpace(10),
        _profilePhotoPicker(),
        hSpace(28),
        AppTextFieldTitle(
          text: AppStrings.txtGalleryPhotos,
          textStyle: AppTextStyle.black(14, FontWeight.w600),
        ),
        hSpace(10),
        _galleryGrid(),
      ],
    );
  }

  Widget _profilePhotoPicker() {
    return GestureDetector(
      onTap: _onPickProfilePhoto,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _provider.profilePhoto == null || _provider.profilePhoto!.isEmpty
                ? Container(
                    height: 110,
                    width: 110,
                    color: AppColors.softPink,
                    child: Icon(Icons.person, size: 50, color: AppColors.primaryColor),
                  )
                : Base64ImageContainer(
                    height: 110,
                    width: 110,
                    base64Image: _provider.profilePhoto!,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.camera_alt, size: 16, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _galleryGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (int i = 0; i < _provider.photos.length; i++) _galleryTile(i),
        _addPhotoTile(),
      ],
    );
  }

  Widget _galleryTile(int index) {
    final String photo = _provider.photos[index];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Base64ImageContainer(height: 90, width: 90, base64Image: photo),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: IconButton(
            icon: const Icon(Icons.cancel, size: 20, color: AppColors.red),
            onPressed: () => _provider.removeGalleryPhoto(photo),
          ),
        ),
      ],
    );
  }

  Widget _addPhotoTile() {
    return GestureDetector(
      onTap: _onPickGalleryPhoto,
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(Icons.add_photo_alternate_outlined, color: AppColors.grey),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 11. PARTNER PREFERENCES
  // ---------------------------------------------------------------------------
  Widget _partnerPrefSection(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          label:
              '${AppStrings.txtPreferredAgeRange}: ${_provider.preferredAgeRange.start.round()} - ${_provider.preferredAgeRange.end.round()} yrs',
          child: RangeSlider(
            values: _provider.preferredAgeRange,
            min: 18,
            max: 70,
            divisions: 52,
            activeColor: AppColors.primaryColor,
            labels: RangeLabels(
              _provider.preferredAgeRange.start.round().toString(),
              _provider.preferredAgeRange.end.round().toString(),
            ),
            onChanged: _provider.setPreferredAgeRange,
          ),
        ),
        hSpace(12),
        _field(
          label:
              '${AppStrings.txtPreferredHeightRange}: ${_provider.preferredHeightRange.start.round()} - ${_provider.preferredHeightRange.end.round()} cm',
          child: RangeSlider(
            values: _provider.preferredHeightRange,
            min: 120,
            max: 210,
            divisions: 90,
            activeColor: AppColors.primaryColor,
            labels: RangeLabels(
              _provider.preferredHeightRange.start.round().toString(),
              _provider.preferredHeightRange.end.round().toString(),
            ),
            onChanged: _provider.setPreferredHeightRange,
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredMaritalStatus,
          child: AppMultiSelectChips(
            options: _provider.maritalStatusOptions,
            selected: _provider.preferredMaritalStatus,
            onChanged: _provider.setPreferredMaritalStatus,
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredDiet,
          child: AppMultiSelectChips(
            options: _provider.dietOptions,
            selected: _provider.preferredDiet,
            onChanged: _provider.setPreferredDiet,
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredSmoking,
          child: AppMultiSelectChips(
            options: _provider.habitOptions,
            selected: _provider.preferredSmoking,
            onChanged: _provider.setPreferredSmoking,
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredDrinking,
          child: AppMultiSelectChips(
            options: _provider.habitOptions,
            selected: _provider.preferredDrinking,
            onChanged: _provider.setPreferredDrinking,
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredReligion,
          child: AppTagInput(
            values: _provider.preferredReligion,
            onChanged: _provider.setPreferredReligion,
            hint: 'e.g. Hindu, Christian',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredCommunity,
          child: AppTagInput(
            values: _provider.preferredCommunity,
            onChanged: _provider.setPreferredCommunity,
            hint: 'e.g. Nair, Iyer',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredEducation,
          child: AppTagInput(
            values: _provider.preferredEducation,
            onChanged: _provider.setPreferredEducation,
            hint: 'e.g. B.Tech, MBA',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredOccupation,
          child: AppTagInput(
            values: _provider.preferredOccupation,
            onChanged: _provider.setPreferredOccupation,
            hint: 'e.g. Engineer, Doctor',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPreferredLocation,
          child: AppTagInput(
            values: _provider.preferredLocation,
            onChanged: _provider.setPreferredLocation,
            hint: 'e.g. Chennai, Coimbatore',
          ),
        ),
        hSpace(20),
        _field(
          label: AppStrings.txtPartnerAbout,
          child: AppTextField(
            controller: _provider.partnerAboutCtrl,
            hint: AppStrings.txtPartnerAboutHint,
            maxLines: 5,
            maxLength: 500,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE BUTTON
  // ---------------------------------------------------------------------------
  Widget _saveButton() {
    return AppButton(
      title: AppStrings.txtSaveProfile,
      enabled: !_provider.isSaving,
      onTap: _onSave,
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  Future<void> _onPickDob() async {
    hideKeyboard();
    final DateTime? picked = await pickDateOfBirth(
      context,
      initialDate: _provider.dob ?? DateTime(1995, 1, 1),
    );
    if (picked == null) return;
    _provider.setDob(picked);
  }

  Future<void> _onPickProfilePhoto() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    _provider.setProfilePhoto(base64Encode(bytes));
  }

  Future<void> _onPickGalleryPhoto() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    _provider.addGalleryPhoto(base64Encode(bytes));
  }

  Future<void> _onSave() async {
    hideKeyboard();
    await _provider.updateProfile();
  }
}


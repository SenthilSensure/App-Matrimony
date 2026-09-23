import 'package:flutter/material.dart';
import '../../base/base_provider.dart';
import '../../model/profile/profile_model.dart';
import '../../utils/constants/app_messages.dart';
import '../../utils/constants/app_strings.dart';

class ProfileProvider extends BaseProvider {
  // =========================
  // BASIC INFORMATION
  // =========================
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  String? gender;
  DateTime? dob;
  String? profileCreatedFor;
  String? maritalStatus;

  // =========================
  // LOCATION
  // =========================
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController(text: 'India');
  final TextEditingController pincodeCtrl = TextEditingController();

  // =========================
  // PHYSICAL INFORMATION
  // =========================
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  String? bodyType;
  String? complexion;
  String? physicalStatus = 'Normal';

  // =========================
  // EDUCATION
  // =========================
  final TextEditingController educationCtrl = TextEditingController();
  final TextEditingController educationDetailsCtrl = TextEditingController();
  final TextEditingController collegeCtrl = TextEditingController();

  // =========================
  // CAREER
  // =========================
  final TextEditingController occupationCtrl = TextEditingController();
  final TextEditingController jobTitleCtrl = TextEditingController();
  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController workLocationCtrl = TextEditingController();
  final TextEditingController annualIncomeCtrl = TextEditingController();

  // =========================
  // FAMILY
  // =========================
  final TextEditingController fatherNameCtrl = TextEditingController();
  final TextEditingController fatherOccupationCtrl = TextEditingController();
  final TextEditingController motherNameCtrl = TextEditingController();
  final TextEditingController motherOccupationCtrl = TextEditingController();
  List<Sibling> siblings = [];
  String? familyType;
  String? familyStatus;
  String? familyValues;

  // =========================
  // RELIGION / COMMUNITY
  // =========================
  final TextEditingController religionCtrl = TextEditingController();
  final TextEditingController communityCtrl = TextEditingController();
  final TextEditingController subCommunityCtrl = TextEditingController();
  final TextEditingController motherTongueCtrl = TextEditingController();

  // =========================
  // LIFESTYLE
  // =========================
  String? diet;
  String? smoking;
  String? drinking;
  List<String> hobbies = [];
  List<String> interests = [];

  // =========================
  // ABOUT
  // =========================
  final TextEditingController aboutCtrl = TextEditingController();

  // =========================
  // PHOTOS
  // =========================
  String? profilePhoto;
  List<String> photos = [];

  // =========================
  // PARTNER PREFERENCES
  // =========================
  RangeValues preferredAgeRange = const RangeValues(21, 35);
  RangeValues preferredHeightRange = const RangeValues(150, 185);
  List<String> preferredMaritalStatus = [];
  List<String> preferredReligion = [];
  List<String> preferredCommunity = [];
  List<String> preferredEducation = [];
  List<String> preferredOccupation = [];
  List<String> preferredLocation = [];
  List<String> preferredDiet = [];
  List<String> preferredSmoking = [];
  List<String> preferredDrinking = [];
  final TextEditingController partnerAboutCtrl = TextEditingController();

  // =========================
  // STATE FLAGS
  // =========================
  bool isLoading = false;
  bool isSaving = false;

  // =========================
  // OPTION LISTS
  // =========================
  final List<String> genderOptions = const [
    AppStrings.txtMale,
    AppStrings.txtFemale,
    AppStrings.txtOther,
  ];

  final List<String> profileCreatedForOptions = const [
    'Self',
    'Parent',
    'Sibling',
    'Relative',
  ];

  final List<String> maritalStatusOptions = const [
    'Never Married',
    'Divorced',
    'Widowed',
    'Separated',
  ];

  final List<String> bodyTypeOptions = const [
    'Slim',
    'Athletic',
    'Average',
    'Heavy',
  ];

  final List<String> complexionOptions = const [
    'Fair',
    'Wheatish',
    'Dark',
  ];

  final List<String> physicalStatusOptions = const [
    'Normal',
    'Physically Challenged',
  ];

  final List<String> familyTypeOptions = const [
    'Nuclear',
    'Joint',
  ];

  final List<String> familyStatusOptions = const [
    'Middle Class',
    'Upper Middle Class',
    'Rich',
    'Affluent',
  ];

  final List<String> familyValuesOptions = const [
    'Traditional',
    'Moderate',
    'Liberal',
  ];

  final List<String> dietOptions = const [
    'Vegetarian',
    'Non-Vegetarian',
    'Eggetarian',
    'Vegan',
  ];

  final List<String> habitOptions = const [
    'No',
    'Occasionally',
    'Yes',
  ];

  final List<String> siblingRelationshipOptions = const [
    'Brother',
    'Sister',
  ];

  final List<String> siblingMaritalStatusOptions = const [
    'Married',
    'Unmarried',
  ];

  // =========================
  // SETTERS
  // =========================
  void setGender(String? value) {
    gender = value;
    notifyListeners();
  }

  void setDob(DateTime value) {
    dob = value;
    dobCtrl.text = '${_two(value.day)}/${_two(value.month)}/${value.year}';
    notifyListeners();
  }

  void setProfileCreatedFor(String? value) {
    profileCreatedFor = value;
    notifyListeners();
  }

  void setMaritalStatus(String? value) {
    maritalStatus = value;
    notifyListeners();
  }

  void setBodyType(String? value) {
    bodyType = value;
    notifyListeners();
  }

  void setComplexion(String? value) {
    complexion = value;
    notifyListeners();
  }

  void setPhysicalStatus(String? value) {
    physicalStatus = value;
    notifyListeners();
  }

  void setFamilyType(String? value) {
    familyType = value;
    notifyListeners();
  }

  void setFamilyStatus(String? value) {
    familyStatus = value;
    notifyListeners();
  }

  void setFamilyValues(String? value) {
    familyValues = value;
    notifyListeners();
  }

  void setDiet(String? value) {
    diet = value;
    notifyListeners();
  }

  void setSmoking(String? value) {
    smoking = value;
    notifyListeners();
  }

  void setDrinking(String? value) {
    drinking = value;
    notifyListeners();
  }

  void setHobbies(List<String> value) {
    hobbies = value;
    notifyListeners();
  }

  void setInterests(List<String> value) {
    interests = value;
    notifyListeners();
  }

  void setPreferredAgeRange(RangeValues value) {
    preferredAgeRange = value;
    notifyListeners();
  }

  void setPreferredHeightRange(RangeValues value) {
    preferredHeightRange = value;
    notifyListeners();
  }

  void setPreferredMaritalStatus(List<String> value) {
    preferredMaritalStatus = value;
    notifyListeners();
  }

  void setPreferredReligion(List<String> value) {
    preferredReligion = value;
    notifyListeners();
  }

  void setPreferredCommunity(List<String> value) {
    preferredCommunity = value;
    notifyListeners();
  }

  void setPreferredEducation(List<String> value) {
    preferredEducation = value;
    notifyListeners();
  }

  void setPreferredOccupation(List<String> value) {
    preferredOccupation = value;
    notifyListeners();
  }

  void setPreferredLocation(List<String> value) {
    preferredLocation = value;
    notifyListeners();
  }

  void setPreferredDiet(List<String> value) {
    preferredDiet = value;
    notifyListeners();
  }

  void setPreferredSmoking(List<String> value) {
    preferredSmoking = value;
    notifyListeners();
  }

  void setPreferredDrinking(List<String> value) {
    preferredDrinking = value;
    notifyListeners();
  }

  // Siblings management
  void addSibling() {
    siblings = [...siblings, Sibling(relationship: 'Brother', maritalStatus: 'Unmarried')];
    notifyListeners();
  }

  void updateSibling(int index, {String? relationship, String? maritalStatus}) {
    if (index < 0 || index >= siblings.length) return;
    if (relationship != null) siblings[index].relationship = relationship;
    if (maritalStatus != null) siblings[index].maritalStatus = maritalStatus;
    notifyListeners();
  }

  void removeSibling(int index) {
    if (index < 0 || index >= siblings.length) return;
    siblings = List.of(siblings)..removeAt(index);
    notifyListeners();
  }

  // Photos (placeholder — wire to image_picker + upload API later)
  void setProfilePhoto(String base64OrUrl) {
    profilePhoto = base64OrUrl;
    notifyListeners();
  }

  void addGalleryPhoto(String base64OrUrl) {
    photos = [...photos, base64OrUrl];
    notifyListeners();
  }

  void removeGalleryPhoto(String value) {
    photos = photos.where((e) => e != value).toList();
    notifyListeners();
  }

  // =========================
  // HELPERS
  // =========================
  String _two(int value) => value.toString().padLeft(2, '0');

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  /// Populates all controllers/state from a fetched [ProfileModel].
  void _applyProfile(ProfileModel p) {
    nameCtrl.text = p.name ?? '';
    gender = p.gender;
    dob = p.dob;
    if (p.dob != null) {
      dobCtrl.text = '${_two(p.dob!.day)}/${_two(p.dob!.month)}/${p.dob!.year}';
    }
    profileCreatedFor = p.profileCreatedFor;
    maritalStatus = p.maritalStatus;

    cityCtrl.text = p.city ?? '';
    stateCtrl.text = p.state ?? '';
    countryCtrl.text = p.country ?? 'India';
    pincodeCtrl.text = p.pincode ?? '';

    heightCtrl.text = p.height?.toString() ?? '';
    weightCtrl.text = p.weight?.toString() ?? '';
    bodyType = p.bodyType;
    complexion = p.complexion;
    physicalStatus = p.physicalStatus ?? 'Normal';

    educationCtrl.text = p.education ?? '';
    educationDetailsCtrl.text = p.educationDetails ?? '';
    collegeCtrl.text = p.college ?? '';

    occupationCtrl.text = p.occupation ?? '';
    jobTitleCtrl.text = p.jobTitle ?? '';
    companyCtrl.text = p.company ?? '';
    workLocationCtrl.text = p.workLocation ?? '';
    annualIncomeCtrl.text = p.annualIncome?.toString() ?? '';

    fatherNameCtrl.text = p.fatherName ?? '';
    fatherOccupationCtrl.text = p.fatherOccupation ?? '';
    motherNameCtrl.text = p.motherName ?? '';
    motherOccupationCtrl.text = p.motherOccupation ?? '';
    siblings = p.siblings;
    familyType = p.familyType;
    familyStatus = p.familyStatus;
    familyValues = p.familyValues;

    religionCtrl.text = p.religion ?? '';
    communityCtrl.text = p.community ?? '';
    subCommunityCtrl.text = p.subCommunity ?? '';
    motherTongueCtrl.text = p.motherTongue ?? '';

    diet = p.diet;
    smoking = p.smoking;
    drinking = p.drinking;
    hobbies = p.hobbies;
    interests = p.interests;

    aboutCtrl.text = p.about ?? '';

    profilePhoto = p.profilePhoto;
    photos = p.photos;

    preferredAgeRange = RangeValues(
      (p.preferredAgeMin ?? 21).toDouble(),
      (p.preferredAgeMax ?? 35).toDouble(),
    );
    preferredHeightRange = RangeValues(
      (p.preferredHeightMin ?? 150).toDouble(),
      (p.preferredHeightMax ?? 185).toDouble(),
    );
    preferredMaritalStatus = p.preferredMaritalStatus;
    preferredReligion = p.preferredReligion;
    preferredCommunity = p.preferredCommunity;
    preferredEducation = p.preferredEducation;
    preferredOccupation = p.preferredOccupation;
    preferredLocation = p.preferredLocation;
    preferredDiet = p.preferredDiet;
    preferredSmoking = p.preferredSmoking;
    preferredDrinking = p.preferredDrinking;
    partnerAboutCtrl.text = p.partnerAbout ?? '';
  }

  /// Builds the payload sent to `updateProfile`.
  Map<String, dynamic> _buildPayload() {
    return {
      "name": nameCtrl.text.trim(),
      "gender": gender,
      "dob": dob == null
          ? null
          : '${dob!.year}-${_two(dob!.month)}-${_two(dob!.day)}',
      "profileCreatedFor": profileCreatedFor,
      "maritalStatus": maritalStatus,
      "city": cityCtrl.text.trim(),
      "state": stateCtrl.text.trim(),
      "country": countryCtrl.text.trim(),
      "pincode": pincodeCtrl.text.trim(),
      "height": num.tryParse(heightCtrl.text.trim()),
      "weight": num.tryParse(weightCtrl.text.trim()),
      "bodyType": bodyType,
      "complexion": complexion,
      "physicalStatus": physicalStatus,
      "education": educationCtrl.text.trim(),
      "educationDetails": educationDetailsCtrl.text.trim(),
      "college": collegeCtrl.text.trim(),
      "occupation": occupationCtrl.text.trim(),
      "jobTitle": jobTitleCtrl.text.trim(),
      "company": companyCtrl.text.trim(),
      "workLocation": workLocationCtrl.text.trim(),
      "annualIncome": num.tryParse(annualIncomeCtrl.text.trim()),
      "fatherName": fatherNameCtrl.text.trim(),
      "fatherOccupation": fatherOccupationCtrl.text.trim(),
      "motherName": motherNameCtrl.text.trim(),
      "motherOccupation": motherOccupationCtrl.text.trim(),
      "siblings": siblings.map((e) => e.toJson()).toList(),
      "familyType": familyType,
      "familyStatus": familyStatus,
      "familyValues": familyValues,
      "religion": religionCtrl.text.trim(),
      "community": communityCtrl.text.trim(),
      "subCommunity": subCommunityCtrl.text.trim(),
      "motherTongue": motherTongueCtrl.text.trim(),
      "diet": diet,
      "smoking": smoking,
      "drinking": drinking,
      "hobbies": hobbies,
      "interests": interests,
      "about": aboutCtrl.text.trim(),
      "profilePhoto": profilePhoto,
      "photos": photos,
      "preferredAgeMin": preferredAgeRange.start.round(),
      "preferredAgeMax": preferredAgeRange.end.round(),
      "preferredHeightMin": preferredHeightRange.start.round(),
      "preferredHeightMax": preferredHeightRange.end.round(),
      "preferredMaritalStatus": preferredMaritalStatus,
      "preferredReligion": preferredReligion,
      "preferredCommunity": preferredCommunity,
      "preferredEducation": preferredEducation,
      "preferredOccupation": preferredOccupation,
      "preferredLocation": preferredLocation,
      "preferredDiet": preferredDiet,
      "preferredSmoking": preferredSmoking,
      "preferredDrinking": preferredDrinking,
      "partnerAbout": partnerAboutCtrl.text.trim(),
    };
  }

  // =========================
  // API
  // =========================

  /// Fetches the logged-in user's profile and populates all fields.
  Future<void> getProfileDetails() async {
    _setLoading(true);

    final result = await authRepo.getProfileDetails();

    result.fold(
      (failure) {
        errorToast(failure.toString());
      },
      (profile) {
        _applyProfile(profile);
      },
    );

    _setLoading(false);
  }

  /// Saves the current form state to the backend.
  Future<bool> updateProfile() async {
    _setSaving(true);
    showLoading();

    final result = await authRepo.updateProfile(_buildPayload());

    hideLoading();
    _setSaving(false);

    return result.fold(
      (failure) {
        errorToast(failure.toString());
        return false;
      },
      (profile) {
        _applyProfile(profile);
        successToast(AppStrings.msgProfileUpdated);
        return true;
      },
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    dobCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    pincodeCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    educationCtrl.dispose();
    educationDetailsCtrl.dispose();
    collegeCtrl.dispose();
    occupationCtrl.dispose();
    jobTitleCtrl.dispose();
    companyCtrl.dispose();
    workLocationCtrl.dispose();
    annualIncomeCtrl.dispose();
    fatherNameCtrl.dispose();
    fatherOccupationCtrl.dispose();
    motherNameCtrl.dispose();
    motherOccupationCtrl.dispose();
    religionCtrl.dispose();
    communityCtrl.dispose();
    subCommunityCtrl.dispose();
    motherTongueCtrl.dispose();
    aboutCtrl.dispose();
    partnerAboutCtrl.dispose();
    super.dispose();
  }
}


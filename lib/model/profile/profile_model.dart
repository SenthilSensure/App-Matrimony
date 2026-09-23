import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class Sibling {
  String? relationship; // Brother / Sister
  String? maritalStatus; // Married / Unmarried

  Sibling({this.relationship, this.maritalStatus});

  factory Sibling.fromJson(Map<String, dynamic> json) => Sibling(
        relationship: json['relationship'],
        maritalStatus: json['maritalStatus'],
      );

  Map<String, dynamic> toJson() => {
        'relationship': relationship,
        'maritalStatus': maritalStatus,
      };
}

class ProfileModel {
  String? userId;

  // Basic information
  String? name;
  String? gender;
  DateTime? dob;
  String? profileCreatedFor;
  String? maritalStatus;

  // Location
  String? city;
  String? state;
  String? country;
  String? pincode;

  // Physical information
  num? height;
  num? weight;
  String? bodyType;
  String? complexion;
  String? physicalStatus;

  // Education
  String? education;
  String? educationDetails;
  String? college;

  // Career
  String? occupation;
  String? jobTitle;
  String? company;
  String? workLocation;
  num? annualIncome;

  // Family
  String? fatherName;
  String? fatherOccupation;
  String? motherName;
  String? motherOccupation;
  List<Sibling> siblings;
  String? familyType;
  String? familyStatus;
  String? familyValues;

  // Religion / community
  String? religion;
  String? community;
  String? subCommunity;
  String? motherTongue;

  // Lifestyle
  String? diet;
  String? smoking;
  String? drinking;
  List<String> hobbies;
  List<String> interests;

  // About
  String? about;

  // Photos
  String? profilePhoto;
  List<String> photos;

  // Partner preferences
  num? preferredAgeMin;
  num? preferredAgeMax;
  num? preferredHeightMin;
  num? preferredHeightMax;
  List<String> preferredMaritalStatus;
  List<String> preferredReligion;
  List<String> preferredCommunity;
  List<String> preferredEducation;
  List<String> preferredOccupation;
  List<String> preferredLocation;
  List<String> preferredDiet;
  List<String> preferredSmoking;
  List<String> preferredDrinking;
  String? partnerAbout;

  ProfileModel({
    this.userId,
    this.name,
    this.gender,
    this.dob,
    this.profileCreatedFor,
    this.maritalStatus,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.height,
    this.weight,
    this.bodyType,
    this.complexion,
    this.physicalStatus,
    this.education,
    this.educationDetails,
    this.college,
    this.occupation,
    this.jobTitle,
    this.company,
    this.workLocation,
    this.annualIncome,
    this.fatherName,
    this.fatherOccupation,
    this.motherName,
    this.motherOccupation,
    List<Sibling>? siblings,
    this.familyType,
    this.familyStatus,
    this.familyValues,
    this.religion,
    this.community,
    this.subCommunity,
    this.motherTongue,
    this.diet,
    this.smoking,
    this.drinking,
    List<String>? hobbies,
    List<String>? interests,
    this.about,
    this.profilePhoto,
    List<String>? photos,
    this.preferredAgeMin,
    this.preferredAgeMax,
    this.preferredHeightMin,
    this.preferredHeightMax,
    List<String>? preferredMaritalStatus,
    List<String>? preferredReligion,
    List<String>? preferredCommunity,
    List<String>? preferredEducation,
    List<String>? preferredOccupation,
    List<String>? preferredLocation,
    List<String>? preferredDiet,
    List<String>? preferredSmoking,
    List<String>? preferredDrinking,
    this.partnerAbout,
  })  : siblings = siblings ?? [],
        hobbies = hobbies ?? [],
        interests = interests ?? [],
        photos = photos ?? [],
        preferredMaritalStatus = preferredMaritalStatus ?? [],
        preferredReligion = preferredReligion ?? [],
        preferredCommunity = preferredCommunity ?? [],
        preferredEducation = preferredEducation ?? [],
        preferredOccupation = preferredOccupation ?? [],
        preferredLocation = preferredLocation ?? [],
        preferredDiet = preferredDiet ?? [],
        preferredSmoking = preferredSmoking ?? [],
        preferredDrinking = preferredDrinking ?? [];

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userId: json['userId'],
        name: json['name'],
        gender: json['gender'],
        dob: _parseDate(json['dob']),
        profileCreatedFor: json['profileCreatedFor'],
        maritalStatus: json['maritalStatus'],
        city: json['city'],
        state: json['state'],
        country: json['country'] ?? 'India',
        pincode: json['pincode'],
        height: json['height'],
        weight: json['weight'],
        bodyType: json['bodyType'],
        complexion: json['complexion'],
        physicalStatus: json['physicalStatus'] ?? 'Normal',
        education: json['education'],
        educationDetails: json['educationDetails'],
        college: json['college'],
        occupation: json['occupation'],
        jobTitle: json['jobTitle'],
        company: json['company'],
        workLocation: json['workLocation'],
        annualIncome: json['annualIncome'],
        fatherName: json['fatherName'],
        fatherOccupation: json['fatherOccupation'],
        motherName: json['motherName'],
        motherOccupation: json['motherOccupation'],
        siblings: (json['siblings'] as List<dynamic>?)
                ?.map((e) => Sibling.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        familyType: json['familyType'],
        familyStatus: json['familyStatus'],
        familyValues: json['familyValues'],
        religion: json['religion'],
        community: json['community'],
        subCommunity: json['subCommunity'],
        motherTongue: json['motherTongue'],
        diet: json['diet'],
        smoking: json['smoking'],
        drinking: json['drinking'],
        hobbies: _stringList(json['hobbies']),
        interests: _stringList(json['interests']),
        about: json['about'],
        profilePhoto: json['profilePhoto'],
        photos: _stringList(json['photos']),
        preferredAgeMin: json['preferredAgeMin'],
        preferredAgeMax: json['preferredAgeMax'],
        preferredHeightMin: json['preferredHeightMin'],
        preferredHeightMax: json['preferredHeightMax'],
        preferredMaritalStatus: _stringList(json['preferredMaritalStatus']),
        preferredReligion: _stringList(json['preferredReligion']),
        preferredCommunity: _stringList(json['preferredCommunity']),
        preferredEducation: _stringList(json['preferredEducation']),
        preferredOccupation: _stringList(json['preferredOccupation']),
        preferredLocation: _stringList(json['preferredLocation']),
        preferredDiet: _stringList(json['preferredDiet']),
        preferredSmoking: _stringList(json['preferredSmoking']),
        preferredDrinking: _stringList(json['preferredDrinking']),
        partnerAbout: json['partnerAbout'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'gender': gender,
        'dob': dob?.toIso8601String(),
        'profileCreatedFor': profileCreatedFor,
        'maritalStatus': maritalStatus,
        'city': city,
        'state': state,
        'country': country,
        'pincode': pincode,
        'height': height,
        'weight': weight,
        'bodyType': bodyType,
        'complexion': complexion,
        'physicalStatus': physicalStatus,
        'education': education,
        'educationDetails': educationDetails,
        'college': college,
        'occupation': occupation,
        'jobTitle': jobTitle,
        'company': company,
        'workLocation': workLocation,
        'annualIncome': annualIncome,
        'fatherName': fatherName,
        'fatherOccupation': fatherOccupation,
        'motherName': motherName,
        'motherOccupation': motherOccupation,
        'siblings': siblings.map((e) => e.toJson()).toList(),
        'familyType': familyType,
        'familyStatus': familyStatus,
        'familyValues': familyValues,
        'religion': religion,
        'community': community,
        'subCommunity': subCommunity,
        'motherTongue': motherTongue,
        'diet': diet,
        'smoking': smoking,
        'drinking': drinking,
        'hobbies': hobbies,
        'interests': interests,
        'about': about,
        'profilePhoto': profilePhoto,
        'photos': photos,
        'preferredAgeMin': preferredAgeMin,
        'preferredAgeMax': preferredAgeMax,
        'preferredHeightMin': preferredHeightMin,
        'preferredHeightMax': preferredHeightMax,
        'preferredMaritalStatus': preferredMaritalStatus,
        'preferredReligion': preferredReligion,
        'preferredCommunity': preferredCommunity,
        'preferredEducation': preferredEducation,
        'preferredOccupation': preferredOccupation,
        'preferredLocation': preferredLocation,
        'preferredDiet': preferredDiet,
        'preferredSmoking': preferredSmoking,
        'preferredDrinking': preferredDrinking,
        'partnerAbout': partnerAbout,
      };
}


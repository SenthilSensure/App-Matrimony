class ProfileRes {
  bool? success;
  String? message;
  User? user;
  Profile? profile;

  ProfileRes({this.success, this.message, this.user, this.profile});

  ProfileRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? email;
  String? mobileNumber;
  bool? isActive;

  User({this.userId, this.email, this.mobileNumber, this.isActive});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['isActive'] = isActive;
    return data;
  }
}

class Profile {
  String? sId;
  String? userId;
  String? name;
  String? gender;
  String? dob;
  String? profileCreatedFor;
  String? maritalStatus;
  String? city;
  String? state;
  String? country;
  String? pincode;
  int? height;
  int? weight;
  String? bodyType;
  String? complexion;
  String? physicalStatus;
  String? education;
  String? educationDetails;
  String? college;
  String? occupation;
  String? jobTitle;
  String? company;
  String? workLocation;
  int? annualIncome;
  String? fatherName;
  String? fatherOccupation;
  String? motherName;
  String? motherOccupation;
  List<Siblings>? siblings;
  String? familyType;
  String? familyStatus;
  String? familyValues;
  String? religion;
  String? community;
  String? subCommunity;
  String? motherTongue;
  String? diet;
  String? smoking;
  String? drinking;
  List<String>? hobbies;
  List<String>? interests;
  String? about;
  String? profilePhoto;
  List<String>? photos;
  int? preferredAgeMin;
  int? preferredAgeMax;
  int? preferredHeightMin;
  int? preferredHeightMax;
  List<String>? preferredMaritalStatus;
  List<String>? preferredReligion;
  List<String>? preferredCommunity;
  List<String>? preferredEducation;
  List<String>? preferredOccupation;
  List<String>? preferredLocation;
  List<String>? preferredDiet;
  List<String>? preferredSmoking;
  List<String>? preferredDrinking;
  String? partnerAbout;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.sId,
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
        this.siblings,
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
        this.hobbies,
        this.interests,
        this.about,
        this.profilePhoto,
        this.photos,
        this.preferredAgeMin,
        this.preferredAgeMax,
        this.preferredHeightMin,
        this.preferredHeightMax,
        this.preferredMaritalStatus,
        this.preferredReligion,
        this.preferredCommunity,
        this.preferredEducation,
        this.preferredOccupation,
        this.preferredLocation,
        this.preferredDiet,
        this.preferredSmoking,
        this.preferredDrinking,
        this.partnerAbout,
        this.createdAt,
        this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    gender = json['gender'];
    dob = json['dob'];
    profileCreatedFor = json['profileCreatedFor'];
    maritalStatus = json['maritalStatus'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    height = json['height'];
    weight = json['weight'];
    bodyType = json['bodyType'];
    complexion = json['complexion'];
    physicalStatus = json['physicalStatus'];
    education = json['education'];
    educationDetails = json['educationDetails'];
    college = json['college'];
    occupation = json['occupation'];
    jobTitle = json['jobTitle'];
    company = json['company'];
    workLocation = json['workLocation'];
    annualIncome = json['annualIncome'];
    fatherName = json['fatherName'];
    fatherOccupation = json['fatherOccupation'];
    motherName = json['motherName'];
    motherOccupation = json['motherOccupation'];
    if (json['siblings'] != null) {
      siblings = <Siblings>[];
      json['siblings'].forEach((v) {
        siblings!.add(Siblings.fromJson(v));
      });
    }
    familyType = json['familyType'];
    familyStatus = json['familyStatus'];
    familyValues = json['familyValues'];
    religion = json['religion'];
    community = json['community'];
    subCommunity = json['subCommunity'];
    motherTongue = json['motherTongue'];
    diet = json['diet'];
    smoking = json['smoking'];
    drinking = json['drinking'];
    hobbies = json['hobbies'].cast<String>();
    interests = json['interests'].cast<String>();
    about = json['about'];
    profilePhoto = json['profilePhoto'];
    photos = json['photos'].cast<String>();
    preferredAgeMin = json['preferredAgeMin'];
    preferredAgeMax = json['preferredAgeMax'];
    preferredHeightMin = json['preferredHeightMin'];
    preferredHeightMax = json['preferredHeightMax'];
    preferredMaritalStatus = json['preferredMaritalStatus'].cast<String>();
    preferredReligion = json['preferredReligion'].cast<String>();
    preferredCommunity = json['preferredCommunity'].cast<String>();
    preferredEducation = json['preferredEducation'].cast<String>();
    preferredOccupation = json['preferredOccupation'].cast<String>();
    preferredLocation = json['preferredLocation'].cast<String>();
    preferredDiet = json['preferredDiet'].cast<String>();
    preferredSmoking = json['preferredSmoking'].cast<String>();
    preferredDrinking = json['preferredDrinking'].cast<String>();
    partnerAbout = json['partnerAbout'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['gender'] = gender;
    data['dob'] = dob;
    data['profileCreatedFor'] = profileCreatedFor;
    data['maritalStatus'] = maritalStatus;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    data['height'] = height;
    data['weight'] = weight;
    data['bodyType'] = bodyType;
    data['complexion'] = complexion;
    data['physicalStatus'] = physicalStatus;
    data['education'] = education;
    data['educationDetails'] = educationDetails;
    data['college'] = college;
    data['occupation'] = occupation;
    data['jobTitle'] = jobTitle;
    data['company'] = company;
    data['workLocation'] = workLocation;
    data['annualIncome'] = annualIncome;
    data['fatherName'] = fatherName;
    data['fatherOccupation'] = fatherOccupation;
    data['motherName'] = motherName;
    data['motherOccupation'] = motherOccupation;
    if (siblings != null) {
      data['siblings'] = siblings!.map((v) => v.toJson()).toList();
    }
    data['familyType'] = familyType;
    data['familyStatus'] = familyStatus;
    data['familyValues'] = familyValues;
    data['religion'] = religion;
    data['community'] = community;
    data['subCommunity'] = subCommunity;
    data['motherTongue'] = motherTongue;
    data['diet'] = diet;
    data['smoking'] = smoking;
    data['drinking'] = drinking;
    data['hobbies'] = hobbies;
    data['interests'] = interests;
    data['about'] = about;
    data['profilePhoto'] = profilePhoto;
    data['photos'] = photos;
    data['preferredAgeMin'] = preferredAgeMin;
    data['preferredAgeMax'] = preferredAgeMax;
    data['preferredHeightMin'] = preferredHeightMin;
    data['preferredHeightMax'] = preferredHeightMax;
    data['preferredMaritalStatus'] = preferredMaritalStatus;
    data['preferredReligion'] = preferredReligion;
    data['preferredCommunity'] = preferredCommunity;
    data['preferredEducation'] = preferredEducation;
    data['preferredOccupation'] = preferredOccupation;
    data['preferredLocation'] = preferredLocation;
    data['preferredDiet'] = preferredDiet;
    data['preferredSmoking'] = preferredSmoking;
    data['preferredDrinking'] = preferredDrinking;
    data['partnerAbout'] = partnerAbout;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Siblings {
  String? relationship;
  String? maritalStatus;

  Siblings({this.relationship, this.maritalStatus});

  Siblings.fromJson(Map<String, dynamic> json) {
    relationship = json['relationship'];
    maritalStatus = json['maritalStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['relationship'] = relationship;
    data['maritalStatus'] = maritalStatus;
    return data;
  }
}

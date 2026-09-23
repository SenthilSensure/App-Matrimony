import 'dart:convert';

LoginRes loginResFromJson(String str) => LoginRes.fromJson(json.decode(str));
String loginResToJson(LoginRes data) => json.encode(data.toJson());

class LoginRes {
  bool? success;
  String? message;
  String? token;
  LoginUser? data;

  LoginRes({this.success, this.message, this.token, this.data});

  LoginRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    // Token may come at the root (`token` / `accessToken`) or inside `data`.
    token = json['token'] ?? json['accessToken'];

    final user = json['data'] ?? json['user'];
    if (user is Map<String, dynamic>) {
      data = LoginUser.fromJson(user);
      token ??= user['token'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['token'] = token;
    map['data'] = data?.toJson();
    return map;
  }
}

class LoginUser {
  String? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? gender;
  String? dob;

  /// Whether the user finished the profile completion wizard.
  bool? isProfileCompleted;

  LoginUser({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.gender,
    this.dob,
    this.isProfileCompleted,
  });

  LoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? json['_id']?.toString();
    name = json['name'];
    email = json['email'];
    mobileNumber =
        (json['mobileNumber'] ?? json['mobileNo'] ?? json['phone'])?.toString();
    gender = json['gender'];
    dob = json['dob'];
    isProfileCompleted =
        json['isProfileCompleted'] ?? json['profileCompleted'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
        'gender': gender,
        'dob': dob,
        'isProfileCompleted': isProfileCompleted,
      };
}

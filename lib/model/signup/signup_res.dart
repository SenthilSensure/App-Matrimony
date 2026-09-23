import 'dart:convert';

SignupRes signupResFromJson(String str) => SignupRes.fromJson(json.decode(str));
String signupResToJson(SignupRes data) => json.encode(data.toJson());

class SignupRes {
  bool? success;
  String? message;

  SignupRes({this.success, this.message});

  SignupRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}

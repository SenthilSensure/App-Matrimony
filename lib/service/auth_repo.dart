import 'package:app_matrimony/model/signup/signup_res.dart';
import 'package:dartz/dartz.dart';
import '../base/base_repo.dart';
import '../model/chat/profile_chat_res.dart';
import '../model/login/login_res.dart';
import '../model/profile/profile_model.dart';
import 'api_methods.dart';
import 'api_urls.dart';

class AuthRepo extends BaseRepo {
  String token() {
    var token = '';
    if(pref.token.isNotEmpty) {
      token = 'Bearer ${pref.token}';
    }
    return token;
  }

  // Signup
  Future<Either<dynamic, SignupRes>> signup(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiSignUp,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = signupResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Login
  Future<Either<dynamic, LoginRes>> login(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiLogin,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = loginResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Verify OTP - returns the session (token + user) on success
  Future<Either<dynamic, LoginRes>> verifyOtp(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiVerifyOtp,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = loginResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Resend OTP
  Future<Either<dynamic, LoginRes>> resendOtp(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiResendOtp,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = loginResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Profile Chat
  Future<Either<dynamic, ProfileChatRes>> profileChat(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiProfileChatMessage,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = profileChatResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get Profile Details
  Future<Either<dynamic, ProfileModel>> getProfileDetails() async {
    try {
      final response = await apiClient.apiClient(
        path: apiGetProfile,
        method: ApiMethod.get,
        header: tokenHeader(token()),
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final res = profileModelFromJson(r.toString());
        return Right(res);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Update Profile
  Future<Either<dynamic, ProfileModel>> updateProfile(
      Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiUpdateProfile,
        method: ApiMethod.post,
        header: tokenHeader(token()),
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final res = profileModelFromJson(r.toString());
        return Right(res);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}

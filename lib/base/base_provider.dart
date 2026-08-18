import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../service/api_client.dart';
import '../service/auth_repo.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_helper.dart';
import '../utils/constants/app_loader.dart';
import '../utils/constants/app_messages.dart';
import '../utils/constants/app_text_style.dart';
import '../utils/di/app_di.dart';
import '../utils/storage/app_preference.dart';

class BaseProvider extends ChangeNotifier {
  AppSharedPref pref = getIt<AppSharedPref>();
  ApiClient api = getIt<ApiClient>();
  AuthRepo authRepo = getIt<AuthRepo>();
  AppHelper appHelper = getIt<AppHelper>();

  // Name Salutation
  List<String> titleOptions = ['Mr.', 'Mrs.', 'Ms.', 'M/s.'];

  // Amount Formatter
  final NumberFormat amtFormat = NumberFormat.decimalPattern('en_IN');

  showLoading() {
    showLoader();
  }

  hideLoading() {
    hideLoader();
  }

  String detectInputType(String input) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final mobileRegex = RegExp(r"^[0-9]{10}$");

    if (emailRegex.hasMatch(input)) {
      return 'E';
    } else if (mobileRegex.hasMatch(input)) {
      return 'M';
    } else {
      // I - invalid
      return 'I';
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Converts Uint8List (e.g., image bytes) to a Base64 string.
  String uint8ListToBase64(Uint8List data) {
    return base64Encode(data);
  }

  /// Converts a Base64 string back to Uint8List.
  Uint8List base64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  void successAlertDialog(
      BuildContext context, String message, String btnText, Function() onNext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: kIsWeb ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
          ),
          margin: kIsWeb
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3)
              : const EdgeInsets.symmetric(horizontal: 40),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: AppColors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.white(16, FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    height: 1,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onNext();
                      },
                      child: Text(
                        btnText,
                        style: AppTextStyle.white(16, FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getFirebaseToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      if (kIsWeb) {
        // 🌐 Web: Firebase popup
        final googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');

        return await firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // 📱 Mobile: google_sign_in ^7.x API
        await GoogleSignIn.instance.initialize();

        final GoogleSignInAccount? googleUser =
            await GoogleSignIn.instance.authenticate(scopeHint: ['email']);

        if (googleUser == null) {
          throw Exception('Google sign-in aborted');
        }

        final googleAuth = googleUser.authentication;

        final authorization = await googleUser.authorizationClient
            .authorizationForScopes(['email']);

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: authorization?.accessToken,
        );

        return await firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In Error: $e');
      }

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception('Account exists with a different sign-in method');
          case 'invalid-credential':
            throw Exception('Invalid Google credentials');
          case 'operation-not-allowed':
            throw Exception('Google sign-in is not enabled');
          case 'user-disabled':
            throw Exception('This account has been disabled');
          case 'web-storage-unsupported':
            throw Exception('Web storage is not supported or disabled');
          default:
            throw Exception('Google sign-in failed: ${e.message}');
        }
      }
      rethrow;
    }
  }

  Future<UserCredential> signInWithApple() async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      if (!kIsWeb && Platform.isIOS) {
        // Native iOS
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        return await firebaseAuth.signInWithCredential(oauthCredential);
      }
      else if (kIsWeb) {
        // Web (must use popup or redirect)
        final provider = OAuthProvider("apple.com");
        provider.addScope('email');
        provider.addScope('name');
        provider.setCustomParameters({'locale': 'en'});

        return await firebaseAuth.signInWithPopup(provider);
        // OR: return await firebaseAuth.signInWithRedirect(provider);
      }
      else {
        // Android (Apple not officially supported but Firebase allows provider flow)
        final provider = OAuthProvider("apple.com");
        provider.addScope('email');
        provider.addScope('name');

        return await firebaseAuth.signInWithProvider(provider);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Apple Sign-In Error: $e');
      }

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception('An account already exists with a different sign-in method');
          case 'invalid-credential':
            throw Exception('Invalid Apple credentials');
          case 'operation-not-allowed':
            throw Exception('Apple sign-in is not enabled');
          case 'user-disabled':
            throw Exception('This account has been disabled');
          case 'web-storage-unsupported':
            throw Exception('Web storage is not supported or disabled');
          default:
            throw Exception('Apple sign-in failed: ${e.message}');
        }
      }

      rethrow;
    }
  }


  Future<SocialUser?> signInWithFacebook() async {
    try {
      final fb = FacebookLogin();

      final res = await fb.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email
        ],
      );

      if (res.status == FacebookLoginStatus.success) {
        final FacebookAccessToken? accessToken = res.accessToken;
        if (accessToken == null) {
          errorToast('Facebook access token is null');
          return null;
        }

        // Create Firebase credential
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        // Sign in to Firebase
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          errorToast('Firebase user is null');
          return null;
        }

        // Get Facebook profile and email
        String? fbName;
        String? fbEmail;

        try {
          final profile = await fb.getUserProfile();
          fbName = profile?.name;
        } catch (e) {
          // Handle profile fetch error silently
          fbName = null;
        }

        try {
          fbEmail = await fb.getUserEmail();
        } catch (e) {
          // Handle email fetch error silently
          fbEmail = null;
        }

        final socialUser = SocialUser(
          id: firebaseUser.uid,
          name: fbName ?? firebaseUser.displayName ?? '',
          email: fbEmail ?? firebaseUser.email ?? '',
          source: 'Facebook',
        );

        return socialUser;

      } else if (res.status == FacebookLoginStatus.cancel) {
        errorToast('Facebook login cancelled');
        return null;
      } else {
        errorToast('Facebook login failed');
        return null;
      }
    } catch (e) {
      errorToast('Facebook login error: ${e.toString()}');
      return null;
    }
  }

  String? getMonth(String month) {
    switch (month) {
      case "1":
        return "Jan";
      case "2":
        return "Feb";
      case "3":
        return "Mar";
      case "4":
        return "Apr";
      case "5":
        return "May";
      case "6":
        return "Jun";
      case "7":
        return "Jul";
      case "8":
        return "Aug";
      case "9":
        return "Sep";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      default:
        return "Dec";
    }
  }

  String maskPan(String? pan) {
    if (pan == null || pan.length < 4) return pan ?? '-';
    return '*' * (pan.length - 4) + pan.substring(pan.length - 4);
  }
}

class ImageFile {
  const ImageFile(this.compressedFile);

  final Uint8List? compressedFile;
}

class SocialUser {
  final String id;
  final String name;
  final String email;
  final String source;

  SocialUser(
      {required this.id,
        required this.name,
        required this.email,
        required this.source});
}
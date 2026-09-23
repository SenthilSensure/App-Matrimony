import '../utils/constants/flavor_config.dart';

String get baseUrl => FlavorConfig.instance.baseUrl;
const apiLogin = 'login';
const apiSignUp = 'signup';
const apiVerifyOtp = 'verify-otp';
const apiResendOtp = 'resend-otp';
const apiProfileChatMessage = 'profile-chat/message';
const apiGetProfile = 'profile';
const apiUpdateProfile = 'profile/update';

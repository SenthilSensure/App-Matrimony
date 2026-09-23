import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../ui/home/home_page.dart';
import '../../ui/intro/splash_page.dart';
import '../../ui/login/login_page.dart';
import '../../ui/notification/notification_page.dart';
import '../../ui/otp/otp_page.dart';
import '../../ui/chat/profile_chat_page.dart';
import '../../ui/profile/profile_page.dart';
import '../../ui/signup/signup_page.dart';
import '../storage/app_preference.dart';

/// Route guard to handle web navigation security and flow control
class RouteGuard {
  static final RouteGuard _instance = RouteGuard._internal();

  factory RouteGuard() => _instance;

  RouteGuard._internal();

  static RouteGuard get instance => _instance;

  /// Routes that can be opened without login
  static const List<String> _publicRoutes = [
    SplashPage.id,
    LoginPage.id,
    SignupPage.id,
    OtpPage.id,
  ];

  /// Routes that are only reachable after login
  static const List<String> _authRequiredRoutes = [
    HomePage.id,
    ProfilePage.id,
    ProfileChatPage.id,
    NotificationPage.id,
  ];

  /// Routes that a logged-in user should not see again
  static const List<String> _authFlowRoutes = [
    LoginPage.id,
    SignupPage.id,
  ];

  /// Validate route access and redirect if necessary.
  /// Returns the route that should be navigated to, or null if access is allowed.
  static String? validateRouteAccess(String requestedRoute) {
    // Skip validation for non-web platforms
    if (!kIsWeb) return null;

    // Handle root route
    if (requestedRoute == '/' || requestedRoute.isEmpty) {
      requestedRoute = SplashPage.id;
    }

    // Splash always decides on its own
    if (requestedRoute == SplashPage.id) return null;

    final pref = AppSharedPref.instance;
    final bool isLoggedIn = pref.isLogin;

    // Protected route without login -> send to login
    if (_authRequiredRoutes.contains(requestedRoute) && !isLoggedIn) {
      return LoginPage.id;
    }

    // Already logged in -> skip login/signup
    if (isLoggedIn && _authFlowRoutes.contains(requestedRoute)) {
      return HomePage.id;
    }

    // Unknown route -> let it through only when it is public
    if (!_publicRoutes.contains(requestedRoute) &&
        !_authRequiredRoutes.contains(requestedRoute)) {
      return isLoggedIn ? HomePage.id : LoginPage.id;
    }

    return null; // Allow access
  }

  /// Handle route redirection with proper navigation
  static void handleRouteRedirection(
      String originalRoute, String redirectRoute) {
    if (kIsWeb) {
      // Store original intended route for potential restoration after auth
      _storeIntendedRoute(originalRoute);
    }
  }

  /// Store the originally intended route for restoration after successful auth
  static void _storeIntendedRoute(String route) {
    AppSharedPref.instance.intendedRoute = route;
  }

  /// Get and clear the originally intended route
  static String? getAndClearIntendedRoute() {
    final pref = AppSharedPref.instance;
    final intendedRoute = pref.intendedRoute;
    if (intendedRoute.isNotEmpty) {
      pref.clearIntendedRoute();
      return intendedRoute;
    }
    return null;
  }

  /// Complete auth flow and navigate to appropriate page
  static void completeAuthFlow() {
    if (!kIsWeb) return;

    // Check if there's an intended route to restore
    final intendedRoute = getAndClearIntendedRoute();

    if (intendedRoute != null &&
        validateRouteAccess(intendedRoute) == null) {
      Get.offAllNamed(intendedRoute);
      return;
    }

    Get.offAllNamed(HomePage.id);
  }
}

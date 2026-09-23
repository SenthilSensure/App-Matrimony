import 'dart:convert';
import 'package:app_matrimony/utils/router/route_guard.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../ui/intro/splash_page.dart';
import '../../ui/notification/notification_page.dart';
import '../../ui/otp/otp_page.dart';
import '../../ui/profile/profile_page.dart';
import '../../ui/signup/signup_page.dart';
import '../../ui/chat/profile_chat_page.dart';
import '../security/key_manager.dart';
import '../../ui/home/home_page.dart';
import '../../ui/login/login_page.dart';

class AppRouter {
  // Original route names mapping to web-friendly names
  static const Map<String, String> routeNames = {
    SplashPage.id: 'intro',
    SignupPage.id: 'register',
    LoginPage.id: 'login',
    OtpPage.id: 'otp',
    HomePage.id: 'home',
    ProfileChatPage.id: 'profile-chat',
    NotificationPage.id: 'notification',
  };

  // Cache for encoded routes to avoid repeated encoding
  static final Map<String, String> _encodedRouteCache = <String, String>{};

  // Securely encrypt route name for web URLs
  static String _encodeRouteName(String routeName) {
    try {
      // Use secure encryption instead of simple base64
      final keyManager = SecureKeyManager.instance;
      final encrypted = keyManager.encrypter.encrypt(routeName, iv: keyManager.encryptionIV);

      // Convert to URL-safe base64 to avoid URL encoding issues
      return base64Url.encode(encrypted.bytes);
    } catch (e) {
      // Fallback to simple base64 if secure encryption fails
      try {
        return base64Url.encode(utf8.encode(routeName));
      } catch (e2) {
        return routeName; // ultimate fallback
      }
    }
  }

  // Securely decrypt route name from web URLs
  static String _decodeRouteName(String encodedName) {
    try {
      // First try secure decryption
      final keyManager = SecureKeyManager.instance;
      final encryptedBytes = base64Url.decode(encodedName);
      final encrypted = encrypt.Encrypted(encryptedBytes);
      return keyManager.encrypter.decrypt(encrypted, iv: keyManager.encryptionIV);
    } catch (e) {
      // Fallback to simple base64 decoding for backward compatibility
      try {
        return utf8.decode(base64Url.decode(encodedName));
      } catch (e2) {
        return encodedName; // ultimate fallback
      }
    }
  }

  // Get encoded web path or fallback to original ID
  static String getRoutePath(String routeId) {
    if (kIsWeb && routeNames.containsKey(routeId)) {
      // Use cached encoded route if available
      if (_encodedRouteCache.containsKey(routeId)) {
        return _encodedRouteCache[routeId]!;
      }

      // Encode the route name and cache it
      final routeName = routeNames[routeId]!;
      final encodedRoute = _encodeRouteName(routeName); // Remove leading slash
      _encodedRouteCache[routeId] = encodedRoute;
      return encodedRoute;
    }
    return routeId;
  }

  // Get original route ID from encoded web path
  static String getOriginalRouteId(String encodedPath) {
    // Handle both with and without leading slash
    String encodedName = encodedPath;
    if (encodedPath.startsWith('/')) {
      encodedName = encodedPath.substring(1); // Remove leading '/' if present
    }

    final decodedName = _decodeRouteName(encodedName);

    // Find the original route ID by matching decoded name with route names
    for (String originalId in routeNames.keys) {
      if (routeNames[originalId] == decodedName) {
        return originalId;
      }
    }

    return encodedPath; // fallback if not found
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Convert encoded web paths back to original IDs for routing
    String routeName = settings.name ?? '';

    // Handle root route for web
    if (routeName == '/') {
      routeName = 'SplashPage';  // Default to splash page for root route
    }

    // If it's an encoded web path (with or without leading slash), decode it
    if ((routeName.startsWith('/') && routeName.length > 1) ||
        (!routeName.startsWith('/') && routeName.isNotEmpty && !routeNames.containsValue(routeName))) {
      routeName = getOriginalRouteId(routeName);
    }

    // Apply route guard validation for web platforms
    if (kIsWeb && routeName.isNotEmpty) {
      final redirectRoute = RouteGuard.validateRouteAccess(routeName);
      if (redirectRoute != null) {
        // Store the original route and redirect
        RouteGuard.handleRouteRedirection(routeName, redirectRoute);

        // Return route for the redirect destination instead
        return generateRoute(RouteSettings(name: redirectRoute, arguments: settings.arguments));
      }
    }

    switch (routeName) {
      case 'SplashPage':
      case '/':
        {
          return MaterialPageRoute(
            builder: (_) => const SplashPage(),
            settings: RouteSettings(
              name: kIsWeb ? '/' : 'SplashPage',
              arguments: settings.arguments,
            ),
          );
        }
      case SignupPage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const SignupPage(),
            settings: RouteSettings(
              name: getRoutePath(SignupPage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case LoginPage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const LoginPage(),
            settings: RouteSettings(
              name: getRoutePath(LoginPage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case OtpPage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const OtpPage(),
            settings: RouteSettings(
              name: getRoutePath(OtpPage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case ProfileChatPage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const ProfileChatPage(),
            settings: RouteSettings(
              name: getRoutePath(ProfileChatPage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case HomePage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: RouteSettings(
              name: getRoutePath(HomePage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case ProfilePage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const ProfilePage(),
            settings: RouteSettings(
              name: getRoutePath(ProfilePage.id),
              arguments: settings.arguments,
            ),
          );
        }
      case NotificationPage.id:
        {
          return MaterialPageRoute(
            builder: (_) => const NotificationPage(),
            settings: RouteSettings(
              name: getRoutePath(NotificationPage.id),
              arguments: settings.arguments,
            ),
          );
        }
      default:
        {
          return MaterialPageRoute(
              builder: (_) => const LoginPage(), settings: settings);
        }
    }
  }
}

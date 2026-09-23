import 'package:flutter/foundation.dart';
import 'route_guard.dart';
import 'app_router.dart';
// Conditional import - only import dart:html on web platform
import 'web_html_stub.dart'
    if (dart.library.html) 'dart:html' as html;

/// Web middleware to handle URL changes and prevent unauthorized access
class WebRouteMiddleware {
  static WebRouteMiddleware? _instance;
  static WebRouteMiddleware get instance => _instance ??= WebRouteMiddleware._();

  WebRouteMiddleware._();

  /// Initialize web-specific route monitoring
  void initialize() {
    if (!kIsWeb) return;

    try {
      print('Web route middleware initialized');

      // Listen to browser navigation events (back/forward)
      html.window.onPopState.listen((event) {
        _handleBrowserNavigation();
      });

      // Monitor URL changes
      _setupUrlMonitoring();

      print('Browser navigation listeners set up');
    } catch (e) {
      print('Failed to initialize web middleware: $e');
    }
  }

  /// Handle browser navigation (back/forward buttons)
  void _handleBrowserNavigation() {
    try {
      final currentPath = html.window.location.pathname ?? '/';
      print('Browser navigation detected: $currentPath');

      // Validate the current route
      final originalRouteId = _extractRouteFromPath(currentPath);
      final redirectRoute = RouteGuard.validateRouteAccess(originalRouteId);

      if (redirectRoute != null) {
        print('Unauthorized access attempt to: $originalRouteId, redirecting to: $redirectRoute');
        RouteGuard.handleRouteRedirection(originalRouteId, redirectRoute);
      }
    } catch (e) {
      print('Error handling browser navigation: $e');
    }
  }

  /// Setup URL monitoring for direct access attempts
  void _setupUrlMonitoring() {
    try {
      // Check current URL on initialization
      final currentPath = html.window.location.pathname ?? '/';
      if (currentPath != '/') {
        print('Direct URL access detected: $currentPath');
        _validateDirectAccess(currentPath);
      }
    } catch (e) {
      print('Error setting up URL monitoring: $e');
    }
  }

  /// Validate direct URL access attempts
  void _validateDirectAccess(String path) {
    try {
      final originalRouteId = _extractRouteFromPath(path);
      final redirectRoute = RouteGuard.validateRouteAccess(originalRouteId);

      if (redirectRoute != null) {
        print('Direct access validation failed for: $originalRouteId, redirecting to: $redirectRoute');
        // Use a delay to ensure the app is fully initialized
        Future.delayed(const Duration(milliseconds: 500), () {
          RouteGuard.handleRouteRedirection(originalRouteId, redirectRoute);
        });
      }
    } catch (e) {
      print('Error validating direct access: $e');
    }
  }

  /// Extract route ID from URL path
  String _extractRouteFromPath(String path) {
    if (path == '/' || path.isEmpty) {
      return 'SplashPage';
    }

    // Remove leading slash and decode if necessary
    String routePath = path.startsWith('/') ? path.substring(1) : path;

    // Try to decode the route using AppRouter's decoding logic
    try {
      // Import AppRouter to use its decoding logic
      final originalRouteId = AppRouter.getOriginalRouteId(routePath);
      print('Extracted route ID: $originalRouteId from path: $path');
      return originalRouteId;
    } catch (e) {
      print('Error decoding route path: $e');
      return 'SplashPage';
    }
  }

  /// Clean up listeners
  void dispose() {
    if (!kIsWeb) return;
    print('Web middleware disposed');
  }

  /// Check if the current URL path should be validated
  static bool shouldValidateCurrentUrl() {
    if (!kIsWeb) return false;

    try {
      return true; // Always validate for now
    } catch (e) {
      return false;
    }
  }

  /// Get current URL information
  static Map<String, String> getCurrentUrlInfo() {
    if (!kIsWeb) return {};

    try {
      return {
        'platform': 'web',
        'pathname': html.window.location.pathname ?? '/',
        'search': html.window.location.search ?? '',
        'hash': html.window.location.hash ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };
    } catch (e) {
      return {'platform': 'web', 'error': e.toString()};
    }
  }

  /// Update browser URL without navigation
  static void updateUrl(String path) {
    if (!kIsWeb) return;

    try {
      html.window.history.pushState(null, '', path);
    } catch (e) {
      print('Error updating URL: $e');
    }
  }

  /// Replace current URL without navigation
  static void replaceUrl(String path) {
    if (!kIsWeb) return;

    try {
      html.window.history.replaceState(null, '', path);
    } catch (e) {
      print('Error replacing URL: $e');
    }
  }

  /// Security features for web
  void enableSecurityFeatures() {
    if (!kIsWeb) return;

    try {
      // Disable right-click context menu
      html.document.onContextMenu.listen((event) {
        event.preventDefault();
      });

      // Disable F12, Ctrl+Shift+I, Ctrl+U, etc.
      html.document.onKeyDown.listen((event) {
        if (event.keyCode == 123 || // F12
            (event.ctrlKey && event.shiftKey && event.keyCode == 73) || // Ctrl+Shift+I
            (event.ctrlKey && event.keyCode == 85)) { // Ctrl+U
          event.preventDefault();
        }
      });

      print('Security features enabled');
    } catch (e) {
      print('Error enabling security features: $e');
    }
  }
}

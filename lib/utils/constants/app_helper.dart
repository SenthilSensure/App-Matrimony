import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppHelper {
  static late AppHelper _instance;
  static late AndroidDeviceInfo _androidInfo;
  static late WebBrowserInfo _webInfo;
  static late IosDeviceInfo _iosInfo;
  static late PackageInfo packageInfo;
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  AppHelper._privateConstructor();

  static final AppHelper instance = AppHelper._privateConstructor();

  static Future<AppHelper> getInstance() async {
    return AppHelper.instance;
  }

  initSetup() async {
    if(kIsWeb) {
      _webInfo = await DeviceInfoPlugin().webBrowserInfo;
    } else {
      if (Platform.isAndroid) {
        _androidInfo = await DeviceInfoPlugin().androidInfo;
      } else if (Platform.isIOS) {
        _iosInfo = await DeviceInfoPlugin().iosInfo;
      }
    }
    packageInfo = await PackageInfo.fromPlatform();
  }

  String getDevicePlatform() {
    if(kIsWeb) {
      return 'web';
    } else {
      if (Platform.isAndroid) {
        return 'android';
      } else if (Platform.isIOS) {
        return 'ios';
      }
    }
    return '';
  }

  String getDeviceModel() {
    if(kIsWeb) {
      return '';
    } else {
      if (Platform.isAndroid && _androidInfo != null) {
        final String manufacturer = _androidInfo.manufacturer;
        final String model = _androidInfo.model;
        return '$manufacturer $model';
      } else if (Platform.isIOS && _iosInfo != null) {
        final String name = _iosInfo.utsname.machine;
        return '$name';
      }
    }
    return '';
  }

  String getOSVersionNumber() {
    if(kIsWeb) {
      return '';
    } else {
      if (Platform.isAndroid && _androidInfo != null) {
        return "${_androidInfo.version.sdkInt}";
      } else if (Platform.isIOS && _iosInfo != null) {
        return _iosInfo.systemVersion;
      }
    }
    return '';
  }

  String getVersionNumber() {
    if (packageInfo != null) {
      return packageInfo.version;
    }
    return '';
  }

  String getBuildNumber() {
    return packageInfo.buildNumber;
    return '';
  }

  String getSystemLanguage() {
    if (kIsWeb) {
      return 'en_US'; // Default locale for web
    } else {
      return Platform.localeName;
    }
  }

  String? getDeviceID() {
    if(kIsWeb) {
      return _webInfo.vendor;
    } else {
      if (Platform.isAndroid) {
        return _androidInfo.id;
      } else if (Platform.isIOS) {
        return _iosInfo.identifierForVendor;
      }
    }
    return '';
  }

  String? getDeviceType(BuildContext context) {
    String deviceType = "phone";

    // Check shortest side for tablet
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide >= 600) {
      deviceType = "tab";
      return deviceType;
    }

    if(kIsWeb) {
      return "web";
    }

    if (Platform.isAndroid) {
      final model = _androidInfo.model.toLowerCase() ?? '';
      if (model.contains("tab")) {
        deviceType = "tab";
      }
    } else if (Platform.isIOS) {
      final model = _iosInfo.utsname.machine.toLowerCase() ?? '';
      if (model.contains("ipad")) {
        deviceType = "tab";
      }
    }
    return deviceType;
  }

  bool isTablet(BuildContext context) {
    if (kIsWeb) {
      // For web, use screen size to determine tablet layout
      var shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide > 600;
    } else if (Platform.isIOS) {
      return _iosInfo.model.toLowerCase() == "ipad";
    } else {
      // The equivalent of the "smallestWidth" qualifier on Android.
      var shortestSide = MediaQuery.of(context).size.shortestSide;
      // Determine if we should use mobile layout or not, 600 here is
      // a common breakpoint for a typical 7-inch tablet.
      return shortestSide > 600;
    }
  }

  static String genderFullForm(String? code) {
    switch (code?.toUpperCase()) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  static String maritalStatusFullForm(String? code) {
    switch (code?.toUpperCase()) {
      case 'M':
        return 'Married';
      case 'N':
        return 'Un Married';
      default:
        return 'Unknown';
    }
  }

  /// Get app signature key for SMS retrieval
  /// This is used for SMS auto-fill functionality
 // static Future<String> getAppSignature() async {
    // Use the centralized SmsAutofillService
   // return await SmsAutofillService.getAppSignature();
 // }
}

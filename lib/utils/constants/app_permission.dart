import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_messages.dart';

class PermissionUtils {
  PermissionType? _permissionType;
  Function()? _onPermissionDenied;
  Function()? _onPermissionGranted;
  Function()? _onPermissionPermanentlyDenied;

  PermissionUtils(PermissionType permissionType) {
    _permissionType = permissionType;
  }

  PermissionUtils onPermissionDenied(Function()? onPermissionDenied) {
    _onPermissionDenied = onPermissionDenied;
    return this;
  }

  PermissionUtils onPermissionGranted(Function()? onPermissionGranted) {
    _onPermissionGranted = onPermissionGranted;
    return this;
  }

  PermissionUtils onPermissionPermanentlyDenied(
      Function()? onPermissionPermanentlyDenied) {
    _onPermissionPermanentlyDenied = onPermissionPermanentlyDenied;
    return this;
  }

  Permission _getPermissionFromType(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.manageExternalStorage:
        return Permission.manageExternalStorage;
      case PermissionType.recordAudio:
        return Permission.microphone;
      case PermissionType.writeContacts:
        return Permission.contacts;
      case PermissionType.readContacts:
        return Permission.contacts;
      case PermissionType.whenInUseLocation:
        return Permission.locationWhenInUse;
      case PermissionType.alwaysLocation:
        return Permission.locationAlways;
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.photos:
        return Permission.photos;
      default:
        throw Exception('Invalid permission type');
    }
  }

  void execute(BuildContext context) async {
    Permission permission = _getPermissionFromType(_permissionType!);

    // Show rationale for sensitive permissions
    if (permission == Permission.camera) {
      // Camera permission is used for KYC document capture and profile photos
      bool shouldProceed = await _showPermissionRationale(context, 'Camera Access Required',
        'This permission is needed to capture photos of your identity documents for account verification and to take profile pictures.');
      if (!shouldProceed) return;
    } else if (permission == Permission.notification) {
      // Notification permission for important financial alerts
      bool shouldProceed = await _showPermissionRationale(context, 'Notification Permission',
        'Allow notifications to receive important updates about your account, transactions, and security alerts.');
      if (!shouldProceed) return;
    }

    if (permission == Permission.locationWhenInUse ||
        permission == Permission.locationAlways ||
        permission == Permission.location) {
      await permission.shouldShowRequestRationale;
    }

    PermissionStatus status = await permission.request();

    if (status.isGranted) {
      if (_onPermissionGranted != null) {
        _onPermissionGranted!();
      }
    } else if (status.isDenied) {
      if (_onPermissionDenied != null) {
        _onPermissionDenied!();
      }
    } else if (status.isPermanentlyDenied) {
      if (_onPermissionPermanentlyDenied != null) {
        _onPermissionPermanentlyDenied!();
      }
    }
  }

  Future<bool> _showPermissionRationale(BuildContext context, String title, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Allow'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  static void permissionDeny(BuildContext context, Permission type) {
    if (type == Permission.camera) {
      showAppSnackBar(context,
          'Camera permissions are permanently denied, we cannot request permissions.',
          buttonText: 'Settings', onPressed: () {
        openAppSettings();
      });
    } else if (type == Permission.storage) {
      showAppSnackBar(context,
          'Gallery permissions are permanently denied, we cannot request permissions.',
          buttonText: 'Settings', onPressed: () {
        openAppSettings();
      });
    }
  }

  static Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.camera.request();
      return status.isGranted;
    }
  }

  static Future<bool> checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  static Future<bool> checkNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.notification.request();
      return status.isGranted;
    }
  }

  /// Check if sensitive permissions are properly declared for Google Play compliance
  static Future<Map<String, bool>> getPermissionStatus() async {
    return {
      'camera': (await Permission.camera.status).isGranted,
      'notification': (await Permission.notification.status).isGranted,
      'storage': (await Permission.storage.status).isGranted,
    };
  }
}

enum PermissionType {
  recordAudio,
  camera,
  storage,
  manageExternalStorage,
  notification,
  location,
  accessCoarseLocation,
  accessFineLocation,
  whenInUseLocation,
  alwaysLocation,
  writeContacts,
  readContacts,
  photos,
}

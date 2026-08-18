import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants/app_update_config.dart';
import '../utils/constants/app_colors.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  /// Check for app updates and show update dialog if available
  Future<void> checkForUpdate(BuildContext context) async {
    // Only check for updates in release mode and on Android platform
    if (kDebugMode || !Platform.isAndroid || kIsWeb || !AppUpdateConfig.enableAppUpdates) {
      return;
    }

    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Determine if this should be a force update
        bool isForceUpdate = await _shouldForceUpdate(updateInfo);

        // Check if context is still valid before showing dialogs
        if (!context.mounted) return;

        if (isForceUpdate) {
          await _showForceUpdateDialog(context, updateInfo);
        } else {
          await _showOptionalUpdateDialog(context, updateInfo);
        }
      }
    } catch (e) {
      // Silently handle errors in production
      if (kDebugMode) {
        print('App update check error: $e');
      }
    }
  }


  /// Determine if this should be a force update based on version difference
  Future<bool> _shouldForceUpdate(AppUpdateInfo updateInfo) async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      int currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      // Check if current version is below minimum required
      bool isVersionOutdated = AppUpdateConfig.isVersionOutdated(
        currentVersion,
        AppUpdateConfig.minimumRequiredVersion
      );

      // Check if current version code is below minimum required
      bool isVersionCodeOutdated = AppUpdateConfig.isVersionCodeOutdated(
        currentVersionCode,
        AppUpdateConfig.minimumRequiredVersionCode
      );


      bool shouldForceByDays = updateInfo.clientVersionStalenessDays != null &&
          updateInfo.clientVersionStalenessDays! > AppUpdateConfig.maxDaysBeforeForceUpdate;

      bool shouldForce = isVersionOutdated ||
          isVersionCodeOutdated ||
          shouldForceByDays ||
          updateInfo.immediateUpdateAllowed == true;

      return shouldForce;
    } catch (e) {
      return true;
    }
  }

  /// Show force update dialog (user cannot dismiss)
  Future<void> _showForceUpdateDialog(BuildContext context, AppUpdateInfo updateInfo) async {
    final Completer<void> completer = Completer<void>();

    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.app_settings_alt,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'App Update Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'A new version is available with enhanced features and improvements. Update now for the best experience.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _performUpdate(updateInfo, isImmediate: true);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Update Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    return completer.future;
  }

  /// Show optional update dialog (user can dismiss)
  Future<void> _showOptionalUpdateDialog(BuildContext context, AppUpdateInfo updateInfo) async {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.app_settings_alt,
                  size: 40,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'App Update Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'A new version is available with enhanced features and improvements. Update now for the best experience.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.black.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          foregroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Later'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _performUpdate(updateInfo, isImmediate: false);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _performUpdate(AppUpdateInfo updateInfo, {required bool isImmediate}) async {
    try {
      if (isImmediate && updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (!isImmediate && updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        listenForFlexibleUpdateCompletion();
      } else {
        await _openPlayStore();
      }
    } catch (e) {
      await _openPlayStore();
    }
  }

  Future<void> _openPlayStore() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;

      final Uri playStoreUrl = Uri.parse('market://details?id=$packageName');

      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        final Uri browserUrl = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
        if (await canLaunchUrl(browserUrl)) {
          await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not open Play Store';
        }
      }
    } catch (e) {
      _showPlayStoreInstructions();
    }
  }

  void _showPlayStoreInstructions() {
    // Could show a toast or dialog here if needed
  }


  void listenForFlexibleUpdateCompletion() {
    InAppUpdate.completeFlexibleUpdate().then((_) {

    }).catchError((e) {

    });
  }

  Future<void> showManualUpdateDialog(BuildContext context, {bool isForceUpdate = false}) async {
    if (isForceUpdate) {
      final Completer<void> completer = Completer<void>();

      showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.open_in_new,
                      size: 40,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Update Required',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'A new version is available with enhanced features and improvements. Update now for the best experience.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _openPlayStore();
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Play Store'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );

      return completer.future;
    } else {
      return showModalBottomSheet<void>(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.open_in_new,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'A new version is available with enhanced features and improvements. Update now for the best experience.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primaryColor),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Later'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _openPlayStore();
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }
  }
}

class AppUpdateConfig {
  // Enable/disable app update checks (only works in release builds)
  static const bool enableAppUpdates = true;

  // Minimum required version that forces update
  static const String minimumRequiredVersion = "1.0.9";

  // Minimum required version code that forces update
  static const int minimumRequiredVersionCode = 15;

  // Maximum days before forcing update (even for optional updates)
  static const int maxDaysBeforeForceUpdate = 7;

  // Update priority threshold for force updates (0-5, where 5 is highest)
  static const int forceUpdatePriorityThreshold = 4;

  /// Check if a version is outdated compared to minimum required version
  /// Returns true if currentVersion < minimumVersion
  static bool isVersionOutdated(String currentVersion, String minimumVersion) {
    try {
      List<int> currentParts = currentVersion
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
      List<int> minimumParts = minimumVersion
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      // Ensure both lists have same length by padding with zeros
      while (currentParts.length < minimumParts.length) {
        currentParts.add(0);
      }
      while (minimumParts.length < currentParts.length) {
        minimumParts.add(0);
      }

      // Compare version parts
      for (int i = 0; i < currentParts.length; i++) {
        if (currentParts[i] < minimumParts[i]) {
          return true; // Current version is older
        } else if (currentParts[i] > minimumParts[i]) {
          return false; // Current version is newer
        }
        // If equal, continue to next part
      }

      return false; // Versions are equal
    } catch (e) {
      // If version parsing fails, assume not outdated
      return false;
    }
  }

  /// Get version code from version string
  /// Extracts the build number from version string like "1.0.5+11"
  static int getVersionCode(String versionWithBuild) {
    try {
      if (versionWithBuild.contains('+')) {
        return int.parse(versionWithBuild.split('+')[1]);
      }
      return 1; // Default version code
    } catch (e) {
      return 1;
    }
  }

  /// Check if version code is outdated
  static bool isVersionCodeOutdated(int currentVersionCode, int minimumVersionCode) {
    return currentVersionCode < minimumVersionCode;
  }
}

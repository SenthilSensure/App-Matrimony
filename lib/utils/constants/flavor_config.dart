enum Flavor {
  staging,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;
  final String appName;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String baseUrl,
    required String appName,
  }) {
    _instance ??= FlavorConfig._internal(flavor, baseUrl, appName);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.baseUrl, this.appName);

  static FlavorConfig get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw Exception('FlavorConfig not initialized');
    }
  }

  static bool isProduction() => _instance?.flavor == Flavor.production;
  static bool isStaging() => _instance?.flavor == Flavor.staging;
}
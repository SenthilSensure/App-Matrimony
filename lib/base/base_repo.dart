import '../service/api_client.dart';
import '../utils/di/app_di.dart';
import '../utils/storage/app_preference.dart';

class BaseRepo {
  ApiClient apiClient = getIt<ApiClient>();
  AppSharedPref pref = getIt<AppSharedPref>();

  Map<String, String> tokenHeader(String authorization) {
    Map<String, String> header = {};
    if (authorization.isNotEmpty) {
      header = {
        "Authorization": authorization,
        'Content-Type': 'application/json'
      };
    } else {
      header = {'Content-Type': 'application/json'};
    }
    return header;
  }
}

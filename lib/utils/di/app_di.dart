import 'package:get_it/get_it.dart';
import '../../service/api_client.dart';
import '../../service/auth_repo.dart';
import '../constants/app_helper.dart';
import '../storage/app_preference.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  var appSharedPref = await AppSharedPref.getInstance();
  await appSharedPref.initSetup();
  getIt.registerSingleton<AppSharedPref>(appSharedPref);

  var appHelper = await AppHelper.getInstance();
  await appHelper.initSetup();
  getIt.registerSingleton(appHelper);

  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<AuthRepo>(AuthRepo());
}

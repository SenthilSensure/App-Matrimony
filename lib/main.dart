import 'package:app_matrimony/provider/login/login_provider.dart';
import 'package:app_matrimony/provider/otp/otp_provider.dart';
import 'package:app_matrimony/provider/profile/profile_provider.dart';
import 'package:app_matrimony/provider/signup/signup_provider.dart';
import 'package:app_matrimony/provider/chat/profile_chat_provider.dart';
import 'package:app_matrimony/ui/intro/splash_page.dart';
import 'package:app_matrimony/utils/constants/app_colors.dart';
import 'package:app_matrimony/utils/constants/app_helper.dart';
import 'package:app_matrimony/utils/constants/app_loader.dart';
import 'package:app_matrimony/utils/constants/app_theme.dart';
import 'package:app_matrimony/utils/constants/flavor_config.dart';
import 'package:app_matrimony/utils/di/app_di.dart';
import 'package:app_matrimony/utils/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'base/base_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  // Initialize flavor configuration.
  //
  // Override at run time:
  //   flutter run -d chrome --dart-define=BASE_URL=http://localhost:5001/api/
  //
  // NOTE (web): the browser talks to the API directly, so the host must be
  // reachable *from the browser* and the server must send CORS headers.
  // On web we default to `localhost` because `127.0.0.1/localhost` is treated
  // as a secure origin, while a LAN IP over plain http can be blocked.
  const String defineUrl = String.fromEnvironment('BASE_URL');
  final String baseUrl = defineUrl.isNotEmpty
      ? defineUrl
      : kIsWeb
          ? 'http://localhost:5000/api/'
          : 'http://192.168.1.2:5000/api/';
  FlavorConfig(
    flavor: Flavor.production,
    baseUrl: baseUrl,
    appName: 'Matrimony',
  );

  await setupLocator();
  
  runApp(const MatrimonyApp());
}

class MatrimonyApp extends StatelessWidget {
  const MatrimonyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseProvider>(create: (_) => BaseProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ProfileChatProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        return Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return OverlaySupport.global(
                  child: GetMaterialApp(
                    title: 'Matrimony',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      scaffoldBackgroundColor: themeNotifier.bgColor,
                      // Use dynamic background
                      fontFamily: themeNotifier.fontFamily,
                      textTheme: TextTheme(
                        displayLarge: TextStyle(fontFamily: themeNotifier.fontFamily),
                        displayMedium: TextStyle(fontFamily: themeNotifier.fontFamily),
                        displaySmall: TextStyle(fontFamily: themeNotifier.fontFamily),
                        headlineLarge: TextStyle(fontFamily: themeNotifier.fontFamily),
                        headlineMedium: TextStyle(fontFamily: themeNotifier.fontFamily),
                        headlineSmall: TextStyle(fontFamily: themeNotifier.fontFamily),
                        titleLarge: TextStyle(fontFamily: themeNotifier.fontFamily),
                        titleMedium: TextStyle(fontFamily: themeNotifier.fontFamily),
                        titleSmall: TextStyle(fontFamily: themeNotifier.fontFamily),
                        bodyLarge: TextStyle(fontFamily: themeNotifier.fontFamily),
                        bodyMedium: TextStyle(fontFamily: themeNotifier.fontFamily),
                        bodySmall: TextStyle(fontFamily: themeNotifier.fontFamily),
                        labelLarge: TextStyle(fontFamily: themeNotifier.fontFamily),
                        labelMedium: TextStyle(fontFamily: themeNotifier.fontFamily),
                        labelSmall: TextStyle(fontFamily: themeNotifier.fontFamily),
                      ),
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: themeNotifier.primaryColor,
                        primary: themeNotifier.primaryColor,
                        surface: themeNotifier.bgColor, // Use dynamic background
                      ),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeNotifier.buttonColor,
                          // Use dynamic button color
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontFamily: themeNotifier.fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      appBarTheme: AppBarTheme(
                        backgroundColor: themeNotifier.primaryColor,
                        // Use dynamic primary color
                        foregroundColor: Colors.white,
                        elevation: 0,
                        titleTextStyle: TextStyle(
                          fontFamily: themeNotifier.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      radioTheme: RadioThemeData(
                        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return themeNotifier.primaryColor;
                          }
                          return Colors.grey;
                        }),
                      ),
                      checkboxTheme: CheckboxThemeData(
                        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return themeNotifier.primaryColor;
                          }
                          return Colors.grey;
                        }),
                      ),
                    ),
                    supportedLocales: const [
                      Locale("en"),
                    ],
                    builder: (context, child) {
                      return LoaderView(
                        child: child!,
                      );
                    },
                    initialRoute: kIsWeb ? '/' : null,
                    home: kIsWeb ? null : const SplashPage(),
                    onGenerateRoute: AppRouter.generateRoute,
                    onUnknownRoute: (settings) {
                      // Handle unknown routes for web
                      if (kIsWeb) {
                        return AppRouter.generateRoute(const RouteSettings(name: '/'));
                      }
                      return AppRouter.generateRoute(const RouteSettings(name: 'SplashPage'));
                    },
                    navigatorObservers: [AppHelper.routeObserver],
                  ));
            });
      }),
    );
  }
}

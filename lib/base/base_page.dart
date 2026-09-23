import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_text_style.dart';
import '../utils/di/app_di.dart';
import '../utils/storage/app_preference.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BaseState<Page extends BasePage> extends State<Page> {
  AppSharedPref pref = getIt<AppSharedPref>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget divider() {
    return Divider(
      thickness: 0.5,
      color: Colors.grey[400],
    );
  }
}

mixin BasicPage<Page extends BasePage> on BaseState<Page> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: bgColor(),
        appBar: appBar(),
        drawer: drawer(),
        body: SafeArea(child: body()),
        bottomNavigationBar: bottomNav(),
        floatingActionButton: floatingActionButton(),
        floatingActionButtonLocation: floatingActionButtonLocation(),
      ),
    );
  }

  Color bgColor() {
    return AppColors.white;
  }

  Widget hSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget wSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  PreferredSizeWidget? appBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }

  Widget body();

  Widget? bottomNav() {
    return null;
  }

  Widget? floatingActionButton() {
    return null;
  }

  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return null;
  }

  Future<DateTime?> pickDateOfBirth(BuildContext context,
      {DateTime? initialDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // Customize your theme here
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void showSuccessDialog(String message, Function() onNext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColors.green,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.white(16, FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Divider(
                height: 1,
              ),
              const SizedBox(height: 15),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onNext();
                  },
                  child: Text(
                    'Proceed to next',
                    style: AppTextStyle.white(16, FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void showPolicyDialog(String url, String title,
      {bool isAccept = false, Function()? onAccept}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.white(16, FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // WebView
                Expanded(
                  child: WebViewWidget(
                      controller: WebViewController()
                        ..loadRequest(Uri.parse(url))
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)),
                ),
                // Accept button
                if (isAccept)
                  GestureDetector(
                    onTap: () {
                      onAccept?.call();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.vertical(bottom: Radius.circular(15)),
                      ),
                      child: Text(
                        'Accept',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.white(16, FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showExitDialog(BuildContext context,
      {required String message, required VoidCallback onYes}) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: kIsWeb ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
          ),
          margin: kIsWeb
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3)
              : const EdgeInsets.symmetric(horizontal: 1),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.white(16, FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "No",
                          style: AppTextStyle.primary(15, FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onYes();
                        },
                        child: Text(
                          "Yes",
                          style: AppTextStyle.primary(15, FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

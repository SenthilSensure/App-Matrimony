import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class LoaderView extends StatefulWidget {
  const LoaderView({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  LoaderViewState createState() => LoaderViewState();

  static LoaderViewState? of(BuildContext context, {bool nullOk = true}) {
    final LoaderViewState? result =
    context.findRootAncestorStateOfType<LoaderViewState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'LoaderView.of() called with a context that does not contain a LoaderView.'),
      ErrorDescription(
          'No LoaderView ancestor could be found starting from the context that was passed to LoaderView.of(). '
              'This usually happens when the context provided is from the same StatefulWidget as that '
              'whose build function actually creates the LoaderView widget being sought.'),
      ErrorHint(
          'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
              'context that is "under" the LoaderView.'),
      ErrorHint(
          'A more efficient solution is to split your build function into several widgets. This '
              'introduces a new context from which you can obtain the LoaderView. In this solution, '
              'you would have an outer widget that creates the LoaderView populated by instances of '
              'your new inner widgets, and then in these inner widgets you would use LoaderView.of().\n'
              'A less elegant but more expedient solution is assign a GlobalKey to the LoaderView, '
              'then use the key.currentState property to obtain the LoaderViewState rather than '
              'using the LoaderView.of() function.'),
      context.describeElement('The context used was')
    ]);
  }
}

class LoaderViewState extends State<LoaderView> {
  final _LoaderNotifier _notifier = _LoaderNotifier(false);
  bool isPrimaryColor = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    log(widget.child.runtimeType.toString());

    return Material(
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          Positioned.fill(
              child: ValueListenableBuilder<bool>(
                  valueListenable: _notifier,
                  builder: (context, isShowing, widget) {
                    if (isShowing == true) {
                      return AbsorbPointer(
                        absorbing: true,
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: AppColors.primaryColor, // size: MediaQuery.of(context).size.width * 0.45,
                          ),
                        ),
                      );
                    }
                    return Container();
                  })),
        ],
      ),
    );
  }

  showLoader(bool isPrimaryColor) {
    this.isPrimaryColor = isPrimaryColor;
    _notifier.showLoader();
  }

  hideLoader() {
    _notifier.hideLoader();
  }

  toggleLoader() {
    _notifier.toggleLoader();
  }
}

showLoader({bool isPrimaryColor = false}) {
  log("context: ${LoaderView.of(Get.context!)}");
  LoaderView.of(Get.context!)!.showLoader(isPrimaryColor);
}

hideLoader() {
  LoaderView.of(Get.context!)?.hideLoader();
}

toggleLoader(BuildContext context) {
  log("Toggle", name: "toggleLoader()");
  LoaderView.of(context)?.toggleLoader();
}

class _LoaderNotifier extends ValueNotifier<bool> {
  _LoaderNotifier(value) : super(value);

  _setShowing(bool isShowing) {
    value = isShowing;
    notifyListeners();
  }

  showLoader() {
    _setShowing(true);
  }

  hideLoader() {
    _setShowing(false);
  }

  toggleLoader() {
    _setShowing(!value);
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key, this.color}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x40000000),
      child: Center(
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          // size: MediaQuery.of(context).size.width * 0.45,
        ),
      ),
    );
  }
}

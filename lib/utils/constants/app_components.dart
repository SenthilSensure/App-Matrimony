import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final TextInputType inputType;
  final Function? onTap;
  final bool readOnly;
  final TextAlign textAlign;
  final Function? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Color? fillColor;
  final String prefixText;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final Widget? suffixIcon;
  final double? height;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.maxLength = 900,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.fillColor,
    this.prefixText = '',
    this.focusNode,
    this.autofillHints,
    this.suffixIcon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          prefixText.isNotEmpty
              ? Text(
                  prefixText,
                  style: AppTextStyle.black(16, FontWeight.w500),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: TextField(
              maxLength: maxLength,
              maxLines: maxLines,
              textAlign: textAlign,
              keyboardType: inputType,
              obscureText: obscureText,
              controller: controller,
              style: AppTextStyle.black(16, FontWeight.normal),
              readOnly: readOnly,
              enabled: enabled,
              autofillHints: autofillHints,
              onTap: onTap != null
                  ? () {
                      onTap!();
                    }
                  : null,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor ?? AppColors.white,
                hintText: hint,
                counterText: "",
                hintStyle: AppTextStyle.grey(16, FontWeight.normal).copyWith(
                  color: Colors.grey.withValues(alpha: 0.8),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget suffixIcon;
  final Function? onChanged;
  final bool enabled;
  final Color? fillColor;

  const AppPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.suffixIcon,
    this.onChanged,
    this.enabled = true,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          enabled: enabled,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: fillColor ?? AppColors.white,
              hintText: '',
              hintStyle: AppTextStyle.grey(16, FontWeight.normal),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: suffixIcon),
        ),
      ),
    );
  }
}

class AppTextFieldTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final bool isMandatory;

  const AppTextFieldTitle(
      {super.key,
      required this.text,
      this.textAlign,
      this.textStyle,
      this.isMandatory = false});

  @override
  Widget build(BuildContext context) {
    return isMandatory
        ? Text.rich(TextSpan(
            text: text,
            style: textStyle ?? AppTextStyle.black(16, FontWeight.bold),
            children: const [
                TextSpan(
                  text: AppStrings.mandatorySymbol,
                  style: TextStyle(color: AppColors.red),
                ),
              ]))
        : Text(
            text,
            style: textStyle ?? AppTextStyle.black(16, FontWeight.bold),
          );
  }
}

class AppRadioButtonBox extends StatelessWidget {
  final Widget widget;

  const AppRadioButtonBox({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: widget,
    );
  }
}

class AppDropDownBox extends StatelessWidget {
  final Widget child;

  const AppDropDownBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: child,
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool enabled;

  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.buttonColor : Colors.grey,
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                50,
              ),
            ),
          ),
        ),
        onPressed: enabled
            ? () {
                onTap();
              }
            : null,
        child: Text(
          title,
          style: enabled
              ? AppTextStyle.white(16, FontWeight.bold)
              : AppTextStyle.grey(16, FontWeight.bold),
        ),
      ),
    );
  }
}

class AppButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool enabled;
  final Alignment align;

  const AppButton2({
    super.key,
    required this.btnText,
    required this.onPressed,
    this.enabled = true,
    this.align = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.buttonColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 2,
        ),
        child: Text(
          btnText,
          style: enabled
              ? AppTextStyle.white(15, FontWeight.w600)
              : AppTextStyle.grey(15, FontWeight.w600),
        ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final String text;
  final Function onClick;

  const AppOutlineButton(
      {super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onClick();
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.buttonColor, width: 1.3),
        foregroundColor: AppColors.buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyle.primary(16, FontWeight.w600),
      ),
    );
  }
}

// Custom widget for dashed border
class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double dashLength;
  final double dashGap;
  final Color borderColor;
  final Color? backgroundColor;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 0,
    this.dashLength = 5,
    this.dashGap = 3,
    this.borderColor = Colors.grey,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: borderColor,
          dashLength: dashLength,
          dashGap: dashGap,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double dashLength;
  final double dashGap;
  final double borderRadius;
  final Color color;

  DashedBorderPainter({
    required this.color,
    this.dashLength = 5,
    this.dashGap = 3,
    this.borderRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    ));

    Path dashPath = Path();
    double distance = 0.0;

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + dashGap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Base64ImageContainer extends StatelessWidget {
  final String base64Image;
  final double height;
  final double width;

  const Base64ImageContainer({super.key,
    required this.height,
    required this.width,
    required this.base64Image});

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(base64Image);

    return SizedBox(
      height: height,
      width: width,
      child: Image.memory(
        imageBytes,
        fit: BoxFit.fill,
      ),
    );
  }
}

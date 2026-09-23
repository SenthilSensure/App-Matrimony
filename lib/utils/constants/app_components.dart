import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'app_text_style.dart';

class AppTextField extends StatefulWidget {
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
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

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
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  static const double _hPadding = 14;
  static const double _vPadding = 14;

  late FocusNode _focusNode;
  bool _isOwnFocusNode = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _isOwnFocusNode = widget.focusNode == null;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_isOwnFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  Color get _borderColor {
    if (!widget.enabled) return AppColors.lightGrey;
    return _hasFocus ? AppColors.primaryColor : AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = widget.maxLines > 1;
    final bool hasPrefix = widget.prefixText.isNotEmpty;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: _hasFocus ? 1.6 : 1.2),
        borderRadius: BorderRadius.circular(10),
        color: widget.fillColor ??
            (widget.enabled ? AppColors.white : AppColors.lightGrey),
      ),
      alignment: isMultiline ? Alignment.topLeft : Alignment.center,
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (hasPrefix)
            Padding(
              padding: EdgeInsets.only(
                left: _hPadding,
                top: isMultiline ? _vPadding : 0,
              ),
              child: Text(
                widget.prefixText,
                style: AppTextStyle.black(16, FontWeight.w500),
              ),
            ),
          Expanded(
            child: TextField(
              maxLength: widget.maxLength,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: isMultiline ? widget.maxLines : null,
              textAlign: widget.textAlign,
              keyboardType: widget.inputType,
              obscureText: widget.obscureText,
              controller: widget.controller,
              style: AppTextStyle.black(16, FontWeight.normal),
              cursorColor: AppColors.primaryColor,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              autofillHints: widget.autofillHints,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap != null ? () => widget.onTap!() : null,
              onChanged: (value) => widget.onChanged?.call(value),
              inputFormatters: widget.inputFormatters,
              focusNode: _focusNode,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                hintText: widget.hint,
                counterText: '',
                hintStyle: AppTextStyle.grey(15, FontWeight.normal),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // Single source of truth for the inner spacing.
                contentPadding: EdgeInsets.only(
                  left: hasPrefix ? 6 : _hPadding,
                  right: widget.suffixIcon != null ? 4 : _hPadding,
                  top: _vPadding,
                  bottom: _vPadding,
                ),
                suffixIcon: widget.suffixIcon == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(right: _hPadding - 4),
                        child: widget.suffixIcon,
                      ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
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
  final String hint;

  const AppPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.suffixIcon,
    this.onChanged,
    this.enabled = true,
    this.fillColor,
    this.hint = '',
  });

  @override
  Widget build(BuildContext context) {
    // Reuse AppTextField so spacing/borders stay identical everywhere.
    return AppTextField(
      controller: controller,
      hint: hint,
      obscureText: obscureText,
      enabled: enabled,
      fillColor: fillColor,
      onChanged: onChanged,
      suffixIcon: suffixIcon,
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
    final TextStyle style =
        textStyle ?? AppTextStyle.black(15, FontWeight.w600);
    return isMandatory
        ? Text.rich(
            TextSpan(
              text: text,
              style: style,
              children: const [
                TextSpan(
                  text: ' ${AppStrings.mandatorySymbol}',
                  style: TextStyle(color: AppColors.red),
                ),
              ],
            ),
            textAlign: textAlign,
          )
        : Text(
            text,
            style: style,
            textAlign: textAlign,
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
        border: Border.all(color: AppColors.border, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: child,
    );
  }
}

class AppButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool enabled;
  final double height;

  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.enabled = true,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          disabledBackgroundColor: AppColors.lightGrey,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.grey,
          elevation: enabled ? 1 : 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        onPressed: enabled ? () => onTap() : null,
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
          backgroundColor: AppColors.buttonColor,
          disabledBackgroundColor: AppColors.lightGrey,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          elevation: enabled ? 1 : 0,
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

/// Reusable OTP input.
///
/// Renders [length] boxes but is driven by ONE hidden [TextField]. That keeps
/// backspace, paste, SMS autofill and web keyboards working correctly, which a
/// "one TextField per box" implementation usually breaks.
class AppOtpField extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final bool autoFocus;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const AppOtpField({
    super.key,
    required this.controller,
    this.length = 4,
    this.autoFocus = true,
    this.hasError = false,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(() => setState(() {}));
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    setState(() {});
    final String value = widget.controller.text;
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      _focusNode.unfocus();
      widget.onCompleted?.call(value);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The real (invisible) input that holds the value.
        Opacity(
          opacity: 0,
          child: SizedBox(
            height: 56,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: const InputDecoration(counterText: ''),
            ),
          ),
        ),
        // The visible boxes.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Keep the caret at the end when re-focusing.
              widget.controller.selection = TextSelection.collapsed(
                offset: widget.controller.text.length,
              );
              _focusNode.requestFocus();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.length, _box),
            ),
          ),
        ),
      ],
    );
  }

  Widget _box(int index) {
    final String text = widget.controller.text;
    final bool filled = index < text.length;
    final bool active = _focusNode.hasFocus && index == text.length;

    Color borderColor = AppColors.border;
    if (widget.hasError) {
      borderColor = AppColors.red;
    } else if (active) {
      borderColor = AppColors.primaryColor;
    } else if (filled) {
      borderColor = AppColors.primaryColor.withValues(alpha: 0.5);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56,
        width: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled
              ? AppColors.primaryColor.withValues(alpha: 0.06)
              : AppColors.white,
          border: Border.all(color: borderColor, width: active ? 2 : 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: filled
            ? Text(text[index], style: AppTextStyle.black(20, FontWeight.bold))
            : active
                ? Container(
                    height: 22,
                    width: 2,
                    color: AppColors.primaryColor,
                  )
                : Text('-', style: AppTextStyle.grey(18, FontWeight.normal)),
      ),
    );
  }
}

/// Simple single-select dropdown field used across profile / signup forms.
/// Wraps a [DropdownButtonFormField] with the app's standard box styling.
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final String Function(T)? labelBuilder;
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = '',
    this.labelBuilder,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropDownBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.grey),
          style: AppTextStyle.black(15, FontWeight.normal),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
          hint: Text(hint.isEmpty ? AppStrings.txtSelect : hint,
              style: AppTextStyle.grey(15, FontWeight.normal)),
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      labelBuilder != null ? labelBuilder!(e) : e.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

/// Free-form tag/chip input: type a value and press enter (or tap +) to add
/// it as a removable chip. Used for hobbies, interests, preferred religion,
/// preferred locations, etc.
class AppTagInput extends StatefulWidget {
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String hint;

  const AppTagInput({
    super.key,
    required this.values,
    required this.onChanged,
    this.hint = 'Type and press enter',
  });

  @override
  State<AppTagInput> createState() => _AppTagInputState();
}

class _AppTagInputState extends State<AppTagInput> {
  final TextEditingController _ctrl = TextEditingController();

  void _add(String value) {
    final String v = value.trim();
    if (v.isEmpty || widget.values.contains(v)) return;
    widget.onChanged([...widget.values, v]);
    _ctrl.clear();
  }

  void _remove(String value) {
    widget.onChanged(widget.values.where((e) => e != value).toList());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _ctrl,
          hint: widget.hint,
          textInputAction: TextInputAction.done,
          onSubmitted: _add,
          suffixIcon: IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: AppColors.primaryColor, size: 20),
            onPressed: () => _add(_ctrl.text),
          ),
        ),
        if (widget.values.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.values
                .map((v) => Chip(
                      label: Text(v, style: AppTextStyle.black(13, FontWeight.normal)),
                      backgroundColor: AppColors.softPink.withValues(alpha: 0.5),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _remove(v),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Multi-select chip group where options are chosen from a fixed list
/// (e.g. preferred diet, preferred marital status).
class AppMultiSelectChips extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const AppMultiSelectChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final bool isSelected = selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (sel) {
            final List<String> updated = List.of(selected);
            if (sel) {
              updated.add(option);
            } else {
              updated.remove(option);
            }
            onChanged(updated);
          },
          labelStyle: isSelected
              ? AppTextStyle.white(13, FontWeight.w600)
              : AppTextStyle.black(13, FontWeight.normal),
          selectedColor: AppColors.primaryColor,
          backgroundColor: AppColors.white,
          checkmarkColor: AppColors.white,
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : AppColors.border,
          ),
        );
      }).toList(),
    );
  }
}


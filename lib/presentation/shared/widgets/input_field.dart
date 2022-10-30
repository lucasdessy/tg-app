import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

class AppInputField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? label;
  final String? placeholderText;
  final bool isPassword;
  final TextInputType? inputType;
  final bool enabled;
  final void Function(String)? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool multiline;
  final Color fillColor;
  final Color textColor;
  const AppInputField({
    Key? key,
    this.inputFormatters,
    this.controller,
    this.label,
    this.placeholderText,
    this.isPassword = false,
    this.inputType,
    this.enabled = true,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.multiline = false,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late bool showPassword;

  @override
  void initState() {
    super.initState();

    showPassword = widget.isPassword;
  }

  void _handlePasswordIcon() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = SharedConfigs.colors.neutral;
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            TextFormField(
              maxLines: widget.multiline ? 4 : 1,
              onChanged: widget.onChanged,
              controller: widget.controller,
              inputFormatters: widget.inputFormatters,
              obscureText: showPassword,
              style: TextStyle(color: widget.textColor),
              keyboardType: widget.inputType,
              autocorrect: !showPassword,
              enableSuggestions: !showPassword,
              initialValue: widget.initialValue,
              validator: widget.validator,
              decoration: InputDecoration(
                fillColor: widget.fillColor,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: _handlePasswordIcon,
                        splashColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          showPassword
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                suffixIconColor: Colors.grey,
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: widget.placeholderText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

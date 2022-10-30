import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

class AppButton extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool useConstraints;
  final AppButtonStyle style;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;
  final Duration? duration;
  final bool center;

  const AppButton(
      {this.padding,
      this.margin,
      this.useConstraints = false,
      this.style = AppButtonStyle.primary,
      required this.child,
      required this.onPressed,
      this.color,
      this.gradient,
      this.duration,
      this.center = true,
      Key? key})
      : assert((color == null && gradient != null) ||
            (color != null && gradient == null) ||
            (color == null && gradient == null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color;
    BoxBorder border = Border.all(color: Colors.transparent);
    late BorderRadius borderRadius;
    late EdgeInsets padding;
    final Color textColor = onPressed == null ? Colors.grey : Colors.white;

    switch (style) {
      case AppButtonStyle.primary:
        color = onPressed == null
            ? SharedConfigs.colors.secondary.withOpacity(0.3)
            : SharedConfigs.colors.secondary;
        borderRadius = BorderRadius.circular(12);
        padding = const EdgeInsets.all(16);
        break;
      case AppButtonStyle.transparent:
        color = Colors.transparent;
        borderRadius = BorderRadius.circular(12);
        padding = const EdgeInsets.all(16);
        break;
      case AppButtonStyle.rounded:
        color = Colors.transparent;
        border = Border.all(color: SharedConfigs.colors.secondary);
        borderRadius = BorderRadius.circular(90);
        padding = const EdgeInsets.all(12);
        break;
    }
    padding = this.padding ?? padding;
    color = gradient != null ? null : this.color ?? color;

    return LayoutBuilder(
      builder: (context, constraints) {
        double? size;
        if (style == AppButtonStyle.rounded && useConstraints) {
          // Make width and height equal to the smallest of the width and height of the constraints.
          size = math.min(constraints.maxWidth, constraints.maxHeight);
        }
        // Make sure size is not infinite or NaN.
        size = size?.isFinite == true ? size : null;

        return AnimatedContainer(
          duration: duration ?? const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          height: size,
          width: size,
          margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            gradient: gradient,
            color: color,
          ),
          child: Material(
            borderRadius: borderRadius,
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onPressed,
              child: Padding(
                padding: padding,
                child: DefaultTextStyle(
                  style: TextStyle(color: textColor),
                  child: center
                      ? Center(
                          child: child,
                        )
                      : child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum AppButtonStyle {
  primary,
  transparent,
  rounded,
}

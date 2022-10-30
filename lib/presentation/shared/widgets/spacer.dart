import 'package:flutter/material.dart';

class AppSpacer extends StatelessWidget {
  final bool bigSpace;
  final bool horizontal;
  const AppSpacer({this.bigSpace = false, this.horizontal = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: horizontal
          ? 0
          : bigSpace
              ? 30
              : 14,
      width: horizontal
          ? bigSpace
              ? 30
              : 14
          : 0,
    );
  }
}

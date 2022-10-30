import 'package:flutter/material.dart';

import '../config.dart';

class AppWrap extends StatelessWidget {
  final List<Widget> children;
  final bool bigSpacing;
  final WrapAlignment alignment;
  const AppWrap(
      {required this.children,
      this.bigSpacing = false,
      this.alignment = WrapAlignment.spaceEvenly,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      runSpacing: bigSpacing
          ? SharedConfigs.padding.vertical
          : SharedConfigs.padding.top,
      children: children,
    );
  }
}

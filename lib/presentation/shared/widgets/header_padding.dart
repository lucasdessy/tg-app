import 'package:flutter/material.dart';
import 'package:sales_platform_app/presentation/shared/widgets/profile_header.dart';

EdgeInsets getHeaderPadding(BuildContext context) {
  // final mediaQuery = MediaQuery.of(context);
  // final padding = mediaQuery.padding;
  // final topPadding = padding.top + ProfileHeader.height;
  const topPadding = ProfileHeader.height;
  return const EdgeInsets.only(top: topPadding);
}

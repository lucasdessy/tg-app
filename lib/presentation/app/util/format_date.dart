import 'dart:developer' as developer;

import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get format => DateFormat("dd/MM/yyyy").format(this);
}

extension StringFormatter on String {
  DateTime? get parseDate {
    try {
      return DateFormat("dd/MM/yyyy").parse(this);
    } catch (err) {
      developer.log("Error on StringFormatter.parse: $err");
      return null;
    }
  }
}

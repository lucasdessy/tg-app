import 'dart:developer' as dev;

mixin Printable on Object {
  void log(Object? o) {
    dev.log('[$runtimeType] $o');
  }
}

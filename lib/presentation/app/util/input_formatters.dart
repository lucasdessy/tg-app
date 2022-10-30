import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppMasks {
  static final foneMask = _FoneMask();
  static final celularMask = _CelularMask();
  static final cpfMask = _CpfMask();
  static final dataMask = _DataMask();
  static final estadoMask = _EstadoMask();
  static final cepMask = _CepMask();
}

// ignore: library_private_types_in_public_api
extension BuildInputMask on _AppMask {
  MaskTextInputFormatter get toMask => MaskTextInputFormatter(
        mask: mask,
        filter: filter,
        type: MaskAutoCompletionType.lazy,
      );
}

abstract class _AppMask {
  String get mask;
  int get length;
  Map<String, RegExp> get filter;
}

class _FoneMask extends _AppMask {
  @override
  String get mask => '+ 55 (##) ####-####';
  @override
  int get length => 10;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

class _CelularMask extends _AppMask {
  @override
  String get mask => '+ 55 (##) #####-####';
  @override
  int get length => 11;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

class _CpfMask extends _AppMask {
  @override
  String get mask => '###.###.###-##';
  @override
  int get length => 11;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

class _DataMask extends _AppMask {
  @override
  String get mask => '##/##/####';
  @override
  int get length => 8;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

class _EstadoMask extends _AppMask {
  @override
  String get mask => '##';
  @override
  int get length => 2;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

class _CepMask extends _AppMask {
  @override
  String get mask => '#####-###';
  @override
  int get length => 8;
  @override
  Map<String, RegExp> get filter => {
        "#": RegExp(r'\d'),
      };
}

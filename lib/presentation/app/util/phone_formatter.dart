import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../domain/util/print.dart';
import 'input_formatters.dart';

class AppFoneCelularMask extends MaskTextInputFormatter with Printable {
  AppFoneCelularMask()
      : super(
          mask: AppMasks.foneMask.mask,
          filter: AppMasks.foneMask.filter,
          type: MaskAutoCompletionType.lazy,
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String? mask = getMask();
    if (oldValue.text.isNotEmpty) {
      final String numbers = newValue.text.replaceAll(RegExp("[^0-9]"), "");
      final length = numbers.length - 2; //tira o +55;
      if (length <= AppMasks.foneMask.length) {
        if (mask != AppMasks.foneMask.mask) {
          log('switching to foneMask');
          updateMask(mask: AppMasks.foneMask.mask);
        }
      } else {
        if (mask != AppMasks.celularMask.mask) {
          log('switching to celularMask');
          updateMask(mask: AppMasks.celularMask.mask);
        }
      }
    }
    return super.formatEditUpdate(oldValue, newValue);
  }
}

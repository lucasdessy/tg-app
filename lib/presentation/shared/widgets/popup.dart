import 'package:flutter/material.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

Future<void> buildAppPopup(
  BuildContext context, {
  required String title,
  required List<Widget> children,
  required String actionLabel,
  required VoidCallback onAction,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DefaultTextStyle(
        style: TextStyle(color: SharedConfigs.colors.secondary),
        child: AlertDialog(
          backgroundColor: SharedConfigs.colors.primary,
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: children),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                onAction();
                Navigator.of(context).pop();
              },
              child: Text(
                actionLabel,
                style: TextStyle(color: SharedConfigs.colors.neutral),
              ),
            ),
          ],
        ),
      );
    },
  );
}

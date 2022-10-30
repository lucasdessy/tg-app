import 'package:flutter/material.dart';

void buildAppSnackBar(BuildContext context,
    {required String message, Icon? icon, bool isFailure = false}) {
  const textColor = Colors.white;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textColor,
              ),
            ),
          ),
          if (icon != null) icon,
        ],
      ),
      backgroundColor: isFailure ? Colors.red : Colors.green,
    ),
  );
}

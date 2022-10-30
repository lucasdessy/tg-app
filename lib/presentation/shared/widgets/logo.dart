import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      // width: MediaQuery.of(context).size.width * 0.5,
      child: Image.asset('assets/logo.png'),
    );
  }
}

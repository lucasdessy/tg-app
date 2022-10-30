import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/auth/auth_cubit.dart';

import '../app/router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => BlocProvider.of<AuthCubit>(context).authCheck());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.mapOrNull(
            authenticated: (state) => Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.home.path, (route) => false),
            unauthenticated: (state) => Navigator.of(context)
                .pushNamedAndRemoveUntil(
                    AppRoutes.login.path, (route) => false),
          );
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

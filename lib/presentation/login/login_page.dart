import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/input_field.dart';
import 'package:sales_platform_app/presentation/shared/widgets/logo.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';

import '../../application/auth/login/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends StatelessWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.failure != null) {
          buildAppSnackBar(
            context,
            message: state.failure!,
            isFailure: true,
            icon: const Icon(Icons.error),
          );
          context.read<LoginCubit>().clean();
        }
        if (state.isSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home.path);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: SharedConfigs.padding,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const AppLogo(),
              const AppSpacer(
                bigSpace: true,
              ),
              AppInputField(
                label: "E-MAIL",
                placeholderText: "Digite seu email",
                enabled: !state.isSubmitting,
                onChanged: context.read<LoginCubit>().onEmailChanged,
                initialValue: context.read<LoginCubit>().state.email,
              ),
              AppInputField(
                label: "SENHA",
                placeholderText: "Digite sua senha",
                isPassword: true,
                enabled: !state.isSubmitting,
                onChanged: context.read<LoginCubit>().onPasswordChanged,
                initialValue: context.read<LoginCubit>().state.password,
              ),
              const AppSpacer(),
              AppButton(
                child: SizedBox(
                  height: 18,
                  child: Center(
                    child: state.isSubmitting
                        ? const CupertinoActivityIndicator()
                        : const Text("ENTRAR"),
                  ),
                ),
                onPressed: () => context.read<LoginCubit>().onLoginPressed(),
              ),
              AppButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.resetPassword.path);
                },
                style: AppButtonStyle.transparent,
                child: const Text("ESQUECI MINHA SENHA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

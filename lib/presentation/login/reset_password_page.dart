import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/auth/login/reset_password/reset_password_cubit.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/input_field.dart';
import 'package:sales_platform_app/presentation/shared/widgets/logo.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/text.dart';

import '../shared/widgets/snackbar.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResetPasswordCubit>(),
      child: const _ResetPasswordPage(),
    );
  }
}

class _ResetPasswordPage extends StatelessWidget {
  const _ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ResetPasswordCubit>();
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
          buildAppSnackBar(
            context,
            message:
                "Um link para redefinição de senha foi enviado para o seu e-mail.",
            icon: const Icon(Icons.check),
            isFailure: false,
          );
        }
        if (state.failure != null) {
          buildAppSnackBar(
            context,
            message: state.failure!,
            icon: const Icon(Icons.error),
            isFailure: true,
          );
          cubit.cleanState();
        }
      },
      child: Scaffold(
        body: cubit.state.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SafeArea(
                child: ListView(
                  padding: SharedConfigs.padding,
                  children: [
                    const AppSpacer(bigSpace: true),
                    const AppLogo(),
                    const AppSpacer(bigSpace: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: const [
                          AppText(
                              text: "Insira o seu e-mail para\n"
                                  "recuperar a senha",
                              bold: true),
                          AppSpacer(),
                          AppText(
                            text: "Um link para redefinir sua senha "
                                "será enviado para o e-mail cadastrado em "
                                "sua conta",
                          ),
                        ],
                      ),
                    ),
                    const AppSpacer(bigSpace: true),
                    AppInputField(
                      label: "E-MAIL",
                      placeholderText: "Digite seu email",
                      onChanged: cubit.onEmailChanged,
                    ),
                    Row(
                      children: [
                        AppButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: AppButtonStyle.rounded,
                          child: const Icon(CupertinoIcons.chevron_left),
                        ),
                        const AppSpacer(horizontal: true),
                        Expanded(
                          child: AppButton(
                            onPressed: () {
                              cubit.onResetPassword();
                            },
                            child: const Text("ENVIAR"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

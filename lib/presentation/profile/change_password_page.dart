import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/change_password/change_password_cubit.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';

import '../shared/config.dart';
import '../shared/widgets/button.dart';
import '../shared/widgets/input_field.dart';
import '../shared/widgets/logo.dart';
import '../shared/widgets/spacer.dart';
import '../shared/widgets/text.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordCubit>(),
      child: const _ChangePasswordPage(),
    );
  }
}

class _ChangePasswordPage extends StatelessWidget {
  const _ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChangePasswordCubit>();
    final state = cubit.state;
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.error != null) {
          buildAppSnackBar(
            context,
            message: state.error!,
            icon: const Icon(Icons.error),
            isFailure: true,
          );
          cubit.clear();
        }
        if (state.isDone) {
          buildAppSnackBar(
            context,
            message: 'Senha alterada com sucesso!',
            icon: const Icon(Icons.done),
            isFailure: false,
          );
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: state.loading
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
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: const [
                          AppText(text: "Altere sua senha", bold: true),
                          AppSpacer(),
                          AppText(
                            text: "Insira sua nova senha"
                                " e confirme para realizar o seu acesso",
                          ),
                        ],
                      ),
                    ),
                    const AppSpacer(bigSpace: true),
                    AppInputField(
                      label: "SENHA ATUAL",
                      placeholderText: "Digite sua senha atual",
                      isPassword: true,
                      onChanged: cubit.onCurrentPasswordChanged,
                    ),
                    AppInputField(
                      label: "NOVA SENHA",
                      placeholderText: "Crie uma senha",
                      isPassword: true,
                      onChanged: cubit.onNewPasswordChanged,
                    ),
                    AppInputField(
                      label: "CONFIRMAR SENHA",
                      placeholderText: "Confirme sua senha",
                      isPassword: true,
                      onChanged: cubit.onConfirmPasswordChanged,
                    ),
                    const AppSpacer(bigSpace: true),
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
                              cubit.submit();
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

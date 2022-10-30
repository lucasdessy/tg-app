import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/user_cubit.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

import '../../../application/auth/auth_cubit.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();
    final user = userCubit.state.user;
    return Drawer(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: SharedConfigs.colors.primary,
                        ),
                        child: userCubit.state.loading
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        SharedConfigs.colors.tertiary,
                                    foregroundImage: (user?.profileImageUrl !=
                                                null &&
                                            user!.profileImageUrl!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                            user.profileImageUrl!)
                                        : AssetImage(SharedConfigs
                                            .noUserImage())) as ImageProvider,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${user?.name}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      ListTile(
                        title: const Text('Dados Pessoais'),
                        leading: const Icon(Icons.person_outline),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(AppRoutes.editProfile.path);
                        },
                      ),
                      ListTile(
                        title: const Text('Alterar Senha'),
                        leading: const Icon(Icons.lock_outline),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.changePassword.path);
                        },
                      ),
                      if (userCubit.state.telegramLink != null)
                        ListTile(
                          title: const Text('Telegram'),
                          leading: const Icon(Icons.send_outlined),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: userCubit.onTelegramClick,
                        ),
                      if (userCubit.state.helpLink != null)
                        ListTile(
                          title: const Text('Central de ajuda'),
                          leading: const Icon(Icons.help_outline),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: userCubit.onHelpCenterClick,
                        ),
                      // const Spacer(),
                    ],
                  ),
                  ListTile(
                    title: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(Icons.exit_to_app, color: Colors.red),
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login.path,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

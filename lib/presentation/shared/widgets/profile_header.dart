import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/user_cubit.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

class ProfileHeader extends StatelessWidget {
  static const height = 120.0;
  final VoidCallback onTap;
  const ProfileHeader({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserCubit>();
    final state = cubit.state;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          color: SharedConfigs.colors.tertiary.withOpacity(0.7),
          padding: SharedConfigs.padding,
          height: height,
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: state.loading
                ? const CupertinoActivityIndicator()
                : GestureDetector(
                    onTap: onTap,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: SharedConfigs.colors.tertiary,
                          foregroundImage: (state.user?.profileImageUrl !=
                                          null &&
                                      state.user!.profileImageUrl!.isNotEmpty
                                  ? CachedNetworkImageProvider(
                                      state.user!.profileImageUrl!)
                                  : AssetImage(SharedConfigs.noUserImage()))
                              as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Text('${state.user?.name}'),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

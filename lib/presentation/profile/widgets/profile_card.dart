import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/profile/widgets/mini_profile.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';

import '../../../application/user/user_view_model.dart';

class ProfileCard extends StatelessWidget {
  final UserViewModel? user;
  final bool isForEditPage;
  final void Function(String?)? onEditProfile;
  final VoidCallback? onEditProfileImage;
  final bool isEditing;
  final bool loading;
  const ProfileCard(
      {required this.user,
      required this.isForEditPage,
      this.onEditProfile,
      this.onEditProfileImage,
      this.isEditing = false,
      required this.loading,
      Key? key})
      : assert((isForEditPage && onEditProfile != null) ||
            (!isForEditPage && onEditProfile == null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Material(
      color: SharedConfigs.colors.tertiary,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        padding: SharedConfigs.padding.copyWith(top: mediaQuery.padding.top),
        child: Stack(
          children: [
            loading
                ? Center(
                    child: Padding(
                      padding: SharedConfigs.padding,
                      child: const CupertinoActivityIndicator(),
                    ),
                  )
                : MiniProfile(
                    editing: isEditing,
                    onProfilePressed: onEditProfileImage,
                    onEditPressed: (value) {
                      if (!isForEditPage) {
                        Navigator.of(context).pushNamed(
                          AppRoutes.editProfile.path,
                        );
                      } else {
                        onEditProfile!(value);
                      }
                    },
                    user: user,
                  ),
            if (!isForEditPage)
              Align(
                alignment: Alignment.topRight,
                child: AppButton(
                  center: false,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  style: AppButtonStyle.transparent,
                  child: const Icon(
                    Icons.menu,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

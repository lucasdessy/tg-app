import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/profile_medias_cubit.dart';
import 'package:sales_platform_app/application/user/user_cubit.dart';
import 'package:sales_platform_app/presentation/profile/widgets/drawer.dart';
import 'package:sales_platform_app/presentation/profile/widgets/instagram_builder.dart';
import 'package:sales_platform_app/presentation/profile/widgets/profile_card.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/popup.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediasState = context.watch<ProfileMediasCubit>().state;
    final atLeastOneMediaSelected = mediasState.selectedPictures.isNotEmpty;

    return BlocListener<ProfileMediasCubit, ProfileMediasState>(
      listener: (context, state) {
        if (state.error != null) {
          buildAppSnackBar(
            context,
            message: state.error!,
            isFailure: true,
            icon: const Icon(Icons.error),
          );
          context.read<ProfileMediasCubit>().clear();
        }

        if (state.isDownloadingSuccess) {
          buildAppSnackBar(
            context,
            message: 'Fotos baixadas com sucesso',
            isFailure: false,
            icon: const Icon(Icons.check),
          );
          context.read<ProfileMediasCubit>().clear();
        }
      },
      child: Scaffold(
        endDrawer: const ProfileDrawer(),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<UserCubit>().getUser();
              context.read<ProfileMediasCubit>().loadPictures();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileCard(
                  user: context.select((UserCubit cubit) => cubit.state.user),
                  isForEditPage: false,
                  loading:
                      context.select((UserCubit cubit) => cubit.state.loading),
                ),
                const AppSpacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Fotos",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 65,
                            child: mediasState.isEditMode
                                ? IgnorePointer(
                                    ignoring: !atLeastOneMediaSelected,
                                    child: Opacity(
                                      opacity:
                                          atLeastOneMediaSelected ? 1 : 0.5,
                                      child: AppButton(
                                        onPressed: () {
                                          context
                                              .read<ProfileMediasCubit>()
                                              .downloadPictures();
                                        },
                                        style: AppButtonStyle.transparent,
                                        padding: const EdgeInsets.all(6),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Baixar",
                                            ),
                                            Icon(Icons.download),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(
                            height: 65,
                            child: mediasState.isEditMode
                                ? IgnorePointer(
                                    ignoring: !atLeastOneMediaSelected,
                                    child: Opacity(
                                      opacity:
                                          atLeastOneMediaSelected ? 1 : 0.5,
                                      child: AppButton(
                                        onPressed: () {
                                          // context
                                          //     .read<ProfileMediasCubit>()
                                          //     .deletePictures();
                                          buildAppPopup(
                                            context,
                                            title: "Excluir fotos",
                                            children: [
                                              const Text(
                                                  "Deseja excluir as fotos selecionadas?"),
                                            ],
                                            actionLabel: "Excluir",
                                            onAction: () {
                                              context
                                                  .read<ProfileMediasCubit>()
                                                  .deletePictures();
                                            },
                                          );
                                        },
                                        style: AppButtonStyle.transparent,
                                        padding: const EdgeInsets.all(6),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Excluir",
                                            ),
                                            Icon(Icons.delete),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                        child: mediasState.isLoading
                            ? const CupertinoActivityIndicator()
                            : const InstagramBuilder())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

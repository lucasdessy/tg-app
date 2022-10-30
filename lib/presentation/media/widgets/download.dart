import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';

import '../../../application/media/download/download_cubit.dart';
import '../../../domain/download/download_type.dart';

class DownloadWidget extends StatelessWidget {
  final String id;
  const DownloadWidget({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonGradient = LinearGradient(
      colors: [
        SharedConfigs.colors.secondary,
        SharedConfigs.colors.tertiary,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final buttonGradientDisabled = LinearGradient(
      colors: [
        SharedConfigs.colors.tertiary,
        SharedConfigs.colors.tertiary,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final cubit = context.watch<DownloadCubit>();
    const padding = 35.0;
    return BlocListener<DownloadCubit, DownloadState>(
      listener: (context, state) {
        if (state.doneDownloading == true) {
          buildAppSnackBar(context,
              message: "Download completo.", icon: const Icon(Icons.check));
          cubit.clean();
        }
        if (state.error != null) {
          buildAppSnackBar(context,
              message: state.error!,
              icon: const Icon(Icons.error),
              isFailure: true);
          cubit.clean();
        }
      },
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: SharedConfigs.colors.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: padding, top: padding, right: padding),
              child: Column(
                children: const [
                  Text(
                    "Escolha o formato que deseja baixar esse vídeo: ",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onPressed: () =>
                            cubit.setDownloadType(DownloadType.horizontal),
                        style: AppButtonStyle.rounded,
                        useConstraints: true,
                        gradient:
                            cubit.state.downloadType == DownloadType.horizontal
                                ? buttonGradient
                                : buttonGradientDisabled,
                        child: const Icon(Icons.laptop),
                      ),
                      const Text("Horizontal"),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onPressed: () =>
                            cubit.setDownloadType(DownloadType.story),
                        style: AppButtonStyle.rounded,
                        useConstraints: true,
                        gradient: cubit.state.downloadType == DownloadType.story
                            ? buttonGradient
                            : buttonGradientDisabled,
                        child: const Icon(Icons.smartphone),
                      ),
                      const Text("Story"),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onPressed: () =>
                            cubit.setDownloadType(DownloadType.feed),
                        style: AppButtonStyle.rounded,
                        useConstraints: true,
                        gradient: cubit.state.downloadType == DownloadType.feed
                            ? buttonGradient
                            : buttonGradientDisabled,
                        child: const Icon(Icons.tablet),
                      ),
                      const Text("Feed"),
                    ],
                  ),
                ),
              ],
            )),
            const AppSpacer(),
            AppButton(
              duration: const Duration(milliseconds: 20),
              onPressed: cubit.state.downloadType == null
                  ? null
                  : () {
                      cubit.download(id);
                    },
              margin: EdgeInsets.zero,
              gradient: cubit.state.startedDownloading
                  ? LinearGradient(
                      colors: [
                        SharedConfigs.colors.secondary,
                        SharedConfigs.colors.secondary,
                        SharedConfigs.colors.tertiary,
                        SharedConfigs.colors.tertiary,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        0.0,
                        (cubit.state.progress ?? 0.0) - 0.05,
                        (cubit.state.progress ?? 0.0) + 0.05,
                        1.0
                      ],
                    )
                  : LinearGradient(colors: [
                      SharedConfigs.colors.secondary,
                      SharedConfigs.colors.secondary,
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              child: Text(
                  cubit.state.startedDownloading ? "BAIXANDO..." : "BAIXAR"),
            )
          ],
        ),
      ),
    );
  }
}

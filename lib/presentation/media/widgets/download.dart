import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';

import '../../../application/media/download/download_cubit.dart';

class DownloadWidget extends StatelessWidget {
  final String id;
  const DownloadWidget({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DownloadCubit>();
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
        child: AppButton(
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
          child:
              Text(cubit.state.startedDownloading ? "BAIXANDO..." : "BAIXAR"),
        ));
  }
}

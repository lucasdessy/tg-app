import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/media/widgets/header.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/header_padding.dart';
import 'package:sales_platform_app/presentation/shared/widgets/medias_builder.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';

import '../../application/media/medias_cubit.dart';
import 'media_page.dart';

class MediasPage extends StatelessWidget {
  const MediasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MediasCubit>();
    final state = cubit.state;
    final headerPadding = getHeaderPadding(context);
    return Scaffold(
      body: state.isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SafeArea(
              top: false,
              child: RefreshIndicator(
                onRefresh: cubit.getMedias,
                displacement: headerPadding.top,
                child: ListView(
                  padding: headerPadding,
                  children: [
                    const MediasPageHeader(),
                    Padding(
                      padding: SharedConfigs.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AppSpacer(),
                          const Text(
                            "Vídeos",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const AppSpacer(),
                          MediasBuilder(
                            medias: state.medias,
                            onTap: (id) {
                              Navigator.of(context).pushNamed(
                                AppRoutes.media.path,
                                arguments: MediaPageProps(id: id),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

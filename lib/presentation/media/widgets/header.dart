import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/media/medias_cubit.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';

class MediasPageHeader extends StatelessWidget {
  const MediasPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaHeaderImageUrl = context.select(
      (MediasCubit cubit) => cubit.state.mediaHeaderUrl,
    );
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (mediaHeaderImageUrl != null)
            CachedNetworkImage(
              imageUrl: mediaHeaderImageUrl,
              fit: BoxFit.cover,
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, SharedConfigs.colors.primary],
                stops: const [0.0, 0.95],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        SharedConfigs.colors.secondary,
                        SharedConfigs.colors.tertiary,
                      ],
                      stops: const [0.0, 1.3],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_movies_outlined,
                      size: 45, color: Colors.white),
                ),
                const AppSpacer(),
                const Text(
                  "Mídias",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

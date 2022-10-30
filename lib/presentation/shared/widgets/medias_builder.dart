import 'package:flutter/material.dart';
import 'package:sales_platform_app/domain/media/media_model.dart';

import '../config.dart';
import 'card.dart';

class MediasBuilder extends StatelessWidget {
  final List<MediaModel> medias;
  final void Function(String) onTap;
  const MediasBuilder({required this.onTap, required this.medias, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     // Calculate so the card shows at least two cards

    //     final width =
    //         (constraints.minWidth / 2) - (SharedConfigs.padding.horizontal / 2);

    //     return AppWrap(
    //       children: medias
    //           .map<Widget>(
    //             (media) => AppCard(
    //               id: media.id!,
    //               onTap: onTap,
    //               title: media.videoName,
    //               blurHash: media.blurHash,
    //               size: width,
    //               image: (media.thumb),
    //             ),
    //           )
    //           .toList(),
    //     );
    //   },
    // );
    return GridView.builder(
        padding: SharedConfigs.padding,
        itemCount: medias.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          final media = medias[index];
          return AppCard(
            id: media.id!,
            onTap: onTap,
            title: media.videoName,
            blurHash: media.blurHash,
            image: (media.thumb),
          );
        });
  }
}

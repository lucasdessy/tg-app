import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../config.dart';

class AppCard extends StatelessWidget with Printable {
  final String id;
  final void Function(String) onTap;
  final String title;
  final String? blurHash;
  final String image;
  final double? size;
  final double? aspectRatio;
  final bool showPlayButton;
  const AppCard(
      {required this.id,
      required this.onTap,
      required this.title,
      this.blurHash,
      required this.image,
      this.size,
      this.aspectRatio,
      this.showPlayButton = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalWidth = (size ?? 160);
    final finalHeight = finalWidth * (aspectRatio ?? 1);
    log("finalWidth: $finalWidth, finalHeight: $finalHeight");
    return SizedBox(
      width: finalWidth,
      height: finalHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: SharedConfigs.colors.tertiary,
          child: InkWell(
            onTap: () => onTap(id),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => blurHash != null
                            ? BlurHash(
                                hash: blurHash!,
                              )
                            : const CupertinoActivityIndicator(),
                      ),
                      if (showPlayButton)
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.play_arrow),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

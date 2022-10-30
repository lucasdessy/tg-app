import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sales_platform_app/application/training/training_view_model.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/text.dart';

class TrainingCard extends StatelessWidget {
  final void Function(String)? onTap;
  final TrainingViewModel viewModel;
  const TrainingCard({required this.onTap, required this.viewModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final fullHeight = width * (11 / 16);
        final imageHeight = width * (9 / 16);
        final remainingHeight = fullHeight - imageHeight;
        return SizedBox(
          height: fullHeight,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: SharedConfigs.colors.tertiary,
              child: InkWell(
                onTap: () {
                  onTap?.call(viewModel.data.id!);
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: width,
                      child: CachedNetworkImage(
                          imageUrl: viewModel.data.thumb, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: SharedConfigs.colors.primary,
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.play_arrow, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "JÁ DISPONÍVEL",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_outlined, size: 56),
                          const SizedBox(
                            height: 18,
                          ),
                          AppText(text: viewModel.data.videoName, bold: true),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: remainingHeight,
                        width: width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: Row(
                          children: const [
                            Icon(Icons.play_circle_outlined),
                            SizedBox(width: 8),
                            Text("Assistir agora"),
                            Spacer(),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

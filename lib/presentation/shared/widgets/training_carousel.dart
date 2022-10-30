import 'package:flutter/material.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/card.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/wrap.dart';

import '../../../application/training/training_view_model.dart';
import '../config.dart';
import 'text.dart';

class TrainingCarousel extends StatelessWidget with Printable {
  final bool highlightFirst;
  final bool showSeeAll;
  final bool wrap;
  final List<TrainingViewModel> trainings;

  /// Primeira string é o id
  /// Segunda string é o nome da categoria
  final void Function(String?, String) onTap;
  const TrainingCarousel({
    this.highlightFirst = false,
    this.showSeeAll = false,
    this.wrap = false,
    required this.trainings,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('build() ${trainings.length}');
    if (trainings.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final trainingsChildren = <Widget>[];

        for (var i = 0; i < trainings.length; i++) {
          double? aspectRatio;
          double? width;

          // If highlightFirst is true, the first card will be highlighted
          // which means that the first card will have a bigger width
          // and the other cards will have a smaller width
          if (highlightFirst && i == 0) {
            width =
                constraints.maxWidth - (SharedConfigs.padding.horizontal / 2);
            aspectRatio = 11.5 / 16;
          } else {
            width = (constraints.maxWidth / (wrap ? 2 : 2.3)) -
                (SharedConfigs.padding.horizontal / 2);
          }
          final training = trainings[i];
          final trainingWidget = AppCard(
            size: width,
            aspectRatio: aspectRatio,
            id: training.data.id!,
            onTap: (id) => onTap(id, training.data.category),
            image: (training.data.thumb),
            title: training.data.videoName,
            showPlayButton: false,
          );
          trainingsChildren.add(trainingWidget);
          if (!wrap) {
            trainingsChildren.add(SizedBox(width: SharedConfigs.padding.left));
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppButton(
              onPressed: () {
                onTap(null, trainings.first.data.category);
              },
              style: AppButtonStyle.transparent,
              center: false,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisSize: showSeeAll ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: trainings.first.categoryName,
                    bold: true,
                  ),
                  if (showSeeAll)
                    Row(
                      children: [
                        AppText(
                          text: 'Ver tudo',
                          bold: true,
                          color: SharedConfigs.whitenColor(
                              SharedConfigs.colors.secondary),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const AppSpacer(),
            wrap
                ? SizedBox(
                    width: double.infinity,
                    child: AppWrap(
                      bigSpacing: true,
                      children: trainingsChildren,
                    ),
                  )
                : SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(children: trainingsChildren),
                  ),
            const AppSpacer(bigSpace: true),
          ],
        );
      },
    );
  }
}

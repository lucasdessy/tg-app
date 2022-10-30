import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/home/home_cubit.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/widgets/medias_builder.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/training_card.dart';
import 'package:sales_platform_app/presentation/shared/widgets/training_carousel.dart';

import '../../application/media/medias_cubit.dart';
import '../../application/training/trainings_cubit.dart';
import '../../domain/training/category_model.dart';
import '../media/media_page.dart';
import '../shared/config.dart';
import '../shared/widgets/button.dart';
import '../shared/widgets/header_padding.dart';
import '../shared/widgets/text.dart';
import '../training/training_page.dart';

class HomePage extends StatelessWidget {
  final void Function(int) onTap;
  const HomePage({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainingsState = context.watch<TrainingsCubit>().state;
    final mediasState = context.watch<MediasCubit>().state;
    final medias = mediasState.medias.take(2).toList();
    final headerPadding = getHeaderPadding(context);
    final latestCategory =
        CategoryModel.latest().copyWith(name: 'Treinamentos');
    final latestCategories = trainingsState.trainings?[latestCategory.id]
        ?.take(3)
        .map(
          (e) => e.copyWith(
            categoryName: latestCategory.name,
          ),
        )
        .toList();
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          padding: SharedConfigs.padding
              .copyWith(top: headerPadding.top + SharedConfigs.padding.top),
          children: [
            if (trainingsState.latestTraining != null)
              TrainingCard(
                  onTap: (p0) {
                    context.read<HomeCubit>().onHighlightCardTapped();
                    Navigator.of(context).pushNamed(AppRoutes.training.path,
                        arguments: TrainingPageProps(
                          categoryId: latestCategory.id!,
                          id: p0,
                        ));
                  },
                  viewModel: trainingsState.latestTraining!),
            if (latestCategories != null) ...[
              const AppSpacer(bigSpace: true),
              TrainingCarousel(
                highlightFirst: true,
                showSeeAll: true,
                wrap: true,
                trainings: latestCategories,
                onTap: (p0, p1) {
                  if (p0 != null) {
                    Navigator.of(context).pushNamed(
                      AppRoutes.training.path,
                      arguments: TrainingPageProps(
                        categoryId: p1,
                        id: p0,
                      ),
                    );
                  } else {
                    onTap(1);
                  }
                },
              ),
              if (medias.isNotEmpty) ...[
                AppButton(
                  onPressed: () {
                    onTap(2);
                  },
                  style: AppButtonStyle.transparent,
                  center: false,
                  margin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "Mídias",
                        bold: true,
                      ),
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
                MediasBuilder(
                    onTap: (id) {
                      Navigator.of(context).pushNamed(
                        AppRoutes.media.path,
                        arguments: MediaPageProps(id: id),
                      );
                    },
                    medias: medias),
              ]
            ]
          ],
        ),
      ),
    );
  }
}

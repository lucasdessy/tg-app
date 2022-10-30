import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/training_card.dart';
import 'package:sales_platform_app/presentation/shared/widgets/training_carousel.dart';

import '../../application/training/trainings_cubit.dart';
import '../shared/widgets/header_padding.dart';
import 'training_page.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrainingsCubit>();
    final state = cubit.state;
    final headerPadding = getHeaderPadding(context);
    return BlocListener<TrainingsCubit, TrainingsState>(
      listener: (context, state) {
        if (state.failure != null) {
          buildAppSnackBar(context,
              message: state.failure!,
              icon: const Icon(Icons.error),
              isFailure: true);
        }
      },
      child: Scaffold(
        body: state.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SafeArea(
                top: false,
                child: RefreshIndicator(
                  onRefresh: () => cubit.getTrainings(),
                  displacement: headerPadding.top,
                  child: ListView(
                    padding: SharedConfigs.padding.copyWith(
                        top: headerPadding.top + SharedConfigs.padding.top),
                    children: [
                      if (state.latestTraining != null) ...[
                        TrainingCard(
                          viewModel: state.latestTraining!,
                          onTap: (id) {
                            _goToTrainingPage(context, id,
                                state.latestTraining!.data.category);
                          },
                        ),
                        const AppSpacer(bigSpace: true),
                      ],
                      if (state.trainings != null)
                        for (final category in state.trainings!.keys)
                          TrainingCarousel(
                            trainings: state.trainings![category]!,
                            onTap: (id, catId) {
                              _goToTrainingPage(context, id, catId);
                            },
                          )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _goToTrainingPage(BuildContext context, String? id, String categoryId) {
    Navigator.of(context).pushNamed(
      AppRoutes.training.path,
      arguments: TrainingPageProps(
        categoryId: categoryId,
        id: id,
      ),
    );
  }
}

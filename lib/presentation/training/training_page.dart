import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/text.dart';
import 'package:video_player/video_player.dart';

import '../../application/training/training_cubit.dart';
import '../../domain/util/print.dart';
import '../shared/widgets/card.dart';

class TrainingPageProps {
  final String categoryId;
  final String? id;

  const TrainingPageProps({
    required this.categoryId,
    required this.id,
  });
}

class TrainingPage extends StatelessWidget {
  final TrainingPageProps props;
  const TrainingPage({required this.props, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TrainingCubit>()..loadTraining(props.categoryId, props.id),
      child: const _TrainingPage(),
    );
  }
}

class _TrainingPage extends StatefulWidget {
  const _TrainingPage({Key? key}) : super(key: key);

  @override
  State<_TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<_TrainingPage> with Printable {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void dispose() {
    log("Disposing TrainingPage");
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  bool _creating = false;
  Future<void> createVideoController(String url) async {
    if (_creating) return;
    _creating = true;
    log("Creating video controller... with url: $url");
    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Text(
            "Ocorreu um erro ao carregar o vídeo.",
          ),
        );
      },
    );
    log("Video controller created");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrainingCubit>();
    final state = cubit.state;

    return BlocListener<TrainingCubit, TrainingState>(
      listener: (context, state) {
        if (state.mainVideoUrl != null) {
          createVideoController(state.mainVideoUrl!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: state.categoryName != null ? Text(state.categoryName!) : null,
        ),
        body: state.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SafeArea(
                child: ListView(
                  padding: SharedConfigs.padding,
                  children: [
                    if (state.training != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _chewieController != null
                            ? Chewie(controller: _chewieController!)
                            : const CupertinoActivityIndicator(),
                      ),
                    if (state.training != null) ...[
                      const AppSpacer(),
                      AppText(
                        text: state.training!.data.videoName,
                        textAlign: TextAlign.start,
                        bold: true,
                      ),
                      const AppSpacer(
                        bigSpace: true,
                      ),
                    ],
                    // LayoutBuilder(
                    //   builder: (context, constraints) {
                    //     // Calculate so the card shows at least two cards

                    //     final width = (constraints.minWidth / 2) -
                    //         (SharedConfigs.padding.horizontal / 2);

                    //     return AppWrap(
                    //       children: [
                    //         for (final training in state.trainings)
                    //           AppCard(
                    //             id: training.data.id!,
                    //             size: width,

                    //             onTap: (id) {
                    //               Navigator.of(context).pushReplacementNamed(
                    //                 AppRoutes.training.path,
                    //                 arguments: TrainingPageProps(
                    //                   categoryId: state.categoryId,
                    //                   id: id,
                    //                 ),
                    //               );
                    //             },
                    //             image: (training.data.thumb),
                    //             title: training.data.videoName,
                    //           ),
                    //       ],
                    //     );
                    //   },
                    // )
                    GridView.builder(
                        padding: SharedConfigs.padding,
                        itemCount: state.trainings.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          final training = state.trainings[index];
                          return AppCard(
                            id: training.data.id!,
                            onTap: (id) {
                              Navigator.of(context).pushReplacementNamed(
                                AppRoutes.training.path,
                                arguments: TrainingPageProps(
                                  categoryId: state.categoryId,
                                  id: id,
                                ),
                              );
                            },
                            image: (training.data.thumb),
                            title: training.data.videoName,
                          );
                        }),
                  ],
                ),
              ),
      ),
    );
  }
}

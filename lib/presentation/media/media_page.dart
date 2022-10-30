import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/medias_builder.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:video_player/video_player.dart';

import '../../application/media/download/download_cubit.dart';
import '../../application/media/media_cubit.dart';
import '../../injection.dart';
import '../shared/widgets/spacer.dart';
import 'widgets/download.dart';

class MediaPageProps {
  final String id;

  const MediaPageProps({
    required this.id,
  });
}

class MediaPage extends StatelessWidget {
  final MediaPageProps props;
  const MediaPage({required this.props, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<MediaCubit>()..loadMedia(props.id),
        ),
        BlocProvider(
          create: (_) => getIt<DownloadCubit>(),
        ),
      ],
      child: const _MediaPage(),
    );
  }
}

class _MediaPage extends StatefulWidget {
  const _MediaPage({Key? key}) : super(key: key);

  @override
  State<_MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<_MediaPage> with Printable {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void dispose() {
    log("Disposing MediaPage");
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  bool _creating = false;
  Future<void> createVideoController(String url) async {
    if (_creating) return;
    _creating = true;
    log("Creating video controller...");
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
    final cubit = context.watch<MediaCubit>();
    final state = cubit.state;
    final media = state.media;
    return BlocListener<MediaCubit, MediaState>(
      listener: (context, state) {
        if (state.failure != null) {
          buildAppSnackBar(context,
              message: "${state.failure}",
              icon: const Icon(Icons.error),
              isFailure: true);
          Navigator.of(context).pop();
        }
        if (state.mainVideoUrl != null) {
          createVideoController(state.mainVideoUrl!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Download do vídeo"),
        ),
        body: state.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : media == null
                ? Container()
                : SafeArea(
                    bottom: false,
                    child: ListView(
                      padding: SharedConfigs.padding,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _chewieController != null
                              ? Chewie(controller: _chewieController!)
                              : const CupertinoActivityIndicator(),
                        ),
                        const AppSpacer(bigSpace: true),
                        Text(
                          media.videoName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const AppSpacer(),
                        Text(media.description),
                        const AppSpacer(bigSpace: true),
                        DownloadWidget(id: media.id!),
                        const AppSpacer(bigSpace: true),
                        MediasBuilder(
                          medias: state.medias,
                          onTap: (id) {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutes.media.path,
                              arguments: MediaPageProps(id: id),
                            );
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

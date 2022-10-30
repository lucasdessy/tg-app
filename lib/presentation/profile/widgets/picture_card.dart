import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/picture_view_model.dart';

import '../../../application/user/profile_medias_cubit.dart';
import '../../shared/config.dart';

class PictureCard extends StatelessWidget {
  final PictureViewModel picture;
  const PictureCard({required this.picture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedPictures = context
        .select((ProfileMediasCubit cubit) => cubit.state.selectedPictures);
    final isEditMode =
        context.select((ProfileMediasCubit cubit) => cubit.state.isEditMode);
    final isThisSelected = selectedPictures.contains(picture.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          context.read<ProfileMediasCubit>().togglePicture(picture.id);
        },
        onLongPress: () {
          context.read<ProfileMediasCubit>().toggleEditMode(picture.id);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: SharedConfigs.colors.tertiary,
              ),
              child: CachedNetworkImage(
                imageUrl: picture.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
            IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: Colors.black.withOpacity(isThisSelected ? 0.5 : 0),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isEditMode ? 1 : 0,
                child: Row(
                  children: [
                    const Text(
                      "Selecionado",
                      style: TextStyle(fontSize: 11),
                    ),
                    Icon(
                      isThisSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/picture_view_model.dart';
import 'package:sales_platform_app/application/user/profile_medias_cubit.dart';
import 'package:sales_platform_app/presentation/profile/widgets/dotted_picture_container.dart';
import 'package:sales_platform_app/presentation/profile/widgets/picture_card.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/source_picker.dart';

class InstagramBuilder extends StatelessWidget {
  const InstagramBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PictureViewModel> pictures =
        context.select((ProfileMediasCubit cubit) => cubit.state.pictures);
    return GridView.builder(
      padding: SharedConfigs.padding,
      itemCount: pictures.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemBuilder: (context, index) {
        if (index == 0) {
          return DottedPictureContainer(onTap: () async {
            final cubit = context.read<ProfileMediasCubit>();
            final source = await buildSourcePicker(context);
            if (source != null) {
              cubit.uploadImage(source);
            }
          });
        }
        PictureViewModel? picture;

        picture = pictures[index - 1];
        return PictureCard(picture: picture);
      },
    );
  }
}

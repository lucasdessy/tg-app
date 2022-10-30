import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/domain/user/picture_model.dart';

part 'picture_view_model.freezed.dart';

@freezed
class PictureViewModel with _$PictureViewModel {
  const factory PictureViewModel({
    required String id,
    required String url,
  }) = _PictureViewModel;

  factory PictureViewModel.fromDomain(PictureModel picture) {
    return PictureViewModel(
      id: picture.id!,
      url: picture.url,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/auth/auth_cubit.dart' as _i28;
import 'application/auth/login/login_cubit.dart' as _i18;
import 'application/auth/login/reset_password/reset_password_cubit.dart'
    as _i22;
import 'application/home/home_cubit.dart' as _i13;
import 'application/media/download/download_cubit.dart' as _i29;
import 'application/media/media_cubit.dart' as _i31;
import 'application/media/medias_cubit.dart' as _i21;
import 'application/training/training_cubit.dart' as _i33;
import 'application/training/trainings_cubit.dart' as _i25;
import 'application/user/change_password/change_password_cubit.dart' as _i8;
import 'application/user/edit_profile/edit_profile_cubit.dart' as _i30;
import 'application/user/profile_medias_cubit.dart' as _i32;
import 'application/user/user_cubit.dart' as _i34;
import 'domain/analytics/analytics_service.dart' as _i3;
import 'domain/auth/auth_service.dart' as _i6;
import 'domain/download/download_service.dart' as _i9;
import 'domain/global/global_service.dart' as _i11;
import 'domain/image/image_service.dart' as _i14;
import 'domain/media/media_service.dart' as _i19;
import 'domain/training/training_service.dart' as _i23;
import 'domain/user/insta_service.dart' as _i16;
import 'domain/user/user_service.dart' as _i26;
import 'infrastructure/analytics/analytics_service.dart' as _i4;
import 'infrastructure/auth/auth_service.dart' as _i7;
import 'infrastructure/download/download_service.dart' as _i10;
import 'infrastructure/global/global_service.dart' as _i12;
import 'infrastructure/image/image_service.dart' as _i15;
import 'infrastructure/media/media_service.dart' as _i20;
import 'infrastructure/training/training_service.dart' as _i24;
import 'infrastructure/user/insta_service.dart' as _i17;
import 'infrastructure/user/user_service.dart' as _i27;
import 'presentation/app/router.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AnalyticsService>(_i4.AnalyticsServiceImpl());
  gh.singleton<_i5.AppRouter>(_i5.AppRouter(get<_i3.AnalyticsService>()));
  gh.singleton<_i6.AuthService>(_i7.AuthServiceImpl());
  gh.factory<_i8.ChangePasswordCubit>(() => _i8.ChangePasswordCubit(
      get<_i3.AnalyticsService>(), get<_i6.AuthService>()));
  gh.singleton<_i9.DownloadService>(_i10.DownloadServiceImpl());
  gh.singleton<_i11.GlobalService>(_i12.GlobalServiceImpl());
  gh.factory<_i13.HomeCubit>(() => _i13.HomeCubit(get<_i3.AnalyticsService>()));
  gh.singleton<_i14.ImageService>(_i15.ImageServiceImpl());
  gh.singleton<_i16.InstaService>(_i17.InstaServiceImpl());
  gh.factory<_i18.LoginCubit>(() =>
      _i18.LoginCubit(get<_i3.AnalyticsService>(), get<_i6.AuthService>()));
  gh.singleton<_i19.MediaService>(_i20.MediaServiceImpl());
  gh.factory<_i21.MediasCubit>(() => _i21.MediasCubit(
      get<_i3.AnalyticsService>(),
      get<_i19.MediaService>(),
      get<_i11.GlobalService>()));
  gh.factory<_i22.ResetPasswordCubit>(() => _i22.ResetPasswordCubit(
      get<_i3.AnalyticsService>(), get<_i6.AuthService>()));
  gh.singleton<_i23.TrainingService>(_i24.TrainingServiceImpl());
  gh.factory<_i25.TrainingsCubit>(() => _i25.TrainingsCubit(
      get<_i3.AnalyticsService>(), get<_i23.TrainingService>()));
  gh.singleton<_i26.UserService>(_i27.UserServiceImpl());
  gh.singleton<_i28.AuthCubit>(
      _i28.AuthCubit(get<_i3.AnalyticsService>(), get<_i6.AuthService>()));
  gh.factory<_i29.DownloadCubit>(() => _i29.DownloadCubit(
      get<_i3.AnalyticsService>(), get<_i9.DownloadService>()));
  gh.factory<_i30.EditProfileCubit>(() => _i30.EditProfileCubit(
      get<_i3.AnalyticsService>(),
      get<_i26.UserService>(),
      get<_i6.AuthService>(),
      get<_i14.ImageService>()));
  gh.factory<_i31.MediaCubit>(() =>
      _i31.MediaCubit(get<_i3.AnalyticsService>(), get<_i19.MediaService>()));
  gh.factory<_i32.ProfileMediasCubit>(() => _i32.ProfileMediasCubit(
      get<_i3.AnalyticsService>(),
      get<_i6.AuthService>(),
      get<_i26.UserService>(),
      get<_i16.InstaService>()));
  gh.factory<_i33.TrainingCubit>(() => _i33.TrainingCubit(
      get<_i3.AnalyticsService>(), get<_i23.TrainingService>()));
  gh.factory<_i34.UserCubit>(() => _i34.UserCubit(
      get<_i3.AnalyticsService>(),
      get<_i26.UserService>(),
      get<_i6.AuthService>(),
      get<_i11.GlobalService>()));
  return get;
}

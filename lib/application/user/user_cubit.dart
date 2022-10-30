import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/application/user/user_view_model.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/global/global_service.dart';
import 'package:sales_platform_app/domain/user/user_model.dart';
import 'package:sales_platform_app/domain/user/user_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/global/link_enum.dart';

part 'user_cubit.freezed.dart';
part 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> with Printable {
  final AnalyticsService _analyticsService;
  final UserService _userService;
  final AuthService _authService;
  final GlobalService _globalService;
  late final StreamSubscription _userSubscription;
  UserCubit(this._analyticsService, this._userService, this._authService,
      this._globalService)
      : super(const UserState()) {
    _userSubscription = _userService.userStream.listen(userListener);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  void userListener(UserModel? user) {
    log('userListener: $user');
    if (user == null) {
      emit(const UserState());
      return;
    }
    emit(state.copyWith(
        user: UserViewModel.fromDomain(user,
            email: _authService.currentUser!.email)));
  }

  Future<void> getUser() async {
    emit(state.copyWith(loading: true));
    log('getting user...');
    try {
      final user = await _userService.getUser(_authService.currentUser!.uid);
      log(user);
      await _getLinks();
      emit(state.copyWith(
          user: UserViewModel.fromDomain(user,
              email: _authService.currentUser!.email),
          loading: false));
    } catch (e, stack) {
      log(e);
      emit(state.copyWith(error: e.toString(), loading: false));
      _analyticsService.registerError(e, stack);
    }
  }

  Future<void> _getLinks() async {
    try {
      log('getting telegram link...');
      final telLink = await _globalService.getLink(LinkType.telegram);
      emit(state.copyWith(
        telegramLink: telLink,
      ));
      log('Telegram Link is $telLink');
      final whatsappHelpLink =
          await _globalService.getLink(LinkType.whatsappHelp);
      log('Whatsapp Help Link is $whatsappHelpLink');
      emit(state.copyWith(helpLink: whatsappHelpLink));
    } catch (e, stack) {
      log(e);
      emit(state.copyWith(error: e.toString()));
      _analyticsService.registerError(e, stack);
    }
  }

  Future<void> onHelpCenterClick() async {
    final whatsAppHelpLink = state.helpLink;
    log("Whatsapp link: $whatsAppHelpLink");

    if (whatsAppHelpLink != null) {
      final uri = Uri.parse(whatsAppHelpLink);
      if (await canLaunchUrl(uri)) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
        log('Launching whatsapp link...');
        _analyticsService.registerClickedLinkEvent(LinkType.whatsappHelp);
      } else {
        log('Cannot launch whatsapp link');
      }
    } else {
      log('Link is null');
    }
  }

  Future<void> onTelegramClick() async {
    final telegramLink = state.telegramLink;
    log("Telegram link: $telegramLink");

    if (telegramLink != null) {
      final uri = Uri.parse(telegramLink);
      if (await canLaunchUrl(uri)) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
        log('Launching telegram link...');
        _analyticsService.registerClickedLinkEvent(LinkType.telegram);
      } else {
        log('Cannot launch telegram link');
      }
    } else {
      log('Link is null');
    }
  }
}

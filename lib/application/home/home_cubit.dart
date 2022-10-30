import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AnalyticsService _analyticsService;
  HomeCubit(this._analyticsService) : super(const HomeState.initial());

  void onHighlightCardTapped() {
    _analyticsService.registerHighlightCardEvent();
  }
}

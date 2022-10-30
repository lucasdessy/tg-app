import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/download/download_type.dart';
import 'package:sales_platform_app/domain/global/link_enum.dart';
import 'package:sales_platform_app/domain/util/print.dart';

@Singleton(as: AnalyticsService)
class AnalyticsServiceImpl with Printable implements AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;
  final _crashAnalytics = FirebaseCrashlytics.instance;

  AnalyticsServiceImpl() {
    log("Analytics Service created!");
  }

  // Home
  @override
  Future<void> registerHighlightCardEvent() async {
    await _analytics.logEvent(name: 'highlight_card');
    log("Highlight Card Event Registered");
  }

  // Auth
  @override
  Future<void> registerLoginEvent() async {
    await _analytics.logLogin();
    log("Login Event Registered");
  }

  @override
  Future<void> registerLogoutEvent() async {
    await _analytics.logEvent(name: 'logout');
    log("Logout Event Registered");
  }

  @override
  Future<void> registerChangePasswordEvent() async {
    await _analytics.logEvent(name: 'reset_password');
    log("Reset Password Event Registered");
  }

  @override
  Future<void> registerResetPasswordEvent() async {
    await _analytics.logEvent(name: 'forgot_password');
    log("Forgot Password Event Registered");
  }

  // Training
  @override
  Future<void> registerTrainingClickedEvent(String trainingName) async {
    await _analytics.logEvent(name: 'training_clicked', parameters: {
      'training_name': trainingName,
    });
    log("Training Clicked Event Registered");
  }

  @override
  Future<void> registerTrainingCategoryEvent(String categoryName) async {
    await _analytics.logEvent(
        name: 'training_category', parameters: {'category_name': categoryName});
    log("Training Category Event Registered");
  }

  // Media
  @override
  Future<void> registerMediaClickedEvent(String mediaName) async {
    await _analytics.logEvent(name: 'media_clicked', parameters: {
      'media_name': mediaName,
    });
    log("Media Viewed Event Registered");
  }

  @override
  Future<void> registerDownloadedMediaEvent(DownloadType downloadType) async {
    await _analytics.logEvent(
        name: 'downloaded_media',
        parameters: {'download_type': downloadType.toString()});
    log("Downloaded Media Event Registered");
  }

  // User
  @override
  Future<void> registerEditPersonalInfoEvent() async {
    await _analytics.logEvent(name: 'edit_personal_info');
    log("Edit Personal Info Event Registered");
  }

  @override
  Future<void> registerGridPhotoUploadEvent() async {
    await _analytics.logEvent(name: 'grid_photo_upload');
    log("Grid Photo Upload Event Registered");
  }

  @override
  Future<void> registerGridPhotoDeleteEvent() async {
    await _analytics.logEvent(name: 'grid_photo_delete');
    log("Grid Photo Delete Event Registered");
  }

  @override
  Future<void> registerGridPhotoDownloadEvent() async {
    await _analytics.logEvent(name: 'grid_photo_download');
    log("Grid Photo Download Event Registered");
  }

  @override
  Future<void> registerClickedLinkEvent(LinkType linkType) async {
    await _analytics.logEvent(
        name: 'clicked_link', parameters: {'link_type': linkType.toString()});
    log("Clicked Link Event Registered");
  }

  // General
  @override
  Future<void> registerPageNavigateEvent(String pageName) async {
    await _analytics.logScreenView(screenName: pageName);
    log("Page Navigate Event Registered");
  }

  @override
  Future<void> registerError(dynamic error, StackTrace? stack) async {
    _crashAnalytics.recordError(error, stack);
    log("Error Event Registered");
  }

  @override
  Future<void> registerAppOpen() async {
    await _analytics.logAppOpen();
    log("App Open Event Registered");
  }
}

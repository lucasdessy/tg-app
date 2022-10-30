import 'package:sales_platform_app/domain/download/download_type.dart';
import 'package:sales_platform_app/domain/global/link_enum.dart';

abstract class AnalyticsService {
  // Home
  Future<void> registerHighlightCardEvent();
  // Auth
  Future<void> registerLoginEvent();
  Future<void> registerLogoutEvent();
  Future<void> registerChangePasswordEvent();
  Future<void> registerResetPasswordEvent();
  // Training
  Future<void> registerTrainingClickedEvent(String trainingName);
  Future<void> registerTrainingCategoryEvent(String categoryName);
  // Media
  Future<void> registerMediaClickedEvent(String mediaName);
  Future<void> registerDownloadedMediaEvent(DownloadType downloadType);
  // User
  Future<void> registerEditPersonalInfoEvent();
  Future<void> registerGridPhotoUploadEvent();
  Future<void> registerGridPhotoDeleteEvent();
  Future<void> registerGridPhotoDownloadEvent();
  Future<void> registerClickedLinkEvent(LinkType linkType);
  // General
  Future<void> registerPageNavigateEvent(String pageName);
  Future<void> registerError(dynamic error, StackTrace? stack);
  Future<void> registerAppOpen();
}

import 'package:sales_platform_app/domain/download/download_state.dart';
import 'package:sales_platform_app/domain/download/download_type.dart';

abstract class DownloadService {
  Stream<DownloadState> download(String id, DownloadType type);
}

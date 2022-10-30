import 'package:sales_platform_app/domain/global/link_enum.dart';

abstract class GlobalService {
  Future<String> getLink(LinkType linkType);
  Future<String> getMediaHeaderUrl();
  Future<String> getProductHeaderUrl();
}

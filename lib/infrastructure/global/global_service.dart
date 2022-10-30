import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/global/link_enum.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/global/global_service.dart';

@Singleton(as: GlobalService)
class GlobalServiceImpl with Printable implements GlobalService {
  final globalRef =
      FirebaseFirestore.instance.collection("settings").doc("global");
  @override
  Future<String> getLink(LinkType linkType) async {
    try {
      late String link;
      switch (linkType) {
        case LinkType.telegram:
          link = (await globalRef.get()).data()!["telegramUrl"];
          break;
        case LinkType.whatsappHelp:
          link = (await globalRef.get()).data()!["whatsappHelpUrl"];
          break;
      }
      return link;
    } catch (e) {
      log(e);
      throw AppFailure("Ocorreu um erro ao tentar obter o link");
    }
  }

  @override
  Future<String> getMediaHeaderUrl() async {
    try {
      String link = (await globalRef.get()).data()!["mediaHeaderUrl"];
      return link;
    } catch (e) {
      log(e);
      throw AppFailure("Ocorreu um erro ao tentar obter o link");
    }
  }

  @override
  Future<String> getProductHeaderUrl() async {
    try {
      String link = (await globalRef.get()).data()!["productsHeaderUrl"];
      return link;
    } catch (e) {
      log(e);
      throw AppFailure("Ocorreu um erro ao tentar obter o link");
    }
  }
}

///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'ranking_class';

class RankingClass extends MGRequest<Model.LogCharacter> {
  RankingClass._(String region, Map<String, dynamic> parameters)
      : super(_endpoint, parameters..['region'] = region);

  factory RankingClass(String region, int playerRole, int zoneId, int bossId, int version,
      [String server, bool multiHeal = false, multiTank = false, int typeTank, int typeHeal, String span]) {
    return RankingClass._(region, {
      'zone': zoneId,
      'boss': bossId,
      'ver': version,
      'role': playerRole,
      if (server != null) 'server': server,
      if (multiHeal) 'mheal': 1,
      if (multiTank) 'mtank': 1,
      if (typeTank != null) 'ttank': typeTank,
      if (typeHeal != null) 'theal': typeHeal,
      if (span != null) 'span': span,
    });
  }

  factory RankingClass.fromBoss(String region, int playerRole, Model.Boss boss,
      [String server, bool multiHeal = false, multiTank = false, int typeTank, int typeHeal, String span]) {
    return RankingClass(
      region,
      playerRole,
      boss.zoneId,
      boss.bossId,
      boss.version,
      server,
      multiHeal,
      multiTank,
      typeTank,
      typeHeal,
      span,
    );
  }

  @override
  List<Model.LogCharacter> parseResponseJson(List<dynamic> responseJson) {
    return responseJson.map((e) => Model.LogCharacter.fromJson(e)).toList();
  }
}

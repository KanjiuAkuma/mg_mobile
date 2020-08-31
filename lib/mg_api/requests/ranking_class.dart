///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'ranking_class';

class RankingClass extends MgRequest<Model.LogCharacter> {
  final String region, clazz, server, span;
  final Model.Boss boss;
  final int playerRole, typeTank, typeHeal;
  final bool multiHeal, multiTank;

  RankingClass._(this.region, this.clazz, this.playerRole, this.boss, this.server, this.multiHeal, this.multiTank,
      this.typeTank, this.typeHeal, this.span)
      : super(_endpoint, {
          'region': region,
          'role': playerRole,
          if (boss != null) 'ver': boss.version,
          if (boss != null) 'zone': boss.zoneId,
          if (boss != null) 'boss': boss.bossId,
          if (server != null) 'server': server,
          if (multiHeal) 'mheal': 1,
          if (multiTank) 'mtank': 1,
          if (typeTank != null) 'ttank': typeTank,
          if (typeHeal != null) 'theal': typeHeal,
          if (span != null) 'span': span,
        });

  factory RankingClass(String region, String clazz, int playerRole, int version, String zoneId, String bossId,
      [String server, bool multiHeal = false, multiTank = false, int typeTank, int typeHeal, String span]) {
    if (zoneId == null || bossId == null || version == null) {
      assert(zoneId == null && bossId == null && version == null, 'Only one of zoneId, bossId, version is set');
    }
    return RankingClass._(
      region,
      clazz,
      playerRole,
      zoneId != null ? Model.Boss(version, zoneId, bossId) : null,
      server,
      multiHeal,
      multiTank,
      typeTank,
      typeHeal,
      span,
    );
  }

  factory RankingClass.fromBoss(String region, String clazz, int playerRole, Model.Boss boss,
      [String server, bool multiHeal = false, multiTank = false, int typeTank, int typeHeal, String span]) {
    return RankingClass._(
      region,
      clazz,
      playerRole,
      boss,
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
    List<Model.LogCharacter> logs = responseJson.map((e) => Model.LogCharacter.fromJsonAndBoss(boss, e)).toList();
    if (clazz == null) {
      // no class filter set
      return logs;
    } else {
      // filter by class
      return logs.where((l) => l.character.clazz == clazz).toList();
    }
  }
}

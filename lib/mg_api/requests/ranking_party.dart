///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'ranking_party';

class RankingParty extends MgRequest<Model.LogParty> {
  final String region, server, span;
  final Model.Boss boss;
  final bool multiHeal, multiTank;

  RankingParty._(this.region, this.boss, this.server, this.multiHeal, this.multiTank, this.span)
      : super(_endpoint, {
          'region': region,
          'ver': boss.version,
          'zone': boss.zoneId,
          'boss': boss.bossId,
          if (server != null) 'server': server,
          if (multiHeal) 'mheal': 1,
          if (multiTank) 'mtank': 1,
          if (span != null) 'span': span,
        });

  factory RankingParty(String region, int version, String zoneId, String bossId,
      [String server, bool multiHeal = false, multiTank = false, String span]) {
    assert(version != null && zoneId != null && bossId != null, 'Boss must be given');
    return RankingParty._(region, Model.Boss(version, zoneId, bossId), server, multiHeal, multiTank, span);
  }

  factory RankingParty.fromBoss(String region, Model.Boss boss,
      [String server, bool multiHeal = false, multiTank = false, String span]) {
    return RankingParty._(region, boss, server, multiHeal, multiTank, span);
  }

  @override
  List<Model.LogParty> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length) {
      print('Warning: No results returned for $this');
      return [];
    }

    List<Model.LogParty> rankings = [];

    // parse party batches
    String logId = responseJson[0]['logId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (logId != entry['logId']) {
        rankings.add(Model.LogParty.fromJsonAndBoss(boss, entries));
        logId = entry['logId'];
        entries = [];
      }

      entries.add(responseJson[i]);
    }

    // append last batch
    if (0 < entries.length) {
      rankings.add(Model.LogParty.fromJsonAndBoss(boss, entries));
    }

    return rankings;
  }
}

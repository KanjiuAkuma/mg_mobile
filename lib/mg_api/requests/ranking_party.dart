///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'ranking_party';

class RankingParty extends MgRequest<Model.LogParty> {
  RankingParty._(String region, Map<String, dynamic> parameters) : super(_endpoint, parameters..['region'] = region);

  factory RankingParty(String region, int version, String zoneId, String bossId,
      [String server, bool multiHeal = false, multiTank = false, String span]) {
    return RankingParty._(region, {
      'zone': zoneId,
      'boss': bossId,
      'ver': version,
      if (server != null) 'server': server,
      if (multiHeal) 'mheal': 1,
      if (multiTank) 'mtank': 1,
      if (span != null) 'span': span,
    });
  }

  factory RankingParty.fromBoss(String region, Model.Boss boss,
      [String server, bool multiHeal = false, multiTank = false, String span]) {
    return RankingParty(region, boss.version, boss.zoneId, boss.bossId, server, multiHeal, multiTank, span);
  }

  @override
  List<Model.LogParty> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length) {
      print('Warning: No results returned for $this');
      return [];
    }

    List<Model.LogParty> logs = [];

    // parse party batches
    String logId = responseJson[0]['logId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (logId != entry ['logId']) {
        logs.add(Model.LogParty.fromJson(entries));
        logId = entry['logId'];
        entries = [];
      }

      entries.add(responseJson[i]);
    }

    // append last batch
    if (0 < entries.length) {
      logs.add(Model.LogParty.fromJson(entries));
    }

    return logs;
  }

}
///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'ranking_party';

class RankingParty extends MgRequest<Model.LogParty> {
  final String region, server, span;
  final Model.Boss boss;
  final bool multiHeal, multiTank;

  RankingParty._(this.region, this.boss, this.server, this.multiHeal, this.multiTank, this.span)
      : super(region, _endpoint, {
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
  MgResponse<Model.LogParty> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData) {
    if (0 == jsonData.length) {
      print('Warning: No results returned for $this');
      return MgResponse<Model.LogParty>(
        this,
        status,
        rawResponse,
        [],
      );
    }

    List<Model.LogParty> rankings = [];

    // parse party batches
    String logId = jsonData[0]['logId'];
    List<Map<String, dynamic>> entries = [jsonData[0]];

    for (int i = 1; i < jsonData.length; i++) {
      Map<String, dynamic> entry = jsonData[i];

      if (logId != entry['logId']) {
        rankings.add(Model.LogParty.fromJsonAndBoss(boss, entries));
        logId = entry['logId'];
        entries = [];
      }

      entries.add(jsonData[i]);
    }

    // append last batch
    if (0 < entries.length) {
      rankings.add(Model.LogParty.fromJsonAndBoss(boss, entries));
    }

    return MgResponse<Model.LogParty>(
      this,
      status,
      rawResponse,
      rankings,
    );
  }
}

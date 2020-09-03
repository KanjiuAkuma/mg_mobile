///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../../models/models.dart' as Model;

final String _endpoint = 'ranking_clears';

class RankingClears<T> extends MgRequest<T> {
  final Model.Boss boss;
  final String server;

  RankingClears(String region, int version, String zoneId, String bossId, this.server, bool chars)
      : boss = Model.Boss(version, zoneId, bossId),
        super(region, _endpoint, {
          'region': region,
          'zone': zoneId,
          'boss': bossId,
          'ver': version,
          if (server != null) 'server': server,
          if (chars) 'char': 0,
        });

  RankingClears.fromBoss(String region, Model.Boss boss, this.server, bool chars) :
      boss = boss,
      super(region, _endpoint, {
        'region': region,
        'zone': boss.zoneId,
        'boss': boss.bossId,
        'ver': boss.version,
        if (server != null) 'server': server,
        if (chars) 'char': 0,
      });
}

class RankingClearsAccount extends RankingClears<Model.RankingAccount> {

  RankingClearsAccount(String region, int version, String zoneId, String bossId, [String server])
    : super(region, version, zoneId, bossId, server, false);

  RankingClearsAccount.fromBoss(String region, Model.Boss boss, [String server])
    : super.fromBoss(region, boss, server, false);

  @override
  List<Model.RankingAccount> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length) {
      print('Warning: No results returned for $this');
      return [];
    }

    List<Model.RankingAccount> ranking = [];

    // parse user batches
    String userId = responseJson[0]['userId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (userId != entry ['userId']) {
        ranking.add(Model.RankingAccount.fromJson(ranking.length + 1, entries));
        userId = entry['userId'];
        entries = [];
      }

      entries.add(responseJson[i]);
    }

    // append last batch
    if (0 < entries.length) {
      ranking.add(Model.RankingAccount.fromJson(ranking.length + 1, entries));
    }

    return ranking;
  }
}

class RankingClearsCharacters extends RankingClears<Model.RankingCharacter> {

  RankingClearsCharacters(String region, int version, String zoneId, String bossId, [String server])
      : super(region, version, zoneId, bossId, server, true);

  RankingClearsCharacters.fromBoss(String region, Model.Boss boss, [String server])
      : super.fromBoss(region, boss, server, true);

  @override
  List<Model.RankingCharacter> parseResponseJson(List<dynamic> responseJson) {
    List<Model.RankingCharacter> ranking = [];
    for (int i = 0; i < responseJson.length; i++) {
      ranking.add(Model.RankingCharacter.fromJson(i + 1, responseJson[i]));
    }
    return ranking;
  }

}
